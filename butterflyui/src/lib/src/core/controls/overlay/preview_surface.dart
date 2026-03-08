import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildPreviewSurfaceControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ButterflyUIPreviewSurface(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _ButterflyUIPreviewSurface extends StatefulWidget {
  const _ButterflyUIPreviewSurface({
    required this.controlId,
    required this.props,
    required this.rawChildren,
    required this.buildChild,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final List<dynamic> rawChildren;
  final Widget Function(Map<String, Object?> child) buildChild;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_ButterflyUIPreviewSurface> createState() =>
      _ButterflyUIPreviewSurfaceState();
}

class _ButterflyUIPreviewSurfaceState
    extends State<_ButterflyUIPreviewSurface> {
  Map<String, Object?> _liveProps = const <String, Object?>{};

  @override
  void initState() {
    super.initState();
    _liveProps = <String, Object?>{...widget.props};
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _ButterflyUIPreviewSurface oldWidget) {
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
      setState(() {
        _liveProps = <String, Object?>{...widget.props};
      });
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_props':
        {
          final incoming = args['props'];
          if (incoming is Map) {
            setState(() {
              _liveProps = <String, Object?>{
                ..._liveProps,
                ...coerceObjectMap(incoming),
              };
            });
          }
          return _statePayload();
        }
      case 'get_state':
        return _statePayload();
      case 'emit':
      case 'trigger':
        {
          final fallback = method == 'trigger' ? 'open' : method;
          final event = (args['event'] ?? args['name'] ?? fallback).toString();
          final payload = args['payload'] is Map
              ? coerceObjectMap(args['payload'] as Map)
              : <String, Object?>{};
          _emit(event, payload);
          return true;
        }
      default:
        throw UnsupportedError('Unknown preview_surface method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      'title': _liveProps['title']?.toString(),
      'subtitle': _liveProps['subtitle']?.toString(),
      'source': _liveProps['source']?.toString(),
      'loading': _liveProps['loading'] == true,
    };
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) {
      return;
    }
    widget.sendEvent(widget.controlId, event, payload);
  }

  Widget _resolveContent() {
    for (final raw in widget.rawChildren) {
      if (raw is Map) {
        return widget.buildChild(coerceObjectMap(raw));
      }
    }
    final childProp = _liveProps['child'];
    if (childProp is Map) {
      return widget.buildChild(coerceObjectMap(childProp));
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final title = _liveProps['title']?.toString();
    final subtitle = _liveProps['subtitle']?.toString();
    final source = _liveProps['source']?.toString();
    final loading = _liveProps['loading'] == true;
    final content = _resolveContent();

    final card = InkWell(
      onTap: widget.controlId.isEmpty
          ? null
          : () {
              _emit('open', {'source': source, 'title': title});
            },
      child: Builder(
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                coerceDouble(_liveProps['radius']) ?? 10,
              ),
              border: Border.all(
                color:
                    (coerceColor(_liveProps['border_color']) ??
                            Theme.of(context).dividerColor)
                        .withValues(alpha: 0.4),
              ),
              color: coerceColor(
                _liveProps['bgcolor'] ?? _liveProps['background'],
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null || subtitle != null)
                  ListTile(
                    dense: true,
                    title: title == null ? null : Text(title),
                    subtitle: subtitle == null ? null : Text(subtitle),
                  ),
                if (loading)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                else
                  content,
              ],
            ),
          );
        },
      ),
    );
    return applyControlFrameLayout(
      props: _liveProps,
      child: card,
      clipToRadius: true,
      defaultRadius: coerceDouble(_liveProps['radius']) ?? 10,
    );
  }
}
