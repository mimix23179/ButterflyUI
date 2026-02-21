(function () {
  const editor = document.getElementById("editor");
  const status = document.getElementById("status");
  const toolbar = document.getElementById("toolbar");
  const formatBtn = document.getElementById("format-btn");
  const applyBtn = document.getElementById("apply-btn");

  let config = window.__CONDUIT_CONFIG__ || {};
  let emitOnChange = config.emitOnChange !== false;
  let suppress = false;
  let debounceId = null;
  let lastParse = { ok: true, value: null, error: null };

  function post(event, payload) {
    const message = { event, payload };
    if (window.flutter_inappwebview && window.flutter_inappwebview.callHandler) {
      window.flutter_inappwebview.callHandler("conduit", message);
      return;
    }
    if (window.chrome && window.chrome.webview) {
      window.chrome.webview.postMessage(JSON.stringify(message));
    }
  }

  function parseJson(text) {
    if (!text.trim()) {
      return { ok: true, value: null, error: null };
    }
    try {
      const value = JSON.parse(text);
      return { ok: true, value, error: null };
    } catch (err) {
      return { ok: false, value: null, error: err ? String(err.message || err) : "Invalid JSON" };
    }
  }

  function setStatus(ok, message) {
    status.textContent = message;
    status.style.color = ok ? "#16a34a" : "#dc2626";
  }

  function updateStatus() {
    lastParse = parseJson(editor.value);
    if (lastParse.ok) {
      setStatus(true, editor.value.trim() ? "Valid JSON" : "Empty");
    } else {
      setStatus(false, lastParse.error || "Invalid JSON");
    }
  }

  function notifyChange() {
    if (!emitOnChange) return;
    if (debounceId) clearTimeout(debounceId);
    debounceId = setTimeout(() => {
      post("change", {
        text: editor.value,
        valid: lastParse.ok,
        error: lastParse.error,
      });
    }, 200);
  }

  function setValue(text, silent) {
    suppress = !!silent;
    editor.value = text || "";
    updateStatus();
    if (!suppress) {
      notifyChange();
    }
    suppress = false;
  }

  function applyConfig(next) {
    config = next || {};
    emitOnChange = config.emitOnChange !== false;
    const enabled = config.enabled !== false;
    const readOnly = config.readOnly === true;
    const showToolbar = config.showToolbar !== false;
    editor.disabled = !enabled;
    editor.readOnly = readOnly;
    formatBtn.disabled = !enabled || readOnly;
    applyBtn.disabled = !enabled;
    toolbar.style.display = showToolbar ? "flex" : "none";
  }

  editor.addEventListener("input", () => {
    if (suppress) return;
    updateStatus();
    notifyChange();
  });

  formatBtn.addEventListener("click", () => {
    updateStatus();
    if (!lastParse.ok) {
      post("error", { message: lastParse.error || "Invalid JSON" });
      return;
    }
    const formatted = JSON.stringify(lastParse.value, null, 2);
    setValue(formatted, false);
    post("format", { text: formatted });
  });

  applyBtn.addEventListener("click", () => {
    updateStatus();
    if (!lastParse.ok) {
      post("error", { message: lastParse.error || "Invalid JSON" });
      return;
    }
    post("apply", { text: editor.value, value: lastParse.value });
  });

  window.ConduitJsonEditor = {
    setValue,
    setConfig: applyConfig,
    getValue: () => editor.value,
  };

  applyConfig(config);
  setValue(window.__CONDUIT_INITIAL__ || "", true);
})();
