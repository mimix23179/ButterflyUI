import 'dart:async';

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';
import 'package:butterflyui_runtime/src/core/window/window_api.dart';

Widget buildWindowDragRegionControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final draggable = props['draggable'] == null
      ? true
      : (props['draggable'] == true);
  final maximizeOnDoubleTap = props['maximize_on_double_tap'] == null
      ? true
      : (props['maximize_on_double_tap'] == true);
  final emitMove = props['emit_move'] == true;
  final nativeDrag = props['native_drag'] == null
      ? true
      : (props['native_drag'] == true);
  final nativeMaximizeAction = props['native_maximize_action'] == null
      ? true
      : (props['native_maximize_action'] == true);
    final moveEventThrottleMs =
      (coerceOptionalInt(props['move_event_throttle_ms']) ?? 48).clamp(0, 1000);
  final minHeight = coerceDouble(props['min_height']) ?? 32;

  Widget child = const SizedBox.shrink();
  var hasChild = false;
  if (rawChildren.isNotEmpty) {
    final first = rawChildren.first;
    if (first is Map) {
      child = buildChild(coerceObjectMap(first));
      hasChild = true;
    }
  } else if (props['child'] is Map) {
    child = buildChild(coerceObjectMap(props['child'] as Map));
    hasChild = true;
  }

  final fallback = SizedBox(
    height: minHeight,
    child: const Align(
      alignment: Alignment.centerLeft,
      child: SizedBox.shrink(),
    ),
  );

  return _ButterflyUIWindowDragRegion(
    controlId: controlId,
    draggable: draggable,
    maximizeOnDoubleTap: maximizeOnDoubleTap,
    emitMove: emitMove,
    nativeDrag: nativeDrag,
    nativeMaximizeAction: nativeMaximizeAction,
    moveEventThrottleMs: moveEventThrottleMs,
    sendEvent: sendEvent,
    child: hasChild ? child : fallback,
  );
}

class _ButterflyUIWindowDragRegion extends StatefulWidget {
  final String controlId;
  final bool draggable;
  final bool maximizeOnDoubleTap;
  final bool emitMove;
  final bool nativeDrag;
  final bool nativeMaximizeAction;
  final int moveEventThrottleMs;
  final ButterflyUISendRuntimeEvent sendEvent;
  final Widget child;

  const _ButterflyUIWindowDragRegion({
    required this.controlId,
    required this.draggable,
    required this.maximizeOnDoubleTap,
    required this.emitMove,
    required this.nativeDrag,
    required this.nativeMaximizeAction,
    required this.moveEventThrottleMs,
    required this.sendEvent,
    required this.child,
  });

  @override
  State<_ButterflyUIWindowDragRegion> createState() =>
      _ButterflyUIWindowDragRegionState();
}

class _ButterflyUIWindowDragRegionState
    extends State<_ButterflyUIWindowDragRegion> {
  bool _dragStarted = false;
  DateTime? _lastMoveEventAt;

  void _emit(
    String name, [
    Map<String, Object?> payload = const <String, Object?>{},
  ]) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, name, payload);
  }

  void _onPanStart(DragStartDetails details) {
    if (!widget.draggable) return;
    if (!_dragStarted) {
      _dragStarted = true;
      if (widget.nativeDrag) {
        unawaited(ButterflyUIWindowApi.instance.startDrag());
      }
    }
    _emit('drag_start', {
      'global_x': details.globalPosition.dx,
      'global_y': details.globalPosition.dy,
      'local_x': details.localPosition.dx,
      'local_y': details.localPosition.dy,
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!widget.draggable || !widget.emitMove) return;
    if (widget.moveEventThrottleMs > 0) {
      final now = DateTime.now();
      if (_lastMoveEventAt != null &&
          now.difference(_lastMoveEventAt!).inMilliseconds <
              widget.moveEventThrottleMs) {
        return;
      }
      _lastMoveEventAt = now;
    }
    _emit('move', {
      'dx': details.delta.dx,
      'dy': details.delta.dy,
      'global_x': details.globalPosition.dx,
      'global_y': details.globalPosition.dy,
      'local_x': details.localPosition.dx,
      'local_y': details.localPosition.dy,
    });
  }

  void _onPanEnd() {
    if (!widget.draggable) return;
    _dragStarted = false;
    _emit('drag_end');
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.draggable ? SystemMouseCursors.move : MouseCursor.defer,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: widget.draggable ? _onPanStart : null,
        onPanUpdate: widget.draggable && widget.emitMove ? _onPanUpdate : null,
        onPanEnd: widget.draggable ? (_) => _onPanEnd() : null,
        onPanCancel: widget.draggable ? _onPanEnd : null,
        onDoubleTap: widget.draggable && widget.maximizeOnDoubleTap
            ? () {
                if (widget.nativeMaximizeAction) {
                  unawaited(
                    ButterflyUIWindowApi.instance.performAction('toggle_maximize'),
                  );
                }
                _emit('toggle_maximize', {'action': 'toggle_maximize'});
              }
            : null,
        child: widget.child,
      ),
    );
  }
}
