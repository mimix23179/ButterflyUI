import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/common/icon_value.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildRailNavigationControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ButterflyUIRailNavigation(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _RailItem {
  final String id;
  final String label;
  final Object? icon;
  final Object? selectedIcon;
  final bool enabled;

  const _RailItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.enabled,
  });
}

class _ButterflyUIRailNavigation extends StatefulWidget {
  const _ButterflyUIRailNavigation({
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
  State<_ButterflyUIRailNavigation> createState() =>
      _ButterflyUIRailNavigationState();
}

class _ButterflyUIRailNavigationState
    extends State<_ButterflyUIRailNavigation> {
  List<_RailItem> _items = const <_RailItem>[];
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _ButterflyUIRailNavigation oldWidget) {
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
    _items = _parseItems(widget.props['items']);
    _selectedId =
        widget.props['selected_id']?.toString() ??
        widget.props['selected']?.toString() ??
        widget.props['value']?.toString();
    if ((_selectedId == null || _selectedId!.isEmpty) && _items.isNotEmpty) {
      _selectedId = _items.first.id;
    }
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_selected':
        {
          final selectedId =
              args['selected_id']?.toString() ??
              args['selected']?.toString() ??
              args['value']?.toString();
          if (selectedId != null && selectedId.isNotEmpty) {
            setState(() {
              _selectedId = selectedId;
            });
          }
          return _statePayload();
        }
      case 'set_props':
        {
          final incoming = args['props'];
          if (incoming is Map) {
            final map = coerceObjectMap(incoming);
            setState(() {
              if (map.containsKey('items')) {
                _items = _parseItems(map['items']);
              }
              if (map.containsKey('selected_id') ||
                  map.containsKey('selected') ||
                  map.containsKey('value')) {
                _selectedId =
                    map['selected_id']?.toString() ??
                    map['selected']?.toString() ??
                    map['value']?.toString();
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
        throw UnsupportedError('Unknown rail_navigation method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    final selected = _selectedId;
    final selectedIndex = _items.indexWhere((item) => item.id == selected);
    return <String, Object?>{
      'selected_id': selected,
      'selected_index': selectedIndex,
      'count': _items.length,
    };
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  List<_RailItem> _parseItems(Object? rawItems) {
    if (rawItems is! List) return const <_RailItem>[];
    final out = <_RailItem>[];
    for (var i = 0; i < rawItems.length; i += 1) {
      final raw = rawItems[i];
      if (raw is! Map) continue;
      final map = coerceObjectMap(raw);
      final id = (map['id'] ?? map['value'] ?? i).toString();
      final label = (map['label'] ?? map['title'] ?? id).toString();
      out.add(
        _RailItem(
          id: id,
          label: label,
          icon: map['icon'] ?? map['glyph'],
          selectedIcon: map['selected_icon'] ?? map['icon_selected'],
          enabled: map['enabled'] == null ? true : (map['enabled'] == true),
        ),
      );
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) return const SizedBox.shrink();

    final dense = widget.props['dense'] == true;
    final extended = widget.props['extended'] == true;
    final selectedId = _selectedId;

    var selectedIndex = 0;
    if (selectedId != null && selectedId.isNotEmpty) {
      final idx = _items.indexWhere((item) => item.id == selectedId);
      if (idx >= 0) selectedIndex = idx;
    }

    final bgColor =
        coerceColor(widget.props['bgcolor'] ?? widget.props['background']) ??
        Theme.of(context).colorScheme.surface;
    final indicatorColor =
        coerceColor(widget.props['indicator_color']) ??
        Theme.of(context).colorScheme.primaryContainer;
    final selectedIconColor =
        coerceColor(widget.props['selected_icon_color']) ??
        Theme.of(context).colorScheme.onPrimaryContainer;
    final unselectedIconColor =
        coerceColor(widget.props['icon_color']) ??
        Theme.of(context).colorScheme.onSurfaceVariant;
    final selectedLabelColor =
        coerceColor(widget.props['selected_text_color']) ??
        Theme.of(context).colorScheme.onPrimaryContainer;
    final unselectedLabelColor =
        coerceColor(widget.props['text_color']) ??
        Theme.of(context).colorScheme.onSurfaceVariant;

    final labelTypeToken =
        (widget.props['label_type'] ?? widget.props['policy'] ?? 'selected')
            .toString()
            .toLowerCase();
    final labelType = switch (labelTypeToken) {
      'all' || 'always' => NavigationRailLabelType.all,
      'none' || 'never' => NavigationRailLabelType.none,
      _ => NavigationRailLabelType.selected,
    };

    final minWidth =
        coerceDouble(widget.props['min_width']) ?? (dense ? 60 : 72);
    final minExtendedWidth =
        coerceDouble(widget.props['min_extended_width']) ?? 220;

    final rail = Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          right: BorderSide(
            color: Theme.of(
              context,
            ).colorScheme.outlineVariant.withValues(alpha: 0.6),
          ),
        ),
      ),
      child: NavigationRail(
        selectedIndex: selectedIndex,
        extended: extended,
        minWidth: minWidth,
        minExtendedWidth: minExtendedWidth,
        useIndicator: true,
        indicatorColor: indicatorColor,
        labelType: extended ? NavigationRailLabelType.none : labelType,
        selectedIconTheme: IconThemeData(color: selectedIconColor),
        unselectedIconTheme: IconThemeData(color: unselectedIconColor),
        selectedLabelTextStyle: TextStyle(
          color: selectedLabelColor,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelTextStyle: TextStyle(color: unselectedLabelColor),
        onDestinationSelected: widget.controlId.isEmpty
            ? null
            : (index) {
                final item = _items[index];
                if (!item.enabled) return;
                setState(() {
                  _selectedId = item.id;
                });
                final payload = <String, Object?>{
                  'id': item.id,
                  'selected_id': item.id,
                  'label': item.label,
                  'index': index,
                };
                _emit('select', payload);
                _emit('change', payload);
              },
        destinations: _items
            .map(
              (item) => NavigationRailDestination(
                icon: Opacity(
                  opacity: item.enabled ? 1.0 : 0.4,
                  child:
                      buildIconValue(item.icon, size: dense ? 18 : 20) ??
                      const Icon(Icons.circle_outlined, size: 18),
                ),
                selectedIcon:
                    buildIconValue(
                      item.selectedIcon ?? item.icon,
                      size: dense ? 18 : 20,
                    ) ??
                    buildIconValue(item.icon, size: dense ? 18 : 20) ??
                    const Icon(Icons.circle, size: 18),
                label: Text(item.label),
              ),
            )
            .toList(growable: false),
      ),
    );
    return applyControlFrameLayout(
      props: widget.props,
      child: rail,
      clipToRadius: true,
      defaultRadius: coerceDouble(widget.props['radius']),
    );
  }
}
