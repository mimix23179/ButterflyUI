import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildSplitViewControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final children = <Widget>[];
  for (final child in rawChildren) {
    if (child is Map) {
      children.add(buildChild(coerceObjectMap(child)));
    }
  }

  if (children.isEmpty) {
    final first = props['first'];
    final second = props['second'];
    if (first is Map) {
      children.add(buildChild(coerceObjectMap(first)));
    }
    if (second is Map) {
      children.add(buildChild(coerceObjectMap(second)));
    }
  }

  return ButterflyUISplitView(
    controlId: controlId,
    props: props,
    children: children,
    sendEvent: sendEvent,
  );
}

class ButterflyUISplitView extends StatefulWidget {
  final String controlId;
  final Map<String, Object?> props;
  final List<Widget> children;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUISplitView({
    super.key,
    required this.controlId,
    required this.props,
    required this.children,
    required this.sendEvent,
  });

  @override
  State<ButterflyUISplitView> createState() => _ButterflyUISplitViewState();
}

class _ButterflyUISplitViewState extends State<ButterflyUISplitView> {
  double? _ratio;

  @override
  void didUpdateWidget(covariant ButterflyUISplitView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.props['ratio'] != oldWidget.props['ratio']) {
      _ratio = _coerceRatio(widget.props['ratio']) ?? _ratio;
    }
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.children.length;
    if (count <= 0) return const SizedBox.shrink();
    if (count == 1) return widget.children.first;

    final axis = _parseAxis(widget.props['axis'] ?? widget.props['direction']);
    final dividerSize = (coerceDouble(widget.props['divider_size']) ?? 8.0)
        .clamp(2.0, 24.0);
    final draggable = widget.props['draggable'] == null
        ? true
        : (widget.props['draggable'] == true);
    final minRatio = (coerceDouble(widget.props['min_ratio']) ?? 0.15).clamp(
      0.05,
      0.95,
    );
    final maxRatio = (coerceDouble(widget.props['max_ratio']) ?? 0.85).clamp(
      minRatio,
      0.95,
    );
    final ratio = (_ratio ?? _coerceRatio(widget.props['ratio']) ?? 0.5).clamp(
      minRatio,
      maxRatio,
    );

    final first = widget.children.first;
    final second = _buildRemaining(axis, widget.children.skip(1).toList());

    return LayoutBuilder(
      builder: (context, constraints) {
        final extent = axis == Axis.horizontal
            ? constraints.maxWidth
            : constraints.maxHeight;
        if (extent.isInfinite || extent <= dividerSize + 1) {
          return Flex(
            direction: axis,
            children: [
              Expanded(child: first),
              SizedBox(
                width: axis == Axis.horizontal ? dividerSize : null,
                height: axis == Axis.vertical ? dividerSize : null,
                child: _buildDivider(axis, draggable),
              ),
              Expanded(child: second),
            ],
          );
        }

        final available = (extent - dividerSize).clamp(0.0, double.infinity);
        final firstExtent = available * ratio;
        final secondExtent = available - firstExtent;

        final divider = SizedBox(
          width: axis == Axis.horizontal ? dividerSize : null,
          height: axis == Axis.vertical ? dividerSize : null,
          child: _buildDivider(axis, draggable),
        );

        final crossAxis = axis == Axis.horizontal
            ? (constraints.maxHeight.isFinite
                  ? CrossAxisAlignment.stretch
                  : CrossAxisAlignment.start)
            : (constraints.maxWidth.isFinite
                  ? CrossAxisAlignment.stretch
                  : CrossAxisAlignment.start);

        if (axis == Axis.horizontal) {
          return Row(
            crossAxisAlignment: crossAxis,
            children: [
              SizedBox(width: firstExtent, child: first),
              divider,
              SizedBox(width: secondExtent, child: second),
            ],
          );
        }

        return Column(
          crossAxisAlignment: crossAxis,
          children: [
            SizedBox(height: firstExtent, child: first),
            divider,
            SizedBox(height: secondExtent, child: second),
          ],
        );
      },
    );
  }

  Widget _buildRemaining(Axis axis, List<Widget> rest) {
    if (rest.length == 1) return rest.first;
    return Flex(
      direction: axis,
      children: rest.map((child) => Expanded(child: child)).toList(),
    );
  }

  Widget _buildDivider(Axis axis, bool draggable) {
    final color =
        coerceColor(widget.props['divider_color']) ??
        Theme.of(context).colorScheme.outlineVariant;
    final handle = Container(
      color: color.withOpacity(0.35),
      child: Center(
        child: Icon(
          axis == Axis.horizontal ? Icons.drag_indicator : Icons.more_horiz,
          size: 16,
          color: color,
        ),
      ),
    );

    if (!draggable) return handle;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onDoubleTap: () {
        setState(() => _ratio = 0.5);
        _emitRatio('reset');
      },
      onPanUpdate: (details) {
        final box = context.findRenderObject();
        if (box is! RenderBox) return;
        final size = box.size;
        final total = axis == Axis.horizontal ? size.width : size.height;
        if (total <= 1) return;

        final minRatio = (coerceDouble(widget.props['min_ratio']) ?? 0.15)
            .clamp(0.05, 0.95);
        final maxRatio = (coerceDouble(widget.props['max_ratio']) ?? 0.85)
            .clamp(minRatio, 0.95);
        final delta = axis == Axis.horizontal
            ? details.delta.dx
            : details.delta.dy;
        final next =
            ((_ratio ?? _coerceRatio(widget.props['ratio']) ?? 0.5) +
                    (delta / total))
                .clamp(minRatio, maxRatio);

        setState(() => _ratio = next);
        _emitRatio('drag');
      },
      onPanEnd: (_) => _emitRatio('change'),
      child: MouseRegion(
        cursor: axis == Axis.horizontal
            ? SystemMouseCursors.resizeLeftRight
            : SystemMouseCursors.resizeUpDown,
        child: handle,
      ),
    );
  }

  void _emitRatio(String event) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, {
      'ratio': _ratio ?? _coerceRatio(widget.props['ratio']) ?? 0.5,
      'axis':
          (_parseAxis(widget.props['axis'] ?? widget.props['direction']) ==
              Axis.horizontal)
          ? 'horizontal'
          : 'vertical',
    });
  }
}

double? _coerceRatio(Object? value) {
  final ratio = coerceDouble(value);
  if (ratio == null) return null;
  if (ratio > 1) {
    return (ratio / 100).clamp(0.01, 0.99);
  }
  return ratio.clamp(0.01, 0.99);
}

Axis _parseAxis(Object? value) {
  final s = value?.toString().toLowerCase() ?? '';
  switch (s) {
    case 'horizontal':
    case 'row':
    case 'x':
      return Axis.horizontal;
    default:
      return Axis.vertical;
  }
}
