import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart' as neu;
import 'package:google_fonts/google_fonts.dart';
import 'package:nes_ui/nes_ui.dart' as nes;
import 'package:xterm/xterm.dart' as xterm;

import '../candy/theme.dart';
import '../../core/control_registry.dart';
import '../../core/control_utils.dart';
import 'style_pack.dart';

final StylePackRegistry stylePackRegistry = StylePackRegistry(
  defaultPack: _basePack,
  packs: {
    _basePack.name: _basePack,
    _terminalPack.name: _terminalPack,
    _windsurfPack.name: _windsurfPack,
    _retroPack.name: _retroPack,
    _scifiPack.name: _scifiPack,
    _comfyPack.name: _comfyPack,
    _noirPack.name: _noirPack,
    _minimalPack.name: _minimalPack,
    _glassPack.name: _glassPack,
    _solarizedPack.name: _solarizedPack,
    _vaporPack.name: _vaporPack,
    _neonPack.name: _neonPack,
  },
);

const Map<String, Object?> _baseTokens = {
  'theme': {'brightness': 'light'},
  'colors': {
    'background': '#f8fafc',
    'surface': '#ffffff',
    'surface_alt': '#f1f5f9',
    'text': '#0f172a',
    'muted_text': '#64748b',
    'border': '#e2e8f0',
    'primary': '#4f46e5',
    'on_primary': '#ffffff',
    'secondary': '#06b6d4',
    'on_secondary': '#ffffff',
    'success': '#22c55e',
    'warning': '#f59e0b',
    'info': '#3b82f6',
    'error': '#ef4444',
  },
  'typography': {
    'font_family': 'Manrope',
    'mono_family': 'JetBrains Mono',
    'body_size': 14,
    'title_size': 20,
    'label_size': 12,
    'weight': 'w500',
  },
  'radii': {'sm': 6, 'md': 12, 'lg': 20},
  'spacing': {'xs': 4, 'sm': 8, 'md': 12, 'lg': 20},
  'button': {
    'radius': 12,
    'padding': [10, 16],
  },
  'card': {'radius': 14},
  'effects': {'glass_blur': 18},
};

const Map<String, Object?> _baseComponentStyles = {
  'button': {
    'slots': {
      'surface': {'radius': 12, 'border_width': 0, 'elevation': 0},
      'label': {'font_weight': 'w600'},
    },
    'variants': {
      'intent': {
        'primary': {
          'slots': {
            'surface': {'bgcolor': r'$primary'},
            'label': {'color': r'$on_primary'},
          },
        },
        'neutral': {
          'slots': {
            'surface': {'bgcolor': r'$surface_alt', 'border_color': r'$border'},
            'label': {'color': r'$text'},
          },
        },
        'danger': {
          'slots': {
            'surface': {'bgcolor': r'$error'},
            'label': {'color': r'$on_primary'},
          },
        },
      },
      'size': {
        'sm': {'slots': {'surface': {'padding': [8, 12]}}},
        'md': {'slots': {'surface': {'padding': [10, 16]}}},
        'lg': {'slots': {'surface': {'padding': [14, 20]}}},
      },
    },
    'states': {
      'hover': {'slots': {'surface': {'elevation': 6}}},
      'pressed': {'slots': {'surface': {'elevation': 2}}},
      'disabled': {'slots': {'surface': {'opacity': 0.55}}},
    },
    'modifiers': ['hover_lift', 'press_scale', 'focus_ring'],
    'motion': 'os_pop',
  },
  'surface': {
    'slots': {
      'surface': {'radius': 14, 'border_color': r'$border', 'border_width': 1},
    },
    'modifiers': ['elevation'],
  },
  'window_frame': {
    'slots': {'surface': {'radius': 16, 'border_width': 1}},
    'modifiers': ['glass', 'elevation'],
    'motion': 'os_pop',
  },
};

const Map<String, Object?> _baseMotionPack = {
  'hover': {'duration_ms': 90, 'curve': 'ease_out_cubic'},
  'press': {'duration_ms': 90, 'curve': 'ease_out_cubic', 'end_scale': 0.97},
  'focus': {'duration_ms': 150, 'curve': 'ease_out'},
  'os_pop': {
    'duration_ms': 220,
    'curve': 'os_pop',
    'begin_scale': 0.96,
    'end_scale': 1.0,
    'begin_opacity': 0.0,
    'end_opacity': 1.0,
    'begin_offset': [0, 8],
    'end_offset': [0, 0],
    'overshoot': 1.02,
  },
  'slide': {'duration_ms': 220, 'curve': 'slide', 'begin_offset': [0, 8]},
  'disappear': {
    'duration_ms': 150,
    'curve': 'disappear',
    'begin_scale': 1.0,
    'end_scale': 0.96,
    'begin_opacity': 1.0,
    'end_opacity': 0.0,
  },
  'route_enter': {'duration_ms': 220, 'curve': 'os_pop', 'begin_scale': 0.96},
  'route_exit': {'duration_ms': 150, 'curve': 'disappear', 'end_scale': 0.96},
};

const Map<String, Object?> _baseEffectPresets = {
  'default_click': {'type': 'click_burst', 'color': r'$primary', 'radius': 56},
  'glass_hover': {'type': 'glass', 'blur': 20, 'tint': '#14ffffff'},
  'neon_press': {'type': 'press_scale', 'scale': 0.96},
};

const Map<String, Object?> _terminalTokens = {
  'theme': {'brightness': 'dark'},
  'colors': {
    'background': '#050a06',
    'surface': '#0a1410',
    'surface_alt': '#0c1a14',
    'text': '#d1ffd6',
    'muted_text': '#6dfc8f',
    'border': '#0cff8a',
    'primary': '#00ff7a',
    'on_primary': '#001008',
    'secondary': '#00c16e',
    'on_secondary': '#001008',
    'success': '#00ff7a',
    'warning': '#ffd166',
    'info': '#4cc9f0',
    'error': '#ff5c8a',
  },
  'typography': {
    'font_family': 'JetBrains Mono',
    'mono_family': 'JetBrains Mono',
    'body_size': 13,
    'title_size': 18,
    'label_size': 11,
    'weight': 'w500',
  },
  'radii': {'sm': 2, 'md': 4, 'lg': 6},
  'spacing': {'xs': 4, 'sm': 6, 'md': 10, 'lg': 16},
  'button': {
    'radius': 4,
    'padding': [8, 12],
  },
  'card': {'radius': 6},
  'effects': {'glass_blur': 8},
};

const Map<String, Object?> _windsurfTokens = {
  'theme': {'brightness': 'dark'},
  'colors': {
    'background': '#0b1118',
    'surface': '#131b24',
    'surface_alt': '#1b2633',
    'text': '#e2e8f0',
    'muted_text': '#94a3b8',
    'border': '#273344',
    'primary': '#38bdf8',
    'on_primary': '#0b1118',
    'secondary': '#22d3ee',
    'on_secondary': '#0b1118',
    'success': '#34d399',
    'warning': '#fbbf24',
    'info': '#60a5fa',
    'error': '#f87171',
  },
  'typography': {
    'font_family': 'Space Grotesk',
    'mono_family': 'JetBrains Mono',
    'body_size': 14,
    'title_size': 20,
    'label_size': 12,
    'weight': 'w500',
  },
  'radii': {'sm': 6, 'md': 10, 'lg': 14},
  'spacing': {'xs': 4, 'sm': 8, 'md': 12, 'lg': 20},
  'button': {
    'radius': 10,
    'padding': [10, 16],
  },
  'card': {'radius': 12},
};

const Map<String, Object?> _retroTokens = {
  'theme': {'brightness': 'light'},
  'colors': {
    'background': '#ead4aa',
    'surface': '#f2e7c9',
    'surface_alt': '#e0c89b',
    'text': '#3b2f2f',
    'muted_text': '#6d4c41',
    'border': '#8b5e3c',
    'primary': '#d97706',
    'on_primary': '#2b1a0f',
    'secondary': '#b45309',
    'on_secondary': '#2b1a0f',
    'success': '#65a30d',
    'warning': '#f59e0b',
    'info': '#0ea5e9',
    'error': '#dc2626',
  },
  'typography': {
    'font_family': 'Press Start 2P',
    'mono_family': 'Press Start 2P',
    'body_size': 12,
    'title_size': 16,
    'label_size': 10,
    'weight': 'w600',
  },
  'radii': {'sm': 0, 'md': 0, 'lg': 0},
  'spacing': {'xs': 4, 'sm': 6, 'md': 10, 'lg': 16},
  'button': {
    'radius': 0,
    'padding': [8, 12],
  },
  'card': {'radius': 0},
};

const Map<String, Object?> _scifiTokens = {
  'theme': {'brightness': 'dark'},
  'colors': {
    'background': '#050a14',
    'surface': '#0d1726',
    'surface_alt': '#101f34',
    'text': '#c7f9ff',
    'muted_text': '#7bdff2',
    'border': '#00d1ff',
    'primary': '#00f5ff',
    'on_primary': '#001018',
    'secondary': '#7c3aed',
    'on_secondary': '#f5f3ff',
    'success': '#2dd4bf',
    'warning': '#f59e0b',
    'info': '#60a5fa',
    'error': '#f43f5e',
  },
  'typography': {
    'font_family': 'Orbitron',
    'mono_family': 'JetBrains Mono',
    'body_size': 13,
    'title_size': 20,
    'label_size': 11,
    'weight': 'w600',
  },
  'radii': {'sm': 4, 'md': 8, 'lg': 12},
  'spacing': {'xs': 4, 'sm': 8, 'md': 12, 'lg': 20},
  'button': {
    'radius': 8,
    'padding': [10, 14],
  },
  'card': {'radius': 10},
};

const Map<String, Object?> _comfyTokens = {
  'theme': {'brightness': 'light'},
  'colors': {
    'background': '#fff7f9',
    'surface': '#ffffff',
    'surface_alt': '#fbe8ee',
    'text': '#5c4b51',
    'muted_text': '#90727c',
    'border': '#f0cdd4',
    'primary': '#ff9aa2',
    'on_primary': '#4a2228',
    'secondary': '#b5ead7',
    'on_secondary': '#24433b',
    'success': '#86efac',
    'warning': '#fbcfe8',
    'info': '#93c5fd',
    'error': '#fb7185',
  },
  'typography': {
    'font_family': 'Nunito',
    'mono_family': 'JetBrains Mono',
    'body_size': 15,
    'title_size': 22,
    'label_size': 12,
    'weight': 'w500',
  },
  'radii': {'sm': 12, 'md': 20, 'lg': 28},
  'spacing': {'xs': 4, 'sm': 8, 'md': 14, 'lg': 24},
  'button': {
    'radius': 24,
    'padding': [12, 18],
  },
  'card': {'radius': 26},
};

const Map<String, Object?> _noirTokens = {
  'theme': {'brightness': 'dark'},
  'colors': {
    'background': '#0a0a0a',
    'surface': '#111111',
    'surface_alt': '#1a1a1a',
    'text': '#f5f5f5',
    'muted_text': '#a3a3a3',
    'border': '#2a2a2a',
    'primary': '#ffffff',
    'on_primary': '#0a0a0a',
    'secondary': '#8b8b8b',
    'on_secondary': '#0a0a0a',
    'success': '#a3e635',
    'warning': '#fbbf24',
    'info': '#60a5fa',
    'error': '#f87171',
  },
  'typography': {
    'font_family': 'Playfair Display',
    'mono_family': 'JetBrains Mono',
    'body_size': 14,
    'title_size': 22,
    'label_size': 12,
    'weight': 'w600',
  },
  'radii': {'sm': 4, 'md': 8, 'lg': 12},
  'spacing': {'xs': 4, 'sm': 8, 'md': 12, 'lg': 20},
  'button': {
    'radius': 6,
    'padding': [10, 16],
  },
  'card': {'radius': 10},
};

const Map<String, Object?> _minimalTokens = {
  'theme': {'brightness': 'light'},
  'colors': {
    'background': '#f5f5f5',
    'surface': '#ffffff',
    'surface_alt': '#f1f1f1',
    'text': '#111111',
    'muted_text': '#6b7280',
    'border': '#e5e7eb',
    'primary': '#111111',
    'on_primary': '#ffffff',
    'secondary': '#6b7280',
    'on_secondary': '#ffffff',
    'success': '#22c55e',
    'warning': '#f59e0b',
    'info': '#0ea5e9',
    'error': '#ef4444',
  },
  'typography': {
    'font_family': 'IBM Plex Sans',
    'mono_family': 'IBM Plex Mono',
    'body_size': 14,
    'title_size': 20,
    'label_size': 12,
    'weight': 'w500',
  },
  'radii': {'sm': 4, 'md': 6, 'lg': 8},
  'spacing': {'xs': 4, 'sm': 8, 'md': 12, 'lg': 20},
  'button': {
    'radius': 6,
    'padding': [10, 16],
  },
  'card': {'radius': 8},
};

const Map<String, Object?> _glassTokens = {
  'theme': {'brightness': 'dark'},
  'colors': {
    'background': '#0b1020',
    'surface': '#162033',
    'surface_alt': '#1d2b45',
    'text': '#e2e8f0',
    'muted_text': '#94a3b8',
    'border': '#30415f',
    'primary': '#7dd3fc',
    'on_primary': '#0b1020',
    'secondary': '#a5b4fc',
    'on_secondary': '#0b1020',
    'success': '#34d399',
    'warning': '#fbbf24',
    'info': '#60a5fa',
    'error': '#f87171',
  },
  'typography': {
    'font_family': 'DM Sans',
    'mono_family': 'JetBrains Mono',
    'body_size': 14,
    'title_size': 20,
    'label_size': 12,
    'weight': 'w500',
  },
  'radii': {'sm': 10, 'md': 16, 'lg': 24},
  'spacing': {'xs': 4, 'sm': 8, 'md': 12, 'lg': 20},
  'button': {
    'radius': 16,
    'padding': [10, 16],
  },
  'card': {'radius': 18},
  'effects': {'glass_blur': 22},
};

const Map<String, Object?> _solarizedTokens = {
  'theme': {'brightness': 'dark'},
  'colors': {
    'background': '#002b36',
    'surface': '#073642',
    'surface_alt': '#0f3b46',
    'text': '#839496',
    'muted_text': '#586e75',
    'border': '#0f3b46',
    'primary': '#268bd2',
    'on_primary': '#002b36',
    'secondary': '#2aa198',
    'on_secondary': '#002b36',
    'success': '#859900',
    'warning': '#b58900',
    'info': '#268bd2',
    'error': '#dc322f',
  },
  'typography': {
    'font_family': 'Source Code Pro',
    'mono_family': 'Source Code Pro',
    'body_size': 13,
    'title_size': 18,
    'label_size': 11,
    'weight': 'w500',
  },
  'radii': {'sm': 4, 'md': 8, 'lg': 12},
  'spacing': {'xs': 4, 'sm': 8, 'md': 12, 'lg': 20},
  'button': {
    'radius': 6,
    'padding': [8, 12],
  },
  'card': {'radius': 10},
};

const Map<String, Object?> _vaporTokens = {
  'theme': {'brightness': 'dark'},
  'colors': {
    'background': '#1b0b2a',
    'surface': '#2b1240',
    'surface_alt': '#3a155c',
    'text': '#fdf2ff',
    'muted_text': '#d4b3ff',
    'border': '#642b99',
    'primary': '#ff61d8',
    'on_primary': '#2b1240',
    'secondary': '#4cc9f0',
    'on_secondary': '#1b0b2a',
    'success': '#5eead4',
    'warning': '#f472b6',
    'info': '#60a5fa',
    'error': '#fb7185',
  },
  'typography': {
    'font_family': 'VT323',
    'mono_family': 'VT323',
    'body_size': 16,
    'title_size': 22,
    'label_size': 14,
    'weight': 'w500',
  },
  'radii': {'sm': 6, 'md': 10, 'lg': 14},
  'spacing': {'xs': 4, 'sm': 8, 'md': 12, 'lg': 20},
  'button': {
    'radius': 10,
    'padding': [10, 16],
  },
  'card': {'radius': 12},
};

const Map<String, Object?> _neonTokens = {
  'theme': {'brightness': 'dark'},
  'colors': {
    'background': '#05060a',
    'surface': '#0c0f16',
    'surface_alt': '#121826',
    'text': '#e6f1ff',
    'muted_text': '#8aa0c5',
    'border': '#1d2736',
    'primary': '#39ff14',
    'on_primary': '#05060a',
    'secondary': '#00e5ff',
    'on_secondary': '#05060a',
    'success': '#00ffa3',
    'warning': '#fbbf24',
    'info': '#38bdf8',
    'error': '#ff3366',
  },
  'typography': {
    'font_family': 'Rajdhani',
    'mono_family': 'JetBrains Mono',
    'body_size': 14,
    'title_size': 22,
    'label_size': 12,
    'weight': 'w600',
  },
  'radii': {'sm': 4, 'md': 8, 'lg': 12},
  'spacing': {'xs': 4, 'sm': 8, 'md': 12, 'lg': 20},
  'button': {
    'radius': 8,
    'padding': [10, 16],
  },
  'card': {'radius': 10},
};

final StylePack _basePack = StylePack(
  name: 'base',
  defaultTokens: _baseTokens,
  componentStyles: _baseComponentStyles,
  motionPack: _baseMotionPack,
  effectPresets: _baseEffectPresets,
  themeBuilder: (base, tokens) {
    final textTheme = GoogleFonts.manropeTextTheme(base.textTheme);
    return base.copyWith(textTheme: textTheme, primaryTextTheme: textTheme);
  },
  background: _softGradientBackground(const [
    Color(0xfff8fafc),
    Color(0xffe2e8f0),
    Color(0xfff8fafc),
  ]),
);

final StylePack _terminalPack = StylePack(
  name: 'terminal',
  defaultTokens: _terminalTokens,
  themeBuilder: (base, tokens) {
    final textTheme = GoogleFonts.jetBrainsMonoTextTheme(base.textTheme);
    return base.copyWith(textTheme: textTheme, primaryTextTheme: textTheme);
  },
  background: (context, tokens) {
    final bg = tokens.color('background') ?? const Color(0xff050a06);
    return _AnimatedGlowBackground(
      colors: [
        bg,
        (tokens.color('primary') ?? const Color(0xff00ff7a)).withOpacity(0.12),
        bg,
      ],
      scanlines: true,
    );
  },
  overrides: {'terminal_raw_view': _buildXtermOverride},
);

final StylePack _windsurfPack = StylePack(
  name: 'windsurf',
  defaultTokens: _windsurfTokens,
  themeBuilder: (base, tokens) {
    final textTheme = GoogleFonts.spaceGroteskTextTheme(base.textTheme);
    return base.copyWith(textTheme: textTheme, primaryTextTheme: textTheme);
  },
  background: _softGradientBackground(const [
    Color(0xff0b1118),
    Color(0xff121a24),
    Color(0xff0b1118),
  ]),
);

final StylePack _retroPack = StylePack(
  name: 'retro',
  defaultTokens: _retroTokens,
  themeBuilder: (base, tokens) {
    final textTheme = GoogleFonts.pressStart2pTextTheme(base.textTheme);
    final extensions = [...base.extensions.values, const nes.NesTheme(pixelSize: 2)];
    return base.copyWith(
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      extensions: extensions,
    );
  },
  background: (context, tokens) => _CheckerBackground(
    colorA: tokens.color('background') ?? const Color(0xffead4aa),
    colorB: tokens.color('surface_alt') ?? const Color(0xffe0c89b),
    size: 18,
  ),
  overrides: {'button': _buildRetroButton},
);

final StylePack _scifiPack = StylePack(
  name: 'scifi',
  defaultTokens: _scifiTokens,
  themeBuilder: (base, tokens) {
    final textTheme = GoogleFonts.orbitronTextTheme(base.textTheme);
    return base.copyWith(textTheme: textTheme, primaryTextTheme: textTheme);
  },
  background: (context, tokens) => _GridBackground(
    baseColor: tokens.color('background') ?? const Color(0xff050a14),
    lineColor: (tokens.color('primary') ?? const Color(0xff00f5ff)).withOpacity(
      0.12,
    ),
  ),
);

final StylePack _comfyPack = StylePack(
  name: 'comfy',
  defaultTokens: _comfyTokens,
  themeBuilder: (base, tokens) {
    final textTheme = GoogleFonts.nunitoTextTheme(base.textTheme);
    return base.copyWith(textTheme: textTheme, primaryTextTheme: textTheme);
  },
  wrapRoot: (context, tokens, child) {
    final baseColor = tokens.color('surface') ?? const Color(0xffffffff);
    return neu.NeumorphicTheme(
      theme: neu.NeumorphicThemeData(
        baseColor: baseColor,
        accentColor: tokens.color('primary') ?? baseColor,
        variantColor: tokens.color('surface_alt') ?? baseColor.withOpacity(0.9),
        depth: 4,
        intensity: 0.8,
      ),
      child: neu.NeumorphicBackground(child: child),
    );
  },
  background: _softGradientBackground(const [
    Color(0xfffff7f9),
    Color(0xfffbe8ee),
    Color(0xfffff7f9),
  ]),
  overrides: {'button': _buildComfyButton},
);

final StylePack _noirPack = StylePack(
  name: 'noir',
  defaultTokens: _noirTokens,
  themeBuilder: (base, tokens) {
    final textTheme = GoogleFonts.playfairDisplayTextTheme(base.textTheme);
    return base.copyWith(textTheme: textTheme, primaryTextTheme: textTheme);
  },
  background: _softGradientBackground(const [
    Color(0xff0a0a0a),
    Color(0xff141414),
    Color(0xff0a0a0a),
  ]),
);

final StylePack _minimalPack = StylePack(
  name: 'minimal',
  defaultTokens: _minimalTokens,
  themeBuilder: (base, tokens) {
    final textTheme = GoogleFonts.ibmPlexSansTextTheme(base.textTheme);
    return base.copyWith(textTheme: textTheme, primaryTextTheme: textTheme);
  },
  background: _softGradientBackground(const [
    Color(0xfff5f5f5),
    Color(0xffeeeeee),
    Color(0xfff5f5f5),
  ]),
);

final StylePack _glassPack = StylePack(
  name: 'glass',
  defaultTokens: _glassTokens,
  themeBuilder: (base, tokens) {
    final textTheme = GoogleFonts.dmSansTextTheme(base.textTheme);
    return base.copyWith(textTheme: textTheme, primaryTextTheme: textTheme);
  },
  background: (context, tokens) => _AnimatedGlowBackground(
    colors: [
      tokens.color('background') ?? const Color(0xff0b1020),
      (tokens.color('primary') ?? const Color(0xff7dd3fc)).withOpacity(0.12),
      tokens.color('background') ?? const Color(0xff0b1020),
    ],
    scanlines: false,
  ),
  overrides: {'container': _buildGlassContainer, 'card': _buildGlassContainer},
);

final StylePack _solarizedPack = StylePack(
  name: 'solarized',
  defaultTokens: _solarizedTokens,
  themeBuilder: (base, tokens) {
    final textTheme = GoogleFonts.sourceCodeProTextTheme(base.textTheme);
    return base.copyWith(textTheme: textTheme, primaryTextTheme: textTheme);
  },
  background: _softGradientBackground(const [
    Color(0xff002b36),
    Color(0xff073642),
    Color(0xff002b36),
  ]),
);

final StylePack _vaporPack = StylePack(
  name: 'vapor',
  defaultTokens: _vaporTokens,
  themeBuilder: (base, tokens) {
    final textTheme = GoogleFonts.vt323TextTheme(base.textTheme);
    return base.copyWith(textTheme: textTheme, primaryTextTheme: textTheme);
  },
  background: (context, tokens) => _AnimatedGlowBackground(
    colors: const [Color(0xff1b0b2a), Color(0xff3a155c), Color(0xff1b0b2a)],
    scanlines: true,
  ),
  overrides: {'button': _buildNeonButton},
);

final StylePack _neonPack = StylePack(
  name: 'neon',
  defaultTokens: _neonTokens,
  themeBuilder: (base, tokens) {
    final textTheme = GoogleFonts.rajdhaniTextTheme(base.textTheme);
    return base.copyWith(textTheme: textTheme, primaryTextTheme: textTheme);
  },
  background: (context, tokens) => _AnimatedGlowBackground(
    colors: const [Color(0xff05060a), Color(0xff0f1a2b), Color(0xff05060a)],
    scanlines: true,
  ),
  overrides: {'button': _buildNeonButton},
);

Widget _buildRetroButton(
  ConduitControlContext context,
  Map<String, Object?> control,
  ConduitControlBuilder buildDefault,
) {
  final props = context.propsOf(control);
  final label = (props['text'] ?? props['label'])?.toString() ?? 'Button';
  final enabled = props['enabled'] == null ? true : (props['enabled'] == true);
  final onPressed = _buttonHandler(context, control, enabled);
  final tokens = context.tokens;
  final bg =
      coerceColor(props['bgcolor'] ?? props['color']) ??
      tokens.color('primary') ??
      const Color(0xffd97706);
  final fg =
      coerceColor(props['text_color']) ??
      tokens.color('text') ??
      const Color(0xff2b1a0f);
  final border = tokens.color('border') ?? const Color(0xff3b2f2f);
  return Material(
    color: bg,
    child: InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(border: Border.all(color: border, width: 2)),
        child: Text(
          label,
          style: TextStyle(
            color: fg,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            fontFamily: tokens.string('typography', 'font_family'),
          ),
        ),
      ),
    ),
  );
}

Widget _buildComfyButton(
  ConduitControlContext context,
  Map<String, Object?> control,
  ConduitControlBuilder buildDefault,
) {
  final props = context.propsOf(control);
  final label = (props['text'] ?? props['label'])?.toString() ?? 'Button';
  final enabled = props['enabled'] == null ? true : (props['enabled'] == true);
  final onPressed = _buttonHandler(context, control, enabled);
  final radius = coerceDouble(props['radius']) ?? 24;
  final color = coerceColor(props['bgcolor'] ?? props['color']);
  return neu.NeumorphicButton(
    onPressed: onPressed,
    style: neu.NeumorphicStyle(
      color: color,
      depth: enabled ? 6 : -2,
      intensity: 0.85,
      boxShape: neu.NeumorphicBoxShape.roundRect(BorderRadius.circular(radius)),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
    child: Text(label),
  );
}

Widget _buildNeonButton(
  ConduitControlContext context,
  Map<String, Object?> control,
  ConduitControlBuilder buildDefault,
) {
  final props = context.propsOf(control);
  final label = (props['text'] ?? props['label'])?.toString() ?? 'Button';
  final enabled = props['enabled'] == null ? true : (props['enabled'] == true);
  final onPressed = _buttonHandler(context, control, enabled);
  final radius = coerceDouble(props['radius']) ?? 10;
  final accent = coerceColor(props['color']) ?? const Color(0xff39ff14);
  final bg = coerceColor(props['bgcolor']) ?? const Color(0xff0c0f16);
  return GlowContainer(
    glowColor: accent.withOpacity(0.8),
    borderRadius: BorderRadius.circular(radius),
    color: bg,
    child: InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(radius),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Text(
          label,
          style: TextStyle(
            color: accent,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
      ),
    ),
  ).animate().fadeIn(duration: 300.ms);
}

Widget _buildGlassContainer(
  ConduitControlContext context,
  Map<String, Object?> control,
  ConduitControlBuilder buildDefault,
) {
  final built = buildDefault(context, control);
  final props = context.propsOf(control);
  final radius = coerceDouble(props['radius']) ?? 16;
  final blur = coerceDouble(props['blur']) ?? 18;
  return _GlassSurface(radius: radius, blur: blur, child: built);
}

Widget _buildXtermOverride(
  ConduitControlContext context,
  Map<String, Object?> control,
  ConduitControlBuilder buildDefault,
) {
  final props = context.propsOf(control);
  final events = props['events'] is List
      ? List<dynamic>.from(props['events'] as List)
      : const [];
  final rawText = props['raw_text']?.toString() ?? props['text']?.toString();
  return _TerminalXtermPanel(
    events: events,
    rawText: rawText,
    fontFamily: props['font_family']?.toString(),
    fontSize: coerceDouble(props['font_size']),
    lineHeight: coerceDouble(props['line_height']),
    backgroundColor: coerceColor(props['bgcolor'] ?? props['background']),
    textColor: coerceColor(props['text_color']),
  );
}

VoidCallback? _buttonHandler(
  ConduitControlContext context,
  Map<String, Object?> control,
  bool enabled,
) {
  if (!enabled) return null;
  final id = control['id']?.toString();
  if (id == null || id.isEmpty) return null;
  final props = context.propsOf(control);
  final events = props['events'];
  if (events is List) {
    final subscribed = events
        .map((e) => e?.toString())
        .whereType<String>()
        .toSet();
    if (!subscribed.contains('click')) return null;
  }
  return () => context.sendEvent(id, 'click', {});
}

Widget Function(BuildContext, CandyTokens) _softGradientBackground(
  List<Color> colors,
) {
  return (context, tokens) => DecoratedBox(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  );
}

class _AnimatedGlowBackground extends StatefulWidget {
  final List<Color> colors;
  final bool scanlines;

  const _AnimatedGlowBackground({
    required this.colors,
    required this.scanlines,
  });

  @override
  State<_AnimatedGlowBackground> createState() =>
      _AnimatedGlowBackgroundState();
}

class _AnimatedGlowBackgroundState extends State<_AnimatedGlowBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 18),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        final begin = Alignment(
          -0.8 + 0.4 * math.sin(t * math.pi * 2),
          -0.8 + 0.4 * math.cos(t * math.pi * 2),
        );
        final end = Alignment(
          0.8 + 0.3 * math.cos(t * math.pi * 2),
          0.8 + 0.3 * math.sin(t * math.pi * 2),
        );
        return Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.colors,
                  begin: begin,
                  end: end,
                ),
              ),
            ),
            if (widget.scanlines) CustomPaint(painter: _ScanlinePainter()),
          ],
        );
      },
    );
  }
}

class _ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.15)
      ..strokeWidth = 1;
    for (double y = 0; y < size.height; y += 4) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GridBackground extends StatelessWidget {
  final Color baseColor;
  final Color lineColor;

  const _GridBackground({required this.baseColor, required this.lineColor});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GridPainter(baseColor: baseColor, lineColor: lineColor),
      child: const SizedBox.expand(),
    );
  }
}

class _CheckerBackground extends StatelessWidget {
  final Color colorA;
  final Color colorB;
  final double size;

  const _CheckerBackground({
    required this.colorA,
    required this.colorB,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CheckerPainter(colorA: colorA, colorB: colorB, size: size),
      child: const SizedBox.expand(),
    );
  }
}

class _CheckerPainter extends CustomPainter {
  final Color colorA;
  final Color colorB;
  final double size;

  const _CheckerPainter({
    required this.colorA,
    required this.colorB,
    required this.size,
  });

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final paintA = Paint()..color = colorA;
    final paintB = Paint()..color = colorB.withOpacity(0.6);
    canvas.drawRect(Offset.zero & canvasSize, paintA);
    for (double y = 0; y < canvasSize.height; y += size) {
      for (double x = 0; x < canvasSize.width; x += size) {
        final isAlt = ((x / size).floor() + (y / size).floor()) % 2 == 1;
        if (isAlt) {
          canvas.drawRect(Rect.fromLTWH(x, y, size, size), paintB);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GridPainter extends CustomPainter {
  final Color baseColor;
  final Color lineColor;

  const _GridPainter({required this.baseColor, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = baseColor);
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1;
    const spacing = 32.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GlassSurface extends StatelessWidget {
  final Widget child;
  final double radius;
  final double blur;

  const _GlassSurface({
    required this.child,
    required this.radius,
    required this.blur,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _TerminalXtermPanel extends StatefulWidget {
  final List<dynamic> events;
  final String? rawText;
  final String? fontFamily;
  final double? fontSize;
  final double? lineHeight;
  final Color? backgroundColor;
  final Color? textColor;

  const _TerminalXtermPanel({
    required this.events,
    required this.rawText,
    required this.fontFamily,
    required this.fontSize,
    required this.lineHeight,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  State<_TerminalXtermPanel> createState() => _TerminalXtermPanelState();
}

class _TerminalXtermPanelState extends State<_TerminalXtermPanel> {
  late final xterm.Terminal _terminal = xterm.Terminal(maxLines: 2000);

  @override
  void initState() {
    super.initState();
    _writeContent();
  }

  @override
  void didUpdateWidget(covariant _TerminalXtermPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rawText != widget.rawText ||
        oldWidget.events != widget.events) {
      _terminal.write('\x1b[2J\x1b[H');
      _writeContent();
    }
  }

  void _writeContent() {
    final raw = widget.rawText?.trim();
    if (raw != null && raw.isNotEmpty) {
      _terminal.write(raw);
      return;
    }
    final buffer = StringBuffer();
    for (final event in widget.events) {
      if (event is Map) {
        final text = event['text']?.toString();
        if (text != null) buffer.writeln(text);
      } else if (event != null) {
        buffer.writeln(event.toString());
      }
    }
    _terminal.write(buffer.toString());
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.backgroundColor ?? const Color(0xff050a06);
    final fg = widget.textColor ?? const Color(0xffd1ffd6);
    final theme = _buildTerminalTheme(bg, fg);
    return Container(
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: fg.withOpacity(0.4)),
      ),
      child: xterm.TerminalView(
        _terminal,
        theme: theme,
        textStyle: xterm.TerminalStyle(
          fontFamily: widget.fontFamily ?? 'JetBrains Mono',
          fontSize: widget.fontSize ?? 12,
          height: widget.lineHeight ?? 1.4,
        ),
      ),
    );
  }
}

Color _mix(Color a, Color b, double t) => Color.lerp(a, b, t) ?? a;

xterm.TerminalTheme _buildTerminalTheme(Color bg, Color fg) {
  final black = bg;
  final white = fg;
  final red = const Color(0xffef4444);
  final green = const Color(0xff22c55e);
  final yellow = const Color(0xfff59e0b);
  final blue = const Color(0xff3b82f6);
  final magenta = const Color(0xffa855f7);
  final cyan = const Color(0xff22d3ee);

  return xterm.TerminalTheme(
    background: bg,
    foreground: fg,
    cursor: fg,
    selection: fg.withOpacity(0.3),
    black: black,
    red: red,
    green: green,
    yellow: yellow,
    blue: blue,
    magenta: magenta,
    cyan: cyan,
    white: white,
    brightBlack: _mix(black, Colors.white, 0.35),
    brightRed: _mix(red, Colors.white, 0.25),
    brightGreen: _mix(green, Colors.white, 0.25),
    brightYellow: _mix(yellow, Colors.white, 0.25),
    brightBlue: _mix(blue, Colors.white, 0.25),
    brightMagenta: _mix(magenta, Colors.white, 0.25),
    brightCyan: _mix(cyan, Colors.white, 0.25),
    brightWhite: _mix(white, Colors.white, 0.15),
    searchHitBackground: _mix(blue, bg, 0.6),
    searchHitBackgroundCurrent: _mix(magenta, bg, 0.5),
    searchHitForeground: fg,
  );
}

final Map<String, StyleControlOverride> styleOverrideRegistry = {
  'retro_button': _buildRetroButton,
  'comfy_button': _buildComfyButton,
  'neon_button': _buildNeonButton,
  'glass_container': _buildGlassContainer,
  'terminal_xterm': _buildXtermOverride,
  'xterm_terminal': _buildXtermOverride,
};
