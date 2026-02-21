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
  String _query = '';

  @override
  void initState() {
    super.initState();
    _query = widget.query;
    _controller = TextEditingController(text: _query);
  }

  @override
  void didUpdateWidget(covariant ButterflyUISidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query != oldWidget.query && widget.query != _query) {
      _query = widget.query;
      _controller.text = widget.query;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
    final selected = widget.selectedId == item.id;
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
          : () => widget.sendEvent(widget.controlId, 'select', {'id': item.id, 'label': item.label}),
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
            onExpansionChanged: (value) => widget.sendEvent(
              widget.controlId,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showSearch)
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              onChanged: (value) {
                setState(() => _query = value);
                widget.sendEvent(widget.controlId, 'search', {'query': value});
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search',
              ),
            ),
          ),
        Expanded(
          child: ListView(
            children: listChildren,
          ),
        ),
      ],
    );
  }
}

