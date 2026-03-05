import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/common/icon_value.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildStatusBarControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ButterflyUIStatusBar(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _ButterflyUIStatusBar extends StatefulWidget {
  const _ButterflyUIStatusBar({
    required this.controlId,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_ButterflyUIStatusBar> createState() => _ButterflyUIStatusBarState();
}

class _ButterflyUIStatusBarState extends State<_ButterflyUIStatusBar> {
  List<Map<String, Object?>> _items = const <Map<String, Object?>>[];
  String _text = '';

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _ButterflyUIStatusBar oldWidget) {
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
      _syncFromProps();
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  void _syncFromProps() {
    _items = _coerceItems(widget.props['items']);
    _text = widget.props['text']?.toString() ?? '';
  }

  List<Map<String, Object?>> _coerceItems(Object? rawItems) {
    final items = <Map<String, Object?>>[];
    if (rawItems is List) {
      for (final item in rawItems) {
        if (item is Map) {
          items.add(coerceObjectMap(item));
        } else if (item != null) {
          final text = item.toString();
          items.add(<String, Object?>{'id': text, 'label': text});
        }
      }
    }
    return items;
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_items':
        setState(() => _items = _coerceItems(args['items']));
        return _statePayload();
      case 'set_text':
        setState(() => _text = args['text']?.toString() ?? '');
        return _statePayload();
      case 'set_props':
        final rawProps = args['props'];
        if (rawProps is Map) {
          final props = coerceObjectMap(rawProps);
          setState(() {
            if (props.containsKey('items')) {
              _items = _coerceItems(props['items']);
            }
            if (props.containsKey('text')) {
              _text = props['text']?.toString() ?? '';
            }
          });
        }
        return _statePayload();
      case 'get_state':
        return _statePayload();
      case 'emit':
      case 'trigger':
        {
          final fallback = method == 'trigger' ? 'select' : method;
          final event = (args['event'] ?? args['name'] ?? fallback).toString();
          final payload = args['payload'] is Map
              ? coerceObjectMap(args['payload'] as Map)
              : <String, Object?>{};
          _emit(event, payload);
          return true;
        }
      default:
        throw UnsupportedError('Unknown status_bar method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      'items': _items,
      'text': _text,
      'count': _items.length,
    };
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  Widget _buildStatusItem(
    BuildContext context,
    Map<String, Object?> item,
    int index,
    bool dense,
  ) {
    final label =
        (item['label'] ?? item['text'] ?? item['title'] ?? item['id'] ?? 'Item')
            .toString();
    final value = item['value']?.toString();
    final icon = buildIconValue(
      item['icon'] ?? item['leading_icon'],
      size: dense ? 14 : 16,
    );
    final progress = coerceDouble(item['progress']);

    final statusColor = _statusColor(context, item['status']?.toString());
    final fg =
        coerceColor(item['text_color']) ??
        Theme.of(context).colorScheme.onSurface;
    final chipBg =
        coerceColor(item['bgcolor']) ??
        Theme.of(context).colorScheme.surface.withValues(alpha: 0.25);

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: widget.controlId.isEmpty
          ? null
          : () {
              _emit('select', {
                'id': item['id']?.toString() ?? label,
                'label': label,
                'index': index,
                'item': item,
              });
            },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: dense ? 6 : 8,
          vertical: dense ? 3 : 4,
        ),
        decoration: BoxDecoration(
          color: chipBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: statusColor.withValues(alpha: 0.45),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (statusColor != Colors.transparent) ...[
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
            ],
            if (icon != null) ...[icon, const SizedBox(width: 5)],
            Text(
              label,
              style: TextStyle(
                color: fg,
                fontSize: dense ? 11 : 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (value != null && value.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(
                value,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: fg.withValues(alpha: 0.85),
                ),
              ),
            ],
            if (progress != null) ...[
              const SizedBox(width: 8),
              SizedBox(
                width: dense ? 42 : 56,
                child: LinearProgressIndicator(
                  value: progress.clamp(0, 1),
                  minHeight: dense ? 4 : 5,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _items.isNotEmpty
        ? _items
        : (_text.isEmpty
              ? const <Map<String, Object?>>[]
              : <Map<String, Object?>>[
                  {'id': _text, 'label': _text},
                ]);
    final dense = widget.props['dense'] == true;
    final padding =
        coercePadding(widget.props['padding']) ??
        EdgeInsets.symmetric(
          horizontal: dense ? 8 : 12,
          vertical: dense ? 4 : 6,
        );
    final bgcolor =
        coerceColor(widget.props['bgcolor'] ?? widget.props['background']) ??
        Theme.of(context).colorScheme.surface;
    final borderColor =
        coerceColor(widget.props['border_color']) ??
        Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.65);
    final radius = coerceDouble(widget.props['radius']) ?? 0;

    final left = <Widget>[];
    final right = <Widget>[];
    for (var i = 0; i < items.length; i += 1) {
      final item = items[i];
      final align = item['align']?.toString().toLowerCase();
      final widgetItem = _buildStatusItem(context, item, i, dense);
      if (align == 'right' || align == 'end') {
        right.add(widgetItem);
      } else {
        left.add(widgetItem);
      }
    }

    final bar = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bgcolor,
        borderRadius: radius > 0 ? BorderRadius.circular(radius) : null,
        border: Border(top: BorderSide(color: borderColor, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(child: Wrap(spacing: 6, runSpacing: 4, children: left)),
          if (right.isNotEmpty)
            Wrap(
              spacing: 6,
              runSpacing: 4,
              alignment: WrapAlignment.end,
              children: right,
            ),
        ],
      ),
    );
    return applyControlFrameLayout(
      props: widget.props,
      child: bar,
      clipToRadius: radius > 0,
      defaultRadius: radius > 0 ? radius : null,
    );
  }
}

Color _statusColor(BuildContext context, String? status) {
  final token = (status ?? '').toLowerCase();
  switch (token) {
    case 'ok':
    case 'success':
      return Colors.green;
    case 'warn':
    case 'warning':
      return Colors.orange;
    case 'error':
    case 'danger':
      return Theme.of(context).colorScheme.error;
    case 'info':
      return Theme.of(context).colorScheme.primary;
    case 'idle':
      return Theme.of(context).colorScheme.outline;
    default:
      return Colors.transparent;
  }
}
