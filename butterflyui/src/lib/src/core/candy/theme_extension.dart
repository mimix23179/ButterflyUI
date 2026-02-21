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
  final double spacingXs;
  final double spacingSm;
  final double spacingMd;
  final double spacingLg;
  final double glassBlur;

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
    required this.spacingXs,
    required this.spacingSm,
    required this.spacingMd,
    required this.spacingLg,
    required this.glassBlur,
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
    double? spacingXs,
    double? spacingSm,
    double? spacingMd,
    double? spacingLg,
    double? glassBlur,
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
      spacingXs: spacingXs ?? this.spacingXs,
      spacingSm: spacingSm ?? this.spacingSm,
      spacingMd: spacingMd ?? this.spacingMd,
      spacingLg: spacingLg ?? this.spacingLg,
      glassBlur: glassBlur ?? this.glassBlur,
    );
  }

  @override
  ButterflyUIThemeTokens lerp(ThemeExtension<ButterflyUIThemeTokens>? other, double t) {
    if (other is! ButterflyUIThemeTokens) return this;
    Color lerpColor(Color a, Color b) => Color.lerp(a, b, t) ?? a;
    double lerpDouble(double a, double b) => a + (b - a) * t;
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
      spacingXs: lerpDouble(spacingXs, other.spacingXs),
      spacingSm: lerpDouble(spacingSm, other.spacingSm),
      spacingMd: lerpDouble(spacingMd, other.spacingMd),
      spacingLg: lerpDouble(spacingLg, other.spacingLg),
      glassBlur: lerpDouble(glassBlur, other.glassBlur),
    );
  }
}
