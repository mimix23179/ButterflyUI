import 'dart:async';

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class ButterflyUISidebar extends StatefulWidget {
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
  });

  @override
  State<ButterflyUISidebar> createState() => _ButterflyUISidebarState();
}

class _SidebarItem {
  final String id;
  final String label;
  final String? icon;
  final String? badge;
  final bool disabled;

  const _SidebarItem({
    required this.id,
    required this.label,
    this.icon,
    this.badge,
    this.disabled = false,
  });
}

class _SidebarSection {
  final String title;
  final List<_SidebarItem> items;
  final bool collapsed;

  const _SidebarSection({
    required this.title,
    required this.items,
    required this.collapsed,
  });
}

class _ButterflyUISidebarState extends State<ButterflyUISidebar> {
  late TextEditingController _controller;
  Timer? _searchDebounce;
  String _query = '';
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _query = widget.query;
    _selectedId = widget.selectedId;
    _controller = TextEditingController(text: _query);
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
    if (widget.query != oldWidget.query && widget.query != _query) {
      _query = widget.query;
      _controller.text = widget.query;
    }
    if (widget.selectedId != oldWidget.selectedId) {
      _selectedId = widget.selectedId;
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

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_selected':
        setState(() {
          _selectedId =
              args['selected_id']?.toString() ?? args['selected']?.toString() ?? args['value']?.toString();
        });
        return _statePayload();
      case 'set_props':
        final incoming = args['props'];
        if (incoming is Map) {
          final props = Map<String, Object?>.from(incoming);
          setState(() {
            if (props.containsKey('query')) {
              _query = props['query']?.toString() ?? '';
              _controller.text = _query;
            }
            if (props.containsKey('selected_id') ||
                props.containsKey('selected') ||
                props.containsKey('value')) {
              _selectedId = props['selected_id']?.toString() ??
                  props['selected']?.toString() ??
                  props['value']?.toString();
            }
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
              ? Map<String, Object?>.from(args['payload'] as Map)
              : <String, Object?>{};
          _emit(event, payload);
          return true;
        }
      default:
        throw UnsupportedError('Unknown sidebar method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      'selected_id': _selectedId,
      'query': _query,
    };
  }

  bool _allowsEvent(String name) {
    if (widget.events.isEmpty) {
      return true;
    }
    return widget.events.contains(name);
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    if (!_allowsEvent(event)) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  void _onSearchChanged(String value) {
    setState(() => _query = value);
    if (!widget.emitOnSearchChange) return;
    _searchDebounce?.cancel();
    final delay = widget.searchDebounceMs < 0 ? 0 : widget.searchDebounceMs;
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
    for (final section in widget.sections) {
      final title = section['title']?.toString() ?? 'Section';
      final collapsed = section['collapsed'] == true;
      final items = <_SidebarItem>[];
      final rawItems = section['items'];
      if (rawItems is List) {
        for (final item in rawItems) {
          if (item is Map) {
            final id = item['id']?.toString() ?? item['label']?.toString() ?? '';
            if (id.isEmpty) continue;
            final label = item['label']?.toString() ?? id;
            items.add(
              _SidebarItem(
                id: id,
                label: label,
                icon: item['icon']?.toString(),
                badge: item['badge']?.toString(),
                disabled: item['disabled'] == true,
              ),
            );
          } else if (item != null) {
            final label = item.toString();
            items.add(_SidebarItem(id: label, label: label));
          }
        }
      }
      out.add(_SidebarSection(title: title, items: items, collapsed: collapsed));
    }
    return out;
  }

  bool _matchesQuery(_SidebarItem item) {
    if (_query.trim().isEmpty) return true;
    final lower = _query.toLowerCase();
    return item.label.toLowerCase().contains(lower) || item.id.toLowerCase().contains(lower);
  }

  Widget _buildItem(_SidebarItem item) {
    final selected = _selectedId == item.id;
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      dense: widget.dense,
      selected: selected,
      enabled: !item.disabled,
      leading: item.icon == null
          ? null
          : Text(
              item.icon!,
              style: const TextStyle(fontSize: 16),
            ),
      title: Text(
        item.label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: item.badge == null
          ? null
          : Text(
              item.badge!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall,
            ),
      selectedTileColor: colorScheme.primaryContainer.withValues(alpha: 0.4),
      onTap: item.disabled
          ? null
          : () {
              setState(() {
                _selectedId = item.id;
              });
              _emit('select', {'id': item.id, 'label': item.label});
            },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sections = _parseSections();
    final listChildren = <Widget>[];

    for (final section in sections) {
      final visibleItems = section.items.where(_matchesQuery).toList();
      if (visibleItems.isEmpty) continue;
      if (widget.collapsible) {
        listChildren.add(
          ExpansionTile(
            title: Text(
              section.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            initiallyExpanded: !section.collapsed,
                onExpansionChanged: (value) => _emit(
                  'toggle_section',
                  {'title': section.title, 'expanded': value},
                ),
            children: visibleItems.map(_buildItem).toList(),
          ),
        );
      } else {
        listChildren.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(section.title, style: Theme.of(context).textTheme.labelLarge),
          ),
        );
        listChildren.addAll(visibleItems.map(_buildItem));
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final hasBoundedHeight = constraints.hasBoundedHeight;
        final listView = ListView(children: listChildren);
        final listBody = hasBoundedHeight
            ? Expanded(child: listView)
            : SizedBox(height: 320, child: listView);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: hasBoundedHeight ? MainAxisSize.max : MainAxisSize.min,
          children: [
            if (widget.showSearch)
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: _controller,
                  onChanged: _onSearchChanged,
                  onSubmitted: (value) {
                    _query = value;
                    _emit('search_submit', {'query': value});
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search',
                  ),
                ),
              ),
            listBody,
          ],
        );
      },
    );
  }
}

