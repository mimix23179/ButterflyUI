import 'package:flutter/material.dart';

import '../core/webview/webview_api.dart';

class ConduitLifecycleProbe extends StatefulWidget {
  final String controlId;
  final String controlType;
  final int signature;
  final ConduitSendRuntimeSystemEvent sendSystemEvent;
  final Widget child;

  const ConduitLifecycleProbe({
    super.key,
    required this.controlId,
    required this.controlType,
    required this.signature,
    required this.sendSystemEvent,
    required this.child,
  });

  @override
  State<ConduitLifecycleProbe> createState() => _ConduitLifecycleProbeState();
}

class _ConduitLifecycleProbeState extends State<ConduitLifecycleProbe> {
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
  void didUpdateWidget(covariant ConduitLifecycleProbe oldWidget) {
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
