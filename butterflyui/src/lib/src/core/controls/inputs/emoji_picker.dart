import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildEmojiPickerControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _EmojiPickerControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _EmojiPickerControl extends StatefulWidget {
  const _EmojiPickerControl({
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
  State<_EmojiPickerControl> createState() => _EmojiPickerControlState();
}

class _EmojiPickerControlState extends State<_EmojiPickerControl> {
  late String _value;
  late List<String> _emojis;
  late String _query;
  late String _category;
  late List<String> _recent;

  @override
  void initState() {
    super.initState();
    _syncFromProps(widget.props);
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant _EmojiPickerControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
    if (oldWidget.props != widget.props) {
      _syncFromProps(widget.props);
    }
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'get_value':
        return _value;
      case 'set_value':
        final next = (args['value'] ?? '').toString();
        setState(() => _value = next);
        widget.sendEvent(widget.controlId, 'change', {'value': _value});
        return _value;
      case 'set_category':
        final next = (args['category'] ?? '').toString();
        setState(() => _category = next);
        return _category;
      case 'search':
        final next = (args['query'] ?? '').toString();
        setState(() => _query = next);
        return _query;
      case 'emit':
        final event = (args['event'] ?? 'custom').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        widget.sendEvent(widget.controlId, event, payload);
        return true;
      default:
        throw UnsupportedError('Unknown emoji_picker method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final columns = (coerceOptionalInt(widget.props['columns']) ?? 8).clamp(2, 12);
    final spacing = coerceDouble(widget.props['spacing']) ?? 6;
    final showSearch = widget.props['show_search'] == true;
    final showRecent = widget.props['show_recent'] == true;
    final categories = _coerceStringList(widget.props['categories']);
    final includeMetadata = widget.props['include_metadata'] == true;
    final filtered = _applyFilter(_emojis, _query);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showSearch)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TextField(
              onChanged: (value) => setState(() => _query = value),
              decoration: const InputDecoration(
                hintText: 'Search emoji',
                isDense: true,
              ),
            ),
          ),
        if (categories.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: categories
                  .map(
                    (item) => ChoiceChip(
                      selected: _category == item,
                      label: Text(item),
                      onSelected: (_) => setState(() => _category = item),
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
        if (showRecent && _recent.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text('Recent: ${_recent.join(' ')}'),
          ),
        if (_value.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text('Selected: $_value'),
          ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filtered.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            mainAxisExtent: 32,
          ),
          itemBuilder: (context, index) {
            final emoji = filtered[index];
            final selected = emoji == _value;
            return InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                setState(() => _value = emoji);
                _recent.remove(emoji);
                _recent.insert(0, emoji);
                widget.sendEvent(widget.controlId, 'select', {
                  'index': index,
                  'value': emoji,
                  if (includeMetadata)
                    'meta': {
                      'short_name': emoji,
                      'category': _category,
                      'skin_tone': widget.props['skin_tone']?.toString(),
                    },
                });
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: selected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outlineVariant,
                    width: selected ? 2 : 1,
                  ),
                ),
                child: Center(child: Text(emoji, style: const TextStyle(fontSize: 18))),
              ),
            );
          },
        ),
      ],
    );
  }

  void _syncFromProps(Map<String, Object?> props) {
    _value = (props['value'] ?? '').toString();
    _emojis = _coerceEmojis(props['items'] ?? props['emojis']);
    _query = (props['query'] ?? '').toString();
    _category = (props['category'] ?? '').toString();
    _recent = _coerceStringList(props['recent']);
  }
}

List<String> _coerceEmojis(Object? value) {
  if (value is List) {
    final out = <String>[];
    for (final item in value) {
      final text = item?.toString() ?? '';
      if (text.isNotEmpty) out.add(text);
    }
    if (out.isNotEmpty) return out;
  }
  return const [
    '😀',
    '😁',
    '😂',
    '😎',
    '😍',
    '🤖',
    '🎉',
    '✨',
    '🔥',
    '🚀',
    '🌈',
    '🦋',
    '🍀',
    '🍎',
    '⚡',
    '🌟',
    '💫',
    '🌙',
    '🌞',
    '🌊',
    '🌪',     
  ];
}

List<String> _coerceStringList(Object? value) {
  if (value is! List) return const [];
  final out = <String>[];
  for (final item in value) {
    final text = item?.toString() ?? '';
    if (text.isNotEmpty) {
      out.add(text);
    }
  }
  return out;
}

List<String> _applyFilter(List<String> emojis, String query) {
  final normalized = query.trim();
  if (normalized.isEmpty) return emojis;
  return emojis.where((item) => item.contains(normalized)).toList(growable: false);
}
