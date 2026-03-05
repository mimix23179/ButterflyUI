import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/common/icon_value.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildContextMenuControl(
  String controlId,
  Map<String, Object?> props,
  Widget child,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return ButterflyUIContextMenu(
    controlId: controlId,
    props: props,
    child: child,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
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

class ButterflyUIContextMenu extends StatefulWidget {
  const ButterflyUIContextMenu({
    super.key,
    required this.controlId,
    required this.props,
    required this.child,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final Widget child;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<ButterflyUIContextMenu> createState() => _ButterflyUIContextMenuState();
}

class _ButterflyUIContextMenuState extends State<ButterflyUIContextMenu> {
  List<_ContextAction> _actions = const <_ContextAction>[];
  String _trigger = 'secondary';
  bool _openOnTap = false;
  bool _enabled = true;

  @override
  void initState() {
    super.initState();
    _syncFromProps(widget.props);
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant ButterflyUIContextMenu oldWidget) {
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
    _actions = _parseActions(props['items']);
    _trigger = (props['trigger']?.toString().toLowerCase() ?? 'secondary');
    _openOnTap = props['open_on_tap'] == true;
    _enabled = props['enabled'] == null ? true : (props['enabled'] == true);
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_items':
        setState(() {
          _actions = _parseActions(args['items']);
        });
        return _statePayload();
      case 'set_props':
        {
          final rawProps = args['props'];
          if (rawProps is Map) {
            final props = coerceObjectMap(rawProps);
            setState(() {
              if (props.containsKey('items')) {
                _actions = _parseActions(props['items']);
              }
              if (props.containsKey('trigger')) {
                _trigger =
                    props['trigger']?.toString().toLowerCase() ?? _trigger;
              }
              if (props.containsKey('open_on_tap')) {
                _openOnTap = props['open_on_tap'] == true;
              }
              if (props.containsKey('enabled')) {
                _enabled = props['enabled'] == true;
              }
            });
          }
          return _statePayload();
        }
      case 'open_at':
        {
          final x = coerceDouble(args['x']);
          final y = coerceDouble(args['y']);
          final position = args['position'];
          Offset? target;
          if (x != null && y != null) {
            target = Offset(x, y);
          } else if (position is List && position.length >= 2) {
            final px = coerceDouble(position[0]);
            final py = coerceDouble(position[1]);
            if (px != null && py != null) {
              target = Offset(px, py);
            }
          }
          if (target != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              _showAt(target!);
            });
            return true;
          }
          return false;
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
        throw UnsupportedError('Unknown context_menu method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      'enabled': _enabled,
      'trigger': _trigger,
      'open_on_tap': _openOnTap,
      'item_count': _actions.where((action) => !action.separator).length,
    };
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  Future<void> _showAt(Offset globalPosition) async {
    if (_actions.isEmpty || !_enabled) return;

    _emit('open', {'x': globalPosition.dx, 'y': globalPosition.dy});

    final overlay = Overlay.of(context).context.findRenderObject();
    if (overlay is! RenderBox) return;

    final selected = await showMenu<_ContextAction>(
      context: context,
      color: coerceColor(widget.props['bgcolor']),
      elevation: coerceDouble(widget.props['elevation']),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          coerceDouble(widget.props['radius']) ?? 12,
        ),
      ),
      position: RelativeRect.fromRect(
        Rect.fromLTWH(globalPosition.dx, globalPosition.dy, 0, 0),
        Offset.zero & overlay.size,
      ),
      items: _actions
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

    if (!mounted) return;

    if (selected == null) {
      _emit('dismiss', {});
      return;
    }

    _emit('select', {
      'id': selected.id,
      'label': selected.label,
      'payload': selected.payload,
    });
    _emit('change', {
      'id': selected.id,
      'label': selected.label,
      'payload': selected.payload,
    });
  }

  @override
  Widget build(BuildContext context) {
    final showOnTap = _trigger == 'tap' || _openOnTap;

    Widget child = widget.child;
    if (child is SizedBox && widget.props['label'] != null) {
      child = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Text(widget.props['label']!.toString()),
      );
    }
    child = applyControlFrameLayout(
      props: widget.props,
      child: child,
      clipToRadius: true,
      defaultRadius: coerceDouble(widget.props['radius']),
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onSecondaryTapDown: _enabled
          ? (details) => _showAt(details.globalPosition)
          : null,
      onLongPressStart: _enabled
          ? (details) {
              if (_trigger == 'long_press') {
                _showAt(details.globalPosition);
              }
            }
          : null,
      onTapDown: _enabled
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
