import httpx
from openai import OpenAI

from app.config import OLLAMA_BASE_URL, OLLAMA_CHAT_MODEL


def get_chat_client() -> OpenAI:
    return OpenAI(base_url=OLLAMA_BASE_URL, api_key="ollama")


def check_ollama() -> str | None:
    """Return an error message if Ollama is not reachable."""
    try:
        base = OLLAMA_BASE_URL.removesuffix("/v1")
        with httpx.Client(timeout=3.0) as client:
            res = client.get(f"{base}/api/tags")
            if res.status_code != 200:
                return "Ollama is not running. Start it from the Ollama app."
            models = [m["name"] for m in res.json().get("models", [])]
            if OLLAMA_CHAT_MODEL not in models and not any(
                OLLAMA_CHAT_MODEL.split(":")[0] in m for m in models
            ):
                return f"Model {OLLAMA_CHAT_MODEL} not found. Run: ollama pull {OLLAMA_CHAT_MODEL}"
    except httpx.HTTPError:
        return "Ollama is not running. Open the Ollama app or run: ollama serve"
    return None
