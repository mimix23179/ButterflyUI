import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';
import 'package:butterflyui_runtime/src/core/control_theme.dart';

class ButterflyUIPopover extends StatefulWidget {
  final String controlId;
  final Widget anchor;
  final Widget content;
  final bool open;
  final String position;
  final Offset offset;
  final bool dismissible;
  final Duration duration;
  final String transitionType;
  final Curve transitionCurve;
  final Color? scrimColor;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUIPopover({
    super.key,
    required this.controlId,
    required this.anchor,
    required this.content,
    required this.open,
    required this.position,
    required this.offset,
    required this.dismissible,
    this.duration = const Duration(milliseconds: 180),
    this.transitionType = 'fade',
    this.transitionCurve = Curves.easeOutCubic,
    required this.scrimColor,
    required this.sendEvent,
  });

  @override
  State<ButterflyUIPopover> createState() => _ButterflyUIPopoverState();
}

class _ButterflyUIPopoverState extends State<ButterflyUIPopover> {
  final LayerLink _link = LayerLink();

  Alignment _targetAnchor() {
    switch (widget.position.toLowerCase()) {
      case 'top':
        return Alignment.topCenter;
      case 'left':
        return Alignment.centerLeft;
      case 'right':
        return Alignment.centerRight;
      case 'bottom':
      default:
        return Alignment.bottomCenter;
    }
  }

  Alignment _followerAnchor() {
    switch (widget.position.toLowerCase()) {
      case 'top':
        return Alignment.bottomCenter;
      case 'left':
        return Alignment.centerRight;
      case 'right':
        return Alignment.centerLeft;
      case 'bottom':
      default:
        return Alignment.topCenter;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CompositedTransformTarget(link: _link, child: widget.anchor),
        if (widget.open && widget.dismissible)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => widget.sendEvent(widget.controlId, 'dismiss', {}),
              child: Container(
                color: widget.scrimColor ?? butterflyuiScrim(context, opacity: 0.0),
              ),
            ),
          ),
        if (widget.open)
          Positioned.fill(
            child: CompositedTransformFollower(
              link: _link,
              offset: widget.offset,
              targetAnchor: _targetAnchor(),
              followerAnchor: _followerAnchor(),
              child: AnimatedSwitcher(
                duration: widget.duration,
                switchInCurve: widget.transitionCurve,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  final curved = CurvedAnimation(
                    parent: animation,
                    curve: widget.transitionCurve,
                  );
                  final normalizedType = widget.transitionType
                      .trim()
                      .toLowerCase()
                      .replaceAll('-', '_')
                      .replaceAll(' ', '_');
                  switch (normalizedType) {
                    case 'slide':
                    case 'glass_sheet':
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.04),
                          end: Offset.zero,
                        ).animate(curved),
                        child: FadeTransition(opacity: curved, child: child),
                      );
                    case 'zoom':
                    case 'pop':
                      return ScaleTransition(
                        scale: Tween<double>(
                          begin: 0.96,
                          end: 1.0,
                        ).animate(curved),
                        child: FadeTransition(opacity: curved, child: child),
                      );
                    case 'fade':
                    default:
                      return FadeTransition(opacity: curved, child: child);
                  }
                },
                child: KeyedSubtree(
                  key: ValueKey<String>(
                    'popover:${widget.controlId}:${widget.content.hashCode}',
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: widget.content,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
