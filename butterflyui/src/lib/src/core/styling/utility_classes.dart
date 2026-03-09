import '../control_utils.dart';
import 'theme.dart';

Map<String, Object?> applyUtilityClassStyles(
  Map<String, Object?> props, {
  double viewportWidth = 1280,
  double viewportHeight = 800,
}) {
  final tokens = _coerceUtilityTokens(props['class_name'] ?? props['classes']);
  if (tokens.isEmpty) return props;

  final style = _coerceMap(props['style']);
  final baseStates = _coerceMap(style['states']);
  final resolved = _UtilityClassResolver.resolve(
    tokens,
    viewportWidth: viewportWidth,
    viewportHeight: viewportHeight,
  );

  if (resolved.style.isEmpty &&
      resolved.stateStyles.isEmpty &&
      resolved.modifiers.isEmpty &&
      resolved.effects.isEmpty &&
      resolved.backgroundLayers.isEmpty) {
    return props;
  }

  final merged = <String, Object?>{...props};
  final mergedClasses = <String>{
    ..._coerceUtilityTokens(props['classes']),
    ...tokens.map((token) => token.replaceAll(':', '_').trim()).where(
      (token) => token.isNotEmpty,
    ),
  }.toList(growable: false);

  final mergedStyle = <String, Object?>{};
  mergedStyle.addAll(resolved.style);
  mergedStyle.addAll(style);

  if (resolved.stateStyles.isNotEmpty || baseStates.isNotEmpty) {
    final mergedStates = <String, Object?>{};
    for (final entry in resolved.stateStyles.entries) {
      final existing = _coerceMap(baseStates[entry.key]);
      mergedStates[entry.key] = StylingTokens.mergeMaps(entry.value, existing);
    }
    for (final entry in baseStates.entries) {
      mergedStates.putIfAbsent(entry.key, () => entry.value);
    }
    mergedStyle['states'] = mergedStates;
  }

  if (mergedStyle.isNotEmpty) {
    merged['style'] = mergedStyle;
  }

  if (resolved.modifiers.isNotEmpty) {
    final existing = _coerceList(merged['modifiers']);
    merged['modifiers'] = <Object?>[...resolved.modifiers, ...existing];
  }
  if (resolved.effects.isNotEmpty) {
    final existing = _coerceList(merged['effects']);
    merged['effects'] = <Object?>[...resolved.effects, ...existing];
  }
  if (resolved.backgroundLayers.isNotEmpty) {
    final existing = _coerceList(merged['background_layers']);
    merged['background_layers'] = <Object?>[
      ...resolved.backgroundLayers,
      ...existing,
    ];
  }
  if (resolved.motion != null && merged['motion'] == null) {
    merged['motion'] = resolved.motion;
  }
  if (mergedClasses.isNotEmpty) {
    merged['classes'] = mergedClasses;
  }
  return merged;
}

List<String> _coerceUtilityTokens(Object? value) {
  if (value == null) return const <String>[];
  if (value is String) {
    return value
        .split(RegExp(r'[\s,]+'))
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList(growable: false);
  }
  if (value is List) {
    return value
        .where((item) => item != null)
        .map((item) => item.toString().trim())
        .where((part) => part.isNotEmpty)
        .toList(growable: false);
  }
  return <String>[value.toString().trim()];
}

Map<String, Object?> _coerceMap(Object? value) {
  if (value is Map) return coerceObjectMap(value);
  return <String, Object?>{};
}

List<Object?> _coerceList(Object? value) {
  if (value is List) return value.cast<Object?>();
  return const <Object?>[];
}

class _UtilityClassResolution {
  final Map<String, Object?> style;
  final Map<String, Map<String, Object?>> stateStyles;
  final List<Object?> modifiers;
  final List<Object?> effects;
  final List<Object?> backgroundLayers;
  final Object? motion;

  const _UtilityClassResolution({
    required this.style,
    required this.stateStyles,
    required this.modifiers,
    required this.effects,
    required this.backgroundLayers,
    required this.motion,
  });
}

class _UtilityClassResolver {
  static _UtilityClassResolution resolve(
    List<String> tokens, {
    required double viewportWidth,
    required double viewportHeight,
  }) {
    final style = <String, Object?>{};
    final states = <String, Map<String, Object?>>{};
    final modifiers = <Object?>[];
    final effects = <Object?>[];
    final backgroundLayers = <Object?>[];
    final gradientParts = <String, _GradientParts>{};
    Object? motion;

    Map<String, Object?> targetForState(String? state) {
      if (state == null) return style;
      return states.putIfAbsent(state, () => <String, Object?>{});
    }

    void addModifier(Object value) {
      modifiers.add(value);
    }

    void addStateModifier(String state, Map<String, Object?> value) {
      final existing = modifiers.whereType<Map<String, Object?>>().firstWhere(
        (item) => _normalize(item['type']?.toString() ?? '') == 'state_modifiers',
        orElse: () => <String, Object?>{},
      );
      if (existing.isEmpty) {
        modifiers.add(<String, Object?>{'type': 'state_modifiers', state: <Object?>[value]});
        return;
      }
      final list = _coerceList(existing[state]);
      existing[state] = <Object?>[...list, value];
    }

    for (final rawToken in tokens) {
      var token = rawToken.trim();
      if (token.isEmpty) continue;
      String? state;
      final segments = token
          .split(':')
          .map((part) => part.trim())
          .where((part) => part.isNotEmpty)
          .toList(growable: false);
      if (segments.length > 1) {
        final consumed = <int>{};
        for (var index = 0; index < segments.length - 1; index += 1) {
          final prefix = _normalize(segments[index]);
          final minWidth = _breakpointMinWidth(prefix);
          if (minWidth != null) {
            if (viewportWidth < minWidth) {
              token = '';
              break;
            }
            consumed.add(index);
            continue;
          }
          if (_isStatePrefix(prefix)) {
            state = prefix == 'focus' ? 'focused' : prefix;
            consumed.add(index);
          }
        }
        if (token.isNotEmpty) {
          token = segments
              .asMap()
              .entries
              .where((entry) => !consumed.contains(entry.key))
              .map((entry) => entry.value)
              .join(':');
        }
      }
      if (token.isEmpty) continue;

      final target = targetForState(state);
      final normalized = _normalize(token);

      if (_applyGradientToken(normalized, target, gradientParts, state)) {
        continue;
      }
      if (_applyColorToken(normalized, target)) {
        continue;
      }
      if (_applySpacingToken(normalized, target)) {
        continue;
      }
      if (_applyLayoutToken(
        normalized,
        target,
        viewportWidth: viewportWidth,
        viewportHeight: viewportHeight,
      )) {
        continue;
      }
      if (_applyRadiusToken(normalized, target)) {
        continue;
      }
      if (_applyBorderToken(normalized, target)) {
        continue;
      }
      if (_applyShadowToken(normalized, target)) {
        continue;
      }
      if (_applyBlurToken(normalized, target)) {
        continue;
      }
      if (_applyTypographyToken(normalized, target)) {
        continue;
      }
      if (normalized == 'transition_fast') {
        motion ??= <String, Object?>{'duration_ms': 140, 'curve': 'ease_out'};
        addModifier('transition');
        continue;
      }
      if (normalized == 'transition' || normalized == 'transition_normal') {
        motion ??= <String, Object?>{'duration_ms': 220, 'curve': 'ease_out'};
        addModifier('transition');
        continue;
      }
      if (normalized == 'transition_slow') {
        motion ??= <String, Object?>{'duration_ms': 320, 'curve': 'ease_in_out'};
        addModifier('transition');
        continue;
      }
      if (normalized == 'animate_fade_in') {
        effects.add(<String, Object?>{'type': 'transition', 'transition_type': 'fade'});
        continue;
      }
      if (normalized == 'animate_scale_in') {
        effects.add(<String, Object?>{'type': 'transition', 'transition_type': 'scale'});
        continue;
      }
      if (normalized == 'effect_glow') {
        effects.add(<String, Object?>{'type': 'glow'});
        continue;
      }
      if (normalized == 'bg_effect_matrix_rain') {
        backgroundLayers.add(<String, Object?>{'type': 'matrix_rain', 'position': 'background'});
        continue;
      }
      if (normalized == 'bg_effect_galaxy') {
        backgroundLayers.add(<String, Object?>{'type': 'galaxy', 'position': 'background'});
        continue;
      }
      if (normalized == 'bg_effect_rainstorm') {
        backgroundLayers.add(<String, Object?>{'type': 'rainstorm', 'position': 'background'});
        continue;
      }
      final scaleMatch = RegExp(r'^scale_(\d+)$').firstMatch(normalized);
      if (scaleMatch != null && state != null) {
        final scale = (int.parse(scaleMatch.group(1)!) / 100.0);
        if (state == 'hover') {
          addStateModifier('hover', <String, Object?>{
            'type': 'hover_lift',
            'scale': scale,
            'distance': 0,
          });
        } else if (state == 'pressed') {
          addStateModifier('pressed', <String, Object?>{
            'type': 'press_scale',
            'scale': scale,
          });
        }
        continue;
      }
    }

    for (final entry in gradientParts.entries) {
      final gradient = entry.value.toGradient();
      if (gradient == null) continue;
      if (entry.key == 'root') {
        style['gradient'] = gradient;
      } else {
        states.putIfAbsent(entry.key, () => <String, Object?>{})['gradient'] =
            gradient;
      }
    }

    return _UtilityClassResolution(
      style: style,
      stateStyles: states,
      modifiers: modifiers,
      effects: effects,
      backgroundLayers: backgroundLayers,
      motion: motion,
    );
  }

  static bool _applyColorToken(String token, Map<String, Object?> target) {
    if (token.startsWith('bg_')) {
      final color = _resolveUtilityColor(token.substring(3));
      if (color != null) {
        target['bgcolor'] = color;
        return true;
      }
    }
    if (token.startsWith('text_')) {
      final color = _resolveUtilityColor(token.substring(5));
      if (color != null) {
        target['text_color'] = color;
        target['foreground'] = color;
        return true;
      }
    }
    if (token.startsWith('border_')) {
      final color = _resolveUtilityColor(token.substring(7));
      if (color != null) {
        target['border_color'] = color;
        return true;
      }
    }
    if (token == 'text_white') {
      target['text_color'] = '#ffffffff';
      target['foreground'] = '#ffffffff';
      return true;
    }
    return false;
  }

  static bool _applySpacingToken(String token, Map<String, Object?> target) {
    if (token == 'mx_auto') {
      target['alignment'] = 'center';
      return true;
    }
    final all = RegExp(r'^(p|m|gap)_(.+)$').firstMatch(token);
    if (all != null) {
      final amount = _spacingValue(all.group(2)!);
      if (amount == null) return false;
      switch (all.group(1)) {
        case 'p':
          target['padding'] = amount;
          return true;
        case 'm':
          target['margin'] = amount;
          return true;
        case 'gap':
          target['spacing'] = amount;
          return true;
      }
    }

    final axis = RegExp(r'^(px|py|pt|pr|pb|pl)_(.+)$').firstMatch(token);
    if (axis != null) {
      final amount = _spacingValue(axis.group(2)!);
      if (amount == null) return false;
      final existing = _coerceMap(target['padding']);
      switch (axis.group(1)) {
        case 'px':
          existing['left'] = amount;
          existing['right'] = amount;
          break;
        case 'py':
          existing['top'] = amount;
          existing['bottom'] = amount;
          break;
        case 'pt':
          existing['top'] = amount;
          break;
        case 'pr':
          existing['right'] = amount;
          break;
        case 'pb':
          existing['bottom'] = amount;
          break;
        case 'pl':
          existing['left'] = amount;
          break;
      }
      target['padding'] = existing;
      return true;
    }

    final marginAxis = RegExp(r'^(mx|my|mt|mr|mb|ml)_(.+)$').firstMatch(token);
    if (marginAxis == null) return false;
    final amount = _spacingValue(marginAxis.group(2)!);
    if (amount == null) return false;
    final existing = _coerceMap(target['margin']);
    switch (marginAxis.group(1)) {
      case 'mx':
        existing['left'] = amount;
        existing['right'] = amount;
        break;
      case 'my':
        existing['top'] = amount;
        existing['bottom'] = amount;
        break;
      case 'mt':
        existing['top'] = amount;
        break;
      case 'mr':
        existing['right'] = amount;
        break;
      case 'mb':
        existing['bottom'] = amount;
        break;
      case 'ml':
        existing['left'] = amount;
        break;
    }
    target['margin'] = existing;
    return true;
  }

  static bool _applyLayoutToken(
    String token,
    Map<String, Object?> target, {
    required double viewportWidth,
    required double viewportHeight,
  }) {
    final maxWidth = _maxWidthValue(token, viewportWidth);
    if (maxWidth != null) {
      target['max_width'] = maxWidth;
      return true;
    }
    switch (token) {
      case 'w_full':
      case 'w_screen':
        target['width'] = double.infinity;
        return true;
      case 'h_full':
      case 'h_screen':
        target['height'] = viewportHeight;
        return true;
      case 'min_h_screen':
        target['min_height'] = viewportHeight;
        return true;
      case 'relative':
      case 'absolute':
      case 'fixed':
        target['position'] = token;
        return true;
      case 'overflow_hidden':
      case 'overflow_clip':
      case 'overflow_visible':
        target['overflow'] = token.substring('overflow_'.length);
        return true;
      case 'z_0':
      case 'z_10':
      case 'z_20':
      case 'z_30':
      case 'z_40':
      case 'z_50':
        target['z_index'] = double.parse(token.substring(2));
        return true;
    }

    final inset = RegExp(r'^inset_(.+)$').firstMatch(token);
    if (inset != null) {
      final amount = _spacingValue(inset.group(1)!);
      if (amount == null) return false;
      target['top'] = amount;
      target['right'] = amount;
      target['bottom'] = amount;
      target['left'] = amount;
      return true;
    }

    final edge = RegExp(r'^(top|right|bottom|left)_(.+)$').firstMatch(token);
    if (edge != null) {
      final amount = _spacingValue(edge.group(2)!);
      if (amount == null) return false;
      target[edge.group(1)!] = amount;
      return true;
    }
    return false;
  }

  static bool _applyRadiusToken(String token, Map<String, Object?> target) {
    final radii = <String, Object?>{
      'rounded': 8.0,
      'rounded_sm': 6.0,
      'rounded_md': 10.0,
      'rounded_lg': 14.0,
      'rounded_xl': 18.0,
      'rounded_2xl': 24.0,
      'rounded_3xl': 32.0,
      'rounded_full': 999.0,
    };
    final value = radii[token];
    if (value == null) return false;
    target['radius'] = value;
    return true;
  }

  static bool _applyBorderToken(String token, Map<String, Object?> target) {
    if (token == 'border') {
      target['border_width'] = 1.0;
      return true;
    }
    final match = RegExp(r'^border_(\d+)$').firstMatch(token);
    if (match == null) return false;
    target['border_width'] = double.parse(match.group(1)!);
    return true;
  }

  static bool _applyShadowToken(String token, Map<String, Object?> target) {
    final shadow = switch (token) {
      'shadow' || 'shadow_md' => <String, Object?>{
        'color': '#33000000',
        'blur': 16.0,
        'spread': 0.0,
        'offset': <double>[0, 8],
      },
      'shadow_lg' => <String, Object?>{
        'color': '#3d000000',
        'blur': 22.0,
        'spread': 0.0,
        'offset': <double>[0, 12],
      },
      'shadow_xl' => <String, Object?>{
        'color': '#47000000',
        'blur': 30.0,
        'spread': 0.0,
        'offset': <double>[0, 16],
      },
      'shadow_2xl' => <String, Object?>{
        'color': '#52000000',
        'blur': 42.0,
        'spread': 2.0,
        'offset': <double>[0, 20],
      },
      _ => null,
    };
    if (shadow == null) return false;
    target['shadow'] = shadow;
    return true;
  }

  static bool _applyBlurToken(String token, Map<String, Object?> target) {
    final blur = switch (token) {
      'backdrop_blur_sm' => 8.0,
      'backdrop_blur_md' => 14.0,
      'backdrop_blur_lg' => 22.0,
      'backdrop_blur_xl' => 28.0,
      _ => null,
    };
    if (blur == null) return false;
    target['blur'] = blur;
    return true;
  }

  static bool _applyTypographyToken(String token, Map<String, Object?> target) {
    final fontSize = switch (token) {
      'text_xs' => 12.0,
      'text_sm' => 14.0,
      'text_base' => 16.0,
      'text_lg' => 18.0,
      'text_xl' => 20.0,
      'text_2xl' => 24.0,
      'text_3xl' => 30.0,
      'text_4xl' => 36.0,
      'text_5xl' => 48.0,
      'text_6xl' => 60.0,
      'text_7xl' => 72.0,
      'text_8xl' => 96.0,
      'text_display' => 84.0,
      'text_headline' => 52.0,
      'text_body' => 18.0,
      'text_caption' => 13.0,
      _ => null,
    };
    if (fontSize != null) {
      target['font_size'] = fontSize;
      return true;
    }
    final weight = switch (token) {
      'font_medium' => 'w500',
      'font_normal' => 'w400',
      'font_semibold' => 'w600',
      'font_bold' => 'w700',
      'font_black' => 'w900',
      _ => null,
    };
    if (weight != null) {
      target['font_weight'] = weight;
      return true;
    }
    final tracking = switch (token) {
      'tracking_tighter' => -1.6,
      'tracking_tight' => -0.9,
      'tracking_normal' => 0.0,
      'tracking_wide' => 0.8,
      'tracking_wider' => 1.4,
      _ => null,
    };
    if (tracking != null) {
      target['letter_spacing'] = tracking;
      return true;
    }
    final leading = switch (token) {
      'leading_none' => 1.0,
      'leading_tight' => 1.1,
      'leading_snug' => 1.2,
      'leading_normal' => 1.35,
      'leading_relaxed' => 1.55,
      _ => null,
    };
    if (leading != null) {
      target['line_height'] = leading;
      return true;
    }
    return false;
  }

  static bool _applyGradientToken(
    String token,
    Map<String, Object?> target,
    Map<String, _GradientParts> gradients,
    String? state,
  ) {
    final gradientKey = state ?? 'root';
    final gradient = gradients.putIfAbsent(gradientKey, _GradientParts.new);
    if (token == 'bg_gradient_to_r') {
      gradient.begin = 'center_left';
      gradient.end = 'center_right';
      return true;
    }
    if (token == 'bg_gradient_to_l') {
      gradient.begin = 'center_right';
      gradient.end = 'center_left';
      return true;
    }
    if (token == 'bg_gradient_to_b') {
      gradient.begin = 'top_center';
      gradient.end = 'bottom_center';
      return true;
    }
    if (token == 'bg_gradient_to_t') {
      gradient.begin = 'bottom_center';
      gradient.end = 'top_center';
      return true;
    }
    if (token.startsWith('from_')) {
      final color = _resolveUtilityColor(token.substring(5));
      if (color != null) {
        gradient.from = color;
        return true;
      }
    }
    if (token.startsWith('via_')) {
      final color = _resolveUtilityColor(token.substring(4));
      if (color != null) {
        gradient.via = color;
        return true;
      }
    }
    if (token.startsWith('to_')) {
      final color = _resolveUtilityColor(token.substring(3));
      if (color != null) {
        gradient.to = color;
        return true;
      }
    }
    return false;
  }
}

class _GradientParts {
  String? begin;
  String? end;
  String? from;
  String? via;
  String? to;

  Map<String, Object?>? toGradient() {
    final colors = <String>[
      if (from != null) from!,
      if (via != null) via!,
      if (to != null) to!,
    ];
    if (colors.length < 2) return null;
    return <String, Object?>{
      'type': 'linear',
      'begin': begin ?? 'center_left',
      'end': end ?? 'center_right',
      'colors': colors,
    };
  }
}

String _normalize(String token) {
  return token.trim().toLowerCase().replaceAll('-', '_').replaceAll(' ', '_');
}

bool _isStatePrefix(String token) {
  return switch (token) {
    'hover' || 'pressed' || 'focus' || 'focused' || 'disabled' => true,
    _ => false,
  };
}

double? _breakpointMinWidth(String token) {
  return switch (token) {
    'sm' => 640,
    'md' => 768,
    'lg' => 1024,
    'xl' => 1280,
    '2xl' || 'xxl' => 1536,
    _ => null,
  };
}

double? _maxWidthValue(String token, double viewportWidth) {
  return switch (token) {
    'max_w_none' => double.infinity,
    'max_w_sm' => 384.0,
    'max_w_md' => 448.0,
    'max_w_lg' => 512.0,
    'max_w_xl' => 576.0,
    'max_w_2xl' => 672.0,
    'max_w_3xl' => 768.0,
    'max_w_4xl' => 896.0,
    'max_w_5xl' => 1024.0,
    'max_w_6xl' => 1152.0,
    'max_w_7xl' => 1280.0,
    'max_w_screen' => viewportWidth,
    _ => null,
  };
}

double? _spacingValue(String token) {
  final normalized = token.trim().replaceAll('_', '.');
  final scale = <String, double>{
    '0': 0,
    '0.5': 2,
    '1': 4,
    '1.5': 6,
    '2': 8,
    '2.5': 10,
    '3': 12,
    '3.5': 14,
    '4': 16,
    '5': 20,
    '6': 24,
    '8': 32,
    '10': 40,
    '12': 48,
    '16': 64,
  };
  return scale[normalized];
}

String? _resolveUtilityColor(String token) {
  final normalized = _normalize(token);
  final slash = normalized.indexOf('/');
  var base = normalized;
  double? opacity;
  if (slash >= 0) {
    base = normalized.substring(0, slash);
    final opacityToken = normalized.substring(slash + 1);
    final parsed = double.tryParse(opacityToken);
    if (parsed != null) {
      opacity = (parsed.clamp(0, 100)) / 100.0;
    }
  }

  final color = _utilityPalette[base];
  if (color == null) return null;
  if (opacity == null) return color;
  final hex = color.replaceFirst('#', '');
  if (hex.length != 8) return color;
  final alpha = (opacity * 255).round().toRadixString(16).padLeft(2, '0');
  return '#$alpha${hex.substring(2)}';
}

const Map<String, String> _utilityPalette = <String, String>{
  'transparent': '#00000000',
  'black': '#ff000000',
  'white': '#ffffffff',
  'zinc_50': '#fffafafa',
  'zinc_100': '#fff4f4f5',
  'zinc_200': '#ffe4e4e7',
  'zinc_300': '#ffd4d4d8',
  'zinc_400': '#ffa1a1aa',
  'zinc_500': '#ff71717a',
  'zinc_600': '#ff52525b',
  'zinc_700': '#ff3f3f46',
  'zinc_800': '#ff27272a',
  'zinc_900': '#ff18181b',
  'zinc_950': '#ff09090b',
  'slate_900': '#ff0f172a',
  'slate_950': '#ff020617',
  'purple_500': '#ffa855f7',
  'purple_600': '#ff9333ea',
  'purple_700': '#ff7e22ce',
  'blue_500': '#ff3b82f6',
  'blue_600': '#ff2563eb',
  'cyan_500': '#ff06b6d4',
  'emerald_400': '#ff34d399',
  'emerald_500': '#ff10b981',
  'red_500': '#ffef4444',
  'amber_400': '#fffbbf24',
};
