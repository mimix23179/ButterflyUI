import 'dart:async';

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class _SearchSuggestion {
  final String id;
  final String label;
  final String? subtitle;
  final Map<String, Object?> payload;

  const _SearchSuggestion({
    required this.id,
    required this.label,
    required this.subtitle,
    required this.payload,
  });
}

class _SearchFilter {
  final String id;
  final String label;
  final bool enabled;
  final Color? color;

  const _SearchFilter({
    required this.id,
    required this.label,
    required this.enabled,
    required this.color,
  });
}

Widget buildSearchBarControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return ButterflyUISearchBar(
    controlId: controlId,
    props: props,
    sendEvent: sendEvent,
  );
}

class ButterflyUISearchBar extends StatefulWidget {
  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUISearchBar({
    super.key,
    required this.controlId,
    required this.props,
    required this.sendEvent,
  });

  @override
  State<ButterflyUISearchBar> createState() => _ButterflyUISearchBarState();
}

class _ButterflyUISearchBarState extends State<ButterflyUISearchBar> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  Timer? _debounce;
  String _query = '';
  Set<String> _selectedFilters = <String>{};

  @override
  void initState() {
    super.initState();
    _query = _resolveQuery(widget.props);
    _controller = TextEditingController(text: _query);
    _focusNode = FocusNode();
    _selectedFilters = _coerceStringSet(
      widget.props['values'] ??
          widget.props['selected'] ??
          widget.props['selected_filters'],
    );
  }

  @override
  void didUpdateWidget(covariant ButterflyUISearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.props == widget.props) return;
    final nextQuery = _resolveQuery(widget.props);
    if (nextQuery != _query) {
      _query = nextQuery;
      _controller.value = _controller.value.copyWith(
        text: nextQuery,
        selection: TextSelection.collapsed(offset: nextQuery.length),
      );
    }
    _selectedFilters = _coerceStringSet(
      widget.props['values'] ??
          widget.props['selected'] ??
          widget.props['selected_filters'],
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.props['disabled'] == true
        ? false
        : (widget.props['enabled'] == null || widget.props['enabled'] == true);
    final dense = widget.props['dense'] == true;
    final showClear = widget.props['show_clear'] == null
        ? true
        : (widget.props['show_clear'] == true);
    final loading = widget.props['loading'] == true;
    final showSuggestions = widget.props['show_suggestions'] == null
        ? true
        : (widget.props['show_suggestions'] == true);
    final showFilters = widget.props['show_filters'] == true;
    final maxSuggestions =
        (coerceOptionalInt(widget.props['max_suggestions']) ?? 6).clamp(1, 24);

    final suggestions = _coerceSuggestions(widget.props['suggestions']);
    final filters = _coerceFilters(
      widget.props['filters'] ?? widget.props['options'],
    );
    final visibleSuggestions = suggestions
        .where((item) => _matchesQuery(item, _query))
        .take(maxSuggestions)
        .toList(growable: false);
    final autofocus =
        widget.props['autofocus'] == true || widget.props['auto_focus'] == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          enabled: enabled,
          autofocus: autofocus,
          onChanged: _handleChange,
          onSubmitted: _handleSubmit,
          decoration: InputDecoration(
            isDense: dense,
            hintText:
                (widget.props['placeholder'] ??
                        widget.props['hint'] ??
                        'Search')
                    .toString(),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (loading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                if (showClear && _query.isNotEmpty)
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: enabled ? _clear : null,
                    icon: const Icon(Icons.close),
                    tooltip: 'Clear',
                  ),
              ],
            ),
          ),
        ),
        if (showFilters && filters.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: dense ? 4 : 8,
            runSpacing: dense ? 4 : 8,
            children: filters
                .map((filter) {
                  final selected = _selectedFilters.contains(filter.id);
                  return FilterChip(
                    selected: selected,
                    label: Text(filter.label),
                    onSelected: filter.enabled
                        ? (value) =>
                              _toggleFilter(filter.id, filter.label, value)
                        : null,
                    backgroundColor: filter.color?.withValues(alpha: 0.12),
                    selectedColor: filter.color?.withValues(alpha: 0.25),
                  );
                })
                .toList(growable: false),
          ),
        ],
        if (showSuggestions &&
            visibleSuggestions.isNotEmpty &&
            (_focusNode.hasFocus || _query.trim().isNotEmpty)) ...[
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 220),
            child: Card(
              margin: EdgeInsets.zero,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: visibleSuggestions.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = visibleSuggestions[index];
                  return ListTile(
                    dense: dense,
                    title: Text(item.label),
                    subtitle: item.subtitle == null
                        ? null
                        : Text(
                            item.subtitle!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                    onTap: enabled ? () => _selectSuggestion(item) : null,
                  );
                },
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _handleChange(String value) {
    _query = value;
    setState(() {});

    _debounce?.cancel();
    final debounceMs = coerceOptionalInt(widget.props['debounce_ms']) ?? 180;
    if (debounceMs <= 0) {
      _emitQueryChange(value);
      return;
    }
    _debounce = Timer(Duration(milliseconds: debounceMs), () {
      _emitQueryChange(value);
    });
  }

  void _handleSubmit(String value) {
    _debounce?.cancel();
    _query = value;
    _emit('submit', <String, Object?>{
      'value': value,
      'query': value,
      'filters': _selectedFilters.toList(growable: false),
    });
    _emit('search', <String, Object?>{
      'value': value,
      'query': value,
      'submitted': true,
      'filters': _selectedFilters.toList(growable: false),
    });
  }

  void _clear() {
    _debounce?.cancel();
    setState(() {
      _query = '';
      _controller.clear();
    });
    _emit('clear', {'value': '', 'query': ''});
    _emitQueryChange('');
  }

  void _toggleFilter(String id, String label, bool selected) {
    setState(() {
      if (selected) {
        _selectedFilters.add(id);
      } else {
        _selectedFilters.remove(id);
      }
    });
    final values = _selectedFilters.toList(growable: false);
    _emit('filter_toggle', {
      'id': id,
      'label': label,
      'selected': selected,
      'values': values,
      'query': _query,
    });
    _emit('change', {'value': _query, 'query': _query, 'filters': values});
  }

  void _selectSuggestion(_SearchSuggestion item) {
    final fillOnSelect = widget.props['fill_on_select'] == null
        ? true
        : (widget.props['fill_on_select'] == true);
    if (fillOnSelect) {
      _controller.value = _controller.value.copyWith(
        text: item.label,
        selection: TextSelection.collapsed(offset: item.label.length),
      );
      _query = item.label;
    }
    _emit('suggestion_select', <String, Object?>{
      'id': item.id,
      'label': item.label,
      'query': _query,
      'item': item.payload,
    });
    _emit('select', <String, Object?>{
      'id': item.id,
      'label': item.label,
      'query': _query,
      'item': item.payload,
    });
    _emit('search', <String, Object?>{
      'query': _query,
      'value': _query,
      'selected_id': item.id,
      'item': item.payload,
    });
    setState(() {});
  }

  void _emitQueryChange(String value) {
    final filters = _selectedFilters.toList(growable: false);
    _emit('change', <String, Object?>{
      'value': value,
      'query': value,
      'filters': filters,
    });
    _emit('search', <String, Object?>{
      'value': value,
      'query': value,
      'filters': filters,
      'submitted': false,
    });
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }
}

String _resolveQuery(Map<String, Object?> props) {
  final value = props['query'] ?? props['value'];
  return value?.toString() ?? '';
}

bool _matchesQuery(_SearchSuggestion item, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return true;
  if (item.label.toLowerCase().contains(q)) return true;
  final subtitle = item.subtitle?.toLowerCase();
  return subtitle != null && subtitle.contains(q);
}

Set<String> _coerceStringSet(Object? value) {
  final out = <String>{};
  if (value is List) {
    for (final item in value) {
      final text = item?.toString();
      if (text != null && text.isNotEmpty) out.add(text);
    }
    return out;
  }
  final single = value?.toString();
  if (single != null && single.isNotEmpty) {
    out.add(single);
  }
  return out;
}

List<_SearchSuggestion> _coerceSuggestions(Object? raw) {
  if (raw is! List) return const [];
  final out = <_SearchSuggestion>[];
  for (var i = 0; i < raw.length; i += 1) {
    final item = raw[i];
    if (item == null) continue;
    if (item is Map) {
      final map = coerceObjectMap(item);
      final id =
          (map['id'] ?? map['value'] ?? map['key'] ?? map['label'] ?? 'item_$i')
              .toString();
      final label = (map['label'] ?? map['title'] ?? map['text'] ?? id)
          .toString();
      final subtitle = (map['subtitle'] ?? map['description'])?.toString();
      out.add(
        _SearchSuggestion(
          id: id,
          label: label,
          subtitle: subtitle,
          payload: map,
        ),
      );
      continue;
    }
    final text = item.toString();
    if (text.isEmpty) continue;
    out.add(
      _SearchSuggestion(
        id: text,
        label: text,
        subtitle: null,
        payload: {'value': text},
      ),
    );
  }
  return out;
}

List<_SearchFilter> _coerceFilters(Object? raw) {
  if (raw is! List) return const [];
  final out = <_SearchFilter>[];
  for (var i = 0; i < raw.length; i += 1) {
    final item = raw[i];
    if (item == null) continue;
    if (item is Map) {
      final map = coerceObjectMap(item);
      final id = (map['id'] ?? map['value'] ?? map['key'] ?? map['label'])
          ?.toString();
      if (id == null || id.isEmpty) continue;
      final label = (map['label'] ?? map['title'] ?? id).toString();
      out.add(
        _SearchFilter(
          id: id,
          label: label,
          enabled: map['enabled'] == null ? true : (map['enabled'] == true),
          color: coerceColor(map['color'] ?? map['bgcolor']),
        ),
      );
      continue;
    }
    final text = item.toString();
    if (text.isEmpty) continue;
    out.add(_SearchFilter(id: text, label: text, enabled: true, color: null));
  }
  return out;
}
