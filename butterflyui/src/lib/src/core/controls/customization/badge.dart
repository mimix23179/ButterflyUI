import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class _BadgeControl extends StatefulWidget {
  const _BadgeControl({
    required this.controlId,
    required this.props,
    required this.rawChildren,
    required this.buildChild,
    required this.sendEvent,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
  });

  final String controlId;
  final Map<String, Object?> props;
  final List<dynamic> rawChildren;
  final Widget Function(Map<String, Object?>) buildChild;
  final ButterflyUISendRuntimeEvent sendEvent;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;

  @override
  State<_BadgeControl> createState() => _BadgeControlState();
}

class _BadgeControlState extends State<_BadgeControl> {
  late String _value;

  @override
  void initState() {
    super.initState();
    _value = _coerceValue(widget.props);
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant _BadgeControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
    if (oldWidget.props != widget.props) {
      setState(() {
        _value = _coerceValue(widget.props);
      });
    }
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'get_value':
        return _value;
      case 'set_value':
        final next = args['value']?.toString() ?? '';
        setState(() {
          _value = next;
        });
        widget.sendEvent(widget.controlId, 'change', {'value': _value});
        return _value;
      default:
        throw UnsupportedError('Unknown badge method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final severity = widget.props['severity']?.toString().toLowerCase();
    final Color severityBackground = switch (severity) {
      'success' => Theme.of(context).colorScheme.tertiaryContainer,
      'warn' || 'warning' => Theme.of(context).colorScheme.secondaryContainer,
      'error' || 'danger' => Theme.of(context).colorScheme.errorContainer,
      _ => Theme.of(context).colorScheme.primary,
    };
    final Color severityForeground = switch (severity) {
      'success' => Theme.of(context).colorScheme.onTertiaryContainer,
      'warn' || 'warning' => Theme.of(context).colorScheme.onSecondaryContainer,
      'error' || 'danger' => Theme.of(context).colorScheme.onErrorContainer,
      _ => Theme.of(context).colorScheme.onPrimary,
    };
    final background =
        coerceColor(widget.props['bgcolor'] ?? widget.props['background']) ??
        severityBackground;
    final foreground =
        coerceColor(widget.props['color'] ?? widget.props['text_color']) ??
        severityForeground;
    final padding = coercePadding(widget.props['padding']) ??
        const EdgeInsets.symmetric(horizontal: 8, vertical: 3);
    final dot = widget.props['dot'] == true;
    final pulse = widget.props['pulse'] == true;
    final count = coerceOptionalInt(widget.props['count']);
    final showCount = count != null;

    final textValue = showCount ? count.toString() : _value;

    Widget child = Text(
      textValue,
      style: TextStyle(
        color: foreground,
        fontSize: coerceDouble(widget.props['font_size']) ?? 11,
        fontWeight: FontWeight.w600,
      ),
    );

    if (widget.rawChildren.isNotEmpty && widget.rawChildren.first is Map) {
      child = widget.buildChild(coerceObjectMap(widget.rawChildren.first as Map));
    }

    final content = DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(
          coerceDouble(widget.props['radius']) ?? (dot ? 9999 : 999),
        ),
      ),
      child: Padding(
        padding: dot
            ? EdgeInsets.all((coerceDouble(widget.props['dot_size']) ?? 8) / 2)
            : padding,
        child: dot
            ? SizedBox(
                width: coerceDouble(widget.props['dot_size']) ?? 8,
                height: coerceDouble(widget.props['dot_size']) ?? 8,
              )
            : child,
      ),
    );

    final Widget rendered = pulse
        ? TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.95, end: 1.05),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeInOut,
            builder: (context, scale, pulseChild) {
              return Transform.scale(scale: scale, child: pulseChild);
            },
            child: content,
          )
        : content;

    if (widget.props['clickable'] == true) {
      return InkWell(
        onTap: () => widget.sendEvent(widget.controlId, 'click', {'value': textValue}),
        child: rendered,
      );
    }
    return rendered;
  }
}

String _coerceValue(Map<String, Object?> props) {
  return (props['label'] ?? props['text'] ?? props['value'] ?? '').toString();
}

Widget buildBadgeControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?>) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _BadgeControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    sendEvent: sendEvent,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
  );
}
