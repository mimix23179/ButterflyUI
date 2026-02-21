import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget resolveSvgPicturePlatform(
  String path, {
  required BoxFit fit,
  required Alignment alignment,
  double? width,
  double? height,
  ColorFilter? colorFilter,
}) {
  final trimmed = path.trim();
  if (trimmed.isEmpty) return const SizedBox.shrink();
  return SvgPicture.file(
    File(trimmed),
    fit: fit,
    alignment: alignment,
    width: width,
    height: height,
    colorFilter: colorFilter,
  );
}
