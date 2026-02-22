import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildSplashControl(
  String controlId,
  Map<String, Object?> props,
  Widget child,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _SplashControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
    child: child,
  );
}

class _SplashControl extends StatefulWidget {
  const _SplashControl({
    required this.controlId,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
    required this.child,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;
  final Widget child;

  @override
  State<_SplashControl> createState() => _SplashControlState();
}

class _SplashControlState extends State<_SplashControl> {
  bool _active = false;

  @override
  void initState() {
    super.initState();
    _active = widget.props['active'] == true;
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant _SplashControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'trigger':
        _trigger();
        return true;
      case 'emit':
        final event = (args['event'] ?? 'custom').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        widget.sendEvent(widget.controlId, event, payload);
        return true;
      default:
        throw UnsupportedError('Unknown splash method: $method');
    }
  }

  void _trigger() {
    setState(() => _active = true);
    widget.sendEvent(widget.controlId, 'splash', {'active': true});
    final durationMs = (coerceOptionalInt(widget.props['duration_ms']) ?? 300).clamp(50, 4000);
    Future<void>.delayed(Duration(milliseconds: durationMs), () {
      if (!mounted) return;
      setState(() => _active = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final radius = coerceDouble(widget.props['radius']) ?? 20;
    final splashColor = coerceColor(widget.props['color']) ?? Theme.of(context).colorScheme.primary.withOpacity(0.22);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        splashColor: splashColor,
        onTap: () {
          _trigger();
          widget.sendEvent(widget.controlId, 'tap', const {});
        },
        child: Stack(
          children: [
            widget.child,
            if (_active)
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(radius),
                      color: splashColor.withOpacity(0.35),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
