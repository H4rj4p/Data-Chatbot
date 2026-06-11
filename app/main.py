from contextlib import asynccontextmanager
from pathlib import Path

from fastapi import FastAPI, HTTPException
from fastapi.responses import FileResponse
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel

from app.ai.client import check_ollama
from app.analytics.router import answer_question
from app.config import DATA_FILE
from app.data_loader import get_dataframe_info, load_data_on_startup, reload_data_if_changed

STATIC_DIR = Path(__file__).resolve().parent.parent / "static"


@asynccontextmanager
async def lifespan(_: FastAPI):
    load_data_on_startup()
    yield


app = FastAPI(title="Data Chatbot", lifespan=lifespan)
app.mount("/static", StaticFiles(directory=STATIC_DIR), name="static")


class ChatRequest(BaseModel):
    message: str
    history: list[dict] = []


@app.get("/")
async def index():
    return FileResponse(STATIC_DIR / "index.html")


@app.get("/api/data")
async def data_status():
    reload_data_if_changed()
    info = get_dataframe_info()
    return {
        **info,
        "hint": f"Edit {DATA_FILE} and save — the app reloads it automatically on the next question.",
    }


@app.post("/api/chat")
async def chat(body: ChatRequest):
    if not body.message.strip():
        raise HTTPException(status_code=400, detail="Message cannot be empty")

    ollama_error = check_ollama()
    if ollama_error and not get_dataframe_info()["loaded"]:
        raise HTTPException(status_code=503, detail=ollama_error)

    answer = answer_question(body.message.strip(), body.history)
    return answer.to_dict()
