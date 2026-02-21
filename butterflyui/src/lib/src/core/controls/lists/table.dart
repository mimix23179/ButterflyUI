import 'package:flutter/material.dart';

import 'package:conduit_runtime/src/core/control_utils.dart';
import 'package:conduit_runtime/src/core/webview/webview_api.dart';

class ConduitTableView extends StatefulWidget {
  final String controlId;
  final Map<String, Object?> props;
  final ConduitRegisterInvokeHandler? registerInvokeHandler;
  final ConduitUnregisterInvokeHandler? unregisterInvokeHandler;
  final ConduitSendRuntimeEvent? sendEvent;

  final List<String> columns;
  final List<List<Object?>> rows;
  final bool dense;
  final bool striped;
  final bool showHeader;

  const ConduitTableView({
    super.key,
    this.controlId = '',
    this.props = const {},
    this.registerInvokeHandler,
    this.unregisterInvokeHandler,
    this.sendEvent,
    required this.columns,
    required this.rows,
    required this.dense,
    required this.striped,
    required this.showHeader,
  });

  @override
  State<ConduitTableView> createState() => _ConduitTableViewState();
}

class _ConduitTableViewState extends State<ConduitTableView> {
  late final ScrollController _verticalController;
  late final ScrollController _horizontalController;
  final Map<Axis, double> _lastPixels = <Axis, double>{};

  @override
  void initState() {
    super.initState();
    final initial = coerceDouble(widget.props['initial_offset']);
    final initialY =
        coerceDouble(widget.props['initial_offset_y']) ?? initial ?? 0.0;
    final initialX =
        coerceDouble(widget.props['initial_offset_x']) ?? initial ?? 0.0;
    _verticalController = ScrollController(initialScrollOffset: initialY);
    _horizontalController = ScrollController(initialScrollOffset: initialX);
    if (widget.controlId.isNotEmpty && widget.registerInvokeHandler != null) {
      widget.registerInvokeHandler!(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant ConduitTableView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty &&
          oldWidget.unregisterInvokeHandler != null) {
        oldWidget.unregisterInvokeHandler!(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty && widget.registerInvokeHandler != null) {
        widget.registerInvokeHandler!(widget.controlId, _handleInvoke);
      }
    }

    void jumpIfChanged(
      ScrollController controller,
      Object? oldValue,
      Object? newValue,
    ) {
      final oldOffset = coerceDouble(oldValue);
      final nextOffset = coerceDouble(newValue);
      if (nextOffset == null || nextOffset == oldOffset) return;
      if (!controller.hasClients) return;
      final position = controller.position;
      final clamped = nextOffset
          .clamp(position.minScrollExtent, position.maxScrollExtent)
          .toDouble();
      if (position.pixels != clamped) controller.jumpTo(clamped);
    }

    jumpIfChanged(
      _verticalController,
      oldWidget.props['initial_offset_y'] ?? oldWidget.props['initial_offset'],
      widget.props['initial_offset_y'] ?? widget.props['initial_offset'],
    );
    jumpIfChanged(
      _horizontalController,
      oldWidget.props['initial_offset_x'] ?? oldWidget.props['initial_offset'],
      widget.props['initial_offset_x'] ?? widget.props['initial_offset'],
    );
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty && widget.unregisterInvokeHandler != null) {
      widget.unregisterInvokeHandler!(widget.controlId);
    }
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  ScrollController _resolveAxisController(Map<String, Object?> args) {
    final axis = args['axis']?.toString().toLowerCase();
    if (axis == 'horizontal' || axis == 'x') return _horizontalController;
    return _verticalController;
  }

  String _resolveAxisName(Map<String, Object?> args) {
    final axis = args['axis']?.toString().toLowerCase();
    if (axis == 'horizontal' || axis == 'x') return 'horizontal';
    return 'vertical';
  }

  Curve _parseCurve(Object? value) {
    final s = value?.toString().toLowerCase();
    switch (s) {
      case 'linear':
        return Curves.linear;
      case 'ease_in':
      case 'easein':
        return Curves.easeIn;
      case 'ease_out':
      case 'easeout':
        return Curves.easeOut;
      case 'ease_in_out':
      case 'easeinout':
        return Curves.easeInOut;
      case 'ease':
      default:
        return Curves.ease;
    }
  }

  Set<String> _coerceStringSet(Object? value) {
    final out = <String>{};
    if (value is List) {
      for (final v in value) {
        final s = v?.toString();
        if (s != null && s.isNotEmpty) out.add(s);
      }
    }
    return out;
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    final controller = _resolveAxisController(args);
    if (!controller.hasClients) {
      throw StateError('Table has no attached ScrollPosition');
    }
    final axis = _resolveAxisName(args);
    final position = controller.position;

    double resolveOffset(Object? value) {
      if (axis == 'horizontal') {
        return coerceDouble(
              value ??
                  args['x'] ??
                  args['dx'] ??
                  args['offset'] ??
                  args['pixels'],
            ) ??
            0.0;
      }
      return coerceDouble(
            value ??
                args['y'] ??
                args['dy'] ??
                args['offset'] ??
                args['pixels'],
          ) ??
          0.0;
    }

    Future<void> moveTo(double target) async {
      final clamp = args['clamp'] == null ? true : (args['clamp'] == true);
      final animate = args['animate'] == null
          ? true
          : (args['animate'] == true);
      final durationMs =
          coerceOptionalInt(args['duration_ms'] ?? args['durationMs']) ?? 250;
      final curve = _parseCurve(args['curve']);

      final resolved = clamp
          ? target
                .clamp(position.minScrollExtent, position.maxScrollExtent)
                .toDouble()
          : target;
      if (animate) {
        await controller.animateTo(
          resolved,
          duration: Duration(milliseconds: durationMs),
          curve: curve,
        );
      } else {
        controller.jumpTo(resolved);
      }
    }

    switch (method) {
      case 'get_scroll_metrics':
        return <String, Object?>{
          'pixels': position.pixels,
          'min_scroll_extent': position.minScrollExtent,
          'max_scroll_extent': position.maxScrollExtent,
          'viewport_dimension': position.viewportDimension,
          'axis': axis,
          'reverse': false,
          'at_start': position.pixels <= position.minScrollExtent + 0.5,
          'at_end': position.pixels >= position.maxScrollExtent - 0.5,
        };
      case 'scroll_to':
        await moveTo(resolveOffset(args['offset'] ?? args['pixels']));
        return null;
      case 'scroll_by':
        final delta = resolveOffset(
          args['delta'] ?? args['scroll_delta'] ?? args['scrollDelta'],
        );
        await moveTo(position.pixels + delta);
        return null;
      case 'scroll_to_start':
        await moveTo(position.minScrollExtent);
        return null;
      case 'scroll_to_end':
        await moveTo(position.maxScrollExtent);
        return null;
      default:
        throw UnsupportedError('Unknown table method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final headingHeight = widget.showHeader ? null : 0.0;
    final controlId = widget.controlId;
    final sendEvent = widget.sendEvent;
    final emitRowTap = controlId.isNotEmpty && sendEvent != null;
    final dataColumns = widget.columns
        .map((col) => DataColumn(label: Text(col)))
        .toList();

    final dataRows = <DataRow>[];
    for (var i = 0; i < widget.rows.length; i += 1) {
      final row = widget.rows[i];
      final normalized = List<Object?>.from(row);
      while (normalized.length < widget.columns.length) {
        normalized.add(null);
      }
      if (normalized.length > widget.columns.length) {
        normalized.removeRange(widget.columns.length, normalized.length);
      }
      final cells = normalized
          .map((cell) => DataCell(Text(cell?.toString() ?? '')))
          .toList();
      final color = widget.striped && i.isOdd
          ? MaterialStateProperty.all(
              Theme.of(
                context,
              ).colorScheme.surfaceVariant.withValues(alpha: 0.3),
            )
          : null;
      dataRows.add(
        DataRow(
          cells: cells,
          color: color,
          onSelectChanged: emitRowTap
              ? (_) => sendEvent(controlId, 'row_tap', {
                  'index': i,
                  'row': List<Object?>.from(normalized),
                })
              : null,
        ),
      );
    }

    final table = DataTable(
      columns: dataColumns,
      rows: dataRows,
      showCheckboxColumn: false,
      headingRowHeight: headingHeight,
      dataRowMinHeight: widget.dense ? 32 : null,
      dataRowMaxHeight: widget.dense ? 40 : null,
      dividerThickness: 0.6,
      columnSpacing: widget.dense ? 16 : 24,
    );

    Widget scrollable = SingleChildScrollView(
      controller: _horizontalController,
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        controller: _verticalController,
        scrollDirection: Axis.vertical,
        child: table,
      ),
    );

    if (controlId.isEmpty || sendEvent == null) {
      return scrollable;
    }

    final events = _coerceStringSet(widget.props['events']);
    final wantsScrollStart = events.contains('scroll_start');
    final wantsScroll = events.contains('scroll');
    final wantsScrollEnd = events.contains('scroll_end');
    final anyScrollEvents = wantsScrollStart || wantsScroll || wantsScrollEnd;
    if (!anyScrollEvents) {
      return scrollable;
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

        if (notification is ScrollStartNotification) {
          if (wantsScrollStart) {
            sendEvent(controlId, 'scroll_start', payload('scroll_start'));
          }
        } else if (notification is ScrollUpdateNotification) {
          if (wantsScroll) {
            sendEvent(controlId, 'scroll', payload('scroll'));
          }
        } else if (notification is ScrollEndNotification) {
          if (wantsScrollEnd) {
            sendEvent(controlId, 'scroll_end', payload('scroll_end'));
          }
        }
        return false;
      },
      child: scrollable,
    );
  }
}
