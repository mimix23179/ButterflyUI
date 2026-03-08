import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_shells/base_control_shell.dart';
import 'package:butterflyui_runtime/src/core/control_shells/layout_control_shell.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildContainerControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildFromControl,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ContainerControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildFromControl: buildFromControl,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _ContainerControl extends StatefulWidget {
  const _ContainerControl({
    required this.controlId,
    required this.props,
    required this.rawChildren,
    required this.buildFromControl,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final List<dynamic> rawChildren;
  final Widget Function(Map<String, Object?> child) buildFromControl;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_ContainerControl> createState() => _ContainerControlState();
}

class _ContainerControlState extends State<_ContainerControl> {
  late Map<String, Object?> _liveProps;

  @override
  void initState() {
    super.initState();
    _liveProps = <String, Object?>{...widget.props};
    registerInvokeHandlerIfNeeded(
      controlId: widget.controlId,
      registerInvokeHandler: widget.registerInvokeHandler,
      handler: _handleInvoke,
    );
  }

  @override
  void didUpdateWidget(covariant _ContainerControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    syncInvokeHandlerRegistration(
      previousControlId: oldWidget.controlId,
      currentControlId: widget.controlId,
      registerInvokeHandler: widget.registerInvokeHandler,
      unregisterInvokeHandler: widget.unregisterInvokeHandler,
      handler: _handleInvoke,
    );
    if (oldWidget.props != widget.props) {
      _liveProps = <String, Object?>{...widget.props};
    }
  }

  @override
  void dispose() {
    unregisterInvokeHandlerIfNeeded(
      controlId: widget.controlId,
      unregisterInvokeHandler: widget.unregisterInvokeHandler,
    );
    super.dispose();
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_layout':
      case 'set_style':
      case 'set_props':
        setState(() {
          _liveProps = <String, Object?>{
            ..._liveProps,
            ..._extractPropUpdates(args),
          };
        });
        return _statePayload();
      case 'get_state':
      case 'get_layout':
        return _statePayload();
      case 'emit':
        final event = (args['event'] ?? 'change').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        if (widget.controlId.isNotEmpty) {
          widget.sendEvent(widget.controlId, event, payload);
        }
        return null;
      default:
        throw UnsupportedError('Unknown container method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      if (_liveProps['width'] != null) 'width': _liveProps['width'],
      if (_liveProps['height'] != null) 'height': _liveProps['height'],
      if (_liveProps['min_width'] != null) 'min_width': _liveProps['min_width'],
      if (_liveProps['min_height'] != null)
        'min_height': _liveProps['min_height'],
      if (_liveProps['max_width'] != null) 'max_width': _liveProps['max_width'],
      if (_liveProps['max_height'] != null)
        'max_height': _liveProps['max_height'],
      if (_liveProps['bgcolor'] != null || _liveProps['color'] != null)
        'bgcolor': _liveProps['bgcolor'] ?? _liveProps['color'],
      if (_liveProps['radius'] != null) 'radius': _liveProps['radius'],
      if (_liveProps['alignment'] != null) 'alignment': _liveProps['alignment'],
      if (_liveProps['slot'] != null) 'slot': _liveProps['slot'],
      if (_liveProps['title'] != null) 'title': _liveProps['title'],
      if (_liveProps['size'] != null) 'size': _liveProps['size'],
      if (_liveProps['content_layout'] != null)
        'content_layout': _liveProps['content_layout'],
      if (_liveProps['content_gap'] != null)
        'content_gap': _liveProps['content_gap'],
    };
  }

  @override
  Widget build(BuildContext context) {
    final childMaps = resolveControlChildMaps(widget.rawChildren, _liveProps);
    final width = coerceDouble(_liveProps['width']);
    final height = coerceDouble(_liveProps['height']);
    final minWidth = coerceDouble(_liveProps['min_width']);
    final minHeight = coerceDouble(_liveProps['min_height']);
    final maxWidth = coerceDouble(_liveProps['max_width']);
    final maxHeight = coerceDouble(_liveProps['max_height']);
    final margin = coercePadding(_liveProps['margin']);
    final opacity = coerceDouble(_liveProps['opacity']);
    final contentPadding = coercePadding(_liveProps['content_padding']);
    final contentAlignment = parseLayoutAlignment(
      _liveProps['content_alignment'],
    );
    final image = coerceDecorationImage(_liveProps['image']);
    final suppressSurfaceFill = _shouldSuppressSurfaceFill(
      _liveProps,
      image: image,
    );
    final inheritedSurfaceTint = coerceColor(
      _liveProps['__surface_tint_color'],
    );
    final hasExplicitSurfaceFill =
        _coerceBool(_liveProps['__has_explicit_surface_fill']) == true;
    final bgColor = suppressSurfaceFill
        ? null
        : !hasExplicitSurfaceFill && inheritedSurfaceTint != null
        ? deriveInheritedSurfaceFill(inheritedSurfaceTint)
        : coerceColor(_liveProps['bgcolor'] ?? _liveProps['color']);
    final borderColor =
        coerceColor(_liveProps['border_color']) ??
        (!hasExplicitSurfaceFill && inheritedSurfaceTint != null
            ? deriveInheritedSurfaceBorder(inheritedSurfaceTint)
            : null);
    final borderWidth = coerceDouble(_liveProps['border_width']) ?? 0.0;
    final radius = coerceDouble(_liveProps['radius']);
    final boxShadow = coerceBoxShadow(_liveProps['shadow']);
    final gradient = suppressSurfaceFill
        ? null
        : !hasExplicitSurfaceFill && inheritedSurfaceTint != null
        ? null
        : coerceGradient(_liveProps['gradient']);
    final shapeStr = _liveProps['shape']?.toString().toLowerCase();
    final shape = shapeStr == 'circle' ? BoxShape.circle : BoxShape.rectangle;
    final blur = _effectiveBlur(coerceDouble(_liveProps['blur']));
    final contentGap = coerceDouble(_liveProps['content_gap']) ?? 0.0;
    final contentLayout =
        (_liveProps['content_layout']?.toString().toLowerCase() ?? 'single')
            .trim();
    final clipBehavior =
        parseLayoutClip(_liveProps['clip_behavior']) ?? Clip.none;
    final scrollAxis = parseLayoutAxis(_liveProps['content_scroll']);

    Widget? content;
    if (childMaps.length == 1) {
      content = widget.buildFromControl(childMaps.first);
    } else if (childMaps.length > 1) {
      final builtChildren = childMaps.map(widget.buildFromControl).toList();
      if (contentLayout == 'row' || contentLayout == 'horizontal') {
        content = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: buildSpacedChildren(
            builtChildren,
            Axis.horizontal,
            contentGap,
          ),
        );
      } else if (contentLayout == 'stack') {
        content = Stack(children: builtChildren);
      } else {
        content = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: buildSpacedChildren(
            builtChildren,
            Axis.vertical,
            contentGap,
          ),
        );
      }
    }
    if (content != null && scrollAxis != null) {
      content = SingleChildScrollView(
        scrollDirection: scrollAxis,
        child: content,
      );
    }

    Widget container = Container(
      width: width,
      height: height,
      constraints: buildLayoutConstraints(
        minWidth: minWidth,
        minHeight: minHeight,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      ),
      margin: margin,
      alignment: contentAlignment,
      padding: contentPadding,
      decoration: _buildBoxDecoration(
        color: bgColor,
        borderColor: borderColor,
        borderWidth: borderWidth,
        radius: radius,
        boxShadow: boxShadow,
        gradient: gradient,
        image: image,
        shape: shape,
      ),
      child: content,
    );

    if (opacity != null && opacity >= 0 && opacity < 1) {
      container = Opacity(opacity: opacity.clamp(0.0, 1.0), child: container);
    }

    if (blur > 0) {
      Widget blurred = ClipRRect(
        borderRadius: (shape == BoxShape.circle || radius == null)
            ? BorderRadius.zero
            : BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: container,
        ),
      );
      if (shape == BoxShape.circle) {
        blurred = ClipOval(clipBehavior: clipBehavior, child: blurred);
      } else if (clipBehavior != Clip.none) {
        blurred = ClipRRect(
          clipBehavior: clipBehavior,
          borderRadius: radius == null
              ? BorderRadius.zero
              : BorderRadius.circular(radius),
          child: blurred,
        );
      }
      return blurred;
    }

    if (shape == BoxShape.circle) {
      return ClipOval(clipBehavior: clipBehavior, child: container);
    }
    if (clipBehavior != Clip.none) {
      return ClipRRect(
        clipBehavior: clipBehavior,
        borderRadius: radius == null
            ? BorderRadius.zero
            : BorderRadius.circular(radius),
        child: container,
      );
    }
    return container;
  }
}

BoxDecoration? _buildBoxDecoration({
  Color? color,
  Color? borderColor,
  double? borderWidth,
  double? radius,
  List<BoxShadow>? boxShadow,
  Gradient? gradient,
  DecorationImage? image,
  BoxShape shape = BoxShape.rectangle,
}) {
  if (color == null &&
      borderColor == null &&
      radius == null &&
      boxShadow == null &&
      gradient == null &&
      image == null &&
      shape == BoxShape.rectangle) {
    return null;
  }
  return BoxDecoration(
    color: color,
    border: borderColor == null || (borderWidth ?? 0) <= 0
        ? null
        : Border.all(color: borderColor, width: borderWidth ?? 1.0),
    borderRadius: (shape == BoxShape.circle || radius == null)
        ? null
        : BorderRadius.circular(radius),
    boxShadow: boxShadow,
    gradient: gradient,
    image: image,
    shape: shape,
  );
}

double _effectiveBlur(double? value) {
  if (value == null || value <= 0) return 0.0;
  var blur = value.clamp(0.0, 16.0);
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
    blur = blur.clamp(0.0, 6.0);
  }
  return blur.toDouble();
}

bool _shouldSuppressSurfaceFill(
  Map<String, Object?> props, {
  required DecorationImage? image,
}) {
  final preserveSurface =
      _coerceBool(
        props['preserve_surface'] ??
            props['preserve_fill'] ??
            props['preserve_background'],
      ) ==
      true;
  if (preserveSurface) {
    return false;
  }
  return _coerceBool(props['__image_backdrop_inherited']) == true ||
      image != null;
}

bool? _coerceBool(Object? value) {
  if (value is bool) {
    return value;
  }
  final normalized = value?.toString().trim().toLowerCase();
  if (normalized == null || normalized.isEmpty) {
    return null;
  }
  if (normalized == 'true' || normalized == '1' || normalized == 'yes') {
    return true;
  }
  if (normalized == 'false' || normalized == '0' || normalized == 'no') {
    return false;
  }
  return null;
}

Map<String, Object?> _extractPropUpdates(Map<String, Object?> args) {
  final props = args['props'];
  if (props is Map) {
    return coerceObjectMap(props);
  }
  return args;
}
