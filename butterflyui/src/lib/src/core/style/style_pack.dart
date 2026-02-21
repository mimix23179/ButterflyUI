import 'package:flutter/material.dart';

import '../candy/theme.dart';
import '../../core/control_registry.dart';

typedef StyleControlOverride = Widget Function(
  ButterflyUIControlContext context,
  Map<String, Object?> control,
  ButterflyUIControlBuilder buildDefault,
);

class StylePack {
  final String name;
  final Map<String, Object?> defaultTokens;
  final Map<String, Object?> componentStyles;
  final Map<String, Object?> motionPack;
  final Map<String, Object?> effectPresets;
  final ThemeData Function(ThemeData base, CandyTokens tokens)? themeBuilder;
  final Map<String, StyleControlOverride> overrides;
  final Widget Function(BuildContext context, CandyTokens tokens)? background;
  final Widget Function(BuildContext context, CandyTokens tokens, Widget child)?
  wrapRoot;

  const StylePack({
    required this.name,
    this.defaultTokens = const {},
    this.componentStyles = const {},
    this.motionPack = const {},
    this.effectPresets = const {},
    this.themeBuilder,
    this.overrides = const {},
    this.background,
    this.wrapRoot,
  });

  ThemeData applyTheme(CandyTokens tokens) {
    final base = tokens.buildTheme();
    return themeBuilder?.call(base, tokens) ?? base;
  }

  CandyTokens buildTokens(Map<String, Object?> overrides) {
    final merged = CandyTokens.mergeMaps(defaultTokens, overrides);
    return CandyTokens(merged);
  }
}

class StylePackRegistry {
  final Map<String, StylePack> _packs;
  final StylePack defaultPack;

  StylePackRegistry({
    required Map<String, StylePack> packs,
    required this.defaultPack,
  }) : _packs = packs.map(
          (key, value) => MapEntry(_normalize(key), value),
        );

  static String _normalize(String value) {
    return value.trim().toLowerCase().replaceAll(' ', '_');
  }

  StylePack resolve(String? name) {
    if (name == null || name.trim().isEmpty) return defaultPack;
    return _packs[_normalize(name)] ?? defaultPack;
  }

  bool contains(String? name) {
    if (name == null || name.trim().isEmpty) return false;
    return _packs.containsKey(_normalize(name));
  }

  void register(StylePack pack, {bool replace = true}) {
    final key = _normalize(pack.name);
    if (!replace && _packs.containsKey(key)) return;
    _packs[key] = pack;
  }

  void registerAll(Iterable<StylePack> packs, {bool replace = true}) {
    for (final pack in packs) {
      register(pack, replace: replace);
    }
  }

  CandyTokens buildTokens(String? name, Map<String, Object?> overrides) {
    final pack = resolve(name);
    return pack.buildTokens(overrides);
  }
}
