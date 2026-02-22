import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/controls/common/option_types.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class ButterflyUICombobox extends StatefulWidget {
  final String controlId;
  final List<ButterflyUIOption> options;
  final String value;
  final bool enabled;
  final String? label;
  final String? hint;
  final bool dense;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUICombobox({
    super.key,
    required this.controlId,
    required this.options,
    required this.value,
    required this.enabled,
    required this.label,
    required this.hint,
    required this.dense,
    required this.sendEvent,
  });

  @override
  State<ButterflyUICombobox> createState() => _ButterflyUIComboboxState();
}

class _ButterflyUIComboboxState extends State<ButterflyUICombobox> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.value,
  );

  @override
  void didUpdateWidget(covariant ButterflyUICombobox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && widget.value != _controller.text) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _emit(String value, {ButterflyUIOption? option}) {
    final payload = <String, Object?>{
      'value': value,
      if (option != null) 'value_key': option.key,
      if (option != null) 'label': option.label,
      if (option != null) 'option_value': option.value,
    };
    widget.sendEvent(widget.controlId, 'change', payload);
    widget.sendEvent(widget.controlId, 'input', payload);
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<ButterflyUIOption>(
      initialValue: TextEditingValue(text: widget.value),
      optionsBuilder: (text) {
        final q = text.text.trim().toLowerCase();
        if (q.isEmpty) {
          return widget.options.where((option) => option.enabled);
        }
        return widget.options.where(
          (option) => option.enabled && option.label.toLowerCase().contains(q),
        );
      },
      displayStringForOption: (option) => option.label,
      onSelected: (option) {
        _controller.text = option.label;
        _emit(option.label, option: option);
      },
      fieldViewBuilder: (context, textController, focusNode, onFieldSubmitted) {
        if (textController.text != _controller.text) {
          textController.text = _controller.text;
        }
        return TextField(
          controller: textController,
          focusNode: focusNode,
          enabled: widget.enabled,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            border: const OutlineInputBorder(),
            isDense: widget.dense,
          ),
          onChanged: (value) {
            _controller.text = value;
            _emit(value);
          },
          onSubmitted: (value) {
            _controller.text = value;
            _emit(value);
          },
        );
      },
    );
  }
}

Widget buildComboboxControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return ButterflyUICombobox(
    controlId: controlId,
    options: coerceOptionList(props['options'] ?? props['items']),
    value: (props['value'] ?? props['text'] ?? '').toString(),
    enabled: props['enabled'] == null ? true : (props['enabled'] == true),
    label: props['label']?.toString(),
    hint: (props['hint'] ?? props['placeholder'])?.toString(),
    dense: props['dense'] == true,
    sendEvent: sendEvent,
  );
}
