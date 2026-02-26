import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/common/icon_value.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildRailNavControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _RailNavControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _RailNavControl extends StatefulWidget {
  const _RailNavControl({
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
  State<_RailNavControl> createState() => _RailNavControlState();
}

class _RailNavControlState extends State<_RailNavControl> {
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.props['selected_id']?.toString();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _RailNavControl oldWidget) {
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
      _selectedId = widget.props['selected_id']?.toString();
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_selected':
        final next = args['selected_id']?.toString();
        if (next != null && next.isNotEmpty) {
          setState(() => _selectedId = next);
        }
        return _statePayload(_coerceItems(widget.props['items']));
      case 'get_state':
        return _statePayload(_coerceItems(widget.props['items']));
      case 'emit':
        final event = (args['event'] ?? 'select').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        if (widget.controlId.isNotEmpty) {
          widget.sendEvent(widget.controlId, event, payload);
        }
        return null;
      default:
        throw UnsupportedError('Unknown rail_nav method: $method');
    }
  }

  List<Map<String, Object?>> _coerceItems(Object? rawItems) {
    final items = <Map<String, Object?>>[];
    if (rawItems is List) {
      for (final item in rawItems) {
        if (item is Map) {
          items.add(coerceObjectMap(item));
        }
      }
    }
    return items;
  }

  Map<String, Object?> _statePayload(List<Map<String, Object?>> items) {
    final selected = _selectedId;
    var selectedIndex = 0;
    if (selected != null && selected.isNotEmpty) {
      final idx = items.indexWhere((e) => e['id']?.toString() == selected);
      if (idx >= 0) selectedIndex = idx;
    }
    return <String, Object?>{
      'selected_id': selected,
      'selected_index': selectedIndex,
      'count': items.length,
    };
  }

  @override
  Widget build(BuildContext context) {
    final items = _coerceItems(widget.props['items']);
    if (items.isEmpty) return const SizedBox.shrink();

    final selectedId = _selectedId;
    var selectedIndex = 0;
    if (selectedId != null && selectedId.isNotEmpty) {
      final idx = items.indexWhere((e) => e['id']?.toString() == selectedId);
      if (idx >= 0) selectedIndex = idx;
    }

    final extended = widget.props['extended'] == true;
    final dense = widget.props['dense'] == true;

    return NavigationRail(
      extended: extended,
      minWidth: dense ? 56 : null,
      labelType: extended ? null : NavigationRailLabelType.selected,
      selectedIndex: selectedIndex,
      onDestinationSelected: widget.controlId.isEmpty
          ? null
          : (index) {
              final item = items[index];
              final selectedId = (item['id'] ?? index).toString();
              final payload = {
                'id': selectedId,
                'selected_id': selectedId,
                'value': selectedId,
                'index': index,
                'item': item,
              };
              setState(() {
                _selectedId = selectedId;
              });
              widget.sendEvent(widget.controlId, 'select', payload);
              widget.sendEvent(widget.controlId, 'change', payload);
            },
      destinations: items
          .map(
            (item) => NavigationRailDestination(
              icon: buildIconValue(item['icon'], size: 18) ?? const Icon(Icons.circle_outlined, size: 18),
              selectedIcon:
                  buildIconValue(item['selected_icon'] ?? item['icon_selected'], size: 18) ??
                  buildIconValue(item['icon'], size: 18) ??
                  const Icon(Icons.circle, size: 18),
              label: Text((item['label'] ?? item['title'] ?? item['id'] ?? '').toString()),
            ),
          )
          .toList(growable: false),
    );
  }
}
