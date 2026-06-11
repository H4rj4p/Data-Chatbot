from pathlib import Path

from fastapi import FastAPI, File, Header, HTTPException, UploadFile
from fastapi.responses import FileResponse, StreamingResponse
from fastapi.staticfiles import StaticFiles
from openai import APIError
from pydantic import BaseModel

from app.ai.client import check_ollama
from app.config import ALLOWED_EXTENSIONS, MAX_UPLOAD_BYTES
from app.rag.chat import stream_answer
from app.rag.ingest import chunk_text, extract_document
from app.rag.store import get_store

STATIC_DIR = Path(__file__).resolve().parent.parent / "static"

app = FastAPI(title="Data Chatbot")
app.mount("/static", StaticFiles(directory=STATIC_DIR), name="static")


class ChatRequest(BaseModel):
    message: str
    history: list[dict] = []


@app.get("/")
async def index():
    return FileResponse(STATIC_DIR / "index.html")


@app.post("/api/upload")
async def upload_document(
    file: UploadFile = File(...),
    x_session_id: str = Header(default="default"),
):
    if not file.filename:
        raise HTTPException(status_code=400, detail="No filename provided")

    suffix = Path(file.filename or "").suffix.lower()
    content_type = file.content_type or ""
    if suffix not in ALLOWED_EXTENSIONS and "csv" not in content_type.lower():
        raise HTTPException(status_code=400, detail="Unsupported file type")

    content = await file.read()
    if len(content) > MAX_UPLOAD_BYTES:
        raise HTTPException(status_code=400, detail="File too large")

    try:
        doc = extract_document(file.filename or "upload.csv", content, content_type)
        is_csv = suffix == ".csv" or "csv" in content_type.lower()
        chunks = chunk_text(doc.text, is_csv=is_csv)
        if not chunks:
            raise HTTPException(status_code=400, detail="No readable text found")
        store = get_store(x_session_id)
        store.add_document(file.filename, chunks, row_count=doc.row_count)
    except ValueError as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc)) from exc

    return {"ok": True, "filename": file.filename}


@app.post("/api/chat")
async def chat(
    body: ChatRequest,
    x_session_id: str = Header(default="default"),
):
    if not body.message.strip():
        raise HTTPException(status_code=400, detail="Message cannot be empty")

    ollama_error = check_ollama()
    if ollama_error:
        raise HTTPException(status_code=503, detail=ollama_error)

    store = get_store(x_session_id)

    def event_stream():
        try:
            for token in stream_answer(store, body.message.strip(), body.history):
                yield token
        except APIError as exc:
            yield f"Error: {exc.message}"

    return StreamingResponse(event_stream(), media_type="text/plain")
