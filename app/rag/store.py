import json
import re
import uuid
from dataclasses import dataclass

import chromadb
from chromadb.utils import embedding_functions

from app.config import DATA_DIR, SMALL_DOC_CHARS

_chroma_client = chromadb.PersistentClient(path=str(DATA_DIR / "chroma"))
_embed_fn = embedding_functions.DefaultEmbeddingFunction()


def _safe_collection_name(session_id: str) -> str:
    safe = re.sub(r"[^a-zA-Z0-9_-]", "_", session_id)[:60]
    return f"session_{safe or 'default'}"


def _tokenize(text: str) -> set[str]:
    return set(re.findall(r"[a-z0-9]+", text.lower()))


@dataclass
class DocumentChunk:
    id: str
    source: str
    text: str


class SessionStore:
    def __init__(self, session_id: str):
        self.session_id = session_id
        self.collection_name = _safe_collection_name(session_id)
        self.collection = _chroma_client.get_or_create_collection(
            name=self.collection_name,
            embedding_function=_embed_fn,
            metadata={"hnsw:space": "cosine"},
        )
        self.stats_path = DATA_DIR / "sessions" / session_id / "stats.json"
        self.stats_path.parent.mkdir(parents=True, exist_ok=True)
        self.file_stats: dict[str, int] = self._load_stats()

    def _load_stats(self) -> dict[str, int]:
        if not self.stats_path.exists():
            return {}
        return json.loads(self.stats_path.read_text())

    def _save_stats(self) -> None:
        self.stats_path.write_text(json.dumps(self.file_stats))

    def add_document(self, source: str, chunks: list[str], row_count: int | None = None) -> int:
        if not chunks:
            return 0

        if row_count is not None:
            self.file_stats[source] = row_count
            self._save_stats()

        ids = [str(uuid.uuid4()) for _ in chunks]
        metadatas = [{"source": source} for _ in chunks]
        self.collection.add(ids=ids, documents=chunks, metadatas=metadatas)
        return len(chunks)

    def get_total_row_count(self) -> int:
        return sum(self.file_stats.values())

    def get_all_records(self) -> list[dict[str, str]]:
        records: list[dict[str, str]] = []
        seen: set[str] = set()

        for chunk in self._all_chunks():
            for line in chunk.text.splitlines():
                line = line.strip()
                if not line or line.startswith("Columns:"):
                    continue
                if line in seen:
                    continue
                seen.add(line)

                record: dict[str, str] = {}
                for part in line.split(","):
                    part = part.strip()
                    if "=" in part:
                        key, value = part.split("=", 1)
                        record[key.strip().lower()] = value.strip()
                if record:
                    records.append(record)

        return records

    def _all_chunks(self) -> list[DocumentChunk]:
        if self.collection.count() == 0:
            return []
        result = self.collection.get(include=["documents", "metadatas"])
        return [
            DocumentChunk(id=doc_id, source=meta.get("source", "unknown"), text=text)
            for doc_id, text, meta in zip(
                result["ids"], result["documents"], result["metadatas"]
            )
        ]

    def _keyword_search(self, query: str, top_k: int) -> list[DocumentChunk]:
        query_tokens = _tokenize(query)
        if not query_tokens:
            return []

        scored: list[tuple[int, DocumentChunk]] = []
        for chunk in self._all_chunks():
            text_tokens = _tokenize(chunk.text)
            overlap = len(query_tokens & text_tokens)
            if overlap:
                scored.append((overlap, chunk))

        scored.sort(key=lambda item: item[0], reverse=True)
        return [chunk for _, chunk in scored[:top_k]]

    def search(self, query: str, top_k: int = 10) -> list[DocumentChunk]:
        if self.collection.count() == 0:
            return []

        all_chunks = self._all_chunks()
        total_chars = sum(len(c.text) for c in all_chunks)
        if total_chars <= SMALL_DOC_CHARS:
            return all_chunks

        results = self.collection.query(
            query_texts=[query],
            n_results=min(top_k, self.collection.count()),
            include=["documents", "metadatas"],
        )

        semantic: list[DocumentChunk] = []
        documents = results["documents"][0]
        metadatas = results["metadatas"][0]
        ids = results["ids"][0]

        for doc_id, text, meta in zip(ids, documents, metadatas):
            semantic.append(
                DocumentChunk(
                    id=doc_id,
                    source=meta.get("source", "unknown"),
                    text=text,
                )
            )

        keyword = self._keyword_search(query, top_k)
        merged: dict[str, DocumentChunk] = {}
        for chunk in keyword + semantic:
            merged[chunk.id] = chunk
        return list(merged.values())[:top_k]


_stores: dict[str, SessionStore] = {}


def get_store(session_id: str) -> SessionStore:
    if session_id not in _stores:
        _stores[session_id] = SessionStore(session_id)
    return _stores[session_id]
