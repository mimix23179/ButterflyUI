import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:flutter/material.dart';

import '../../studio_contract.dart';

typedef StudioSurfaceSelectCallback = void Function(String id, {bool additive});

class StudioCanvasSurface extends StatelessWidget {
  const StudioCanvasSurface({
    super.key,
    required this.surfaceProps,
    required this.selectedIds,
    required this.zoom,
    required this.onSelect,
  });

  final Map<String, Object?> surfaceProps;
  final Set<String> selectedIds;
  final double zoom;
  final StudioSurfaceSelectCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final worldW = (coerceDouble(surfaceProps['world_width']) ?? 2200).clamp(
      320,
      10000,
    );
    final worldH = (coerceDouble(surfaceProps['world_height']) ?? 1400).clamp(
      240,
      10000,
    );
    final grid = (coerceDouble(surfaceProps['grid_size']) ?? 24).clamp(4, 240);
    final background =
        coerceColor(surfaceProps['background'] ?? surfaceProps['bgcolor']) ??
        const Color(0xff0b1220);
    final entities = _entities();
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Transform.scale(
            scale: zoom,
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: worldW.toDouble(),
              height: worldH.toDouble(),
              child: Stack(
                children: [
                  Positioned.fill(child: ColoredBox(color: background)),
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _Grid(
                        grid: grid.toDouble(),
                        color: Theme.of(
                          context,
                        ).dividerColor.withValues(alpha: 0.35),
                      ),
                    ),
                  ),
                  for (final entity in entities)
                    _Entity(
                      entity: entity,
                      selected: selectedIds.contains(
                        (entity['id'] ?? '').toString(),
                      ),
                      onTap: () => onSelect(
                        (entity['id'] ?? '').toString(),
                        additive: false,
                      ),
                      onLongPress: () => onSelect(
                        (entity['id'] ?? '').toString(),
                        additive: true,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, Object?>> _entities() {
    for (final key in ['entities', 'items', 'nodes']) {
      final records = studioCoerceMapList(surfaceProps[key]);
      if (records.isNotEmpty) return records;
    }
    return <Map<String, Object?>>[
      {
        'id': 'root',
        'label': 'Root',
        'x': 120,
        'y': 120,
        'width': 320,
        'height': 220,
        'color': '#1f2937',
      },
      {
        'id': 'headline',
        'label': 'Headline',
        'x': 540,
        'y': 140,
        'width': 260,
        'height': 70,
        'color': '#115e59',
      },
      {
        'id': 'cta',
        'label': 'CTA',
        'x': 560,
        'y': 260,
        'width': 160,
        'height': 56,
        'color': '#1d4ed8',
      },
    ];
  }
}

class _Entity extends StatelessWidget {
  const _Entity({
    required this.entity,
    required this.selected,
    required this.onTap,
    required this.onLongPress,
  });

  final Map<String, Object?> entity;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final x = coerceDouble(entity['x']) ?? 0;
    final y = coerceDouble(entity['y']) ?? 0;
    final w = (coerceDouble(entity['width']) ?? 180).clamp(48, 1000).toDouble();
    final h = (coerceDouble(entity['height']) ?? 96).clamp(32, 900).toDouble();
    final color = coerceColor(entity['color']) ?? const Color(0xff0f766e);
    final child = Container(
      width: w,
      height: h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        (entity['label'] ?? entity['name'] ?? entity['id'] ?? '').toString(),
        style: const TextStyle(color: Colors.white),
      ),
    );

    return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: selected
            ? Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1.5,
                  ),
                ),
                child: child,
              )
            : child,
      ),
    );
  }
}

class _Grid extends CustomPainter {
  _Grid({required this.grid, required this.color});

  final double grid;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final spacing = grid <= 2 ? 2.0 : grid;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    for (var x = 0.0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _Grid oldDelegate) {
    return oldDelegate.grid != grid || oldDelegate.color != color;
  }
}
