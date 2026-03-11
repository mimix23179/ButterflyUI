import 'dart:async';

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_theme.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/common/icon_value.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class ButterflyUISidebar extends StatefulWidget {
  const ButterflyUISidebar({
    super.key,
    required this.controlId,
    required this.sections,
    required this.selectedId,
    required this.showSearch,
    required this.query,
    required this.collapsible,
    required this.dense,
    required this.emitOnSearchChange,
    required this.searchDebounceMs,
    required this.events,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
    this.props = const <String, Object?>{},
  });

  final String controlId;
  final List<Map<String, Object?>> sections;
  final String? selectedId;
  final bool showSearch;
  final String query;
  final bool collapsible;
  final bool dense;
  final bool emitOnSearchChange;
  final int searchDebounceMs;
  final Set<String> events;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;
  final Map<String, Object?> props;

  @override
  State<ButterflyUISidebar> createState() => _ButterflyUISidebarState();
}

class _SidebarItem {
  const _SidebarItem({
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

class _SidebarSection {
  const _SidebarSection({
    required this.id,
    required this.title,
    required this.items,
    required this.collapsed,
  });

  final String id;
  final String title;
  final List<_SidebarItem> items;
  final bool collapsed;
}

class _ButterflyUISidebarState extends State<ButterflyUISidebar> {
  late TextEditingController _controller;
  Timer? _searchDebounce;
  Map<String, Object?> _liveProps = const <String, Object?>{};
  String _query = '';
  String? _selectedId;
  bool _showSearch = false;
  bool _collapsible = false;
  bool _dense = false;
  bool _emitOnSearchChange = true;
  int _searchDebounceMs = 180;
  List<Map<String, Object?>> _sections = const <Map<String, Object?>>[];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _syncFromProps(widget.props);
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant ButterflyUISidebar oldWidget) {
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
    _controller.dispose();
    super.dispose();
  }

  void _syncFromProps(Map<String, Object?> props) {
    _liveProps = <String, Object?>{...props};
    _query = _liveProps['query']?.toString() ?? widget.query;
    _selectedId =
        _liveProps['selected_id']?.toString() ??
        _liveProps['selected']?.toString() ??
        _liveProps['value']?.toString() ??
        widget.selectedId;
    _showSearch = _liveProps['show_search'] == true || widget.showSearch;
    _collapsible = _liveProps['collapsible'] == true || widget.collapsible;
    _dense = _liveProps['dense'] == true || widget.dense;
    _emitOnSearchChange = _liveProps['emit_on_search_change'] == null
        ? widget.emitOnSearchChange
        : (_liveProps['emit_on_search_change'] == true);
    _searchDebounceMs =
        coerceOptionalInt(_liveProps['search_debounce_ms']) ??
        widget.searchDebounceMs;
    final rawSections = _liveProps['sections'];
    if (rawSections is List) {
      _sections = rawSections
          .whereType<Map>()
          .map(coerceObjectMap)
          .toList(growable: false);
    } else if (_liveProps['items'] is List) {
      _sections = <Map<String, Object?>>[
        <String, Object?>{
          'id': 'items',
          'title': _liveProps['title'] ?? 'Items',
          'items': _liveProps['items'],
        },
      ];
    } else {
      _sections = widget.sections;
    }
    if (_controller.text != _query) {
      _controller.text = _query;
    }
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_selected':
        setState(() {
          _selectedId =
              args['selected_id']?.toString() ??
              args['selected']?.toString() ??
              args['value']?.toString();
        });
        return _statePayload();
      case 'set_props':
        final incoming = args['props'];
        if (incoming is Map) {
          final props = coerceObjectMap(incoming);
          setState(() {
            _syncFromProps(<String, Object?>{..._liveProps, ...props});
          });
        }
        return _statePayload();
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
        throw UnsupportedError('Unknown sidebar method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{'selected_id': _selectedId, 'query': _query};
  }

  bool _allowsEvent(String name) {
    if (widget.events.isEmpty) return true;
    return widget.events.contains(name);
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    if (!_allowsEvent(event)) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  void _onSearchChanged(String value) {
    setState(() => _query = value);
    if (!_emitOnSearchChange) return;
    _searchDebounce?.cancel();
    final delay = _searchDebounceMs < 0 ? 0 : _searchDebounceMs;
    if (delay == 0) {
      _emit('search', {'query': value});
      return;
    }
    _searchDebounce = Timer(Duration(milliseconds: delay), () {
      _emit('search', {'query': value});
    });
  }

  List<_SidebarSection> _parseSections() {
    final out = <_SidebarSection>[];
    for (var s = 0; s < _sections.length; s += 1) {
      final section = _sections[s];
      final sectionId = (section['id'] ?? section['title'] ?? s).toString();
      final title = section['title']?.toString() ?? 'Section';
      final collapsed = section['collapsed'] == true;
      final items = <_SidebarItem>[];
      final rawItems = section['items'];
      if (rawItems is List) {
        for (var i = 0; i < rawItems.length; i += 1) {
          final item = rawItems[i];
          if (item is Map) {
            final map = coerceObjectMap(item);
            final id =
                (map['id'] ?? map['value'] ?? map['label'] ?? '$sectionId-$i')
                    .toString();
            final label = (map['label'] ?? map['title'] ?? id).toString();
            items.add(
              _SidebarItem(
                id: id,
                label: label,
                icon: map['icon'] ?? map['glyph'] ?? map['leading_icon'],
                badge: map['badge']?.toString(),
                disabled: map['disabled'] == true,
                payload: map,
              ),
            );
          } else if (item != null) {
            final label = item.toString();
            items.add(
              _SidebarItem(
                id: '$sectionId-$label',
                label: label,
                icon: null,
                badge: null,
                disabled: false,
                payload: {'label': label},
              ),
            );
          }
        }
      }
      out.add(
        _SidebarSection(
          id: sectionId,
          title: title,
          items: items,
          collapsed: collapsed,
        ),
      );
    }
    return out;
  }

  bool _matchesQuery(_SidebarItem item) {
    if (_query.trim().isEmpty) return true;
    final needle = _query.toLowerCase();
    return item.label.toLowerCase().contains(needle) ||
        item.id.toLowerCase().contains(needle);
  }

  Widget _buildItem(
    BuildContext context,
    _SidebarItem item, {
    required bool dense,
    required Color selectedColor,
    required Color selectedTextColor,
    required Color textColor,
    required Color iconColor,
    required Color badgeColor,
  }) {
    final selected = _selectedId == item.id;
    final icon = buildIconValue(
      item.icon,
      size: dense ? 16 : 18,
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
        dense: dense,
        selected: selected,
        enabled: !item.disabled,
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
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  item.badge!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: selected ? selectedTextColor : textColor,
                  ),
                ),
              ),
        onTap: item.disabled
            ? null
            : () {
                setState(() {
                  _selectedId = item.id;
                });
                _emit('select', {
                  'id': item.id,
                  'label': item.label,
                  'item': item.payload,
                });
                _emit('change', {'selected_id': item.id, 'item': item.payload});
              },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sections = _parseSections();
    final dense = _dense;
    final surface = butterflyuiResolveSurfaceChrome(
      context,
      _liveProps,
      fallbackRadius: 14,
      fallbackPadding: const EdgeInsets.all(8),
    );
    final selectedColor =
        coerceColor(_liveProps['selected_color']) ??
        butterflyuiPrimary(context).withValues(alpha: 0.16);
    final selectedTextColor =
        coerceColor(_liveProps['selected_text_color']) ?? butterflyuiPrimary(context);
    final textColor = butterflyuiResolveSlotColor(
      context,
      _liveProps,
      slot: 'label',
      explicit: _liveProps['text_color'],
    );
    final iconColor = butterflyuiResolveSlotColor(
      context,
      _liveProps,
      slot: 'icon',
      explicit: _liveProps['icon_color'],
      fallback: butterflyuiMutedText(context),
    );
    final badgeColor =
        butterflyuiResolveSlotColor(
          context,
          _liveProps,
          slot: 'background',
          explicit: _liveProps['badge_bgcolor'],
          fallback: butterflyuiSurfaceAlt(context).withValues(alpha: 0.82),
        ).withValues(alpha: 0.82);
    final padding = surface.contentPadding ?? const EdgeInsets.all(8);
    final radius = surface.radius;

    final listChildren = <Widget>[];
    for (final section in sections) {
      final visibleItems = section.items.where(_matchesQuery).toList();
      if (visibleItems.isEmpty) continue;
      if (_collapsible) {
        listChildren.add(
          ExpansionTile(
            title: Text(
              section.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            initiallyExpanded: !section.collapsed,
            onExpansionChanged: (expanded) {
              _emit('toggle_section', {'id': section.id, 'expanded': expanded});
            },
            children: [
              for (final item in visibleItems)
                _buildItem(
                  context,
                  item,
                  dense: dense,
                  selectedColor: selectedColor,
                  selectedTextColor: selectedTextColor,
                  textColor: textColor,
                  iconColor: iconColor,
                  badgeColor: badgeColor,
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
            _buildItem(
              context,
              item,
              dense: dense,
              selectedColor: selectedColor,
              selectedTextColor: selectedTextColor,
              textColor: textColor,
              iconColor: iconColor,
              badgeColor: badgeColor,
            ),
          );
        }
      }
    }

    final searchHint =
        widget.props['search_placeholder']?.toString() ?? 'Search';
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_showSearch)
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
            child: TextField(
              controller: _controller,
              onChanged: _onSearchChanged,
              onSubmitted: (value) {
                _query = value;
                _emit('search_submit', {'query': value});
              },
              decoration: InputDecoration(
                isDense: true,
                prefixIcon: const Icon(Icons.search),
                hintText: searchHint,
              ),
            ),
          ),
        Expanded(
          child: ListView(padding: EdgeInsets.zero, children: listChildren),
        ),
      ],
    );

    final sidebar = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: surface.backgroundColor,
        gradient: surface.gradient,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: surface.borderColor,
          width: surface.borderWidth,
        ),
        boxShadow: surface.boxShadow,
      ),
      child: body,
    );
    return applyControlFrameLayout(
      props: _liveProps,
      child: sidebar,
      clipToRadius: true,
      defaultRadius: radius,
    );
  }
}
