import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_shells/base_control_shell.dart';
import 'package:butterflyui_runtime/src/core/control_shells/form_field_control_shell.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class ButterflyUISwitch extends StatefulWidget {
  const ButterflyUISwitch({
    super.key,
    required this.controlId,
    required this.label,
    required this.value,
    required this.enabled,
    required this.inline,
    required this.mode,
    required this.offLabel,
    required this.onLabel,
    required this.segments,
    this.autofocus = false,
    this.events,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final String? label;
  final bool value;
  final bool enabled;
  final bool inline;
  final String mode;
  final String? offLabel;
  final String? onLabel;
  final List<String> segments;
  final bool autofocus;
  final Object? events;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<ButterflyUISwitch> createState() => _ButterflyUISwitchState();
}

class _ButterflyUISwitchState extends State<ButterflyUISwitch> {
  late final FocusNode _focusNode = FocusNode(
    debugLabel: 'butterflyui:switch:${widget.controlId}',
  );
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
    registerInvokeHandlerIfNeeded(
      controlId: widget.controlId,
      registerInvokeHandler: widget.registerInvokeHandler,
      handler: _handleInvoke,
    );
  }

  @override
  void didUpdateWidget(covariant ButterflyUISwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    syncInvokeHandlerRegistration(
      previousControlId: oldWidget.controlId,
      currentControlId: widget.controlId,
      registerInvokeHandler: widget.registerInvokeHandler,
      unregisterInvokeHandler: widget.unregisterInvokeHandler,
      handler: _handleInvoke,
    );
    if (widget.value != oldWidget.value) {
      _value = widget.value;
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
            final next = coerceShellBoolOrNull(payload['value']) ?? _value;
            setState(() {
              _value = next;
            });
            return <String, Object?>{'value': _value};
          case 'toggle':
            setState(() {
              _value = !_value;
            });
            return <String, Object?>{'value': _value};
          case 'get_value':
          case 'get_state':
            return <String, Object?>{'value': _value};
          default:
            throw UnsupportedError('Unknown switch method: $name');
        }
      },
    );
  }

  void _handleChanged(bool next) {
    setState(() {
      _value = next;
    });
    final payload = <String, Object?>{'value': next};
    emitFormFieldValueEvents(
      controlId: widget.controlId,
      subscribedEventsSource: widget.events,
      payload: payload,
      sendEvent: widget.sendEvent,
      emitToggle: true,
    );
  }

  Widget _buildSegmented() {
    final labels = widget.segments.isNotEmpty
        ? widget.segments
        : <String>[widget.offLabel ?? 'Off', widget.onLabel ?? 'On'];
    final safeLabels = labels.length >= 2
        ? labels
        : <String>[labels.isNotEmpty ? labels.first : 'Off', 'On'];
    final selectedIndex = _value ? 1 : 0;
    return ToggleButtons(
      isSelected: [selectedIndex == 0, selectedIndex == 1],
      onPressed: widget.enabled
          ? (index) {
              _handleChanged(index == 1);
            }
          : null,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Text(safeLabels[0]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Text(safeLabels[1]),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.label;
    final segmented =
        widget.mode.toLowerCase() == 'segmented' || widget.segments.isNotEmpty;
    final control = segmented
        ? _buildSegmented()
        : Switch(
            value: _value,
            onChanged: widget.enabled ? _handleChanged : null,
          );

    final child = (label == null || label.trim().isEmpty)
        ? control
        : (widget.inline
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [control, const SizedBox(width: 8), Text(label)],
                )
              : SwitchListTile(
                  value: _value,
                  title: Text(label),
                  onChanged: widget.enabled ? _handleChanged : null,
                ));

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
      child: child,
    );
  }
}
