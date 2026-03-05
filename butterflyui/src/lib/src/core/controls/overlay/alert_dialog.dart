import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:butterflyui_runtime/src/core/control_theme.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
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
    child: child,
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
  );
}

Widget _buildAlertDialogBody(
  String controlId,
  Map<String, Object?> props,
  Widget Function(Map<String, Object?> child) buildFromControl,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final title = _coerceDialogNode(
    props['title'],
    buildFromControl,
    const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
  );
  final content = _coerceDialogNode(props['content'], buildFromControl, null);

  final actions = _coerceActions(props['actions']);
  final actionWidgets = actions
      .map((action) => _buildActionButton(controlId, action, sendEvent))
      .whereType<Widget>()
      .toList();

  return ConstrainedBox(
    constraints: BoxConstraints(
      maxWidth: coerceDouble(props['max_width']) ?? 520,
      minWidth: coerceDouble(props['min_width']) ?? 280,
    ),
    child: Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(coerceDouble(props['radius']) ?? 12),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) title,
            if (title != null && content != null) const SizedBox(height: 8),
            if (content != null) content,
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
  String controlId,
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

  switch (variant) {
    case 'filled':
    case 'elevated':
      return ElevatedButton(
        onPressed: enabled ? handleTap : null,
        child: Text(label),
      );
    case 'outlined':
      return OutlinedButton(
        onPressed: enabled ? handleTap : null,
        child: Text(label),
      );
    default:
      return TextButton(
        onPressed: enabled ? handleTap : null,
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
      case 'get_state':
        return {'open': _open, 'present': _present};
      default:
        throw UnsupportedError('Unknown alert_dialog method: $method');
    }
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
    if (!_present && !_open) {
      return const SizedBox.shrink();
    }

    final scope = IgnorePointer(
      ignoring: !_open,
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: FocusScope(
          autofocus: _open,
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
