import 'package:flutter/material.dart';

import 'image_provider_resolver.dart';
Color? Function(String token)? _tokenColorResolver;

void setTokenColorResolver(Color? Function(String token)? resolver) {
  _tokenColorResolver = resolver;
}

Color? _resolveTokenColor(String token) {
  final resolver = _tokenColorResolver;
  if (resolver == null) return null;
  try {
    return resolver(token);
  } catch (_) {
    return null;
  }
}

const Map<String, int> _namedColors = {
  'aliceblue': 0xFFF0F8FF,
  'antiquewhite': 0xFFFAEBD7,
  'aqua': 0xFF00FFFF,
  'aquamarine': 0xFF7FFFD4,
  'azure': 0xFFF0FFFF,
  'beige': 0xFFF5F5DC,
  'bisque': 0xFFFFE4C4,
  'black': 0xFF000000,
  'blanchedalmond': 0xFFFFEBCD,
  'blue': 0xFF0000FF,
  'blueviolet': 0xFF8A2BE2,
  'brown': 0xFFA52A2A,
  'burlywood': 0xFFDEB887,
  'cadetblue': 0xFF5F9EA0,
  'chartreuse': 0xFF7FFF00,
  'chocolate': 0xFFD2691E,
  'coral': 0xFFFF7F50,
  'cornflowerblue': 0xFF6495ED,
  'cornsilk': 0xFFFFF8DC,
  'crimson': 0xFFDC143C,
  'cyan': 0xFF00FFFF,
  'darkblue': 0xFF00008B,
  'darkcyan': 0xFF008B8B,
  'darkgoldenrod': 0xFFB8860B,
  'darkgray': 0xFFA9A9A9,
  'darkgrey': 0xFFA9A9A9,
  'darkgreen': 0xFF006400,
  'darkkhaki': 0xFFBDB76B,
  'darkmagenta': 0xFF8B008B,
  'darkolivegreen': 0xFF556B2F,
  'darkorange': 0xFFFF8C00,
  'darkorchid': 0xFF9932CC,
  'darkred': 0xFF8B0000,
  'darksalmon': 0xFFE9967A,
  'darkseagreen': 0xFF8FBC8F,
  'darkslateblue': 0xFF483D8B,
  'darkslategray': 0xFF2F4F4F,
  'darkslategrey': 0xFF2F4F4F,
  'darkturquoise': 0xFF00CED1,
  'darkviolet': 0xFF9400D3,
  'deeppink': 0xFFFF1493,
  'deepskyblue': 0xFF00BFFF,
  'dimgray': 0xFF696969,
  'dimgrey': 0xFF696969,
  'dodgerblue': 0xFF1E90FF,
  'firebrick': 0xFFB22222,
  'floralwhite': 0xFFFFFAF0,
  'forestgreen': 0xFF228B22,
  'fuchsia': 0xFFFF00FF,
  'gainsboro': 0xFFDCDCDC,
  'ghostwhite': 0xFFF8F8FF,
  'gold': 0xFFFFD700,
  'goldenrod': 0xFFDAA520,
  'gray': 0xFF808080,
  'grey': 0xFF808080,
  'green': 0xFF008000,
  'greenyellow': 0xFFADFF2F,
  'honeydew': 0xFFF0FFF0,
  'hotpink': 0xFFFF69B4,
  'indianred': 0xFFCD5C5C,
  'indigo': 0xFF4B0082,
  'ivory': 0xFFFFFFF0,
  'khaki': 0xFFF0E68C,
  'lavender': 0xFFE6E6FA,
  'lavenderblush': 0xFFFFF0F5,
  'lawngreen': 0xFF7CFC00,
  'lemonchiffon': 0xFFFFFACD,
  'lightblue': 0xFFADD8E6,
  'lightcoral': 0xFFF08080,
  'lightcyan': 0xFFE0FFFF,
  'lightgoldenrodyellow': 0xFFFAFAD2,
  'lightgray': 0xFFD3D3D3,
  'lightgrey': 0xFFD3D3D3,
  'lightgreen': 0xFF90EE90,
  'lightpink': 0xFFFFB6C1,
  'lightsalmon': 0xFFFFA07A,
  'lightseagreen': 0xFF20B2AA,
  'lightskyblue': 0xFF87CEFA,
  'lightslategray': 0xFF778899,
  'lightslategrey': 0xFF778899,
  'lightsteelblue': 0xFFB0C4DE,
  'lightyellow': 0xFFFFFFE0,
  'lime': 0xFF00FF00,
  'limegreen': 0xFF32CD32,
  'linen': 0xFFFAF0E6,
  'magenta': 0xFFFF00FF,
  'maroon': 0xFF800000,
  'mediumaquamarine': 0xFF66CDAA,
  'mediumblue': 0xFF0000CD,
  'mediumorchid': 0xFFBA55D3,
  'mediumpurple': 0xFF9370DB,
  'mediumseagreen': 0xFF3CB371,
  'mediumslateblue': 0xFF7B68EE,
  'mediumspringgreen': 0xFF00FA9A,
  'mediumturquoise': 0xFF48D1CC,
  'mediumvioletred': 0xFFC71585,
  'midnightblue': 0xFF191970,
  'mintcream': 0xFFF5FFFA,
  'mistyrose': 0xFFFFE4E1,
  'moccasin': 0xFFFFE4B5,
  'navajowhite': 0xFFFFDEAD,
  'navy': 0xFF000080,
  'oldlace': 0xFFFDF5E6,
  'olive': 0xFF808000,
  'olivedrab': 0xFF6B8E23,
  'orange': 0xFFFFA500,
  'orangered': 0xFFFF4500,
  'orchid': 0xFFDA70D6,
  'palegoldenrod': 0xFFEEE8AA,
  'palegreen': 0xFF98FB98,
  'paleturquoise': 0xFFAFEEEE,
  'palevioletred': 0xFFDB7093,
  'papayawhip': 0xFFFFEFD5,
  'peachpuff': 0xFFFFDAB9,
  'peru': 0xFFCD853F,
  'pink': 0xFFFFC0CB,
  'plum': 0xFFDDA0DD,
  'powderblue': 0xFFB0E0E6,
  'purple': 0xFF800080,
  'rebeccapurple': 0xFF663399,
  'red': 0xFFFF0000,
  'rosybrown': 0xFFBC8F8F,
  'royalblue': 0xFF4169E1,
  'saddlebrown': 0xFF8B4513,
  'salmon': 0xFFFA8072,
  'sandybrown': 0xFFF4A460,
  'seagreen': 0xFF2E8B57,
  'seashell': 0xFFFFF5EE,
  'sienna': 0xFFA0522D,
  'silver': 0xFFC0C0C0,
  'skyblue': 0xFF87CEEB,
  'slateblue': 0xFF6A5ACD,
  'slategray': 0xFF708090,
  'slategrey': 0xFF708090,
  'snow': 0xFFFFFAFA,
  'springgreen': 0xFF00FF7F,
  'steelblue': 0xFF4682B4,
  'tan': 0xFFD2B48C,
  'teal': 0xFF008080,
  'thistle': 0xFFD8BFD8,
  'tomato': 0xFFFF6347,
  'turquoise': 0xFF40E0D0,
  'violet': 0xFFEE82EE,
  'wheat': 0xFFF5DEB3,
  'white': 0xFFFFFFFF,
  'whitesmoke': 0xFFF5F5F5,
  'yellow': 0xFFFFFF00,
  'yellowgreen': 0xFF9ACD32,
  'transparent': 0x00000000,
};

Color? _resolveNamedColor(String name) {
  final value = _namedColors[name];
  if (value == null) return null;
  return Color(value);
}

double? _parseNumber(String value) {
  return double.tryParse(value.trim());
}

double _clamp01(double value) {
  if (value < 0) return 0.0;
  if (value > 1) return 1.0;
  return value;
}

double _parseHue(String raw) {
  var value = raw.trim().toLowerCase();
  if (value.endsWith('deg')) {
    value = value.substring(0, value.length - 3);
  } else if (value.endsWith('turn')) {
    value = value.substring(0, value.length - 4);
    final parsed = _parseNumber(value) ?? 0.0;
    final normalized = (parsed * 360.0) % 360.0;
    return normalized < 0 ? normalized + 360.0 : normalized;
  } else if (value.endsWith('rad')) {
    value = value.substring(0, value.length - 3);
    final parsed = _parseNumber(value) ?? 0.0;
    final normalized = (parsed * 180.0 / 3.141592653589793) % 360.0;
    return normalized < 0 ? normalized + 360.0 : normalized;
  }
  final parsed = _parseNumber(value) ?? 0.0;
  final normalized = parsed % 360.0;
  return normalized < 0 ? normalized + 360.0 : normalized;
}

double _parsePercentOrUnit(String raw) {
  var value = raw.trim().toLowerCase();
  if (value.endsWith('%')) {
    value = value.substring(0, value.length - 1);
    final parsed = _parseNumber(value) ?? 0.0;
    return _clamp01(parsed / 100.0);
  }
  final parsed = _parseNumber(value) ?? 0.0;
  if (parsed > 1.0) {
    return _clamp01(parsed / 100.0);
  }
  return _clamp01(parsed);
}

double _parseAlpha(String raw) {
  final parsed = _parseNumber(raw) ?? 1.0;
  if (parsed <= 1.0) {
    return _clamp01(parsed);
  }
  return _clamp01(parsed / 255.0);
}

Color? _parseHslColor(String raw) {
  final open = raw.indexOf('(');
  final close = raw.lastIndexOf(')');
  if (open == -1 || close == -1 || close <= open) return null;
  final parts = raw
      .substring(open + 1, close)
      .split(',')
      .map((p) => p.trim())
      .toList();
  if (parts.length < 3) return null;

  final h = _parseHue(parts[0]);
  final s = _parsePercentOrUnit(parts[1]);
  final l = _parsePercentOrUnit(parts[2]);
  final a = parts.length >= 4 ? _parseAlpha(parts[3]) : 1.0;

  final c = (1.0 - (2.0 * l - 1.0).abs()) * s;
  final hp = h / 60.0;
  final x = c * (1.0 - ((hp % 2.0) - 1.0).abs());
  double r1 = 0.0;
  double g1 = 0.0;
  double b1 = 0.0;
  if (hp >= 0 && hp < 1) {
    r1 = c;
    g1 = x;
  } else if (hp >= 1 && hp < 2) {
    r1 = x;
    g1 = c;
  } else if (hp >= 2 && hp < 3) {
    g1 = c;
    b1 = x;
  } else if (hp >= 3 && hp < 4) {
    g1 = x;
    b1 = c;
  } else if (hp >= 4 && hp < 5) {
    r1 = x;
    b1 = c;
  } else if (hp >= 5 && hp < 6) {
    r1 = c;
    b1 = x;
  }
  final m = l - c / 2.0;
  int toChannel(double v) =>
      (((v + m).clamp(0.0, 1.0) as num).toDouble() * 255.0).round();

  final r = toChannel(r1);
  final g = toChannel(g1);
  final b = toChannel(b1);
  final alpha = (_clamp01(a) * 255.0).round();
  return Color.fromARGB(alpha, r, g, b);
}

double? coerceDouble(Object? value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

int? coerceOptionalInt(Object? value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}

EdgeInsets? coercePadding(Object? value) {
  if (value == null) return null;
  if (value is num) return EdgeInsets.all(value.toDouble());
  if (value is List) {
    final nums = value.map(coerceDouble).whereType<double>().toList();
    if (nums.isEmpty) return null;
    if (nums.length == 1) {
      return EdgeInsets.all(nums[0]);
    }
    if (nums.length == 2) {
      return EdgeInsets.symmetric(vertical: nums[0], horizontal: nums[1]);
    }
    if (nums.length >= 4) {
      return EdgeInsets.fromLTRB(nums[0], nums[1], nums[2], nums[3]);
    }
  }
  if (value is Map) {
    final map = coerceObjectMap(value);
    final left = coerceDouble(map['left']) ?? 0.0;
    final top = coerceDouble(map['top']) ?? 0.0;
    final right = coerceDouble(map['right']) ?? 0.0;
    final bottom = coerceDouble(map['bottom']) ?? 0.0;
    return EdgeInsets.fromLTRB(left, top, right, bottom);
  }
  return null;
}

Color? coerceColor(Object? value) {
  if (value == null) return null;
  if (value is int) return Color(value);

  if (value is Map) {
    final map = coerceObjectMap(value);

    final direct = map['value'];
    if (direct is int) return Color(direct);

    final token = map['token'];
    if (token != null) {
      final resolved = _resolveTokenColor(token.toString());
      if (resolved != null) return resolved;
    }

    final name = map['name'];
    if (name is String) {
      final resolved = _resolveNamedColor(name.trim().toLowerCase());
      if (resolved != null) return resolved;
    }

    final hexValue = map['hex'] ?? map['color'] ?? map['argb'] ?? map['rgba'];
    if (hexValue is String) {
      final parsed = coerceColor(hexValue);
      if (parsed != null) return parsed;
    }

    final rRaw = map['r'] ?? map['red'];
    final gRaw = map['g'] ?? map['green'];
    final bRaw = map['b'] ?? map['blue'];
    if (rRaw != null && gRaw != null && bRaw != null) {
      int clamp255(num v) => v < 0 ? 0 : (v > 255 ? 255 : v.round());
      final r = clamp255(
        (rRaw is num) ? rRaw : (num.tryParse(rRaw.toString()) ?? 0),
      );
      final g = clamp255(
        (gRaw is num) ? gRaw : (num.tryParse(gRaw.toString()) ?? 0),
      );
      final b = clamp255(
        (bRaw is num) ? bRaw : (num.tryParse(bRaw.toString()) ?? 0),
      );

      final aRaw = map['a'] ?? map['alpha'];
      int a = 255;
      if (aRaw != null) {
        final n = (aRaw is num) ? aRaw : num.tryParse(aRaw.toString());
        if (n != null) {
          // Accept either 0..1 or 0..255.
          a = n <= 1 ? clamp255(n * 255.0) : clamp255(n);
        }
      }
      return Color.fromARGB(a, r, g, b);
    }
  }

  final raw = value.toString().trim();
  if (raw.isEmpty) return null;
  if (raw.startsWith(r'$')) {
    final token = raw.substring(1).trim();
    if (token.isNotEmpty) {
      final resolved = _resolveTokenColor(token);
      if (resolved != null) return resolved;
    }
  }
  final lower = raw.toLowerCase();

  if (lower.startsWith('hsl(') || lower.startsWith('hsla(')) {
    final parsed = _parseHslColor(raw);
    if (parsed != null) return parsed;
  }

  // rgb() / rgba() strings.
  if (lower.startsWith('rgb(') || lower.startsWith('rgba(')) {
    final open = raw.indexOf('(');
    final close = raw.lastIndexOf(')');
    if (open != -1 && close != -1 && close > open) {
      final parts = raw
          .substring(open + 1, close)
          .split(',')
          .map((p) => p.trim())
          .toList();
      if (parts.length == 3 || parts.length == 4) {
        num? parseNum(String s) => num.tryParse(s);
        final r = parseNum(parts[0]);
        final g = parseNum(parts[1]);
        final b = parseNum(parts[2]);
        if (r != null && g != null && b != null) {
          int clamp255(num v) => v < 0 ? 0 : (v > 255 ? 255 : v.round());
          final rr = clamp255(r);
          final gg = clamp255(g);
          final bb = clamp255(b);
          var aa = 255;
          if (parts.length == 4) {
            final a = parseNum(parts[3]);
            if (a != null) {
              aa = a <= 1 ? clamp255(a * 255.0) : clamp255(a);
            }
          }
          return Color.fromARGB(aa, rr, gg, bb);
        }
      }
    }
  }

  final named = _resolveNamedColor(lower);
  if (named != null) return named;

  // Hex strings: #RGB, #ARGB, #RRGGBB, #AARRGGBB, 0x..., or raw hex.
  var hex = lower;
  if (hex.startsWith('#')) {
    hex = hex.substring(1);
  } else if (hex.startsWith('0x')) {
    hex = hex.substring(2);
  }

  // Expand short forms.
  if (hex.length == 3) {
    // RGB
    final r = hex[0];
    final g = hex[1];
    final b = hex[2];
    hex = 'ff$r$r$g$g$b$b';
  } else if (hex.length == 4) {
    // ARGB
    final a = hex[0];
    final r = hex[1];
    final g = hex[2];
    final b = hex[3];
    hex = '$a$a$r$r$g$g$b$b';
  } else if (hex.length == 6) {
    hex = 'ff$hex';
  }

  if (hex.length != 8) {
    final resolved = _resolveTokenColor(lower);
    if (resolved != null) return resolved;
    return null;
  }
  final parsed = int.tryParse(hex, radix: 16);
  if (parsed == null) return null;
  return Color(parsed);
}

Color? parseColor(Object? value) {
  return coerceColor(value);
}

Map<String, Object?> coerceObjectMap(Map value) {
  return value.map((k, v) => MapEntry(k.toString(), v));
}

ImageProvider? resolveImageProvider(String src) {
  return resolveImageProviderImpl(src);
}

List<BoxShadow>? coerceBoxShadow(Object? value) {
  if (value == null) return null;
  final list = (value is List) ? value : [value];
  final shadows = <BoxShadow>[];
  for (final item in list) {
    if (item is Map) {
      final map = coerceObjectMap(item);
      final color = coerceColor(map['color']) ?? const Color(0xFF000000);
      final offsetList = map['offset'] is List ? map['offset'] as List : null;
      final offset = (offsetList != null && offsetList.length >= 2)
          ? Offset(
              coerceDouble(offsetList[0]) ?? 0,
              coerceDouble(offsetList[1]) ?? 0,
            )
          : Offset.zero;
      final blur = coerceDouble(map['blur_radius'] ?? map['blur']) ?? 0.0;
      final spread = coerceDouble(map['spread_radius'] ?? map['spread']) ?? 0.0;
      final styleStr = map['blur_style']?.toString().toLowerCase();
      final blurStyle = styleStr == 'solid'
          ? BlurStyle.solid
          : styleStr == 'outer'
          ? BlurStyle.outer
          : styleStr == 'inner'
          ? BlurStyle.inner
          : BlurStyle.normal;
      shadows.add(
        BoxShadow(
          color: color,
          offset: offset,
          blurRadius: blur,
          spreadRadius: spread,
          blurStyle: blurStyle,
        ),
      );
    }
  }
  return shadows.isEmpty ? null : shadows;
}

AlignmentGeometry? _coerceAlignment(Object? value) {
  // Simple alignment parser
  if (value == null) return null;
  final s = value
      .toString()
      .toLowerCase()
      .replaceAll('-', '_')
      .replaceAll(' ', '_');
  switch (s) {
    case 'center':
      return Alignment.center;
    case 'top_center':
      return Alignment.topCenter;
    case 'bottom_center':
      return Alignment.bottomCenter;
    case 'center_left':
      return Alignment.centerLeft;
    case 'center_right':
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
  // Coerce from list/map if needed
  if (value is List && value.length >= 2) {
    return Alignment(coerceDouble(value[0]) ?? 0, coerceDouble(value[1]) ?? 0);
  }
  return null;
}

Gradient? coerceGradient(Object? value) {
  if (value is! Map) return null;
  final map = coerceObjectMap(value);
  final type = map['type']?.toString().toLowerCase() ?? 'linear';
  final colors = (map['colors'] as List?)
      ?.map(coerceColor)
      .whereType<Color>()
      .toList();
  if (colors == null || colors.isEmpty) return null;
  final stops = (map['stops'] as List?)
      ?.map(coerceDouble)
      .whereType<double>()
      .toList();
  if (stops != null && stops.length != colors.length)
    return null; // Invalid stops

  final tileModeStr = map['tile_mode']?.toString().toLowerCase();
  final tileMode = tileModeStr == 'mirror'
      ? TileMode.mirror
      : tileModeStr == 'repeated'
      ? TileMode.repeated
      : TileMode.clamp;

  // Transforms are hard to serialize simply, skipping for now.

  if (type == 'linear') {
    final begin = _coerceAlignment(map['begin']) ?? Alignment.centerLeft;
    final end = _coerceAlignment(map['end']) ?? Alignment.centerRight;
    return LinearGradient(
      colors: colors,
      stops: stops,
      begin: begin,
      end: end,
      tileMode: tileMode,
    );
  } else if (type == 'radial') {
    final center = _coerceAlignment(map['center']) ?? Alignment.center;
    final radius = coerceDouble(map['radius']) ?? 0.5;
    final focal = _coerceAlignment(map['focal']);
    final focalRadius = coerceDouble(map['focal_radius']) ?? 0.0;
    return RadialGradient(
      colors: colors,
      stops: stops,
      center: center,
      radius: radius,
      focal: focal,
      focalRadius: focalRadius,
      tileMode: tileMode,
    );
  } else if (type == 'sweep') {
    final center = _coerceAlignment(map['center']) ?? Alignment.center;
    final startAngle = coerceDouble(map['start_angle']) ?? 0.0;
    final endAngle = coerceDouble(map['end_angle']) ?? 6.28318530718;
    return SweepGradient(
      colors: colors,
      stops: stops,
      center: center,
      startAngle: startAngle,
      endAngle: endAngle,
      tileMode: tileMode,
    );
  }
  return null;
}

DecorationImage? coerceDecorationImage(Object? value) {
  if (value is! Map) return null;
  final map = coerceObjectMap(value);
  final src = map['src']?.toString();
  if (src == null || src.isEmpty) return null;

  final provider = resolveImageProvider(src);
  if (provider == null) return null;

  final fitStr = map['fit']?.toString().toLowerCase();
  final fit = fitStr == 'contain'
      ? BoxFit.contain
      : fitStr == 'cover'
      ? BoxFit.cover
      : fitStr == 'fill'
      ? BoxFit.fill
      : fitStr == 'fit_width'
      ? BoxFit.fitWidth
      : fitStr == 'fit_height'
      ? BoxFit.fitHeight
      : fitStr == 'scale_down'
      ? BoxFit.scaleDown
      : fitStr == 'none'
      ? BoxFit.none
      : null;

  final align = _coerceAlignment(map['alignment']) ?? Alignment.center;
  final opacity = coerceDouble(map['opacity']) ?? 1.0;
  final repeatStr = map['repeat']?.toString().toLowerCase();
  final repeat = repeatStr == 'repeat_x'
      ? ImageRepeat.repeatX
      : repeatStr == 'repeat_y'
      ? ImageRepeat.repeatY
      : repeatStr == 'repeat'
      ? ImageRepeat.repeat
      : ImageRepeat.noRepeat;

  return DecorationImage(
    image: provider,
    fit: fit,
    alignment: align,
    opacity: opacity,
    repeat: repeat,
  );
}
