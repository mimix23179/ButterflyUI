import 'package:flutter/material.dart';

import '../control_utils.dart';
import '../webview/webview_api.dart';

Axis? parseScrollableAxis(Object? value) {
  final s = value?.toString().toLowerCase();
  switch (s) {
    case 'horizontal':
    case 'row':
      return Axis.horizontal;
    case 'vertical':
    case 'column':
      return Axis.vertical;
  }
  return null;
}

Curve parseScrollableCurve(Object? value) {
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
    case 'ease_out_cubic':
    case 'easeoutcubic':
      return Curves.easeOutCubic;
    case 'ease':
    default:
      return Curves.ease;
  }
}

Set<String> coerceScrollableEvents(Object? value) {
  final out = <String>{};
  if (value is List) {
    for (final entry in value) {
      final event = entry?.toString();
      if (event != null && event.isNotEmpty) {
        out.add(event);
      }
    }
  }
  return out;
}

Future<Object?> handleScrollableInvoke({
  required String controlType,
  required ScrollController controller,
  required Axis axis,
  required bool reverse,
  required String method,
  required Map<String, Object?> args,
}) async {
  if (!controller.hasClients) {
    throw StateError('$controlType has no attached ScrollPosition');
  }

  final position = controller.position;

  double resolveOffset(Object? value) {
    final direct = coerceDouble(value);
    if (direct != null) return direct;
    if (axis == Axis.horizontal) {
      return coerceDouble(args['x'] ?? args['dx']) ?? 0.0;
    }
    return coerceDouble(args['y'] ?? args['dy']) ?? 0.0;
  }

  Future<void> moveTo(double target) async {
    final clamp = args['clamp'] == null ? true : (args['clamp'] == true);
    final animate = args['animate'] == null ? true : (args['animate'] == true);
    final durationMs =
        coerceOptionalInt(args['duration_ms'] ?? args['durationMs']) ?? 250;
    final curve = parseScrollableCurve(args['curve']);
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
        'axis': axis == Axis.horizontal ? 'horizontal' : 'vertical',
        'reverse': reverse,
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
      throw UnsupportedError('Unknown $controlType method: $method');
  }
}

Widget wrapScrollableNotifications({
  required Widget child,
  required ScrollController controller,
  required String controlId,
  required Set<String> events,
  required ButterflyUISendRuntimeEvent sendEvent,
}) {
  final wantsScrollStart = events.contains('scroll_start');
  final wantsScroll = events.contains('scroll');
  final wantsScrollEnd = events.contains('scroll_end');
  if (controlId.isEmpty ||
      (!wantsScrollStart && !wantsScroll && !wantsScrollEnd)) {
    return child;
  }

  var lastPixels = 0.0;

  return NotificationListener<ScrollNotification>(
    onNotification: (notification) {
      final metrics = notification.metrics;
      final axis = metrics.axis;
      final delta = notification is ScrollUpdateNotification
          ? (notification.scrollDelta ?? (metrics.pixels - lastPixels))
          : 0.0;
      lastPixels = metrics.pixels;

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
        sendEvent(controlId, 'scroll_start', payload('scroll_start'));
      } else if (notification is ScrollUpdateNotification && wantsScroll) {
        sendEvent(controlId, 'scroll', payload('scroll'));
      } else if (notification is ScrollEndNotification && wantsScrollEnd) {
        sendEvent(controlId, 'scroll_end', payload('scroll_end'));
      }
      return false;
    },
    child: child,
  );
}
