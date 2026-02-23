import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildReactionBarControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final rawItems = props['items'];
  final items = <Map<String, Object?>>[];
  if (rawItems is List) {
    for (final item in rawItems) {
      if (item is Map) {
        items.add(coerceObjectMap(item));
      }
    }
  }

  final selected = <String>{};
  final rawSelected = props['selected'];
  if (rawSelected is List) {
    for (final entry in rawSelected) {
      final id = entry?.toString();
      if (id != null && id.isNotEmpty) selected.add(id);
    }
  }

  final dense = props['dense'] == true;
  final maxVisible = (coerceOptionalInt(props['max_visible']) ?? items.length).clamp(0, items.length);

  return Wrap(
    spacing: dense ? 4 : 8,
    runSpacing: dense ? 4 : 8,
    children: [
      for (var i = 0; i < maxVisible; i += 1)
        _ReactionChip(
          controlId: controlId,
          item: items[i],
          selected: selected,
          sendEvent: sendEvent,
          dense: dense,
        ),
    ],
  );
}

class _ReactionChip extends StatefulWidget {
  const _ReactionChip({
    required this.controlId,
    required this.item,
    required this.selected,
    required this.sendEvent,
    required this.dense,
  });

  final String controlId;
  final Map<String, Object?> item;
  final Set<String> selected;
  final ButterflyUISendRuntimeEvent sendEvent;
  final bool dense;

  @override
  State<_ReactionChip> createState() => _ReactionChipState();
}

class _ReactionChipState extends State<_ReactionChip> {
  late bool _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected.contains(_id);
  }

  @override
  void didUpdateWidget(covariant _ReactionChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = widget.selected.contains(_id);
    if (next != _selected) {
      _selected = next;
    }
  }

  String get _id => (widget.item['id'] ?? widget.item['key'] ?? widget.item['emoji'] ?? '').toString();
  String get _label => (widget.item['label'] ?? widget.item['emoji'] ?? _id).toString();
  int get _count => coerceOptionalInt(widget.item['count']) ?? 0;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      visualDensity: widget.dense ? VisualDensity.compact : VisualDensity.standard,
      selected: _selected,
      label: Text(_count > 0 ? '$_label $_count' : _label),
      onSelected: (next) {
        setState(() {
          _selected = next;
        });
        if (widget.controlId.isEmpty) return;
        widget.sendEvent(widget.controlId, 'react', {
          'id': _id,
          'selected': next,
          'item': widget.item,
        });
      },
    );
  }
}
