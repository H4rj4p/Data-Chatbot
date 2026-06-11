from __future__ import annotations

from app.analytics.engine import try_analytics_answer
from app.analytics.models import ChatAnswer
from app.data_loader import get_dataframe, get_dataframe_info, reload_data_if_changed
from app.rag.chat import answer_with_llm
from app.rag.store import get_store
from app.config import APP_SESSION_ID


def answer_question(question: str, history: list[dict]) -> ChatAnswer:
    reload_data_if_changed()
    df = get_dataframe()

    if df is None or df.empty:
        info = get_dataframe_info()
        return ChatAnswer(
            type="text",
            text=f"No data loaded. Put your CSV at {info['path']} and restart the server.",
        )

    analytics = try_analytics_answer(question, df, history)
    if analytics:
        return analytics

    store = get_store(APP_SESSION_ID)
    text = answer_with_llm(store, question, history)
    return ChatAnswer(type="text", text=text)
