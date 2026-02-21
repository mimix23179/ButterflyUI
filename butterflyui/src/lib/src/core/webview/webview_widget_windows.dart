import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_windows/webview_windows.dart';

import 'webview_api.dart';

const Map<int, String> _httpStatusReasons = {
  400: 'Bad Request',
  401: 'Unauthorized',
  403: 'Forbidden',
  404: 'Not Found',
  405: 'Method Not Allowed',
  408: 'Request Timeout',
  409: 'Conflict',
  410: 'Gone',
  413: 'Payload Too Large',
  415: 'Unsupported Media Type',
  418: "I'm a teapot",
  422: 'Unprocessable Entity',
  429: 'Too Many Requests',
  500: 'Internal Server Error',
  501: 'Not Implemented',
  502: 'Bad Gateway',
  503: 'Service Unavailable',
  504: 'Gateway Timeout',
};

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
  State<ButterflyUIWebViewWidget> createState() => _ButterflyUIWebViewWidgetState();
}

class _ButterflyUIWebViewWidgetState extends State<ButterflyUIWebViewWidget> {
  final WebviewController _controller = WebviewController();
  InAppWebViewController? _inAppController;
  WebViewController? _flutterController;

  StreamSubscription<String>? _urlSub;
  StreamSubscription<String>? _titleSub;
  StreamSubscription<HistoryChanged>? _historySub;
  StreamSubscription<LoadingState>? _loadingStateSub;
  StreamSubscription<WebErrorStatus>? _loadErrorSub;
  StreamSubscription<dynamic>? _messageSub;

  late String _engine;
  String _currentUrl = '';
  String _title = '';
  bool _canGoBack = false;
  bool _canGoForward = false;
  bool _jsDisabled = false;
  bool _readySent = false;
  String? _initializationError;
  final Set<String> _failedEngines = <String>{};

  bool get _useInApp => _engine == 'inapp';
  bool get _useFlutter {
    final engine = _engine;
    if (engine == 'flutter' || engine == 'webview_flutter') return true;
    if (!Platform.isWindows &&
        engine != 'windows' &&
        engine != 'webview_windows') {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _engine = _normalizeEngine(widget.props.engine);
    _jsDisabled = !widget.props.javascriptEnabled;
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    _startEngineInitialization();
  }

  String _normalizeEngine(String engine) {
    final value = engine.trim().toLowerCase();
    if (value == 'inapp') return 'inapp';
    if (value == 'flutter' || value == 'webview_flutter') return 'flutter';
    if (value == 'windows' || value == 'webview_windows') return 'windows';
    if (!Platform.isWindows) return 'flutter';
    return 'windows';
  }

  bool _isKnownEngine(String value) {
    final normalized = value.trim().toLowerCase();
    return normalized == 'windows' ||
        normalized == 'webview_windows' ||
        normalized == 'inapp' ||
        normalized == 'flutter' ||
        normalized == 'webview_flutter';
  }

  void _resetNavigationState() {
    _currentUrl = '';
    _title = '';
    _canGoBack = false;
    _canGoForward = false;
    _readySent = false;
  }

  Future<void> _startEngineInitialization({bool asFallback = false}) async {
    _initializationError = null;
    _resetNavigationState();
    if (_useInApp) {
      _clearWindowsSubscriptions();
      _flutterController = null;
      if (widget.props.clearCacheOnStart) {
        try {
          await InAppWebViewController.clearAllCache();
        } catch (_) {}
      }
      if (mounted) setState(() {});
      _failedEngines.remove(_engine);
      return;
    }
    if (_useFlutter) {
      _clearWindowsSubscriptions();
      _inAppController = null;
      try {
        await _initializeFlutter();
        _failedEngines.remove(_engine);
      } catch (error) {
        _initializationError = error.toString();
        _failedEngines.add(_engine);
        widget.sendEvent(widget.controlId, 'load_error', {
          'engine': _engine,
          'stage': 'initialize',
          'message': error.toString(),
        });
        if (!asFallback && await _attemptFallback('initialize_failed', error)) {
          return;
        }
        if (mounted) setState(() {});
      }
      return;
    }
    _inAppController = null;
    _flutterController = null;
    try {
      await _initialize();
      _failedEngines.remove(_engine);
    } catch (error) {
      _initializationError = error.toString();
      _failedEngines.add(_engine);
      widget.sendEvent(widget.controlId, 'load_error', {
        'engine': _engine,
        'stage': 'initialize',
        'message': error.toString(),
      });
      if (!asFallback && await _attemptFallback('initialize_failed', error)) {
        return;
      }
      if (mounted) setState(() {});
    }
  }

  Future<bool> _attemptFallback(String reason, Object error) async {
    final candidates = <String>[];
    final explicitFallback = widget.props.fallbackEngine.trim().toLowerCase();
    if (explicitFallback.isNotEmpty && _isKnownEngine(explicitFallback)) {
      candidates.add(explicitFallback);
    } else {
      // Automatic fallback chain so unsupported engines recover without
      // requiring per-control fallback configuration.
      if (_engine == 'windows') {
        candidates.addAll(const ['inapp', 'flutter']);
      } else if (_engine == 'inapp') {
        if (Platform.isWindows) {
          candidates.addAll(const ['flutter', 'windows']);
        } else {
          candidates.add('flutter');
        }
      } else {
        // flutter/webview_flutter
        if (Platform.isWindows) {
          candidates.addAll(const ['inapp', 'windows']);
        } else {
          candidates.add('inapp');
        }
      }
    }

    for (final candidateRaw in candidates) {
      final candidate = _normalizeEngine(candidateRaw);
      if (candidate == _engine) continue;
      if (_failedEngines.contains(candidate)) continue;
      final previous = _engine;
      _engine = candidate;
      widget.sendEvent(widget.controlId, 'engine_fallback', {
        'from': previous,
        'to': candidate,
        'reason': reason,
        'error': error.toString(),
      });
      if (mounted) setState(() {});
      await _startEngineInitialization(asFallback: true);
      if (_initializationError == null || _initializationError!.isEmpty) {
        return true;
      }
    }
    return false;
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

    final newEngine = _normalizeEngine(widget.props.engine);
    final oldEngine = _normalizeEngine(oldWidget.props.engine);
    final criticalChanged =
        newEngine != oldEngine ||
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
      _engine = newEngine;
      _jsDisabled = !widget.props.javascriptEnabled;
      _startEngineInitialization();
      setState(() {});
      return;
    }

    final htmlChanged =
        widget.props.html != oldWidget.props.html ||
        widget.props.baseUrl != oldWidget.props.baseUrl;
    if (_useInApp) {
      if (htmlChanged && widget.props.html.isNotEmpty) {
        _loadInAppHtml(widget.props.html, widget.props.baseUrl);
      } else if (widget.props.html.isEmpty &&
          widget.props.url != oldWidget.props.url &&
          widget.props.url.isNotEmpty) {
        _loadInAppUrl(widget.props.url, headers: widget.props.requestHeaders);
      }
    } else if (_useFlutter) {
      if (htmlChanged && widget.props.html.isNotEmpty) {
        _loadFlutterHtml(widget.props.html, widget.props.baseUrl);
      } else if (widget.props.html.isEmpty &&
          widget.props.url != oldWidget.props.url &&
          widget.props.url.isNotEmpty) {
        _flutterController?.loadRequest(
          Uri.parse(widget.props.url),
          headers: widget.props.requestHeaders,
        );
      }
    } else {
      if (htmlChanged && widget.props.html.isNotEmpty) {
        _loadHtml(widget.props.html, widget.props.baseUrl);
      } else if (widget.props.html.isEmpty &&
          widget.props.url != oldWidget.props.url &&
          widget.props.url.isNotEmpty) {
        _controller.loadUrl(widget.props.url);
      }
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

  Future<void> _initializeFlutter() async {
    _readySent = false;
    final controller = WebViewController();
    _flutterController = controller;

    await controller.setJavaScriptMode(
      _jsDisabled ? JavaScriptMode.disabled : JavaScriptMode.unrestricted,
    );
    await controller.setUserAgent(widget.props.userAgent);

    final bg = widget.props.bgcolor;
    if (bg is Color) {
      await controller.setBackgroundColor(bg);
    }
    if (widget.props.clearCacheOnStart) {
      try {
        await controller.clearCache();
        await controller.clearLocalStorage();
      } catch (_) {}
    }

    await controller.setNavigationDelegate(
      NavigationDelegate(
        onNavigationRequest: (request) {
          if (_isPreventedUrl(request.url)) {
            widget.sendEvent(widget.controlId, 'blocked_navigation', {
              'url': request.url,
              'engine': _engine,
            });
            return NavigationDecision.prevent;
          }
          if (_isExternalScheme(request.url)) {
            widget.sendEvent(
              widget.controlId,
              widget.props.openExternalLinks
                  ? 'external_navigation'
                  : 'blocked_navigation',
              {'url': request.url, 'engine': _engine},
            );
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
        onProgress: (progress) {
          widget.sendEvent(widget.controlId, 'progress', {
            'progress': progress,
            'engine': _engine,
          });
        },
        onPageStarted: (url) {
          _currentUrl = url;
          widget.sendEvent(widget.controlId, 'load_start', {
            'url': url,
            'engine': _engine,
          });
          widget.sendEvent(widget.controlId, 'navigation', {'url': url});
        },
        onPageFinished: (url) async {
          _currentUrl = url;
          _title = await controller.getTitle() ?? '';
          _canGoBack = await controller.canGoBack();
          _canGoForward = await controller.canGoForward();
          widget.sendEvent(widget.controlId, 'navigation', {'url': url});
          widget.sendEvent(widget.controlId, 'title', {'title': _title});
          widget.sendEvent(widget.controlId, 'history', {
            'canGoBack': _canGoBack,
            'canGoForward': _canGoForward,
          });
          widget.sendEvent(widget.controlId, 'load_stop', {
            'url': url,
            'engine': _engine,
          });
          if (!_readySent) {
            _readySent = true;
            widget.sendEvent(widget.controlId, 'ready', {'url': url});
          }
          if (mounted) setState(() {});
        },
        onWebResourceError: (error) {
          widget.sendEvent(widget.controlId, 'load_error', {
            'code': error.errorCode,
            'type': error.errorType?.name ?? 'unknown',
            'description': error.description,
            'url': error.url ?? _currentUrl,
            'is_main_frame': error.isForMainFrame,
            'engine': _engine,
          });
          if (mounted) setState(() {});
        },
        onHttpError: (error) {
          final response = error.response;
          final status = response?.statusCode;
          final reason = response == null
              ? null
              : _httpStatusReasons[status] ?? 'HTTP $status';
          widget.sendEvent(widget.controlId, 'http_error', {
            'url': error.request?.uri.toString() ?? response?.uri?.toString(),
            'status_code': status,
            'reason': reason,
            'engine': _engine,
          });
        },
      ),
    );

    if (!_jsDisabled) {
      await controller.addJavaScriptChannel(
        'ButterflyUI',
        onMessageReceived: (message) {
          _handleWebMessage(message.message);
        },
      );
    }

    final html = widget.props.html;
    final url = widget.props.url;
    if (html.isNotEmpty) {
      await _loadFlutterHtml(html, widget.props.baseUrl);
    } else if (url.isNotEmpty) {
      widget.sendEvent(widget.controlId, 'load_start', {'url': url});
      await controller.loadRequest(
        Uri.parse(url),
        headers: widget.props.requestHeaders,
      );
    } else {
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

  Future<void> _loadInAppHtml(String html, String? baseUrl) async {
    final controller = _inAppController;
    if (controller == null) return;
    final content = baseUrl != null && baseUrl.isNotEmpty
        ? _injectBaseTag(html, baseUrl)
        : html;
    await controller.loadData(
      data: content,
      baseUrl: baseUrl != null ? WebUri(baseUrl) : null,
    );
  }

  Future<void> _loadFlutterHtml(String html, String? baseUrl) async {
    final controller = _flutterController;
    if (controller == null) return;
    final content = baseUrl != null && baseUrl.isNotEmpty
        ? _injectBaseTag(html, baseUrl)
        : html;
    await controller.loadHtmlString(content, baseUrl: baseUrl);
  }

  Future<void> _loadInAppUrl(String url, {Map<String, String>? headers}) async {
    final controller = _inAppController;
    if (controller == null) return;
    await controller.loadUrl(
      urlRequest: URLRequest(url: WebUri(url), headers: headers),
    );
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

  void _handleInAppMessage(List<dynamic> args) {
    if (args.isEmpty) return;
    _handleWebMessage(args.first);
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    if (_useInApp) {
      return _handleInAppInvoke(method, args);
    }
    if (_useFlutter) {
      return _handleFlutterInvoke(method, args);
    }
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
        return widget.props.userAgent;
      case 'load_file':
        final path = args['path']?.toString() ?? '';
        if (path.isEmpty) return null;
        final uri = path.startsWith('file:')
            ? path
            : Uri.file(path, windows: true).toString();
        await _controller.loadUrl(uri);
        return null;
      case 'load_request':
        final url = args['url']?.toString() ?? '';
        if (url.isEmpty) return null;
        if (_isPreventedUrl(url)) {
          widget.sendEvent(widget.controlId, 'blocked_navigation', {
            'url': url,
          });
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
        await _controller.loadUrl(url);
        return null;
      case 'set_user_agent':
        final userAgent = args['value']?.toString() ?? '';
        if (userAgent.isEmpty) return null;
        await _controller.setUserAgent(userAgent);
        return null;
      case 'open_devtools':
        await _controller.openDevTools();
        return null;
      case 'set_popup_policy':
        final policy = args['value']?.toString().toLowerCase() ?? 'deny';
        final mapped = policy == 'allow'
            ? WebviewPopupWindowPolicy.allow
            : policy == 'same_window' || policy == 'samewindow'
            ? WebviewPopupWindowPolicy.sameWindow
            : WebviewPopupWindowPolicy.deny;
        await _controller.setPopupWindowPolicy(mapped);
        return null;
      case 'run_javascript':
        if (_jsDisabled) return null;
        final script = args['value']?.toString() ?? '';
        if (script.isEmpty) return null;
        await _controller.executeScript(script);
        return null;
      case 'load_html':
        var html = args['value']?.toString() ?? '';
        final baseUrl = args['base_url']?.toString();
        if (baseUrl != null && baseUrl.isNotEmpty) {
          html = _injectBaseTag(html, baseUrl);
        }
        await _controller.loadStringContent(html);
        return null;
      case 'scroll_to':
        final x = _toInt(args['x']);
        final y = _toInt(args['y']);
        await _controller.executeScript('window.scrollTo($x,$y);');
        return null;
      case 'scroll_by':
        final x = _toInt(args['x']);
        final y = _toInt(args['y']);
        await _controller.executeScript('window.scrollBy($x,$y);');
        return null;
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
        // Best-effort: return null.
        return null;
      case 'set_javascript_mode':
        final mode = args['mode']?.toString() ?? '';
        _jsDisabled = (mode == 'disabled');
        return null;
      default:
        throw UnsupportedError('Unknown webview method: $method');
    }
  }

  Future<Object?> _handleFlutterInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    final controller = _flutterController;
    switch (method) {
      case 'reload':
        await controller?.reload();
        return null;
      case 'can_go_back':
        return await controller?.canGoBack() ?? false;
      case 'can_go_forward':
        return await controller?.canGoForward() ?? false;
      case 'go_back':
        if (await controller?.canGoBack() ?? false) {
          await controller?.goBack();
        }
        return null;
      case 'go_forward':
        if (await controller?.canGoForward() ?? false) {
          await controller?.goForward();
        }
        return null;
      case 'clear_cache':
        await controller?.clearCache();
        return null;
      case 'clear_local_storage':
        await controller?.runJavaScript(
          'try{localStorage.clear();sessionStorage.clear();}catch(e){}',
        );
        return null;
      case 'get_current_url':
        return await controller?.currentUrl();
      case 'get_title':
        return await controller?.getTitle();
      case 'get_user_agent':
        return widget.props.userAgent;
      case 'load_file':
        final path = args['path']?.toString() ?? '';
        if (path.isEmpty) return null;
        final uri = path.startsWith('file:')
            ? Uri.parse(path)
            : Uri.file(path, windows: Platform.isWindows);
        await controller?.loadRequest(uri);
        return null;
      case 'load_request':
        final url = args['url']?.toString() ?? '';
        if (url.isEmpty) return null;
        if (_isPreventedUrl(url)) {
          widget.sendEvent(widget.controlId, 'blocked_navigation', {
            'url': url,
          });
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
        final headers = _coerceHeaders(args['headers']);
        await controller?.loadRequest(Uri.parse(url), headers: headers);
        return null;
      case 'set_user_agent':
        await controller?.setUserAgent(args['value']?.toString());
        return null;
      case 'open_devtools':
        return null;
      case 'set_popup_policy':
        return null;
      case 'run_javascript':
        if (_jsDisabled) return null;
        final script = args['value']?.toString() ?? '';
        if (script.isEmpty) return null;
        await controller?.runJavaScript(script);
        return null;
      case 'load_html':
        var html = args['value']?.toString() ?? '';
        final baseUrl = args['base_url']?.toString();
        if (baseUrl != null && baseUrl.isNotEmpty) {
          html = _injectBaseTag(html, baseUrl);
        }
        await controller?.loadHtmlString(html, baseUrl: baseUrl);
        return null;
      case 'scroll_to':
        final x = _toInt(args['x']);
        final y = _toInt(args['y']);
        await controller?.scrollTo(x, y);
        return null;
      case 'scroll_by':
        final x = _toInt(args['x']);
        final y = _toInt(args['y']);
        await controller?.scrollBy(x, y);
        return null;
      case 'scroll_to_start':
        await controller?.scrollTo(0, 0);
        return null;
      case 'scroll_to_end':
        await controller?.runJavaScript(
          'try{window.scrollTo(0,Math.max(document.body.scrollHeight,document.documentElement.scrollHeight));}catch(e){window.scrollTo(0,0);}',
        );
        return null;
      case 'get_scroll_metrics':
        if (_jsDisabled) return null;
        final result = await controller?.runJavaScriptReturningResult(
          'try{JSON.stringify({x:window.scrollX||0,y:window.scrollY||0,viewport_width:window.innerWidth||0,viewport_height:window.innerHeight||0,doc_width:Math.max(document.body.scrollWidth,document.documentElement.scrollWidth),doc_height:Math.max(document.body.scrollHeight,document.documentElement.scrollHeight)})}catch(e){null}',
        );
        if (result == null) return null;
        if (result is Map) return Map<String, Object?>.from(result);
        var s = result.toString();
        if (s.startsWith('"') && s.endsWith('"') && s.length >= 2) {
          s = s.substring(1, s.length - 1).replaceAll(r'\"', '"');
        }
        if (s.isEmpty || s == 'null') return null;
        try {
          final decoded = jsonDecode(s);
          if (decoded is Map) {
            return Map<String, Object?>.from(decoded);
          }
        } catch (_) {}
        return s;
      case 'set_javascript_mode':
        final mode = args['mode']?.toString() ?? '';
        _jsDisabled = (mode == 'disabled');
        await controller?.setJavaScriptMode(
          _jsDisabled ? JavaScriptMode.disabled : JavaScriptMode.unrestricted,
        );
        return null;
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

  Future<Object?> _handleInAppInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    final controller = _inAppController;
    switch (method) {
      case 'reload':
        await controller?.reload();
        return null;
      case 'can_go_back':
        return await controller?.canGoBack() ?? false;
      case 'can_go_forward':
        return await controller?.canGoForward() ?? false;
      case 'go_back':
        if (await controller?.canGoBack() ?? false) {
          await controller?.goBack();
        }
        return null;
      case 'go_forward':
        if (await controller?.canGoForward() ?? false) {
          await controller?.goForward();
        }
        return null;
      case 'clear_cache':
        await InAppWebViewController.clearAllCache();
        return null;
      case 'clear_local_storage':
        await controller?.evaluateJavascript(
          source: 'try{localStorage.clear();sessionStorage.clear();}catch(e){}',
        );
        return null;
      case 'get_current_url':
        return (await controller?.getUrl())?.toString();
      case 'get_title':
        return await controller?.getTitle();
      case 'get_user_agent':
        final settings = await controller?.getSettings();
        return settings?.userAgent;
      case 'load_file':
        final path = args['path']?.toString() ?? '';
        if (path.isEmpty) return null;
        final uri = path.startsWith('file:')
            ? path
            : Uri.file(path, windows: true).toString();
        await controller?.loadUrl(urlRequest: URLRequest(url: WebUri(uri)));
        return null;
      case 'load_request':
        final url = args['url']?.toString() ?? '';
        if (url.isEmpty) return null;
        if (_isPreventedUrl(url)) {
          widget.sendEvent(widget.controlId, 'blocked_navigation', {
            'url': url,
          });
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
        final headers = _coerceHeaders(args['headers']);
        await controller?.loadUrl(
          urlRequest: URLRequest(url: WebUri(url), headers: headers),
        );
        return null;
      case 'set_user_agent':
        final userAgent = args['value']?.toString() ?? '';
        await controller?.setSettings(
          settings: InAppWebViewSettings(userAgent: userAgent),
        );
        return null;
      case 'open_devtools':
        return null;
      case 'set_popup_policy':
        final policy = args['value']?.toString().toLowerCase() ?? 'deny';
        final allow = policy == 'allow' || policy == 'same_window';
        await controller?.setSettings(
          settings: InAppWebViewSettings(
            supportMultipleWindows: allow,
            javaScriptCanOpenWindowsAutomatically: allow,
          ),
        );
        return null;
      case 'run_javascript':
        if (_jsDisabled) return null;
        final script = args['value']?.toString() ?? '';
        if (script.isEmpty) return null;
        await controller?.evaluateJavascript(source: script);
        return null;
      case 'load_html':
        var html = args['value']?.toString() ?? '';
        final baseUrl = args['base_url']?.toString();
        if (baseUrl != null && baseUrl.isNotEmpty) {
          html = _injectBaseTag(html, baseUrl);
        }
        await controller?.loadData(
          data: html,
          baseUrl: baseUrl != null ? WebUri(baseUrl) : null,
        );
        return null;
      case 'scroll_to':
        final x = _toInt(args['x']);
        final y = _toInt(args['y']);
        await controller?.evaluateJavascript(source: 'window.scrollTo($x,$y);');
        return null;
      case 'scroll_by':
        final x = _toInt(args['x']);
        final y = _toInt(args['y']);
        await controller?.evaluateJavascript(source: 'window.scrollBy($x,$y);');
        return null;
      case 'scroll_to_start':
        await controller?.evaluateJavascript(source: 'window.scrollTo(0,0);');
        return null;
      case 'scroll_to_end':
        await controller?.evaluateJavascript(
          source:
              'try{window.scrollTo(0,Math.max(document.body.scrollHeight,document.documentElement.scrollHeight));}catch(e){window.scrollTo(0,0);}',
        );
        return null;
      case 'get_scroll_metrics':
        if (_jsDisabled) return null;
        final result = await controller?.evaluateJavascript(
          source:
              'try{JSON.stringify({x:window.scrollX||0,y:window.scrollY||0,viewport_width:window.innerWidth||0,viewport_height:window.innerHeight||0,doc_width:Math.max(document.body.scrollWidth,document.documentElement.scrollWidth),doc_height:Math.max(document.body.scrollHeight,document.documentElement.scrollHeight)})}catch(e){null}',
        );
        if (result == null) return null;
        // InAppWebView may return a JSON string or a decoded object depending on platform.
        if (result is Map) return Map<String, Object?>.from(result);
        var s = result.toString();
        if (s.startsWith('"') && s.endsWith('"') && s.length >= 2) {
          s = s.substring(1, s.length - 1).replaceAll(r'\"', '"');
        }
        if (s.isEmpty || s == 'null') return null;
        try {
          final decoded = jsonDecode(s);
          if (decoded is Map) {
            return Map<String, Object?>.from(decoded);
          }
        } catch (_) {}
        return s;
      case 'set_javascript_mode':
        final mode = args['mode']?.toString() ?? '';
        _jsDisabled = (mode == 'disabled');
        await controller?.setSettings(
          settings: InAppWebViewSettings(javaScriptEnabled: !_jsDisabled),
        );
        return null;
      default:
        throw UnsupportedError('Unknown webview method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_useInApp) {
      final html = widget.props.html;
      final url = widget.props.url;
      final initialData = html.isNotEmpty
          ? InAppWebViewInitialData(
              data:
                  widget.props.baseUrl != null &&
                      widget.props.baseUrl!.isNotEmpty
                  ? _injectBaseTag(html, widget.props.baseUrl!)
                  : html,
              baseUrl: widget.props.baseUrl != null
                  ? WebUri(widget.props.baseUrl!)
                  : null,
            )
          : null;
      final initialUrlRequest = html.isEmpty && url.isNotEmpty
          ? URLRequest(url: WebUri(url), headers: widget.props.requestHeaders)
          : null;

      return InAppWebView(
        initialData: initialData,
        initialUrlRequest: initialUrlRequest,
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: !_jsDisabled,
          javaScriptCanOpenWindowsAutomatically: widget.props.allowPopups,
          mediaPlaybackRequiresUserGesture:
              widget.props.mediaPlaybackRequiresUserGesture,
          allowsInlineMediaPlayback: widget.props.allowsInlineMediaPlayback,
          transparentBackground: widget.props.bgcolor == null,
          userAgent: widget.props.userAgent ?? '',
          cacheEnabled: widget.props.cacheEnabled,
          clearCache: widget.props.clearCacheOnStart,
          incognito: widget.props.incognito,
          domStorageEnabled: widget.props.domStorageEnabled,
          thirdPartyCookiesEnabled: widget.props.thirdPartyCookiesEnabled,
          allowFileAccess: widget.props.allowFileAccess,
          allowUniversalAccessFromFileURLs:
              widget.props.allowUniversalAccessFromFileUrls,
          supportMultipleWindows: widget.props.allowPopups,
          useShouldOverrideUrlLoading: true,
        ),
        onWebViewCreated: (controller) {
          _inAppController = controller;
          if (!_jsDisabled) {
            controller.addJavaScriptHandler(
              handlerName: 'butterflyui',
              callback: _handleInAppMessage,
            );
          }
        },
        shouldOverrideUrlLoading: (controller, action) async {
          final nextUrl = action.request.url?.toString() ?? '';
          if (_isPreventedUrl(nextUrl)) {
            widget.sendEvent(widget.controlId, 'blocked_navigation', {
              'url': nextUrl,
              'engine': _engine,
            });
            return NavigationActionPolicy.CANCEL;
          }
          if (_isExternalScheme(nextUrl)) {
            widget.sendEvent(
              widget.controlId,
              widget.props.openExternalLinks
                  ? 'external_navigation'
                  : 'blocked_navigation',
              {'url': nextUrl, 'engine': _engine},
            );
            return NavigationActionPolicy.CANCEL;
          }
          return NavigationActionPolicy.ALLOW;
        },
        onLoadStart: (controller, uri) {
          _currentUrl = uri?.toString() ?? '';
          widget.sendEvent(widget.controlId, 'load_start', {
            'url': _currentUrl,
            'engine': _engine,
          });
          widget.sendEvent(widget.controlId, 'navigation', {
            'url': _currentUrl,
          });
        },
        onProgressChanged: (controller, progress) {
          widget.sendEvent(widget.controlId, 'progress', {
            'progress': progress,
            'engine': _engine,
          });
        },
        onReceivedError: (controller, request, error) {
          widget.sendEvent(widget.controlId, 'load_error', {
            'url': request.url.toString(),
            'code': error.type.toNativeValue(),
            'type': error.type.toString(),
            'description': error.description,
            'engine': _engine,
          });
        },
        onReceivedHttpError: (controller, request, response) {
          widget.sendEvent(widget.controlId, 'http_error', {
            'url': request.url.toString(),
            'status_code': response.statusCode,
            'reason': response.reasonPhrase,
            'engine': _engine,
          });
        },
        onLoadStop: (controller, uri) async {
          _currentUrl = uri?.toString() ?? '';
          _canGoBack = await controller.canGoBack();
          _canGoForward = await controller.canGoForward();
          widget.sendEvent(widget.controlId, 'navigation', {
            'url': _currentUrl,
          });
          widget.sendEvent(widget.controlId, 'history', {
            'canGoBack': _canGoBack,
            'canGoForward': _canGoForward,
          });
          widget.sendEvent(widget.controlId, 'load_stop', {
            'url': _currentUrl,
            'engine': _engine,
          });
          if (!_readySent) {
            _readySent = true;
            widget.sendEvent(widget.controlId, 'ready', {'url': _currentUrl});
          }
          if (mounted) setState(() {});
        },
        onTitleChanged: (controller, title) {
          _title = title ?? '';
          widget.sendEvent(widget.controlId, 'title', {'title': _title});
          if (mounted) setState(() {});
        },
      );
    }

    if (_useFlutter) {
      final controller = _flutterController;
      if (controller == null) {
        return _buildLoaderOrError();
      }
      return SizedBox.expand(child: WebViewWidget(controller: controller));
    }

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
