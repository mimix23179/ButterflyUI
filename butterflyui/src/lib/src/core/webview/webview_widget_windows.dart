import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_windows/webview_windows.dart';

import 'webview_api.dart';

class ButterflyUIWebViewWidget extends StatefulWidget {
  final String controlId;
  final ButterflyUIWebViewProps props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUIWebViewWidget({
    super.key,
    required this.controlId,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<ButterflyUIWebViewWidget> createState() =>
      _ButterflyUIWebViewWidgetState();
}

class _ButterflyUIWebViewWidgetState extends State<ButterflyUIWebViewWidget> {
  final WebviewController _controller = WebviewController();

  StreamSubscription<String>? _urlSub;
  StreamSubscription<String>? _titleSub;
  StreamSubscription<HistoryChanged>? _historySub;
  StreamSubscription<LoadingState>? _loadingStateSub;
  StreamSubscription<WebErrorStatus>? _loadErrorSub;
  StreamSubscription<dynamic>? _messageSub;

  static const String _engine = 'windows';
  String _currentUrl = '';
  String _title = '';
  bool _canGoBack = false;
  bool _canGoForward = false;
  bool _jsDisabled = false;
  bool _readySent = false;
  String? _initializationError;

  @override
  void initState() {
    super.initState();
    _jsDisabled = !widget.props.javascriptEnabled;
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    _startEngineInitialization();
  }

  void _resetNavigationState() {
    _currentUrl = '';
    _title = '';
    _canGoBack = false;
    _canGoForward = false;
    _readySent = false;
  }

  Future<void> _startEngineInitialization() async {
    _initializationError = null;
    _resetNavigationState();

    _clearWindowsSubscriptions();

    try {
      await _initialize();
    } catch (error) {
      _initializationError = error.toString();
      widget.sendEvent(widget.controlId, 'load_error', {
        'engine': _engine,
        'stage': 'initialize',
        'message': error.toString(),
      });
    }

    if (mounted) setState(() {});
  }

  void _clearWindowsSubscriptions() {
    _urlSub?.cancel();
    _titleSub?.cancel();
    _historySub?.cancel();
    _loadingStateSub?.cancel();
    _loadErrorSub?.cancel();
    _messageSub?.cancel();
    _urlSub = null;
    _titleSub = null;
    _historySub = null;
    _loadingStateSub = null;
    _loadErrorSub = null;
    _messageSub = null;
  }

  @override
  void didUpdateWidget(covariant ButterflyUIWebViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controlId != oldWidget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }

    final criticalChanged =
      widget.props.engine != oldWidget.props.engine ||
        widget.props.fallbackEngine != oldWidget.props.fallbackEngine ||
        widget.props.javascriptEnabled != oldWidget.props.javascriptEnabled ||
        widget.props.userAgent != oldWidget.props.userAgent ||
        widget.props.allowPopups != oldWidget.props.allowPopups ||
        widget.props.cacheEnabled != oldWidget.props.cacheEnabled ||
        widget.props.incognito != oldWidget.props.incognito ||
        widget.props.domStorageEnabled != oldWidget.props.domStorageEnabled ||
        widget.props.thirdPartyCookiesEnabled !=
            oldWidget.props.thirdPartyCookiesEnabled ||
        widget.props.allowFileAccess != oldWidget.props.allowFileAccess ||
        widget.props.allowUniversalAccessFromFileUrls !=
            oldWidget.props.allowUniversalAccessFromFileUrls ||
        widget.props.requestHeaders.toString() !=
            oldWidget.props.requestHeaders.toString();
    if (criticalChanged) {
      _jsDisabled = !widget.props.javascriptEnabled;
      _startEngineInitialization();
      setState(() {});
      return;
    }

    final htmlChanged =
        widget.props.html != oldWidget.props.html ||
        widget.props.baseUrl != oldWidget.props.baseUrl;
    if (htmlChanged && widget.props.html.isNotEmpty) {
      _loadHtml(widget.props.html, widget.props.baseUrl);
    } else if (widget.props.html.isEmpty &&
        widget.props.url != oldWidget.props.url &&
        widget.props.url.isNotEmpty) {
      _controller.loadUrl(widget.props.url);
    }
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    _clearWindowsSubscriptions();
    // ignore: discarded_futures
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    _readySent = false;
    _clearWindowsSubscriptions();
    if (!_controller.value.isInitialized) {
      await _controller.initialize().timeout(
        Duration(milliseconds: widget.props.initTimeoutMs),
      );
    }

    final userAgent = widget.props.userAgent;
    if (userAgent != null && userAgent.trim().isNotEmpty) {
      try {
        await _controller.setUserAgent(userAgent);
      } catch (_) {}
    }

    try {
      await _controller.setPopupWindowPolicy(
        widget.props.allowPopups
            ? WebviewPopupWindowPolicy.sameWindow
            : WebviewPopupWindowPolicy.deny,
      );
    } catch (_) {}

    try {
      await _controller.setCacheDisabled(!widget.props.cacheEnabled);
      if (widget.props.clearCacheOnStart) {
        await _controller.clearCache();
      }
    } catch (_) {}

    _loadingStateSub = _controller.loadingState.listen((state) {
      widget.sendEvent(widget.controlId, 'load_state', {
        'state': state.name,
        'engine': _engine,
      });
      if (state == LoadingState.loading) {
        widget.sendEvent(widget.controlId, 'load_start', {
          'url': _currentUrl,
          'engine': _engine,
        });
      } else if (state == LoadingState.navigationCompleted) {
        widget.sendEvent(widget.controlId, 'progress', {
          'progress': 100,
          'engine': _engine,
        });
        widget.sendEvent(widget.controlId, 'load_stop', {
          'url': _currentUrl,
          'engine': _engine,
        });
      }
    });

    _loadErrorSub = _controller.onLoadError.listen((error) {
      widget.sendEvent(widget.controlId, 'load_error', {
        'code': error.index,
        'type': error.name,
        'url': _currentUrl,
        'engine': _engine,
      });
      if (mounted) setState(() {});
    });

    if (widget.props.clearCacheOnStart) {
      try {
        await _controller.clearCookies();
      } catch (_) {}
    }

    _urlSub = _controller.url.listen((url) {
      _currentUrl = url;
      widget.sendEvent(widget.controlId, 'navigation', {'url': url});
      if (!_readySent) {
        _readySent = true;
        widget.sendEvent(widget.controlId, 'ready', {'url': url});
      }
      if (mounted) setState(() {});
    });
    _titleSub = _controller.title.listen((t) {
      _title = t;
      widget.sendEvent(widget.controlId, 'title', {'title': t});
      if (mounted) setState(() {});
    });
    _historySub = _controller.historyChanged.listen((h) {
      _canGoBack = h.canGoBack;
      _canGoForward = h.canGoForward;
      widget.sendEvent(widget.controlId, 'history', {
        'canGoBack': h.canGoBack,
        'canGoForward': h.canGoForward,
      });
      if (mounted) setState(() {});
    });
    _messageSub = _controller.webMessage.listen(_handleWebMessage);

    final html = widget.props.html;
    final url = widget.props.url;
    if (html.isNotEmpty) {
      await _loadHtml(html, widget.props.baseUrl);
    } else if (url.isNotEmpty) {
      widget.sendEvent(widget.controlId, 'load_start', {'url': url});
      await _controller.loadUrl(url);
    }

    // Fallback if navigation events did not arrive yet.
    if (!_readySent) {
      _readySent = true;
      widget.sendEvent(widget.controlId, 'ready', {'url': url});
    }

    if (mounted) setState(() {});
  }

  static int _toInt(Object? value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String _injectBaseTag(String html, String baseUrl) {
    final normalized = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
    const headOpen = '<head>';

    if (html.contains('<base')) return html;

    if (html.contains(headOpen)) {
      return html.replaceFirst(headOpen, '$headOpen<base href="$normalized">');
    }

    return '<head><base href="$normalized"></head>$html';
  }

  Future<void> _loadHtml(String html, String? baseUrl) async {
    var content = html;
    if (baseUrl != null && baseUrl.isNotEmpty) {
      content = _injectBaseTag(content, baseUrl);
    }
    await _controller.loadStringContent(content);
  }

  static Map<String, String> _coerceHeaders(Object? value) {
    final out = <String, String>{};
    if (value is! Map) return out;
    for (final entry in value.entries) {
      final key = entry.key.toString().trim();
      if (key.isEmpty) continue;
      out[key] = entry.value?.toString() ?? '';
    }
    return out;
  }

  void _handleWebMessage(dynamic message) {
    Object? payload = message;
    if (message is String) {
      try {
        payload = jsonDecode(message);
      } catch (_) {
        payload = message;
      }
    }
    widget.sendEvent(widget.controlId, 'message', {'data': payload});
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    // Handle invoke methods for WebView

    switch (method) {
      case 'reload':
        await _controller.reload();
        return null;

      case 'can_go_back':
        return _canGoBack;

      case 'can_go_forward':
        return _canGoForward;

      case 'go_back':
        if (_canGoBack) await _controller.goBack();
        return null;

      case 'go_forward':
        if (_canGoForward) await _controller.goForward();
        return null;

      case 'clear_cache':
        await _controller.clearCache();
        return null;

      case 'clear_local_storage':
        await _controller.executeScript(
          'try{localStorage.clear();sessionStorage.clear();}catch(e){}',
        );
        return null;

      case 'get_current_url':
        return _currentUrl.isEmpty ? null : _currentUrl;

      case 'get_title':
        return _title.isEmpty ? null : _title;

      case 'get_user_agent':
        // webview_windows exposes setUserAgent, but not a reliable getter.
        return widget.props.userAgent;

      case 'load_file': {
        final path = args['path']?.toString() ?? '';
        if (path.isEmpty) return null;

        final uri = path.startsWith('file:')
            ? path
            : Uri.file(path, windows: true).toString();

        if (_isPreventedUrl(uri)) {
          widget.sendEvent(widget.controlId, 'blocked_navigation', {'url': uri});
          return null;
        }

        await _controller.loadUrl(uri);
        return null;
      }

      case 'load_request': {
        final url = args['url']?.toString() ?? '';
        if (url.isEmpty) return null;

        final headers = _coerceHeaders(args['headers']);

        if (_isPreventedUrl(url)) {
          widget.sendEvent(widget.controlId, 'blocked_navigation', {'url': url});
          return null;
        }

        if (_isExternalScheme(url)) {
          widget.sendEvent(
            widget.controlId,
            widget.props.openExternalLinks
                ? 'external_navigation'
                : 'blocked_navigation',
            {'url': url},
          );
          return null;
        }

        if (headers.isNotEmpty) {
          widget.sendEvent(widget.controlId, 'header_ignored', {
            'url': url,
            'reason': 'webview_windows does not support per-request headers',
            'engine': _engine,
          });
        }

        await _controller.loadUrl(url);
        return null;
      }

      case 'set_user_agent': {
        final userAgent = args['value']?.toString() ?? '';
        if (userAgent.isEmpty) return null;
        await _controller.setUserAgent(userAgent);
        return null;
      }

      case 'open_devtools':
        await _controller.openDevTools();
        return null;

      case 'set_popup_policy': {
        final policy = args['value']?.toString().toLowerCase() ?? 'deny';
        final mapped = policy == 'allow'
            ? WebviewPopupWindowPolicy.allow
            : policy == 'same_window' || policy == 'samewindow'
                ? WebviewPopupWindowPolicy.sameWindow
                : WebviewPopupWindowPolicy.deny;
        await _controller.setPopupWindowPolicy(mapped);
        return null;
      }

      case 'run_javascript': {
        if (_jsDisabled) return null;
        final script = args['value']?.toString() ?? '';
        if (script.isEmpty) return null;
        await _controller.executeScript(script);
        return null;
      }

      case 'load_html': {
        var html = args['value']?.toString() ?? '';
        final baseUrl = args['base_url']?.toString();
        if (baseUrl != null && baseUrl.isNotEmpty) {
          html = _injectBaseTag(html, baseUrl);
        }
        await _controller.loadStringContent(html);
        return null;
      }

      case 'scroll_to': {
        final x = _toInt(args['x']);
        final y = _toInt(args['y']);
        await _controller.executeScript('window.scrollTo($x,$y);');
        return null;
      }

      case 'scroll_by': {
        final x = _toInt(args['x']);
        final y = _toInt(args['y']);
        await _controller.executeScript('window.scrollBy($x,$y);');
        return null;
      }

      case 'scroll_to_start':
        await _controller.executeScript('window.scrollTo(0,0);');
        return null;

      case 'scroll_to_end':
        await _controller.executeScript(
          'try{window.scrollTo(0,Math.max(document.body.scrollHeight,document.documentElement.scrollHeight));}catch(e){window.scrollTo(0,0);}',
        );
        return null;

      case 'get_scroll_metrics':
        // webview_windows does not reliably support returning JS evaluation results.
        return null;

      case 'set_javascript_mode': {
        final mode = args['mode']?.toString() ?? '';
        _jsDisabled = (mode == 'disabled');
        await _startEngineInitialization();
        return null;
      }

      default:
        throw UnsupportedError('Unknown webview method: $method');
    }
  }

  bool _isPreventedUrl(String url) {
    if (url.isEmpty) return false;
    final prevent = widget.props.preventLinks;
    if (prevent.isEmpty) return false;
    for (final pattern in prevent) {
      if (pattern.isEmpty) continue;
      if (url.startsWith(pattern) || url.contains(pattern)) return true;
    }
    return false;
  }

  bool _isExternalScheme(String url) {
    Uri? uri;
    try {
      uri = Uri.parse(url);
    } catch (_) {
      return false;
    }
    final scheme = uri.scheme.toLowerCase();
    if (scheme.isEmpty) return false;
    return scheme != 'http' &&
        scheme != 'https' &&
        scheme != 'file' &&
        scheme != 'about' &&
        scheme != 'data' &&
        scheme != 'javascript';
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return _buildLoaderOrError();
    }

    return SizedBox.expand(child: Webview(_controller));
  }

  Widget _buildLoaderOrError() {
    final error = _initializationError;
    if (error == null || error.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded, size: 28),
            const SizedBox(height: 8),
            Text(
              'WebView initialization failed ($_engine)',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(error, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                _startEngineInitialization();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
