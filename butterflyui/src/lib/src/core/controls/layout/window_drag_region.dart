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
    sendEvent: sendEvent,
    child: hasChild ? child : fallback,
  );
}

class _ButterflyUIWindowDragRegion extends StatelessWidget {
  final String controlId;
  final bool draggable;
  final bool maximizeOnDoubleTap;
  final bool emitMove;
  final bool nativeDrag;
  final bool nativeMaximizeAction;
  final ButterflyUISendRuntimeEvent sendEvent;
  final Widget child;

  const _ButterflyUIWindowDragRegion({
    required this.controlId,
    required this.draggable,
    required this.maximizeOnDoubleTap,
    required this.emitMove,
    required this.nativeDrag,
    required this.nativeMaximizeAction,
    required this.sendEvent,
    required this.child,
  });

  void _emit(
    String name, [
    Map<String, Object?> payload = const <String, Object?>{},
  ]) {
    if (controlId.isEmpty) return;
    sendEvent(controlId, name, payload);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: draggable ? SystemMouseCursors.move : MouseCursor.defer,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: draggable
            ? (details) {
                if (nativeDrag) {
                  unawaited(ButterflyUIWindowApi.instance.startDrag());
                }
                _emit('drag_start', {
                  'global_x': details.globalPosition.dx,
                  'global_y': details.globalPosition.dy,
                  'local_x': details.localPosition.dx,
                  'local_y': details.localPosition.dy,
                });
              }
            : null,
        onPanUpdate: draggable && emitMove
            ? (details) {
                _emit('move', {
                  'dx': details.delta.dx,
                  'dy': details.delta.dy,
                  'global_x': details.globalPosition.dx,
                  'global_y': details.globalPosition.dy,
                  'local_x': details.localPosition.dx,
                  'local_y': details.localPosition.dy,
                });
              }
            : null,
        onPanEnd: draggable ? (_) => _emit('drag_end') : null,
        onDoubleTap: draggable && maximizeOnDoubleTap
            ? () {
                if (nativeMaximizeAction) {
                  unawaited(
                    ButterflyUIWindowApi.instance.performAction('toggle_maximize'),
                  );
                }
                _emit('toggle_maximize', {'action': 'toggle_maximize'});
              }
            : null,
        child: child,
      ),
    );
  }
}
