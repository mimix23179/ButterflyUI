// Unified Candy umbrella control
// This replaces the separate engine/host/registry/renderer files
// It registers candy controls directly into the global registry

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/candy/theme.dart';
import 'package:butterflyui_runtime/src/core/candy/theme_extension.dart';
import 'package:butterflyui_runtime/src/core/control_registry.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/align_control.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/card.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/column.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/container.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/row.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/stack.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/wrap.dart';
import 'package:butterflyui_runtime/src/core/controls/buttons/button.dart';
import 'package:butterflyui_runtime/src/core/controls/customization/border.dart';
import 'package:butterflyui_runtime/src/core/controls/customization/badge.dart';
import 'package:butterflyui_runtime/src/core/controls/customization/color_tools.dart';
import 'package:butterflyui_runtime/src/core/controls/effects/shimmer_shadow.dart';
import 'package:butterflyui_runtime/src/core/controls/effects/layer.dart';
import 'package:butterflyui_runtime/src/core/controls/effects/particle_field.dart';
import 'package:butterflyui_runtime/src/core/controls/effects/motion.dart';
import 'package:butterflyui_runtime/src/core/controls/display/canvas_control.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

// ============================================================================
// Candy Context - provides environment for building candy controls
// ============================================================================

class CandyContext {
  final String controlId;
  final Map<String, Object?> merged;
  final List<dynamic> rawChildren;
  final CandyTokens tokens;
  final ButterflyUIThemeTokens style;
  final ButterflyUISendRuntimeEvent sendEvent;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final Widget Function(Map<String, Object?> control) buildChild;

  CandyContext({
    required this.controlId,
    required this.merged,
    required this.rawChildren,
    required this.tokens,
    required this.style,
    required this.sendEvent,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.buildChild,
  });
}

// Helper functions to build children
List<Widget> candyBuildAllChildren(
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> control) buildChild,
) {
  return rawChildren
      .whereType<Map>()
      .map((c) => buildChild(coerceObjectMap(c)))
      .toList();
}

Widget candyFirstChildOrEmpty(
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> control) buildChild,
) {
  final children = rawChildren.whereType<Map>().toList();
  if (children.isEmpty) return const SizedBox.shrink();
  return buildChild(coerceObjectMap(children.first));
}

// Parse helper functions
MainAxisAlignment candyParseMainAxis(Object? value) {
  final v = candyNorm(value?.toString() ?? '');
  return switch (v) {
    'start' || 'min' => MainAxisAlignment.start,
    'end' || 'max' => MainAxisAlignment.end,
    'center' => MainAxisAlignment.center,
    'space_between' || 'spaceBetween' => MainAxisAlignment.spaceBetween,
    'space_around' || 'spaceAround' => MainAxisAlignment.spaceAround,
    'space_evenly' || 'spaceEvenly' => MainAxisAlignment.spaceEvenly,
    _ => MainAxisAlignment.start,
  };
}

CrossAxisAlignment candyParseCrossAxis(Object? value) {
  final v = candyNorm(value?.toString() ?? '');
  return switch (v) {
    'start' || 'min' => CrossAxisAlignment.start,
    'end' || 'max' => CrossAxisAlignment.end,
    'center' => CrossAxisAlignment.center,
    'stretch' => CrossAxisAlignment.stretch,
    'baseline' => CrossAxisAlignment.baseline,
    _ => CrossAxisAlignment.start,
  };
}

MainAxisSize candyParseMainAxisSize(Object? value) {
  final v = candyNorm(value?.toString() ?? '');
  return v == 'max' ? MainAxisSize.max : MainAxisSize.min;
}

StackFit candyParseStackFit(Object? value) {
  final v = candyNorm(value?.toString() ?? '');
  return switch (v) {
    'loose' => StackFit.loose,
    'expand' => StackFit.expand,
    'passthrough' => StackFit.passthrough,
    _ => StackFit.loose,
  };
}

WrapAlignment candyParseWrapAlignment(Object? value) {
  final v = candyNorm(value?.toString() ?? '');
  return switch (v) {
    'start' => WrapAlignment.start,
    'end' => WrapAlignment.end,
    'center' => WrapAlignment.center,
    'space_between' || 'spaceBetween' => WrapAlignment.spaceBetween,
    'space_around' || 'spaceAround' => WrapAlignment.spaceAround,
    'space_evenly' || 'spaceEvenly' => WrapAlignment.spaceEvenly,
    _ => WrapAlignment.start,
  };
}

WrapCrossAlignment candyParseWrapCrossAxis(Object? value) {
  final v = candyNorm(value?.toString() ?? '');
  return switch (v) {
    'start' => WrapCrossAlignment.start,
    'end' => WrapCrossAlignment.end,
    'center' => WrapCrossAlignment.center,
    _ => WrapCrossAlignment.start,
  };
}

Clip candyParseClip(Object? value) {
  final v = candyNorm(value?.toString() ?? '');
  return switch (v) {
    'none' => Clip.none,
    'hard' || 'antiAliasWithSaveLayer' => Clip.antiAliasWithSaveLayer,
    _ => Clip.antiAlias,
  };
}

BoxFit candyParseBoxFit(Object? value) {
  final v = candyNorm(value?.toString() ?? '');
  return switch (v) {
    'none' => BoxFit.none,
    'contain' => BoxFit.contain,
    'cover' => BoxFit.cover,
    'fill' => BoxFit.fill,
    'fitWidth' => BoxFit.fitWidth,
    'fitHeight' => BoxFit.fitHeight,
    'scaleDown' => BoxFit.scaleDown,
    _ => BoxFit.contain,
  };
}

Alignment candyParseAlignment(Object? value) {
  if (value == null) return Alignment.topLeft;
  final v = value.toString();
  if (v.contains('center')) return Alignment.center;
  if (v.contains('right')) {
    if (v.contains('bottom')) return Alignment.bottomRight;
    if (v.contains('top')) return Alignment.topRight;
    return Alignment.centerRight;
  }
  if (v.contains('bottom')) return Alignment.bottomLeft;
  return Alignment.topLeft;
}

TextAlign? candyParseTextAlign(Object? value) {
  final v = candyNorm(value?.toString() ?? '');
  return switch (v) {
    'left' => TextAlign.left,
    'right' => TextAlign.right,
    'center' => TextAlign.center,
    'justify' => TextAlign.justify,
    _ => null,
  };
}

TextOverflow? candyParseTextOverflow(Object? value) {
  final v = candyNorm(value?.toString() ?? '');
  return switch (v) {
    'clip' => TextOverflow.clip,
    'ellipsis' => TextOverflow.ellipsis,
    'fade' => TextOverflow.fade,
    _ => null,
  };
}

FontWeight? candyParseWeight(Object? value) {
  if (value == null) return null;
  final v = value.toString();
  final num? weight = coerceDouble(v);
  if (weight != null) return FontWeight.values[(weight / 100).round().clamp(1, 9)];
  return switch (candyNorm(v)) {
    '100' || 'thin' => FontWeight.w100,
    '200' || 'extralight' => FontWeight.w200,
    '300' || 'light' => FontWeight.w300,
    '400' || 'regular' || 'normal' => FontWeight.w400,
    '500' || 'medium' => FontWeight.w500,
    '600' || 'semibold' => FontWeight.w600,
    '700' || 'bold' => FontWeight.w700,
    '800' || 'extrabold' => FontWeight.w800,
    '900' || 'black' => FontWeight.w900,
    _ => null,
  };
}

IconData? candyParseIcon(Object? value) {
  if (value == null) return null;
  final v = value.toString().toLowerCase();
  // Common icon mappings
  return switch (v) {
    'home' || 'house' => Icons.home,
    'search' || 'magnify' => Icons.search,
    'settings' || 'cog' => Icons.settings,
    'add' || 'plus' => Icons.add,
    'remove' || 'minus' => Icons.remove,
    'delete' || 'trash' => Icons.delete,
    'edit' || 'pencil' => Icons.edit,
    'close' || 'x' => Icons.close,
    'check' || 'tick' => Icons.check,
    'menu' || 'hamburger' => Icons.menu,
    'arrow_back' || 'back' => Icons.arrow_back,
    'arrow_forward' || 'forward' => Icons.arrow_forward,
    'arrow_up' || 'up' => Icons.arrow_upward,
    'arrow_down' || 'down' => Icons.arrow_downward,
    'star' || 'favorite' => Icons.star,
    'star_outline' || 'favorite_border' => Icons.star_border,
    'mail' || 'email' => Icons.mail,
    'person' || 'user' => Icons.person,
    'image' || 'photo' => Icons.image,
    'camera' => Icons.camera,
    'play' || 'play_arrow' => Icons.play_arrow,
    'pause' => Icons.pause,
    'stop' => Icons.stop,
    'refresh' || 'reload' => Icons.refresh,
    'visibility' || 'eye' => Icons.visibility,
    'visibility_off' || 'eye_off' => Icons.visibility_off,
    _ => Icons.help_outline,
  };
}

Curve candyParseCurve(Object? value) {
  final v = candyNorm(value?.toString() ?? '');
  return switch (v) {
    'linear' => Curves.linear,
    'ease' => Curves.ease,
    'ease_in' || 'easeIn' => Curves.easeIn,
    'ease_out' || 'easeOut' => Curves.easeOut,
    'ease_in_out' || 'easeInOut' => Curves.easeInOut,
    'elastic_out' || 'elasticOut' => Curves.elasticOut,
    'bounce_out' || 'bounceOut' => Curves.bounceOut,
    _ => Curves.easeInOut,
  };
}

EdgeInsets? candyCoercePadding(Object? value) {
  if (value == null) return null;
  if (value is num) return EdgeInsets.all(value.toDouble());
  if (value is Map) {
    final map = coerceObjectMap(value);
    final all = coerceDouble(map['all']);
    if (all != null) return EdgeInsets.all(all);
    return EdgeInsets.only(
      left: coerceDouble(map['left']) ?? 0,
      right: coerceDouble(map['right']) ?? 0,
      top: coerceDouble(map['top']) ?? 0,
      bottom: coerceDouble(map['bottom']) ?? 0,
    );
  }
  return null;
}

Border? candyCoerceBorder(Map<String, Object?> m) {
  final color = coerceColor(m['border_color'] ?? m['border']);
  if (color == null) return null;
  final width = coerceDouble(m['border_width']) ?? 1.0;
  final radius = coerceDouble(m['border_radius']);
  
  if (radius != null && radius > 0) {
    return Border.all(color: color, width: width);
  }
  return Border.all(color: color, width: width);
}

String candyNorm(String v) => v.replaceAll('-', '_').replaceAll(' ', '_').toLowerCase();

// ============================================================================
// Candy Control Builders
// ============================================================================

// Layout controls
Widget? buildCandyLayoutModule(String module, CandyContext ctx) {
  return switch (module) {
    'row' => _buildRow(ctx),
    'column' => _buildColumn(ctx),
    'stack' => _buildStack(ctx),
    'wrap' => _buildWrap(ctx),
    'container' || 'surface' => _buildContainer(ctx),
    'align' => _buildAlign(ctx),
    'center' => _buildCenter(ctx),
    'spacer' => _buildSpacer(ctx),
    'aspect_ratio' || 'aspectratio' => _buildAspectRatio(ctx),
    'overflow_box' || 'overflowbox' => _buildOverflowBox(ctx),
    'fitted_box' || 'fittedbox' => _buildFittedBox(ctx),
    'card' => _buildCard(ctx),
    _ => null,
  };
}

Widget _buildRow(CandyContext ctx) {
  final m = ctx.merged;
  final spacing = coerceDouble(m['spacing']) ?? 0;
  final children = candyBuildAllChildren(ctx.rawChildren, ctx.buildChild);

  if (spacing > 0) {
    final spaced = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      spaced.add(children[i]);
      if (i < children.length - 1) spaced.add(SizedBox(width: spacing));
    }
    return Row(
      mainAxisAlignment: candyParseMainAxis(m['main_axis'] ?? m['alignment']),
      crossAxisAlignment: candyParseCrossAxis(m['cross_axis']),
      mainAxisSize: candyParseMainAxisSize(m['main_axis_size']),
      children: spaced,
    );
  }

  return buildRowControl(m, ctx.rawChildren, ctx.tokens, ctx.buildChild);
}

Widget _buildColumn(CandyContext ctx) {
  final m = ctx.merged;
  final spacing = coerceDouble(m['spacing']) ?? 0;
  final children = candyBuildAllChildren(ctx.rawChildren, ctx.buildChild);

  if (spacing > 0) {
    final spaced = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      spaced.add(children[i]);
      if (i < children.length - 1) spaced.add(SizedBox(height: spacing));
    }
    return Column(
      mainAxisAlignment: candyParseMainAxis(m['main_axis'] ?? m['alignment']),
      crossAxisAlignment: candyParseCrossAxis(m['cross_axis']),
      mainAxisSize: candyParseMainAxisSize(m['main_axis_size']),
      children: spaced,
    );
  }

  return buildColumnControl(m, ctx.rawChildren, ctx.tokens, ctx.buildChild);
}

Widget _buildStack(CandyContext ctx) {
  return buildStackControl(
    ctx.merged,
    ctx.rawChildren,
    ctx.buildChild,
  );
}

Widget _buildWrap(CandyContext ctx) {
  return buildWrapControl(
    ctx.merged,
    ctx.rawChildren,
    ctx.tokens,
    ctx.buildChild,
  );
}

Widget _buildContainer(CandyContext ctx) {
  return buildContainerControl(
    ctx.merged,
    ctx.rawChildren,
    ctx.buildChild,
  );
}

Widget _buildAlign(CandyContext ctx) {
  return buildAlignControl(
    '${ctx.controlId}::align',
    ctx.merged,
    ctx.rawChildren,
    ctx.buildChild,
    ctx.registerInvokeHandler,
    ctx.unregisterInvokeHandler,
    ctx.sendEvent,
  );
}

Widget _buildCenter(CandyContext ctx) {
  return Align(
    alignment: Alignment.center,
    widthFactor: coerceDouble(ctx.merged['width_factor']),
    heightFactor: coerceDouble(ctx.merged['height_factor']),
    child: candyFirstChildOrEmpty(ctx.rawChildren, ctx.buildChild),
  );
}

Widget _buildSpacer(CandyContext ctx) {
  final flex = coerceOptionalInt(ctx.merged['flex']);
  final box = SizedBox(
    width: coerceDouble(ctx.merged['width']),
    height: coerceDouble(ctx.merged['height']),
  );
  if (flex != null && flex > 0) return Expanded(flex: flex, child: box);
  return box;
}

Widget _buildAspectRatio(CandyContext ctx) {
  return AspectRatio(
    aspectRatio: coerceDouble(ctx.merged['value'] ?? ctx.merged['ratio']) ?? 1.6,
    child: candyFirstChildOrEmpty(ctx.rawChildren, ctx.buildChild),
  );
}

Widget _buildOverflowBox(CandyContext ctx) {
  final m = ctx.merged;
  return OverflowBox(
    alignment: candyParseAlignment(m['alignment']),
    minWidth: coerceDouble(m['min_width']),
    maxWidth: coerceDouble(m['max_width']),
    minHeight: coerceDouble(m['min_height']),
    maxHeight: coerceDouble(m['max_height']),
    child: candyFirstChildOrEmpty(ctx.rawChildren, ctx.buildChild),
  );
}

Widget _buildFittedBox(CandyContext ctx) {
  final m = ctx.merged;
  return FittedBox(
    fit: candyParseBoxFit(m['fit']),
    alignment: candyParseAlignment(m['alignment']),
    clipBehavior: candyParseClip(m['clip_behavior']),
    child: candyFirstChildOrEmpty(ctx.rawChildren, ctx.buildChild),
  );
}

Widget _buildCard(CandyContext ctx) {
  return buildCardControl(ctx.merged, ctx.rawChildren, ctx.tokens, ctx.buildChild);
}

// Interactive controls
Widget? buildCandyInteractiveModule(String module, CandyContext ctx) {
  return switch (module) {
    'button' => _buildButton(ctx),
    'badge' => _buildBadge(ctx),
    'avatar' => _buildAvatar(ctx),
    'icon' => _buildIcon(ctx),
    'text' => _buildText(ctx),
    _ => null,
  };
}

Widget _buildButton(CandyContext ctx) {
  return buildButtonControl(ctx.controlId, ctx.merged, ctx.tokens, ctx.sendEvent);
}

Widget _buildBadge(CandyContext ctx) {
  return buildBadgeControl(
    '${ctx.controlId}::badge',
    ctx.merged,
    ctx.rawChildren,
    ctx.buildChild,
    ctx.registerInvokeHandler,
    ctx.unregisterInvokeHandler,
    ctx.sendEvent,
  );
}

Widget _buildAvatar(CandyContext ctx) {
  final m = ctx.merged;
  final size = coerceDouble(m['size']) ?? 36.0;
  final label = (m['label'] ?? m['text'] ?? '').toString();
  final src = m['src']?.toString();
  final hasImage = src != null && src.isNotEmpty;
  final image = hasImage ? NetworkImage(src) : null;
  final bg = coerceColor(m['bgcolor']) ?? ctx.style.background;
  final fg = coerceColor(m['color']) ?? ctx.style.text;
  final shape = candyNorm((m['shape'] ?? 'circle').toString());

  final initials = label.isNotEmpty ? label.substring(0, 1).toUpperCase() : '?';
  final textChild = Text(
    initials,
    style: TextStyle(
      color: fg,
      fontSize: size * 0.38,
      fontWeight: FontWeight.w600,
    ),
  );

  if (shape == 'square' || shape == 'rect' || shape == 'rectangle') {
    final radius = coerceDouble(m['radius']) ?? (size * 0.2);
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        width: size,
        height: size,
        color: bg,
        alignment: Alignment.center,
        child: image != null
            ? Image(image: image, width: size, height: size, fit: BoxFit.cover)
            : textChild,
      ),
    );
  }

  return CircleAvatar(
    radius: size / 2,
    backgroundColor: bg,
    foregroundColor: fg,
    backgroundImage: image,
    child: image == null ? textChild : null,
  );
}

Widget _buildIcon(CandyContext ctx) {
  final m = ctx.merged;
  return Icon(
    candyParseIcon(m['icon']) ?? Icons.help_outline,
    size: coerceDouble(m['size']),
    color: coerceColor(m['color']) ?? ctx.style.text,
  );
}

Widget _buildText(CandyContext ctx) {
  final m = ctx.merged;
  return Text(
    (m['text'] ?? m['value'] ?? '').toString(),
    textAlign: candyParseTextAlign(m['align']) ?? TextAlign.start,
    maxLines: coerceOptionalInt(m['max_lines']),
    overflow: candyParseTextOverflow(m['overflow']),
    style: TextStyle(
      color: coerceColor(m['color'] ?? m['text_color']) ?? ctx.style.text,
      fontSize: coerceDouble(m['size'] ?? m['font_size']),
      fontWeight: candyParseWeight(m['weight'] ?? m['font_weight']),
      height: coerceDouble(m['line_height']),
      letterSpacing: coerceDouble(m['letter_spacing']),
    ),
  );
}

// Decoration controls
Widget? buildCandyDecorationModule(String module, CandyContext ctx) {
  return switch (module) {
    'border' => _buildBorder(ctx),
    'shadow' => _buildShadow(ctx),
    'outline' => _buildOutline(ctx),
    'gradient' => _buildGradient(ctx),
    'decorated_box' || 'decoratedbox' => _buildDecoratedBox(ctx),
    'clip' => _buildClip(ctx),
    _ => null,
  };
}

Widget _buildBorder(CandyContext ctx) {
  return buildBorderControl(
    '${ctx.controlId}::border',
    ctx.merged,
    ctx.rawChildren,
    ctx.buildChild,
    ctx.registerInvokeHandler,
    ctx.unregisterInvokeHandler,
  );
}

Widget _buildShadow(CandyContext ctx) {
  return buildShadowStackControl(
    ctx.merged,
    candyFirstChildOrEmpty(ctx.rawChildren, ctx.buildChild),
  );
}

Widget _buildOutline(CandyContext ctx) {
  final m = ctx.merged;
  final outlineColor = coerceColor(m['outline_color']) ?? ctx.style.border;
  final outlineWidth = coerceDouble(m['outline_width']) ?? 1.0;
  final radius = coerceDouble(m['radius']) ?? ctx.style.radiusMd;
  final padding = candyCoercePadding(m['padding']);

  Widget child = candyFirstChildOrEmpty(ctx.rawChildren, ctx.buildChild);
  if (padding != null) child = Padding(padding: padding, child: child);

  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: outlineColor, width: outlineWidth),
      borderRadius: radius > 0 ? BorderRadius.circular(radius) : null,
    ),
    child: child,
  );
}

Widget _buildGradient(CandyContext ctx) {
  return buildGradientControl(
    ctx.merged,
    ctx.rawChildren,
    ctx.buildChild,
    controlId: '${ctx.controlId}::gradient',
    registerInvokeHandler: ctx.registerInvokeHandler,
    unregisterInvokeHandler: ctx.unregisterInvokeHandler,
    sendEvent: ctx.sendEvent,
  );
}

Widget _buildDecoratedBox(CandyContext ctx) {
  final m = ctx.merged;
  final gradient = coerceGradient(m['gradient']);
  final bgcolor = coerceColor(m['bgcolor'] ?? m['background']);
  final radius = coerceDouble(m['radius']) ?? ctx.style.radiusMd;
  final shadows = coerceBoxShadow(m['shadow']);
  final border = candyCoerceBorder(m);
  final padding = candyCoercePadding(m['padding']);

  Widget child = candyFirstChildOrEmpty(ctx.rawChildren, ctx.buildChild);
  if (padding != null) child = Padding(padding: padding, child: child);

  return DecoratedBox(
    decoration: BoxDecoration(
      color: gradient != null ? null : bgcolor,
      gradient: gradient,
      border: border,
      borderRadius: radius > 0 ? BorderRadius.circular(radius) : null,
      boxShadow: shadows,
    ),
    child: child,
  );
}

Widget _buildClip(CandyContext ctx) {
  final m = ctx.merged;
  final child = candyFirstChildOrEmpty(ctx.rawChildren, ctx.buildChild);
  final shape = candyNorm((m['shape'] ?? m['clip_shape'] ?? 'rect').toString());
  final clipBehavior = candyParseClip(m['clip_behavior']);
  final radius = coerceDouble(m['radius']) ?? ctx.style.radiusMd;

  if (shape == 'oval' || shape == 'circle') {
    return ClipOval(clipBehavior: clipBehavior, child: child);
  }

  return ClipRRect(
    clipBehavior: clipBehavior,
    borderRadius: radius > 0 ? BorderRadius.circular(radius) : BorderRadius.zero,
    child: child,
  );
}

// Effects controls
Widget? buildCandyEffectsModule(String module, CandyContext ctx) {
  return switch (module) {
    'effects' => _buildEffects(ctx),
    'particles' => _buildParticles(ctx),
    'canvas' => _buildCanvas(ctx),
    _ => null,
  };
}

Widget _buildEffects(CandyContext ctx) {
  Widget child = buildLayerControl(ctx.merged, ctx.rawChildren, ctx.buildChild);

  if (ctx.merged['shimmer'] == true) {
    child = buildShimmerControl(
      '${ctx.controlId}::effects',
      ctx.merged,
      child,
      ctx.registerInvokeHandler,
      ctx.unregisterInvokeHandler,
    );
  }

  return child;
}

Widget _buildParticles(CandyContext ctx) {
  final particleField = buildParticleFieldControl(
    '${ctx.controlId}::particles',
    ctx.merged,
    ctx.registerInvokeHandler,
    ctx.unregisterInvokeHandler,
    ctx.sendEvent,
  );

  final shouldOverlay = ctx.merged['overlay'] != false;
  if (!shouldOverlay) return particleField;

  final child = candyFirstChildOrEmpty(ctx.rawChildren, ctx.buildChild);
  return Stack(
    fit: StackFit.expand,
    children: [
      child,
      IgnorePointer(child: particleField),
    ],
  );
}

Widget _buildCanvas(CandyContext ctx) {
  return buildCanvasControl(
    '${ctx.controlId}::canvas',
    ctx.merged,
    ctx.registerInvokeHandler,
    ctx.unregisterInvokeHandler,
    ctx.sendEvent,
  );
}

// Motion controls
Widget? buildCandyMotionModule(String module, CandyContext ctx) {
  return switch (module) {
    'animation' || 'motion' => _buildAnimation(ctx),
    'transition' => _buildTransition(ctx),
    _ => null,
  };
}

Widget _buildAnimation(CandyContext ctx) {
  return buildMotionControl(ctx.merged, ctx.rawChildren, ctx.buildChild);
}

Widget _buildTransition(CandyContext ctx) {
  final m = ctx.merged;
  final durationMs = (coerceOptionalInt(m['duration_ms']) ?? 220).clamp(1, 120000);
  final curve = candyParseCurve(m['curve']);
  final preset = candyNorm((m['preset'] ?? 'fade').toString());

  Widget Function(Widget, Animation<double>) builder;
  switch (preset) {
    case 'scale':
      builder = (child, anim) => ScaleTransition(scale: anim, child: child);
    case 'slide':
      builder = (child, anim) => SlideTransition(
            position: Tween<Offset>(begin: const Offset(0.08, 0), end: Offset.zero).animate(anim),
            child: FadeTransition(opacity: anim, child: child),
          );
    case 'slide_up':
      builder = (child, anim) => SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(anim),
            child: FadeTransition(opacity: anim, child: child),
          );
    case 'slide_down':
      builder = (child, anim) => SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, -0.08), end: Offset.zero).animate(anim),
            child: FadeTransition(opacity: anim, child: child),
          );
    default:
      builder = (child, anim) => FadeTransition(opacity: anim, child: child);
  }

  final discriminator = m['key'] ?? m['state'] ?? m['value'];

  return AnimatedSwitcher(
    duration: Duration(milliseconds: durationMs),
    switchInCurve: curve,
    switchOutCurve: curve,
    transitionBuilder: builder,
    child: KeyedSubtree(
      key: ValueKey(discriminator),
      child: candyFirstChildOrEmpty(ctx.rawChildren, ctx.buildChild),
    ),
  );
}

// Helper function to create ButterflyUIThemeTokens from CandyTokens
ButterflyUIThemeTokens _createThemeTokensFromTokens(CandyTokens tokens) {
  // Try to get values from tokens using the map-based API
  final bg = tokens.color('background') ?? const Color(0xFFFAFAFA);
  final surface = tokens.color('surface') ?? const Color(0xFFF5F5F5);
  final surfaceAlt = tokens.color('surfaceAlt') ?? const Color(0xFFEEEEEE);
  final textColor = tokens.color('text') ?? const Color(0xFF1A1A1A);
  final mutedText = tokens.color('mutedText') ?? const Color(0xFF666666);
  final borderColor = tokens.color('border') ?? const Color(0xFFE0E0E0);
  final primary = tokens.color('primary') ?? const Color(0xFF6366F1);
  final secondary = tokens.color('secondary') ?? const Color(0xFF8B5CF6);
  final success = tokens.color('success') ?? const Color(0xFF22C55E);
  final warning = tokens.color('warning') ?? const Color(0xFFF59E0B);
  final info = tokens.color('info') ?? const Color(0xFF3B82F6);
  final error = tokens.color('error') ?? const Color(0xFFEF4444);
  
  return ButterflyUIThemeTokens(
    background: bg,
    surface: surface,
    surfaceAlt: surfaceAlt,
    text: textColor,
    mutedText: mutedText,
    border: borderColor,
    primary: primary,
    secondary: secondary,
    success: success,
    warning: warning,
    info: info,
    error: error,
    fontFamily: null,
    monoFamily: null,
    radiusSm: tokens.number('radius', 'sm') ?? 6,
    radiusMd: tokens.number('radius', 'md') ?? 12,
    radiusLg: tokens.number('radius', 'lg') ?? 18,
    spacingXs: tokens.number('spacing', 'xs') ?? 4,
    spacingSm: tokens.number('spacing', 'sm') ?? 8,
    spacingMd: tokens.number('spacing', 'md') ?? 12,
    spacingLg: tokens.number('spacing', 'lg') ?? 20,
    glassBlur: tokens.number('effects', 'glassBlur') ?? 18,
  );
}

Widget? buildCandyControl(
  String controlId,
  Map<String, Object?> merged,
  List<dynamic> rawChildren,
  CandyTokens tokens,
  // ThemeData is no longer required - we use tokens directly
  ButterflyUISendRuntimeEvent sendEvent,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  Widget Function(Map<String, Object?> control) buildChild,
) {
  final module = merged['module']?.toString();
  if (module == null) return null;
  
  // Build style from tokens - create a fallback ButterflyUIThemeTokens
  final style = _createThemeTokensFromTokens(tokens);
  
  final ctx = CandyContext(
    controlId: controlId,
    merged: merged,
    rawChildren: rawChildren,
    tokens: tokens,
    style: style,
    sendEvent: sendEvent,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    buildChild: buildChild,
  );

  // Chain through all module builders
  return buildCandyLayoutModule(module, ctx) ??
      buildCandyInteractiveModule(module, ctx) ??
      buildCandyDecorationModule(module, ctx) ??
      buildCandyEffectsModule(module, ctx) ??
      buildCandyMotionModule(module, ctx);
}

// ============================================================================
// Registry Registration
// ============================================================================

/// Registers all candy controls into the global registry
void registerCandyControls(ButterflyUIControlRegistry registry) {
  // Register candy_scope - the scope wrapper widget
  registry.register('candy_scope', _buildCandyScope);
  
  // Note: Individual candy controls (candy_row, candy_column, etc.) 
  // are handled via the main 'candy' case in control_renderer.dart
  // which calls buildCandyControl directly
}

// Scope builder
Widget _buildCandyScope(
  ButterflyUIControlContext context,
  Map<String, Object?> control,
) {
  final props = context.propsOf(control);
  
  // Extract scope properties
  final tokensMap = props['tokens'];
  final tokens = tokensMap is Map 
      ? CandyTokens.fromMap(coerceObjectMap(tokensMap)) 
      : context.tokens;
  
  final theme = tokens.buildTheme();
  
  // Get the child
  final childMaps = context.childMapsOf(control);
  final childWidget = childMaps.isNotEmpty 
      ? context.buildChild(childMaps.first) 
      : const SizedBox.shrink();
  
  // Build theme data
  final brightness = props['brightness'] as String? ?? 'light';
  final isDark = brightness.toLowerCase().startsWith('dark');
  
  return _CandyScopeWidget(
    tokens: tokens,
    isDark: isDark,
    child: childWidget,
  );
}

class _CandyScopeWidget extends InheritedWidget {
  final CandyTokens tokens;
  final bool isDark;
  
  const _CandyScopeWidget({
    required this.tokens,
    required this.isDark,
    required Widget child,
  }) : super(child: child);
  
  @override
  bool updateShouldNotify(_CandyScopeWidget oldWidget) {
    return tokens != oldWidget.tokens || isDark != oldWidget.isDark;
  }
}
