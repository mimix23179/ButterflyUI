import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/styling/theme_extension.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildOverlayControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ButterflyUIOverlay(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _ButterflyUIOverlay extends StatefulWidget {
  const _ButterflyUIOverlay({
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
  State<_ButterflyUIOverlay> createState() => _ButterflyUIOverlayState();
}

class _ButterflyUIOverlayState extends State<_ButterflyUIOverlay> {
  Map<String, Object?> _liveProps = const <String, Object?>{};
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _syncFromProps(widget.props);
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _ButterflyUIOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    if (oldWidget.props != widget.props) {
      _syncFromProps(widget.props);
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  void _syncFromProps(Map<String, Object?> props) {
    _liveProps = <String, Object?>{...props};
    _open = _liveProps['open'] == true;
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_open':
        {
          setState(() {
            _open = args['value'] == true || args['open'] == true;
            _liveProps = <String, Object?>{..._liveProps, 'open': _open};
          });
          return _statePayload();
        }
      case 'set_props':
        {
          final incoming = args['props'];
          if (incoming is Map) {
            setState(() {
              _syncFromProps(<String, Object?>{
                ..._liveProps,
                ...coerceObjectMap(incoming),
              });
            });
          }
          return _statePayload();
        }
      case 'get_state':
        return _statePayload();
      case 'emit':
      case 'trigger':
        {
          final fallback = method == 'trigger' ? 'change' : method;
          final event = (args['event'] ?? args['name'] ?? fallback).toString();
          final payload = args['payload'] is Map
              ? coerceObjectMap(args['payload'] as Map)
              : <String, Object?>{};
          _emit(event, payload);
          return true;
        }
      default:
        throw UnsupportedError('Unknown overlay method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      'open': _open,
      'overlay_count': _resolveOverlayMaps().length,
      'active_overlay': _liveProps['active_overlay'] ?? _liveProps['active_id'],
      'active_index': coerceOptionalInt(_liveProps['active_index']),
      'show_all_overlays': _liveProps['show_all_overlays'] == true,
    };
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) {
      return;
    }
    widget.sendEvent(widget.controlId, event, payload);
  }

  List<Map<String, Object?>> _rawChildMaps() {
    return widget.rawChildren
        .whereType<Map>()
        .map(coerceObjectMap)
        .toList(growable: false);
  }

  Map<String, Object?>? _resolveBaseMap() {
    final base = _liveProps['base'];
    if (base is Map) {
      return coerceObjectMap(base);
    }
    final children = _rawChildMaps();
    if (children.length > 1) {
      return children.first;
    }
    return null;
  }

  List<Map<String, Object?>> _resolveOverlayMaps() {
    final overlays = <Map<String, Object?>>[];
    final rawOverlays = _liveProps['overlays'];
    if (rawOverlays is List) {
      for (final raw in rawOverlays) {
        if (raw is Map) {
          overlays.add(coerceObjectMap(raw));
        }
      }
    }
    if (overlays.isNotEmpty) {
      return overlays;
    }
    final childMaps = _rawChildMaps();
    if (childMaps.length > 1) {
      return childMaps.sublist(1);
    }
    if (childMaps.length == 1 && _resolveBaseMap() == null) {
      return childMaps;
    }
    return const <Map<String, Object?>>[];
  }

  Set<String> _activeIds() {
    final active = <String>{};
    final raw = _liveProps['active_overlay'] ?? _liveProps['active_id'];
    if (raw is List) {
      for (final value in raw) {
        final text = value?.toString();
        if (text != null && text.isNotEmpty) {
          active.add(text);
        }
      }
    } else if (raw != null) {
      final text = raw.toString();
      if (text.isNotEmpty) {
        active.add(text);
      }
    }
    return active;
  }

  List<Map<String, Object?>> _visibleOverlays() {
    final overlays = _resolveOverlayMaps();
    if (overlays.isEmpty) {
      return const <Map<String, Object?>>[];
    }
    if (_liveProps['show_all_overlays'] == true) {
      final limit = coerceOptionalInt(_liveProps['max_visible_overlays']);
      return limit == null
          ? overlays
          : overlays.take(limit).toList(growable: false);
    }
    final activeIds = _activeIds();
    if (activeIds.isNotEmpty) {
      final matches = overlays
          .where((overlay) {
            final overlayId =
                overlay['id']?.toString() ?? overlay['key']?.toString() ?? '';
            return activeIds.contains(overlayId);
          })
          .toList(growable: false);
      if (matches.isNotEmpty) {
        return matches;
      }
    }
    final activeIndex = coerceOptionalInt(_liveProps['active_index']);
    if (activeIndex != null &&
        activeIndex >= 0 &&
        activeIndex < overlays.length) {
      return <Map<String, Object?>>[overlays[activeIndex]];
    }
    if (_liveProps['show_default_overlay'] == true || activeIds.isEmpty) {
      return <Map<String, Object?>>[overlays.first];
    }
    return const <Map<String, Object?>>[];
  }

  Alignment _coerceAlignment(Object? raw) {
    final key = raw?.toString().toLowerCase().trim();
    switch (key) {
      case 'top':
      case 'top_center':
        return Alignment.topCenter;
      case 'bottom':
      case 'bottom_center':
        return Alignment.bottomCenter;
      case 'left':
      case 'center_left':
        return Alignment.centerLeft;
      case 'right':
      case 'center_right':
        return Alignment.centerRight;
      case 'top_left':
        return Alignment.topLeft;
      case 'top_right':
        return Alignment.topRight;
      case 'bottom_left':
        return Alignment.bottomLeft;
      case 'bottom_right':
        return Alignment.bottomRight;
      default:
        return Alignment.center;
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseMap = _resolveBaseMap();
    final overlays = _visibleOverlays();
    final base = baseMap == null
        ? const SizedBox.shrink()
        : widget.buildChild(baseMap);
    if (!_open) {
      return base;
    }

    final dismissible =
        _liveProps['dismissible'] == null || _liveProps['dismissible'] == true;
    final tokens = Theme.of(context).extension<ButterflyUIThemeTokens>();
    final scrim =
        coerceColor(_liveProps['scrim_color']) ??
        tokens?.overlayScrim ??
        Colors.black.withValues(alpha: 0.35);
    final alignment = _coerceAlignment(_liveProps['alignment']);
    final clip = _liveProps['clip'] == true ? Clip.antiAlias : Clip.none;

    return Stack(
      clipBehavior: clip,
      fit: StackFit.expand,
      children: [
        base,
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: dismissible
              ? () {
                  setState(() {
                    _open = false;
                    _liveProps = <String, Object?>{
                      ..._liveProps,
                      'open': false,
                    };
                  });
                  _emit('dismiss', _statePayload());
                  _emit('close', _statePayload());
                }
              : null,
          child: ColoredBox(color: scrim),
        ),
        ...overlays.map(
          (overlay) =>
              Align(alignment: alignment, child: widget.buildChild(overlay)),
        ),
      ],
    );
  }
}
