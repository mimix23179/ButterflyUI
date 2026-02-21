import 'package:flutter/material.dart';

import 'package:conduit_runtime/src/core/webview/webview_api.dart';
import 'package:conduit_runtime/src/core/animation/animation_spec.dart';
import 'package:conduit_runtime/src/core/controls/common/option_types.dart';

class ConduitSelect extends StatefulWidget {
  final String controlId;
  final List<ConduitOption> options;
  final int index;
  final Object? explicitValue;
  final bool enabled;
  final bool dense;
  final String? label;
  final String? hint;
  final ConduitSendRuntimeEvent sendEvent;

  const ConduitSelect({
    super.key,
    required this.controlId,
    required this.options,
    required this.index,
    required this.explicitValue,
    required this.enabled,
    required this.dense,
    required this.label,
    required this.hint,
    required this.sendEvent,
  });

  @override
  State<ConduitSelect> createState() => _ConduitSelectState();
}

class _ConduitSelectState extends State<ConduitSelect> {
  String? _valueKey;

  @override
  void initState() {
    super.initState();
    _valueKey = _resolveValue();
  }

  @override
  void didUpdateWidget(covariant ConduitSelect oldWidget) {
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
    final explicitValue = widget.explicitValue?.toString();
    if (explicitValue != null &&
        options.any((option) => option.key == explicitValue)) {
      return explicitValue;
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

  void _emitSelection(String next) {
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

  void _handleChanged(String? next) {
    if (next == null) return;
    if (next == _valueKey) return;
    setState(() {
      _valueKey = next;
    });
    _emitSelection(next);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _valueKey,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        isDense: widget.dense,
      ),
      items: widget.options
          .map(
            (option) => DropdownMenuItem<String>(
              value: option.key,
              enabled: option.enabled,
              child: option.animation != null
                  ? AnimationSpec.fromJson(
                      option.animation,
                    ).wrap(Text(option.label))
                  : Text(option.label),
            ),
          )
          .toList(),
      onChanged: widget.enabled ? _handleChanged : null,
    );
  }
}
