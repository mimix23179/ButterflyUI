import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildFocusAnchorControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _FocusAnchorControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _FocusAnchorControl extends StatefulWidget {
  const _FocusAnchorControl({
    required this.controlId,
    required this.props,
    required this.rawChildren,
    required this.buildChild,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final List<dynamic> rawChildren;
  final Widget Function(Map<String, Object?> child) buildChild;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_FocusAnchorControl> createState() => _FocusAnchorControlState();
}

class _FocusAnchorControlState extends State<_FocusAnchorControl> {
  final FocusNode _node = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
    _node.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(covariant _FocusAnchorControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    if (!mapEquals(oldWidget.props, widget.props)) {
      if (widget.props['autofocus'] == true && !_node.hasFocus) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _node.requestFocus();
        });
      }
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    _node.removeListener(_onFocusChanged);
    _node.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, _node.hasFocus ? 'focus' : 'blur', _statePayload());
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'focus':
        _node.requestFocus();
        return _statePayload();
      case 'unfocus':
        _node.unfocus();
        return _statePayload();
      case 'get_state':
        return _statePayload();
      default:
        throw UnsupportedError('Unknown focus_anchor method: $method');
    }
  }

  Map<String, Object?> _statePayload() => <String, Object?>{'focused': _node.hasFocus};

  @override
  Widget build(BuildContext context) {
    final enabled = widget.props['enabled'] == null || widget.props['enabled'] == true;
    final canRequestFocus = widget.props['can_request_focus'] == null || widget.props['can_request_focus'] == true;
    final skipTraversal = widget.props['skip_traversal'] == true;
    final descendantsAreFocusable = widget.props['descendants_are_focusable'] == null ||
        widget.props['descendants_are_focusable'] == true;
    final descendantsAreTraversable = widget.props['descendants_are_traversable'] == null ||
        widget.props['descendants_are_traversable'] == true;

    Widget child = const SizedBox.shrink();
    for (final raw in widget.rawChildren) {
      if (raw is Map) {
        child = widget.buildChild(coerceObjectMap(raw));
        break;
      }
    }

    return Focus(
      focusNode: _node,
      autofocus: widget.props['autofocus'] == true,
      canRequestFocus: enabled && canRequestFocus,
      skipTraversal: skipTraversal,
      descendantsAreFocusable: descendantsAreFocusable,
      descendantsAreTraversable: descendantsAreTraversable,
      child: child,
    );
  }
}
