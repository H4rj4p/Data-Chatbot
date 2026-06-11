from __future__ import annotations

import json
import re
from typing import Any

from openai import APIError

from app.ai.client import check_ollama, get_chat_client
from app.analytics.schema import build_schema_summary
from app.config import OLLAMA_CHAT_MODEL
import pandas as pd

PLANNER_PROMPT = """You translate questions about a spreadsheet into a JSON query plan.
Return ONLY valid JSON. No markdown fences or commentary.

Dataset schema (exact column names and allowed text values):
{schema}

Conversation (oldest to newest):
{history}

Rules:
- Use exact column names from the schema.
- For text filters, use exact values from schema "values" when possible.
- intent "aggregate": average -> function mean, total/sum -> function sum, how many -> function count.
- intent "extremum": oldest/highest/most -> direction max; youngest/lowest/least -> direction min.
- intent "person": find rows where Name contains person_name (case-insensitive).
- intent "list": return matching rows; use select_columns when the user asks for specific fields.
- intent "count": return the number of matching rows (not a listing unless they also ask to list).
- Use conversation history for follow-ups ("they", "what about", "and", pronouns).
- Multiple metrics in one question -> multiple entries in aggregations.
- If the question cannot be answered from this tabular data, set intent to "unsupported".

JSON shape:
{{
  "intent": "list" | "count" | "aggregate" | "extremum" | "person" | "unsupported",
  "filters": [{{"column": "Role", "operator": "equals", "value": "Software Engineer"}}],
  "aggregations": [{{"column": "Salary", "function": "mean"}}],
  "extremum": {{"column": "Age", "direction": "max"}},
  "person_name": "Harjap",
  "select_columns": ["Name", "Salary"],
  "sort": {{"column": "Salary", "ascending": true}},
  "limit": null,
  "title": "short result title"
}}
"""


def _format_history(history: list[dict]) -> str:
    if not history:
        return "(none)"
    lines: list[str] = []
    for message in history[-6:]:
        role = message.get("role", "user")
        content = str(message.get("content", "")).strip()
        if content:
            lines.append(f"{role}: {content}")
    return "\n".join(lines) if lines else "(none)"


def _extract_json(text: str) -> dict[str, Any] | None:
    text = text.strip()
    if not text:
        return None
    try:
        return json.loads(text)
    except json.JSONDecodeError:
        pass
    match = re.search(r"\{.*\}", text, flags=re.DOTALL)
    if not match:
        return None
    try:
        return json.loads(match.group(0))
    except json.JSONDecodeError:
        return None


def plan_question(
    question: str,
    df: pd.DataFrame,
    history: list[dict] | None = None,
) -> dict[str, Any] | None:
    ollama_error = check_ollama()
    if ollama_error:
        return None

    schema = json.dumps(build_schema_summary(df), indent=2)
    system = PLANNER_PROMPT.format(
        schema=schema,
        history=_format_history(history or []),
    )

    client = get_chat_client()
    try:
        response = client.chat.completions.create(
            model=OLLAMA_CHAT_MODEL,
            messages=[
                {"role": "system", "content": system},
                {"role": "user", "content": question},
            ],
            stream=False,
            temperature=0,
        )
    except APIError:
        return None

    content = response.choices[0].message.content or ""
    plan = _extract_json(content)
    if not isinstance(plan, dict):
        return None
    return plan
