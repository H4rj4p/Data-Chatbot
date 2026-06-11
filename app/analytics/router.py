from __future__ import annotations

from app.analytics.engine import try_analytics_answer
from app.analytics.models import ChatAnswer
from app.analytics.planned import try_planned_answer
from app.data_loader import get_dataframe, get_dataframe_info, reload_data_if_changed


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

    planned = try_planned_answer(question, df, history)
    if planned:
        return planned

    return ChatAnswer(
        type="text",
        text=(
            "I couldn't compute a reliable answer from your data. "
            "Try rephrasing, or ask about names, roles, salaries, ages, counts, averages, or totals."
        ),
    )
