# AGENTS.md

## Cursor Cloud specific instructions

### What this is
A single FastAPI service ("Data Chatbot"): a RAG + rule-based analytics chatbot that
answers natural-language questions about a tabular data file. Backend is in `app/`,
the browser UI is the static files in `static/`.

### Running (dev)
- Always work inside the virtualenv: `source .venv/bin/activate` (the update script
  creates/refreshes `.venv`).
- Dev server (hot reload): `uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload`.
- Open `http://localhost:8000/` for the chat UI; API is `POST /api/chat` and
  `GET /api/data`.

### Non-obvious gotchas
- **No LLM is required for normal use.** The rule-based analytics engine
  (`app/analytics/engine.py`) answers most questions (counts, averages, sorting,
  person lookup, charts) with zero external calls. An LLM (Ollama by default, see
  `app/ai/client.py` / `app/analytics/planner.py`) is only an *optional* fallback;
  `/api/chat` only hard-fails on a missing LLM when no data is loaded. There is no
  Ollama server in this environment, so the LLM-backed `try_planned_answer` /
  RAG-chat paths simply no-op — this is expected, not a bug.
- **First startup downloads an embedding model.** On first run, ChromaDB
  (`app/rag/store.py`) downloads the `all-MiniLM-L6-v2` ONNX model (~79MB) to
  `~/.cache/chroma`. This needs network access and adds a few seconds to the first
  startup; later startups are fast.
- **ChromaDB telemetry warnings are harmless.** Lines like
  `Failed to send telemetry event ... capture() takes 1 positional argument but 3
  were given` are a chromadb/posthog version mismatch and do not affect behavior.
- **Default data file is `data_source/employees.csv`** (see `app/config.py`).
  `.env.example` points `DATA_FILE` at `SampleData.numbers`; there is no committed
  `.env`, so the CSV is used by default. The app hot-reloads the data file when its
  mtime changes (next question triggers re-index).
- **`requirements.txt` originally pinned `numbers-parser==4.14.0`, which does not
  exist on PyPI** (versions jump 4.13.3 -> 4.14.1). It is pinned to `4.14.1` so the
  environment installs. `numbers-parser` is only used to read `.numbers` files but is
  imported at module load in `app/data_loader.py`, so it must be installable.
- The `app/auth/` package is present but currently unused by `app/main.py`.
