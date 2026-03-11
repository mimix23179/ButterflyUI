import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:butterflyui_runtime/src/core/control_shells/base_control_shell.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildGridControl(
  String controlId,
  Map<String, Object?> props,
  List<Map<String, Object?>> children,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _GridControl(
    controlId: controlId,
    props: props,
    children: children,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _GridControl extends StatefulWidget {
  const _GridControl({
    required this.controlId,
    required this.props,
    required this.children,
    required this.buildChild,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final List<Map<String, Object?>> children;
  final Widget Function(Map<String, Object?> child) buildChild;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_GridControl> createState() => _GridControlState();
}

class _GridControlState extends State<_GridControl> {
  late Map<String, Object?> _liveProps;

  @override
  void initState() {
    super.initState();
    _liveProps = <String, Object?>{...widget.props};
    registerInvokeHandlerIfNeeded(
      controlId: widget.controlId,
      registerInvokeHandler: widget.registerInvokeHandler,
      handler: _handleInvoke,
    );
  }

  @override
  void didUpdateWidget(covariant _GridControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    syncInvokeHandlerRegistration(
      previousControlId: oldWidget.controlId,
      currentControlId: widget.controlId,
      registerInvokeHandler: widget.registerInvokeHandler,
      unregisterInvokeHandler: widget.unregisterInvokeHandler,
      handler: _handleInvoke,
    );
    if (oldWidget.props != widget.props) {
      _liveProps = <String, Object?>{...widget.props};
    }
  }

  @override
  void dispose() {
    unregisterInvokeHandlerIfNeeded(
      controlId: widget.controlId,
      unregisterInvokeHandler: widget.unregisterInvokeHandler,
    );
    super.dispose();
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_layout':
      case 'set_grid':
      case 'set_props':
        final nextProps = _extractPropUpdates(args);
        setState(() {
          _liveProps = <String, Object?>{..._liveProps, ...nextProps};
        });
        return _statePayload();
      case 'get_state':
      case 'get_layout':
      case 'get_grid':
        return _statePayload();
      case 'emit':
        final event = (args['event'] ?? 'change').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        if (widget.controlId.isNotEmpty) {
          widget.sendEvent(widget.controlId, event, payload);
        }
        return null;
      default:
        throw UnsupportedError('Unknown grid method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    final axis =
        _parseAxis(_liveProps['direction'] ?? _liveProps['axis']) ??
        Axis.vertical;
    final items = _liveProps['items'] is List
        ? _liveProps['items'] as List
        : const <Object?>[];
    return <String, Object?>{
      'columns':
          (coerceOptionalInt(
                    _liveProps['columns'] ?? _liveProps['cross_axis_count'],
                  ) ??
                  2)
              .clamp(1, 24),
      'spacing': coerceDouble(_liveProps['spacing']) ?? 8.0,
      'run_spacing':
          coerceDouble(_liveProps['run_spacing']) ??
          coerceDouble(_liveProps['spacing']) ??
          8.0,
      'child_aspect_ratio':
          coerceDouble(_liveProps['child_aspect_ratio']) ?? 1.0,
      'direction': axis == Axis.horizontal ? 'horizontal' : 'vertical',
      'reverse': _liveProps['reverse'] == true,
      'shrink_wrap': _liveProps['shrink_wrap'] == true,
      'scrollable': _liveProps['scrollable'] == null
          ? true
          : (_liveProps['scrollable'] == true),
      'item_count': widget.children.isNotEmpty
          ? widget.children.length
          : items.length,
      if (_liveProps['primary'] != null) 'primary': _liveProps['primary'],
    };
  }

  @override
  Widget build(BuildContext context) {
    final axis =
        _parseAxis(_liveProps['direction'] ?? _liveProps['axis']) ??
        Axis.vertical;
    final reverse = _liveProps['reverse'] == true;
    final shrinkWrap = _liveProps['shrink_wrap'] == true;
    final scrollable = _liveProps['scrollable'] == null
        ? true
        : (_liveProps['scrollable'] == true);
    final primary = axis == Axis.vertical
        ? (_liveProps['primary'] == true)
        : false;
    final ScrollPhysics? physics = scrollable
        ? null
        : const NeverScrollableScrollPhysics();
    final padding = coercePadding(
      _liveProps['content_padding'] ?? _liveProps['padding'],
    );
    final columns =
        (coerceOptionalInt(
                  _liveProps['columns'] ?? _liveProps['cross_axis_count'],
                ) ??
                2)
            .clamp(1, 24);
    final spacing = coerceDouble(_liveProps['spacing']) ?? 8;
    final runSpacing = coerceDouble(_liveProps['run_spacing']) ?? spacing;
    final childAspectRatio =
        coerceDouble(_liveProps['child_aspect_ratio']) ?? 1;
    final useSpans = _hasExplicitSpans(widget.children, _liveProps);

    if (axis == Axis.vertical && useSpans) {
      final tiles = _buildStaggeredTiles(
        controlId: widget.controlId,
        props: _liveProps,
        children: widget.children,
        buildChild: widget.buildChild,
        sendEvent: widget.sendEvent,
        columns: columns,
      );
      final grid = StaggeredGrid.count(
        crossAxisCount: columns,
        mainAxisSpacing: runSpacing,
        crossAxisSpacing: spacing,
        children: tiles,
      );
      if (!scrollable) {
        return Padding(
          padding: padding ?? EdgeInsets.zero,
          child: grid,
        );
      }
      return SingleChildScrollView(
        reverse: reverse,
        padding: padding,
        physics: physics,
        child: grid,
      );
    }

    return GridView.count(
      crossAxisCount: columns,
      crossAxisSpacing: spacing,
      mainAxisSpacing: runSpacing,
      childAspectRatio: childAspectRatio,
      scrollDirection: axis,
      reverse: reverse,
      shrinkWrap: shrinkWrap,
      primary: primary,
      physics: physics,
      padding: padding,
      children: _buildTiles(
        controlId: widget.controlId,
        props: _liveProps,
        children: widget.children,
        buildChild: widget.buildChild,
        sendEvent: widget.sendEvent,
      ),
    );
  }
}

Map<String, Object?> _extractPropUpdates(Map<String, Object?> args) {
  final props = args['props'];
  if (props is Map) {
    return coerceObjectMap(props);
  }
  return args;
}

List<Widget> _buildTiles({
  required String controlId,
  required Map<String, Object?> props,
  required List<Map<String, Object?>> children,
  required Widget Function(Map<String, Object?> child) buildChild,
  required ButterflyUISendRuntimeEvent sendEvent,
}) {
  final tiles = <Widget>[];
  if (children.isNotEmpty) {
    tiles.addAll(children.map(buildChild));
    return tiles;
  }
  if (props['items'] is! List) {
    return tiles;
  }
  final items = props['items'] as List;
  for (var i = 0; i < items.length; i += 1) {
    final item = items[i];
    if (item is Map) {
      final map = coerceObjectMap(item);
      final title =
          map['title']?.toString() ??
          map['label']?.toString() ??
          '${map['id'] ?? i}';
      tiles.add(
        Card(
          child: InkWell(
            onTap: controlId.isEmpty
                ? null
                : () {
                    sendEvent(controlId, 'select', {'index': i, 'item': map});
                  },
            child: Center(child: Text(title, textAlign: TextAlign.center)),
          ),
        ),
      );
    } else {
      tiles.add(Card(child: Center(child: Text(item?.toString() ?? ''))));
    }
  }
  return tiles;
}

List<Widget> _buildStaggeredTiles({
  required String controlId,
  required Map<String, Object?> props,
  required List<Map<String, Object?>> children,
  required Widget Function(Map<String, Object?> child) buildChild,
  required ButterflyUISendRuntimeEvent sendEvent,
  required int columns,
}) {
  final tiles = <Widget>[];
  if (children.isNotEmpty) {
    for (final child in children) {
      final childProps = child['props'] is Map
          ? coerceObjectMap(child['props'] as Map)
          : <String, Object?>{};
      final columnSpan =
          (coerceOptionalInt(
                    childProps['column_span'] ??
                        childProps['col_span'] ??
                        childProps['span'] ??
                        childProps['cross_axis_span'],
                  ) ??
                  1)
              .clamp(1, columns);
      final rowSpan =
          (coerceOptionalInt(
                    childProps['row_span'] ??
                        childProps['main_axis_span'] ??
                        childProps['span_y'],
                  ) ??
                  1)
              .clamp(1, 100);
      tiles.add(
        StaggeredGridTile.count(
          crossAxisCellCount: columnSpan,
          mainAxisCellCount: rowSpan.toDouble(),
          child: buildChild(child),
        ),
      );
    }
    return tiles;
  }
  if (props['items'] is! List) {
    return tiles;
  }
  final items = props['items'] as List;
  for (var i = 0; i < items.length; i += 1) {
    final item = items[i];
    final map = item is Map ? coerceObjectMap(item) : <String, Object?>{};
    final columnSpan =
        (coerceOptionalInt(
                  map['column_span'] ??
                      map['col_span'] ??
                      map['span'] ??
                      map['cross_axis_span'],
                ) ??
                1)
            .clamp(1, columns);
    final rowSpan =
        (coerceOptionalInt(
                  map['row_span'] ??
                      map['main_axis_span'] ??
                      map['span_y'],
                ) ??
                1)
            .clamp(1, 100);
    Widget child;
    if (item is Map) {
      final title =
          map['title']?.toString() ??
          map['label']?.toString() ??
          '${map['id'] ?? i}';
      child = Card(
        child: InkWell(
          onTap: controlId.isEmpty
              ? null
              : () {
                  sendEvent(controlId, 'select', {'index': i, 'item': map});
                },
          child: Center(child: Text(title, textAlign: TextAlign.center)),
        ),
      );
    } else {
      child = Card(child: Center(child: Text(item?.toString() ?? '')));
    }
    tiles.add(
      StaggeredGridTile.count(
        crossAxisCellCount: columnSpan,
        mainAxisCellCount: rowSpan.toDouble(),
        child: child,
      ),
    );
  }
  return tiles;
}

bool _hasExplicitSpans(
  List<Map<String, Object?>> children,
  Map<String, Object?> props,
) {
  for (final child in children) {
    final childProps = child['props'] is Map
        ? coerceObjectMap(child['props'] as Map)
        : <String, Object?>{};
    if (childProps['column_span'] != null ||
        childProps['col_span'] != null ||
        childProps['row_span'] != null ||
        childProps['main_axis_span'] != null ||
        childProps['span'] != null) {
      return true;
    }
  }
  if (props['items'] is List) {
    for (final item in props['items'] as List) {
      if (item is Map) {
        final map = coerceObjectMap(item);
        if (map['column_span'] != null ||
            map['col_span'] != null ||
            map['row_span'] != null ||
            map['main_axis_span'] != null ||
            map['span'] != null) {
          return true;
        }
      }
    }
  }
  return false;
}

Axis? _parseAxis(Object? value) {
  final s = value?.toString().toLowerCase();
  switch (s) {
    case 'horizontal':
    case 'row':
    case 'x':
      return Axis.horizontal;
    case 'vertical':
    case 'column':
    case 'y':
      return Axis.vertical;
  }
  return null;
}
