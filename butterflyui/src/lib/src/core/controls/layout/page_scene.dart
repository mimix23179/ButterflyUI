import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

Widget buildPageSceneControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
) {
  Map<String, Object?>? layerFromProp(String key) {
    final raw = props[key];
    if (raw is Map) return coerceObjectMap(raw);
    return null;
  }

  final backgroundLayer = layerFromProp('background_layer');
  final ambientLayer = layerFromProp('ambient_layer');
  final heroLayer = layerFromProp('hero_layer');
  final contentLayer = layerFromProp('content_layer');
  final overlayLayer = layerFromProp('overlay_layer');

  final fallbackChildren = rawChildren
      .whereType<Map>()
      .map(coerceObjectMap)
      .toList();

  Map<String, Object?>? childAt(int index) {
    if (index < 0 || index >= fallbackChildren.length) return null;
    return fallbackChildren[index];
  }

  final resolvedBackground = backgroundLayer ?? childAt(0);
  final resolvedAmbient = ambientLayer ?? childAt(1);
  final resolvedHero = heroLayer ?? childAt(2);
  final resolvedContent = contentLayer ?? childAt(3) ?? childAt(0);
  final resolvedOverlay = overlayLayer ?? childAt(4);

  final clipBehavior = props['clip'] == true ? Clip.antiAlias : Clip.none;
  final expand = props['expand'] == null ? true : (props['expand'] == true);
  final alignment =
      _parseAlignment(props['content_alignment']) ?? Alignment.center;

  final pages = _coercePageLayers(props['pages']);
  final activePage = _resolveActivePage(props, pages, resolvedContent);
  final content = activePage == null
      ? const SizedBox.shrink()
      : _buildPageTransition(
          props: props,
          keyToken: _pageIdentity(activePage),
          child: buildChild(activePage),
        );

  final stack = Stack(
    clipBehavior: clipBehavior,
    fit: expand ? StackFit.expand : StackFit.loose,
    children: <Widget>[
      if (resolvedBackground != null)
        Positioned.fill(child: buildChild(resolvedBackground)),
      if (resolvedAmbient != null)
        Positioned.fill(
          child: IgnorePointer(
            child: Opacity(
              opacity: coerceDouble(props['ambient_opacity']) ?? 1.0,
              child: buildChild(resolvedAmbient),
            ),
          ),
        ),
      Align(alignment: alignment, child: content),
      if (resolvedHero != null)
        Positioned.fill(
          child: IgnorePointer(
            child: Align(
              alignment:
                  _parseAlignment(props['hero_alignment']) ??
                  Alignment.topCenter,
              child: buildChild(resolvedHero),
            ),
          ),
        ),
      if (resolvedOverlay != null)
        Positioned.fill(child: buildChild(resolvedOverlay)),
    ],
  );

  final padding = coercePadding(props['content_padding']);
  if (padding != null) {
    return Padding(padding: padding, child: stack);
  }
  return stack;
}

Widget _buildPageTransition({
  required Map<String, Object?> props,
  required String keyToken,
  required Widget child,
}) {
  final transitionRaw = props['transition'];
  final transition = transitionRaw is Map
      ? coerceObjectMap(transitionRaw)
      : <String, Object?>{};
  final transitionType =
      (props['transition_type']?.toString() ??
              transition['type']?.toString() ??
              'fade')
          .toLowerCase()
          .replaceAll('-', '_')
          .trim();
  if (transitionType == 'none' || transitionType == 'off') {
    return child;
  }

  final durationMs =
      coerceOptionalInt(transition['duration_ms'] ?? props['transition_ms']) ??
      260;
  final duration = Duration(milliseconds: durationMs.clamp(0, 4000));
  final curveName = (transition['curve']?.toString() ?? 'easeOutCubic')
      .toLowerCase();
  final curve = _curveFromName(curveName);

  return AnimatedSwitcher(
    duration: duration,
    switchInCurve: curve,
    switchOutCurve: Curves.easeInCubic,
    transitionBuilder: (animatedChild, animation) {
      final curved = CurvedAnimation(parent: animation, curve: curve);
      switch (transitionType) {
        case 'slide':
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.05, 0),
              end: Offset.zero,
            ).animate(curved),
            child: FadeTransition(opacity: curved, child: animatedChild),
          );
        case 'scale':
        case 'pop':
          return ScaleTransition(
            scale: Tween<double>(begin: 0.96, end: 1.0).animate(curved),
            child: FadeTransition(opacity: curved, child: animatedChild),
          );
        case 'fade':
        default:
          return FadeTransition(opacity: curved, child: animatedChild);
      }
    },
    child: KeyedSubtree(key: ValueKey<String>(keyToken), child: child),
  );
}

Map<String, Object?>? _resolveActivePage(
  Map<String, Object?> props,
  List<Map<String, Object?>> pages,
  Map<String, Object?>? resolvedContent,
) {
  final activeToken =
      props['active_page'] ??
      props['active_id'] ??
      props['page'] ??
      props['value'];
  if (activeToken == null) {
    return resolvedContent ?? (pages.isNotEmpty ? pages.first : null);
  }

  final activeIndex = coerceOptionalInt(activeToken);
  if (activeIndex != null) {
    if (activeIndex <= 0) {
      return resolvedContent ?? (pages.isNotEmpty ? pages.first : null);
    }
    final indexInPages = activeIndex - 1;
    if (indexInPages >= 0 && indexInPages < pages.length) {
      return pages[indexInPages];
    }
    return resolvedContent ?? (pages.isNotEmpty ? pages.last : null);
  }

  final activeId = activeToken.toString().trim();
  if (activeId.isEmpty ||
      activeId == 'main' ||
      activeId == 'content' ||
      activeId == 'root') {
    return resolvedContent ?? (pages.isNotEmpty ? pages.first : null);
  }

  for (final page in pages) {
    if (_pageIdentity(page) == activeId) {
      return page;
    }
  }
  return resolvedContent ?? (pages.isNotEmpty ? pages.first : null);
}

List<Map<String, Object?>> _coercePageLayers(Object? raw) {
  final out = <Map<String, Object?>>[];
  if (raw is! List) return out;
  for (final item in raw) {
    if (item is Map) out.add(coerceObjectMap(item));
  }
  return out;
}

String _pageIdentity(Map<String, Object?> page) {
  final props = page['props'] is Map
      ? coerceObjectMap(page['props'] as Map)
      : const <String, Object?>{};
  final candidates = <Object?>[
    page['id'],
    page['page_id'],
    page['route_id'],
    props['page_id'],
    props['route_id'],
    props['id'],
  ];
  for (final candidate in candidates) {
    final value = candidate?.toString().trim() ?? '';
    if (value.isNotEmpty) return value;
  }
  return page.hashCode.toString();
}

Curve _curveFromName(String name) {
  switch (name) {
    case 'linear':
      return Curves.linear;
    case 'easein':
    case 'ease_in':
      return Curves.easeIn;
    case 'easeout':
    case 'ease_out':
      return Curves.easeOut;
    case 'easeinout':
    case 'ease_in_out':
      return Curves.easeInOut;
    case 'fastoutslowin':
    case 'fast_out_slow_in':
      return Curves.fastOutSlowIn;
    case 'easeoutcubic':
    case 'ease_out_cubic':
    default:
      return Curves.easeOutCubic;
  }
}

Alignment? _parseAlignment(Object? value) {
  if (value == null) return null;
  if (value is List && value.length >= 2) {
    return Alignment(
      coerceDouble(value[0]) ?? 0.0,
      coerceDouble(value[1]) ?? 0.0,
    );
  }
  if (value is Map) {
    final map = coerceObjectMap(value);
    return Alignment(
      coerceDouble(map['x']) ?? 0.0,
      coerceDouble(map['y']) ?? 0.0,
    );
  }
  switch (value.toString().toLowerCase().replaceAll('-', '_')) {
    case 'center':
      return Alignment.center;
    case 'top_left':
      return Alignment.topLeft;
    case 'top_center':
    case 'top':
      return Alignment.topCenter;
    case 'top_right':
      return Alignment.topRight;
    case 'center_left':
    case 'left':
      return Alignment.centerLeft;
    case 'center_right':
    case 'right':
      return Alignment.centerRight;
    case 'bottom_left':
      return Alignment.bottomLeft;
    case 'bottom_center':
    case 'bottom':
      return Alignment.bottomCenter;
    case 'bottom_right':
      return Alignment.bottomRight;
    default:
      return null;
  }
}
