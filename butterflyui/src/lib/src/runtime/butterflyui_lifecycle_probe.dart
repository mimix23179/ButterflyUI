import 'package:flutter/material.dart';

import '../core/webview/webview_api.dart';

class ButterflyUILifecycleProbe extends StatefulWidget {
  final String controlId;
  final String controlType;
  final int signature;
  final ButterflyUISendRuntimeSystemEvent sendSystemEvent;
  final Widget child;

  const ButterflyUILifecycleProbe({
    super.key,
    required this.controlId,
    required this.controlType,
    required this.signature,
    required this.sendSystemEvent,
    required this.child,
  });

  @override
  State<ButterflyUILifecycleProbe> createState() => _ButterflyUILifecycleProbeState();
}

class _ButterflyUILifecycleProbeState extends State<ButterflyUILifecycleProbe> {
  @override
  void initState() {
    super.initState();
    widget.sendSystemEvent('lifecycle', {
      'control_id': widget.controlId,
      'control_type': widget.controlType,
      'signature': widget.signature,
      'event': 'mount',
    });
  }

  @override
  void didUpdateWidget(covariant ButterflyUILifecycleProbe oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.signature != widget.signature) {
      widget.sendSystemEvent('lifecycle', {
        'control_id': widget.controlId,
        'control_type': widget.controlType,
        'signature': widget.signature,
        'event': 'update',
      });
    }
  }

  @override
  void dispose() {
    widget.sendSystemEvent('lifecycle', {
      'control_id': widget.controlId,
      'control_type': widget.controlType,
      'signature': widget.signature,
      'event': 'unmount',
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
