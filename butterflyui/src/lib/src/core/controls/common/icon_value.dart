import 'package:flutter/material.dart';

IconData? parseIconDataLoose(Object? value) {
  if (value == null) return null;

  final raw = value.toString().trim();
  if (raw.isEmpty) return null;

  final key = raw.toLowerCase().replaceAll('-', '_').replaceAll(' ', '_');
  switch (key) {
    case 'home':
      return Icons.home_outlined;
    case 'search':
      return Icons.search;
    case 'settings':
      return Icons.settings_outlined;
    case 'folder':
      return Icons.folder_outlined;
    case 'file':
    case 'document':
      return Icons.description_outlined;
    case 'download':
      return Icons.download_outlined;
    case 'upload':
      return Icons.upload_outlined;
    case 'delete':
    case 'trash':
      return Icons.delete_outline;
    case 'edit':
      return Icons.edit_outlined;
    case 'close':
      return Icons.close;
    case 'check':
      return Icons.check;
    case 'warning':
      return Icons.warning_amber_rounded;
    case 'error':
      return Icons.error_outline;
    case 'info':
      return Icons.info_outline;
    case 'play':
      return Icons.play_arrow;
    case 'pause':
      return Icons.pause;
    case 'stop':
      return Icons.stop;
    case 'refresh':
      return Icons.refresh;
    case 'menu':
      return Icons.menu;
    case 'arrow_right':
    case 'chevron_right':
      return Icons.chevron_right;
    case 'arrow_left':
    case 'chevron_left':
      return Icons.chevron_left;
    case 'arrow_down':
    case 'chevron_down':
      return Icons.expand_more;
    case 'arrow_up':
    case 'chevron_up':
      return Icons.expand_less;
  }
  return null;
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
  if (normalized.startsWith('\\u')) {
    return int.tryParse(normalized.substring(2), radix: 16);
  }
  return int.tryParse(normalized);
}

Widget? buildIconValue(
  Object? value, {
  Color? color,
  double? size,
  TextStyle? textStyle,
}) {
  if (value == null) return null;
  if (value is Map) {
    final codepoint = _parseIconCodepoint(value['codepoint'] ?? value['unicode'] ?? value['icon']);
    if (codepoint != null) {
      final fontFamily = value['font_family']?.toString() ?? 'MaterialIcons';
      final fontPackage = value['font_package']?.toString();
      return Text(
        String.fromCharCode(codepoint),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: (textStyle ?? TextStyle(fontSize: size, color: color)).copyWith(
          fontFamily: fontFamily,
          package: fontPackage,
        ),
      );
    }
    final nextValue = value['icon'] ?? value['name'] ?? value['value'] ?? value['text'] ?? value['label'];
    if (nextValue != null) {
      return buildIconValue(nextValue, color: color, size: size, textStyle: textStyle);
    }
  } else {
    final codepoint = _parseIconCodepoint(value);
    if (codepoint != null) {
      return Text(
        String.fromCharCode(codepoint),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: (textStyle ?? TextStyle(fontSize: size, color: color)).copyWith(
          fontFamily: 'MaterialIcons',
        ),
      );
    }
  }
  final iconData = parseIconDataLoose(value);
  if (iconData != null) {
    return Icon(iconData, size: size, color: color);
  }

  final text = value.toString().trim();
  if (text.isEmpty) return null;
  return Text(
    text,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: textStyle,
  );
}
