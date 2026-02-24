import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class _BorderSideControl extends StatefulWidget {
  const _BorderSideControl({
    required this.controlId,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;

  @override
  State<_BorderSideControl> createState() => _BorderSideControlState();
}

class _BorderSideControlState extends State<_BorderSideControl> {
  late String _side;
  late Color _color;
  late double _width;
  late double _length;

  @override
  void initState() {
    super.initState();
    _syncFromProps(widget.props);
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant _BorderSideControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
    if (oldWidget.props != widget.props) {
      setState(() {
        _syncFromProps(widget.props);
      });
    }
  }

  void _syncFromProps(Map<String, Object?> props) {
    _side = (props['side'] ?? 'bottom').toString().toLowerCase();
    _color = coerceColor(props['color']) ?? const Color(0xff64748b);
    _width = coerceDouble(props['width']) ?? 1;
    _length = coerceDouble(props['length']) ?? double.infinity;
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_style':
        setState(() {
          _side = (args['side'] ?? _side).toString().toLowerCase();
          _color = coerceColor(args['color']) ?? _color;
          _width = coerceDouble(args['width']) ?? _width;
          _length = coerceDouble(args['length']) ?? _length;
        });
        return null;
      default:
        throw UnsupportedError('Unknown border_side method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    Border border;
    final topMap = widget.props['top'];
    final rightMap = widget.props['right'];
    final bottomMap = widget.props['bottom'];
    final leftMap = widget.props['left'];
    BorderSide parse(Object? raw, BorderSide fallback) {
      if (raw is! Map) return fallback;
      final map = coerceObjectMap(raw);
      return BorderSide(
        color: coerceColor(map['color']) ?? fallback.color,
        width: coerceDouble(map['width']) ?? fallback.width,
      );
    }
    final fallbackSide = BorderSide(color: _color, width: _width);
    if (topMap is Map || rightMap is Map || bottomMap is Map || leftMap is Map) {
      border = Border(
        top: parse(topMap, fallbackSide),
        right: parse(rightMap, fallbackSide),
        bottom: parse(bottomMap, fallbackSide),
        left: parse(leftMap, fallbackSide),
      );
    } else {
    switch (_side) {
      case 'top':
          border = Border(top: fallbackSide);
        break;
      case 'left':
          border = Border(left: fallbackSide);
        break;
      case 'right':
          border = Border(right: fallbackSide);
        break;
      default:
          border = Border(bottom: fallbackSide);
        break;
    }
    }
    final animated = widget.props['animated'] == true;
    final durationMs = (coerceOptionalInt(widget.props['duration_ms']) ?? 180)
        .clamp(1, 600000);

    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: _length,
        child: animated
            ? AnimatedContainer(
                duration: Duration(milliseconds: durationMs),
                decoration: BoxDecoration(border: border),
                child: const SizedBox(height: 1),
              )
            : DecoratedBox(
                decoration: BoxDecoration(border: border),
                child: const SizedBox(height: 1),
              ),
      ),
    );
  }
}

Widget buildBorderSideControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
) {
  return _BorderSideControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
  );
}
