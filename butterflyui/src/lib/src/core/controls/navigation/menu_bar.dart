import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/common/icon_value.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildMenuBarControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return ButterflyUIMenuBar(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

Widget buildMenuItemControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final label =
      (props['label'] ?? props['text'] ?? props['title'] ?? 'Menu item')
          .toString();
  final subtitle = props['subtitle']?.toString();
  final iconWidget = buildIconValue(
    props['icon'] ?? props['leading_icon'],
    size: 18,
  );
  final trailingText =
      (props['shortcut'] ?? props['trailing_text'] ?? props['meta'])
          ?.toString();
  final enabled = props['enabled'] == null ? true : (props['enabled'] == true);

  void emitSelect() {
    if (controlId.isEmpty) return;
    sendEvent(controlId, 'select', {
      'id': props['id']?.toString() ?? label,
      'label': label,
      if (props['value'] != null) 'value': props['value'],
    });
  }

  return ListTile(
    dense: props['dense'] == true,
    enabled: enabled,
    selected: props['selected'] == true,
    leading: iconWidget,
    title: Text(label),
    subtitle: subtitle == null ? null : Text(subtitle),
    trailing: trailingText == null ? null : Text(trailingText),
    onTap: enabled ? emitSelect : null,
  );
}

class _MenuActionData {
  final String id;
  final String label;
  final String? shortcut;
  final Object? icon;
  final bool enabled;
  final bool danger;
  final bool separator;
  final Map<String, Object?> payload;

  const _MenuActionData({
    required this.id,
    required this.label,
    required this.shortcut,
    required this.icon,
    required this.enabled,
    required this.danger,
    required this.separator,
    required this.payload,
  });
}

class _MenuGroupData {
  final String id;
  final String label;
  final Object? icon;
  final List<_MenuActionData> actions;

  const _MenuGroupData({
    required this.id,
    required this.label,
    required this.icon,
    required this.actions,
  });
}

class ButterflyUIMenuBar extends StatefulWidget {
  const ButterflyUIMenuBar({
    super.key,
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
  State<ButterflyUIMenuBar> createState() => _ButterflyUIMenuBarState();
}

class _ButterflyUIMenuBarState extends State<ButterflyUIMenuBar> {
  List<_MenuGroupData> _groups = const <_MenuGroupData>[];
  bool _dense = false;

  @override
  void initState() {
    super.initState();
    _syncFromProps(widget.props);
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant ButterflyUIMenuBar oldWidget) {
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
      _syncFromProps(widget.props);
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  void _syncFromProps(Map<String, Object?> props) {
    _groups = _parseMenuGroups(props);
    _dense = props['dense'] == true;
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_menus':
      case 'set_items':
        {
          setState(() {
            final payload = <String, Object?>{
              ...widget.props,
              if (args.containsKey('menus')) 'menus': args['menus'],
              if (args.containsKey('items')) 'items': args['items'],
            };
            _groups = _parseMenuGroups(payload);
          });
          return _statePayload();
        }
      case 'set_props':
        {
          final incoming = args['props'];
          if (incoming is Map) {
            final props = coerceObjectMap(incoming);
            setState(() {
              final merged = <String, Object?>{...widget.props, ...props};
              _groups = _parseMenuGroups(merged);
              if (props.containsKey('dense')) {
                _dense = props['dense'] == true;
              }
            });
          }
          return _statePayload();
        }
      case 'get_state':
        return _statePayload();
      case 'emit':
      case 'trigger':
        {
          final fallback = method == 'trigger' ? 'change' : method;
          final event = (args['event'] ?? args['name'] ?? fallback).toString();
          final payload = args['payload'] is Map
              ? coerceObjectMap(args['payload'] as Map)
              : <String, Object?>{};
          _emit(event, payload);
          return true;
        }
      default:
        throw UnsupportedError('Unknown menu_bar method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    var actionCount = 0;
    for (final group in _groups) {
      actionCount += group.actions.where((action) => !action.separator).length;
    }
    return <String, Object?>{
      'dense': _dense,
      'menu_count': _groups.length,
      'action_count': actionCount,
    };
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  @override
  Widget build(BuildContext context) {
    final height = coerceDouble(widget.props['height']) ?? (_dense ? 34 : 40);
    final padding =
        coercePadding(widget.props['padding']) ??
        EdgeInsets.symmetric(horizontal: _dense ? 8 : 12, vertical: 4);

    final bgColor =
        coerceColor(widget.props['bgcolor'] ?? widget.props['background']) ??
        Theme.of(context).colorScheme.surface;
    final borderColor =
        coerceColor(
          widget.props['divider_color'] ?? widget.props['border_color'],
        ) ??
        Theme.of(context).colorScheme.outlineVariant;

    if (_groups.isEmpty) {
      final bar = Container(
        height: height,
        padding: padding,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: bgColor,
          border: Border(
            bottom: BorderSide(color: borderColor.withValues(alpha: 0.6)),
          ),
        ),
        child: Text(
          widget.props['title']?.toString() ?? 'Menu',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
      return applyControlFrameLayout(
        props: widget.props,
        child: bar,
        clipToRadius: true,
        defaultRadius: coerceDouble(widget.props['radius']),
      );
    }

    final bar = Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          bottom: BorderSide(color: borderColor.withValues(alpha: 0.6)),
        ),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _groups.length,
        separatorBuilder: (_, _) => const SizedBox(width: 4),
        itemBuilder: (context, index) {
          final group = _groups[index];
          return _MenuGroupButton(
            controlId: widget.controlId,
            group: group,
            dense: _dense,
            sendEvent: widget.sendEvent,
          );
        },
      ),
    );
    return applyControlFrameLayout(
      props: widget.props,
      child: bar,
      clipToRadius: true,
      defaultRadius: coerceDouble(widget.props['radius']),
    );
  }
}

class _MenuGroupButton extends StatelessWidget {
  const _MenuGroupButton({
    required this.controlId,
    required this.group,
    required this.dense,
    required this.sendEvent,
  });

  final String controlId;
  final _MenuGroupData group;
  final bool dense;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_MenuActionData>(
      tooltip: group.label,
      onOpened: () {
        if (controlId.isEmpty) return;
        sendEvent(controlId, 'open', {
          'menu_id': group.id,
          'label': group.label,
        });
      },
      onCanceled: () {
        if (controlId.isEmpty) return;
        sendEvent(controlId, 'dismiss', {
          'menu_id': group.id,
          'label': group.label,
        });
      },
      onSelected: (_MenuActionData action) {
        if (controlId.isEmpty) return;
        sendEvent(controlId, 'select', {
          'menu_id': group.id,
          'id': action.id,
          'label': action.label,
          'payload': action.payload,
        });
        sendEvent(controlId, 'change', {
          'menu_id': group.id,
          'id': action.id,
          'label': action.label,
          'payload': action.payload,
        });
      },
      itemBuilder: (context) {
        return group.actions
            .map<PopupMenuEntry<_MenuActionData>>((action) {
              if (action.separator) {
                return const PopupMenuDivider(height: 8);
              }

              final iconWidget = buildIconValue(action.icon, size: 16);
              final textColor = action.danger
                  ? Theme.of(context).colorScheme.error
                  : null;

              return PopupMenuItem<_MenuActionData>(
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
                        style: textColor == null
                            ? null
                            : TextStyle(color: textColor),
                      ),
                    ),
                    if (action.shortcut != null && action.shortcut!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          action.shortcut!,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                  ],
                ),
              );
            })
            .toList(growable: false);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: dense ? 8 : 10, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (group.icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child:
                    buildIconValue(group.icon, size: 16) ??
                    const SizedBox.shrink(),
              ),
            Text(group.label),
            const SizedBox(width: 2),
            const Icon(Icons.expand_more, size: 16),
          ],
        ),
      ),
    );
  }
}

List<_MenuGroupData> _parseMenuGroups(Map<String, Object?> props) {
  final groups = <_MenuGroupData>[];

  if (props['menus'] is List) {
    final rawMenus = props['menus'] as List;
    for (var i = 0; i < rawMenus.length; i += 1) {
      final raw = rawMenus[i];
      if (raw is! Map) continue;
      final menu = coerceObjectMap(raw);
      final label = (menu['label'] ?? menu['title'] ?? 'Menu ${i + 1}')
          .toString();
      final menuId = (menu['id'] ?? menu['value'] ?? label).toString();
      final actions = _parseMenuActions(menu['items'], parent: label);
      groups.add(
        _MenuGroupData(
          id: menuId,
          label: label,
          icon: menu['icon'],
          actions: actions,
        ),
      );
    }
  }

  if (groups.isEmpty && props['items'] is List) {
    final actions = _parseMenuActions(props['items'], parent: null);
    if (actions.isNotEmpty) {
      groups.add(
        _MenuGroupData(
          id: 'menu',
          label: props['label']?.toString() ?? 'Menu',
          icon: props['icon'],
          actions: actions,
        ),
      );
    }
  }

  return groups;
}

List<_MenuActionData> _parseMenuActions(
  Object? raw, {
  required String? parent,
}) {
  if (raw is! List) return const [];
  final actions = <_MenuActionData>[];

  for (final item in raw) {
    if (item == null) continue;

    if (item is String &&
        (item.trim() == '-' || item.trim().toLowerCase() == 'separator')) {
      actions.add(
        const _MenuActionData(
          id: '__separator__',
          label: '',
          shortcut: null,
          icon: null,
          enabled: false,
          danger: false,
          separator: true,
          payload: {},
        ),
      );
      continue;
    }

    if (item is! Map) {
      final label = item.toString();
      actions.add(
        _MenuActionData(
          id: label,
          label: label,
          shortcut: null,
          icon: null,
          enabled: true,
          danger: false,
          separator: false,
          payload: {'label': label},
        ),
      );
      continue;
    }

    final map = coerceObjectMap(item);
    if (map['separator'] == true || map['type']?.toString() == 'separator') {
      actions.add(
        const _MenuActionData(
          id: '__separator__',
          label: '',
          shortcut: null,
          icon: null,
          enabled: false,
          danger: false,
          separator: true,
          payload: {},
        ),
      );
      continue;
    }

    final nested = map['items'] is List ? map['items'] : map['children'];
    if (nested is List && nested.isNotEmpty) {
      final parentLabel = (map['label'] ?? map['title'] ?? map['id'] ?? 'Group')
          .toString();
      actions.addAll(
        _parseMenuActions(
          nested,
          parent: parent == null ? parentLabel : '$parent / $parentLabel',
        ),
      );
      continue;
    }

    final rawLabel =
        (map['label'] ?? map['text'] ?? map['title'] ?? map['id'] ?? 'Item')
            .toString();
    final label = parent == null ? rawLabel : '$parent / $rawLabel';
    final id = (map['id'] ?? map['value'] ?? rawLabel).toString();
    final payload = <String, Object?>{...map, 'id': id, 'label': rawLabel};

    actions.add(
      _MenuActionData(
        id: id,
        label: label,
        shortcut: (map['shortcut'] ?? map['meta'])?.toString(),
        icon: map['icon'],
        enabled: map['enabled'] == null ? true : (map['enabled'] == true),
        danger: map['danger'] == true || map['variant']?.toString() == 'danger',
        separator: false,
        payload: payload,
      ),
    );
  }

  return actions;
}
