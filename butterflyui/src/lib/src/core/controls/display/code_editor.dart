import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_windows/webview_windows.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class ButterflyUICodeEditor extends StatefulWidget {
  final String controlId;
  final String value;
  final String? language;
  final String? theme;
  final String engine;
  final String webviewEngine;
  final bool readOnly;
  final bool autofocus;
  final bool wordWrap;
  final bool showLineNumbers;
  final bool showGutter;
  final bool showMinimap;
  final bool glyphMargin;
  final bool emitOnChange;
  final int debounceMs;
  final int tabSize;
  final String? documentUri;
  final double fontSize;
  final String fontFamily;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final double borderWidth;
  final double radius;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUICodeEditor({
    super.key,
    required this.controlId,
    required this.value,
    required this.language,
    required this.theme,
    required this.engine,
    required this.webviewEngine,
    required this.readOnly,
    required this.autofocus,
    required this.wordWrap,
    required this.showLineNumbers,
    required this.showGutter,
    required this.showMinimap,
    required this.glyphMargin,
    required this.emitOnChange,
    required this.debounceMs,
    required this.tabSize,
    required this.documentUri,
    required this.fontSize,
    required this.fontFamily,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    required this.borderWidth,
    required this.radius,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<ButterflyUICodeEditor> createState() => _ButterflyUICodeEditorState();
}

class _ButterflyUICodeEditorState extends State<ButterflyUICodeEditor> {
  late final TextEditingController _fallbackController = TextEditingController(
    text: widget.value,
  );
  final FocusNode _fallbackFocusNode = FocusNode();
  final ScrollController _fallbackEditorScroll = ScrollController();
  final ScrollController _fallbackGutterScroll = ScrollController();

  final WebviewController _windowsController = WebviewController();
  WebViewController? _flutterController;
  StreamSubscription<dynamic>? _windowsMessageSub;

  Timer? _debounce;
  bool _fallbackSuppressChange = false;
  bool _monacoReady = false;
  bool _monacoInitialized = false;
  bool _isSyncingGutter = false;
  String _latestValue = '';

  bool get _useMonaco {
    final normalized = widget.engine.trim().toLowerCase();
    return !(normalized == 'flutter' ||
        normalized == 'basic' ||
        normalized == 'text' ||
        normalized == 'textarea');
  }

  bool get _useFlutterWebView {
    final normalized = widget.webviewEngine.trim().toLowerCase();
    if (normalized == 'flutter' || normalized == 'webview_flutter') {
      return true;
    }
    if (normalized == 'windows' || normalized == 'webview_windows') {
      return false;
    }
    return !Platform.isWindows;
  }

  @override
  void initState() {
    super.initState();
    _latestValue = widget.value;
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);

    _fallbackEditorScroll.addListener(() {
      if (_isSyncingGutter) return;
      if (!_fallbackGutterScroll.hasClients) return;
      _isSyncingGutter = true;
      final target = _fallbackEditorScroll.offset.clamp(
        0.0,
        _fallbackGutterScroll.position.maxScrollExtent,
      );
      _fallbackGutterScroll.jumpTo(target);
      _isSyncingGutter = false;
    });

    if (_useMonaco) {
      unawaited(_initializeMonaco());
    }
  }

  @override
  void didUpdateWidget(covariant ButterflyUICodeEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controlId != oldWidget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }

    final oldUsesMonaco = _resolveUseMonaco(oldWidget.engine);
    final oldUsesFlutterWebview = _resolveUseFlutterWebView(
      oldWidget.webviewEngine,
    );
    if (_useMonaco != oldUsesMonaco ||
        _useFlutterWebView != oldUsesFlutterWebview) {
      _monacoReady = false;
      _monacoInitialized = false;
      if (_useMonaco) {
        unawaited(_initializeMonaco());
      }
    }

    if (widget.value != oldWidget.value && widget.value != _latestValue) {
      _latestValue = widget.value;
      if (_useMonaco) {
        unawaited(_setMonacoValue(widget.value, silent: true));
      } else if (widget.value != _fallbackController.text) {
        _fallbackSuppressChange = true;
        _fallbackController.value = _fallbackController.value.copyWith(
          text: widget.value,
          selection: TextSelection.collapsed(offset: widget.value.length),
        );
        _fallbackSuppressChange = false;
      }
    }
  }

  bool _resolveUseMonaco(String value) {
    final normalized = value.trim().toLowerCase();
    return !(normalized == 'flutter' ||
        normalized == 'basic' ||
        normalized == 'text' ||
        normalized == 'textarea');
  }

  bool _resolveUseFlutterWebView(String value) {
    final normalized = value.trim().toLowerCase();
    if (normalized == 'flutter' || normalized == 'webview_flutter') {
      return true;
    }
    if (normalized == 'windows' || normalized == 'webview_windows') {
      return false;
    }
    return !Platform.isWindows;
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    _windowsMessageSub?.cancel();
    _debounce?.cancel();
    _fallbackFocusNode.dispose();
    _fallbackController.dispose();
    _fallbackEditorScroll.dispose();
    _fallbackGutterScroll.dispose();
    unawaited(_windowsController.dispose());
    super.dispose();
  }

  Future<void> _initializeMonaco() async {
    if (_monacoInitialized) return;
    _monacoInitialized = true;
    if (_useFlutterWebView) {
      await _initializeFlutterMonaco();
      return;
    }

    await _windowsController.initialize().timeout(
      const Duration(milliseconds: 15000),
    );
    _windowsMessageSub?.cancel();
    _windowsMessageSub = _windowsController.webMessage.listen(_handleMonacoMessage);

    final html = await _buildMonacoHtml();
    await _windowsController.loadStringContent(html);
  }

  Future<void> _initializeFlutterMonaco() async {
    final controller = WebViewController();
    _flutterController = controller;

    await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    await controller.setNavigationDelegate(
      NavigationDelegate(
        onPageFinished: (_) async {
          if (!_monacoReady) {
            _monacoReady = true;
            widget.sendEvent(widget.controlId, 'ready', {
              'engine': 'monaco',
              'webview_engine': 'flutter',
            });
          }
        },
      ),
    );

    await controller.addJavaScriptChannel(
      'ButterflyUI',
      onMessageReceived: (message) {
        _handleMonacoMessage(message.message);
      },
    );

    final html = await _buildMonacoHtml();
    await controller.loadHtmlString(html);
  }

  Future<String> _buildMonacoHtml() async {
    final template = await rootBundle.loadString(
      'assets/editor/monaco_editor.html',
    );
    final script = await rootBundle.loadString('assets/editor/monaco_editor.js');
    final style = await rootBundle.loadString('assets/editor/monaco_editor.css');

    final config = <String, Object?>{
      'language': widget.language ?? 'plaintext',
      'theme': widget.theme ?? 'vs-dark',
      'readOnly': widget.readOnly,
      'wordWrap': widget.wordWrap,
      'lineNumbers': widget.showLineNumbers,
      'glyphMargin': widget.glyphMargin,
      'minimap': widget.showMinimap,
      'emitOnChange': widget.emitOnChange,
      'debounceMs': widget.debounceMs,
      'fontSize': widget.fontSize,
      'fontFamily': widget.fontFamily,
      'tabSize': widget.tabSize,
      'documentUri': widget.documentUri,
      'submitOnCtrlEnter': true,
      'formatOnType': false,
      'formatOnPaste': false,
      'renderWhitespace': 'selection',
    };

    return template
        .replaceFirst('/*{{style}}*/', style)
        .replaceFirst('/*{{script}}*/', script)
        .replaceFirst('/*{{initial}}*/ ""', jsonEncode(widget.value))
        .replaceFirst('/*{{config}}*/ {}', jsonEncode(config));
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    if (_useMonaco) {
      return _handleMonacoInvoke(method, args);
    }
    return _handleFallbackInvoke(method, args);
  }

  Future<Object?> _handleFallbackInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'get_value':
        return _fallbackController.text;
      case 'set_value':
        final value = args['value']?.toString() ?? '';
        _fallbackSuppressChange = true;
        _fallbackController.value = _fallbackController.value.copyWith(
          text: value,
          selection: TextSelection.collapsed(offset: value.length),
        );
        _fallbackSuppressChange = false;
        _latestValue = value;
        if (mounted) setState(() {});
        return null;
      case 'focus':
        _fallbackFocusNode.requestFocus();
        return null;
      case 'blur':
        _fallbackFocusNode.unfocus();
        return null;
      case 'select_all':
        _fallbackController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _fallbackController.text.length,
        );
        return null;
      case 'insert_text':
        final value = args['value']?.toString() ?? '';
        if (value.isEmpty) return null;
        final selection = _fallbackController.selection;
        if (!selection.isValid) {
          _fallbackController.text += value;
        } else {
          final base = selection.start;
          final extent = selection.end;
          final text = _fallbackController.text;
          final next = text.replaceRange(base, extent, value);
          _fallbackController.value = TextEditingValue(
            text: next,
            selection: TextSelection.collapsed(offset: base + value.length),
          );
        }
        _latestValue = _fallbackController.text;
        _emitFallbackChange(immediate: true);
        if (mounted) setState(() {});
        return null;
      case 'format_document':
        widget.sendEvent(widget.controlId, 'format_request', {
          'value': _fallbackController.text,
          'language': widget.language ?? '',
        });
        return null;
      default:
        throw UnsupportedError('Unknown code_editor method: $method');
    }
  }

  Future<Object?> _handleMonacoInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'get_value':
        final result = await _runMonacoJavaScript(
          'window.ButterflyUIMonaco ? window.ButterflyUIMonaco.getValue() : "";',
          expectResult: true,
        );
        if (result is String) {
          _latestValue = result;
          return result;
        }
        return _latestValue;
      case 'set_value':
        final value = args['value']?.toString() ?? '';
        _latestValue = value;
        await _setMonacoValue(value, silent: true);
        return null;
      case 'focus':
        await _runMonacoJavaScript(
          'if(window.ButterflyUIMonaco){window.ButterflyUIMonaco.focus();}',
        );
        return null;
      case 'blur':
        await _runMonacoJavaScript(
          'if(window.ButterflyUIMonaco){window.ButterflyUIMonaco.blur();}',
        );
        return null;
      case 'select_all':
        await _runMonacoJavaScript(
          'if(window.ButterflyUIMonaco){window.ButterflyUIMonaco.selectAll();}',
        );
        return null;
      case 'insert_text':
        final value = args['value']?.toString() ?? '';
        await _runMonacoJavaScript(
          'if(window.ButterflyUIMonaco){window.ButterflyUIMonaco.insertText(${jsonEncode(value)});}',
        );
        return null;
      case 'format_document':
        await _runMonacoJavaScript(
          'if(window.ButterflyUIMonaco){window.ButterflyUIMonaco.formatDocument();}',
        );
        widget.sendEvent(widget.controlId, 'format_request', {
          'value': _latestValue,
          'language': widget.language ?? '',
        });
        return null;
      case 'reveal_line':
        final line = coerceOptionalInt(args['line']) ?? 1;
        await _runMonacoJavaScript(
          'if(window.ButterflyUIMonaco){window.ButterflyUIMonaco.revealLine($line);}',
        );
        return null;
      case 'set_markers':
        final markers = args['markers'] is List
            ? List<Object?>.from(args['markers'] as List)
            : const <Object?>[];
        await _runMonacoJavaScript(
          'if(window.ButterflyUIMonaco){window.ButterflyUIMonaco.setMarkers(${jsonEncode(markers)});}',
        );
        return null;
      default:
        throw UnsupportedError('Unknown code_editor method: $method');
    }
  }

  Future<void> _setMonacoValue(String value, {required bool silent}) async {
    await _runMonacoJavaScript(
      'if(window.ButterflyUIMonaco){window.ButterflyUIMonaco.setValue(${jsonEncode(value)}, ${silent ? 'true' : 'false'});}',
    );
  }

  Future<Object?> _runMonacoJavaScript(
    String script, {
    bool expectResult = false,
  }) async {
    if (_useFlutterWebView) {
      final controller = _flutterController;
      if (controller == null) return null;
      if (expectResult) {
        final raw = await controller.runJavaScriptReturningResult(script);
        return _normalizeJavaScriptResult(raw);
      }
      await controller.runJavaScript(script);
      return null;
    }

    final raw = await _windowsController.executeScript(script);
    return expectResult ? _normalizeJavaScriptResult(raw) : null;
  }

  Object? _normalizeJavaScriptResult(Object? raw) {
    if (raw == null) return null;
    if (raw is num || raw is bool) return raw;
    final text = raw.toString();
    if (text.isEmpty || text == 'null' || text == 'undefined') return null;
    try {
      return jsonDecode(text);
    } catch (_) {
      if (text.startsWith('"') && text.endsWith('"') && text.length >= 2) {
        try {
          return jsonDecode(text);
        } catch (_) {}
      }
      return text;
    }
  }

  void _handleMonacoMessage(dynamic message) {
    Object? decoded = message;
    if (message is String) {
      try {
        decoded = jsonDecode(message);
      } catch (_) {
        decoded = message;
      }
    }

    if (decoded is! Map) return;
    final map = coerceObjectMap(decoded);
    final event = map['event']?.toString() ?? 'message';
    final payload = map['payload'] is Map
        ? coerceObjectMap(map['payload'] as Map)
        : <String, Object?>{};

    if (event == 'ready') {
      _monacoReady = true;
      payload['engine'] = 'monaco';
      payload['webview_engine'] = _useFlutterWebView ? 'flutter' : 'windows';
      widget.sendEvent(widget.controlId, 'ready', payload);
      return;
    }

    if (event == 'change') {
      final value = payload['value']?.toString() ?? '';
      _latestValue = value;
    }

    widget.sendEvent(widget.controlId, event, payload);
  }

  void _emitFallbackChange({bool immediate = false}) {
    if (_fallbackSuppressChange || !widget.emitOnChange) return;
    _debounce?.cancel();
    final text = _fallbackController.text;
    if (immediate || widget.debounceMs <= 0) {
      widget.sendEvent(widget.controlId, 'change', {'value': text});
      return;
    }
    _debounce = Timer(Duration(milliseconds: widget.debounceMs), () {
      widget.sendEvent(widget.controlId, 'change', {'value': text});
    });
  }

  void _emitFallbackSubmit() {
    _debounce?.cancel();
    widget.sendEvent(widget.controlId, 'submit', {
      'value': _fallbackController.text,
      'language': widget.language ?? '',
    });
  }

  Widget _buildFallbackEditor() {
    final lineCount = '\n'.allMatches(_fallbackController.text).length + 1;
    final lineNumbersText = List<String>.generate(
      lineCount,
      (index) => '${index + 1}',
    ).join('\n');

    final editor = TextField(
      controller: _fallbackController,
      focusNode: _fallbackFocusNode,
      autofocus: widget.autofocus,
      readOnly: widget.readOnly,
      maxLines: null,
      minLines: 12,
      scrollController: _fallbackEditorScroll,
      keyboardType: TextInputType.multiline,
      style: TextStyle(
        fontFamily: widget.fontFamily,
        fontSize: widget.fontSize,
        color: widget.textColor,
        height: 1.45,
      ),
      onChanged: (_) {
        _latestValue = _fallbackController.text;
        _emitFallbackChange();
        if (mounted) setState(() {});
      },
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );

    final wrappedEditor = Focus(
      onKeyEvent: (_, event) {
        if (event is! KeyDownEvent) return KeyEventResult.ignored;
        final key = event.logicalKey;
        final ctrl = HardwareKeyboard.instance.isControlPressed;
        if (ctrl && key == LogicalKeyboardKey.enter) {
          _emitFallbackSubmit();
          return KeyEventResult.handled;
        }
        if (ctrl && key == LogicalKeyboardKey.keyS) {
          widget.sendEvent(widget.controlId, 'save', {
            'value': _fallbackController.text,
          });
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: editor,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showGutter && widget.showLineNumbers)
          Container(
            width: 54,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            color: widget.backgroundColor.withValues(alpha: 0.75),
            alignment: Alignment.topRight,
            child: SingleChildScrollView(
              controller: _fallbackGutterScroll,
              physics: const NeverScrollableScrollPhysics(),
              child: Text(
                lineNumbersText,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: widget.fontFamily,
                  fontSize: widget.fontSize - 1,
                  color: widget.textColor.withValues(alpha: 0.55),
                  height: 1.45,
                ),
              ),
            ),
          ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: widget.wordWrap
                ? const NeverScrollableScrollPhysics()
                : const ClampingScrollPhysics(),
            child: SizedBox(
              width: widget.wordWrap ? null : 1200,
              child: wrappedEditor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonacoEditor() {
    if (_useFlutterWebView) {
      final controller = _flutterController;
      if (controller == null) {
        return const SizedBox.shrink();
      }
      return WebViewWidget(controller: controller);
    }
    return Webview(_windowsController);
  }

  @override
  Widget build(BuildContext context) {
    final child = _useMonaco ? _buildMonacoEditor() : _buildFallbackEditor();
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        border: widget.borderWidth > 0
            ? Border.all(color: widget.borderColor, width: widget.borderWidth)
            : null,
        borderRadius: BorderRadius.circular(widget.radius),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

Widget buildCodeEditorControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final value = (props['value'] ?? props['text'] ?? props['code'] ?? '')
      .toString();
  final fontSize = coerceDouble(props['font_size']) ?? 13;
  final fontFamily = props['font_family']?.toString() ?? 'JetBrains Mono';
  final backgroundColor =
      coerceColor(
        props['editor_bg'] ?? props['editor_background'] ?? props['bgcolor'],
      ) ??
      const Color(0xff0b1220);
  final textColor =
      coerceColor(props['editor_text_color'] ?? props['text_color']) ??
      const Color(0xffdbeafe);
  final borderColor =
      coerceColor(props['border_color']) ?? const Color(0xff334155);
  final borderWidth = coerceDouble(props['border_width']) ?? 1.0;
  final radius = coerceDouble(props['radius']) ?? 10.0;

  return ButterflyUICodeEditor(
    controlId: controlId,
    value: value,
    language: props['language']?.toString(),
    theme: props['theme']?.toString(),
    engine: (props['engine'] ?? 'monaco').toString(),
    webviewEngine: (props['webview_engine'] ?? 'windows').toString(),
    readOnly: props['read_only'] == true,
    autofocus: props['auto_focus'] == true || props['autofocus'] == true,
    wordWrap: props['word_wrap'] == true || props['wrap'] == true,
    showLineNumbers: props['line_numbers'] == null
        ? true
        : (props['line_numbers'] == true),
    showGutter: props['show_gutter'] == null
        ? true
        : (props['show_gutter'] == true),
    showMinimap: props['show_minimap'] == true || props['minimap'] == true,
    glyphMargin: props['glyph_margin'] == true ||
        props['show_breakpoints'] == true,
    emitOnChange: props['emit_on_change'] == null
        ? true
        : (props['emit_on_change'] == true),
    debounceMs: (coerceOptionalInt(props['debounce_ms']) ?? 180).clamp(0, 2000),
    tabSize: (coerceOptionalInt(props['tab_size']) ?? 2).clamp(1, 12),
    documentUri: props['document_uri']?.toString(),
    fontSize: fontSize,
    fontFamily: fontFamily,
    backgroundColor: backgroundColor,
    textColor: textColor,
    borderColor: borderColor,
    borderWidth: borderWidth,
    radius: radius,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}
