import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class ButterflyUINotificationItem {
  final String id;
  final String title;
  final String message;
  final String? variant;
  final bool read;
  final String? timestamp;

  const ButterflyUINotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.variant,
    required this.read,
    required this.timestamp,
  });
}

List<ButterflyUINotificationItem> _parseNotificationItems(
  Map<String, Object?> props,
) {
  final raw = props['items'] ?? props['notifications'];
  if (raw is! List) return const [];
  final out = <ButterflyUINotificationItem>[];
  for (var i = 0; i < raw.length; i += 1) {
    final item = raw[i];
    if (item is! Map) continue;
    final map = coerceObjectMap(item);
    final id = (map['id'] ?? map['key'] ?? 'n_$i').toString();
    final title = (map['title'] ?? map['label'] ?? map['variant'] ?? 'Notification')
        .toString();
    final message = (map['message'] ?? map['text'] ?? '').toString();
    out.add(
      ButterflyUINotificationItem(
        id: id,
        title: title,
        message: message,
        variant: map['variant']?.toString(),
        read: map['read'] == true,
        timestamp: map['timestamp']?.toString(),
      ),
    );
  }
  return out;
}

class ButterflyUINotificationCenter extends StatefulWidget {
  final String controlId;
  final List<ButterflyUINotificationItem> initialItems;
  final String? title;
  final bool showClearAll;
  final int maxItems;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUINotificationCenter({
    super.key,
    required this.controlId,
    required this.initialItems,
    required this.title,
    required this.showClearAll,
    required this.maxItems,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<ButterflyUINotificationCenter> createState() =>
      _ButterflyUINotificationCenterState();
}

class _ButterflyUINotificationCenterState
    extends State<ButterflyUINotificationCenter> {
  late List<ButterflyUINotificationItem> _items =
      List<ButterflyUINotificationItem>.from(
    widget.initialItems,
  );

  @override
  void initState() {
    super.initState();
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant ButterflyUINotificationCenter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
    if (oldWidget.initialItems != widget.initialItems) {
      _items = List<ButterflyUINotificationItem>.from(widget.initialItems);
    }
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'clear':
      case 'clear_all':
        setState(() {
          _items.clear();
        });
        widget.sendEvent(widget.controlId, 'clear', {});
        return null;
      case 'add_item':
      case 'push':
        {
          final itemArgs = args['item'];
          if (itemArgs is Map) {
            final map = coerceObjectMap(itemArgs);
            final item = ButterflyUINotificationItem(
              id: (map['id'] ?? map['key'] ?? DateTime.now().microsecondsSinceEpoch.toString())
                  .toString(),
              title: (map['title'] ?? map['label'] ?? 'Notification').toString(),
              message: (map['message'] ?? map['text'] ?? '').toString(),
              variant: map['variant']?.toString(),
              read: map['read'] == true,
              timestamp: map['timestamp']?.toString(),
            );
            setState(() {
              _items.insert(0, item);
              if (_items.length > widget.maxItems) {
                _items = _items.take(widget.maxItems).toList(growable: false);
              }
            });
          }
          return null;
        }
      case 'remove':
      case 'dismiss':
        {
          final id = args['id']?.toString() ?? '';
          if (id.isEmpty) return null;
          setState(() {
            _items.removeWhere((item) => item.id == id);
          });
          return null;
        }
      case 'get_items':
        return _items
            .map(
              (item) => {
                'id': item.id,
                'title': item.title,
                'message': item.message,
                'variant': item.variant,
                'read': item.read,
                'timestamp': item.timestamp,
              },
            )
            .toList(growable: false);
      default:
        throw UnsupportedError('Unknown notification_center method: $method');
    }
  }

  void _dismiss(ButterflyUINotificationItem item) {
    setState(() {
      _items.removeWhere((entry) => entry.id == item.id);
    });
    widget.sendEvent(widget.controlId, 'dismiss', {
      'id': item.id,
      'title': item.title,
      'message': item.message,
    });
  }

  void _open(ButterflyUINotificationItem item) {
    widget.sendEvent(widget.controlId, 'open', {
      'id': item.id,
      'title': item.title,
      'message': item.message,
      'variant': item.variant,
      'timestamp': item.timestamp,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            dense: true,
            title: Text(widget.title ?? 'Notifications'),
            trailing: widget.showClearAll
                ? TextButton(
                    onPressed: _items.isEmpty
                        ? null
                        : () {
                            setState(() {
                              _items.clear();
                            });
                            widget.sendEvent(widget.controlId, 'clear', {});
                          },
                    child: const Text('Clear'),
                  )
                : null,
          ),
          const Divider(height: 1),
          if (_items.isEmpty)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text('No notifications'),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _items.length,
                separatorBuilder: (_, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return ListTile(
                    dense: true,
                    title: Text(item.title),
                    subtitle: item.message.isEmpty
                        ? null
                        : Text(item.message, maxLines: 2, overflow: TextOverflow.ellipsis),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () => _dismiss(item),
                    ),
                    onTap: () => _open(item),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

Widget buildNotificationCenterControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return ButterflyUINotificationCenter(
    controlId: controlId,
    initialItems: _parseNotificationItems(props),
    title: props['title']?.toString(),
    showClearAll: props['show_clear_all'] == null
        ? true
        : (props['show_clear_all'] == true),
    maxItems: (coerceOptionalInt(props['max_items']) ?? 100).clamp(1, 2000),
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}
