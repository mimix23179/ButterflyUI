import 'dart:async';

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_theme.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/common/icon_value.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildDrawerControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ButterflyUIDrawerControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _DrawerItem {
  const _DrawerItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.badge,
    required this.disabled,
    required this.payload,
  });

  final String id;
  final String label;
  final Object? icon;
  final String? badge;
  final bool disabled;
  final Map<String, Object?> payload;
}

class _DrawerSection {
  const _DrawerSection({
    required this.id,
    required this.title,
    required this.items,
    required this.collapsed,
  });

  final String id;
  final String title;
  final List<_DrawerItem> items;
  final bool collapsed;
}

class _ButterflyUIDrawerControl extends StatefulWidget {
  const _ButterflyUIDrawerControl({
    required this.controlId,
    required this.props,
    required this.rawChildren,
    required this.buildChild,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final List<dynamic> rawChildren;
  final Widget Function(Map<String, Object?> child) buildChild;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_ButterflyUIDrawerControl> createState() =>
      _ButterflyUIDrawerControlState();
}

class _ButterflyUIDrawerControlState extends State<_ButterflyUIDrawerControl> {
  late TextEditingController _searchController;
  Timer? _searchDebounce;
  bool _open = false;
  bool _dismissible = true;
  bool _showSearch = false;
  bool _collapsible = false;
  bool _dense = false;
  String _side = 'left';
  String _query = '';
  String? _selectedId;
  double _size = 300;
  Color? _scrimColor;
  List<_DrawerSection> _sections = const <_DrawerSection>[];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _syncFromProps(widget.props);
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _ButterflyUIDrawerControl oldWidget) {
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
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _syncFromProps(Map<String, Object?> props) {
    _open = props['open'] == true;
    _dismissible = props['dismissible'] == null
        ? true
        : (props['dismissible'] == true);
    _showSearch = props['show_search'] == true;
    _collapsible = props['collapsible'] == true;
    _dense = props['dense'] == true;
    _side = _normalizeSide(
      props['side']?.toString() ?? props['position']?.toString(),
    );
    _size =
        coerceDouble(props['size'] ?? props['width'] ?? props['height']) ??
        300.0;
    _scrimColor = coerceColor(props['scrim_color']);
    _selectedId =
        props['selected_id']?.toString() ??
        props['selected']?.toString() ??
        props['value']?.toString();
    _query = props['query']?.toString() ?? _query;
    if (_searchController.text != _query) {
      _searchController.text = _query;
    }
    _sections = _parseSections(
      props['sections'] is List ? props['sections'] : props['items'],
      fallbackTitle: props['title']?.toString() ?? 'Items',
    );
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_open':
        {
          final next = args['value'] == true || args['open'] == true;
          _setOpen(next, emitLifecycle: true);
          return _statePayload();
        }
      case 'set_selected':
        {
          setState(() {
            _selectedId =
                args['selected_id']?.toString() ??
                args['selected']?.toString() ??
                args['value']?.toString();
          });
          return _statePayload();
        }
      case 'set_query':
        {
          final next = args['query']?.toString() ?? '';
          setState(() {
            _query = next;
            _searchController.text = next;
          });
          _emit('search', {'query': next});
          return _statePayload();
        }
      case 'set_props':
        {
          final incoming = args['props'];
          if (incoming is Map) {
            final props = coerceObjectMap(incoming);
            setState(() {
              if (props.containsKey('open')) {
                _open = props['open'] == true;
              }
              if (props.containsKey('dismissible')) {
                _dismissible = props['dismissible'] == true;
              }
              if (props.containsKey('show_search')) {
                _showSearch = props['show_search'] == true;
              }
              if (props.containsKey('collapsible')) {
                _collapsible = props['collapsible'] == true;
              }
              if (props.containsKey('dense')) {
                _dense = props['dense'] == true;
              }
              if (props.containsKey('side') || props.containsKey('position')) {
                _side = _normalizeSide(
                  props['side']?.toString() ?? props['position']?.toString(),
                );
              }
              if (props.containsKey('size') ||
                  props.containsKey('width') ||
                  props.containsKey('height')) {
                _size =
                    coerceDouble(
                      props['size'] ?? props['width'] ?? props['height'],
                    ) ??
                    _size;
              }
              if (props.containsKey('scrim_color')) {
                _scrimColor = coerceColor(props['scrim_color']);
              }
              if (props.containsKey('query')) {
                _query = props['query']?.toString() ?? '';
                _searchController.text = _query;
              }
              if (props.containsKey('selected_id') ||
                  props.containsKey('selected') ||
                  props.containsKey('value')) {
                _selectedId =
                    props['selected_id']?.toString() ??
                    props['selected']?.toString() ??
                    props['value']?.toString();
              }
              if (props.containsKey('sections') || props.containsKey('items')) {
                final fallbackTitle =
                    props['title']?.toString() ??
                    widget.props['title']?.toString() ??
                    'Items';
                _sections = _parseSections(
                  props['sections'] is List
                      ? props['sections']
                      : props['items'],
                  fallbackTitle: fallbackTitle,
                );
              }
            });
            _emit('state', _statePayload());
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
        throw UnsupportedError('Unknown drawer method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    var itemCount = 0;
    for (final section in _sections) {
      itemCount += section.items.length;
    }
    return <String, Object?>{
      'open': _open,
      'side': _side,
      'size': _size,
      'dismissible': _dismissible,
      'selected_id': _selectedId,
      'query': _query,
      'show_search': _showSearch,
      'section_count': _sections.length,
      'item_count': itemCount,
    };
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  void _setOpen(bool next, {required bool emitLifecycle}) {
    if (_open == next) {
      _emit('state', _statePayload());
      return;
    }
    setState(() => _open = next);
    if (emitLifecycle) {
      _emit(next ? 'open' : 'close', _statePayload());
      _emit('change', _statePayload());
    }
    _emit('state', _statePayload());
  }

  void _dismiss() {
    if (!_dismissible) return;
    _setOpen(false, emitLifecycle: true);
    _emit('dismiss', _statePayload());
  }

  String _normalizeSide(String? raw) {
    switch ((raw ?? '').toLowerCase()) {
      case 'right':
      case 'top':
      case 'bottom':
      case 'left':
        return raw!.toLowerCase();
      default:
        return 'left';
    }
  }

  List<_DrawerSection> _parseSections(
    Object? raw, {
    required String fallbackTitle,
  }) {
    if (raw is! List) return const <_DrawerSection>[];
    final sections = <_DrawerSection>[];
    final looksLikeSections = raw.any((entry) {
      if (entry is! Map) return false;
      final map = coerceObjectMap(entry);
      return map['items'] is List || map['children'] is List;
    });

    if (!looksLikeSections) {
      sections.add(
        _DrawerSection(
          id: '__default__',
          title: fallbackTitle,
          items: _parseItems(raw, sectionId: '__default__'),
          collapsed: false,
        ),
      );
      return sections;
    }

    for (var s = 0; s < raw.length; s += 1) {
      final sectionRaw = raw[s];
      if (sectionRaw is! Map) continue;
      final map = coerceObjectMap(sectionRaw);
      final sectionId =
          (map['id'] ?? map['value'] ?? map['title'] ?? 'section_$s')
              .toString();
      final title = (map['title'] ?? map['label'] ?? 'Section ${s + 1}')
          .toString();
      final children = map['items'] is List ? map['items'] : map['children'];
      sections.add(
        _DrawerSection(
          id: sectionId,
          title: title,
          items: _parseItems(children, sectionId: sectionId),
          collapsed: map['collapsed'] == true,
        ),
      );
    }
    return sections;
  }

  List<_DrawerItem> _parseItems(Object? raw, {required String sectionId}) {
    if (raw is! List) return const <_DrawerItem>[];
    final items = <_DrawerItem>[];
    for (var i = 0; i < raw.length; i += 1) {
      final entry = raw[i];
      if (entry is Map) {
        final map = coerceObjectMap(entry);
        final id = (map['id'] ?? map['value'] ?? '$sectionId-$i').toString();
        final label = (map['label'] ?? map['title'] ?? map['text'] ?? id)
            .toString();
        items.add(
          _DrawerItem(
            id: id,
            label: label,
            icon: map['icon'] ?? map['glyph'] ?? map['leading_icon'],
            badge: map['badge']?.toString(),
            disabled: map['disabled'] == true || map['enabled'] == false,
            payload: map,
          ),
        );
      } else if (entry != null) {
        final label = entry.toString();
        items.add(
          _DrawerItem(
            id: '$sectionId-$label',
            label: label,
            icon: null,
            badge: null,
            disabled: false,
            payload: {'id': '$sectionId-$label', 'label': label},
          ),
        );
      }
    }
    return items;
  }

  bool _matchesQuery(_DrawerItem item) {
    if (_query.trim().isEmpty) return true;
    final needle = _query.toLowerCase();
    return item.label.toLowerCase().contains(needle) ||
        item.id.toLowerCase().contains(needle);
  }

  void _onSearchChanged(String value) {
    setState(() => _query = value);
    final emitOnChange = widget.props['emit_on_search_change'] == null
        ? true
        : (widget.props['emit_on_search_change'] == true);
    if (!emitOnChange) return;
    _searchDebounce?.cancel();
    final delay = coerceOptionalInt(widget.props['search_debounce_ms']) ?? 180;
    if (delay <= 0) {
      _emit('search', {'query': value});
      return;
    }
    _searchDebounce = Timer(Duration(milliseconds: delay), () {
      _emit('search', {'query': value});
    });
  }

  void _selectItem(_DrawerItem item) {
    setState(() => _selectedId = item.id);
    final payload = <String, Object?>{
      'id': item.id,
      'selected_id': item.id,
      'label': item.label,
      'item': item.payload,
    };
    _emit('select', payload);
    _emit('change', payload);
  }

  Widget _buildDefaultContent(BuildContext context) {
    final title = widget.props['title']?.toString();
    final subtitle = widget.props['subtitle']?.toString();
    final textColor =
        coerceColor(widget.props['text_color']) ??
        Theme.of(context).colorScheme.onSurface;
    final iconColor =
        coerceColor(widget.props['icon_color']) ??
        Theme.of(context).colorScheme.onSurfaceVariant;
    final selectedColor =
        coerceColor(widget.props['selected_color']) ??
        Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.7);
    final selectedTextColor =
        coerceColor(widget.props['selected_text_color']) ??
        Theme.of(context).colorScheme.onPrimaryContainer;

    final listChildren = <Widget>[];
    for (final section in _sections) {
      final visibleItems = section.items
          .where(_matchesQuery)
          .toList(growable: false);
      if (visibleItems.isEmpty) continue;
      if (_collapsible) {
        listChildren.add(
          ExpansionTile(
            title: Text(
              section.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            initiallyExpanded: !section.collapsed,
            children: [
              for (final item in visibleItems)
                _buildListItem(
                  context,
                  item,
                  textColor: textColor,
                  iconColor: iconColor,
                  selectedColor: selectedColor,
                  selectedTextColor: selectedTextColor,
                ),
            ],
          ),
        );
      } else {
        listChildren.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
            child: Text(
              section.title,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        );
        for (final item in visibleItems) {
          listChildren.add(
            _buildListItem(
              context,
              item,
              textColor: textColor,
              iconColor: iconColor,
              selectedColor: selectedColor,
              selectedTextColor: selectedTextColor,
            ),
          );
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null && title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 4),
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        if (subtitle != null && subtitle.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
            child: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          ),
        if (_showSearch)
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                isDense: true,
                prefixIcon: const Icon(Icons.search),
                hintText:
                    widget.props['search_placeholder']?.toString() ?? 'Search',
              ),
            ),
          ),
        Expanded(
          child: ListView(padding: EdgeInsets.zero, children: listChildren),
        ),
      ],
    );
  }

  Widget _buildListItem(
    BuildContext context,
    _DrawerItem item, {
    required Color textColor,
    required Color iconColor,
    required Color selectedColor,
    required Color selectedTextColor,
  }) {
    final selected = _selectedId == item.id;
    final icon = buildIconValue(
      item.icon,
      size: _dense ? 16 : 18,
      colorValue: selected ? selectedTextColor : iconColor,
      color: selected ? selectedTextColor : iconColor,
    );
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: selected ? selectedColor : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        dense: _dense,
        enabled: !item.disabled,
        selected: selected,
        leading: icon,
        title: Text(
          item.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: selected ? selectedTextColor : textColor,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        trailing: item.badge == null
            ? null
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surface.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  item.badge!,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: selected ? selectedTextColor : textColor,
                  ),
                ),
              ),
        onTap: item.disabled ? null : () => _selectItem(item),
      ),
    );
  }

  Widget _resolvePanelChild(BuildContext context) {
    for (final raw in widget.rawChildren) {
      if (raw is Map) {
        return widget.buildChild(coerceObjectMap(raw));
      }
    }
    final propChild = widget.props['child'];
    if (propChild is Map) {
      return widget.buildChild(coerceObjectMap(propChild));
    }
    return _buildDefaultContent(context);
  }

  @override
  Widget build(BuildContext context) {
    final durationMs =
        coerceOptionalInt(
          widget.props['duration_ms'] ?? widget.props['duration'],
        ) ??
        220;
    final curve = _curveFrom(widget.props['curve']?.toString());
    final size = MediaQuery.of(context).size;
    final horizontal = _side == 'left' || _side == 'right';
    final panelSize = _size <= 0
        ? (horizontal ? size.width * 0.3 : size.height * 0.3)
        : _size;
    final panelColor =
        coerceColor(widget.props['bgcolor'] ?? widget.props['background']) ??
        Theme.of(context).colorScheme.surface;
    final borderColor =
        coerceColor(widget.props['border_color']) ??
        Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.7);
    final elevation = coerceDouble(widget.props['elevation']) ?? 6.0;
    final radius = coerceDouble(widget.props['radius']) ?? 16.0;
    final panelClip =
        coerceClipBehavior(widget.props['clip_behavior']) ?? Clip.antiAlias;
    final panelMargin =
        coercePadding(widget.props['margin'] ?? widget.props['panel_margin']) ??
        EdgeInsets.zero;

    double left = 0;
    double top = 0;
    double? right;
    double? bottom;

    if (_side == 'left') {
      left = _open
          ? panelMargin.left
          : -(panelSize + panelMargin.left + panelMargin.right);
      top = panelMargin.top;
      bottom = panelMargin.bottom;
    } else if (_side == 'right') {
      right = _open
          ? panelMargin.right
          : -(panelSize + panelMargin.left + panelMargin.right);
      top = panelMargin.top;
      bottom = panelMargin.bottom;
    } else if (_side == 'top') {
      top = _open
          ? panelMargin.top
          : -(panelSize + panelMargin.top + panelMargin.bottom);
      left = panelMargin.left;
      right = panelMargin.right;
    } else {
      bottom = _open
          ? panelMargin.bottom
          : -(panelSize + panelMargin.top + panelMargin.bottom);
      left = panelMargin.left;
      right = panelMargin.right;
    }

    final panel = Material(
      type: MaterialType.transparency,
      child: Material(
        color: panelColor,
        elevation: elevation,
        clipBehavior: panelClip,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(color: borderColor, width: 1),
        ),
        child: _resolvePanelChild(context),
      ),
    );

    return Stack(
      children: [
        if (_open)
          Positioned.fill(
            child: GestureDetector(
              onTap: _dismissible ? _dismiss : null,
              child: Container(
                color: _scrimColor ?? butterflyuiScrim(context, opacity: 0.54),
              ),
            ),
          ),
        AnimatedPositioned(
          duration: Duration(milliseconds: durationMs.clamp(0, 2000)),
          curve: curve,
          left: _side == 'right' ? null : left,
          right: _side == 'right' ? right : null,
          top: _side == 'bottom' ? null : top,
          bottom: _side == 'bottom' ? bottom : null,
          width: horizontal ? panelSize : null,
          height: horizontal ? null : panelSize,
          child: panel,
        ),
      ],
    );
  }

  Curve _curveFrom(String? raw) {
    switch ((raw ?? '').toLowerCase().replaceAll('-', '_')) {
      case 'linear':
        return Curves.linear;
      case 'ease_in':
      case 'easein':
        return Curves.easeIn;
      case 'ease_in_out':
      case 'easeinout':
        return Curves.easeInOut;
      default:
        return Curves.easeOutCubic;
    }
  }
}
