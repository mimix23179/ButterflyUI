import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/motion/motion_pack.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class _RouteSpec {
  final String id;
  final String title;
  final Map<String, Object?>? child;

  const _RouteSpec({
    required this.id,
    required this.title,
    required this.child,
  });
}

class _ClampedAnimation extends Animation<double>
    with AnimationWithParentMixin<double> {
  _ClampedAnimation(this.parent);

  @override
  final Animation<double> parent;

  @override
  double get value {
    final raw = parent.value;
    if (raw.isNaN) return 0.0;
    return raw.clamp(0.0, 1.0).toDouble();
  }
}

Widget buildRouteViewControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
) {
  final children = <Widget>[];
  for (final raw in rawChildren) {
    if (raw is Map) {
      children.add(buildChild(coerceObjectMap(raw)));
    }
  }

  final propChildren = props['children'];
  if (children.isEmpty && propChildren is List) {
    for (final raw in propChildren) {
      if (raw is Map) {
        children.add(buildChild(coerceObjectMap(raw)));
      }
    }
  }

  final rawChild = props['child'];
  if (children.isEmpty && rawChild is Map) {
    children.add(buildChild(coerceObjectMap(rawChild)));
  }

  if (children.isEmpty) return const SizedBox.shrink();
  if (children.length == 1) return children.first;

  final layout = (props['layout'] ?? props['child_layout'] ?? 'column')
      .toString()
      .toLowerCase();
  final spacing = coerceDouble(props['spacing']) ?? 0.0;

  switch (layout) {
    case 'row':
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _withSpacing(children, spacing, Axis.horizontal),
      );
    case 'stack':
      return Stack(children: children);
    case 'wrap':
      return Wrap(spacing: spacing, runSpacing: spacing, children: children);
    case 'column':
    default:
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _withSpacing(children, spacing, Axis.vertical),
      );
  }
}

List<Widget> _withSpacing(List<Widget> children, double spacing, Axis axis) {
  if (spacing <= 0 || children.length <= 1) return children;
  final out = <Widget>[];
  for (var index = 0; index < children.length; index += 1) {
    if (index > 0) {
      out.add(
        axis == Axis.horizontal
            ? SizedBox(width: spacing)
            : SizedBox(height: spacing),
      );
    }
    out.add(children[index]);
  }
  return out;
}

Widget buildRouteControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ButterflyUIRouteControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _ButterflyUIRouteControl extends StatefulWidget {
  const _ButterflyUIRouteControl({
    required this.controlId,
    required this.props,
    required this.rawChildren,
    required this.buildChild,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final List<dynamic> rawChildren;
  final Widget Function(Map<String, Object?> child) buildChild;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_ButterflyUIRouteControl> createState() =>
      _ButterflyUIRouteControlState();
}

class _ButterflyUIRouteControlState extends State<_ButterflyUIRouteControl> {
  String? _routeId;
  String? _lastEmittedRouteId;
  DateTime? _lastRouteEmitAt;

  @override
  void initState() {
    super.initState();
    _routeId = widget.props['route_id']?.toString();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _ButterflyUIRouteControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    final nextRouteId = widget.props['route_id']?.toString();
    if (nextRouteId != _routeId) {
      _routeId = nextRouteId;
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method.trim().toLowerCase()) {
      case 'set_route_id':
      case 'set_route':
        final next = args['route_id']?.toString() ?? args['id']?.toString();
        if (next == null || next.isEmpty) {
          return {'ok': false};
        }
        setState(() {
          _routeId = next;
        });
        _emitRouteChange(next);
        return {'ok': true, 'route_id': _routeId};
      case 'get_state':
        return {'route_id': _routeId};
      case 'emit':
        final event = (args['event'] ?? 'route_event').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        if (widget.controlId.isNotEmpty) {
          widget.sendEvent(widget.controlId, event, payload);
        }
        return true;
      default:
        throw Exception('Unknown route invoke method: $method');
    }
  }

  void _emitRouteChange(String routeId) {
    if (widget.controlId.isEmpty) return;
    final now = DateTime.now();
    final throttleMs =
        (coerceOptionalInt(widget.props['route_event_throttle_ms']) ?? 48)
            .clamp(0, 1000);
    if (throttleMs > 0 &&
        _lastEmittedRouteId == routeId &&
        _lastRouteEmitAt != null &&
        now.difference(_lastRouteEmitAt!).inMilliseconds < throttleMs) {
      return;
    }
    _lastEmittedRouteId = routeId;
    _lastRouteEmitAt = now;
    widget.sendEvent(widget.controlId, 'change', {'route_id': routeId});
    if (widget.props['emit_route_change_alias'] == true) {
      widget.sendEvent(widget.controlId, 'route_change', {'route_id': routeId});
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildRouteViewControl(
      widget.props,
      widget.rawChildren,
      widget.buildChild,
    );
  }
}

Widget buildRouterControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
  Map<String, Object?> motionPack,
) {
  return _ButterflyUIRouter(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
    motionPack: motionPack,
  );
}

class _ButterflyUIRouter extends StatefulWidget {
  final String controlId;
  final Map<String, Object?> props;
  final List<dynamic> rawChildren;
  final Widget Function(Map<String, Object?> child) buildChild;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;
  final Map<String, Object?> motionPack;

  const _ButterflyUIRouter({
    required this.controlId,
    required this.props,
    required this.rawChildren,
    required this.buildChild,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
    required this.motionPack,
  });

  @override
  State<_ButterflyUIRouter> createState() => _ButterflyUIRouterState();
}

class _ButterflyUIRouterState extends State<_ButterflyUIRouter> {
  String? _activeId;
  final Set<String> _visitedRoutes = <String>{};
  String? _lastEmittedRouteId;
  DateTime? _lastRouteEmitAt;

  @override
  void initState() {
    super.initState();
    final routes = _parseRoutes();
    _activeId =
        _resolveExplicitActive(widget.props, routes) ??
        _resolveFallbackActive(routes);
    if (_activeId != null && _activeId!.isNotEmpty) {
      _visitedRoutes.add(_activeId!);
    }
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _ButterflyUIRouter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    final routes = _parseRoutes();
    final explicit = _resolveExplicitActive(widget.props, routes);
    if (explicit != null) {
      if (explicit != _activeId) {
        _activeId = explicit;
        _visitedRoutes.add(explicit);
      }
    } else {
      final fallback = _resolveFallbackActive(routes);
      final exists = routes.any((route) => route.id == _activeId);
      if (!exists && fallback != _activeId) {
        _activeId = fallback;
        _visitedRoutes.add(fallback);
      }
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    final normalized = method.trim().toLowerCase();
    if (normalized == 'go_to' ||
        normalized == 'navigate' ||
        normalized == 'set_route') {
      final requested = args['route_id']?.toString() ?? args['id']?.toString();
      if (requested != null && requested.isNotEmpty) {
        _setRoute(requested);
        return <String, Object?>{'ok': true, 'active': _activeId};
      }
      final index = coerceOptionalInt(args['index']);
      final routes = _parseRoutes();
      if (index != null && index >= 0 && index < routes.length) {
        _setRoute(routes[index].id);
        return <String, Object?>{'ok': true, 'active': _activeId};
      }
      return <String, Object?>{'ok': false};
    }
    if (normalized == 'active_route' || normalized == 'get_active') {
      return <String, Object?>{'active': _activeId};
    }
    throw Exception('Unknown router invoke method: $method');
  }

  void _setRoute(String id) {
    if (id == _activeId) return;
    setState(() {
      _activeId = id;
      _visitedRoutes.add(id);
    });
    _emitRouteChange(id);
  }

  void _emitRouteChange(String routeId) {
    if (widget.controlId.isEmpty) return;
    final now = DateTime.now();
    final throttleMs =
        (coerceOptionalInt(widget.props['route_event_throttle_ms']) ?? 48)
            .clamp(0, 1000);
    if (throttleMs > 0 &&
        _lastEmittedRouteId == routeId &&
        _lastRouteEmitAt != null &&
        now.difference(_lastRouteEmitAt!).inMilliseconds < throttleMs) {
      return;
    }
    _lastEmittedRouteId = routeId;
    _lastRouteEmitAt = now;
    widget.sendEvent(widget.controlId, 'change', <String, Object?>{
      'route_id': routeId,
    });
    if (widget.props['emit_route_change_alias'] == true) {
      widget.sendEvent(widget.controlId, 'route_change', <String, Object?>{
        'route_id': routeId,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final routes = _parseRoutes();
    if (routes.isEmpty) return const SizedBox.shrink();
    final activeId =
        _resolveExplicitActive(widget.props, routes) ??
        (routes.any((route) => route.id == _activeId)
            ? _activeId!
            : _resolveFallbackActive(routes));
    _RouteSpec active = routes.first;
    for (final route in routes) {
      if (route.id == activeId) {
        active = route;
        break;
      }
    }

    final motion = ButterflyUIMotionPack.resolve(
      widget.props['motion'] ??
          (widget.props['transition'] is Map
              ? coerceObjectMap(widget.props['transition'] as Map)
              : widget.props['transition']),
      pack: widget.motionPack,
      fallbackName: 'route_enter',
    );
    final transitionType =
        (widget.props['transition_type']?.toString() ??
                (widget.props['transition'] is Map
                    ? coerceObjectMap(
                        widget.props['transition'] as Map,
                      )['type']?.toString()
                    : null) ??
                'pop_from_rect')
            .toLowerCase();
    final sourceRect = _coerceRect(
      widget.props['source_rect'] ??
          (widget.props['transition'] is Map
              ? coerceObjectMap(widget.props['transition'] as Map)['origin']
              : null),
    );
    final showTabs = widget.props['show_tabs'] == true;
    final keepAlive = widget.props['keep_alive'] == null
        ? false
        : (widget.props['keep_alive'] == true);

    return LayoutBuilder(
      builder: (context, constraints) {
        final viewport = Size(constraints.maxWidth, constraints.maxHeight);
        final lightweightTransitions =
            widget.props['lightweight_transitions'] == null
            ? true
            : (widget.props['lightweight_transitions'] == true);
        final activeIndex = routes.indexWhere((route) => route.id == active.id);

        Widget transition;
        if (keepAlive) {
          // Keep route elements alive to avoid tearing down heavy controls
          // (e.g., WebView) on every route switch.
          transition = IndexedStack(
            index: activeIndex < 0 ? 0 : activeIndex,
            children: routes
                .map((route) {
                  final shouldBuild =
                      route.id == active.id ||
                      _visitedRoutes.contains(route.id);
                  final routeChild = !shouldBuild || route.child == null
                      ? const SizedBox.shrink()
                      : widget.buildChild(route.child!);
                  return KeyedSubtree(
                    key: ValueKey<String>('route:${route.id}'),
                    child: routeChild,
                  );
                })
                .toList(growable: false),
          );
        } else {
          final child = active.child == null
              ? const SizedBox.shrink()
              : KeyedSubtree(
                  key: ValueKey<String>(active.id),
                  child: widget.buildChild(active.child!),
                );
          transition = AnimatedSwitcher(
            duration: motion.duration,
            switchInCurve: motion.curve,
            switchOutCurve: Curves.easeOutCubic,
            layoutBuilder: (currentChild, previousChildren) {
              if (lightweightTransitions) {
                return currentChild ?? const SizedBox.shrink();
              }
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  ...previousChildren,
                  if (currentChild != null) currentChild,
                ],
              );
            },
            transitionBuilder: (child, animation) {
              return _buildTransition(
                transitionType: transitionType,
                animation: animation,
                child: child,
                motion: motion,
                sourceRect: sourceRect,
                viewport: viewport,
              );
            },
            child: child,
          );
        }

        if (!showTabs) return transition;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: routes.map((route) {
                final selected = route.id == active.id;
                return ChoiceChip(
                  label: Text(route.title),
                  selected: selected,
                  onSelected: (_) => _setRoute(route.id),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Expanded(child: transition),
          ],
        );
      },
    );
  }

  Widget _buildTransition({
    required String transitionType,
    required Animation<double> animation,
    required Widget child,
    required ButterflyUIMotionSpec motion,
    required Rect? sourceRect,
    required Size viewport,
  }) {
    final bounded = _ClampedAnimation(animation);
    final curved = CurvedAnimation(parent: bounded, curve: motion.curve);
    switch (transitionType) {
      case 'fade':
        return FadeTransition(opacity: curved, child: child);
      case 'slide':
        return SlideTransition(
          position: Tween<Offset>(
            begin: motion.beginOffset.translate(0.0, 0.02),
            end: motion.endOffset,
          ).animate(curved),
          child: FadeTransition(opacity: curved, child: child),
        );
      case 'zoom':
      case 'pop':
      case 'pop_from_rect':
        final alignment = transitionType == 'pop_from_rect'
            ? _alignmentFromRect(sourceRect, viewport)
            : Alignment.center;
        final startScale = motion.beginScale <= 0 ? 0.96 : motion.beginScale;
        return ScaleTransition(
          alignment: alignment,
          scale: Tween<double>(
            begin: startScale,
            end: motion.overshoot > 1.0 ? motion.overshoot : 1.0,
          ).animate(curved),
          child: FadeTransition(opacity: curved, child: child),
        );
      case 'glass_sheet':
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.08),
            end: Offset.zero,
          ).animate(curved),
          child: FadeTransition(opacity: curved, child: child),
        );
      default:
        return FadeTransition(opacity: curved, child: child);
    }
  }

  List<_RouteSpec> _parseRoutes() {
    final routes = <_RouteSpec>[];
    final rawRoutes = widget.props['routes'];
    if (rawRoutes is List) {
      for (var i = 0; i < rawRoutes.length; i += 1) {
        final item = rawRoutes[i];
        if (item is! Map) continue;
        final map = coerceObjectMap(item);
        final id =
            map['id']?.toString() ??
            map['route_id']?.toString() ??
            map['name']?.toString() ??
            'route_$i';
        final title =
            map['title']?.toString() ?? map['label']?.toString() ?? id;
        Map<String, Object?>? child;
        if (map['child'] is Map) {
          child = coerceObjectMap(map['child'] as Map);
        } else if (map['content'] is Map) {
          child = coerceObjectMap(map['content'] as Map);
        }
        routes.add(_RouteSpec(id: id, title: title, child: child));
      }
    }

    for (var i = 0; i < widget.rawChildren.length; i += 1) {
      final raw = widget.rawChildren[i];
      if (raw is! Map) continue;
      final child = coerceObjectMap(raw);
      final type = child['type']?.toString().toLowerCase();
      if (type != 'route_view' && type != 'route_host' && type != 'route') {
        continue;
      }
      final props = child['props'] is Map
          ? coerceObjectMap(child['props'] as Map)
          : <String, Object?>{};
      final id =
          props['route_id']?.toString() ??
          props['id']?.toString() ??
          child['id']?.toString() ??
          'route_$i';
      final title =
          props['title']?.toString() ?? props['label']?.toString() ?? id;
      Map<String, Object?>? routeChild = child;
      routes.add(_RouteSpec(id: id, title: title, child: routeChild));
    }
    return routes;
  }

  String _resolveActive(Map<String, Object?> props, List<_RouteSpec> routes) {
    if (routes.isEmpty) return '';
    final active =
        props['active']?.toString() ??
        props['active_route']?.toString() ??
        props['route']?.toString() ??
        props['value']?.toString();
    if (active != null && active.isNotEmpty) {
      for (final route in routes) {
        if (route.id == active) return route.id;
      }
    }
    final index = coerceOptionalInt(props['index']);
    if (index != null && index >= 0 && index < routes.length) {
      return routes[index].id;
    }
    return routes.first.id;
  }

  String _resolveFallbackActive(List<_RouteSpec> routes) {
    if (routes.isEmpty) return '';
    return routes.first.id;
  }

  String? _resolveExplicitActive(
    Map<String, Object?> props,
    List<_RouteSpec> routes,
  ) {
    final hasExplicitRouteKey =
        props.containsKey('active') ||
        props.containsKey('active_route') ||
        props.containsKey('route') ||
        props.containsKey('value');
    if (hasExplicitRouteKey) {
      final resolved = _resolveActive(props, routes);
      if (resolved.isNotEmpty) return resolved;
    }
    if (props.containsKey('index')) {
      final resolved = _resolveActive(props, routes);
      if (resolved.isNotEmpty) return resolved;
    }
    return null;
  }

  Rect? _coerceRect(Object? value) {
    if (value is List && value.length >= 4) {
      final x = coerceDouble(value[0]) ?? 0.0;
      final y = coerceDouble(value[1]) ?? 0.0;
      final w = coerceDouble(value[2]) ?? 0.0;
      final h = coerceDouble(value[3]) ?? 0.0;
      return Rect.fromLTWH(x, y, w, h);
    }
    if (value is Map) {
      final map = coerceObjectMap(value);
      final x = coerceDouble(map['x'] ?? map['left']) ?? 0.0;
      final y = coerceDouble(map['y'] ?? map['top']) ?? 0.0;
      final w = coerceDouble(map['width']) ?? 0.0;
      final h = coerceDouble(map['height']) ?? 0.0;
      if (w > 0 && h > 0) return Rect.fromLTWH(x, y, w, h);
    }
    return null;
  }

  Alignment _alignmentFromRect(Rect? rect, Size viewport) {
    if (rect == null) return Alignment.center;
    if (viewport.width <= 0 || viewport.height <= 0) return Alignment.center;
    final center = rect.center;
    final dx = ((center.dx / viewport.width) * 2 - 1).clamp(-1.0, 1.0);
    final dy = ((center.dy / viewport.height) * 2 - 1).clamp(-1.0, 1.0);
    return Alignment(dx, dy);
  }
}
