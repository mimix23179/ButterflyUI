import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/controls/common/option_types.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class ButterflyUIMultiSelect extends StatefulWidget {
  final String controlId;
  final List<ButterflyUIOption> options;
  final Set<String> selected;
  final bool enabled;
  final bool dense;
  final String? label;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUIMultiSelect({
    super.key,
    required this.controlId,
    required this.options,
    required this.selected,
    required this.enabled,
    required this.dense,
    required this.label,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<ButterflyUIMultiSelect> createState() => _ButterflyUIMultiSelectState();
}

class _ButterflyUIMultiSelectState extends State<ButterflyUIMultiSelect> {
  late Set<String> _selected = Set<String>.from(widget.selected);
  late List<ButterflyUIOption> _options = List<ButterflyUIOption>.from(widget.options);

  @override
  void initState() {
    super.initState();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant ButterflyUIMultiSelect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) {
      _selected = Set<String>.from(widget.selected);
    }
    if (oldWidget.options != widget.options) {
      _options = List<ButterflyUIOption>.from(widget.options);
    }
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'get_values':
        return _selected.toList(growable: false);
      case 'set_values':
        final next = <String>{};
        final values = args['values'];
        if (values is List) {
          for (final item in values) {
            final text = item?.toString();
            if (text != null && text.isNotEmpty) {
              next.add(text);
            }
          }
        }
        setState(() {
          _selected = next;
        });
        return _selected.toList(growable: false);
      case 'set_options':
        setState(() {
          _options = coerceOptionList(args['options'] ?? args['items']);
        });
        return {'count': _options.length};
      default:
        throw UnsupportedError('Unknown multi_select method: $method');
    }
  }

  void _emit(ButterflyUIOption option) {
    final ids = _selected.toList(growable: false);
    final labels = _options
        .where((item) => _selected.contains(item.key))
        .map((item) => item.label)
        .toList(growable: false);
    final payload = <String, Object?>{
      'value': ids,
      'values': ids,
      'labels': labels,
      'option': {
        'key': option.key,
        'label': option.label,
        'value': option.value,
      },
    };
    widget.sendEvent(widget.controlId, 'change', payload);
    widget.sendEvent(widget.controlId, 'input', payload);
  }

  @override
  Widget build(BuildContext context) {
    final chips = _options
        .map(
          (option) => FilterChip(
            label: Text(option.label),
            selected: _selected.contains(option.key),
            onSelected: (!widget.enabled || !option.enabled)
                ? null
                : (next) {
                    setState(() {
                      if (next) {
                        _selected.add(option.key);
                      } else {
                        _selected.remove(option.key);
                      }
                    });
                    _emit(option);
                  },
          ),
        )
        .toList(growable: false);

    return InputDecorator(
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
        isDense: widget.dense,
      ),
      child: Wrap(
        spacing: widget.dense ? 6 : 8,
        runSpacing: widget.dense ? 6 : 8,
        children: chips,
      ),
    );
  }
}

Widget buildMultiSelectControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final options = coerceOptionList(props['options'] ?? props['items']);
  final selectedRaw = props['values'] ?? props['selected'] ?? props['value'];
  final selected = <String>{};
  if (selectedRaw is List) {
    for (final item in selectedRaw) {
      final text = item?.toString();
      if (text != null && text.isNotEmpty) selected.add(text);
    }
  } else {
    final text = selectedRaw?.toString();
    if (text != null && text.isNotEmpty) selected.add(text);
  }

  return ButterflyUIMultiSelect(
    controlId: controlId,
    options: options,
    selected: selected,
    enabled: props['enabled'] == null ? true : (props['enabled'] == true),
    dense: props['dense'] == true,
    label: props['label']?.toString(),
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}
