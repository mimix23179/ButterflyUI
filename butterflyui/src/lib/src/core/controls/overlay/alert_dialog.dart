import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:butterflyui_runtime/src/core/control_theme.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/styling/theme_extension.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildAlertDialogControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildFromControl,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final transition = props['transition'] is Map
      ? coerceObjectMap(props['transition'] as Map)
      : const <String, Object?>{};

  Widget? child;
  final childFromChildren = rawChildren.whereType<Map>().map(coerceObjectMap);
  if (childFromChildren.isNotEmpty) {
    child = buildFromControl(childFromChildren.first);
  } else if (props['child'] is Map) {
    child = buildFromControl(coerceObjectMap(props['child'] as Map));
  }

  child ??= _buildAlertDialogBody(
    controlId,
    props,
    buildFromControl,
    sendEvent,
  );

  return _AlertDialogModal(
    controlId: controlId,
    initialOpen: props['open'] == true,
    dismissible: props['dismissible'] == true,
    closeOnEscape: props['close_on_escape'] == null
        ? true
        : (props['close_on_escape'] == true),
    trapFocus: props['trap_focus'] == null
        ? true
        : (props['trap_focus'] == true),
    duration: Duration(
      milliseconds:
          (coerceOptionalInt(
                    props['duration_ms'] ?? transition['duration_ms'],
                  ) ??
                  200)
              .clamp(0, 2000),
    ),
    transitionType:
        (props['transition_type']?.toString() ??
                transition['type']?.toString() ??
                'fade')
            .toLowerCase(),
    sourceRect: _coerceRect(props['source_rect'] ?? transition['origin']),
    scrimColor: coerceColor(props['scrim_color']),
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
    child: child,
  );
}

Widget _buildAlertDialogBody(
  String controlId,
  Map<String, Object?> props,
  Widget Function(Map<String, Object?> child) buildFromControl,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return Builder(
    builder: (context) {
      final tokens = Theme.of(context).extension<ButterflyUIThemeTokens>();
      final surface = butterflyuiResolveSurfaceChrome(
        context,
        props,
        fallbackBackground: butterflyuiSurface(context),
        fallbackBorder: butterflyuiBorder(context),
        fallbackRadius: tokens?.radiusLg ?? 16.0,
        fallbackBorderWidth: coerceDouble(props['border_width']) ?? 1.0,
        fallbackPadding: const EdgeInsets.all(16),
      );
      final titleColor = butterflyuiResolveSlotColor(
        context,
        props,
        slot: 'label',
        explicit: props['title_color'],
        fallback: butterflyuiText(context),
      );
      final bodyColor = butterflyuiResolveSlotColor(
        context,
        props,
        slot: 'content',
        explicit: props['text_color'] ?? props['content_color'],
        fallback: butterflyuiMutedText(context),
        muted: true,
      );
      final title = _coerceDialogNode(
        props['title'],
        buildFromControl,
        TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: titleColor,
        ),
      );
      final content = _coerceDialogNode(
        props['content'],
        buildFromControl,
        TextStyle(color: bodyColor),
      );
      final actions = _coerceActions(props['actions']);
      final actionWidgets = actions
          .map(
            (action) => _buildActionButton(
              context,
              controlId,
              props,
              action,
              sendEvent,
            ),
          )
          .whereType<Widget>()
          .toList();

      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: coerceDouble(props['max_width']) ?? 520,
          minWidth: coerceDouble(props['min_width']) ?? 280,
        ),
        child: Material(
          color: surface.backgroundColor,
          elevation: 0,
          borderRadius: BorderRadius.circular(surface.radius),
          clipBehavior: Clip.antiAlias,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: surface.backgroundColor,
              gradient: surface.gradient,
              borderRadius: BorderRadius.circular(surface.radius),
              border: surface.borderWidth <= 0
                  ? null
                  : Border.all(
                      color: surface.borderColor,
                      width: surface.borderWidth,
                    ),
              boxShadow: surface.boxShadow,
            ),
            child: Padding(
              padding:
                  surface.contentPadding ??
                  const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title case final titleWidget?) titleWidget,
                  if (title != null && content != null) const SizedBox(height: 8),
                  if (content case final contentWidget?)
                    DefaultTextStyle.merge(
                      style: TextStyle(color: bodyColor),
                      child: contentWidget,
                    ),
                  if (actionWidgets.isNotEmpty) const SizedBox(height: 16),
                  if (actionWidgets.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        for (var i = 0; i < actionWidgets.length; i += 1) ...[
                          if (i > 0) const SizedBox(width: 8),
                          actionWidgets[i],
                        ],
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget? _coerceDialogNode(
  Object? value,
  Widget Function(Map<String, Object?> child) buildFromControl,
  TextStyle? style,
) {
  if (value == null) return null;
  if (value is Map) {
    return buildFromControl(coerceObjectMap(value));
  }
  final text = value.toString();
  if (text.isEmpty) return null;
  return Text(text, style: style);
}

List<Map<String, Object?>> _coerceActions(Object? raw) {
  if (raw is! List) return const <Map<String, Object?>>[];
  return raw
      .map((entry) {
        if (entry is Map) return coerceObjectMap(entry);
        final label = entry?.toString();
        if (label == null || label.isEmpty) return null;
        return <String, Object?>{'label': label};
      })
      .whereType<Map<String, Object?>>()
      .toList();
}

Widget? _buildActionButton(
  BuildContext context,
  String controlId,
  Map<String, Object?> dialogProps,
  Map<String, Object?> action,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final label = (action['label'] ?? action['text'])?.toString();
  if (label == null || label.isEmpty) return null;
  final actionId = (action['id'] ?? label).toString();
  final variant = (action['variant'] ?? 'text').toString().toLowerCase();
  final enabled = action['enabled'] != false;
  final payload = <String, Object?>{
    'id': actionId,
    'label': label,
    if (action['value'] != null) 'value': action['value'],
  };

  void handleTap() {
    if (!enabled || controlId.isEmpty) return;
    sendEvent(controlId, 'action', payload);
  }

  final mergedProps = <String, Object?>{...dialogProps, ...action};
  final surface = butterflyuiResolveSurfaceChrome(
    context,
    mergedProps,
    fallbackBackground: switch (variant) {
      'filled' || 'elevated' => butterflyuiPrimary(context),
      'outlined' => Colors.transparent,
      _ => Colors.transparent,
    },
    fallbackBorder: butterflyuiBorder(context),
    fallbackRadius: butterflyuiTokens(context)?.radiusMd ?? 12,
    fallbackBorderWidth: variant == 'outlined' ? 1.0 : 0.0,
    fallbackPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
  );
  final primary = butterflyuiPrimary(context);
  final text = butterflyuiResolveSlotColor(
    context,
    mergedProps,
    slot: 'label',
    fallback: butterflyuiText(context),
  );
  final filledForeground = butterflyuiResolveSlotColor(
    context,
    mergedProps,
    slot: 'label',
    fallback: _resolveReadableForeground(
      surface.backgroundColor ?? primary,
    ),
  );
  final shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(surface.radius),
  );

  switch (variant) {
    case 'filled':
    case 'elevated':
      return ElevatedButton(
        onPressed: enabled ? handleTap : null,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: surface.backgroundColor ?? primary,
          foregroundColor: filledForeground,
          shape: shape,
          padding: surface.contentPadding,
        ),
        child: Text(label),
      );
    case 'outlined':
      return OutlinedButton(
        onPressed: enabled ? handleTap : null,
        style: OutlinedButton.styleFrom(
          foregroundColor: text,
          side: BorderSide(
            color: surface.borderColor,
            width: surface.borderWidth,
          ),
          shape: shape,
          backgroundColor: surface.backgroundColor,
          padding: surface.contentPadding,
        ),
        child: Text(label),
      );
    default:
      return TextButton(
        onPressed: enabled ? handleTap : null,
        style: TextButton.styleFrom(
          foregroundColor: text,
          shape: shape,
          backgroundColor: surface.backgroundColor,
          padding: surface.contentPadding,
        ),
        child: Text(label),
      );
  }
}

Rect? _coerceRect(Object? raw) {
  if (raw is List && raw.length >= 4) {
    final left = coerceDouble(raw[0]);
    final top = coerceDouble(raw[1]);
    final width = coerceDouble(raw[2]);
    final height = coerceDouble(raw[3]);
    if (left != null && top != null && width != null && height != null) {
      return Rect.fromLTWH(left, top, width, height);
    }
  }
  if (raw is Map) {
    final map = coerceObjectMap(raw);
    final left = coerceDouble(map['x'] ?? map['left']);
    final top = coerceDouble(map['y'] ?? map['top']);
    final width = coerceDouble(map['width'] ?? map['w']);
    final height = coerceDouble(map['height'] ?? map['h']);
    if (left != null && top != null && width != null && height != null) {
      return Rect.fromLTWH(left, top, width, height);
    }
  }
  return null;
}

Color _resolveReadableForeground(Color background) {
  return ThemeData.estimateBrightnessForColor(background) == Brightness.dark
      ? Colors.white
      : Colors.black;
}

class _AlertDialogModal extends StatefulWidget {
  const _AlertDialogModal({
    required this.controlId,
    required this.child,
    required this.initialOpen,
    required this.dismissible,
    required this.closeOnEscape,
    required this.trapFocus,
    required this.duration,
    required this.transitionType,
    required this.sourceRect,
    required this.scrimColor,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Widget child;
  final bool initialOpen;
  final bool dismissible;
  final bool closeOnEscape;
  final bool trapFocus;
  final Duration duration;
  final String transitionType;
  final Rect? sourceRect;
  final Color? scrimColor;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_AlertDialogModal> createState() => _AlertDialogModalState();
}

class _AlertDialogModalState extends State<_AlertDialogModal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
    reverseDuration: widget.duration,
  );
  late final Animation<double> _opacity = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );
  late final Animation<double> _scale = Tween<double>(
    begin: 0.96,
    end: 1.0,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(0, 0.04),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

  late bool _open = widget.initialOpen;
  bool _present = false;
  bool _dismissSent = false;
  late bool _dismissible = widget.dismissible;
  late bool _closeOnEscape = widget.closeOnEscape;
  late bool _trapFocus = widget.trapFocus;
  late Color? _scrimColor = widget.scrimColor;

  @override
  void initState() {
    super.initState();
    _present = _open;
    _controller.value = _open ? 1.0 : 0.0;
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _AlertDialogModal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    if (oldWidget.initialOpen != widget.initialOpen) {
      _open = widget.initialOpen;
    }
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
      _controller.reverseDuration = widget.duration;
    }
    _dismissible = widget.dismissible;
    _closeOnEscape = widget.closeOnEscape;
    _trapFocus = widget.trapFocus;
    _scrimColor = widget.scrimColor;
    if (_open) {
      _dismissSent = false;
      if (!_present) {
        setState(() => _present = true);
      }
      _controller.forward();
      return;
    }
    _controller.reverse().whenComplete(() {
      if (!mounted || _open) return;
      if (_present) {
        setState(() => _present = false);
      }
    });
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    _controller.dispose();
    super.dispose();
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_open':
        setState(() {
          _open = args['value'] == true;
          if (_open) {
            _dismissSent = false;
            _present = true;
            _controller.forward();
          } else {
            _controller.reverse().whenComplete(() {
              if (!mounted || _open) return;
              setState(() => _present = false);
            });
          }
        });
        return null;
      case 'set_props':
        final incoming = args['props'];
        if (incoming is Map) {
          final props = coerceObjectMap(incoming);
          setState(() {
            if (props.containsKey('open')) {
              _open = props['open'] == true;
              if (_open) {
                _dismissSent = false;
                _present = true;
                _controller.forward();
              } else {
                _controller.reverse().whenComplete(() {
                  if (!mounted || _open) return;
                  setState(() => _present = false);
                });
              }
            }
            if (props.containsKey('dismissible')) {
              _dismissible = props['dismissible'] == true;
            }
            if (props.containsKey('close_on_escape')) {
              _closeOnEscape = props['close_on_escape'] == true;
            }
            if (props.containsKey('trap_focus')) {
              _trapFocus = props['trap_focus'] != false;
            }
            if (props.containsKey('scrim_color')) {
              _scrimColor = coerceColor(props['scrim_color']);
            }
          });
        }
        return {'open': _open, 'present': _present};
      case 'emit':
      case 'trigger':
        {
          final fallback = method == 'trigger' ? 'change' : method;
          final event = (args['event'] ?? args['name'] ?? fallback).toString();
          final payload = args['payload'] is Map
              ? coerceObjectMap(args['payload'] as Map)
              : <String, Object?>{};
          if (widget.controlId.isNotEmpty) {
            widget.sendEvent(widget.controlId, event, payload);
          }
          return true;
        }
      case 'get_state':
        return {'open': _open, 'present': _present};
      default:
        throw UnsupportedError('Unknown alert_dialog method: $method');
    }
  }

  void _dismiss() {
    if (_dismissSent || !_dismissible) return;
    _dismissSent = true;
    setState(() {
      _open = false;
    });
    _controller.reverse().whenComplete(() {
      if (!mounted || _open) return;
      setState(() => _present = false);
    });
    if (widget.controlId.isNotEmpty) {
      widget.sendEvent(widget.controlId, 'dismiss', const {});
      widget.sendEvent(widget.controlId, 'close', const {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_present && !_open) {
      return const SizedBox.shrink();
    }

    final scope = IgnorePointer(
      ignoring: !_open,
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: FocusScope(
          autofocus: _open,
          canRequestFocus: _trapFocus,
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: _dismissible ? _dismiss : null,
                  child: FadeTransition(
                    opacity: _opacity,
                    child: Container(
                      color:
                          _scrimColor ??
                          butterflyuiScrim(context, opacity: 0.54),
                    ),
                  ),
                ),
              ),
              Center(child: RepaintBoundary(child: _buildTransitionedChild())),
            ],
          ),
        ),
      ),
    );

    if (!_closeOnEscape) return scope;
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

  Widget _buildTransitionedChild() {
    final child = Material(color: Colors.transparent, child: widget.child);
    final normalized = widget.transitionType
        .trim()
        .toLowerCase()
        .replaceAll('-', '_')
        .replaceAll(' ', '_');
    switch (normalized) {
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
        final alignment = normalized == 'pop_from_rect'
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
