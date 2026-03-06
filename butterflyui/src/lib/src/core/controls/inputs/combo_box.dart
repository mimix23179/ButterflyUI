import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_shells/base_control_shell.dart';
import 'package:butterflyui_runtime/src/core/control_shells/form_field_control_shell.dart';
import 'package:butterflyui_runtime/src/core/controls/common/option_types.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class ButterflyUICombobox extends StatefulWidget {
  final String controlId;
  final List<ButterflyUIOption> options;
  final String value;
  final bool enabled;
  final bool loading;
  final String? label;
  final String? hint;
  final bool dense;
  final bool autofocus;
  final Object? events;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUICombobox({
    super.key,
    required this.controlId,
    required this.options,
    required this.value,
    required this.enabled,
    required this.loading,
    required this.label,
    required this.hint,
    required this.dense,
    this.autofocus = false,
    this.events,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<ButterflyUICombobox> createState() => _ButterflyUIComboboxState();
}

class _ButterflyUIComboboxState extends State<ButterflyUICombobox> {
  late final FocusNode _focusNode = FocusNode(
    debugLabel: 'butterflyui:combo_box:${widget.controlId}',
  );
  late final TextEditingController _controller = TextEditingController(
    text: widget.value,
  );
  late List<ButterflyUIOption> _options = List<ButterflyUIOption>.from(
    widget.options,
  );
  late bool _loading = widget.loading;

  @override
  void initState() {
    super.initState();
    registerInvokeHandlerIfNeeded(
      controlId: widget.controlId,
      registerInvokeHandler: widget.registerInvokeHandler,
      handler: _handleInvoke,
    );
  }

  @override
  void didUpdateWidget(covariant ButterflyUICombobox oldWidget) {
    super.didUpdateWidget(oldWidget);
    syncInvokeHandlerRegistration(
      previousControlId: oldWidget.controlId,
      currentControlId: widget.controlId,
      registerInvokeHandler: widget.registerInvokeHandler,
      unregisterInvokeHandler: widget.unregisterInvokeHandler,
      handler: _handleInvoke,
    );
    if (oldWidget.value != widget.value && widget.value != _controller.text) {
      _controller.text = widget.value;
    }
    if (oldWidget.options != widget.options) {
      _options = List<ButterflyUIOption>.from(widget.options);
    }
    if (oldWidget.loading != widget.loading) {
      _loading = widget.loading;
    }
  }

  @override
  void dispose() {
    unregisterInvokeHandlerIfNeeded(
      controlId: widget.controlId,
      unregisterInvokeHandler: widget.unregisterInvokeHandler,
    );
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    return handleFormFieldInvoke(
      context: context,
      focusNode: _focusNode,
      method: method,
      args: args,
      onUnhandled: (name, payload) async {
        switch (name) {
          case 'get_value':
          case 'get_state':
            return <String, Object?>{
              'value': _controller.text,
              'loading': _loading,
              'option_count': _options.length,
            };
          case 'set_value':
            final value = (payload['value'] ?? '').toString();
            setState(() {
              _controller.text = value;
            });
            return _controller.text;
          case 'set_options':
            final next = coerceOptionList(
              payload['options'] ?? payload['items'],
            );
            setState(() {
              _options = next;
            });
            return {'count': _options.length};
          case 'set_loading':
            setState(() {
              _loading = payload['value'] == true;
            });
            return _loading;
          default:
            throw UnsupportedError('Unknown combobox method: $name');
        }
      },
    );
  }

  void _emit(String value, {ButterflyUIOption? option, bool submit = false}) {
    final payload = <String, Object?>{
      'value': value,
      if (option != null) 'value_key': option.key,
      if (option != null) 'label': option.label,
      if (option != null) 'option_value': option.value,
    };
    emitFormFieldValueEvents(
      controlId: widget.controlId,
      subscribedEventsSource: widget.events,
      payload: payload,
      sendEvent: widget.sendEvent,
      emitSubmit: submit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<ButterflyUIOption>(
      initialValue: TextEditingValue(text: widget.value),
      optionsBuilder: (text) {
        if (_loading) {
          return const Iterable<ButterflyUIOption>.empty();
        }
        final q = text.text.trim().toLowerCase();
        if (q.isEmpty) {
          return _options.where((option) => option.enabled);
        }
        return _options.where(
          (option) => option.enabled && option.label.toLowerCase().contains(q),
        );
      },
      displayStringForOption: (option) => option.label,
      onSelected: (option) {
        _controller.text = option.label;
        _emit(option.label, option: option);
      },
      fieldViewBuilder: (context, textController, _, onFieldSubmitted) {
        if (textController.text != _controller.text) {
          textController.text = _controller.text;
        }
        return Focus(
          onFocusChange: (value) {
            emitSubscribedEvent(
              controlId: widget.controlId,
              subscribedEventsSource: widget.events,
              name: value ? 'focus' : 'blur',
              payload: <String, Object?>{'focused': value},
              sendEvent: widget.sendEvent,
            );
          },
          child: TextField(
            controller: textController,
            focusNode: _focusNode,
            enabled: widget.enabled,
            autofocus: widget.autofocus,
            decoration: InputDecoration(
              labelText: widget.label,
              hintText: widget.hint,
              border: const OutlineInputBorder(),
              isDense: widget.dense,
              suffixIcon: _loading
                  ? const Padding(
                      padding: EdgeInsets.all(10),
                      child: SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : null,
            ),
            onChanged: (value) {
              _controller.text = value;
              _emit(value);
            },
            onSubmitted: (value) {
              _controller.text = value;
              _emit(value, submit: true);
              onFieldSubmitted();
            },
          ),
        );
      },
    );
  }
}

Widget buildComboboxControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return ButterflyUICombobox(
    controlId: controlId,
    options: coerceOptionList(props['options'] ?? props['items']),
    value: (props['value'] ?? props['text'] ?? '').toString(),
    enabled: props['enabled'] == null ? true : (props['enabled'] == true),
    loading: props['loading'] == true,
    label: props['label']?.toString(),
    hint: (props['hint'] ?? props['placeholder'])?.toString(),
    dense: props['dense'] == true,
    autofocus: props['autofocus'] == true,
    events: props['events'],
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}
