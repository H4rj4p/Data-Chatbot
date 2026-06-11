const sessionId = localStorage.getItem("sessionId") || crypto.randomUUID();
localStorage.setItem("sessionId", sessionId);

const chatEl = document.getElementById("chat");
const emptyState = document.getElementById("empty-state");
const questionInput = document.getElementById("question");
const sendBtn = document.getElementById("send-btn");
const uploadBtn = document.getElementById("upload-btn");
const fileInput = document.getElementById("file-input");

let history = [];
let isStreaming = false;

const sessionHeaders = () => ({ "X-Session-Id": sessionId });

async function parseResponse(res) {
  const text = await res.text();
  let data = null;
  try {
    data = JSON.parse(text);
  } catch {
    // response was not JSON
  }
  if (!res.ok) {
    throw new Error((data && data.detail) || text || "Request failed");
  }
  return data;
}

function hideEmptyState() {
  if (emptyState) emptyState.remove();
}

function addMessage(role, text, streaming = false) {
  hideEmptyState();

  const wrapper = document.createElement("div");
  wrapper.className = `message ${role}`;

  const inner = document.createElement("div");
  inner.className = "message-inner";

  const avatar = document.createElement("div");
  avatar.className = `avatar ${role}`;
  avatar.textContent = role === "user" ? "You" : role === "assistant" ? "AI" : "·";

  const bubble = document.createElement("div");
  bubble.className = `bubble${streaming ? " streaming" : ""}`;
  bubble.textContent = text;

  inner.appendChild(avatar);
  inner.appendChild(bubble);
  wrapper.appendChild(inner);
  chatEl.appendChild(wrapper);
  chatEl.scrollTop = chatEl.scrollHeight;
  return bubble;
}

function autoResize() {
  questionInput.style.height = "auto";
  questionInput.style.height = Math.min(questionInput.scrollHeight, 200) + "px";
}

uploadBtn.addEventListener("click", () => fileInput.click());

fileInput.addEventListener("change", async () => {
  const file = fileInput.files[0];
  if (!file) return;

  const statusBubble = addMessage("system", `Uploading ${file.name}...`);

  const formData = new FormData();
  formData.append("file", file);

  try {
    const res = await fetch("/api/upload", {
      method: "POST",
      headers: sessionHeaders(),
      body: formData,
    });
    const data = await parseResponse(res);
    statusBubble.textContent = `Uploaded ${data.filename}. You can now ask questions about it.`;
    statusBubble.parentElement.parentElement.className = "message system";
  } catch (err) {
    statusBubble.textContent = `Upload failed: ${err.message}`;
  }

  fileInput.value = "";
});

async function send() {
  const message = questionInput.value.trim();
  if (!message || isStreaming) return;

  questionInput.value = "";
  autoResize();
  addMessage("user", message);
  history.push({ role: "user", content: message });

  isStreaming = true;
  sendBtn.disabled = true;
  const bubble = addMessage("assistant", "", true);
  let reply = "";

  try {
    const res = await fetch("/api/chat", {
      method: "POST",
      headers: { ...sessionHeaders(), "Content-Type": "application/json" },
      body: JSON.stringify({ message, history: history.slice(0, -1) }),
    });

    if (!res.ok) await parseResponse(res);

    const reader = res.body.getReader();
    const decoder = new TextDecoder();

    while (true) {
      const { done, value } = await reader.read();
      if (done) break;
      reply += decoder.decode(value, { stream: true });
      bubble.textContent = reply;
      chatEl.scrollTop = chatEl.scrollHeight;
    }

    bubble.classList.remove("streaming");
    history.push({ role: "assistant", content: reply });
  } catch (err) {
    bubble.classList.remove("streaming");
    bubble.textContent = `Error: ${err.message}`;
  } finally {
    isStreaming = false;
    sendBtn.disabled = false;
  }
}

sendBtn.addEventListener("click", send);
questionInput.addEventListener("input", autoResize);
questionInput.addEventListener("keydown", (e) => {
  if (e.key === "Enter" && !e.shiftKey) {
    e.preventDefault();
    send();
  }
});
