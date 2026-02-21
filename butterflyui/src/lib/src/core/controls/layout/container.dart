import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:conduit_runtime/src/core/control_utils.dart';

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
    border: borderColor == null
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

Widget buildContainerControl(
  Map<String, Object?> props,
  List children,
  Widget Function(Map<String, Object?> child) buildFromControl,
) {
  final sourceChildren = children.isEmpty && props['children'] is List
      ? props['children'] as List
      : children;
  final childMaps = _childMaps(sourceChildren);
  if (childMaps.isEmpty && props['child'] is Map) {
    childMaps.add(coerceObjectMap(props['child'] as Map));
  }
  final width = coerceDouble(props['width']);
  final height = coerceDouble(props['height']);
  final minWidth = coerceDouble(props['min_width']);
  final minHeight = coerceDouble(props['min_height']);
  final maxWidth = coerceDouble(props['max_width']);
  final maxHeight = coerceDouble(props['max_height']);
  final margin = coercePadding(props['margin']);
  final opacity = coerceDouble(props['opacity']);
  final contentPadding = coercePadding(props['content_padding']);
  final contentAlignment = _parseAlignment(props['content_alignment']);
  // Use 'color' as alias for 'bgcolor' for consistency with headers style
  final bgColor = coerceColor(props['bgcolor'] ?? props['color']);
  final borderColor = coerceColor(props['border_color']);
  final borderWidth = coerceDouble(props['border_width']);
  final radius = coerceDouble(props['radius']);
  final boxShadow = coerceBoxShadow(props['shadow']);
  final gradient = coerceGradient(props['gradient']);
  final image = coerceDecorationImage(props['image']);
  final shapeStr = props['shape']?.toString().toLowerCase();
  final shape = shapeStr == 'circle' ? BoxShape.circle : BoxShape.rectangle;
  final blur = _effectiveBlur(coerceDouble(props['blur']));
  final contentGap = coerceDouble(props['content_gap']) ?? 0.0;
  final contentLayout =
      (props['content_layout']?.toString().toLowerCase() ?? 'single').trim();
  final clipBehavior = _parseClip(props['clip_behavior']) ?? Clip.none;
  final scrollAxis = _parseAxis(props['content_scroll']);

  Widget? content;
  if (childMaps.length == 1) {
    content = buildFromControl(childMaps.first);
  } else if (childMaps.length > 1) {
    final builtChildren = childMaps.map(buildFromControl).toList();
    if (contentLayout == 'row' || contentLayout == 'horizontal') {
      content = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _withSpacing(builtChildren, Axis.horizontal, contentGap),
      );
    } else if (contentLayout == 'stack') {
      content = Stack(children: builtChildren);
    } else {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _withSpacing(builtChildren, Axis.vertical, contentGap),
      );
    }
  }
  if (content != null && scrollAxis != null) {
    content = SingleChildScrollView(
      scrollDirection: scrollAxis,
      child: content,
    );
  }

  final decoration = _buildBoxDecoration(
    color: bgColor,
    borderColor: borderColor,
    borderWidth: borderWidth,
    radius: radius,
    boxShadow: boxShadow,
    gradient: gradient,
    image: image,
    shape: shape,
  );

  Widget container = Container(
    width: width,
    height: height,
    constraints: _buildConstraints(
      minWidth: minWidth,
      minHeight: minHeight,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    ),
    margin: margin,
    alignment: contentAlignment,
    padding: contentPadding,
    decoration: decoration,
    child: content,
  );

  if (opacity != null && opacity >= 0 && opacity < 1) {
    container = Opacity(opacity: opacity.clamp(0.0, 1.0), child: container);
  }

  if (blur > 0) {
    // For glassmorphism, we clip the blur to the container's shape
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

double _effectiveBlur(double? value) {
  if (value == null || value <= 0) return 0.0;
  var blur = value.clamp(0.0, 16.0);
  // Backdrop blur can hitch badly on Windows when layered many times.
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
    blur = blur.clamp(0.0, 6.0);
  }
  return blur.toDouble();
}

BoxConstraints? _buildConstraints({
  double? minWidth,
  double? minHeight,
  double? maxWidth,
  double? maxHeight,
}) {
  if (minWidth == null &&
      minHeight == null &&
      maxWidth == null &&
      maxHeight == null) {
    return null;
  }
  return BoxConstraints(
    minWidth: minWidth ?? 0,
    minHeight: minHeight ?? 0,
    maxWidth: maxWidth ?? double.infinity,
    maxHeight: maxHeight ?? double.infinity,
  );
}

List<Map<String, Object?>> _childMaps(List children) {
  final out = <Map<String, Object?>>[];
  for (final child in children) {
    if (child is Map) {
      out.add(coerceObjectMap(child));
    }
  }
  return out;
}

List<Widget> _withSpacing(List<Widget> items, Axis axis, double spacing) {
  if (spacing <= 0 || items.length < 2) return items;
  final out = <Widget>[];
  for (var i = 0; i < items.length; i += 1) {
    if (i > 0) {
      out.add(
        axis == Axis.horizontal
            ? SizedBox(width: spacing)
            : SizedBox(height: spacing),
      );
    }
    out.add(items[i]);
  }
  return out;
}

Alignment? _parseAlignment(Object? value) {
  if (value == null) return null;
  if (value is List && value.length >= 2) {
    final x = coerceDouble(value[0]) ?? 0.0;
    final y = coerceDouble(value[1]) ?? 0.0;
    return Alignment(x, y);
  }
  if (value is Map) {
    final map = coerceObjectMap(value);
    final x = coerceDouble(map['x']);
    final y = coerceDouble(map['y']);
    if (x != null || y != null) {
      return Alignment(x ?? 0.0, y ?? 0.0);
    }
  }
  final s = value
      .toString()
      .toLowerCase()
      .replaceAll('-', '_')
      .replaceAll(' ', '_');
  switch (s) {
    case 'center':
      return Alignment.center;
    case 'top':
    case 'top_center':
      return Alignment.topCenter;
    case 'bottom':
    case 'bottom_center':
      return Alignment.bottomCenter;
    case 'left':
    case 'center_left':
    case 'start':
      return Alignment.centerLeft;
    case 'right':
    case 'center_right':
    case 'end':
      return Alignment.centerRight;
    case 'top_left':
      return Alignment.topLeft;
    case 'top_right':
      return Alignment.topRight;
    case 'bottom_left':
      return Alignment.bottomLeft;
    case 'bottom_right':
      return Alignment.bottomRight;
  }
  return null;
}

Clip? _parseClip(Object? value) {
  final s = value?.toString().toLowerCase();
  switch (s) {
    case 'hardedge':
    case 'hard_edge':
      return Clip.hardEdge;
    case 'antialias':
    case 'anti_alias':
      return Clip.antiAlias;
    case 'antialiaswithsavelayer':
    case 'anti_alias_with_save_layer':
      return Clip.antiAliasWithSaveLayer;
    case 'none':
      return Clip.none;
  }
  return null;
}

Axis? _parseAxis(Object? value) {
  final s = value?.toString().toLowerCase();
  switch (s) {
    case 'horizontal':
    case 'x':
      return Axis.horizontal;
    case 'vertical':
    case 'y':
      return Axis.vertical;
  }
  return null;
}
