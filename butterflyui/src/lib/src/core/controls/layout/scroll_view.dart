import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildScrollViewControl(
  String controlId,
  Map<String, Object?> props,
  List children,
  Widget Function(Map<String, Object?> child) buildFromControl,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return ButterflyUIScrollView(
    controlId: controlId,
    props: props,
    children: children,
    buildFromControl: buildFromControl,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class ButterflyUIScrollView extends StatefulWidget {
  final String controlId;
  final Map<String, Object?> props;
  final List children;
  final Widget Function(Map<String, Object?> child) buildFromControl;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUIScrollView({
    super.key,
    required this.controlId,
    required this.props,
    required this.children,
    required this.buildFromControl,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<ButterflyUIScrollView> createState() => _ButterflyUIScrollViewState();
}

class _ButterflyUIScrollViewState extends State<ButterflyUIScrollView> {
  late final ScrollController _controller;
  double _lastPixels = 0.0;

  @override
  void initState() {
    super.initState();
    final initialOffset = coerceDouble(widget.props['initial_offset']) ?? 0.0;
    _controller = ScrollController(initialScrollOffset: initialOffset);
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant ButterflyUIScrollView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }

    final oldInitial = coerceDouble(oldWidget.props['initial_offset']);
    final nextInitial = coerceDouble(widget.props['initial_offset']);
    if (nextInitial != null &&
        nextInitial != oldInitial &&
        _controller.hasClients) {
      final position = _controller.position;
      final clamped = nextInitial
          .clamp(position.minScrollExtent, position.maxScrollExtent)
          .toDouble();
      if (position.pixels != clamped) {
        _controller.jumpTo(clamped);
      }
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    _controller.dispose();
    super.dispose();
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    final axis = _parseAxis(widget.props['direction']) ?? Axis.vertical;
    final reverse = widget.props['reverse'] == true;
    if (!_controller.hasClients) {
      throw StateError('ScrollView has no attached ScrollPosition');
    }

    final position = _controller.position;

    double resolveOffset(Object? value) {
      final v = coerceDouble(value);
      if (v != null) return v;
      if (axis == Axis.horizontal) {
        return coerceDouble(args['x'] ?? args['dx']) ?? 0.0;
      }
      return coerceDouble(args['y'] ?? args['dy']) ?? 0.0;
    }

    Future<void> moveTo(double target) async {
      final clamp = args['clamp'] == null ? true : (args['clamp'] == true);
      final animate = args['animate'] == null
          ? true
          : (args['animate'] == true);
      final durationMs =
          coerceOptionalInt(args['duration_ms'] ?? args['durationMs']) ?? 250;
      final curve = _parseCurve(args['curve']);

      final resolved = clamp
          ? target
                .clamp(position.minScrollExtent, position.maxScrollExtent)
                .toDouble()
          : target;
      if (animate) {
        await _controller.animateTo(
          resolved,
          duration: Duration(milliseconds: durationMs),
          curve: curve,
        );
      } else {
        _controller.jumpTo(resolved);
      }
    }

    switch (method) {
      case 'get_scroll_metrics':
        return <String, Object?>{
          'pixels': position.pixels,
          'min_scroll_extent': position.minScrollExtent,
          'max_scroll_extent': position.maxScrollExtent,
          'viewport_dimension': position.viewportDimension,
          'axis': axis == Axis.horizontal ? 'horizontal' : 'vertical',
          'reverse': reverse,
          'at_start': position.pixels <= position.minScrollExtent + 0.5,
          'at_end': position.pixels >= position.maxScrollExtent - 0.5,
        };
      case 'scroll_to':
        await moveTo(resolveOffset(args['offset'] ?? args['pixels']));
        return null;
      case 'scroll_by':
        final delta = resolveOffset(
          args['delta'] ?? args['scroll_delta'] ?? args['scrollDelta'],
        );
        await moveTo(position.pixels + delta);
        return null;
      case 'scroll_to_start':
        await moveTo(position.minScrollExtent);
        return null;
      case 'scroll_to_end':
        await moveTo(position.maxScrollExtent);
        return null;
      default:
        throw UnsupportedError('Unknown scroll_view method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final childMap = _firstChildMap(widget.children);
    final direction = _parseAxis(widget.props['direction']) ?? Axis.vertical;
    final contentPadding = coercePadding(widget.props['content_padding']);
    final reverse = widget.props['reverse'] == true;

    final events = _coerceStringSet(widget.props['events']);
    final wantsScrollStart = events.contains('scroll_start');
    final wantsScroll = events.contains('scroll');
    final wantsScrollEnd = events.contains('scroll_end');
    final anyScrollEvents = wantsScrollStart || wantsScroll || wantsScrollEnd;

    Widget scrollable = SingleChildScrollView(
      controller: _controller,
      scrollDirection: direction,
      reverse: reverse,
      padding: contentPadding,
      child: childMap == null
          ? const SizedBox.shrink()
          : widget.buildFromControl(childMap),
    );

    if (!anyScrollEvents || widget.controlId.isEmpty) {
      return scrollable;
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        final metrics = notification.metrics;
        final axis = metrics.axis;
        final delta = notification is ScrollUpdateNotification
            ? (notification.scrollDelta ?? (metrics.pixels - _lastPixels))
            : 0.0;
        _lastPixels = metrics.pixels;

        Map<String, Object?> payload(String name) {
          return <String, Object?>{
            'name': name,
            'pixels': metrics.pixels,
            'min_scroll_extent': metrics.minScrollExtent,
            'max_scroll_extent': metrics.maxScrollExtent,
            'viewport_dimension': metrics.viewportDimension,
            'axis': axis == Axis.horizontal ? 'horizontal' : 'vertical',
            'delta': delta,
            'at_start': metrics.pixels <= metrics.minScrollExtent + 0.5,
            'at_end': metrics.pixels >= metrics.maxScrollExtent - 0.5,
          };
        }

        if (notification is ScrollStartNotification) {
          if (wantsScrollStart) {
            widget.sendEvent(
              widget.controlId,
              'scroll_start',
              payload('scroll_start'),
            );
          }
        } else if (notification is ScrollUpdateNotification) {
          if (wantsScroll) {
            widget.sendEvent(widget.controlId, 'scroll', payload('scroll'));
          }
        } else if (notification is ScrollEndNotification) {
          if (wantsScrollEnd) {
            widget.sendEvent(
              widget.controlId,
              'scroll_end',
              payload('scroll_end'),
            );
          }
        }
        return false;
      },
      child: scrollable,
    );
  }
}

Map<String, Object?>? _firstChildMap(List children) {
  for (final child in children) {
    if (child is Map) {
      return coerceObjectMap(child);
    }
  }
  return null;
}

Axis? _parseAxis(Object? value) {
  final s = value?.toString().toLowerCase();
  switch (s) {
    case 'horizontal':
    case 'row':
      return Axis.horizontal;
    case 'vertical':
    case 'column':
      return Axis.vertical;
  }
  return null;
}

Set<String> _coerceStringSet(Object? value) {
  final out = <String>{};
  if (value is List) {
    for (final v in value) {
      final s = v?.toString();
      if (s != null && s.isNotEmpty) out.add(s);
    }
  }
  return out;
}

Curve _parseCurve(Object? value) {
  final s = value?.toString().toLowerCase();
  switch (s) {
    case 'linear':
      return Curves.linear;
    case 'ease_in':
    case 'easein':
      return Curves.easeIn;
    case 'ease_out':
    case 'easeout':
      return Curves.easeOut;
    case 'ease_in_out':
    case 'easeinout':
      return Curves.easeInOut;
    case 'ease':
    default:
      return Curves.ease;
  }
}

