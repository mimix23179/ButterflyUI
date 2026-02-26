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
  late List<Map<String, Object?>> _items =
      _coerceItems(widget.props['items'] ?? widget.props['toasts']);

  @override
  void initState() {
    super.initState();
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
      _items = _coerceItems(widget.props['items'] ?? widget.props['toasts']);
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
      (coerceOptionalInt(widget.props['max_items']) ?? 4).clamp(1, 32);

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_items':
        setState(() {
          _items = _coerceItems(args['items'] ?? args['toasts']);
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
                  (item['id']?.toString() ?? item['key']?.toString() ?? '') == id,
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

  @override
  Widget build(BuildContext context) {
    final spacing = coerceDouble(widget.props['spacing']) ?? 8.0;
    final showLatestOnTop = widget.props['latest_on_top'] == null
        ? true
        : (widget.props['latest_on_top'] == true);
    final dismissible = widget.props['dismissible'] == null
        ? true
        : (widget.props['dismissible'] == true);

    var toRender = List<Map<String, Object?>>.from(_items);
    if (showLatestOnTop) {
      toRender = toRender.reversed.toList();
    }
    if (toRender.length > _maxItems) {
      toRender.removeRange(_maxItems, toRender.length);
    }

    final alignment = _resolveAlignment(widget.props['position']?.toString());
    final padding =
        coercePadding(widget.props['padding']) ??
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
