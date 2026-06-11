@echo off
setlocal

cd /d "%~dp0"

if not exist ".venv\Scripts\activate.bat" (
    echo Creating virtual environment...
    python -m venv .venv
    if errorlevel 1 (
        echo Failed to create venv. Install Python 3.11+ from https://www.python.org/downloads/
        exit /b 1
    )
)

call .venv\Scripts\activate.bat

echo Installing dependencies...
pip install -r requirements.txt
if errorlevel 1 exit /b 1

if not exist ".env" (
    echo Creating .env from .env.example...
    copy .env.example .env >nul
)

if not exist "data_source\SampleData.csv" (
    echo ERROR: data_source\SampleData.csv not found.
    echo Make sure you cloned the full repo and are on branch cursor/local-rag-chatbot.
    exit /b 1
)

echo Starting server at http://127.0.0.1:8000
uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
