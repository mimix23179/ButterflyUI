import 'package:flutter/material.dart';

import 'package:conduit_runtime/src/core/webview/webview_api.dart';
import 'package:conduit_runtime/src/core/controls/common/option_types.dart';

class ConduitRadioGroup extends StatefulWidget {
  final String controlId;
  final List<ConduitOption> options;
  final int index;
  final Object? explicitValue;
  final String? label;
  final bool enabled;
  final bool dense;
  final ConduitSendRuntimeEvent sendEvent;

  const ConduitRadioGroup({
    super.key,
    required this.controlId,
    required this.options,
    required this.index,
    required this.explicitValue,
    required this.label,
    required this.enabled,
    required this.dense,
    required this.sendEvent,
  });

  @override
  State<ConduitRadioGroup> createState() => _ConduitRadioGroupState();
}

class _ConduitRadioGroupState extends State<ConduitRadioGroup> {
  String? _valueKey;

  @override
  void initState() {
    super.initState();
    _valueKey = _resolveValue();
  }

  @override
  void didUpdateWidget(covariant ConduitRadioGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = _resolveValue(current: _valueKey);
    if (next != _valueKey) {
      setState(() {
        _valueKey = next;
      });
    }
  }

  String? _resolveValue({String? current}) {
    final options = widget.options;
    final explicit = widget.explicitValue?.toString();
    if (explicit != null && options.any((option) => option.key == explicit)) {
      return explicit;
    }
    if (current != null && options.any((option) => option.key == current)) {
      return current;
    }
    if (options.isEmpty) return null;
    if (widget.index >= 0 && widget.index < options.length) {
      return options[widget.index].key;
    }
    return options.first.key;
  }

  void _handleChanged(String? next) {
    if (next == null) return;
    setState(() {
      _valueKey = next;
    });
    final idx = widget.options.indexWhere((option) => option.key == next);
    if (idx < 0) return;
    final option = widget.options[idx];
    final payload = <String, Object?>{
      'value': option.value ?? option.label,
      'value_key': option.key,
      'label': option.label,
      'index': idx,
    };
    widget.sendEvent(widget.controlId, 'change', payload);
    widget.sendEvent(widget.controlId, 'input', payload);
  }

  @override
  Widget build(BuildContext context) {
    final options = widget.options;
    final label = widget.label;
    final tiles = options
        .map(
          (option) => RadioListTile<String>(
            value: option.key,
            groupValue: _valueKey,
            onChanged: (widget.enabled && option.enabled)
                ? _handleChanged
                : null,
            title: Text(option.label),
            dense: widget.dense,
            contentPadding: EdgeInsets.zero,
          ),
        )
        .toList();

    if (label == null || label.trim().isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: tiles,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text(label), const SizedBox(height: 4), ...tiles],
    );
  }
}
