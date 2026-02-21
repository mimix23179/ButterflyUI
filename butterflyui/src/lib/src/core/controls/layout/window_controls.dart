import 'dart:async';

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/window/window_api.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildWindowControlsControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final showMinimize = props['show_minimize'] == null
      ? true
      : (props['show_minimize'] == true);
  final showMaximize = props['show_maximize'] == null
      ? true
      : (props['show_maximize'] == true);
  final showClose = props['show_close'] == null
      ? true
      : (props['show_close'] == true);
  final spacing = coerceDouble(props['spacing']) ?? 4.0;
  final radius = coerceDouble(props['radius']) ?? 10.0;
  final width = coerceDouble(props['button_width']) ?? 46.0;
  final height = coerceDouble(props['button_height']) ?? 28.0;

  final iconColor = coerceColor(props['icon_color']);
  final closeIconColor = coerceColor(props['close_icon_color']) ?? iconColor;

  final bgColor = coerceColor(props['button_color']);
  final closeBgColor = coerceColor(props['close_button_color']) ?? bgColor;
  final borderColor = coerceColor(props['border_color']);
  final closeBorderColor =
      coerceColor(props['close_border_color']) ?? borderColor;

  final controls = <Widget>[
    if (showMinimize)
      _WindowControlButton(
        icon: Icons.remove,
        action: 'minimize',
        controlId: controlId,
        width: width,
        height: height,
        radius: radius,
        bgColor: bgColor,
        borderColor: borderColor,
        iconColor: iconColor,
        sendEvent: sendEvent,
      ),
    if (showMaximize)
      _WindowControlButton(
        icon: Icons.crop_square,
        action: 'toggle_maximize',
        controlId: controlId,
        width: width,
        height: height,
        radius: radius,
        bgColor: bgColor,
        borderColor: borderColor,
        iconColor: iconColor,
        sendEvent: sendEvent,
      ),
    if (showClose)
      _WindowControlButton(
        icon: Icons.close,
        action: 'close',
        controlId: controlId,
        width: width,
        height: height,
        radius: radius,
        bgColor: closeBgColor,
        borderColor: closeBorderColor,
        iconColor: closeIconColor,
        sendEvent: sendEvent,
      ),
  ];

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: controls
        .map(
          (child) => Padding(
            padding: EdgeInsets.only(left: spacing),
            child: child,
          ),
        )
        .toList(),
  );
}

class _WindowControlButton extends StatefulWidget {
  final IconData icon;
  final String action;
  final String controlId;
  final double width;
  final double height;
  final double radius;
  final Color? bgColor;
  final Color? borderColor;
  final Color? iconColor;
  final ButterflyUISendRuntimeEvent sendEvent;

  const _WindowControlButton({
    required this.icon,
    required this.action,
    required this.controlId,
    required this.width,
    required this.height,
    required this.radius,
    required this.bgColor,
    required this.borderColor,
    required this.iconColor,
    required this.sendEvent,
  });

  @override
  State<_WindowControlButton> createState() => _WindowControlButtonState();
}

class _WindowControlButtonState extends State<_WindowControlButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final base = widget.bgColor ?? scheme.surface.withValues(alpha: 0.18);
    final border = widget.borderColor ?? scheme.outline.withValues(alpha: 0.35);
    final icon = widget.iconColor ?? scheme.onSurface;
    final color = _pressed
        ? base.withValues(alpha: (base.a + 0.18).clamp(0.0, 1.0))
        : (_hovered
              ? base.withValues(alpha: (base.a + 0.08).clamp(0.0, 1.0))
              : base);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: _performAction,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 130),
          curve: Curves.easeOutCubic,
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(widget.radius),
            border: Border.all(color: border),
          ),
          child: Center(child: Icon(widget.icon, size: 14, color: icon)),
        ),
      ),
    );
  }

  Future<void> _performAction() async {
    unawaited(ButterflyUIWindowApi.instance.performAction(widget.action));
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, 'action', <String, Object?>{
      'window_action': widget.action,
    });
  }
}
