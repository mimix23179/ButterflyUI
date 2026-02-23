import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildStaggerControl(
  String controlId,
  Map<String, Object?> props,
  List rawChildren,
  Widget Function(Map<String, Object?> child) buildFromControl,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _StaggerControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildFromControl: buildFromControl,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _StaggerControl extends StatefulWidget {
  final String controlId;
  final Map<String, Object?> props;
  final List rawChildren;
  final Widget Function(Map<String, Object?> child) buildFromControl;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const _StaggerControl({
    required this.controlId,
    required this.props,
    required this.rawChildren,
    required this.buildFromControl,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<_StaggerControl> createState() => _StaggerControlState();
}

class _StaggerControlState extends State<_StaggerControl>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool get _play => widget.props['play'] == null ? true : (widget.props['play'] == true);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);
    if (_play) {
      _controller.forward(from: 0);
    }
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  Duration get _duration {
    final ms = (coerceOptionalInt(widget.props['duration_ms']) ?? 420)
        .clamp(50, 60 * 1000);
    return Duration(milliseconds: ms);
  }

  int get _staggerMs {
    return (coerceOptionalInt(widget.props['stagger_ms'] ?? widget.props['stagger']) ?? 40)
        .clamp(0, 4000);
  }

  @override
  void didUpdateWidget(covariant _StaggerControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    if (oldWidget.props != widget.props) {
      _controller.duration = _duration;
      if (_play) {
        _controller.forward(from: 0);
      } else {
        _controller.stop();
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

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_play':
        final play = args['play'] == true;
        if (play) {
          await _controller.forward(from: 0);
        } else {
          _controller.stop();
        }
        return true;
      case 'get_state':
        return <String, Object?>{
          'play': _controller.isAnimating,
          'value': _controller.value,
        };
      case 'emit':
        final event = (args['event'] ?? 'custom').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        if (widget.controlId.isNotEmpty) {
          widget.sendEvent(widget.controlId, event, payload);
        }
        return true;
      default:
        throw UnsupportedError('Unknown stagger method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (final raw in widget.rawChildren) {
      if (raw is Map) {
        children.add(widget.buildFromControl(coerceObjectMap(raw)));
      }
    }
    if (children.isEmpty) return const SizedBox.shrink();

    final direction = (widget.props['direction'] ?? 'vertical').toString().toLowerCase();
    final offset = direction == 'horizontal'
        ? const Offset(0.06, 0)
        : const Offset(0, 0.08);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final pieces = <Widget>[];
        final totalMs = _duration.inMilliseconds;
        for (var index = 0; index < children.length; index += 1) {
          final startMs = (_staggerMs * index).clamp(0, totalMs);
          final start = totalMs == 0 ? 0.0 : (startMs / totalMs);
          final curve = CurvedAnimation(
            parent: _controller,
            curve: Interval(start, 1.0, curve: Curves.easeOutCubic),
          );
          final slide = Tween<Offset>(begin: offset, end: Offset.zero).evaluate(curve);
          pieces.add(
            FadeTransition(
              opacity: curve,
              child: Transform.translate(
                offset: Offset(slide.dx * 24, slide.dy * 24),
                child: children[index],
              ),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: pieces,
        );
      },
    );
  }
}
