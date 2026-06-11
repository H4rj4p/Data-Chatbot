import re

from openai import APIError

from app.ai.client import check_ollama, get_chat_client
from app.config import OLLAMA_CHAT_MODEL, TOP_K
from app.rag.store import DocumentChunk, SessionStore

SYSTEM_PROMPT = """You answer questions using ONLY the provided document context.
Rules:
- Use exact values from the context. Do not guess or invent numbers.
- Excerpts may be parts of the same file. Never add row counts across excerpts.
- If the context does not contain the answer, say you don't have enough information.
- Keep answers short."""


def build_context(store: SessionStore, chunks: list[DocumentChunk]) -> str:
    if not chunks:
        return ""

    parts: list[str] = []
    total_rows = store.get_total_row_count()
    if total_rows > 0:
        files = ", ".join(f"{name} ({count} records)" for name, count in store.file_stats.items())
        parts.append(f"SUMMARY: {total_rows} total records in {files}.")

    for index, chunk in enumerate(chunks, start=1):
        parts.append(f"[{index}] Excerpt from {chunk.source}:\n{chunk.text}")

    return "\n\n".join(parts)


def answer_with_llm(store: SessionStore, question: str, history: list[dict]) -> str:
    ollama_error = check_ollama()
    if ollama_error:
        return f"Error: {ollama_error}"

    relevant = store.search(question, top_k=TOP_K)
    context = build_context(store, relevant)
    if not context:
        return "No data is loaded yet."

    client = get_chat_client()
    messages = [{"role": "system", "content": SYSTEM_PROMPT}]
    for message in history[-6:]:
        messages.append({"role": message["role"], "content": message["content"]})
    messages.append(
        {
            "role": "user",
            "content": f"Context:\n\n{context}\n\nQuestion: {question}",
        }
    )

    try:
        response = client.chat.completions.create(
            model=OLLAMA_CHAT_MODEL,
            messages=messages,
            stream=False,
            temperature=0,
        )
        return response.choices[0].message.content or "No answer generated."
    except APIError as exc:
        return f"Error: {exc.message}"
