import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/candy/theme_extension.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildArtifactCardControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ArtifactCardControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _ArtifactCardControl extends StatefulWidget {
  const _ArtifactCardControl({
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
  State<_ArtifactCardControl> createState() => _ArtifactCardControlState();
}

class _ArtifactCardControlState extends State<_ArtifactCardControl> {
  late String _title;
  late String _message;

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _ArtifactCardControl oldWidget) {
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
      _syncFromProps();
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  void _syncFromProps() {
    _title = (widget.props['title'] ?? widget.props['label'] ?? '').toString();
    _message = (widget.props['message'] ?? '').toString();
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_content':
        setState(() {
          if (args['title'] != null) _title = args['title'].toString();
          if (args['message'] != null) _message = args['message'].toString();
        });
        _emit('change', _statePayload());
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
        throw UnsupportedError('Unknown artifact_card method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{'title': _title, 'message': _message};
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<ButterflyUIThemeTokens>();
    final props = widget.props;
    final explicitSurfaceFill =
        props.containsKey('bgcolor') ||
        props.containsKey('background') ||
        props.containsKey('gradient');
    final inheritedTint = coerceColor(
      props['surface_tint_color'] ??
          props['__surface_tint_color'] ??
          props['color'],
    );
    final accent =
        coerceColor(props['action_color'] ?? props['color']) ??
        inheritedTint ??
        tokens?.primary ??
        theme.colorScheme.primary;
    final backgroundColor =
        coerceColor(props['bgcolor'] ?? props['background']) ??
        (!explicitSurfaceFill && inheritedTint != null
            ? deriveInheritedSurfaceFill(inheritedTint, alpha: 0.18)
            : tokens?.surface ?? theme.cardColor);
    final borderColor =
        coerceColor(props['border_color']) ??
        (!explicitSurfaceFill && inheritedTint != null
            ? deriveInheritedSurfaceBorder(inheritedTint)
            : tokens?.border ?? theme.colorScheme.outlineVariant);
    final borderWidth =
        coerceDouble(props['border_width']) ??
        (!explicitSurfaceFill && inheritedTint != null ? 1.0 : 0.0);
    final radius = coerceDouble(props['radius']) ?? tokens?.radiusLg ?? 18.0;
    final gradient = coerceGradient(props['gradient']);
    final shadow =
        coerceBoxShadow(props['shadow']) ??
        (props['glow'] == true
            ? <BoxShadow>[
                BoxShadow(
                  color: accent.withValues(alpha: 0.28),
                  blurRadius: 24,
                  spreadRadius: 0.5,
                  offset: const Offset(0, 10),
                ),
              ]
            : null);
    final titleColor =
        coerceColor(
          props['title_color'] ?? props['text_color'] ?? props['foreground'],
        ) ??
        tokens?.text ??
        theme.colorScheme.onSurface;
    final messageColor =
        coerceColor(
          props['message_color'] ??
              props['subtitle_color'] ??
              props['muted_text_color'],
        ) ??
        tokens?.mutedText ??
        theme.colorScheme.onSurfaceVariant;
    final contentPadding =
        coercePadding(props['content_padding']) ??
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14);

    Widget? child;
    for (final raw in widget.rawChildren) {
      if (raw is Map) {
        child = widget.buildChild(coerceObjectMap(raw));
        break;
      }
    }

    final actionLabel = props['action_label']?.toString();
    final actionVariant = (props['action_variant'] ?? 'soft')
        .toString()
        .trim()
        .toLowerCase();
    final actionTextColor =
        coerceColor(props['action_text_color']) ??
        (actionVariant == 'filled'
            ? _resolveReadableForeground(accent)
            : accent);
    final actionBackground = switch (actionVariant) {
      'filled' => accent,
      'outlined' || 'text' => Colors.transparent,
      _ => accent.withValues(alpha: 0.12),
    };
    final actionStyle = TextButton.styleFrom(
      foregroundColor: actionTextColor,
      backgroundColor: actionBackground,
      side: actionVariant == 'outlined'
          ? BorderSide(color: accent.withValues(alpha: 0.5), width: 1)
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          coerceDouble(props['action_radius']) ?? 12,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    );

    Widget body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_title.isNotEmpty)
          Text(
            _title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: titleColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        if (_message.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            _message,
            style: theme.textTheme.bodyMedium?.copyWith(color: messageColor),
          ),
        ],
        if (child != null) ...[const SizedBox(height: 12), child],
        if (actionLabel != null && actionLabel.isNotEmpty) ...[
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _emit('action', _statePayload()),
              style: actionStyle,
              child: Text(actionLabel),
            ),
          ),
        ],
      ],
    );

    final clickable = props['clickable'] == true;
    if (clickable) {
      body = Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: () => _emit('tap', _statePayload()),
          child: Padding(padding: contentPadding, child: body),
        ),
      );
    } else {
      body = Padding(padding: contentPadding, child: body);
    }

    Widget surface = DecoratedBox(
      decoration: BoxDecoration(
        color: gradient == null ? backgroundColor : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
        border: borderWidth <= 0
            ? null
            : Border.all(color: borderColor, width: borderWidth),
        boxShadow: shadow,
      ),
      child: body,
    );

    final blur = (coerceDouble(props['backdrop_blur'] ?? props['blur']) ?? 0.0)
        .clamp(0.0, 30.0);
    final backdropColor = coerceColor(props['backdrop_color']);
    if (blur > 0 || backdropColor != null) {
      surface = ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: backdropColor,
              borderRadius: BorderRadius.circular(radius),
            ),
            child: surface,
          ),
        ),
      );
    }

    return _applyArtifactTransparency(child: surface, props: props);
  }
}

Color _resolveReadableForeground(Color background) {
  return ThemeData.estimateBrightnessForColor(background) == Brightness.dark
      ? Colors.white
      : Colors.black;
}

Widget _applyArtifactTransparency({
  required Widget child,
  required Map<String, Object?> props,
}) {
  final explicitOpacity = coerceDouble(props['opacity']);
  final transparency = coerceDouble(
    props['transparency'] ?? props['alpha'] ?? props['translucency'],
  );
  double? resolvedOpacity = explicitOpacity;
  if (transparency != null) {
    final normalized = transparency > 1
        ? (transparency / 100.0).clamp(0.0, 1.0)
        : transparency.clamp(0.0, 1.0);
    final transparencyOpacity = 1.0 - normalized;
    resolvedOpacity = resolvedOpacity == null
        ? transparencyOpacity
        : (resolvedOpacity * transparencyOpacity).clamp(0.0, 1.0);
  }
  if (resolvedOpacity == null || resolvedOpacity >= 1.0) {
    return child;
  }
  return Opacity(opacity: resolvedOpacity.clamp(0.0, 1.0), child: child);
}
