import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/common/icon_value.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildNavigationRingControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ButterflyUINavigationRing(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _RingItem {
  final String id;
  final String label;
  final Object? icon;
  final bool enabled;
  final String? badge;

  const _RingItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.enabled,
    required this.badge,
  });
}

class _ButterflyUINavigationRing extends StatefulWidget {
  const _ButterflyUINavigationRing({
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
  State<_ButterflyUINavigationRing> createState() =>
      _ButterflyUINavigationRingState();
}

class _ButterflyUINavigationRingState
    extends State<_ButterflyUINavigationRing> {
  List<_RingItem> _items = const <_RingItem>[];
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
  void didUpdateWidget(covariant _ButterflyUINavigationRing oldWidget) {
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
          final next =
              args['selected_id']?.toString() ??
              args['selected']?.toString() ??
              args['value']?.toString();
          if (next != null && next.isNotEmpty) {
            setState(() {
              _selectedId = next;
            });
          }
          return _statePayload();
        }
      case 'set_props':
        {
          final incoming = args['props'];
          if (incoming is Map) {
            final props = coerceObjectMap(incoming);
            setState(() {
              if (props.containsKey('items')) {
                _items = _parseItems(props['items']);
              }
              if (props.containsKey('selected_id') ||
                  props.containsKey('selected') ||
                  props.containsKey('value')) {
                _selectedId =
                    props['selected_id']?.toString() ??
                    props['selected']?.toString() ??
                    props['value']?.toString();
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
        throw UnsupportedError('Unknown navigation_ring method: $method');
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

  List<_RingItem> _parseItems(Object? rawItems) {
    if (rawItems is! List) {
      return const <_RingItem>[];
    }
    final out = <_RingItem>[];
    for (var i = 0; i < rawItems.length; i += 1) {
      final raw = rawItems[i];
      if (raw is! Map) continue;
      final map = coerceObjectMap(raw);
      final id = (map['id'] ?? map['value'] ?? i).toString();
      final label = (map['label'] ?? map['title'] ?? id).toString();
      out.add(
        _RingItem(
          id: id,
          label: label,
          icon: map['icon'] ?? map['glyph'] ?? map['leading_icon'],
          enabled: map['enabled'] == null ? true : (map['enabled'] == true),
          badge: map['badge']?.toString(),
        ),
      );
    }
    return out;
  }

  bool _showLabel({required String policy, required bool selected}) {
    switch (policy) {
      case 'always':
        return true;
      case 'never':
        return false;
      default:
        return selected;
    }
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  void _select(_RingItem item, int index) {
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
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) return const SizedBox.shrink();

    final dense = widget.props['dense'] == true;
    final policy = (widget.props['policy'] ?? 'selected_only')
        .toString()
        .toLowerCase()
        .replaceAll('-', '_');
    final spacing = coerceDouble(widget.props['spacing']) ?? (dense ? 6 : 10);
    final padding =
        coercePadding(widget.props['padding']) ??
        EdgeInsets.symmetric(
          horizontal: dense ? 8 : 12,
          vertical: dense ? 6 : 8,
        );
    final radius = coerceDouble(widget.props['radius']) ?? 999;

    final bgColor =
        coerceColor(widget.props['bgcolor'] ?? widget.props['background']) ??
        Theme.of(context).colorScheme.surface.withValues(alpha: 0.75);
    final borderColor =
        coerceColor(widget.props['border_color']) ??
        Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.7);
    final selectedColor =
        coerceColor(widget.props['selected_color']) ??
        Theme.of(context).colorScheme.primaryContainer;
    final selectedTextColor =
        coerceColor(widget.props['selected_text_color']) ??
        Theme.of(context).colorScheme.onPrimaryContainer;
    final textColor =
        coerceColor(widget.props['text_color']) ??
        Theme.of(context).colorScheme.onSurface;

    final ring = Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor, width: 1),
      ),
      padding: padding,
      child: Wrap(
        spacing: spacing,
        runSpacing: spacing,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (var i = 0; i < _items.length; i += 1)
            _buildChip(
              context: context,
              item: _items[i],
              index: i,
              dense: dense,
              policy: policy,
              selectedColor: selectedColor,
              selectedTextColor: selectedTextColor,
              textColor: textColor,
            ),
        ],
      ),
    );
    return applyControlFrameLayout(
      props: widget.props,
      child: ring,
      clipToRadius: true,
      defaultRadius: radius,
    );
  }

  Widget _buildChip({
    required BuildContext context,
    required _RingItem item,
    required int index,
    required bool dense,
    required String policy,
    required Color selectedColor,
    required Color selectedTextColor,
    required Color textColor,
  }) {
    final selected = _selectedId == item.id;
    final showLabel = _showLabel(policy: policy, selected: selected);
    final icon = buildIconValue(
      item.icon,
      size: dense ? 16 : 18,
      colorValue: selected ? selectedTextColor : textColor,
      color: selected ? selectedTextColor : textColor,
    );
    final chipPadding = EdgeInsets.symmetric(
      horizontal: showLabel ? (dense ? 10 : 12) : (dense ? 8 : 10),
      vertical: dense ? 6 : 8,
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: selected ? selectedColor : Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: selected
              ? selectedColor.withValues(alpha: 0.9)
              : Theme.of(
                  context,
                ).colorScheme.outlineVariant.withValues(alpha: 0.7),
          width: selected ? 1.2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: item.enabled ? () => _select(item, index) : null,
        child: Padding(
          padding: chipPadding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) icon,
              if (showLabel) ...[
                if (icon != null) const SizedBox(width: 8),
                Text(
                  item.label,
                  style: TextStyle(
                    color: selected ? selectedTextColor : textColor,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
              if (item.badge != null && item.badge!.isNotEmpty) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surface.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    item.badge!,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: selected ? selectedTextColor : textColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
