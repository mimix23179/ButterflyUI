import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:flutter/material.dart';

import '../../studio_contract.dart';

class StudioNodeSurface extends StatelessWidget {
  const StudioNodeSurface({
    super.key,
    required this.surfaceProps,
    required this.selectedIds,
    required this.onSelectNode,
  });

  final Map<String, Object?> surfaceProps;
  final Set<String> selectedIds;
  final void Function(String id, {bool additive}) onSelectNode;

  @override
  Widget build(BuildContext context) {
    final nodes = _nodes();
    final edges = studioCoerceMapList(surfaceProps['edges']);
    final worldW = (coerceDouble(surfaceProps['world_width']) ?? 2200).clamp(
      480,
      12000,
    );
    final worldH = (coerceDouble(surfaceProps['world_height']) ?? 1400).clamp(
      360,
      12000,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: SizedBox(
            width: worldW.toDouble(),
            height: worldH.toDouble(),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _EdgesPainter(
                      nodes: nodes,
                      edges: edges,
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.55),
                    ),
                  ),
                ),
                for (final node in nodes)
                  _NodeCard(
                    node: node,
                    selected: selectedIds.contains(
                      (node['id'] ?? '').toString(),
                    ),
                    onTap: () => onSelectNode(
                      (node['id'] ?? '').toString(),
                      additive: false,
                    ),
                    onLongPress: () => onSelectNode(
                      (node['id'] ?? '').toString(),
                      additive: true,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, Object?>> _nodes() {
    final nodes = studioCoerceMapList(surfaceProps['nodes']);
    if (nodes.isNotEmpty) return nodes;
    return <Map<String, Object?>>[
      {
        'id': 'source',
        'label': 'Source',
        'x': 120,
        'y': 120,
        'width': 170,
        'height': 90,
        'color': '#1d4ed8',
      },
      {
        'id': 'grade',
        'label': 'Color Grade',
        'x': 420,
        'y': 170,
        'width': 190,
        'height': 96,
        'color': '#0f766e',
      },
      {
        'id': 'output',
        'label': 'Output',
        'x': 760,
        'y': 130,
        'width': 170,
        'height': 90,
        'color': '#7c3aed',
      },
    ];
  }
}

class _NodeCard extends StatelessWidget {
  const _NodeCard({
    required this.node,
    required this.selected,
    required this.onTap,
    required this.onLongPress,
  });

  final Map<String, Object?> node;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final x = coerceDouble(node['x']) ?? 0;
    final y = coerceDouble(node['y']) ?? 0;
    final w = (coerceDouble(node['width']) ?? 180).clamp(80, 420).toDouble();
    final h = (coerceDouble(node['height']) ?? 96).clamp(60, 280).toDouble();
    final color = coerceColor(node['color']) ?? const Color(0xff374151);

    return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: w,
          height: h,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.white.withValues(alpha: 0.14),
              width: selected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: selected ? 10 : 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (node['label'] ?? node['id'] ?? 'Node').toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                (node['type'] ?? 'processor').toString(),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EdgesPainter extends CustomPainter {
  _EdgesPainter({
    required this.nodes,
    required this.edges,
    required this.color,
  });

  final List<Map<String, Object?>> nodes;
  final List<Map<String, Object?>> edges;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final nodeMap = <String, Rect>{};
    for (final node in nodes) {
      final id = (node['id'] ?? '').toString();
      if (id.isEmpty) continue;
      final x = coerceDouble(node['x']) ?? 0;
      final y = coerceDouble(node['y']) ?? 0;
      final w = (coerceDouble(node['width']) ?? 180).clamp(80, 420).toDouble();
      final h = (coerceDouble(node['height']) ?? 96).clamp(60, 280).toDouble();
      nodeMap[id] = Rect.fromLTWH(x, y, w, h);
    }

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final effectiveEdges = edges.isEmpty
        ? <Map<String, Object?>>[
            {'from': 'source', 'to': 'grade'},
            {'from': 'grade', 'to': 'output'},
          ]
        : edges;

    for (final edge in effectiveEdges) {
      final fromId = (edge['from'] ?? '').toString();
      final toId = (edge['to'] ?? '').toString();
      final from = nodeMap[fromId];
      final to = nodeMap[toId];
      if (from == null || to == null) continue;
      final start = Offset(from.right, from.center.dy);
      final end = Offset(to.left, to.center.dy);
      final controlA = Offset(start.dx + 70, start.dy);
      final controlB = Offset(end.dx - 70, end.dy);
      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..cubicTo(
          controlA.dx,
          controlA.dy,
          controlB.dx,
          controlB.dy,
          end.dx,
          end.dy,
        );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _EdgesPainter oldDelegate) {
    return oldDelegate.nodes != nodes ||
        oldDelegate.edges != edges ||
        oldDelegate.color != color;
  }
}
