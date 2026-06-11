from __future__ import annotations

import pandas as pd

from app.analytics.executor import execute_plan
from app.analytics.models import ChatAnswer
from app.analytics.planner import plan_question


def try_planned_answer(
    question: str,
    df: pd.DataFrame,
    history: list[dict] | None = None,
) -> ChatAnswer | None:
    plan = plan_question(question, df, history)
    if not plan:
        return None
    return execute_plan(plan, df)
