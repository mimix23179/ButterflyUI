import 'package:flutter/material.dart';

import 'package:conduit_runtime/src/core/control_utils.dart';
import 'package:conduit_runtime/src/core/webview/webview_api.dart';

Widget buildToastHostControl(
  String controlId,
  Map<String, Object?> props,
  ConduitSendRuntimeEvent sendEvent,
) {
  final items = _coerceItems(props['items'] ?? props['toasts']);
  final maxItems = (coerceOptionalInt(props['max_items']) ?? 4).clamp(1, 32);
  final spacing = coerceDouble(props['spacing']) ?? 8.0;
  final showLatestOnTop = props['latest_on_top'] == null
      ? true
      : (props['latest_on_top'] == true);
  final dismissible = props['dismissible'] == null
      ? true
      : (props['dismissible'] == true);

  var toRender = List<Map<String, Object?>>.from(items);
  if (showLatestOnTop) {
    toRender = toRender.reversed.toList();
  }
  if (toRender.length > maxItems) {
    toRender.removeRange(maxItems, toRender.length);
  }

  final alignment = _resolveAlignment(props['position']?.toString());
  final padding =
      coercePadding(props['padding']) ??
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
                    controlId: controlId,
                    item: item,
                    dismissible: dismissible,
                    sendEvent: sendEvent,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    ),
  );
}

class _ToastCard extends StatelessWidget {
  final String controlId;
  final Map<String, Object?> item;
  final bool dismissible;
  final ConduitSendRuntimeEvent sendEvent;

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
