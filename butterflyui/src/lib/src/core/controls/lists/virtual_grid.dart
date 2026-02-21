import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildVirtualGridControl(
  String controlId,
  Map<String, Object?> props,
  List rawChildren,
  Widget Function(Map<String, Object?> child) buildFromControl,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return ButterflyUIVirtualGrid(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildFromControl: buildFromControl,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class ButterflyUIVirtualGrid extends StatefulWidget {
  final String controlId;
  final Map<String, Object?> props;
  final List rawChildren;
  final Widget Function(Map<String, Object?> child) buildFromControl;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUIVirtualGrid({
    super.key,
    required this.controlId,
    required this.props,
    required this.rawChildren,
    required this.buildFromControl,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<ButterflyUIVirtualGrid> createState() => _ButterflyUIVirtualGridState();
}

class _ButterflyUIVirtualGridState extends State<ButterflyUIVirtualGrid> {
  late final ScrollController _controller;
  int _lastPrefetchMarker = -1;

  @override
  void initState() {
    super.initState();
    final initialOffset = coerceDouble(widget.props['initial_offset']) ?? 0.0;
    _controller = ScrollController(initialScrollOffset: initialOffset);
    _controller.addListener(_maybeEmitPrefetch);
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant ButterflyUIVirtualGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    final oldLength = _resolveItemCount(oldWidget.props, oldWidget.rawChildren);
    final nextLength = _resolveItemCount(widget.props, widget.rawChildren);
    if (nextLength != oldLength) {
      _lastPrefetchMarker = -1;
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    _controller
      ..removeListener(_maybeEmitPrefetch)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final childMaps = _coerceChildMaps(widget.rawChildren);
    final items = _coerceItems(widget.props['items']);
    final itemCount = childMaps.isNotEmpty ? childMaps.length : items.length;

    final columns =
        (coerceOptionalInt(
                  widget.props['columns'] ?? widget.props['cross_axis_count'],
                ) ??
                2)
            .clamp(1, 12);
    final spacing = coerceDouble(widget.props['spacing']) ?? 8;
    final runSpacing = coerceDouble(widget.props['run_spacing']) ?? spacing;
    final childAspectRatio =
        coerceDouble(widget.props['child_aspect_ratio']) ?? 1.0;
    final reverse = widget.props['reverse'] == true;
    final shrinkWrap = widget.props['shrink_wrap'] == true;
    final padding = coercePadding(
      widget.props['content_padding'] ?? widget.props['padding'],
    );
    final scrollable = widget.props['scrollable'] == null
        ? true
        : (widget.props['scrollable'] == true);

    final loading = widget.props['loading'] == true;
    final skeletonCount =
        (coerceOptionalInt(widget.props['skeleton_count']) ?? columns).clamp(
          1,
          48,
        );
    final totalCount =
        itemCount + (loading && itemCount > 0 ? skeletonCount : 0);

    return GridView.builder(
      controller: _controller,
      reverse: reverse,
      shrinkWrap: shrinkWrap,
      padding: padding,
      physics: scrollable
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: spacing,
        mainAxisSpacing: runSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: totalCount,
      itemBuilder: (context, index) {
        if (index >= itemCount) {
          return const Card(
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        if (childMaps.isNotEmpty) {
          return widget.buildFromControl(childMaps[index]);
        }
        final item = items[index];
        if (item is Map) {
          final map = coerceObjectMap(item);
          if (map.containsKey('type')) {
            return widget.buildFromControl(map);
          }
          final title =
              (map['title'] ??
                      map['label'] ??
                      map['text'] ??
                      map['id'] ??
                      index)
                  .toString();
          final enabled = map['enabled'] == null
              ? true
              : (map['enabled'] == true);
          return Card(
            child: InkWell(
              onTap: enabled
                  ? () {
                      if (widget.controlId.isEmpty) return;
                      widget.sendEvent(widget.controlId, 'select', {
                        'index': index,
                        'id': map['id']?.toString() ?? title,
                        'item': map,
                      });
                    }
                  : null,
              child: Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          );
        }
        return Card(child: Center(child: Text(item?.toString() ?? '')));
      },
    );
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    if (!_controller.hasClients) {
      throw StateError('VirtualGrid has no attached ScrollPosition');
    }
    final position = _controller.position;
    switch (method) {
      case 'get_scroll_metrics':
        return <String, Object?>{
          'pixels': position.pixels,
          'min_scroll_extent': position.minScrollExtent,
          'max_scroll_extent': position.maxScrollExtent,
          'viewport_dimension': position.viewportDimension,
          'axis': 'vertical',
          'at_start': position.pixels <= position.minScrollExtent + 0.5,
          'at_end': position.pixels >= position.maxScrollExtent - 0.5,
        };
      case 'scroll_to':
        final offset = coerceDouble(args['offset'] ?? args['pixels']) ?? 0.0;
        await _controller.animateTo(
          offset.clamp(position.minScrollExtent, position.maxScrollExtent),
          duration: Duration(
            milliseconds: coerceOptionalInt(args['duration_ms']) ?? 220,
          ),
          curve: Curves.easeOut,
        );
        return null;
      case 'scroll_to_start':
        await _controller.animateTo(
          position.minScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
        return null;
      case 'scroll_to_end':
        await _controller.animateTo(
          position.maxScrollExtent,
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOut,
        );
        return null;
      default:
        throw UnsupportedError('Unknown virtual_grid method: $method');
    }
  }

  void _maybeEmitPrefetch() {
    if (widget.controlId.isEmpty) return;
    if (!_controller.hasClients) return;
    if (widget.props['has_more'] != true) return;

    final childMaps = _coerceChildMaps(widget.rawChildren);
    final items = _coerceItems(widget.props['items']);
    final itemCount = childMaps.isNotEmpty ? childMaps.length : items.length;
    if (itemCount <= 0) return;

    final columns = (coerceOptionalInt(widget.props['columns']) ?? 2).clamp(
      1,
      12,
    );
    final threshold =
        (coerceOptionalInt(widget.props['prefetch_threshold']) ?? 2).clamp(
          1,
          50,
        );
    final position = _controller.position;
    final extentPerRow = 220.0;
    final visibleRows =
        ((position.pixels + position.viewportDimension) / extentPerRow).floor();
    final visibleItems = visibleRows * columns;
    final remaining = itemCount - visibleItems;
    if (remaining > threshold * columns) return;
    if (_lastPrefetchMarker == itemCount) return;

    _lastPrefetchMarker = itemCount;
    widget.sendEvent(widget.controlId, 'prefetch', {
      'total_items': itemCount,
      'visible_items': visibleItems.clamp(0, itemCount),
      'remaining': remaining,
      'threshold': threshold,
    });
  }

  int _resolveItemCount(Map<String, Object?> props, List children) {
    final childMaps = _coerceChildMaps(children);
    if (childMaps.isNotEmpty) return childMaps.length;
    final items = props['items'];
    if (items is List) return items.length;
    return 0;
  }
}

List<Map<String, Object?>> _coerceChildMaps(List rawChildren) {
  final out = <Map<String, Object?>>[];
  for (final child in rawChildren) {
    if (child is Map) {
      out.add(coerceObjectMap(child));
    }
  }
  return out;
}

List<Object?> _coerceItems(Object? raw) {
  if (raw is List) return raw.cast<Object?>();
  return const <Object?>[];
}
