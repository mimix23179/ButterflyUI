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
  return _StatusBarControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _StatusBarControl extends StatefulWidget {
  const _StatusBarControl({
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
  State<_StatusBarControl> createState() => _StatusBarControlState();
}

class _StatusBarControlState extends State<_StatusBarControl> {
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
  void didUpdateWidget(covariant _StatusBarControl oldWidget) {
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
          items.add({'id': text, 'label': text});
        }
      }
    }
    return items;
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_items':
        setState(() {
          _items = _coerceItems(args['items']);
        });
        return _statePayload();
      case 'set_text':
        setState(() {
          _text = args['text']?.toString() ?? '';
        });
        return _statePayload();
      case 'get_state':
        return _statePayload();
      case 'emit':
        final event = (args['event'] ?? 'select').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        _emit(event, payload);
        return null;
      default:
        throw UnsupportedError('Unknown status_bar method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{'items': _items, 'text': _text};
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
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
        Theme.of(context).colorScheme.outlineVariant;

    Widget itemToWidget(Map<String, Object?> item, int index) {
      final label =
          (item['label'] ?? item['text'] ?? item['title'] ?? item['id'] ?? 'Item')
              .toString();
      final icon = buildIconValue(item['icon'], size: 14);
      final value = item['value']?.toString();
      final status = item['status']?.toString();
      final statusDot = status == null
          ? null
          : Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: _statusColor(context, status),
                shape: BoxShape.circle,
              ),
            );

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
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: dense ? 4 : 6,
            vertical: 2,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (statusDot != null) ...[statusDot, const SizedBox(width: 6)],
              if (icon != null) ...[icon, const SizedBox(width: 4)],
              Text(label),
              if (value != null && value.isNotEmpty) ...[
                const SizedBox(width: 6),
                Text(value, style: Theme.of(context).textTheme.labelSmall),
              ],
            ],
          ),
        ),
      );
    }

    final left = <Widget>[];
    final right = <Widget>[];
    for (var i = 0; i < items.length; i += 1) {
      final item = items[i];
      final align = item['align']?.toString().toLowerCase();
      if (align == 'right' || align == 'end') {
        right.add(itemToWidget(item, i));
      } else {
        left.add(itemToWidget(item, i));
      }
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bgcolor,
        border: Border(top: BorderSide(color: borderColor.withOpacity(0.6))),
      ),
      child: Row(
        children: [
          Expanded(child: Wrap(spacing: 4, runSpacing: 2, children: left)),
          if (right.isNotEmpty)
            Wrap(
              spacing: 4,
              runSpacing: 2,
              alignment: WrapAlignment.end,
              children: right,
            ),
        ],
      ),
    );
  }
}

Color _statusColor(BuildContext context, String status) {
  switch (status.toLowerCase()) {
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
    default:
      return Theme.of(context).colorScheme.secondary;
  }
}
