import 'package:flutter/material.dart';

import 'package:conduit_runtime/src/core/webview/webview_api.dart';

class ConduitSwitch extends StatefulWidget {
  final String controlId;
  final String? label;
  final bool value;
  final bool enabled;
  final bool inline;
  final ConduitSendRuntimeEvent sendEvent;

  const ConduitSwitch({
    super.key,
    required this.controlId,
    required this.label,
    required this.value,
    required this.enabled,
    required this.inline,
    required this.sendEvent,
  });

  @override
  State<ConduitSwitch> createState() => _ConduitSwitchState();
}

class _ConduitSwitchState extends State<ConduitSwitch> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(covariant ConduitSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _value = widget.value;
    }
  }

  void _handleChanged(bool next) {
    setState(() {
      _value = next;
    });
    final payload = <String, Object?>{'value': next};
    widget.sendEvent(widget.controlId, 'change', payload);
    widget.sendEvent(widget.controlId, 'input', payload);
    widget.sendEvent(widget.controlId, 'toggle', payload);
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.label;
    if (label == null || label.trim().isEmpty) {
      return Switch(
        value: _value,
        onChanged: widget.enabled ? _handleChanged : null,
      );
    }
    if (widget.inline) {
      final outlineColor = WidgetStateProperty.all(Colors.transparent);
      final outlineWidth = WidgetStateProperty.all(0.0);
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Switch(
            value: _value,
            onChanged: widget.enabled ? _handleChanged : null,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            trackOutlineColor: outlineColor,
            trackOutlineWidth: outlineWidth,
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      );
    }
    return SwitchListTile(
      value: _value,
      title: Text(label),
      onChanged: widget.enabled ? _handleChanged : null,
    );
  }
}
