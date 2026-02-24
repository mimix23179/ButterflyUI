import 'package:vector_math/vector_math_64.dart' as vm;
import 'package:butterflyui_runtime/src/core/control_utils.dart';

import '../../studio_contract.dart';

class StudioTransformSnapshot {
  StudioTransformSnapshot({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.rotationDeg,
    required this.scaleX,
    required this.scaleY,
  });

  final double x;
  final double y;
  final double width;
  final double height;
  final double rotationDeg;
  final double scaleX;
  final double scaleY;

  vm.Matrix4 toMatrix() {
    return vm.Matrix4.identity()
      ..translateByDouble(x, y, 0, 1)
      ..rotateZ(vm.radians(rotationDeg))
      ..scaleByDouble(scaleX, scaleY, 1, 1);
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'rotation': rotationDeg,
      'scale_x': scaleX,
      'scale_y': scaleY,
    };
  }

  factory StudioTransformSnapshot.fromMap(Map<String, Object?> map) {
    return StudioTransformSnapshot(
      x: coerceDouble(map['x']) ?? 0,
      y: coerceDouble(map['y']) ?? 0,
      width: coerceDouble(map['width']) ?? 160,
      height: coerceDouble(map['height']) ?? 100,
      rotationDeg: coerceDouble(map['rotation']) ?? 0,
      scaleX: coerceDouble(map['scale_x']) ?? 1,
      scaleY: coerceDouble(map['scale_y']) ?? 1,
    );
  }
}

class StudioTransformService {
  final Map<String, StudioTransformSnapshot> _entityTransforms =
      <String, StudioTransformSnapshot>{};

  void loadFrom(Map<String, Object?> payload) {
    _entityTransforms.clear();
    final entries = studioCoerceObjectMap(payload['entities']);
    for (final entry in entries.entries) {
      final id = entry.key.trim();
      if (id.isEmpty || entry.value is! Map) continue;
      _entityTransforms[id] = StudioTransformSnapshot.fromMap(
        studioCoerceObjectMap(entry.value),
      );
    }
  }

  StudioTransformSnapshot getTransform(String entityId) {
    final id = entityId.trim();
    return _entityTransforms[id] ??
        StudioTransformSnapshot(
          x: 0,
          y: 0,
          width: 160,
          height: 100,
          rotationDeg: 0,
          scaleX: 1,
          scaleY: 1,
        );
  }

  void setTransform(String entityId, StudioTransformSnapshot snapshot) {
    final id = entityId.trim();
    if (id.isEmpty) return;
    _entityTransforms[id] = snapshot;
  }

  Map<String, Object?> toMap() {
    final entities = <String, Object?>{};
    for (final entry in _entityTransforms.entries) {
      entities[entry.key] = entry.value.toMap();
    }
    return <String, Object?>{'entities': entities};
  }
}
