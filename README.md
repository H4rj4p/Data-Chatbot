# Data Chatbot

Ask questions about a spreadsheet using plain English. Works on **Mac and Windows**.

## Quick start (Windows)

1. Install [Python 3.11+](https://www.python.org/downloads/) — check **"Add Python to PATH"**
2. Install [Git](https://git-scm.com/download/win)
3. Optional: install [Ollama](https://ollama.com) for fallback questions the rule engine cannot answer

```powershell
git clone https://github.com/H4rj4p/Data-Chatbot.git
cd Data-Chatbot
git checkout cursor/local-rag-chatbot
git pull
```

Double-click **`run.bat`** or in PowerShell:

```powershell
.\run.bat
```

Open **http://127.0.0.1:8000**

## Quick start (Mac)

```bash
git clone https://github.com/H4rj4p/Data-Chatbot.git
cd Data-Chatbot
git checkout cursor/local-rag-chatbot
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
uvicorn app.main:app --reload
```

## Data file

The repo includes sample data at `data_source/SampleData.csv`.

Do **not** copy a `.env` from another computer if it has a Mac path like `/Users/...`. On Windows, use:

```env
DATA_FILE=data_source/SampleData.csv
```

## Common Windows problems

| Problem | Fix |
|---|---|
| `'python' is not recognized` | Reinstall Python with "Add to PATH" checked |
| `No module named uvicorn` | Run `pip install -r requirements.txt` inside the venv |
| `data not loaded` | Check `.env` — use `data_source/SampleData.csv`, not a Mac path |
| Port 8000 in use | Close other servers or run `uvicorn app.main:app --port 8001` |
| Ollama errors | Install Ollama and run `ollama pull llama3.2` — analytics still work without it if data is loaded |

## Manual run (Windows)

```powershell
cd Data-Chatbot
python -m venv .venv
.\.venv\Scripts\activate
pip install -r requirements.txt
copy .env.example .env
uvicorn app.main:app --reload
```
