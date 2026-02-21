import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';
import 'package:butterflyui_runtime/src/core/control_theme.dart';

class ButterflyUISlidePanel extends StatelessWidget {
  final String controlId;
  final Widget child;
  final bool open;
  final String side;
  final double size;
  final Color? scrimColor;
  final bool dismissible;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUISlidePanel({
    super.key,
    required this.controlId,
    required this.child,
    required this.open,
    required this.side,
    required this.size,
    required this.scrimColor,
    required this.dismissible,
    required this.sendEvent,
  });

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final isHorizontal = side == 'left' || side == 'right';
    final panelSize = size <= 0 ? (isHorizontal ? screen.width * 0.3 : screen.height * 0.3) : size;

    double left = 0;
    double top = 0;
    double? right;
    double? bottom;

    if (side == 'left') {
      left = open ? 0 : -panelSize;
      top = 0;
      bottom = 0;
    } else if (side == 'right') {
      right = open ? 0 : -panelSize;
      top = 0;
      bottom = 0;
    } else if (side == 'top') {
      top = open ? 0 : -panelSize;
      left = 0;
      right = 0;
    } else {
      bottom = open ? 0 : -panelSize;
      left = 0;
      right = 0;
    }

    return Stack(
      children: [
        if (open)
          Positioned.fill(
            child: GestureDetector(
              onTap: dismissible ? () => sendEvent(controlId, 'dismiss', {}) : null,
              child: Container(
                color: scrimColor ?? butterflyuiScrim(context, opacity: 0.54),
              ),
            ),
          ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          left: side == 'right' ? null : left,
          right: side == 'right' ? right : null,
          top: side == 'bottom' ? null : top,
          bottom: side == 'bottom' ? bottom : null,
          width: isHorizontal ? panelSize : null,
          height: isHorizontal ? null : panelSize,
          child: Material(
            elevation: 4,
            color: Theme.of(context).colorScheme.surface,
            clipBehavior: Clip.hardEdge,
            child: child,
          ),
        ),
      ],
    );
  }
}

