import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildToastHostControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ToastHostControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _ToastHostControl extends StatefulWidget {
  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const _ToastHostControl({
    required this.controlId,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<_ToastHostControl> createState() => _ToastHostControlState();
}

class _ToastHostControlState extends State<_ToastHostControl> {
  Map<String, Object?> _liveProps = const <String, Object?>{};
  late List<Map<String, Object?>> _items = _coerceItems(
    widget.props['items'] ?? widget.props['toasts'],
  );

  @override
  void initState() {
    super.initState();
    _liveProps = <String, Object?>{...widget.props};
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _ToastHostControl oldWidget) {
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
      _liveProps = <String, Object?>{...widget.props};
      _items = _coerceItems(_liveProps['items'] ?? _liveProps['toasts']);
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  int get _maxItems =>
      (coerceOptionalInt(_liveProps['max_items']) ?? 4).clamp(1, 32);

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_items':
        setState(() {
          _items = _coerceItems(args['items'] ?? args['toasts']);
          _liveProps = <String, Object?>{
            ..._liveProps,
            'items': args['items'] ?? args['toasts'],
            'toasts': args['items'] ?? args['toasts'],
          };
        });
        return null;
      case 'push':
      case 'add_item':
        {
          final raw = args['item'];
          if (raw is! Map) return null;
          final item = coerceObjectMap(raw);
          setState(() {
            _items.add(item);
            if (_items.length > _maxItems) {
              _items = _items.sublist(_items.length - _maxItems);
            }
          });
          return null;
        }
      case 'dismiss':
      case 'remove':
        {
          final id = args['id']?.toString() ?? '';
          if (id.isEmpty) return null;
          setState(() {
            _items.removeWhere(
              (item) =>
                  (item['id']?.toString() ?? item['key']?.toString() ?? '') ==
                  id,
            );
          });
          return null;
        }
      case 'clear':
      case 'clear_all':
        setState(() {
          _items = const <Map<String, Object?>>[];
        });
        return null;
      case 'set_props':
        {
          final incoming = args['props'];
          if (incoming is Map) {
            final props = coerceObjectMap(incoming);
            setState(() {
              _liveProps = <String, Object?>{..._liveProps, ...props};
              if (props.containsKey('items') || props.containsKey('toasts')) {
                _items = _coerceItems(
                  _liveProps['items'] ?? _liveProps['toasts'],
                );
              }
            });
          }
          return _statePayload();
        }
      case 'get_state':
        return _statePayload();
      case 'get_items':
        return List<Map<String, Object?>>.from(_items, growable: false);
      case 'emit':
        {
          if (widget.controlId.isEmpty) return null;
          final event = (args['event'] ?? 'change').toString();
          final payload = args['payload'] is Map
              ? coerceObjectMap(args['payload'] as Map)
              : <String, Object?>{};
          widget.sendEvent(widget.controlId, event, payload);
          return null;
        }
      default:
        throw UnsupportedError('Unknown toast_host method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      'count': _items.length,
      'max_items': _maxItems,
      'position': (_liveProps['position'] ?? 'bottom_right').toString(),
      'latest_on_top': _liveProps['latest_on_top'] == null
          ? true
          : (_liveProps['latest_on_top'] == true),
      'dismissible': _liveProps['dismissible'] == null
          ? true
          : (_liveProps['dismissible'] == true),
    };
  }

  @override
  Widget build(BuildContext context) {
    final spacing = coerceDouble(_liveProps['spacing']) ?? 8.0;
    final showLatestOnTop = _liveProps['latest_on_top'] == null
        ? true
        : (_liveProps['latest_on_top'] == true);
    final dismissible = _liveProps['dismissible'] == null
        ? true
        : (_liveProps['dismissible'] == true);

    var toRender = List<Map<String, Object?>>.from(_items);
    if (showLatestOnTop) {
      toRender = toRender.reversed.toList();
    }
    if (toRender.length > _maxItems) {
      toRender.removeRange(_maxItems, toRender.length);
    }

    final alignment = _resolveAlignment(_liveProps['position']?.toString());
    final padding =
        coercePadding(_liveProps['padding']) ??
        const EdgeInsets.symmetric(horizontal: 12, vertical: 12);

    return IgnorePointer(
      ignoring: false,
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: _isRight(alignment)
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: toRender
                .map(
                  (item) => Padding(
                    padding: EdgeInsets.only(bottom: spacing),
                    child: _ToastCard(
                      controlId: widget.controlId,
                      item: item,
                      dismissible: dismissible,
                      sendEvent: widget.sendEvent,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _ToastCard extends StatelessWidget {
  final String controlId;
  final Map<String, Object?> item;
  final bool dismissible;
  final ButterflyUISendRuntimeEvent sendEvent;

  const _ToastCard({
    required this.controlId,
    required this.item,
    required this.dismissible,
    required this.sendEvent,
  });

  @override
  Widget build(BuildContext context) {
    final id = item['id']?.toString() ?? item['key']?.toString() ?? '';
    final title = item['title']?.toString() ?? item['label']?.toString() ?? '';
    final message =
        item['message']?.toString() ??
        item['text']?.toString() ??
        item['value']?.toString() ??
        '';
    if (title.isEmpty && message.isEmpty) {
      return const SizedBox.shrink();
    }

    final variant = item['variant']?.toString().toLowerCase();
    final scheme = Theme.of(context).colorScheme;
    final bg = _variantColor(variant, scheme).withValues(alpha: 0.94);
    final fg = _variantOnColor(variant, scheme);

    return Material(
      color: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: fg.withValues(alpha: 0.2)),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                blurRadius: 14,
                spreadRadius: 1,
                offset: Offset(0, 6),
                color: Color(0x33000000),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (title.isNotEmpty)
                        Text(
                          title,
                          style: TextStyle(
                            color: fg,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      if (message.isNotEmpty)
                        Text(
                          message,
                          style: TextStyle(color: fg.withValues(alpha: 0.92)),
                        ),
                    ],
                  ),
                ),
                if (dismissible)
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    splashRadius: 16,
                    icon: Icon(Icons.close, size: 16, color: fg),
                    onPressed: () {
                      if (controlId.isEmpty) return;
                      sendEvent(controlId, 'dismiss', <String, Object?>{
                        'id': id,
                        'item': item,
                      });
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

List<Map<String, Object?>> _coerceItems(Object? value) {
  if (value is! List) return const <Map<String, Object?>>[];
  final out = <Map<String, Object?>>[];
  for (final item in value) {
    if (item is Map) {
      out.add(coerceObjectMap(item));
    }
  }
  return out;
}

Alignment _resolveAlignment(String? raw) {
  switch ((raw ?? '').toLowerCase().replaceAll('-', '_')) {
    case 'top_left':
      return Alignment.topLeft;
    case 'top_right':
      return Alignment.topRight;
    case 'bottom_left':
      return Alignment.bottomLeft;
    case 'bottom_center':
    case 'bottom':
      return Alignment.bottomCenter;
    case 'center':
      return Alignment.center;
    case 'top_center':
    case 'top':
      return Alignment.topCenter;
    case 'bottom_right':
    default:
      return Alignment.bottomRight;
  }
}

bool _isRight(Alignment alignment) {
  return alignment.x > 0.2;
}

Color _variantColor(String? variant, ColorScheme scheme) {
  switch (variant) {
    case 'success':
      return const Color(0xFF1F8A5D);
    case 'warning':
      return const Color(0xFF8A6116);
    case 'error':
    case 'danger':
      return const Color(0xFF8C2E2E);
    default:
      return scheme.surface;
  }
}

Color _variantOnColor(String? variant, ColorScheme scheme) {
  switch (variant) {
    case 'success':
    case 'warning':
    case 'error':
    case 'danger':
      return Colors.white;
    default:
      return scheme.onSurface;
  }
}
