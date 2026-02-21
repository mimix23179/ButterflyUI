import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:conduit_runtime/src/core/webview/webview_api.dart';
import 'package:conduit_runtime/src/core/control_theme.dart';

class ConduitModal extends StatefulWidget {
  final String controlId;
  final Widget child;
  final bool open;
  final bool dismissible;
  final bool closeOnEscape;
  final bool trapFocus;
  final Duration duration;
  final String transitionType;
  final Curve transitionCurve;
  final Rect? sourceRect;
  final Color? scrimColor;
  final ConduitSendRuntimeEvent sendEvent;

  const ConduitModal({
    super.key,
    required this.controlId,
    required this.child,
    required this.open,
    required this.dismissible,
    this.closeOnEscape = true,
    this.trapFocus = true,
    this.duration = const Duration(milliseconds: 180),
    this.transitionType = 'pop',
    this.transitionCurve = Curves.easeOutCubic,
    this.sourceRect,
    required this.scrimColor,
    required this.sendEvent,
  });

  @override
  State<ConduitModal> createState() => _ConduitModalState();
}

class _ConduitModalState extends State<ConduitModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;
  late Animation<Offset> _slide;
  bool _present = false;
  bool _dismissSent = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: widget.duration,
    );
    _opacity = CurvedAnimation(
      parent: _controller,
      curve: widget.transitionCurve,
    );
    _scale = Tween<double>(begin: 0.96, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.transitionCurve),
    );
    _slide = Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _controller, curve: widget.transitionCurve),
        );
    _present = widget.open;
    if (widget.open) {
      _controller.value = 1.0;
    } else {
      _controller.value = 0.0;
    }
  }

  @override
  void didUpdateWidget(covariant ConduitModal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
      _controller.reverseDuration = widget.duration;
    }
    if (widget.open) {
      _dismissSent = false;
      if (!_present) {
        setState(() => _present = true);
      }
      _controller.forward();
      return;
    }
    _controller.reverse().whenComplete(() {
      if (!mounted || widget.open) return;
      if (_present) {
        setState(() => _present = false);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismiss() {
    if (_dismissSent || !widget.dismissible) return;
    _dismissSent = true;
    if (widget.controlId.isNotEmpty) {
      widget.sendEvent(widget.controlId, 'dismiss', const {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_present && !widget.open) {
      return const SizedBox.shrink();
    }

    final scope = IgnorePointer(
      ignoring: !widget.open,
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: FocusScope(
          autofocus: widget.open,
          canRequestFocus: widget.trapFocus,
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: widget.dismissible ? _dismiss : null,
                  child: FadeTransition(
                    opacity: _opacity,
                    child: Container(
                      color:
                          widget.scrimColor ??
                          conduitScrim(context, opacity: 0.54),
                    ),
                  ),
                ),
              ),
              Center(
                child: RepaintBoundary(child: _buildTransitionedChild(context)),
              ),
            ],
          ),
        ),
      ),
    );

    if (!widget.closeOnEscape) return scope;
    return Shortcuts(
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.escape): ActivateIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<Intent>(
            onInvoke: (_) {
              _dismiss();
              return null;
            },
          ),
        },
        child: scope,
      ),
    );
  }

  Widget _buildTransitionedChild(BuildContext context) {
    final child = Material(color: Colors.transparent, child: widget.child);
    final normalizedType = widget.transitionType
        .trim()
        .toLowerCase()
        .replaceAll('-', '_')
        .replaceAll(' ', '_');
    switch (normalizedType) {
      case 'fade':
        return FadeTransition(opacity: _opacity, child: child);
      case 'slide':
      case 'glass_sheet':
        return FadeTransition(
          opacity: _opacity,
          child: SlideTransition(position: _slide, child: child),
        );
      case 'zoom':
      case 'pop':
      case 'pop_from_rect':
      default:
        final alignment = normalizedType == 'pop_from_rect'
            ? _alignmentFromRect(widget.sourceRect, MediaQuery.of(context).size)
            : Alignment.center;
        return FadeTransition(
          opacity: _opacity,
          child: ScaleTransition(
            alignment: alignment,
            scale: _scale,
            child: child,
          ),
        );
    }
  }

  Alignment _alignmentFromRect(Rect? rect, Size viewport) {
    if (rect == null || viewport.width <= 0 || viewport.height <= 0) {
      return Alignment.center;
    }
    final dx = (rect.center.dx / viewport.width) * 2 - 1;
    final dy = (rect.center.dy / viewport.height) * 2 - 1;
    return Alignment(dx.clamp(-1.0, 1.0), dy.clamp(-1.0, 1.0));
  }
}
