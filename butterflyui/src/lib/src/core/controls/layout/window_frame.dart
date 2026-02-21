import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/candy/theme.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';
import 'package:butterflyui_runtime/src/core/window/window_api.dart';

Widget buildWindowFrameControl(
  String controlId,
  Map<String, Object?> props,
  CandyTokens tokens,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  if (props['open'] == false || props['visible'] == false) {
    return const SizedBox.shrink();
  }

  final childMap = _controlMap(props['child']) ?? _firstControl(rawChildren);
  final leadingMap = _controlMap(props['title_leading'] ?? props['leading']);
  final contentMap = _controlMap(
    props['title_content'] ?? props['title_widget'],
  );
  final trailingMap =
      _controlMap(props['title_trailing'] ?? props['window_controls']) ??
      _secondControl(rawChildren);

  final child = childMap == null
      ? const SizedBox.shrink()
      : buildChild(childMap);
  final titleLeading = leadingMap == null ? null : buildChild(leadingMap);
  final titleContent = contentMap == null ? null : buildChild(contentMap);
  final titleTrailing = trailingMap == null ? null : buildChild(trailingMap);

  return _ButterflyUIWindowFrame(
    controlId: controlId,
    props: props,
    tokens: tokens,
    child: child,
    titleLeading: titleLeading,
    titleContent: titleContent,
    titleTrailing: titleTrailing,
    sendEvent: sendEvent,
  );
}

Map<String, Object?>? _controlMap(Object? value) {
  if (value is! Map) return null;
  return coerceObjectMap(value);
}

Map<String, Object?>? _firstControl(List<dynamic> rawChildren) {
  for (final raw in rawChildren) {
    if (raw is Map) {
      return coerceObjectMap(raw);
    }
  }
  return null;
}

Map<String, Object?>? _secondControl(List<dynamic> rawChildren) {
  var seenFirst = false;
  for (final raw in rawChildren) {
    if (raw is! Map) continue;
    if (!seenFirst) {
      seenFirst = true;
      continue;
    }
    return coerceObjectMap(raw);
  }
  return null;
}

class _ButterflyUIWindowFrame extends StatefulWidget {
  final String controlId;
  final Map<String, Object?> props;
  final CandyTokens tokens;
  final Widget child;
  final Widget? titleLeading;
  final Widget? titleContent;
  final Widget? titleTrailing;
  final ButterflyUISendRuntimeEvent sendEvent;

  const _ButterflyUIWindowFrame({
    required this.controlId,
    required this.props,
    required this.tokens,
    required this.child,
    required this.titleLeading,
    required this.titleContent,
    required this.titleTrailing,
    required this.sendEvent,
  });

  @override
  State<_ButterflyUIWindowFrame> createState() => _ButterflyUIWindowFrameState();
}

class _ButterflyUIWindowFrameState extends State<_ButterflyUIWindowFrame> {
  bool _customFrame = true;
  bool _nativeActions = true;

  @override
  void initState() {
    super.initState();
    _customFrame = _resolveCustomFrame(widget.props);
    _nativeActions = _resolveNativeActions(widget.props);
    unawaited(ButterflyUIWindowApi.instance.ensureCustomFrame(_customFrame));
  }

  @override
  void didUpdateWidget(covariant _ButterflyUIWindowFrame oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextCustomFrame = _resolveCustomFrame(widget.props);
    _nativeActions = _resolveNativeActions(widget.props);
    if (nextCustomFrame != _customFrame) {
      _customFrame = nextCustomFrame;
      unawaited(ButterflyUIWindowApi.instance.ensureCustomFrame(_customFrame));
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.props['title']?.toString() ?? 'Window';
    final radius =
        coerceDouble(widget.props['radius']) ??
        widget.tokens.number('radii', 'md') ??
        14;
    final shadow =
        coerceDouble(widget.props['shadow']) ??
        coerceDouble(widget.props['elevation']) ??
        20;
    final borderColor =
        coerceColor(widget.props['border_color']) ??
        widget.tokens.color('border') ??
        const Color(0x22000000);
    final backgroundColor =
        coerceColor(widget.props['bgcolor'] ?? widget.props['background']) ??
        widget.tokens.color('surface') ??
        const Color(0xFFFFFFFF);
    final titleColor =
        coerceColor(widget.props['title_color']) ??
        widget.tokens.color('text') ??
        const Color(0xFF0F172A);
    final contentPadding =
        coercePadding(widget.props['content_padding']) ?? EdgeInsets.zero;
    final titleHeight = coerceDouble(widget.props['title_height']) ?? 34.0;
    final draggable = widget.props['draggable'] == null
        ? true
        : (widget.props['draggable'] == true);
    final glass =
        widget.props['acrylic_effect'] == true || widget.props['glass'] == true;
    final acrylicOpacity =
        coerceDouble(widget.props['acrylic_opacity']) ?? 0.88;
    final showMinimize = widget.props['show_minimize'] != false;
    final showMaximize = widget.props['show_maximize'] != false;
    final showClose = widget.props['show_close'] != false;
    final showDefaultControls = widget.props['show_default_controls'] == true
        ? true
        : (widget.props['show_default_controls'] == false
              ? false
              : widget.titleTrailing == null);

    Widget panel = DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: glass ? acrylicOpacity : 1.0),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0x32000000),
            blurRadius: shadow,
            spreadRadius: shadow * 0.08,
            offset: Offset(0, shadow * 0.25),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _WindowTitleBar(
            title: title,
            titleColor: titleColor,
            height: titleHeight,
            draggable: draggable,
            leading: widget.titleLeading,
            content: widget.titleContent,
            trailing: widget.titleTrailing,
            showDefaultControls: showDefaultControls,
            onMove: (delta) {
              if (widget.controlId.isEmpty) return;
              widget.sendEvent(widget.controlId, 'move', <String, Object?>{
                'dx': delta.dx,
                'dy': delta.dy,
              });
            },
            onDragStart: () {
              if (draggable) {
                unawaited(ButterflyUIWindowApi.instance.startDrag());
              }
              if (widget.controlId.isEmpty) return;
              widget.sendEvent(widget.controlId, 'drag_start', const {});
            },
            onAction: (action) {
              if (_nativeActions) {
                unawaited(ButterflyUIWindowApi.instance.performAction(action));
              }
              if (widget.controlId.isEmpty) return;
              widget.sendEvent(widget.controlId, action, <String, Object?>{
                'action': action,
              });
            },
            showMinimize: showMinimize,
            showMaximize: showMaximize,
            showClose: showClose,
          ),
          Expanded(
            child: Padding(
              padding: contentPadding,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular((radius - 1).clamp(0.0, 64.0)),
                ),
                child: widget.child,
              ),
            ),
          ),
        ],
      ),
    );

    if (glass) {
      panel = ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: coerceDouble(widget.props['blur']) ?? 20.0,
            sigmaY: coerceDouble(widget.props['blur']) ?? 20.0,
          ),
          child: panel,
        ),
      );
    }
    return panel;
  }
}

bool _resolveCustomFrame(Map<String, Object?> props) {
  final explicit = props['custom_frame'];
  if (explicit is bool) return explicit;
  final useNative =
      props['use_native_title_bar'] == true ||
      props['native_title_bar'] == true ||
      props['system_title_bar'] == true;
  return !useNative;
}

bool _resolveNativeActions(Map<String, Object?> props) {
  if (props['native_window_actions'] == false) return false;
  if (props['window_actions'] == false) return false;
  return true;
}

class _WindowTitleBar extends StatelessWidget {
  final String title;
  final Color titleColor;
  final double height;
  final bool draggable;
  final bool showMinimize;
  final bool showMaximize;
  final bool showClose;
  final bool showDefaultControls;
  final Widget? leading;
  final Widget? content;
  final Widget? trailing;
  final ValueChanged<Offset> onMove;
  final VoidCallback onDragStart;
  final ValueChanged<String> onAction;

  const _WindowTitleBar({
    required this.title,
    required this.titleColor,
    required this.height,
    required this.draggable,
    required this.showMinimize,
    required this.showMaximize,
    required this.showClose,
    required this.showDefaultControls,
    required this.leading,
    required this.content,
    required this.trailing,
    required this.onMove,
    required this.onDragStart,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    Widget titleNode =
        content ??
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: titleColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        );

    Widget trailingNode;
    if (trailing != null) {
      trailingNode = Padding(
        padding: const EdgeInsets.only(right: 6),
        child: trailing!,
      );
    } else if (showDefaultControls) {
      trailingNode = Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (showMinimize)
            _WindowButton(
              icon: Icons.remove,
              onTap: () => onAction('minimize'),
            ),
          if (showMaximize)
            _WindowButton(
              icon: Icons.crop_square_rounded,
              onTap: () => onAction('toggle_maximize'),
            ),
          if (showClose)
            _WindowButton(
              icon: Icons.close,
              danger: true,
              onTap: () => onAction('close'),
            ),
          const SizedBox(width: 6),
        ],
      );
    } else {
      trailingNode = const SizedBox(width: 6);
    }

    Widget bar = SizedBox(
      height: height,
      child: Row(
        children: <Widget>[
          leading == null
              ? const SizedBox(width: 10)
              : Padding(
                  padding: const EdgeInsets.only(left: 8, right: 6),
                  child: leading!,
                ),
          Expanded(
            child: _WindowDragRegion(
              draggable: draggable,
              onMove: onMove,
              onDragStart: onDragStart,
              onAction: onAction,
              child: titleNode,
            ),
          ),
          trailingNode,
        ],
      ),
    );

    return bar;
  }
}

class _WindowDragRegion extends StatelessWidget {
  final bool draggable;
  final ValueChanged<Offset> onMove;
  final VoidCallback onDragStart;
  final ValueChanged<String> onAction;
  final Widget child;

  const _WindowDragRegion({
    required this.draggable,
    required this.onMove,
    required this.onDragStart,
    required this.onAction,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!draggable) return child;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (_) => onDragStart(),
      onPanUpdate: (details) => onMove(details.delta),
      onDoubleTap: () => onAction('toggle_maximize'),
      child: Align(alignment: Alignment.centerLeft, child: child),
    );
  }
}

class _WindowButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool danger;

  const _WindowButton({
    required this.icon,
    required this.onTap,
    this.danger = false,
  });

  @override
  State<_WindowButton> createState() => _WindowButtonState();
}

class _WindowButtonState extends State<_WindowButton> {
  bool _hovered = false;
  bool _pressed = false;

  void _handlePressed() {
    if (!_pressed) {
      setState(() => _pressed = true);
    }
    widget.onTap();
    Timer(const Duration(milliseconds: 120), () {
      if (!mounted) return;
      setState(() => _pressed = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final hoverColor = widget.danger
        ? const Color(0x20FF5A5F)
        : const Color(0x1AFFFFFF);
    final pressColor = widget.danger
        ? const Color(0x33FF5A5F)
        : const Color(0x30FFFFFF);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        scale: _pressed ? 0.9 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: _pressed
                ? pressColor
                : (_hovered ? hoverColor : Colors.transparent),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            splashRadius: 14,
            iconSize: 14,
            visualDensity: VisualDensity.compact,
            onPressed: _handlePressed,
            icon: Icon(widget.icon),
          ),
        ),
      ),
    );
  }
}
