import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:conduit_runtime/src/core/control_utils.dart';
import 'package:conduit_runtime/src/core/control_theme.dart';

Widget buildImageControl(
  Map<String, Object?> props,
  List children,
  Widget Function(Map<String, Object?> child) buildFromControl,
) {
  final src = props['src']?.toString() ?? '';
  if (src.isEmpty) return const SizedBox.shrink();
  final fit = _parseBoxFit(props['fit']);
  final radius = coerceDouble(props['radius']) ?? 0.0;
  final useCache = props['cache'] == null ? true : (props['cache'] == true);
  final placeholder = props['placeholder']?.toString();
  Widget image;
  if (useCache && (src.startsWith('http://') || src.startsWith('https://'))) {
    image = CachedNetworkImage(
      imageUrl: src,
      fit: fit,
      placeholder: (context, url) {
        if (placeholder != null && placeholder.isNotEmpty) {
          return Center(child: Text(placeholder));
        }
        return Container(
          color: conduitSurfaceAlt(context),
          alignment: Alignment.center,
          child: const Text('image'),
        );
      },
      errorWidget: (context, url, error) {
        return Container(
          color: conduitSurfaceAlt(context),
          alignment: Alignment.center,
          child: const Text('image'),
        );
      },
    );
  } else {
    final provider = resolveImageProvider(src);
    if (provider == null) return const SizedBox.shrink();
    image = Image(
      image: provider,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: conduitSurfaceAlt(context),
          alignment: Alignment.center,
          child: const Text('image'),
        );
      },
    );
  }
  if (radius > 0) {
    image = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: image,
    );
  }
  return image;
}

BoxFit? _parseBoxFit(Object? value) {
  final s = value?.toString().toLowerCase();
  switch (s) {
    case 'cover':
      return BoxFit.cover;
    case 'contain':
      return BoxFit.contain;
    case 'fill':
      return BoxFit.fill;
    case 'fit_width':
    case 'fitwidth':
      return BoxFit.fitWidth;
    case 'fit_height':
    case 'fitheight':
      return BoxFit.fitHeight;
    case 'scale_down':
    case 'scaledown':
      return BoxFit.scaleDown;
    case 'none':
      return BoxFit.none;
  }
  return null;
}
