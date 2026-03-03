import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildPageViewControl(
  String controlId,
  Map<String, Object?> props,
  List<Widget> children,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ButterflyUIPageView(
    controlId,
    props: props,
    children: children,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _ButterflyUIPageView extends StatefulWidget {
  const _ButterflyUIPageView(
    this.controlId, {
    required this.props,
    required this.children,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final List<Widget> children;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_ButterflyUIPageView> createState() => _ButterflyUIPageViewState();
}

class _ButterflyUIPageViewState extends State<_ButterflyUIPageView> {
  PageController? _controller;
  int _index = 0;
  double _viewportFraction = 1.0;
  bool _keepPage = true;

  @override
  void initState() {
    super.initState();
    _syncFromProps(animateToIndex: false);
    _registerInvokeHandler(widget.controlId);
  }

  @override
  void didUpdateWidget(covariant _ButterflyUIPageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      _unregisterInvokeHandler(oldWidget.controlId);
      _registerInvokeHandler(widget.controlId);
    }
    _syncFromProps(animateToIndex: true);
  }

  @override
  void dispose() {
    _unregisterInvokeHandler(widget.controlId);
    _controller?.dispose();
    super.dispose();
  }

  void _registerInvokeHandler(String controlId) {
    if (controlId.isEmpty) return;
    widget.registerInvokeHandler(controlId, _handleInvoke);
  }

  void _unregisterInvokeHandler(String controlId) {
    if (controlId.isEmpty) return;
    widget.unregisterInvokeHandler(controlId);
  }

  void _syncFromProps({required bool animateToIndex}) {
    final desiredIndex = _resolvedInitialIndex();
    final desiredViewport = _resolvedViewportFraction();
    final desiredKeepPage = _coerceBool(widget.props['keep_alive'], fallback: true);
    final shouldRecreateController =
        _controller == null ||
        _viewportFraction != desiredViewport ||
        _keepPage != desiredKeepPage;

    _viewportFraction = desiredViewport;
    _keepPage = desiredKeepPage;

    if (shouldRecreateController) {
      final previous = _controller;
      _controller = PageController(
        initialPage: desiredIndex,
        viewportFraction: desiredViewport,
        keepPage: desiredKeepPage,
      );
      previous?.dispose();
      _index = desiredIndex;
      if (mounted) {
        setState(() {});
      }
      return;
    }

    final bounded = _clampIndex(desiredIndex);
    if (bounded != _index) {
      if (animateToIndex) {
        _setIndex(
          bounded,
          animated: _coerceBool(widget.props['animate'], fallback: true),
          durationMs: coerceOptionalInt(widget.props['duration_ms']),
          emitEvents: false,
        );
      } else {
        _index = bounded;
        _controller?.jumpToPage(_index);
      }
    }
  }

  int _resolvedInitialIndex() {
    final fromIndex = coerceOptionalInt(widget.props['index']);
    final fromInitial = coerceOptionalInt(widget.props['initial_page']);
    return _clampIndex(fromIndex ?? fromInitial ?? 0);
  }

  int _clampIndex(int value) {
    if (widget.children.isEmpty) return 0;
    return value.clamp(0, widget.children.length - 1);
  }

  double _resolvedViewportFraction() {
    final value = coerceDouble(widget.props['viewport_fraction']);
    if (value == null) return 1.0;
    if (value <= 0) return 1.0;
    return value;
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_index':
      case 'set_page':
        _setIndex(
          coerceOptionalInt(args['index'] ?? args['page']) ?? _index,
          animated: _coerceBool(args['animated'], fallback: _coerceBool(widget.props['animate'], fallback: true)),
          durationMs: coerceOptionalInt(args['duration_ms']) ?? coerceOptionalInt(widget.props['duration_ms']),
        );
        return _state();
      case 'next_page':
      case 'next':
        _setIndex(
          _index + 1,
          animated: _coerceBool(args['animated'], fallback: _coerceBool(widget.props['animate'], fallback: true)),
          durationMs: coerceOptionalInt(args['duration_ms']) ?? coerceOptionalInt(widget.props['duration_ms']),
        );
        return _state();
      case 'previous_page':
      case 'prev_page':
      case 'prev':
        _setIndex(
          _index - 1,
          animated: _coerceBool(args['animated'], fallback: _coerceBool(widget.props['animate'], fallback: true)),
          durationMs: coerceOptionalInt(args['duration_ms']) ?? coerceOptionalInt(widget.props['duration_ms']),
        );
        return _state();
      case 'get_state':
        return _state();
      case 'emit':
        final eventName = (args['event'] ?? 'change').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        _emit(eventName, payload);
        return null;
      default:
        throw UnsupportedError('Unknown page_view method: $method');
    }
  }

  void _setIndex(
    int value, {
    required bool animated,
    int? durationMs,
    bool emitEvents = true,
  }) {
    final next = _clampIndex(value);
    if (next == _index) return;
    _index = next;
    if (animated) {
      _controller?.animateToPage(
        next,
        duration: Duration(milliseconds: (durationMs ?? 240).clamp(1, 60000)),
        curve: Curves.easeOutCubic,
      );
    } else {
      _controller?.jumpToPage(next);
    }
    if (emitEvents) {
      final payload = _state();
      _emit('change', payload);
      _emit('input', payload);
    }
    if (mounted) {
      setState(() {});
    }
  }

  Map<String, Object?> _state() {
    final count = widget.children.length;
    return <String, Object?>{
      'index': _index,
      'page': _index,
      'count': count,
      'has_previous': _index > 0,
      'has_next': _index < count - 1,
    };
  }

  void _emit(String name, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, name, payload);
  }

  Axis _axisFromProps() {
    final raw = (widget.props['scroll_direction'] ?? widget.props['axis'])
        ?.toString()
        .toLowerCase();
    return raw == 'vertical' || raw == 'column' || raw == 'y'
        ? Axis.vertical
        : Axis.horizontal;
  }

  bool _coerceBool(Object? value, {required bool fallback}) {
    if (value == null) return fallback;
    if (value is bool) return value;
    if (value is num) return value != 0;
    final normalized = value.toString().toLowerCase();
    if (normalized == 'true' ||
        normalized == '1' ||
        normalized == 'yes' ||
        normalized == 'on') {
      return true;
    }
    if (normalized == 'false' ||
        normalized == '0' ||
        normalized == 'no' ||
        normalized == 'off') {
      return false;
    }
    return fallback;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.children.isEmpty) {
      return const SizedBox.shrink();
    }
    final controller =
        _controller ??
        PageController(
          initialPage: _index,
          viewportFraction: _viewportFraction,
          keepPage: _keepPage,
        );
    _controller ??= controller;

    return PageView.builder(
      controller: controller,
      itemCount: widget.children.length,
      scrollDirection: _axisFromProps(),
      reverse: _coerceBool(widget.props['reverse'], fallback: false),
      pageSnapping: _coerceBool(widget.props['page_snapping'], fallback: true),
      padEnds: _coerceBool(widget.props['pad_ends'], fallback: true),
      onPageChanged: (page) {
        if (page == _index) return;
        _index = page;
        final payload = _state();
        _emit('change', payload);
        _emit('input', payload);
        if (mounted) {
          setState(() {});
        }
      },
      itemBuilder: (context, index) => widget.children[index],
    );
  }
}
