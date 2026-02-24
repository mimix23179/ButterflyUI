import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

List<double> _coercePoints(Object? raw) {
  if (raw is! List) return const [];
  final out = <double>[];
  for (final item in raw) {
    if (item is num) {
      out.add(item.toDouble());
      continue;
    }
    if (item is Map) {
      final map = coerceObjectMap(item);
      final value = coerceDouble(map['y'] ?? map['value']);
      if (value != null) out.add(value);
      continue;
    }
    final value = coerceDouble(item);
    if (value != null) out.add(value);
  }
  return out;
}

class _LineChartPainter extends CustomPainter {
  final List<double> points;
  final Color color;
  final bool fill;

  const _LineChartPainter({
    required this.points,
    required this.color,
    required this.fill,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final minY = points.reduce(math.min);
    final maxY = points.reduce(math.max);
    final span = (maxY - minY).abs() < 0.0001 ? 1.0 : (maxY - minY);
    final stepX = points.length <= 1 ? size.width : size.width / (points.length - 1);

    final path = Path();
    for (var i = 0; i < points.length; i += 1) {
      final x = stepX * i;
      final t = (points[i] - minY) / span;
      final y = size.height - (t * size.height);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    if (fill) {
      final fillPath = Path.from(path)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
      final fillPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = color.withValues(alpha: 0.2);
      canvas.drawPath(fillPath, fillPaint);
    }

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.color != color ||
        oldDelegate.fill != fill;
  }
}

class _BarChartPainter extends CustomPainter {
  final List<double> points;
  final List<List<double>> datasets;
  final bool grouped;
  final bool stacked;
  final Color color;

  const _BarChartPainter({
    required this.points,
    required this.datasets,
    required this.grouped,
    required this.stacked,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final source = datasets.isNotEmpty ? datasets.first : points;
    if (source.isEmpty) return;
    var maxY = source.reduce(math.max);
    var minY = source.reduce(math.min);
    if (datasets.length > 1 && stacked) {
      final length = datasets.map((e) => e.length).fold<int>(0, math.max);
      maxY = 0;
      minY = 0;
      for (var i = 0; i < length; i += 1) {
        var total = 0.0;
        for (final set in datasets) {
          if (i < set.length) {
            total += set[i];
          }
        }
        maxY = math.max(maxY, total);
        minY = math.min(minY, total);
      }
    }
    final span = (maxY - minY).abs() < 0.0001 ? 1.0 : (maxY - minY);
    final count = datasets.isNotEmpty
        ? datasets.map((e) => e.length).fold<int>(0, math.max)
        : points.length;
    if (count <= 0) return;
    final barWidth = size.width / count;
    final palette = <Color>[
      color,
      color.withValues(alpha: 0.8),
      color.withValues(alpha: 0.6),
      color.withValues(alpha: 0.4),
    ];

    if (datasets.length <= 1) {
      final paint = Paint()..color = color;
      for (var i = 0; i < points.length; i += 1) {
        final t = (points[i] - minY) / span;
        final h = math.max(2.0, t * size.height);
        final rect = Rect.fromLTWH(
          i * barWidth + 2,
          size.height - h,
          math.max(2.0, barWidth - 4),
          h,
        );
        canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(3)), paint);
      }
      return;
    }

    for (var i = 0; i < count; i += 1) {
      if (stacked) {
        var cumulative = 0.0;
        for (var d = 0; d < datasets.length; d += 1) {
          final value = i < datasets[d].length ? datasets[d][i] : 0.0;
          final y0 = (cumulative - minY) / span;
          cumulative += value;
          final y1 = (cumulative - minY) / span;
          final top = size.height - (math.max(y0, y1) * size.height);
          final height = math.max(2.0, (y1 - y0).abs() * size.height);
          final rect = Rect.fromLTWH(i * barWidth + 2, top, math.max(2.0, barWidth - 4), height);
          canvas.drawRRect(
            RRect.fromRectAndRadius(rect, const Radius.circular(2)),
            Paint()..color = palette[d % palette.length],
          );
        }
      } else {
        final groups = grouped ? datasets.length : 1;
        final groupWidth = (barWidth - 4) / groups;
        for (var d = 0; d < datasets.length; d += 1) {
          final value = i < datasets[d].length ? datasets[d][i] : 0.0;
          final t = (value - minY) / span;
          final h = math.max(2.0, t * size.height);
          final left = i * barWidth + 2 + (grouped ? d * groupWidth : 0);
          final width = math.max(2.0, grouped ? (groupWidth - 1) : (barWidth - 4));
          final rect = Rect.fromLTWH(left, size.height - h, width, h);
          canvas.drawRRect(
            RRect.fromRectAndRadius(rect, const Radius.circular(2)),
            Paint()..color = palette[d % palette.length],
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.datasets != datasets ||
        oldDelegate.grouped != grouped ||
        oldDelegate.stacked != stacked ||
        oldDelegate.color != color;
  }
}

Widget buildChartControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ChartControl(
    controlId: controlId,
    initialProps: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _ChartControl extends StatefulWidget {
  final String controlId;
  final Map<String, Object?> initialProps;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const _ChartControl({
    required this.controlId,
    required this.initialProps,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<_ChartControl> createState() => _ChartControlState();
}

class _ChartControlState extends State<_ChartControl> {
  late List<double> _points = _coercePoints(
    widget.initialProps['points'] ??
        widget.initialProps['values'] ??
        widget.initialProps['data'],
  );
  late List<List<double>> _datasets =
      _coerceBarDatasets(widget.initialProps['datasets']);

  @override
  void initState() {
    super.initState();
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant _ChartControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
    if (oldWidget.initialProps != widget.initialProps) {
      _points = _coercePoints(
        widget.initialProps['points'] ??
            widget.initialProps['values'] ??
            widget.initialProps['data'],
      );
      _datasets = _coerceBarDatasets(widget.initialProps['datasets']);
    }
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_data':
        setState(() {
          _points = _coercePoints(
            args['values'] ?? args['points'] ?? args['data'] ?? args['value'],
          );
          if (args['datasets'] != null) {
            _datasets = _coerceBarDatasets(args['datasets']);
          }
        });
        return null;
      case 'get_state':
        return {
          'values': List<double>.from(_points, growable: false),
          'points': List<double>.from(_points, growable: false),
          if (_datasets.isNotEmpty)
            'datasets': _datasets
                .map((set) => List<double>.from(set, growable: false))
                .toList(growable: false),
        };
      case 'emit':
        final event = (args['event'] ?? 'change').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        widget.sendEvent(widget.controlId, event, payload);
        return null;
      default:
        throw UnsupportedError('Unknown chart method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final props = widget.initialProps;
    final points = _points;
    final datasets = _datasets;
    final color = coerceColor(props['color']) ?? const Color(0xff4f46e5);
    final bgColor = coerceColor(props['background']) ?? Colors.transparent;
    final chartType =
        (props['chart_type'] ?? props['type'] ?? 'line').toString().toLowerCase();
    final height = coerceDouble(props['height']) ?? 180;
    final fill = props['fill'] == true || chartType == 'area';
    final grouped = props['grouped'] == true;
    final stacked = props['stacked'] == true;

    Widget chart;
    if (points.isEmpty) {
      chart = Center(
        child: Text((props['empty_label'] ?? 'No chart data').toString()),
      );
    } else if (chartType == 'bar' || chartType == 'column') {
      chart = CustomPaint(
        painter: _BarChartPainter(
          points: points,
          datasets: datasets,
          grouped: grouped,
          stacked: stacked,
          color: color,
        ),
        size: Size(double.infinity, height),
      );
    } else {
      chart = CustomPaint(
        painter: _LineChartPainter(points: points, color: color, fill: fill),
        size: Size(double.infinity, height),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite && constraints.maxWidth > 0
            ? constraints.maxWidth
            : 1.0;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: points.isEmpty
              ? null
              : (details) {
                  final ratio = (details.localPosition.dx / width).clamp(0.0, 1.0);
                  final index = (ratio * (points.length - 1)).round();
                  widget.sendEvent(widget.controlId, 'select', {
                    'index': index,
                    'value': points[index],
                    if (datasets.isNotEmpty)
                      'dataset_values': datasets
                          .map((set) => index < set.length ? set[index] : null)
                          .toList(growable: false),
                  });
                },
          child: Container(
            height: height,
            color: bgColor,
            child: SizedBox.expand(child: chart),
          ),
        );
      },
    );
  }
}

List<List<double>> _coerceBarDatasets(Object? raw) {
  if (raw is! List) return const [];
  final out = <List<double>>[];
  for (final item in raw) {
    if (item is Map) {
      final map = coerceObjectMap(item);
      final values = _coercePoints(map['values'] ?? map['points'] ?? map['data']);
      if (values.isNotEmpty) {
        out.add(values);
      }
      continue;
    }
    if (item is List) {
      final values = _coercePoints(item);
      if (values.isNotEmpty) {
        out.add(values);
      }
    }
  }
  return out;
}

Widget buildSparklineControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _SparklineControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _SparklineControl extends StatefulWidget {
  const _SparklineControl({
    required this.controlId,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_SparklineControl> createState() => _SparklineControlState();
}

class _SparklineControlState extends State<_SparklineControl> {
  late List<double> _points;

  @override
  void initState() {
    super.initState();
    _points = _coercePoints(
      widget.props['points'] ?? widget.props['values'] ?? widget.props['data'],
    );
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _SparklineControl oldWidget) {
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
      _points = _coercePoints(
        widget.props['points'] ?? widget.props['values'] ?? widget.props['data'],
      );
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_data':
        setState(() {
          _points = _coercePoints(
            args['values'] ?? args['points'] ?? args['data'] ?? args['value'],
          );
        });
        return null;
      case 'get_state':
        return {
          'values': List<double>.from(_points, growable: false),
          'points': List<double>.from(_points, growable: false),
        };
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
        throw UnsupportedError('Unknown sparkline method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = coerceColor(widget.props['color']) ?? const Color(0xff4f46e5);
    final height = coerceDouble(widget.props['height']) ?? 40;
    final fill = widget.props['fill'] == true;

    return SizedBox(
      height: height,
      child: _points.isEmpty
          ? const SizedBox.shrink()
          : CustomPaint(
              painter: _LineChartPainter(points: _points, color: color, fill: fill),
              size: Size.infinite,
            ),
    );
  }
}
