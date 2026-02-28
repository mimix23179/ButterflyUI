// Unified Skins umbrella control
// This replaces the separate engine/host/registry/renderer files
// It allows users to create custom skins for their programs using existing components

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
// Skins Context - provides environment for building skin controls
// ============================================================================

class SkinsContext {
  final String controlId;
  final Map<String, Object?> merged;
  final List<dynamic> rawChildren;
  final SkinsTokens tokens;
  final ButterflyUIThemeTokens style;
  final ButterflyUISendRuntimeEvent sendEvent;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final Widget Function(Map<String, Object?> control) buildChild;

  SkinsContext({
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

// ============================================================================
// Skins Tokens - provides theme values for skin controls
// ============================================================================

class SkinsTokens {
  final Map<String, dynamic> _data;

  SkinsTokens(this._data);

  // Get a color value from the tokens
  Color? color(String key, [String? subKey]) {
    Object? value;
    if (subKey != null) {
      final sub = _data[key];
      if (sub is Map) {
        value = sub[subKey];
      }
    } else {
      value = _data[key];
    }
    if (value == null) return null;
    if (value is Color) return value;
    if (value is int) return Color(value);
    if (value is String) {
      try {
        return Color(int.parse(value.replaceFirst('#', '0xFF')));
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  // Get a numeric value from the tokens
  double? number(String key, [String? subKey]) {
    Object? value;
    if (subKey != null) {
      final sub = _data[key];
      if (sub is Map) {
        value = sub[subKey];
      }
    } else {
      value = _data[key];
    }
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  // Get a string value from the tokens
  String? string(String key, [String? subKey]) {
    Object? value;
    if (subKey != null) {
      final sub = _data[key];
      if (sub is Map) {
        value = sub[subKey];
      }
    } else {
      value = _data[key];
    }
    return value?.toString();
  }

  // Get a boolean value from the tokens
  bool? boolean(String key, [String? subKey]) {
    Object? value;
    if (subKey != null) {
      final sub = _data[key];
      if (sub is Map) {
        value = sub[subKey];
      }
    } else {
      value = _data[key];
    }
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    return null;
  }

  // Physics & Atmosphere Getters
  Curve get motionCurve {
    final curveStr = string('physics', 'motion_curve') ?? 'easeOutCubic';
    switch (curveStr.toLowerCase()) {
      case 'linear':
        return Curves.linear;
      case 'easein':
        return Curves.easeIn;
      case 'easeinout':
        return Curves.easeInOut;
      case 'bounceout':
        return Curves.bounceOut;
      case 'elasticout':
        return Curves.elasticOut;
      case 'fastoutslown':
        return Curves.fastOutSlowIn;
      default:
        return Curves.easeOutCubic;
    }
  }

  double get glassBlur => number('physics', 'glass_blur') ?? 10.0;

  double get shadowPhysics => number('physics', 'shadow_physics') ?? 1.0;

  String get hoverBehavior => string('physics', 'hover_behavior') ?? 'lift';

  String get clickEffect => string('physics', 'click_effect') ?? 'ripple';

  Duration get transitionSpeed {
    final ms = number('physics', 'transition_speed_ms') ?? 250;
    return Duration(milliseconds: ms.toInt());
  }

  String? get soundClick => string('sound', 'click');
  String? get soundHover => string('sound', 'hover');
  String? get soundSuccess => string('sound', 'success');
  String? get soundError => string('sound', 'error');
  String? get soundWarning => string('sound', 'warning');
  String? get soundInfo => string('sound', 'info');

  // Build a Flutter ThemeData from tokens
  ThemeData buildTheme({bool isDark = false}) {
    final bg = color('background') ?? const Color(0xFFFAFAFA);
    final primary = color('primary') ?? const Color(0xFF6366F1);
    final brightness = isDark ? Brightness.dark : Brightness.light;

    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: Colors.white,
        secondary: color('secondary') ?? const Color(0xFF8B5CF6),
        onSecondary: Colors.white,
        error: color('error') ?? const Color(0xFFEF4444),
        onError: Colors.white,
        surface: color('surface') ?? const Color(0xFFF5F5F5),
        onSurface: color('text') ?? const Color(0xFF1A1A1A),
      ),
    );
  }

  // Create tokens from a map
  factory SkinsTokens.fromMap(Map<String, dynamic> map) {
    return SkinsTokens(map);
  }

  // Default tokens for built-in skins
  factory SkinsTokens.defaultSkin() {
    return SkinsTokens({
      'background': '#FAFAFA',
      'surface': '#F5F5F5',
      'surfaceAlt': '#EEEEEE',
      'text': '#1A1A1A',
      'mutedText': '#666666',
      'border': '#E0E0E0',
      'primary': '#6366F1',
      'secondary': '#8B5CF6',
      'radius': {'sm': 6, 'md': 12, 'lg': 18},
      'spacing': {'xs': 4, 'sm': 8, 'md': 12, 'lg': 20},
      'effects': {'glassBlur': 18},
    });
  }

  // Shadow skin tokens
  factory SkinsTokens.shadowSkin() {
    return SkinsTokens({
      'background': '#1A1A2E',
      'surface': '#16213E',
      'surfaceAlt': '#0F3460',
      'text': '#EAEAEA',
      'mutedText': '#A0A0A0',
      'border': '#2D2D44',
      'primary': '#7B68EE',
      'secondary': '#9370DB',
      'radius': {'sm': 8, 'md': 16, 'lg': 24},
      'spacing': {'xs': 4, 'sm': 8, 'md': 16, 'lg': 24},
      'effects': {'glassBlur': 20, 'shadow': true},
    });
  }

  // Fire skin tokens
  factory SkinsTokens.fireSkin() {
    return SkinsTokens({
      'background': '#1A0A0A',
      'surface': '#2D1515',
      'surfaceAlt': '#4A1C1C',
      'text': '#FFE4D6',
      'mutedText': '#CC9988',
      'border': '#5C2020',
      'primary': '#FF4500',
      'secondary': '#FF6347',
      'radius': {'sm': 4, 'md': 8, 'lg': 16},
      'spacing': {'xs': 2, 'sm': 6, 'md': 10, 'lg': 18},
      'effects': {'fire': true, 'glow': true},
    });
  }

  // Earth skin tokens
  factory SkinsTokens.earthSkin() {
    return SkinsTokens({
      'background': '#1A1A14',
      'surface': '#2D2D1F',
      'surfaceAlt': '#3D3D2A',
      'text': '#E8E4D6',
      'mutedText': '#A8A490',
      'border': '#4A4A35',
      'primary': '#8B7355',
      'secondary': '#A0826D',
      'radius': {'sm': 2, 'md': 6, 'lg': 12},
      'spacing': {'xs': 4, 'sm': 8, 'md': 12, 'lg': 20},
      'effects': {'texture': 'earth'},
    });
  }

  // Gaming skin tokens
  factory SkinsTokens.gamingSkin() {
    return SkinsTokens({
      'background': '#0D0D1A',
      'surface': '#151525',
      'surfaceAlt': '#1E1E30',
      'text': '#00FF88',
      'mutedText': '#00AA55',
      'border': '#2A2A40',
      'primary': '#00FF88',
      'secondary': '#00DDFF',
      'radius': {'sm': 2, 'md': 4, 'lg': 8},
      'spacing': {'xs': 2, 'sm': 4, 'md': 8, 'lg': 16},
      'effects': {'glow': true, 'cyber': true},
    });
  }

  // Create from candy tokens
  factory SkinsTokens.fromCandyTokens(CandyTokens candy) {
    return SkinsTokens({
      'background': candy.color('background')?.value ?? '#FAFAFA',
      'surface': candy.color('surface')?.value ?? '#F5F5F5',
      'surfaceAlt': candy.color('surfaceAlt')?.value ?? '#EEEEEE',
      'text': candy.color('text')?.value ?? '#1A1A1A',
      'mutedText': candy.color('mutedText')?.value ?? '#666666',
      'border': candy.color('border')?.value ?? '#E0E0E0',
      'primary': candy.color('primary')?.value ?? '#6366F1',
      'secondary': candy.color('secondary')?.value ?? '#8B5CF6',
      'radius': {
        'sm': candy.number('radius', 'sm') ?? 6,
        'md': candy.number('radius', 'md') ?? 12,
        'lg': candy.number('radius', 'lg') ?? 18,
      },
      'spacing': {
        'xs': candy.number('spacing', 'xs') ?? 4,
        'sm': candy.number('spacing', 'sm') ?? 8,
        'md': candy.number('spacing', 'md') ?? 12,
        'lg': candy.number('spacing', 'lg') ?? 20,
      },
    });
  }
}

// ============================================================================
// Helper functions to build children
// ============================================================================

List<Widget> skinsBuildAllChildren(
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> control) buildChild,
) {
  return rawChildren
      .whereType<Map>()
      .map((c) => buildChild(coerceObjectMap(c)))
      .toList();
}

Widget skinsFirstChildOrEmpty(
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> control) buildChild,
) {
  final children = rawChildren.whereType<Map>().toList();
  if (children.isEmpty) return const SizedBox.shrink();
  return buildChild(coerceObjectMap(children.first));
}

// ============================================================================
// Parse helper functions
// ============================================================================

MainAxisAlignment skinsParseMainAxis(Object? value) {
  final v = skinsNorm(value?.toString() ?? '');
  return switch (v) {
    'start' || 'min' => MainAxisAlignment.start,
    'end' || 'max' => MainAxisAlignment.end,
    'center' => MainAxisAlignment.center,
    'space_between' || 'spacebetween' => MainAxisAlignment.spaceBetween,
    'space_around' || 'spacearound' => MainAxisAlignment.spaceAround,
    'space_evenly' || 'spaceevenly' => MainAxisAlignment.spaceEvenly,
    _ => MainAxisAlignment.start,
  };
}

CrossAxisAlignment skinsParseCrossAxis(Object? value) {
  final v = skinsNorm(value?.toString() ?? '');
  return switch (v) {
    'start' || 'min' => CrossAxisAlignment.start,
    'end' || 'max' => CrossAxisAlignment.end,
    'center' => CrossAxisAlignment.center,
    'stretch' => CrossAxisAlignment.stretch,
    'baseline' => CrossAxisAlignment.baseline,
    _ => CrossAxisAlignment.start,
  };
}

MainAxisSize skinsParseMainAxisSize(Object? value) {
  final v = skinsNorm(value?.toString() ?? '');
  return v == 'max' ? MainAxisSize.max : MainAxisSize.min;
}

StackFit skinsParseStackFit(Object? value) {
  final v = skinsNorm(value?.toString() ?? '');
  return switch (v) {
    'loose' => StackFit.loose,
    'expand' => StackFit.expand,
    'passthrough' => StackFit.passthrough,
    _ => StackFit.loose,
  };
}

WrapAlignment skinsParseWrapAlignment(Object? value) {
  final v = skinsNorm(value?.toString() ?? '');
  return switch (v) {
    'start' => WrapAlignment.start,
    'end' => WrapAlignment.end,
    'center' => WrapAlignment.center,
    'space_between' || 'spacebetween' => WrapAlignment.spaceBetween,
    'space_around' || 'spacearound' => WrapAlignment.spaceAround,
    'space_evenly' || 'spaceevenly' => WrapAlignment.spaceEvenly,
    _ => WrapAlignment.start,
  };
}

WrapCrossAlignment skinsParseWrapCrossAxis(Object? value) {
  final v = skinsNorm(value?.toString() ?? '');
  return switch (v) {
    'start' => WrapCrossAlignment.start,
    'end' => WrapCrossAlignment.end,
    'center' => WrapCrossAlignment.center,
    _ => WrapCrossAlignment.start,
  };
}

Clip skinsParseClip(Object? value) {
  final v = skinsNorm(value?.toString() ?? '');
  return switch (v) {
    'none' => Clip.none,
    'hard' || 'antialiaswithsavelayer' => Clip.antiAliasWithSaveLayer,
    _ => Clip.antiAlias,
  };
}

BoxFit skinsParseBoxFit(Object? value) {
  final v = skinsNorm(value?.toString() ?? '');
  return switch (v) {
    'none' => BoxFit.none,
    'contain' => BoxFit.contain,
    'cover' => BoxFit.cover,
    'fill' => BoxFit.fill,
    'fitwidth' => BoxFit.fitWidth,
    'fitheight' => BoxFit.fitHeight,
    'scaledown' => BoxFit.scaleDown,
    _ => BoxFit.contain,
  };
}

Alignment skinsParseAlignment(Object? value) {
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

TextAlign? skinsParseTextAlign(Object? value) {
  final v = skinsNorm(value?.toString() ?? '');
  return switch (v) {
    'left' => TextAlign.left,
    'right' => TextAlign.right,
    'center' => TextAlign.center,
    'justify' => TextAlign.justify,
    _ => null,
  };
}

TextOverflow? skinsParseTextOverflow(Object? value) {
  final v = skinsNorm(value?.toString() ?? '');
  return switch (v) {
    'clip' => TextOverflow.clip,
    'ellipsis' => TextOverflow.ellipsis,
    'fade' => TextOverflow.fade,
    _ => null,
  };
}

FontWeight? skinsParseWeight(Object? value) {
  if (value == null) return null;
  final v = value.toString().toLowerCase();
  return switch (v) {
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

FontStyle? skinsParseFontStyle(Object? value) {
  final v = skinsNorm(value?.toString() ?? '');
  return switch (v) {
    'normal' => FontStyle.normal,
    'italic' => FontStyle.italic,
    _ => null,
  };
}

TextDecoration? skinsParseDecoration(Object? value) {
  final v = skinsNorm(value?.toString() ?? '');
  return switch (v) {
    'none' => TextDecoration.none,
    'underline' => TextDecoration.underline,
    'overline' => TextDecoration.overline,
    'linethrough' => TextDecoration.lineThrough,
    _ => null,
  };
}

Curve skinsParseCurve(Object? value) {
  final v = skinsNorm(value?.toString() ?? '');
  return switch (v) {
    'linear' => Curves.linear,
    'ease' => Curves.ease,
    'easein' => Curves.easeIn,
    'easeout' => Curves.easeOut,
    'easeinout' => Curves.easeInOut,
    'easeincubic' => Curves.easeInCubic,
    'easeoutcubic' => Curves.easeOutCubic,
    'easeinoutcubic' => Curves.easeInOutCubic,
    'fastoutslowin' => Curves.fastOutSlowIn,
    'bouncein' => Curves.bounceIn,
    'bounceout' => Curves.bounceOut,
    'bounceinout' => Curves.bounceInOut,
    'elasticin' => Curves.elasticIn,
    'elasticout' => Curves.elasticOut,
    'elasticinout' => Curves.elasticInOut,
    _ => Curves.easeOut,
  };
}

double skinsParseOpacity(Object? value) {
  if (value == null) return 1.0;
  if (value is num) return value.clamp(0.0, 1.0).toDouble();
  final parsed = double.tryParse(value.toString());
  return parsed?.clamp(0.0, 1.0) ?? 1.0;
}

String skinsNorm(String v) {
  return v
      .toLowerCase()
      .replaceAll('_', '')
      .replaceAll('-', '')
      .replaceAll(' ', '');
}

// ============================================================================
// Padding helper
// ============================================================================

EdgeInsets? skinsCoercePadding(Object? value) {
  if (value == null) return null;
  if (value is EdgeInsets) return value;

  double? top, right, bottom, left;

  if (value is num) {
    final v = value.toDouble();
    top = right = bottom = left = v;
  } else if (value is List && value.length >= 4) {
    top = (value[0] as num).toDouble();
    right = (value[1] as num).toDouble();
    bottom = (value[2] as num).toDouble();
    left = (value[3] as num).toDouble();
  } else if (value is Map) {
    top = (value['top'] as num?)?.toDouble();
    right = (value['right'] as num?)?.toDouble();
    bottom = (value['bottom'] as num?)?.toDouble();
    left = (value['left'] as num?)?.toDouble();

    // Handle symmetric padding
    final vertical = (value['vertical'] as num?)?.toDouble();
    final horizontal = (value['horizontal'] as num?)?.toDouble();

    if (vertical != null) {
      top ??= vertical;
      bottom ??= vertical;
    }
    if (horizontal != null) {
      left ??= horizontal;
      right ??= horizontal;
    }
  }

  if (top == null && right == null && bottom == null && left == null) {
    return null;
  }

  return EdgeInsets.only(
    top: top ?? 0,
    right: right ?? 0,
    bottom: bottom ?? 0,
    left: left ?? 0,
  );
}

Border? skinsCoerceBorder(Map<String, Object?> m) {
  final borderData = m['border'];
  if (borderData == null) return null;

  if (borderData is Border) return borderData;

  if (borderData is Map) {
    final width = coerceDouble(borderData['width'] ?? borderData['size']) ?? 1;
    final color =
        coerceColor(borderData['color'] ?? borderData['stroke']) ?? Colors.grey;

    final style = borderData['style']?.toString() ?? 'solid';
    if (style == 'none') return null;

    return Border.all(color: color, width: width);
  }

  return null;
}

// ============================================================================
// Build functions for each skin module type
// ============================================================================

// Layout module
Widget? buildSkinsLayoutModule(String module, SkinsContext ctx) {
  return switch (module) {
    'row' => _buildRow(ctx),
    'column' => _buildColumn(ctx),
    'stack' => _buildStack(ctx),
    'wrap' => _buildWrap(ctx),
    'align' || 'alignment' => _buildAlign(ctx),
    'container' => _buildContainer(ctx),
    'card' => _buildCard(ctx),
    'button' || 'btn' => _buildButton(ctx),
    'badge' => _buildBadge(ctx),
    'border' => _buildBorder(ctx),
    'page' => _buildPage(ctx),
    _ => null,
  };
}

Widget _buildPage(SkinsContext ctx) {
  final child = skinsFirstChildOrEmpty(ctx.rawChildren, ctx.buildChild);
  return Scaffold(
    backgroundColor: Colors.transparent,
    body: SafeArea(child: child),
  );
}

Widget _buildRow(SkinsContext ctx) {
  // Use the existing row control with skin tokens
  return buildRowControl(
    ctx.merged,
    skinsBuildAllChildren(ctx.rawChildren, ctx.buildChild),
    _createCandyTokensFromSkins(ctx.tokens),
    ctx.buildChild,
  );
}

Widget _buildColumn(SkinsContext ctx) {
  // Use the existing column control with skin tokens
  return buildColumnControl(
    ctx.merged,
    skinsBuildAllChildren(ctx.rawChildren, ctx.buildChild),
    _createCandyTokensFromSkins(ctx.tokens),
    ctx.buildChild,
  );
}

Widget _buildStack(SkinsContext ctx) {
  // Use the existing stack control with skin tokens
  return buildStackControl(
    ctx.merged,
    skinsBuildAllChildren(ctx.rawChildren, ctx.buildChild),
    ctx.buildChild,
  );
}

Widget _buildWrap(SkinsContext ctx) {
  // Use the existing wrap control with skin tokens
  return buildWrapControl(
    ctx.merged,
    skinsBuildAllChildren(ctx.rawChildren, ctx.buildChild),
    _createCandyTokensFromSkins(ctx.tokens),
    ctx.buildChild,
  );
}

Widget _buildAlign(SkinsContext ctx) {
  // Use the existing align control with skin tokens
  return buildAlignControl(
    ctx.controlId,
    ctx.merged,
    ctx.rawChildren,
    ctx.buildChild,
    ctx.registerInvokeHandler,
    ctx.unregisterInvokeHandler,
    ctx.sendEvent,
  );
}

Widget _buildContainer(SkinsContext ctx) {
  // Use the existing container control with skin tokens
  return buildContainerControl(
    ctx.merged,
    skinsBuildAllChildren(ctx.rawChildren, ctx.buildChild),
    ctx.buildChild,
  );
}

Widget _buildCard(SkinsContext ctx) {
  // Use the existing card control with skin tokens
  return buildCardControl(
    ctx.merged,
    skinsBuildAllChildren(ctx.rawChildren, ctx.buildChild),
    _createCandyTokensFromSkins(ctx.tokens),
    ctx.buildChild,
  );
}

Widget _buildButton(SkinsContext ctx) {
  final m = ctx.merged;

  // Convert SkinsTokens to a map that can be used as props
  final buttonProps = Map<String, Object?>.from(m);

  // Convert SkinsTokens to CandyTokens
  final candyTokens = _createCandyTokensFromSkins(ctx.tokens);

  // Build button using the existing button control with converted tokens
  return buildButtonControl(
    ctx.controlId,
    buttonProps,
    candyTokens,
    ctx.sendEvent,
  );
}

Widget _buildBadge(SkinsContext ctx) {
  // Build badge using the existing badge control
  return buildBadgeControl(
    ctx.controlId,
    ctx.merged,
    ctx.rawChildren,
    ctx.buildChild,
    ctx.registerInvokeHandler,
    ctx.unregisterInvokeHandler,
    ctx.sendEvent,
  );
}

Widget _buildBorder(SkinsContext ctx) {
  // Use the existing border control with skin tokens
  return buildBorderControl(
    ctx.controlId,
    ctx.merged,
    ctx.rawChildren,
    ctx.buildChild,
    ctx.registerInvokeHandler,
    ctx.unregisterInvokeHandler,
  );
}

// Decoration module
BoxDecoration? _buildSkinDecoration(SkinsContext ctx) {
  final m = ctx.merged;
  final gradient = coerceGradient(m['gradient']);
  final bgcolor = coerceColor(m['bgcolor'] ?? m['background']);
  final radius = coerceDouble(m['radius']) ?? ctx.style.radiusMd;
  final shadows = coerceBoxShadow(m['shadow']);
  final border = skinsCoerceBorder(m);

  if (gradient == null &&
      bgcolor == null &&
      shadows == null &&
      border == null) {
    return null;
  }

  return BoxDecoration(
    color: gradient != null ? null : bgcolor,
    gradient: gradient,
    border: border,
    borderRadius: radius > 0 ? BorderRadius.circular(radius) : null,
    boxShadow: shadows,
  );
}

ShapeBorder? _buildSkinShape(SkinsContext ctx) {
  final m = ctx.merged;
  final radius = coerceDouble(m['radius']) ?? ctx.style.radiusMd;
  final border = skinsCoerceBorder(m);

  final shapeType = m['shape']?.toString().toLowerCase();

  switch (shapeType) {
    case 'circle':
      return CircleBorder(side: border?.top ?? BorderSide.none);
    case 'oval':
      return const StadiumBorder();
    default:
      return RoundedRectangleBorder(
        side: border?.top ?? BorderSide.none,
        borderRadius: BorderRadius.circular(radius),
      );
  }
}

// ============================================================================
// Build main Skins control
// ============================================================================

Widget? buildSkinsControl(
  String controlId,
  Map<String, Object?> merged,
  List<dynamic> rawChildren,
  SkinsTokens tokens,
  ButterflyUISendRuntimeEvent sendEvent,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  Widget Function(Map<String, Object?> control) buildChild,
) {
  final module = merged['module']?.toString();
  if (module == null) return null;

  // Build style from tokens
  final style = _createThemeTokensFromTokens(tokens);

  final ctx = SkinsContext(
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
  return buildSkinsLayoutModule(module, ctx) ??
      buildSkinsDecorationModule(module, ctx) ??
      buildSkinsEffectsModule(module, ctx) ??
      buildSkinsMotionModule(module, ctx);
}

// Decoration module builder
Widget? buildSkinsDecorationModule(String module, SkinsContext ctx) {
  return switch (module) {
    'gradient' => _buildGradient(ctx),
    'decorated' || 'decoratedbox' => _buildDecoratedBox(ctx),
    'clip' => _buildClip(ctx),
    _ => null,
  };
}

Widget _buildGradient(SkinsContext ctx) {
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

Widget _buildDecoratedBox(SkinsContext ctx) {
  final m = ctx.merged;
  final gradient = coerceGradient(m['gradient']);
  final bgcolor = coerceColor(m['bgcolor'] ?? m['background']);
  final radius = coerceDouble(m['radius']) ?? ctx.style.radiusMd;
  final shadows = coerceBoxShadow(m['shadow']);
  final border = skinsCoerceBorder(m);
  final padding = skinsCoercePadding(m['padding']);

  Widget child = skinsFirstChildOrEmpty(ctx.rawChildren, ctx.buildChild);
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

Widget _buildClip(SkinsContext ctx) {
  final m = ctx.merged;
  final child = skinsFirstChildOrEmpty(ctx.rawChildren, ctx.buildChild);
  final shape = skinsNorm((m['shape'] ?? m['clip_shape'] ?? 'rect').toString());
  final clipBehavior = skinsParseClip(m['clip_behavior']);
  final radius = coerceDouble(m['radius']) ?? ctx.style.radiusMd;

  if (shape == 'oval' || shape == 'circle') {
    return ClipOval(clipBehavior: clipBehavior, child: child);
  }

  return ClipRRect(
    clipBehavior: clipBehavior,
    borderRadius: radius > 0
        ? BorderRadius.circular(radius)
        : BorderRadius.zero,
    child: child,
  );
}

// Effects module builder
Widget? buildSkinsEffectsModule(String module, SkinsContext ctx) {
  return switch (module) {
    'effects' => _buildEffects(ctx),
    'particles' => _buildParticles(ctx),
    'canvas' => _buildCanvas(ctx),
    _ => null,
  };
}

Widget _buildEffects(SkinsContext ctx) {
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

Widget _buildParticles(SkinsContext ctx) {
  final particleField = buildParticleFieldControl(
    '${ctx.controlId}::particles',
    ctx.merged,
    ctx.registerInvokeHandler,
    ctx.unregisterInvokeHandler,
    ctx.sendEvent,
  );

  final shouldOverlay = ctx.merged['overlay'] != false;
  if (!shouldOverlay) return particleField;

  final child = skinsFirstChildOrEmpty(ctx.rawChildren, ctx.buildChild);
  return Stack(
    fit: StackFit.expand,
    children: [
      child,
      IgnorePointer(child: particleField),
    ],
  );
}

Widget _buildCanvas(SkinsContext ctx) {
  return buildCanvasControl(
    '${ctx.controlId}::canvas',
    ctx.merged,
    ctx.registerInvokeHandler,
    ctx.unregisterInvokeHandler,
    ctx.sendEvent,
  );
}

// Motion module builder
Widget? buildSkinsMotionModule(String module, SkinsContext ctx) {
  return switch (module) {
    'animation' || 'motion' => _buildAnimation(ctx),
    'transition' => _buildTransition(ctx),
    _ => null,
  };
}

Widget _buildAnimation(SkinsContext ctx) {
  return buildMotionControl(ctx.merged, ctx.rawChildren, ctx.buildChild);
}

Widget _buildTransition(SkinsContext ctx) {
  final m = ctx.merged;
  final durationMs = (coerceOptionalInt(m['duration_ms']) ?? 220).clamp(
    1,
    120000,
  );
  final curve = skinsParseCurve(m['curve']);
  final preset = skinsNorm((m['preset'] ?? 'fade').toString());

  Widget Function(Widget, Animation<double>) builder;
  switch (preset) {
    case 'scale':
      builder = (child, anim) => ScaleTransition(scale: anim, child: child);
    case 'slide':
      builder = (child, anim) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.08, 0),
          end: Offset.zero,
        ).animate(anim),
        child: FadeTransition(opacity: anim, child: child),
      );
    case 'slide_up':
      builder = (child, anim) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).animate(anim),
        child: FadeTransition(opacity: anim, child: child),
      );
    case 'slide_down':
      builder = (child, anim) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.08),
          end: Offset.zero,
        ).animate(anim),
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
      child: skinsFirstChildOrEmpty(ctx.rawChildren, ctx.buildChild),
    ),
  );
}

// Helper function to create ButterflyUIThemeTokens from SkinsTokens
ButterflyUIThemeTokens _createThemeTokensFromTokens(SkinsTokens tokens) {
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

// Helper function to convert SkinsTokens to CandyTokens for button control
CandyTokens _createCandyTokensFromSkins(SkinsTokens skinsTokens) {
  return CandyTokens({
    'background': skinsTokens.color('background')?.value ?? '#FAFAFA',
    'surface': skinsTokens.color('surface')?.value ?? '#F5F5F5',
    'surfaceAlt': skinsTokens.color('surfaceAlt')?.value ?? '#EEEEEE',
    'text': skinsTokens.color('text')?.value ?? '#1A1A1A',
    'mutedText': skinsTokens.color('mutedText')?.value ?? '#666666',
    'border': skinsTokens.color('border')?.value ?? '#E0E0E0',
    'primary': skinsTokens.color('primary')?.value ?? '#6366F1',
    'secondary': skinsTokens.color('secondary')?.value ?? '#8B5CF6',
    'success': skinsTokens.color('success')?.value ?? '#22C55E',
    'warning': skinsTokens.color('warning')?.value ?? '#F59E0B',
    'info': skinsTokens.color('info')?.value ?? '#3B82F6',
    'error': skinsTokens.color('error')?.value ?? '#EF4444',
    'button': {
      'variant': 'elevated',
      'radius': skinsTokens.number('radius', 'md') ?? 12,
      'padding': {
        'horizontal': skinsTokens.number('spacing', 'md') ?? 12,
        'vertical': skinsTokens.number('spacing', 'sm') ?? 8,
      },
    },
    'radius': {
      'sm': skinsTokens.number('radius', 'sm') ?? 6,
      'md': skinsTokens.number('radius', 'md') ?? 12,
      'lg': skinsTokens.number('radius', 'lg') ?? 18,
    },
    'spacing': {
      'xs': skinsTokens.number('spacing', 'xs') ?? 4,
      'sm': skinsTokens.number('spacing', 'sm') ?? 8,
      'md': skinsTokens.number('spacing', 'md') ?? 12,
      'lg': skinsTokens.number('spacing', 'lg') ?? 20,
    },
  });
}

// ============================================================================
// Registry Registration
// ============================================================================

/// Registers all skins controls into the global registry
void registerSkinsControls(ButterflyUIControlRegistry registry) {
  // Register skins_scope - the scope wrapper widget
  registry.register('skins_scope', _buildSkinsScope);

  // Note: Individual skins controls (skins_row, skins_column, etc.)
  // are handled via the main 'skins' case in control_renderer.dart
  // which calls buildSkinsControl directly
}

// Scope builder
Widget _buildSkinsScope(
  ButterflyUIControlContext context,
  Map<String, Object?> control,
) {
  final props = context.propsOf(control);

  // Extract scope properties
  final tokensMap = props['tokens'];
  final skinType = props['skin']?.toString() ?? 'default';

  // Get tokens based on skin type
  SkinsTokens tokens;
  if (tokensMap is Map) {
    tokens = SkinsTokens.fromMap(coerceObjectMap(tokensMap));
  } else {
    // Use preset skin tokens based on type
    tokens = switch (skinType.toLowerCase()) {
      'shadow' => SkinsTokens.shadowSkin(),
      'fire' => SkinsTokens.fireSkin(),
      'earth' => SkinsTokens.earthSkin(),
      'gaming' || 'cyber' => SkinsTokens.gamingSkin(),
      _ => SkinsTokens.defaultSkin(),
    };
  }

  final theme = tokens.buildTheme();

  // Get the child
  final childMaps = context.childMapsOf(control);
  final childWidget = childMaps.isNotEmpty
      ? context.buildChild(childMaps.first)
      : const SizedBox.shrink();

  // Build theme data
  final brightness = props['brightness'] as String? ?? 'light';
  final isDark = brightness.toLowerCase().startsWith('dark');

  return _SkinsScopeWidget(
    tokens: tokens,
    isDark: isDark,
    child: AnimatedTheme(
      data: theme,
      duration: tokens.transitionSpeed,
      curve: tokens.motionCurve,
      child: childWidget,
    ),
  );
}

class _SkinsScopeWidget extends InheritedWidget {
  final SkinsTokens tokens;
  final bool isDark;

  const _SkinsScopeWidget({
    required this.tokens,
    required this.isDark,
    required super.child,
  });

  static _SkinsScopeWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_SkinsScopeWidget>();
  }

  @override
  bool updateShouldNotify(_SkinsScopeWidget oldWidget) {
    return tokens != oldWidget.tokens || isDark != oldWidget.isDark;
  }
}
