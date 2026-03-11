import 'package:flutter/material.dart';

class ButterflyUIThemeTokens extends ThemeExtension<ButterflyUIThemeTokens> {
  final Color background;
  final Color surface;
  final Color surfaceAlt;
  final Color text;
  final Color mutedText;
  final Color border;
  final Color primary;
  final Color secondary;
  final Color success;
  final Color warning;
  final Color info;
  final Color error;
  final String? fontFamily;
  final String? monoFamily;
  final double radiusSm;
  final double radiusMd;
  final double radiusLg;
  final double radiusXl;
  final double spacingXs;
  final double spacingSm;
  final double spacingMd;
  final double spacingLg;
  final double spacingXl;
  final double borderWidthSm;
  final double borderWidthMd;
  final double borderWidthLg;
  final double shadowSm;
  final double shadowMd;
  final double shadowLg;
  final int motionFastMs;
  final int motionNormalMs;
  final int motionSlowMs;
  final double zDepthBase;
  final double zDepthOverlay;
  final double zDepthModal;
  final Color overlayScrim;
  final Color focusRing;
  final double glassBlur;
  final Map<String, Map<String, Object?>> typeRoles;

  const ButterflyUIThemeTokens({
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.text,
    required this.mutedText,
    required this.border,
    required this.primary,
    required this.secondary,
    required this.success,
    required this.warning,
    required this.info,
    required this.error,
    required this.fontFamily,
    required this.monoFamily,
    required this.radiusSm,
    required this.radiusMd,
    required this.radiusLg,
    required this.radiusXl,
    required this.spacingXs,
    required this.spacingSm,
    required this.spacingMd,
    required this.spacingLg,
    required this.spacingXl,
    required this.borderWidthSm,
    required this.borderWidthMd,
    required this.borderWidthLg,
    required this.shadowSm,
    required this.shadowMd,
    required this.shadowLg,
    required this.motionFastMs,
    required this.motionNormalMs,
    required this.motionSlowMs,
    required this.zDepthBase,
    required this.zDepthOverlay,
    required this.zDepthModal,
    required this.overlayScrim,
    required this.focusRing,
    required this.glassBlur,
    required this.typeRoles,
  });

  @override
  ButterflyUIThemeTokens copyWith({
    Color? background,
    Color? surface,
    Color? surfaceAlt,
    Color? text,
    Color? mutedText,
    Color? border,
    Color? primary,
    Color? secondary,
    Color? success,
    Color? warning,
    Color? info,
    Color? error,
    String? fontFamily,
    String? monoFamily,
    double? radiusSm,
    double? radiusMd,
    double? radiusLg,
    double? radiusXl,
    double? spacingXs,
    double? spacingSm,
    double? spacingMd,
    double? spacingLg,
    double? spacingXl,
    double? borderWidthSm,
    double? borderWidthMd,
    double? borderWidthLg,
    double? shadowSm,
    double? shadowMd,
    double? shadowLg,
    int? motionFastMs,
    int? motionNormalMs,
    int? motionSlowMs,
    double? zDepthBase,
    double? zDepthOverlay,
    double? zDepthModal,
    Color? overlayScrim,
    Color? focusRing,
    double? glassBlur,
    Map<String, Map<String, Object?>>? typeRoles,
  }) {
    return ButterflyUIThemeTokens(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      text: text ?? this.text,
      mutedText: mutedText ?? this.mutedText,
      border: border ?? this.border,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      error: error ?? this.error,
      fontFamily: fontFamily ?? this.fontFamily,
      monoFamily: monoFamily ?? this.monoFamily,
      radiusSm: radiusSm ?? this.radiusSm,
      radiusMd: radiusMd ?? this.radiusMd,
      radiusLg: radiusLg ?? this.radiusLg,
      radiusXl: radiusXl ?? this.radiusXl,
      spacingXs: spacingXs ?? this.spacingXs,
      spacingSm: spacingSm ?? this.spacingSm,
      spacingMd: spacingMd ?? this.spacingMd,
      spacingLg: spacingLg ?? this.spacingLg,
      spacingXl: spacingXl ?? this.spacingXl,
      borderWidthSm: borderWidthSm ?? this.borderWidthSm,
      borderWidthMd: borderWidthMd ?? this.borderWidthMd,
      borderWidthLg: borderWidthLg ?? this.borderWidthLg,
      shadowSm: shadowSm ?? this.shadowSm,
      shadowMd: shadowMd ?? this.shadowMd,
      shadowLg: shadowLg ?? this.shadowLg,
      motionFastMs: motionFastMs ?? this.motionFastMs,
      motionNormalMs: motionNormalMs ?? this.motionNormalMs,
      motionSlowMs: motionSlowMs ?? this.motionSlowMs,
      zDepthBase: zDepthBase ?? this.zDepthBase,
      zDepthOverlay: zDepthOverlay ?? this.zDepthOverlay,
      zDepthModal: zDepthModal ?? this.zDepthModal,
      overlayScrim: overlayScrim ?? this.overlayScrim,
      focusRing: focusRing ?? this.focusRing,
      glassBlur: glassBlur ?? this.glassBlur,
      typeRoles: typeRoles ?? this.typeRoles,
    );
  }

  @override
  ButterflyUIThemeTokens lerp(
    ThemeExtension<ButterflyUIThemeTokens>? other,
    double t,
  ) {
    if (other is! ButterflyUIThemeTokens) return this;
    Color lerpColor(Color a, Color b) => Color.lerp(a, b, t) ?? a;
    double lerpDouble(double a, double b) => a + (b - a) * t;
    int lerpInt(int a, int b) => (a + (b - a) * t).round();
    return ButterflyUIThemeTokens(
      background: lerpColor(background, other.background),
      surface: lerpColor(surface, other.surface),
      surfaceAlt: lerpColor(surfaceAlt, other.surfaceAlt),
      text: lerpColor(text, other.text),
      mutedText: lerpColor(mutedText, other.mutedText),
      border: lerpColor(border, other.border),
      primary: lerpColor(primary, other.primary),
      secondary: lerpColor(secondary, other.secondary),
      success: lerpColor(success, other.success),
      warning: lerpColor(warning, other.warning),
      info: lerpColor(info, other.info),
      error: lerpColor(error, other.error),
      fontFamily: t < 0.5 ? fontFamily : other.fontFamily,
      monoFamily: t < 0.5 ? monoFamily : other.monoFamily,
      radiusSm: lerpDouble(radiusSm, other.radiusSm),
      radiusMd: lerpDouble(radiusMd, other.radiusMd),
      radiusLg: lerpDouble(radiusLg, other.radiusLg),
      radiusXl: lerpDouble(radiusXl, other.radiusXl),
      spacingXs: lerpDouble(spacingXs, other.spacingXs),
      spacingSm: lerpDouble(spacingSm, other.spacingSm),
      spacingMd: lerpDouble(spacingMd, other.spacingMd),
      spacingLg: lerpDouble(spacingLg, other.spacingLg),
      spacingXl: lerpDouble(spacingXl, other.spacingXl),
      borderWidthSm: lerpDouble(borderWidthSm, other.borderWidthSm),
      borderWidthMd: lerpDouble(borderWidthMd, other.borderWidthMd),
      borderWidthLg: lerpDouble(borderWidthLg, other.borderWidthLg),
      shadowSm: lerpDouble(shadowSm, other.shadowSm),
      shadowMd: lerpDouble(shadowMd, other.shadowMd),
      shadowLg: lerpDouble(shadowLg, other.shadowLg),
      motionFastMs: lerpInt(motionFastMs, other.motionFastMs),
      motionNormalMs: lerpInt(motionNormalMs, other.motionNormalMs),
      motionSlowMs: lerpInt(motionSlowMs, other.motionSlowMs),
      zDepthBase: lerpDouble(zDepthBase, other.zDepthBase),
      zDepthOverlay: lerpDouble(zDepthOverlay, other.zDepthOverlay),
      zDepthModal: lerpDouble(zDepthModal, other.zDepthModal),
      overlayScrim: lerpColor(overlayScrim, other.overlayScrim),
      focusRing: lerpColor(focusRing, other.focusRing),
      glassBlur: lerpDouble(glassBlur, other.glassBlur),
      typeRoles: t < 0.5 ? typeRoles : other.typeRoles,
    );
  }

  Map<String, Object?> typeRole(String? name, {String? fallback}) {
    final requested = normalizeButterflyTypeRoleName(name);
    if (requested != null && typeRoles.containsKey(requested)) {
      return typeRoles[requested] ?? const <String, Object?>{};
    }
    final fallbackName = normalizeButterflyTypeRoleName(fallback);
    if (fallbackName != null && typeRoles.containsKey(fallbackName)) {
      return typeRoles[fallbackName] ?? const <String, Object?>{};
    }
    return const <String, Object?>{};
  }
}

String? normalizeButterflyTypeRoleName(Object? value) {
  final raw = value?.toString().trim();
  if (raw == null || raw.isEmpty) return null;
  final normalized = raw
      .toLowerCase()
      .replaceAll('-', '_')
      .replaceAll(' ', '_')
      .replaceAll(':', '_');
  switch (normalized) {
    case 'displayhero':
    case 'hero':
      return 'display_hero';
    case 'display':
    case 'headline':
    case 'heading':
    case 'title':
    case 'body':
    case 'body_lg':
    case 'caption':
    case 'helper':
    case 'button_label':
    case 'input':
    case 'nav':
    case 'overline':
      return normalized;
    default:
      return normalized;
  }
}
