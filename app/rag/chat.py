import re

from openai import APIError

from app.ai.client import check_ollama, get_chat_client
from app.config import OLLAMA_CHAT_MODEL, TOP_K
from app.rag.store import DocumentChunk, SessionStore

COUNT_QUESTION = re.compile(
    r"\b(how many|how much|count|total number|number of)\b",
    re.IGNORECASE,
)

STARTS_WITH_LETTER = re.compile(
    r"start(?:s)?\s+with\s+(?:the\s+letter\s+)?['\"]?([a-zA-Z])",
    re.IGNORECASE,
)

FILTER_SIGNALS = (
    "start with",
    "starts with",
    "begin with",
    "begins with",
    "named",
    "called",
    "whose",
    "where",
    "with the letter",
    "contain",
    "includes",
    "older",
    "younger",
    "greater",
    "less than",
    "between",
    "department",
    "city",
    "from the",
    "in the",
    "equal",
    "more than",
    "fewer than",
)

SYSTEM_PROMPT = """You answer questions using ONLY the provided document context.
Rules:
- Use exact values from the context. Do not guess or invent numbers.
- Excerpts labeled [1], [2], etc. may be PARTS of the SAME file. Never add row counts from multiple excerpts together.
- If a SUMMARY line is provided, use those totals only for whole-file counts, not filtered counts.
- If the context does not contain the answer, say: "I don't have enough information in the uploaded file."
- Keep answers short."""


def _find_name_field(records: list[dict[str, str]]) -> str | None:
    if not records:
        return None
    for key in records[0]:
        if "name" in key:
            return key
    return None


def try_filtered_count(store: SessionStore, question: str) -> str | None:
    if not COUNT_QUESTION.search(question):
        return None

    letter_match = STARTS_WITH_LETTER.search(question)
    if not letter_match:
        return None

    letter = letter_match.group(1).lower()
    records = store.get_all_records()
    name_key = _find_name_field(records)
    if not name_key:
        return None

    matches = [
        record[name_key]
        for record in records
        if record.get(name_key, "").lower().startswith(letter)
    ]

    if not matches:
        return f"0 people have names starting with '{letter.upper()}'."

    if len(matches) <= 8:
        names = ", ".join(matches)
        return f"{len(matches)} people have names starting with '{letter.upper()}': {names}."
    preview = ", ".join(matches[:5])
    return (
        f"{len(matches)} people have names starting with '{letter.upper()}' "
        f"(e.g. {preview}, ...)."
    )


def try_count_answer(store: SessionStore, question: str) -> str | None:
    if not COUNT_QUESTION.search(question):
        return None

    q = question.lower()
    if any(signal in q for signal in FILTER_SIGNALS):
        return None

    total = store.get_total_row_count()
    if total <= 0:
        return None

    files = store.file_stats
    if len(files) == 1:
        filename = next(iter(files))
        return f"There are {total} records in {filename}."
    parts = [f"{name}: {count}" for name, count in files.items()]
    return f"Total records across uploaded files: {total} ({'; '.join(parts)})."


def build_context(store: SessionStore, chunks: list[DocumentChunk]) -> str:
    if not chunks:
        return ""

    parts: list[str] = []
    total_rows = store.get_total_row_count()
    if total_rows > 0:
        files = ", ".join(f"{name} ({count} records)" for name, count in store.file_stats.items())
        parts.append(f"SUMMARY: The uploaded data contains {total_rows} total records across: {files}.")
        parts.append("NOTE: Excerpts below are chunks from the same file(s). Do NOT sum rows across excerpts.")

    sources = {chunk.source for chunk in chunks}
    for index, chunk in enumerate(chunks, start=1):
        parts.append(f"[{index}] Excerpt from {chunk.source}:\n{chunk.text}")

    if len(sources) == 1 and len(chunks) > 1:
        parts.insert(1, f"All {len(chunks)} excerpts below are from the same file: {next(iter(sources))}.")

    return "\n\n".join(parts)


def stream_answer(store: SessionStore, question: str, history: list[dict]):
    ollama_error = check_ollama()
    if ollama_error:
        yield f"Error: {ollama_error}"
        return

    filtered_answer = try_filtered_count(store, question)
    if filtered_answer:
        yield filtered_answer
        return

    count_answer = try_count_answer(store, question)
    if count_answer:
        yield count_answer
        return

    relevant = store.search(question, top_k=TOP_K)
    context = build_context(store, relevant)

    if not context:
        yield "Upload a document first, then ask questions about its contents."
        return

    client = get_chat_client()
    messages = [{"role": "system", "content": SYSTEM_PROMPT}]
    for message in history[-6:]:
        messages.append({"role": message["role"], "content": message["content"]})
    messages.append(
        {
            "role": "user",
            "content": f"Context from uploaded documents:\n\n{context}\n\nQuestion: {question}",
        }
    )

    try:
        stream = client.chat.completions.create(
            model=OLLAMA_CHAT_MODEL,
            messages=messages,
            stream=True,
            temperature=0,
        )
        for chunk in stream:
            delta = chunk.choices[0].delta.content
            if delta:
                yield delta
    except APIError as exc:
        yield f"Error: {exc.message}"
