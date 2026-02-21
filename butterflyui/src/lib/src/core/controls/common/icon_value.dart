import 'package:flutter/material.dart';

IconData? parseIconDataLoose(Object? value) {
  if (value == null) return null;
  if (value is int) {
    return IconData(value, fontFamily: 'MaterialIcons');
  }

  final raw = value.toString().trim();
  if (raw.isEmpty) return null;

  final hex = int.tryParse(raw);
  if (hex != null) {
    return IconData(hex, fontFamily: 'MaterialIcons');
  }

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

Widget? buildIconValue(
  Object? value, {
  Color? color,
  double? size,
  TextStyle? textStyle,
}) {
  if (value == null) return null;
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
