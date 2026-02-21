import 'package:flutter/animation.dart';
import 'package:flutter/widgets.dart';

import '../control_utils.dart';

class ConduitMotionSpec {
  final Duration duration;
  final Curve curve;
  final double beginScale;
  final double endScale;
  final Offset beginOffset;
  final Offset endOffset;
  final double beginOpacity;
  final double endOpacity;
  final double overshoot;

  const ConduitMotionSpec({
    required this.duration,
    required this.curve,
    this.beginScale = 1.0,
    this.endScale = 1.0,
    this.beginOffset = Offset.zero,
    this.endOffset = Offset.zero,
    this.beginOpacity = 1.0,
    this.endOpacity = 1.0,
    this.overshoot = 1.0,
  });

  ConduitMotionSpec copyWith({
    Duration? duration,
    Curve? curve,
    double? beginScale,
    double? endScale,
    Offset? beginOffset,
    Offset? endOffset,
    double? beginOpacity,
    double? endOpacity,
    double? overshoot,
  }) {
    return ConduitMotionSpec(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      beginScale: beginScale ?? this.beginScale,
      endScale: endScale ?? this.endScale,
      beginOffset: beginOffset ?? this.beginOffset,
      endOffset: endOffset ?? this.endOffset,
      beginOpacity: beginOpacity ?? this.beginOpacity,
      endOpacity: endOpacity ?? this.endOpacity,
      overshoot: overshoot ?? this.overshoot,
    );
  }
}

class ConduitMotionPack {
  static const Map<String, int> durationsMs = <String, int>{
    'instant': 0,
    'fast': 90,
    'normal': 150,
    'slow': 220,
    'slower': 320,
  };

  static final Map<String, ConduitMotionSpec> _named =
      <String, ConduitMotionSpec>{
        'instant': const ConduitMotionSpec(
          duration: Duration(milliseconds: 0),
          curve: Curves.linear,
        ),
        'hover': const ConduitMotionSpec(
          duration: Duration(milliseconds: 90),
          curve: Curves.easeOutCubic,
        ),
        'normal': const ConduitMotionSpec(
          duration: Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
        ),
        'press': const ConduitMotionSpec(
          duration: Duration(milliseconds: 90),
          curve: Curves.easeOutCubic,
          beginScale: 1.0,
          endScale: 0.97,
        ),
        'focus': const ConduitMotionSpec(
          duration: Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
        ),
        'os_pop': const ConduitMotionSpec(
          duration: Duration(milliseconds: 220),
          curve: Curves.easeOutBack,
          beginScale: 0.96,
          endScale: 1.0,
          beginOffset: Offset(0, 8),
          endOffset: Offset.zero,
          beginOpacity: 0.0,
          endOpacity: 1.0,
          overshoot: 1.02,
        ),
        'slide': const ConduitMotionSpec(
          duration: Duration(milliseconds: 220),
          curve: Curves.easeInOutCubic,
          beginOffset: Offset(0, 8),
          endOffset: Offset.zero,
          beginOpacity: 0.0,
          endOpacity: 1.0,
        ),
        'disappear': const ConduitMotionSpec(
          duration: Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          beginScale: 1.0,
          endScale: 0.96,
          beginOpacity: 1.0,
          endOpacity: 0.0,
        ),
        'route_enter': const ConduitMotionSpec(
          duration: Duration(milliseconds: 220),
          curve: Curves.easeOutBack,
          beginScale: 0.96,
          endScale: 1.0,
          beginOffset: Offset(0, 8),
          endOffset: Offset.zero,
          beginOpacity: 0.0,
          endOpacity: 1.0,
          overshoot: 1.02,
        ),
        'route_exit': const ConduitMotionSpec(
          duration: Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          beginScale: 1.0,
          endScale: 0.96,
          beginOpacity: 1.0,
          endOpacity: 0.0,
        ),
      };

  static ConduitMotionSpec named(String name) {
    return _named[_normalizeName(name)] ?? _named['normal'] ?? _named['hover']!;
  }

  static ConduitMotionSpec resolve(
    Object? raw, {
    Map<String, Object?>? pack,
    String fallbackName = 'hover',
  }) {
    ConduitMotionSpec base = named(fallbackName);
    if (raw is String && raw.trim().isNotEmpty) {
      final key = _normalizeName(raw);
      if (_named.containsKey(key)) return _named[key]!;
      if (pack != null) {
        final packed = pack[key];
        if (packed is Map) {
          base = _applyMap(base, coerceObjectMap(packed));
          return base;
        }
      }
      return base;
    }
    if (raw is Map) {
      return _applyMap(base, coerceObjectMap(raw));
    }
    return base;
  }

  static ConduitMotionSpec _applyMap(
    ConduitMotionSpec base,
    Map<String, Object?> map,
  ) {
    final durationMs =
        coerceOptionalInt(map['duration_ms'] ?? map['duration']) ??
        durationsMs[_normalizeName(map['speed']?.toString() ?? '')];
    final curve = _curveFromName(map['curve']?.toString()) ?? base.curve;
    final beginScale = coerceDouble(map['begin_scale'] ?? map['from_scale']);
    final endScale = coerceDouble(map['end_scale'] ?? map['to_scale']);
    final beginOpacity = coerceDouble(
      map['begin_opacity'] ?? map['from_opacity'],
    );
    final endOpacity = coerceDouble(map['end_opacity'] ?? map['to_opacity']);
    final beginOffset = _coerceOffset(
      map['begin_offset'] ?? map['from_offset'] ?? map['offset_from'],
    );
    final endOffset = _coerceOffset(
      map['end_offset'] ?? map['to_offset'] ?? map['offset_to'],
    );
    final overshoot = coerceDouble(map['overshoot']);
    return base.copyWith(
      duration: durationMs == null
          ? base.duration
          : Duration(milliseconds: durationMs.clamp(0, 10 * 1000)),
      curve: curve,
      beginScale: beginScale ?? base.beginScale,
      endScale: endScale ?? base.endScale,
      beginOpacity: beginOpacity ?? base.beginOpacity,
      endOpacity: endOpacity ?? base.endOpacity,
      beginOffset: beginOffset ?? base.beginOffset,
      endOffset: endOffset ?? base.endOffset,
      overshoot: overshoot ?? base.overshoot,
    );
  }

  static Offset? _coerceOffset(Object? value) {
    if (value is List && value.length >= 2) {
      return Offset(
        coerceDouble(value[0]) ?? 0.0,
        coerceDouble(value[1]) ?? 0.0,
      );
    }
    if (value is Map) {
      final map = coerceObjectMap(value);
      return Offset(
        coerceDouble(map['x']) ?? 0.0,
        coerceDouble(map['y']) ?? 0.0,
      );
    }
    return null;
  }

  static Curve? _curveFromName(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    switch (_normalizeName(value)) {
      case 'linear':
        return Curves.linear;
      case 'ease':
      case 'ease_in_out':
        return Curves.easeInOut;
      case 'ease_in':
        return Curves.easeIn;
      case 'ease_out':
        return Curves.easeOut;
      case 'ease_out_cubic':
      case 'slide':
        return Curves.easeOutCubic;
      case 'os_pop':
      case 'spring':
      case 'spring_pop':
        return Curves.easeOutBack;
      case 'disappear':
        return Curves.easeOutCubic;
      default:
        return Curves.easeOutCubic;
    }
  }

  static String _normalizeName(String value) {
    return value.trim().toLowerCase().replaceAll('-', '_').replaceAll(' ', '_');
  }
}
