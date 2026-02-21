import 'package:flutter/material.dart';

import 'package:conduit_runtime/src/core/candy/theme.dart';
import 'package:conduit_runtime/src/core/control_utils.dart';
import 'package:conduit_runtime/src/core/webview/webview_api.dart';

Widget buildLauncherControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  ConduitSendRuntimeEvent sendEvent,
  CandyTokens tokens,
) {
  final items = <Map<String, Object?>>[];
  final rawItems = props['items'];
  if (rawItems is List) {
    for (final item in rawItems) {
      if (item is Map) items.add(coerceObjectMap(item));
    }
  }
  if (items.isEmpty) {
    for (var i = 0; i < rawChildren.length; i += 1) {
      final raw = rawChildren[i];
      if (raw is! Map) continue;
      final child = coerceObjectMap(raw);
      items.add(<String, Object?>{
        'id': child['id']?.toString() ?? 'item_$i',
        'label': child['props'] is Map
            ? coerceObjectMap(child['props'] as Map)['label']?.toString() ??
                  child['type']?.toString() ??
                  'Item'
            : 'Item',
        'control': child,
      });
    }
  }
  if (items.isEmpty) return const SizedBox.shrink();

  final columns = (coerceOptionalInt(props['columns']) ?? 5).clamp(1, 12);
  final spacing = coerceDouble(props['spacing']) ?? 12.0;
  final runSpacing = coerceDouble(props['run_spacing']) ?? spacing;
  final iconSize = coerceDouble(props['icon_size']) ?? 24.0;
  final tileWidth = coerceDouble(props['tile_width']) ?? 92.0;
  final tileHeight = coerceDouble(props['tile_height']) ?? 92.0;
  final selectedId =
      props['selected_id']?.toString() ??
      props['selected']?.toString() ??
      props['value']?.toString();
  final bg =
      coerceColor(props['bgcolor'] ?? props['background']) ??
      (tokens.color('surface') ?? const Color(0xFFFFFFFF)).withValues(alpha: 0.42);
  final border =
      coerceColor(props['border_color']) ??
      (tokens.color('border') ?? const Color(0x22000000));
  final textColor = tokens.color('text') ?? const Color(0xFF0F172A);
  final accent = tokens.color('primary') ?? const Color(0xFF4F46E5);
  final radius =
      coerceDouble(props['radius']) ?? tokens.number('radii', 'md') ?? 14.0;

  final tiles = items.map((item) {
    final id = item['id']?.toString() ?? item['route_id']?.toString() ?? '';
    final label = item['label']?.toString() ?? item['title']?.toString() ?? id;
    final iconName = item['icon']?.toString() ?? 'apps';
    final selected = selectedId != null && selectedId == id;
    return _LauncherTile(
      controlId: controlId,
      item: item,
      icon: _iconFromName(iconName),
      label: label,
      iconSize: iconSize,
      width: tileWidth,
      height: tileHeight,
      radius: radius,
      selected: selected,
      backgroundColor: selected ? accent.withValues(alpha: 0.14) : bg,
      borderColor: selected ? accent : border,
      textColor: selected ? accent : textColor,
      sendEvent: sendEvent,
    );
  }).toList();

  final layout = (props['layout']?.toString() ?? 'grid').toLowerCase();
  if (layout == 'dock') {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tiles
            .map((tile) => Padding(
                  padding: EdgeInsets.only(right: spacing),
                  child: SizedBox(width: tileWidth, height: tileHeight, child: tile),
                ))
            .toList(),
      ),
    );
  }

  return GridView.count(
    crossAxisCount: columns,
    crossAxisSpacing: spacing,
    mainAxisSpacing: runSpacing,
    childAspectRatio: tileWidth <= 0 || tileHeight <= 0
        ? 1.0
        : (tileWidth / tileHeight),
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    children: tiles
        .map((tile) => SizedBox(
              width: tileWidth,
              height: tileHeight,
              child: tile,
            ))
        .toList(),
  );
}

class _LauncherTile extends StatelessWidget {
  final String controlId;
  final Map<String, Object?> item;
  final IconData icon;
  final String label;
  final double iconSize;
  final double width;
  final double height;
  final double radius;
  final bool selected;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final ConduitSendRuntimeEvent sendEvent;

  const _LauncherTile({
    required this.controlId,
    required this.item,
    required this.icon,
    required this.label,
    required this.iconSize,
    required this.width,
    required this.height,
    required this.radius,
    required this.selected,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.sendEvent,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (tileContext) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(radius),
            onTap: () {
              final box = tileContext.findRenderObject() as RenderBox?;
              final topLeft = box?.localToGlobal(Offset.zero) ?? Offset.zero;
              final size = box?.size ?? Size(width, height);
              final payload = <String, Object?>{
                'item': item,
                'id':
                    item['id']?.toString() ??
                    item['route_id']?.toString() ??
                    label,
                'label': label,
                'route_id': item['route_id']?.toString(),
                'source_rect': <String, Object?>{
                  'x': topLeft.dx,
                  'y': topLeft.dy,
                  'width': size.width,
                  'height': size.height,
                },
              };
              if (controlId.isNotEmpty) {
                sendEvent(controlId, 'select', payload);
                sendEvent(controlId, 'launch', payload);
              }
            },
            child: Ink(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(color: borderColor),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(icon, size: iconSize, color: textColor),
                    const SizedBox(height: 8),
                    Text(
                      label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 12,
                        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

IconData _iconFromName(String value) {
  switch (value.toLowerCase().replaceAll('-', '_')) {
    case 'download':
      return Icons.download_rounded;
    case 'apps':
    case 'grid':
      return Icons.apps_rounded;
    case 'settings':
      return Icons.settings_rounded;
    case 'folder':
      return Icons.folder_rounded;
    case 'search':
      return Icons.search_rounded;
    case 'home':
      return Icons.home_rounded;
    case 'terminal':
      return Icons.terminal_rounded;
    case 'code':
      return Icons.code_rounded;
    case 'model':
      return Icons.smart_toy_rounded;
    default:
      return Icons.dashboard_customize_rounded;
  }
}
