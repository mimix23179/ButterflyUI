import 'package:flutter/material.dart';

import 'package:conduit_runtime/src/core/control_utils.dart';
import 'package:conduit_runtime/src/core/controls/common/icon_value.dart';
import 'package:conduit_runtime/src/core/webview/webview_api.dart';

Widget buildContextMenuControl(
  String controlId,
  Map<String, Object?> props,
  Widget child,
  ConduitSendRuntimeEvent sendEvent,
) {
  return ConduitContextMenu(
    controlId: controlId,
    props: props,
    child: child,
    sendEvent: sendEvent,
  );
}

class _ContextAction {
  final String id;
  final String label;
  final Object? icon;
  final bool enabled;
  final bool separator;
  final Map<String, Object?> payload;

  const _ContextAction({
    required this.id,
    required this.label,
    required this.icon,
    required this.enabled,
    required this.separator,
    required this.payload,
  });
}

class ConduitContextMenu extends StatefulWidget {
  final String controlId;
  final Map<String, Object?> props;
  final Widget child;
  final ConduitSendRuntimeEvent sendEvent;

  const ConduitContextMenu({
    super.key,
    required this.controlId,
    required this.props,
    required this.child,
    required this.sendEvent,
  });

  @override
  State<ConduitContextMenu> createState() => _ConduitContextMenuState();
}

class _ConduitContextMenuState extends State<ConduitContextMenu> {
  Future<void> _showAt(Offset globalPosition) async {
    final actions = _parseActions(widget.props['items']);
    if (actions.isEmpty) return;

    if (widget.controlId.isNotEmpty) {
      widget.sendEvent(widget.controlId, 'open', {
        'x': globalPosition.dx,
        'y': globalPosition.dy,
      });
    }

    final overlay = Overlay.of(context).context.findRenderObject();
    if (overlay is! RenderBox) return;

    final selected = await showMenu<_ContextAction>(
      context: context,
      color: coerceColor(widget.props['bgcolor']),
      position: RelativeRect.fromRect(
        Rect.fromLTWH(globalPosition.dx, globalPosition.dy, 0, 0),
        Offset.zero & overlay.size,
      ),
      items: actions
          .map<PopupMenuEntry<_ContextAction>>((action) {
            if (action.separator) {
              return const PopupMenuDivider(height: 8);
            }
            final iconWidget = buildIconValue(action.icon, size: 16);
            return PopupMenuItem<_ContextAction>(
              value: action,
              enabled: action.enabled,
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    child: iconWidget ?? const SizedBox.shrink(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      action.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          })
          .toList(growable: false),
    );

    if (!mounted || widget.controlId.isEmpty) return;

    if (selected == null) {
      widget.sendEvent(widget.controlId, 'dismiss', {});
      return;
    }

    widget.sendEvent(widget.controlId, 'select', {
      'id': selected.id,
      'label': selected.label,
      'payload': selected.payload,
    });
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.props['enabled'] == null
        ? true
        : (widget.props['enabled'] == true);
    final trigger =
        (widget.props['trigger']?.toString().toLowerCase() ?? 'secondary');
    final showOnTap = trigger == 'tap' || widget.props['open_on_tap'] == true;

    Widget child = widget.child;
    if (child is SizedBox && widget.props['label'] != null) {
      child = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Text(widget.props['label']!.toString()),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onSecondaryTapDown: enabled
          ? (details) => _showAt(details.globalPosition)
          : null,
      onLongPressStart: enabled
          ? (details) {
              if (trigger == 'long_press') {
                _showAt(details.globalPosition);
              }
            }
          : null,
      onTapDown: enabled
          ? (details) {
              if (showOnTap) {
                _showAt(details.globalPosition);
              }
            }
          : null,
      child: child,
    );
  }
}

List<_ContextAction> _parseActions(Object? raw) {
  if (raw is! List) return const [];

  final actions = <_ContextAction>[];
  for (final item in raw) {
    if (item == null) continue;

    if (item is String &&
        (item.trim() == '-' || item.trim().toLowerCase() == 'separator')) {
      actions.add(
        const _ContextAction(
          id: '__separator__',
          label: '',
          icon: null,
          enabled: false,
          separator: true,
          payload: {},
        ),
      );
      continue;
    }

    if (item is! Map) {
      final label = item.toString();
      actions.add(
        _ContextAction(
          id: label,
          label: label,
          icon: null,
          enabled: true,
          separator: false,
          payload: {'label': label},
        ),
      );
      continue;
    }

    final map = coerceObjectMap(item);
    if (map['separator'] == true || map['type']?.toString() == 'separator') {
      actions.add(
        const _ContextAction(
          id: '__separator__',
          label: '',
          icon: null,
          enabled: false,
          separator: true,
          payload: {},
        ),
      );
      continue;
    }

    final label =
        (map['label'] ?? map['text'] ?? map['title'] ?? map['id'] ?? 'Item')
            .toString();
    final id = (map['id'] ?? map['value'] ?? label).toString();
    actions.add(
      _ContextAction(
        id: id,
        label: label,
        icon: map['icon'],
        enabled: map['enabled'] == null ? true : (map['enabled'] == true),
        separator: false,
        payload: {...map, 'id': id, 'label': label},
      ),
    );
  }

  return actions;
}
