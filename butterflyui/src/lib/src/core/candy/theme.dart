import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

import '../../core/control_utils.dart';
import 'theme_extension.dart';

class CandyTokens {
  Map<String, Object?> _tokens;

  CandyTokens([Map<String, Object?>? tokens])
    : _tokens = tokens ?? <String, Object?>{};

  factory CandyTokens.fromMap(Map<String, Object?> tokens) {
    return CandyTokens(Map<String, Object?>.from(tokens));
  }

  bool get isEmpty => _tokens.isEmpty;

  void update(Map<String, Object?> tokens) {
    _tokens = tokens;
  }

  void merge(Map<String, Object?> tokens) {
    _tokens = mergeMaps(_tokens, tokens);
  }

  Map<String, Object?> toJson() {
    return Map<String, Object?>.from(_tokens);
  }

  Map<String, Object?> section(String key) {
    final raw = _tokens[key];
    return raw is Map ? coerceObjectMap(raw) : <String, Object?>{};
  }

  String? string(String sectionKey, String key) {
    final value = section(sectionKey)[key];
    return value?.toString();
  }

  double? number(String sectionKey, String key) {
    return coerceDouble(section(sectionKey)[key]);
  }

  EdgeInsets? padding(String sectionKey, String key) {
    return coercePadding(section(sectionKey)[key]);
  }

  Color? color(String key) {
    return coerceColor(section('colors')[key]);
  }

  String? themeString(String key) {
    final value = section('theme')[key];
    return value?.toString();
  }

  static Map<String, Object?> mergeMaps(
    Map<String, Object?> base,
    Map<String, Object?> override,
  ) {
    if (override.isEmpty) return Map<String, Object?>.from(base);
    final merged = Map<String, Object?>.from(base);
    override.forEach((key, value) {
      if (value is Map && merged[key] is Map) {
        merged[key] = mergeMaps(
          coerceObjectMap(merged[key] as Map),
          coerceObjectMap(value),
        );
      } else {
        merged[key] = value;
      }
    });
    return merged;
  }

  ThemeData buildTheme() {
    Color? tokenColor(String key) => color(key);

    final typography = section('typography');
    final radii = section('radii');
    final button = section('button');
    final card = section('card');

    final seed = tokenColor('primary') ?? const Color(0xff4f46e5);
    final brightness = _resolveBrightness() ?? Brightness.light;
    var scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    );

    final background = tokenColor('background');
    final surface = tokenColor('surface');
    final surfaceAlt = tokenColor('surface_alt');
    final onSurface = tokenColor('on_surface') ?? tokenColor('text');
    final textColor = tokenColor('text');
    final onPrimary = tokenColor('on_primary') ?? scheme.onPrimary;
    final secondary = tokenColor('secondary');
    final onSecondary = tokenColor('on_secondary') ?? scheme.onSecondary;
    final error = tokenColor('error') ?? scheme.error;
    final onError = tokenColor('on_error') ?? scheme.onError;
    final harmonize =
        section('theme')['harmonize'] == true ||
        section('colors')['harmonize'] == true;
    final harmonizeWith =
        tokenColor('harmonize_with') ?? tokenColor('primary') ?? scheme.primary;

    Color? harmonized(Color? color) {
      if (!harmonize || color == null) return color;
      return Color(Blend.harmonize(color.value, harmonizeWith.value));
    }

    scheme = scheme.copyWith(
      primary: tokenColor('primary') ?? scheme.primary,
      onPrimary: onPrimary,
      secondary: harmonized(secondary ?? scheme.secondary),
      onSecondary: onSecondary,
      background: harmonized(background ?? scheme.background),
      onBackground: textColor ?? scheme.onBackground,
      surface: harmonized(surface ?? scheme.surface),
      onSurface: onSurface ?? scheme.onSurface,
      error: harmonized(error) ?? error,
      onError: onError,
    );

    TextTheme textTheme = ThemeData(useMaterial3: true).textTheme;
    final fontFamily = typography['font_family']?.toString();
    if (fontFamily != null && fontFamily.isNotEmpty) {
      textTheme = textTheme.apply(fontFamily: fontFamily);
    }
    if (textColor != null) {
      textTheme = textTheme.apply(
        bodyColor: textColor,
        displayColor: textColor,
      );
    }
    final bodySize = coerceDouble(typography['body_size']);
    final titleSize = coerceDouble(typography['title_size']);
    final labelSize = coerceDouble(typography['label_size']);
    if (bodySize != null) {
      textTheme = textTheme.copyWith(
        bodyMedium: textTheme.bodyMedium?.copyWith(fontSize: bodySize),
      );
    }
    if (titleSize != null) {
      textTheme = textTheme.copyWith(
        titleLarge: textTheme.titleLarge?.copyWith(fontSize: titleSize),
      );
    }
    if (labelSize != null) {
      textTheme = textTheme.copyWith(
        labelLarge: textTheme.labelLarge?.copyWith(fontSize: labelSize),
      );
    }

    final buttonRadius =
        coerceDouble(button['radius']) ?? coerceDouble(radii['md']);
    final buttonPadding = coercePadding(button['padding']);
    ButtonStyle? buttonStyle;
    if (buttonRadius != null || buttonPadding != null) {
      buttonStyle = ButtonStyle(
        shape: buttonRadius == null
            ? null
            : MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(buttonRadius),
                ),
              ),
        padding: buttonPadding == null
            ? null
            : MaterialStateProperty.all(buttonPadding),
      );
    }

    final cardRadius =
        coerceDouble(card['radius']) ?? coerceDouble(radii['md']);
    final cardColor = tokenColor('card') ?? tokenColor('surface');
    final cardTheme = CardThemeData(
      color: cardColor,
      shape: cardRadius == null
          ? null
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(cardRadius),
            ),
    );

    var theme = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: textTheme,
    );
    theme = theme.copyWith(
      scaffoldBackgroundColor: background ?? scheme.background,
      appBarTheme: AppBarTheme(
        backgroundColor: surface ?? scheme.surface,
        foregroundColor: onSurface ?? scheme.onSurface,
      ),
      cardTheme: cardTheme,
    );

    if (buttonStyle != null) {
      theme = theme.copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(style: buttonStyle),
        textButtonTheme: TextButtonThemeData(style: buttonStyle),
        outlinedButtonTheme: OutlinedButtonThemeData(style: buttonStyle),
      );
    }
    final extensions = <ThemeExtension<dynamic>>[
      ButterflyUIThemeTokens(
        background: background ?? scheme.background,
        surface: surface ?? scheme.surface,
        surfaceAlt: surfaceAlt ?? scheme.surfaceVariant,
        text: textColor ?? scheme.onSurface,
        mutedText: tokenColor('muted_text') ?? scheme.onSurfaceVariant,
        border: tokenColor('border') ?? scheme.outlineVariant,
        primary: scheme.primary,
        secondary: scheme.secondary,
        success: tokenColor('success') ?? const Color(0xff22c55e),
        warning: tokenColor('warning') ?? const Color(0xfff59e0b),
        info: tokenColor('info') ?? const Color(0xff3b82f6),
        error: error,
        fontFamily: fontFamily,
        monoFamily: typography['mono_family']?.toString(),
        radiusSm: coerceDouble(radii['sm']) ?? 6,
        radiusMd: coerceDouble(radii['md']) ?? 12,
        radiusLg: coerceDouble(radii['lg']) ?? 18,
        spacingXs: coerceDouble(section('spacing')['xs']) ?? 4,
        spacingSm: coerceDouble(section('spacing')['sm']) ?? 8,
        spacingMd: coerceDouble(section('spacing')['md']) ?? 12,
        spacingLg: coerceDouble(section('spacing')['lg']) ?? 20,
        glassBlur: coerceDouble(section('effects')['glass_blur']) ?? 18,
      ),
    ];
    return theme.copyWith(extensions: extensions);
  }

  Brightness? _resolveBrightness() {
    final value =
        themeString('brightness') ??
        themeString('mode') ??
        string('colors', 'brightness');
    if (value == null) return null;
    final lowered = value.toLowerCase();
    if (lowered.startsWith('dark')) return Brightness.dark;
    if (lowered.startsWith('light')) return Brightness.light;
    return null;
  }
}
