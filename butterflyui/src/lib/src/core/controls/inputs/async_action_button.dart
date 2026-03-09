import 'dart:async';

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/styling/theme.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/buttons/button_runtime.dart';
import 'package:butterflyui_runtime/src/core/controls/common/icon_value.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildAsyncActionButtonControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _AsyncActionButtonControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _AsyncActionButtonControl extends StatefulWidget {
  const _AsyncActionButtonControl({
    required this.controlId,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_AsyncActionButtonControl> createState() =>
      _AsyncActionButtonControlState();
}

class _AsyncActionButtonControlState extends State<_AsyncActionButtonControl> {
  late bool _busy;

  @override
  void initState() {
    super.initState();
    _busy = widget.props['busy'] == true || widget.props['loading'] == true;
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _AsyncActionButtonControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    if (oldWidget.props != widget.props) {
      final nextBusy =
          widget.props['busy'] == true || widget.props['loading'] == true;
      if (_busy != nextBusy) {
        setState(() => _busy = nextBusy);
      } else {
        _busy = nextBusy;
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

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_busy':
        setState(() => _busy = args['value'] == true);
        _emit('state', _statePayload());
        return _statePayload();
      case 'get_state':
        return _statePayload();
      case 'emit':
        final event = (args['event'] ?? 'action').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        _emit(event, payload);
        return null;
      default:
        throw UnsupportedError('Unknown async_action_button method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{'busy': _busy, 'loading': _busy};
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  @override
  Widget build(BuildContext context) {
    final props = widget.props;
    final label = (props['text'] ?? props['label'] ?? 'Run').toString();
    final busyLabel = (props['busy_label'] ?? 'Working...').toString();
    final enabled = props['enabled'] == null || props['enabled'] == true;
    final disabledWhileBusy =
        props['disabled_while_busy'] == null ||
        props['disabled_while_busy'] == true;
    final canPress = enabled && !(_busy && disabledWhileBusy);
    final variant = (props['variant'] ?? 'filled')
        .toString()
        .toLowerCase()
        .trim();
    final visual = buildButtonVisualSpec(
      props: <String, Object?>{'variant': variant, ...props},
      tokens: StylingTokens(),
      variant: variant,
      fallbackLabel: label,
    );

    Widget leadingIcon;
    if (_busy) {
      leadingIcon = SizedBox(
        width: visual.iconSize ?? 16,
        height: visual.iconSize ?? 16,
        child: const CircularProgressIndicator(strokeWidth: 2),
      );
    } else {
      leadingIcon =
          buildIconValue(
            props['icon'] ??
                props['glyph'] ??
                props['leading_icon'] ??
                'play_arrow',
            colorValue: props['icon_color'] ?? props['color'],
            color: visual.iconColor,
            size: visual.iconSize,
            autoContrast: visual.autoContrast,
            minContrast: visual.minContrast,
            fallbackIcon: Icons.play_arrow,
          ) ??
          const Icon(Icons.play_arrow);
    }

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        leadingIcon,
        SizedBox(width: visual.iconSpacing),
        Text(_busy ? busyLabel : label, style: visual.textStyle),
      ],
    );

    void onPressed() {
      unawaited(maybeDispatchWindowAction(props));
      emitControlPressEvents(
        controlId: widget.controlId,
        props: props,
        payload: buildBasePressPayload(
          label: label,
          variant: variant,
          props: props,
          busy: _busy,
        ),
        sendEvent: widget.sendEvent,
      );
    }

    Widget button;
    switch (variant) {
      case 'text':
        button = TextButton(
          onPressed: canPress ? onPressed : null,
          style: visual.style,
          child: content,
        );
        break;
      case 'outlined':
        button = OutlinedButton(
          onPressed: canPress ? onPressed : null,
          style: visual.style,
          child: content,
        );
        break;
      case 'elevated':
        button = ElevatedButton(
          onPressed: canPress ? onPressed : null,
          style: visual.style,
          child: content,
        );
        break;
      case 'filled':
      default:
        button = FilledButton(
          onPressed: canPress ? onPressed : null,
          style: visual.style,
          child: content,
        );
        break;
    }
    return applyControlTransparency(child: button, props: props);
  }
}
