import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/animation/animation_spec.dart';
import 'package:butterflyui_runtime/src/core/control_shells/base_control_shell.dart';
import 'package:butterflyui_runtime/src/core/control_shells/form_field_control_shell.dart';
import 'package:butterflyui_runtime/src/core/controls/common/option_types.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class ButterflyUISelect extends StatefulWidget {
  final String controlId;
  final List<ButterflyUIOption> options;
  final int index;
  final Object? explicitValue;
  final bool enabled;
  final bool dense;
  final String? label;
  final String? hint;
  final bool autofocus;
  final Object? events;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUISelect({
    super.key,
    required this.controlId,
    required this.options,
    required this.index,
    required this.explicitValue,
    required this.enabled,
    required this.dense,
    required this.label,
    required this.hint,
    this.autofocus = false,
    this.events,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<ButterflyUISelect> createState() => _ButterflyUISelectState();
}

class _ButterflyUISelectState extends State<ButterflyUISelect> {
  late final FocusNode _focusNode = FocusNode(
    debugLabel: 'butterflyui:select:${widget.controlId}',
  );
  String? _valueKey;

  @override
  void initState() {
    super.initState();
    _valueKey = _resolveValue();
    registerInvokeHandlerIfNeeded(
      controlId: widget.controlId,
      registerInvokeHandler: widget.registerInvokeHandler,
      handler: _handleInvoke,
    );
  }

  @override
  void didUpdateWidget(covariant ButterflyUISelect oldWidget) {
    super.didUpdateWidget(oldWidget);
    syncInvokeHandlerRegistration(
      previousControlId: oldWidget.controlId,
      currentControlId: widget.controlId,
      registerInvokeHandler: widget.registerInvokeHandler,
      unregisterInvokeHandler: widget.unregisterInvokeHandler,
      handler: _handleInvoke,
    );
    final next = _resolveValue(current: _valueKey);
    if (next != _valueKey) {
      setState(() {
        _valueKey = next;
      });
    }
  }

  @override
  void dispose() {
    unregisterInvokeHandlerIfNeeded(
      controlId: widget.controlId,
      unregisterInvokeHandler: widget.unregisterInvokeHandler,
    );
    _focusNode.dispose();
    super.dispose();
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

  Map<String, Object?> _selectionPayload(String next) {
    final idx = widget.options.indexWhere((option) => option.key == next);
    if (idx < 0) {
      return <String, Object?>{'value_key': next};
    }
    final option = widget.options[idx];
    return <String, Object?>{
      'value': option.value ?? option.label,
      'value_key': option.key,
      'label': option.label,
      'index': idx,
    };
  }

  void _emitSelection(String next) {
    emitFormFieldValueEvents(
      controlId: widget.controlId,
      subscribedEventsSource: widget.events,
      payload: _selectionPayload(next),
      sendEvent: widget.sendEvent,
    );
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
          case 'set_value':
            final next =
                payload['value_key']?.toString() ??
                payload['value']?.toString();
            if (next != null &&
                widget.options.any((option) => option.key == next)) {
              setState(() {
                _valueKey = next;
              });
            }
            return _valueKey == null ? null : _selectionPayload(_valueKey!);
          case 'select_next':
          case 'select_previous':
            final keys = widget.options
                .where((option) => option.enabled)
                .map((option) => option.key)
                .toList();
            final delta = name == 'select_next' ? 1 : -1;
            final next = stepSelectionKey(keys, _valueKey, delta);
            if (next != null) {
              setState(() {
                _valueKey = next;
              });
            }
            return _valueKey == null ? null : _selectionPayload(_valueKey!);
          case 'get_value':
          case 'get_state':
            return _valueKey == null ? null : _selectionPayload(_valueKey!);
          default:
            throw UnsupportedError('Unknown select method: $name');
        }
      },
    );
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
    final dropdown = DropdownButtonFormField<String>(
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

    return wrapFocusableFormField(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      onFocusChange: (value) {
        emitSubscribedEvent(
          controlId: widget.controlId,
          subscribedEventsSource: widget.events,
          name: value ? 'focus' : 'blur',
          payload: <String, Object?>{'focused': value},
          sendEvent: widget.sendEvent,
        );
      },
      child: dropdown,
    );
  }
}
