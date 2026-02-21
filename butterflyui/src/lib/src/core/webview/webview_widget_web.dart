// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';

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
  State<ButterflyUIWebViewWidget> createState() => _ButterflyUIWebViewWidgetState();
}

class _ButterflyUIWebViewWidgetState extends State<ButterflyUIWebViewWidget> {
  late final String _viewType;
  html.IFrameElement? _iframe;
  bool _jsDisabled = false;

  @override
  void initState() {
    super.initState();
    _viewType =
        'butterflyui-webview-${widget.controlId}-${DateTime.now().microsecondsSinceEpoch}';

    widget.registerInvokeHandler(widget.controlId, _handleInvoke);

    ui.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final frame = html.IFrameElement();
      frame.style.border = 'none';
      frame.style.width = '100%';
      frame.style.height = '100%';

      final htmlValue = widget.props.html;
      final url = widget.props.url;
      if (htmlValue.isNotEmpty) {
        final baseUrl = widget.props.baseUrl;
        frame.srcdoc = (baseUrl != null && baseUrl.isNotEmpty)
            ? _injectBaseTag(htmlValue, baseUrl)
            : htmlValue;
      } else if (url.isNotEmpty) {
        frame.src = url;
      }

      frame.onLoad.listen((_) {
        widget.sendEvent(widget.controlId, 'ready', {'url': frame.src ?? ''});
      });

      _iframe = frame;
      return frame;
    });
  }

  @override
  void didUpdateWidget(covariant ButterflyUIWebViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controlId != oldWidget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }

    final htmlChanged =
        widget.props.html != oldWidget.props.html ||
        widget.props.baseUrl != oldWidget.props.baseUrl;
    if (htmlChanged && widget.props.html.isNotEmpty) {
      final baseUrl = widget.props.baseUrl;
      final htmlValue = (baseUrl != null && baseUrl.isNotEmpty)
          ? _injectBaseTag(widget.props.html, baseUrl)
          : widget.props.html;
      _iframe?.srcdoc = htmlValue;
    } else if (widget.props.html.isEmpty &&
        widget.props.url != oldWidget.props.url &&
        widget.props.url.isNotEmpty) {
      _iframe?.src = widget.props.url;
      widget.sendEvent(widget.controlId, 'navigation', {
        'url': widget.props.url,
      });
    }
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    _iframe = null;
    super.dispose();
  }

  static String _injectBaseTag(String htmlText, String baseUrl) {
    final normalized = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
    const headOpen = '<head>';

    if (htmlText.contains('<base')) return htmlText;

    if (htmlText.contains(headOpen)) {
      return htmlText.replaceFirst(
        headOpen,
        '$headOpen<base href="$normalized">',
      );
    }

    return '<head><base href="$normalized"></head>$htmlText';
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    final iframe = _iframe;
    if (iframe == null) return null;

    switch (method) {
      case 'reload':
        final current = iframe.src;
        iframe.src = current;
        return null;
      case 'can_go_back':
        return false;
      case 'can_go_forward':
        return false;
      case 'go_back':
        try {
          final win = iframe.contentWindow;
          if (win is html.Window) {
            win.history.back();
          }
        } catch (_) {}
        return null;
      case 'go_forward':
        try {
          final win = iframe.contentWindow;
          if (win is html.Window) {
            win.history.forward();
          }
        } catch (_) {}
        return null;
      case 'clear_cache':
        return null;
      case 'clear_local_storage':
        return null;
      case 'get_current_url':
        final current = iframe.src ?? '';
        return current.isEmpty ? null : current;
      case 'get_title':
        try {
          final win = iframe.contentWindow;
          if (win is! html.Window) return null;
          final title = win.document.querySelector('title')?.text;
          if (title == null || title.isEmpty) return null;
          return title;
        } catch (_) {
          return null;
        }
      case 'get_user_agent':
        return html.window.navigator.userAgent;
      case 'load_file':
        final path = args['path']?.toString() ?? '';
        if (path.isEmpty) return null;
        final uri = path.startsWith('file:')
            ? path
            : Uri.file(path, windows: false).toString();
        iframe.src = uri;
        return null;
      case 'load_request':
        final url = args['url']?.toString() ?? '';
        if (url.isEmpty) return null;
        iframe.src = url;
        return null;
      case 'run_javascript':
        if (_jsDisabled) return null;
        return null;
      case 'load_html':
        var htmlText = args['value']?.toString() ?? '';
        final baseUrl = args['base_url']?.toString();
        if (baseUrl != null && baseUrl.isNotEmpty) {
          htmlText = _injectBaseTag(htmlText, baseUrl);
        }
        iframe.srcdoc = htmlText;
        return null;
      case 'scroll_to':
        try {
          final x =
              (args['x'] as num?)?.toInt() ??
              int.tryParse(args['x']?.toString() ?? '') ??
              0;
          final y =
              (args['y'] as num?)?.toInt() ??
              int.tryParse(args['y']?.toString() ?? '') ??
              0;
          final win = iframe.contentWindow;
          if (win is html.Window) {
            win.scrollTo(x, y);
          }
        } catch (_) {}
        return null;
      case 'scroll_by':
        try {
          final x =
              (args['x'] as num?)?.toInt() ??
              int.tryParse(args['x']?.toString() ?? '') ??
              0;
          final y =
              (args['y'] as num?)?.toInt() ??
              int.tryParse(args['y']?.toString() ?? '') ??
              0;
          final win = iframe.contentWindow;
          if (win is html.Window) {
            win.scrollBy(x, y);
          }
        } catch (_) {}
        return null;
      case 'scroll_to_start':
        try {
          final win = iframe.contentWindow;
          if (win is html.Window) {
            win.scrollTo(0, 0);
          }
        } catch (_) {}
        return null;
      case 'scroll_to_end':
        try {
          // This may be blocked cross-origin; best effort.
          final win = iframe.contentWindow;
          if (win is! html.Window) return null;
          final doc = win.document;
          final root = doc.documentElement;
          final height = root?.scrollHeight ?? 0;
          win.scrollTo(0, height);
        } catch (_) {}
        return null;
      case 'get_scroll_metrics':
        try {
          final win = iframe.contentWindow;
          if (win is! html.Window) return null;
          final doc = win.document;
          final x = win.scrollX;
          final y = win.scrollY;
          final viewportWidth = win.innerWidth;
          final viewportHeight = win.innerHeight;
          final root = doc.documentElement;
          final docWidth = root?.scrollWidth ?? 0;
          final docHeight = root?.scrollHeight ?? 0;
          return <String, Object?>{
            'x': x,
            'y': y,
            'viewport_width': viewportWidth,
            'viewport_height': viewportHeight,
            'doc_width': docWidth,
            'doc_height': docHeight,
          };
        } catch (_) {
          return null;
        }
      case 'set_javascript_mode':
        final mode = args['mode']?.toString() ?? '';
        _jsDisabled = (mode == 'disabled');
        return null;
      default:
        // Web iframes cannot reliably implement every desktop method.
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 300, child: HtmlElementView(viewType: _viewType));
  }
}
