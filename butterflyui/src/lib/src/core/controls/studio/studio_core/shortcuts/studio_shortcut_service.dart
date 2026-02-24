import '../../studio_contract.dart';

class StudioShortcutService {
  final Map<String, Map<String, Map<String, Object?>>> _keymaps =
      <String, Map<String, Map<String, Object?>>>{};

  void loadFrom(Map<String, Object?> source) {
    _keymaps.clear();
    final keymaps = studioCoerceObjectMap(source['keymaps']);
    for (final contextEntry in keymaps.entries) {
      final contextId = studioNorm(contextEntry.key);
      if (contextId.isEmpty || contextEntry.value is! Map) continue;
      final mappings = studioCoerceObjectMap(contextEntry.value);
      final out = <String, Map<String, Object?>>{};
      for (final binding in mappings.entries) {
        final chord = _normalizeChord(binding.key);
        if (chord.isEmpty || binding.value is! Map) continue;
        out[chord] = studioCoerceObjectMap(binding.value);
      }
      _keymaps[contextId] = out;
    }
  }

  Map<String, Object?> register({
    required String context,
    required String chord,
    required String command,
    Map<String, Object?> payload = const <String, Object?>{},
  }) {
    final contextId = studioNorm(context);
    final normalizedChord = _normalizeChord(chord);
    final commandId = studioNorm(command);
    if (contextId.isEmpty || normalizedChord.isEmpty || commandId.isEmpty) {
      return <String, Object?>{
        'ok': false,
        'error': 'context, chord and command are required',
      };
    }
    final mappings = _keymaps.putIfAbsent(
      contextId,
      () => <String, Map<String, Object?>>{},
    );
    mappings[normalizedChord] = <String, Object?>{
      'command': commandId,
      'payload': payload,
    };
    return <String, Object?>{
      'ok': true,
      'context': contextId,
      'chord': normalizedChord,
      'command': commandId,
      'payload': payload,
    };
  }

  Map<String, Object?>? resolve(String context, String chord) {
    final contextId = studioNorm(context);
    final normalizedChord = _normalizeChord(chord);
    final contextMap = _keymaps[contextId];
    if (contextMap == null) return null;
    return contextMap[normalizedChord];
  }

  String _normalizeChord(String chord) {
    return chord
        .trim()
        .toLowerCase()
        .replaceAll(' ', '')
        .replaceAll('command', 'meta');
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'keymaps': <String, Object?>{
        for (final context in _keymaps.entries) context.key: context.value,
      },
    };
  }
}
