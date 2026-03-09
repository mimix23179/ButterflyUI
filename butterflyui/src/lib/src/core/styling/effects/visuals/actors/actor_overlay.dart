import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/styling/effects/visuals/renderers/render_layers.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';

IconData _coerceEffectActorIcon(String value) {
  switch (value.trim().toLowerCase()) {
    case 'auto_awesome':
    case 'sparkles':
      return Icons.auto_awesome;
    case 'star':
      return Icons.star;
    case 'favorite':
    case 'heart':
      return Icons.favorite;
    case 'bolt':
    case 'flash':
      return Icons.flash_on;
    default:
      return Icons.auto_awesome;
  }
}

List<Map<String, Object?>> _coerceEffectActors(Object? rawActor) {
  if (rawActor is Map) {
    return <Map<String, Object?>>[coerceObjectMap(rawActor)];
  }
  if (rawActor is List) {
    return rawActor
        .whereType<Map>()
        .map((actor) => coerceObjectMap(actor))
        .where((actor) => actor.isNotEmpty)
        .toList(growable: false);
  }
  return const <Map<String, Object?>>[];
}

Widget _buildEffectActorChip(
  Map<String, Object?> actor,
  bool isDark, {
  required String? label,
  required String? icon,
}) {
  final background =
      coerceColor(actor['bgcolor'] ?? actor['background']) ??
      (isDark ? const Color(0xCC0F172A) : const Color(0xCCFFFFFF));
  final foreground =
      coerceColor(actor['color']) ?? (isDark ? Colors.white : Colors.black87);
  final radius = coerceDouble(actor['radius']) ?? 999.0;
  final padding =
      coercePadding(actor['padding']) ??
      const EdgeInsets.symmetric(horizontal: 10, vertical: 6);

  return Container(
    padding: padding,
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Color(0x22000000),
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (icon != null && icon.isNotEmpty)
          Icon(_coerceEffectActorIcon(icon), size: 16, color: foreground),
        if (icon != null &&
            icon.isNotEmpty &&
            label != null &&
            label.isNotEmpty)
          const SizedBox(width: 6),
        if (label != null && label.isNotEmpty)
          Text(
            label,
            style: TextStyle(
              color: foreground,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    ),
  );
}

Widget? _buildSingleEffectActorOverlay(
  Map<String, Object?> actor,
  bool isDark,
) {
  if (actor['visible'] == false) return null;

  final label =
      actor['label']?.toString() ??
      actor['name']?.toString() ??
      actor['text']?.toString();
  final icon = actor['icon']?.toString();
  final alignment =
      coerceAlignmentGeometry(
            actor['alignment'] ?? actor['position'] ?? 'top_right',
          )
          as Alignment? ??
      Alignment.topRight;

  final animatedActor = buildEffectAnimatedLayer(
    actor,
    fallbackAlignment: alignment,
    fallbackFit: BoxFit.contain,
  );
  if (animatedActor != null) {
    if ((label == null || label.isEmpty) && (icon == null || icon.isEmpty)) {
      return IgnorePointer(
        child: RepaintBoundary(
          child: SizedBox.expand(
            child: Stack(children: <Widget>[animatedActor]),
          ),
        ),
      );
    }
    final width =
        coerceDouble(actor['width']) ??
        coerceDouble(actor['size']) ??
        coerceDouble(actor['diameter']) ??
        110.0;
    final height =
        coerceDouble(actor['height']) ??
        coerceDouble(actor['size']) ??
        coerceDouble(actor['diameter']) ??
        width;
    return IgnorePointer(
      child: RepaintBoundary(
        child: Align(
          alignment: alignment,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: width,
                height: height,
                child: Stack(children: <Widget>[animatedActor]),
              ),
              const SizedBox(height: 8),
              _buildEffectActorChip(actor, isDark, label: label, icon: icon),
            ],
          ),
        ),
      ),
    );
  }

  if ((label == null || label.isEmpty) && (icon == null || icon.isEmpty)) {
    return null;
  }

  return IgnorePointer(
    child: RepaintBoundary(
      child: Align(
        alignment: alignment,
        child: _buildEffectActorChip(actor, isDark, label: label, icon: icon),
      ),
    ),
  );
}

Widget? buildEffectActorOverlay(Object? rawActor, bool isDark) {
  final actors = _coerceEffectActors(rawActor);
  if (actors.isEmpty) return null;

  final overlays = actors
      .map((actor) => _buildSingleEffectActorOverlay(actor, isDark))
      .whereType<Widget>()
      .toList(growable: false);
  if (overlays.isEmpty) return null;
  if (overlays.length == 1) return overlays.first;
  return Stack(fit: StackFit.passthrough, children: overlays);
}
