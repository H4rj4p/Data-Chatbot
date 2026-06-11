import os
from pathlib import Path

from dotenv import load_dotenv

load_dotenv()

BASE_DIR = Path(__file__).resolve().parent.parent
DATA_DIR = BASE_DIR / "data"


def _resolve_data_file() -> Path:
    raw = os.getenv("DATA_FILE", "data_source/SampleData.csv")
    path = Path(raw).expanduser()
    if not path.is_absolute():
        path = BASE_DIR / path
    return path.resolve()


DATA_FILE = _resolve_data_file()
OLLAMA_BASE_URL = os.getenv("OLLAMA_BASE_URL", "http://localhost:11434/v1")
OLLAMA_CHAT_MODEL = os.getenv("OLLAMA_CHAT_MODEL", "llama3.2:latest")

CHUNK_SIZE = 800
CHUNK_OVERLAP = 150
TOP_K = 10
SMALL_DOC_CHARS = 6000
MAX_UPLOAD_BYTES = 10 * 1024 * 1024

ALLOWED_EXTENSIONS = {".txt", ".md", ".csv", ".pdf", ".docx", ".xlsx"}
APP_SESSION_ID = "app"
