import 'package:flutter/material.dart';

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
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<ButterflyUISwitch> createState() => _ButterflyUISwitchState();
}

class _ButterflyUISwitchState extends State<ButterflyUISwitch> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(covariant ButterflyUISwitch oldWidget) {
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

    if (label == null || label.trim().isEmpty) return control;
    if (widget.inline) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [control, const SizedBox(width: 8), Text(label)],
      );
    }
    return SwitchListTile(
      value: _value,
      title: Text(label),
      onChanged: widget.enabled ? _handleChanged : null,
    );
  }
}
