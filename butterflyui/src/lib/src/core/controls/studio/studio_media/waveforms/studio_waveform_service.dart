import '../../studio_contract.dart';

class StudioWaveformService {
  final Map<String, List<double>> _index = <String, List<double>>{};

  Map<String, List<double>> get index =>
      Map<String, List<double>>.unmodifiable(_index);

  void loadFrom(Map<String, Object?> source) {
    _index.clear();
    final waveforms = studioCoerceObjectMap(source['index']);
    for (final entry in waveforms.entries) {
      final key = entry.key.trim();
      if (key.isEmpty || entry.value is! List) continue;
      final values = <double>[];
      for (final raw in entry.value as List) {
        final value = (raw as num?)?.toDouble();
        if (value != null) values.add(value);
      }
      _index[key] = values;
    }
  }

  void register(String assetId, List<double> samples) {
    final id = assetId.trim();
    if (id.isEmpty) return;
    _index[id] = List<double>.from(samples);
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'index': <String, Object?>{
        for (final entry in _index.entries) entry.key: entry.value,
      },
    };
  }
}
