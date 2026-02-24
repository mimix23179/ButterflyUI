import '../studio_contract.dart';

class StudioCandyBridge {
  final Map<String, Object?> _hooks = <String, Object?>{};

  void loadFrom(Map<String, Object?> source) {
    _hooks
      ..clear()
      ..addAll(studioCoerceObjectMap(source));
  }

  void applyTokenSnapshot(Map<String, Object?> tokens) {
    _hooks['tokens'] = deepCopyStudioMap(tokens);
    _hooks['updated_ms'] = DateTime.now().millisecondsSinceEpoch;
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      for (final entry in _hooks.entries)
        entry.key: deepCopyStudioValue(entry.value),
    };
  }
}
