import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/common/color_value.dart';

IconData? parseIconDataLoose(Object? value) {
  if (value == null) return null;
  final raw = value.toString().trim();
  if (raw.isEmpty) return null;
  final key = raw.toLowerCase().replaceAll('-', '_').replaceAll(' ', '_');
  return _iconAliases[key];
}

Widget? buildIconValue(
  Object? value, {
  Object? colorValue,
  Color? color,
  Color? background,
  double? size,
  TextStyle? textStyle,
  bool autoContrast = false,
  double minContrast = 4.5,
  IconData? fallbackIcon,
}) {
  if (value == null) return null;

  final resolvedColor =
      resolveColorValue(
        colorValue ?? color,
        fallback: color,
        background: background,
        autoContrast: autoContrast,
        minContrast: minContrast,
      ) ??
      color;

  if (value is IconData) {
    return Icon(value, size: size, color: resolvedColor);
  }

  if (value is Map) {
    final map = coerceObjectMap(value);
    final codepoint = _parseIconCodepoint(
      map['codepoint'] ?? map['unicode'] ?? map['code'] ?? map['glyph'],
    );
    if (codepoint != null) {
      final fontFamily = map['font_family']?.toString() ?? 'MaterialIcons';
      final fontPackage = map['font_package']?.toString();
      final matchTextDirection =
          coerceBool(map['match_text_direction']) ?? false;
      return Icon(
        IconData(
          codepoint,
          fontFamily: fontFamily,
          fontPackage: fontPackage,
          matchTextDirection: matchTextDirection,
        ),
        size: size,
        color: resolvedColor,
      );
    }

    final nested =
        map['icon'] ??
        map['name'] ??
        map['value'] ??
        map['text'] ??
        map['label'];
    if (nested != null) {
      return buildIconValue(
        nested,
        colorValue: map['color'] ?? colorValue,
        color: resolvedColor,
        background:
            background ??
            resolveColorValue(map['background'] ?? map['bgcolor']),
        size: coerceDouble(map['size']) ?? size,
        textStyle: textStyle,
        autoContrast: coerceBool(map['auto_contrast']) ?? autoContrast,
        minContrast: coerceDouble(map['min_contrast']) ?? minContrast,
        fallbackIcon: fallbackIcon,
      );
    }
  } else {
    final codepoint = _parseIconCodepoint(value);
    if (codepoint != null) {
      return Icon(
        IconData(codepoint, fontFamily: 'MaterialIcons'),
        size: size,
        color: resolvedColor,
      );
    }
  }

  final iconData = parseIconDataLoose(value);
  if (iconData != null) {
    return Icon(iconData, size: size, color: resolvedColor);
  }

  final text = value.toString().trim();
  if (text.isEmpty) return null;

  // Keep one/two-char glyph fallback (emoji/symbol) but avoid rendering long
  // icon names as plain text.
  if (text.runes.length <= 2) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: (textStyle ?? TextStyle(fontSize: size, color: resolvedColor)),
    );
  }

  final fallback = fallbackIcon ?? Icons.help_outline;
  return Icon(fallback, size: size, color: resolvedColor);
}

int? _parseIconCodepoint(Object? value) {
  if (value == null) return null;
  if (value is int) return value;
  final raw = value.toString().trim();
  if (raw.isEmpty) return null;
  final normalized = raw.toLowerCase();
  if (normalized.startsWith('0x')) {
    return int.tryParse(normalized.substring(2), radix: 16);
  }
  if (normalized.startsWith(r'\u')) {
    return int.tryParse(normalized.substring(2), radix: 16);
  }
  if (normalized.startsWith('u+')) {
    return int.tryParse(normalized.substring(2), radix: 16);
  }
  return int.tryParse(normalized);
}

const Map<String, IconData> _iconAliases = <String, IconData>{
  'add': Icons.add,
  'arrow_down': Icons.expand_more,
  'arrow_left': Icons.chevron_left,
  'arrow_right': Icons.chevron_right,
  'arrow_up': Icons.expand_less,
  'check': Icons.check,
  'check_circle': Icons.check_circle_outline,
  'chevron_down': Icons.expand_more,
  'chevron_left': Icons.chevron_left,
  'chevron_right': Icons.chevron_right,
  'chevron_up': Icons.expand_less,
  'close': Icons.close,
  'copy': Icons.copy_outlined,
  'delete': Icons.delete_outline,
  'document': Icons.description_outlined,
  'download': Icons.download_outlined,
  'edit': Icons.edit_outlined,
  'error': Icons.error_outline,
  'file': Icons.description_outlined,
  'filter': Icons.filter_alt_outlined,
  'folder': Icons.folder_outlined,
  'help': Icons.help_outline,
  'home': Icons.home_outlined,
  'image': Icons.image_outlined,
  'info': Icons.info_outline,
  'menu': Icons.menu,
  'more': Icons.more_horiz,
  'pause': Icons.pause,
  'play': Icons.play_arrow,
  'refresh': Icons.refresh,
  'remove': Icons.remove,
  'search': Icons.search,
  'send': Icons.send_outlined,
  'settings': Icons.settings_outlined,
  'stop': Icons.stop,
  'success': Icons.check_circle_outline,
  'upload': Icons.upload_outlined,
  'warning': Icons.warning_amber_rounded,
};
