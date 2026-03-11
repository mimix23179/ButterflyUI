import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

import '../control_utils.dart';
import 'theme_extension.dart';

class StylingTokens {
  Map<String, Object?> _tokens;

  StylingTokens([Map<String, Object?>? tokens])
    : _tokens = tokens ?? <String, Object?>{};

  factory StylingTokens.fromMap(Map<String, Object?> tokens) {
    return StylingTokens(Map<String, Object?>.from(tokens));
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
    final spacing = section('spacing');
    final borders = section('borders');
    final shadows = section('shadows');
    final motion = section('motion');
    final depth = section('depth');
    final overlay = section('overlay');
    final button = section('button');
    final card = section('card');

    final seed = tokenColor('primary') ?? const Color(0xff4f46e5);
    final brightness = _resolveBrightness() ?? Brightness.light;
    var scheme = ColorScheme.fromSeed(seedColor: seed, brightness: brightness);

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
    final resolvedBodySize = bodySize ?? 14.0;
    final resolvedTitleSize = titleSize ?? 20.0;
    final resolvedLabelSize = labelSize ?? 12.0;
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
        radiusXl: coerceDouble(radii['xl']) ?? 28,
        spacingXs: coerceDouble(spacing['xs']) ?? 4,
        spacingSm: coerceDouble(spacing['sm']) ?? 8,
        spacingMd: coerceDouble(spacing['md']) ?? 12,
        spacingLg: coerceDouble(spacing['lg']) ?? 20,
        spacingXl: coerceDouble(spacing['xl']) ?? 32,
        borderWidthSm: coerceDouble(borders['sm']) ?? 1,
        borderWidthMd: coerceDouble(borders['md']) ?? 1.5,
        borderWidthLg: coerceDouble(borders['lg']) ?? 2,
        shadowSm: coerceDouble(shadows['sm']) ?? 8,
        shadowMd: coerceDouble(shadows['md']) ?? 18,
        shadowLg: coerceDouble(shadows['lg']) ?? 30,
        motionFastMs: (coerceDouble(motion['fast_ms']) ?? 90).round(),
        motionNormalMs: (coerceDouble(motion['normal_ms']) ?? 180).round(),
        motionSlowMs: (coerceDouble(motion['slow_ms']) ?? 320).round(),
        zDepthBase: coerceDouble(depth['base']) ?? 0,
        zDepthOverlay: coerceDouble(depth['overlay']) ?? 20,
        zDepthModal: coerceDouble(depth['modal']) ?? 40,
        overlayScrim:
            tokenColor('overlay_scrim') ??
            coerceColor(overlay['scrim']) ??
            Colors.black.withValues(alpha: 0.48),
        focusRing:
            tokenColor('focus_ring') ??
            coerceColor(overlay['focus_ring']) ??
            (tokenColor('primary') ?? scheme.primary).withValues(alpha: 0.64),
        glassBlur: coerceDouble(section('effects')['glass_blur']) ?? 18,
        typeRoles: _resolveTypeRoles(
          typography: typography,
          textColor: textColor ?? scheme.onSurface,
          mutedTextColor: tokenColor('muted_text') ?? scheme.onSurfaceVariant,
          bodySize: resolvedBodySize,
          titleSize: resolvedTitleSize,
          labelSize: resolvedLabelSize,
          fontFamily: fontFamily,
        ),
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

Map<String, Map<String, Object?>> _resolveTypeRoles({
  required Map<String, Object?> typography,
  required Color textColor,
  required Color mutedTextColor,
  required double bodySize,
  required double titleSize,
  required double labelSize,
  required String? fontFamily,
}) {
  Map<String, Object?> role(
    String name, {
    double? fontSize,
    String? fontWeight,
    double? lineHeight,
    double? letterSpacing,
    Color? color,
    bool? uppercase,
  }) {
    return <String, Object?>{
      if (fontFamily != null && fontFamily.isNotEmpty) 'font_family': fontFamily,
      if (fontSize != null) 'font_size': fontSize,
      if (fontWeight != null) 'font_weight': fontWeight,
      if (lineHeight != null) 'line_height': lineHeight,
      if (letterSpacing != null) 'letter_spacing': letterSpacing,
      if (color != null) 'color': color,
      if (uppercase == true) 'text_transform': 'uppercase',
    };
  }

  final defaults = <String, Map<String, Object?>>{
    'display_hero': role(
      'display_hero',
      fontSize: coerceDouble(typography['display_hero_size']) ?? (titleSize * 4.9),
      fontWeight: typography['display_hero_weight']?.toString() ?? 'w700',
      lineHeight: 0.92,
      letterSpacing: -3.2,
      color: textColor,
    ),
    'display': role(
      'display',
      fontSize: coerceDouble(typography['display_size']) ?? (titleSize * 3.3),
      fontWeight: typography['display_weight']?.toString() ?? 'w700',
      lineHeight: 0.96,
      letterSpacing: -2.2,
      color: textColor,
    ),
    'headline': role(
      'headline',
      fontSize: coerceDouble(typography['headline_size']) ?? (titleSize * 2.2),
      fontWeight: typography['headline_weight']?.toString() ?? 'w700',
      lineHeight: 1.0,
      letterSpacing: -1.2,
      color: textColor,
    ),
    'heading': role(
      'heading',
      fontSize: coerceDouble(typography['heading_size']) ?? (titleSize * 1.5),
      fontWeight: typography['heading_weight']?.toString() ?? 'w600',
      lineHeight: 1.05,
      letterSpacing: -0.8,
      color: textColor,
    ),
    'title': role(
      'title',
      fontSize: titleSize,
      fontWeight: typography['title_weight']?.toString() ?? 'w600',
      lineHeight: 1.12,
      color: textColor,
    ),
    'body_lg': role(
      'body_lg',
      fontSize: coerceDouble(typography['body_lg_size']) ?? (bodySize + 2),
      fontWeight: typography['body_lg_weight']?.toString() ?? 'w400',
      lineHeight: 1.5,
      color: textColor,
    ),
    'body': role(
      'body',
      fontSize: bodySize,
      fontWeight: typography['body_weight']?.toString() ?? 'w400',
      lineHeight: 1.45,
      color: textColor,
    ),
    'caption': role(
      'caption',
      fontSize: labelSize,
      fontWeight: typography['caption_weight']?.toString() ?? 'w500',
      lineHeight: 1.3,
      color: mutedTextColor,
    ),
    'helper': role(
      'helper',
      fontSize: coerceDouble(typography['helper_size']) ?? labelSize,
      fontWeight: typography['helper_weight']?.toString() ?? 'w400',
      lineHeight: 1.35,
      color: mutedTextColor,
    ),
    'button_label': role(
      'button_label',
      fontSize: coerceDouble(typography['button_label_size']) ?? (labelSize + 4),
      fontWeight: typography['button_label_weight']?.toString() ?? 'w600',
      lineHeight: 1.0,
      letterSpacing: 0.1,
      color: textColor,
    ),
    'input': role(
      'input',
      fontSize: coerceDouble(typography['input_size']) ?? bodySize,
      fontWeight: typography['input_weight']?.toString() ?? 'w400',
      lineHeight: 1.35,
      color: textColor,
    ),
    'nav': role(
      'nav',
      fontSize: coerceDouble(typography['nav_size']) ?? bodySize,
      fontWeight: typography['nav_weight']?.toString() ?? 'w500',
      lineHeight: 1.1,
      color: textColor,
    ),
    'overline': role(
      'overline',
      fontSize: coerceDouble(typography['overline_size']) ?? (labelSize - 1),
      fontWeight: typography['overline_weight']?.toString() ?? 'w600',
      lineHeight: 1.2,
      letterSpacing: 1.4,
      color: mutedTextColor,
      uppercase: true,
    ),
  };

  final rawRoles = typography['roles'];
  if (rawRoles is! Map) return defaults;
  final merged = <String, Map<String, Object?>>{
    for (final entry in defaults.entries)
      entry.key: Map<String, Object?>.from(entry.value),
  };
  for (final entry in rawRoles.entries) {
    final name = normalizeButterflyTypeRoleName(entry.key);
    if (name == null) continue;
    final override = entry.value is Map
        ? coerceObjectMap(entry.value as Map)
        : <String, Object?>{};
    final current = merged[name] ?? <String, Object?>{};
    merged[name] = StylingTokens.mergeMaps(current, override);
  }
  return merged;
}
