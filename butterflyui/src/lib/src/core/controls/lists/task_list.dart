import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildTaskListControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return ButterflyUITaskList(
    controlId: controlId,
    props: props,
    sendEvent: sendEvent,
  );
}

class ButterflyUITaskList extends StatefulWidget {
  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUITaskList({
    super.key,
    required this.controlId,
    required this.props,
    required this.sendEvent,
  });

  @override
  State<ButterflyUITaskList> createState() => _ButterflyUITaskListState();
}

class _ButterflyUITaskListState extends State<ButterflyUITaskList> {
  final Map<String, bool> _checked = <String, bool>{};

  @override
  void initState() {
    super.initState();
    _syncFromProps();
  }

  @override
  void didUpdateWidget(covariant ButterflyUITaskList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.props != widget.props) {
      _syncFromProps();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasks = _coerceTasks(widget.props['items']);
    if (tasks.isEmpty) return const SizedBox.shrink();

    final dense = widget.props['dense'] == true;
    final separator = widget.props['separator'] == true;
    final children = <Widget>[];

    for (var i = 0; i < tasks.length; i += 1) {
      final task = tasks[i];
      final value = _checked[task.id] ?? false;
      children.add(
        CheckboxListTile(
          dense: dense,
          value: value,
          title: Text(
            task.label,
            style: value
                ? const TextStyle(decoration: TextDecoration.lineThrough)
                : null,
          ),
          subtitle: task.description == null ? null : Text(task.description!),
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: task.enabled
              ? (checked) => _onToggle(task, checked == true)
              : null,
        ),
      );
      if (separator && i < tasks.length - 1) {
        children.add(const Divider(height: 1));
      }
    }

    return ListView(
      shrinkWrap: widget.props['shrink_wrap'] == null
          ? true
          : (widget.props['shrink_wrap'] == true),
      physics: const NeverScrollableScrollPhysics(),
      padding: coercePadding(widget.props['padding']),
      children: children,
    );
  }

  void _syncFromProps() {
    final tasks = _coerceTasks(widget.props['items']);
    final next = <String, bool>{};
    for (final task in tasks) {
      next[task.id] = task.done;
    }
    setState(() {
      _checked
        ..clear()
        ..addAll(next);
    });
  }

  void _onToggle(_TaskItem task, bool value) {
    setState(() {
      _checked[task.id] = value;
    });
    if (widget.controlId.isEmpty) return;
    final completed = _checked.entries.where((entry) => entry.value).length;
    widget.sendEvent(widget.controlId, 'toggle', {
      'id': task.id,
      'label': task.label,
      'value': value,
      'checked': value,
      'completed_count': completed,
      'total_count': _checked.length,
    });
    widget.sendEvent(widget.controlId, 'change', {
      'id': task.id,
      'values': _checked,
      'completed_count': completed,
      'total_count': _checked.length,
    });
  }
}

class _TaskItem {
  final String id;
  final String label;
  final String? description;
  final bool done;
  final bool enabled;

  const _TaskItem({
    required this.id,
    required this.label,
    required this.description,
    required this.done,
    required this.enabled,
  });
}

List<_TaskItem> _coerceTasks(Object? raw) {
  if (raw is! List) return const [];
  final out = <_TaskItem>[];
  for (var i = 0; i < raw.length; i += 1) {
    final item = raw[i];
    if (item is Map) {
      final map = coerceObjectMap(item);
      final id =
          (map['id'] ?? map['key'] ?? map['value'] ?? map['label'] ?? 'task_$i')
              .toString();
      final label = (map['label'] ?? map['title'] ?? map['text'] ?? id)
          .toString();
      out.add(
        _TaskItem(
          id: id,
          label: label,
          description: (map['description'] ?? map['subtitle'])?.toString(),
          done:
              map['done'] == true ||
              map['completed'] == true ||
              map['checked'] == true,
          enabled: map['enabled'] == null ? true : (map['enabled'] == true),
        ),
      );
      continue;
    }
    final text = item?.toString() ?? '';
    if (text.isEmpty) continue;
    out.add(
      _TaskItem(
        id: 'task_$i',
        label: text,
        description: null,
        done: false,
        enabled: true,
      ),
    );
  }
  return out;
}
