import 'package:flutter/material.dart';

import 'package:conduit_runtime/src/core/control_utils.dart';
import 'package:conduit_runtime/src/core/webview/webview_api.dart';

Widget buildVirtualListControl(
  String controlId,
  Map<String, Object?> props,
  List rawChildren,
  Widget Function(Map<String, Object?> child) buildFromControl,
  ConduitRegisterInvokeHandler registerInvokeHandler,
  ConduitUnregisterInvokeHandler unregisterInvokeHandler,
  ConduitSendRuntimeEvent sendEvent,
) {
  return ConduitVirtualList(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildFromControl: buildFromControl,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class ConduitVirtualList extends StatefulWidget {
  final String controlId;
  final Map<String, Object?> props;
  final List rawChildren;
  final Widget Function(Map<String, Object?> child) buildFromControl;
  final ConduitRegisterInvokeHandler registerInvokeHandler;
  final ConduitUnregisterInvokeHandler unregisterInvokeHandler;
  final ConduitSendRuntimeEvent sendEvent;

  const ConduitVirtualList({
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
  State<ConduitVirtualList> createState() => _ConduitVirtualListState();
}

class _ConduitVirtualListState extends State<ConduitVirtualList> {
  late final ScrollController _controller;
  int _lastPrefetchMarker = -1;
  final Map<Axis, double> _lastPixels = <Axis, double>{};

  @override
  void initState() {
    super.initState();
    final initial = coerceDouble(widget.props['initial_offset']) ?? 0.0;
    final initialIndex = coerceOptionalInt(widget.props['initial_index']) ?? 0;
    final itemExtent = coerceDouble(widget.props['item_extent']) ?? 0.0;
    final initialOffset = initial > 0
        ? initial
        : (itemExtent > 0 ? initialIndex * itemExtent : 0.0);
    _controller = ScrollController(initialScrollOffset: initialOffset);
    _controller.addListener(_maybeEmitPrefetch);
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant ConduitVirtualList oldWidget) {
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

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    if (!_controller.hasClients) {
      throw StateError('VirtualList has no attached ScrollPosition');
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
      case 'scroll_to_index':
        final index = (coerceOptionalInt(args['index']) ?? 0).clamp(0, 2000000);
        final itemExtent = coerceDouble(widget.props['item_extent']) ?? 72.0;
        final target = index * itemExtent;
        await _controller.animateTo(
          target.clamp(position.minScrollExtent, position.maxScrollExtent),
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
        throw UnsupportedError('Unknown virtual_list method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _coerceItems(widget.props['items']);
    final childMaps = _coerceChildMaps(widget.rawChildren);
    final itemCount = childMaps.isNotEmpty ? childMaps.length : items.length;
    final separator = widget.props['separator'] == true;
    final loading = widget.props['loading'] == true;
    final skeletonCount =
        (coerceOptionalInt(widget.props['skeleton_count']) ?? 3).clamp(1, 20);
    final showLoading = loading && itemCount > 0;

    final scrollable = widget.props['scrollable'] == null
        ? true
        : (widget.props['scrollable'] == true);
    final reverse = widget.props['reverse'] == true;
    final shrinkWrap = widget.props['shrink_wrap'] == true;
    final itemExtent = coerceDouble(widget.props['item_extent']);
    final cacheExtent = coerceDouble(widget.props['cache_extent']);
    final padding = coercePadding(
      widget.props['content_padding'] ?? widget.props['padding'],
    );

    final header = _buildAuxWidget(widget.props['header']);
    final footer = _buildAuxWidget(widget.props['footer']);
    final hasHeader = header != null;
    final hasFooter = footer != null;
    final headerOffset = hasHeader ? 1 : 0;
    final dataStart = headerOffset;
    final dataEnd = dataStart + itemCount;
    final loadingEnd = dataEnd + (showLoading ? skeletonCount : 0);

    final totalCount =
        headerOffset +
        itemCount +
        (showLoading ? skeletonCount : 0) +
        (hasFooter ? 1 : 0);

    Widget buildItem(BuildContext context, int index) {
      if (hasHeader && index == 0) {
        return header;
      }
      if (index >= dataStart && index < dataEnd) {
        final itemIndex = index - dataStart;
        final baseItem = childMaps.isNotEmpty
            ? widget.buildFromControl(childMaps[itemIndex])
            : _buildDataItem(items[itemIndex], itemIndex);
        if (separator && itemIndex > 0) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [const Divider(height: 1), baseItem],
          );
        }
        return baseItem;
      }
      if (index >= dataEnd && index < loadingEnd) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: LinearProgressIndicator(minHeight: 2),
        );
      }
      if (hasFooter && index == totalCount - 1) {
        return footer;
      }
      return const SizedBox.shrink();
    }

    final events = _coerceStringSet(widget.props['events']);
    final wantsScrollStart = events.contains('scroll_start');
    final wantsScroll = events.contains('scroll');
    final wantsScrollEnd = events.contains('scroll_end');
    final anyScrollEvents = wantsScrollStart || wantsScroll || wantsScrollEnd;

    Widget list = ListView.builder(
      controller: _controller,
      reverse: reverse,
      shrinkWrap: shrinkWrap,
      physics: scrollable
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      padding: padding,
      itemExtent: itemExtent,
      cacheExtent: cacheExtent,
      itemCount: totalCount,
      itemBuilder: buildItem,
    );

    if (!anyScrollEvents || widget.controlId.isEmpty) {
      return list;
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        final metrics = notification.metrics;
        final axis = metrics.axis;
        final previousPixels = _lastPixels[axis] ?? metrics.pixels;
        final delta = notification is ScrollUpdateNotification
            ? (notification.scrollDelta ?? (metrics.pixels - previousPixels))
            : 0.0;
        _lastPixels[axis] = metrics.pixels;

        Map<String, Object?> payload(String name) {
          return <String, Object?>{
            'name': name,
            'pixels': metrics.pixels,
            'min_scroll_extent': metrics.minScrollExtent,
            'max_scroll_extent': metrics.maxScrollExtent,
            'viewport_dimension': metrics.viewportDimension,
            'axis': axis == Axis.horizontal ? 'horizontal' : 'vertical',
            'delta': delta,
            'at_start': metrics.pixels <= metrics.minScrollExtent + 0.5,
            'at_end': metrics.pixels >= metrics.maxScrollExtent - 0.5,
          };
        }

        if (notification is ScrollStartNotification && wantsScrollStart) {
          widget.sendEvent(
            widget.controlId,
            'scroll_start',
            payload('scroll_start'),
          );
        } else if (notification is ScrollUpdateNotification && wantsScroll) {
          widget.sendEvent(widget.controlId, 'scroll', payload('scroll'));
        } else if (notification is ScrollEndNotification && wantsScrollEnd) {
          widget.sendEvent(
            widget.controlId,
            'scroll_end',
            payload('scroll_end'),
          );
        }
        return false;
      },
      child: list,
    );
  }

  int _resolveItemCount(Map<String, Object?> props, List children) {
    final childMaps = _coerceChildMaps(children);
    if (childMaps.isNotEmpty) return childMaps.length;
    final items = props['items'];
    if (items is List) return items.length;
    return 0;
  }

  void _maybeEmitPrefetch() {
    if (widget.controlId.isEmpty) return;
    if (!_controller.hasClients) return;

    final hasMore = widget.props['has_more'] == true;
    if (!hasMore) return;

    final childMaps = _coerceChildMaps(widget.rawChildren);
    final items = _coerceItems(widget.props['items']);
    final itemCount = childMaps.isNotEmpty ? childMaps.length : items.length;
    if (itemCount <= 0) return;

    final threshold =
        (coerceOptionalInt(widget.props['prefetch_threshold']) ?? 3).clamp(
          1,
          50,
        );
    final itemExtent = coerceDouble(widget.props['item_extent']) ?? 72.0;
    final position = _controller.position;
    final visibleIndex =
        ((position.pixels + position.viewportDimension) / itemExtent).floor();
    final remaining = itemCount - visibleIndex;
    if (remaining > threshold) return;

    if (_lastPrefetchMarker == itemCount) return;
    _lastPrefetchMarker = itemCount;

    widget.sendEvent(widget.controlId, 'prefetch', {
      'total_items': itemCount,
      'visible_index': visibleIndex.clamp(0, itemCount),
      'remaining': remaining,
      'threshold': threshold,
    });
  }

  Widget _buildDataItem(Object? item, int index) {
    if (item is Map) {
      final map = coerceObjectMap(item);
      if (map.containsKey('type')) {
        return widget.buildFromControl(map);
      }
      final title =
          (map['title'] ?? map['label'] ?? map['text'] ?? map['id'] ?? '$index')
              .toString();
      final subtitle = map['subtitle']?.toString();
      final enabled = map['enabled'] == null ? true : (map['enabled'] == true);
      return ListTile(
        dense: widget.props['dense'] == true,
        enabled: enabled,
        title: Text(title),
        subtitle: subtitle == null ? null : Text(subtitle),
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
      );
    }
    final text = item?.toString() ?? '';
    return ListTile(
      dense: widget.props['dense'] == true,
      title: Text(text),
      onTap: widget.controlId.isEmpty
          ? null
          : () {
              widget.sendEvent(widget.controlId, 'select', {
                'index': index,
                'value': text,
              });
            },
    );
  }

  Widget? _buildAuxWidget(Object? raw) {
    if (raw is Map) {
      return widget.buildFromControl(coerceObjectMap(raw));
    }
    if (raw == null) return null;
    final text = raw.toString();
    if (text.isEmpty) return null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(text),
    );
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

Set<String> _coerceStringSet(Object? value) {
  final out = <String>{};
  if (value is List) {
    for (final item in value) {
      final text = item?.toString();
      if (text != null && text.isNotEmpty) out.add(text);
    }
    return out;
  }
  final single = value?.toString();
  if (single != null && single.isNotEmpty) {
    out.add(single);
  }
  return out;
}
