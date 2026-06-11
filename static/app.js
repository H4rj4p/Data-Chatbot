const chatEl = document.getElementById("chat");
const emptyState = document.getElementById("empty-state");
const dataStatus = document.getElementById("data-status");
const questionInput = document.getElementById("question");
const sendBtn = document.getElementById("send-btn");

let history = [];
let isSending = false;

function hideEmptyState() {
  if (emptyState) emptyState.remove();
}

function createMessage(role) {
  hideEmptyState();
  const wrapper = document.createElement("div");
  wrapper.className = `message ${role}`;
  const inner = document.createElement("div");
  inner.className = "message-inner";
  const avatar = document.createElement("div");
  avatar.className = `avatar ${role}`;
  avatar.textContent = role === "user" ? "You" : role === "assistant" ? "AI" : "·";
  const bubble = document.createElement("div");
  bubble.className = "bubble";
  inner.appendChild(avatar);
  inner.appendChild(bubble);
  wrapper.appendChild(inner);
  chatEl.appendChild(wrapper);
  chatEl.scrollTop = chatEl.scrollHeight;
  return bubble;
}

function renderTable(bubble, columns, rows) {
  const table = document.createElement("table");
  table.className = "data-table";
  const thead = document.createElement("thead");
  const headRow = document.createElement("tr");
  columns.forEach((col) => {
    const th = document.createElement("th");
    th.textContent = col;
    headRow.appendChild(th);
  });
  thead.appendChild(headRow);
  table.appendChild(thead);

  const tbody = document.createElement("tbody");
  rows.forEach((row) => {
    const tr = document.createElement("tr");
    row.forEach((cell) => {
      const td = document.createElement("td");
      td.textContent = cell;
      tr.appendChild(td);
    });
    tbody.appendChild(tr);
  });
  table.appendChild(tbody);
  bubble.appendChild(table);
}

function renderChart(bubble, chart) {
  const wrap = document.createElement("div");
  wrap.className = "chart-wrap";
  const canvas = document.createElement("canvas");
  wrap.appendChild(canvas);
  bubble.appendChild(wrap);

  new Chart(canvas, {
    type: chart.kind || "bar",
    data: {
      labels: chart.labels || [],
      datasets: [
        {
          label: chart.label || "Value",
          data: chart.values || [],
          backgroundColor: "#19c37d",
          borderColor: "#19c37d",
        },
      ],
    },
    options: {
      responsive: true,
      plugins: { legend: { labels: { color: "#ececec" } } },
      scales: {
        x: { ticks: { color: "#aaa" }, grid: { color: "#222" } },
        y: { ticks: { color: "#aaa" }, grid: { color: "#222" } },
      },
    },
  });
}

function renderAnswer(bubble, data) {
  bubble.innerHTML = "";
  const text = document.createElement("p");
  text.textContent = data.text;
  bubble.appendChild(text);

  if (data.tables?.length) {
    data.tables.forEach((section) => {
      const heading = document.createElement("p");
      heading.textContent = section.title;
      heading.style.marginTop = "16px";
      heading.style.color = "#aaa";
      bubble.appendChild(heading);
      renderTable(bubble, section.columns, section.rows);
    });
  } else if (data.columns && data.rows && (data.type === "table" || data.type === "chart")) {
    renderTable(bubble, data.columns, data.rows);
  }
  if (data.type === "chart" && data.chart) {
    renderChart(bubble, data.chart);
  }
}

async function loadDataStatus() {
  const res = await fetch("/api/data");
  const data = await res.json();
  if (data.loaded) {
    dataStatus.textContent = `Loaded ${data.rows} rows from ${data.path} · edit the file and ask again to refresh`;
  } else {
    dataStatus.textContent = `Waiting for data file at ${data.path}`;
  }
}

async function send() {
  const message = questionInput.value.trim();
  if (!message || isSending) return;

  questionInput.value = "";
  questionInput.style.height = "auto";
  createMessage("user").textContent = message;
  history.push({ role: "user", content: message });

  isSending = true;
  sendBtn.disabled = true;
  const bubble = createMessage("assistant");
  bubble.textContent = "Thinking...";

  try {
    const res = await fetch("/api/chat", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ message, history: history.slice(0, -1) }),
    });
    const data = await res.json();
    if (!res.ok) throw new Error(data.detail || "Request failed");
    renderAnswer(bubble, data);
    history.push({ role: "assistant", content: data.text });
    loadDataStatus();
  } catch (err) {
    bubble.textContent = `Error: ${err.message}`;
  } finally {
    isSending = false;
    sendBtn.disabled = false;
  }
}

sendBtn.addEventListener("click", send);
questionInput.addEventListener("keydown", (e) => {
  if (e.key === "Enter" && !e.shiftKey) {
    e.preventDefault();
    send();
  }
});

loadDataStatus();
