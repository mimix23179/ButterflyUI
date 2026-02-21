import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'svg_picture_resolver_stub.dart'
    if (dart.library.io) 'svg_picture_resolver_io.dart';

Widget resolveSvgPictureFromPath(
  String path, {
  required BoxFit fit,
  required Alignment alignment,
  double? width,
  double? height,
  ColorFilter? colorFilter,
}) {
  return resolveSvgPicturePlatform(
    path,
    fit: fit,
    alignment: alignment,
    width: width,
    height: height,
    colorFilter: colorFilter,
  );
}
