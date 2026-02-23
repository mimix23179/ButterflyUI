import 'package:flutter/widgets.dart';

import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildVisibilityControl(
  String controlId,
  Map<String, Object?> props,
  Widget child,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
) {
  return _VisibilityControl(
    controlId: controlId,
    props: props,
    child: child,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
  );
}

class _VisibilityControl extends StatefulWidget {
  const _VisibilityControl({
    required this.controlId,
    required this.props,
    required this.child,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
  });

  final String controlId;
  final Map<String, Object?> props;
  final Widget child;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;

  @override
  State<_VisibilityControl> createState() => _VisibilityControlState();
}

class _VisibilityControlState extends State<_VisibilityControl> {
  late bool _visible;

  @override
  void initState() {
    super.initState();
    _visible = widget.props['visible'] == null || widget.props['visible'] == true;
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _VisibilityControl oldWidget) {
    super.didUpdateWidget(oldWidget);
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
      case 'set_visible':
        setState(() {
          _visible = args['value'] == true;
        });
        return _state();
      case 'get_state':
        return _state();
      default:
        throw UnsupportedError('Unknown visibility method: $method');
    }
  }

  Map<String, Object?> _state() => <String, Object?>{'visible': _visible};

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _visible,
      maintainState: widget.props['maintain_state'] == true,
      maintainAnimation: widget.props['maintain_animation'] == true,
      maintainSize: widget.props['maintain_size'] == true,
      child: widget.child,
    );
  }
}
