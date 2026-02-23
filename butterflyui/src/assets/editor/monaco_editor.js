(function () {
  const cfg = window.__BUTTERFLY_MONACO_CONFIG__ || {};
  const initialValue = window.__BUTTERFLY_MONACO_VALUE__ || '';
  const submitOnCtrlEnter = cfg.submitOnCtrlEnter !== false;
  const emitOnChange = cfg.emitOnChange !== false;
  const debounceMs = Number(cfg.debounceMs || 180);
  const editorNode = document.getElementById('editor');
  let editor = null;
  let changeDebounce = null;
  let fallbackEditor = null;

  function post(event, payload) {
    const message = JSON.stringify({ event: event, payload: payload || {} });
    try {
      if (window.flutter_inappwebview && window.flutter_inappwebview.callHandler) {
        window.flutter_inappwebview.callHandler('ButterflyUI', message);
        return;
      }
    } catch (_) {}
    try {
      if (window.chrome && window.chrome.webview) {
        window.chrome.webview.postMessage(message);
        return;
      }
    } catch (_) {}
    try {
      if (window.ButterflyUI && window.ButterflyUI.postMessage) {
        window.ButterflyUI.postMessage(message);
      }
    } catch (_) {}
  }

  function debounceChange() {
    if (!emitOnChange || !editor) return;
    if (changeDebounce) clearTimeout(changeDebounce);
    changeDebounce = setTimeout(function () {
      const model = editor.getModel();
      const value = model ? model.getValue() : '';
      post('change', { value: value, line_count: model ? model.getLineCount() : 1 });
    }, Math.max(0, debounceMs));
  }

  function toMarkerSeverity(value) {
    const sev = String(value || '').toLowerCase();
    if (sev === 'error') return monaco.MarkerSeverity.Error;
    if (sev === 'warning' || sev === 'warn') return monaco.MarkerSeverity.Warning;
    if (sev === 'hint') return monaco.MarkerSeverity.Hint;
    return monaco.MarkerSeverity.Info;
  }

  function initMonaco() {
    if (typeof require !== 'function') {
      initFallbackEditor('loader_missing');
      return;
    }
    require.config({ paths: { vs: 'https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.52.2/min/vs' } });
    require(['vs/editor/editor.main'], function () {
      editor = monaco.editor.create(editorNode, {
        value: initialValue,
        language: cfg.language || 'plaintext',
        theme: cfg.theme || 'vs-dark',
        readOnly: cfg.readOnly === true,
        wordWrap: cfg.wordWrap === true ? 'on' : 'off',
        minimap: { enabled: cfg.minimap === true },
        lineNumbers: cfg.lineNumbers === false ? 'off' : 'on',
        glyphMargin: cfg.glyphMargin === true,
        tabSize: Number(cfg.tabSize || 2),
        fontFamily: cfg.fontFamily || 'JetBrains Mono',
        fontSize: Number(cfg.fontSize || 13),
        renderWhitespace: cfg.renderWhitespace || 'selection',
        formatOnType: cfg.formatOnType === true,
        formatOnPaste: cfg.formatOnPaste === true,
        automaticLayout: true,
      });

      const model = editor.getModel();
      if (model && cfg.documentUri) {
        const uri = monaco.Uri.parse(String(cfg.documentUri));
        const language = cfg.language || 'plaintext';
        const nextModel = monaco.editor.createModel(model.getValue(), language, uri);
        editor.setModel(nextModel);
        model.dispose();
      }

      if (model) {
        model.onDidChangeContent(function () {
          debounceChange();
        });
      }

      editor.onDidFocusEditorText(function () {
        post('focus', {});
      });

      editor.onDidBlurEditorText(function () {
        post('blur', {});
      });

      editor.onDidChangeCursorPosition(function (event) {
        post('cursor_change', {
          line: event.position.lineNumber,
          column: event.position.column,
        });
      });

      editor.addCommand(monaco.KeyMod.CtrlCmd | monaco.KeyCode.KeyS, function () {
        post('save', { value: editor.getValue() });
      });

      if (submitOnCtrlEnter) {
        editor.addCommand(monaco.KeyMod.CtrlCmd | monaco.KeyCode.Enter, function () {
          post('submit', { value: editor.getValue() });
        });
      }

      window.ButterflyUIMonaco = {
        _editor: editor,
        getValue: function () {
          return editor ? editor.getValue() : '';
        },
        setValue: function (value, silent) {
          if (!editor) return;
          const model = editor.getModel();
          if (!model) return;
          model.setValue(String(value == null ? '' : value));
          if (!silent) debounceChange();
        },
        focus: function () {
          if (editor) editor.focus();
        },
        blur: function () {
          if (editor && editor.getDomNode()) editor.getDomNode().blur();
        },
        selectAll: function () {
          if (!editor) return;
          const model = editor.getModel();
          if (!model) return;
          editor.setSelection(model.getFullModelRange());
        },
        insertText: function (value) {
          if (!editor) return;
          editor.executeEdits('butterflyui', [{
            range: editor.getSelection(),
            text: String(value == null ? '' : value),
            forceMoveMarkers: true,
          }]);
          debounceChange();
        },
        revealLine: function (line) {
          if (!editor) return;
          editor.revealLineInCenter(Number(line || 1));
        },
        setMarkers: function (markers) {
          if (!editor) return;
          const model = editor.getModel();
          if (!model) return;
          const normalized = Array.isArray(markers) ? markers.map(function (marker) {
            return {
              startLineNumber: Number(marker.startLineNumber || marker.start_line || marker.line || 1),
              startColumn: Number(marker.startColumn || marker.start_column || marker.column || 1),
              endLineNumber: Number(marker.endLineNumber || marker.end_line || marker.line || 1),
              endColumn: Number(marker.endColumn || marker.end_column || marker.column || 1),
              message: String(marker.message || ''),
              severity: toMarkerSeverity(marker.severity),
              source: marker.source ? String(marker.source) : 'butterflyui',
            };
          }) : [];
          monaco.editor.setModelMarkers(model, 'butterflyui', normalized);
        },
        formatDocument: async function () {
          if (!editor) return false;
          const result = await editor.getAction('editor.action.formatDocument').run();
          debounceChange();
          return !!result;
        },
        setOptions: function (options) {
          if (!editor || !options || typeof options !== 'object') return;
          editor.updateOptions(options);
        },
        setTheme: function (theme) {
          if (!window.monaco || !theme) return;
          monaco.editor.setTheme(String(theme));
        }
      };

      post('ready', {
        engine: 'monaco',
        language: cfg.language || 'plaintext',
        line_count: editor.getModel() ? editor.getModel().getLineCount() : 1,
      });
    }, function () {
      initFallbackEditor('cdn_unavailable');
    });
  }

  function initFallbackEditor(reason) {
    editorNode.innerHTML = '';
    const ta = document.createElement('textarea');
    ta.value = String(initialValue || '');
    ta.readOnly = cfg.readOnly === true;
    ta.spellcheck = false;
    ta.style.width = '100%';
    ta.style.height = '100%';
    ta.style.boxSizing = 'border-box';
    ta.style.border = 'none';
    ta.style.outline = 'none';
    ta.style.margin = '0';
    ta.style.padding = '10px 12px';
    ta.style.background = '#1e1e1e';
    ta.style.color = '#d4d4d4';
    ta.style.fontFamily = String(cfg.fontFamily || 'JetBrains Mono, monospace');
    ta.style.fontSize = String(Number(cfg.fontSize || 13)) + 'px';
    ta.style.lineHeight = '1.5';
    ta.style.whiteSpace = cfg.wordWrap === true ? 'pre-wrap' : 'pre';
    ta.style.resize = 'none';

    ta.addEventListener('input', function () {
      post('change', { value: ta.value, line_count: ta.value.split('\n').length });
    });
    ta.addEventListener('focus', function () { post('focus', {}); });
    ta.addEventListener('blur', function () { post('blur', {}); });
    ta.addEventListener('keydown', function (event) {
      if ((event.ctrlKey || event.metaKey) && event.key.toLowerCase() === 's') {
        event.preventDefault();
        post('save', { value: ta.value });
      }
      if (submitOnCtrlEnter && (event.ctrlKey || event.metaKey) && event.key === 'Enter') {
        event.preventDefault();
        post('submit', { value: ta.value });
      }
    });

    editorNode.appendChild(ta);
    fallbackEditor = ta;

    window.ButterflyUIMonaco = {
      _editor: null,
      getValue: function () { return fallbackEditor ? fallbackEditor.value : ''; },
      setValue: function (value) {
        if (!fallbackEditor) return;
        fallbackEditor.value = String(value == null ? '' : value);
      },
      focus: function () { if (fallbackEditor) fallbackEditor.focus(); },
      blur: function () { if (fallbackEditor) fallbackEditor.blur(); },
      selectAll: function () {
        if (!fallbackEditor) return;
        fallbackEditor.selectionStart = 0;
        fallbackEditor.selectionEnd = fallbackEditor.value.length;
      },
      insertText: function (value) {
        if (!fallbackEditor) return;
        const text = String(value == null ? '' : value);
        const start = fallbackEditor.selectionStart || 0;
        const end = fallbackEditor.selectionEnd || 0;
        const current = fallbackEditor.value;
        fallbackEditor.value = current.slice(0, start) + text + current.slice(end);
      },
      revealLine: function () {},
      setMarkers: function () {},
      formatDocument: async function () { return false; },
      setOptions: function (options) {
        if (!fallbackEditor || !options || typeof options !== 'object') return;
        if (Object.prototype.hasOwnProperty.call(options, 'readOnly')) {
          fallbackEditor.readOnly = options.readOnly === true;
        }
        if (Object.prototype.hasOwnProperty.call(options, 'wordWrap')) {
          fallbackEditor.style.whiteSpace = options.wordWrap === 'on' ? 'pre-wrap' : 'pre';
        }
        if (Object.prototype.hasOwnProperty.call(options, 'fontSize')) {
          fallbackEditor.style.fontSize = String(Number(options.fontSize || 13)) + 'px';
        }
        if (Object.prototype.hasOwnProperty.call(options, 'fontFamily')) {
          fallbackEditor.style.fontFamily = String(options.fontFamily || 'JetBrains Mono, monospace');
        }
      },
      setTheme: function () {}
    };

    post('ready', {
      engine: 'fallback',
      reason: String(reason || 'unknown'),
      language: cfg.language || 'plaintext',
      line_count: ta.value.split('\n').length,
    });
  }

  initMonaco();
})();
