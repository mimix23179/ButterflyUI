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
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _active = widget.props['active'] == true;
    _progress = (coerceDouble(widget.props['progress']) ?? 0).clamp(0, 1).toDouble();
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    if (!_active && widget.props['auto_start'] == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _trigger();
      });
    }
  }

  @override
  void didUpdateWidget(covariant _SplashControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
    if (oldWidget.props['active'] != widget.props['active']) {
      _active = widget.props['active'] == true;
    }
    if (oldWidget.props['progress'] != widget.props['progress']) {
      _progress = (coerceDouble(widget.props['progress']) ?? _progress).clamp(0, 1).toDouble();
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
      case 'start':
        _trigger();
        return true;
      case 'stop':
        setState(() => _active = false);
        widget.sendEvent(widget.controlId, 'complete', {'skipped': false, 'progress': _progress});
        return true;
      case 'set_progress':
        final value = coerceDouble(args['value']);
        if (value != null) {
          setState(() {
            _progress = value.clamp(0, 1).toDouble();
          });
          widget.sendEvent(widget.controlId, 'progress', {'value': _progress});
        }
        return _progress;
      case 'skip':
        if (widget.props['skip_enabled'] == true) {
          setState(() => _active = false);
          widget.sendEvent(widget.controlId, 'skip', {'progress': _progress});
        }
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
    final durationMs = (coerceOptionalInt(widget.props['duration_ms']) ?? 900).clamp(50, 10000);
    final minDuration = (coerceOptionalInt(widget.props['min_duration_ms']) ?? 0).clamp(0, 10000);
    final totalMs = durationMs > minDuration ? durationMs : minDuration;
    Future<void>.delayed(Duration(milliseconds: durationMs), () {
      if (!mounted) return;
      if (widget.props['hide_on_complete'] != false) {
        setState(() => _active = false);
      }
      widget.sendEvent(widget.controlId, 'complete', {'skipped': false, 'progress': _progress});
    });
    if (totalMs > 0) {
      Future<void>.delayed(Duration(milliseconds: totalMs), () {
        if (!mounted) return;
        if (_progress < 1) {
          setState(() => _progress = 1);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final radius = coerceDouble(widget.props['radius']) ?? 20;
    final splashColor = coerceColor(widget.props['color']) ?? Theme.of(context).colorScheme.primary.withOpacity(0.22);
    final background = coerceColor(widget.props['background']) ?? Colors.transparent;
    final showProgress = widget.props['show_progress'] == true || widget.props['loading'] == true;
    final title = widget.props['title']?.toString();
    final subtitle = widget.props['subtitle']?.toString() ?? widget.props['message']?.toString();
    final skipEnabled = widget.props['skip_enabled'] == true;

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(radius),
            splashColor: splashColor,
            onTap: () {
              _trigger();
              widget.sendEvent(widget.controlId, 'tap', const {});
            },
            child: widget.child,
          ),
          if (_active)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  color: background == Colors.transparent
                      ? splashColor.withOpacity(0.35)
                      : background,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (title != null && title.isNotEmpty)
                          Text(title, style: Theme.of(context).textTheme.titleMedium),
                        if (subtitle != null && subtitle.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                          ),
                        if (showProgress)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: SizedBox(
                              width: 220,
                              child: LinearProgressIndicator(value: _progress <= 0 ? null : _progress),
                            ),
                          ),
                        if (skipEnabled)
                          TextButton(
                            onPressed: () {
                              setState(() => _active = false);
                              widget.sendEvent(widget.controlId, 'skip', {'progress': _progress});
                            },
                            child: const Text('Skip'),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
