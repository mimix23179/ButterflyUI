import 'control_utils.dart';

String _snakeCaseRuntimeKey(String key) {
  if (key.isEmpty) return key;
  final buffer = StringBuffer();
  for (var i = 0; i < key.length; i += 1) {
    final char = key[i];
    final code = char.codeUnitAt(0);
    final isUpper = code >= 65 && code <= 90;
    if (isUpper) {
      if (i > 0 && key[i - 1] != '_') {
        buffer.write('_');
      }
      buffer.write(char.toLowerCase());
    } else if (char == '-' || char == ' ') {
      buffer.write('_');
    } else {
      buffer.write(char);
    }
  }
  return buffer.toString();
}

Object? _normalizeRuntimePropValue(Object? value) {
  if (value is Map) {
    return value.map(
      (key, entry) =>
          MapEntry(key.toString(), _normalizeRuntimePropValue(entry)),
    );
  }
  if (value is List) {
    return value.map(_normalizeRuntimePropValue).toList();
  }
  return value;
}

class RuntimeControlNode {
  RuntimeControlNode(this.raw);

  final Map<String, Object?> raw;

  static const Map<String, String> _propAliases = <String, String>{
    'background_color': 'bgcolor',
    'bg_color': 'bgcolor',
    'bordercolor': 'border_color',
    'borderwidth': 'border_width',
    'crossaxis': 'cross_axis',
    'mainaxis': 'main_axis',
    'mainaxissize': 'main_axis_size',
    'runspacing': 'run_spacing',
    'textcolor': 'text_color',
  };

  late final Map<String, Object?> props = _buildProps();

  String get id => raw['id']?.toString() ?? '';

  String get type => raw['type']?.toString() ?? '';

  List<Map<String, Object?>> get children {
    final rawChildren = raw['children'];
    if (rawChildren is! List) return const <Map<String, Object?>>[];
    return rawChildren
        .whereType<Map>()
        .map((entry) => coerceObjectMap(entry))
        .toList();
  }

  Set<String> get events {
    final rawEvents = props['events'];
    if (rawEvents is! List) return const <String>{};
    return rawEvents
        .map((event) => _snakeCaseRuntimeKey(event?.toString() ?? ''))
        .where((event) => event.isNotEmpty)
        .toSet();
  }

  bool hasEvent(String eventName) {
    final normalized = _snakeCaseRuntimeKey(eventName);
    if (normalized.isEmpty) return false;
    return events.contains(normalized);
  }

  Object? prop(String name, [Object? fallback]) {
    final normalized = _snakeCaseRuntimeKey(name);
    if (props.containsKey(normalized)) {
      return props[normalized];
    }
    return fallback;
  }

  Map<String, Object?>? childProp(String name) {
    final value = prop(name);
    if (value is Map) {
      return coerceObjectMap(value);
    }
    return null;
  }

  List<Map<String, Object?>> childListProp(String name) {
    final value = prop(name);
    if (value is! List) return const <Map<String, Object?>>[];
    return value
        .whereType<Map>()
        .map((entry) => coerceObjectMap(entry))
        .toList();
  }

  Map<String, Object?> _buildProps() {
    final rawProps = raw['props'];
    if (rawProps is! Map) {
      return <String, Object?>{};
    }
    final source = coerceObjectMap(rawProps);
    final normalized = <String, Object?>{};
    source.forEach((key, value) {
      normalized[key] = _normalizeRuntimePropValue(value);
      final snake = _snakeCaseRuntimeKey(key);
      normalized.putIfAbsent(snake, () => _normalizeRuntimePropValue(value));
    });
    _propAliases.forEach((alias, canonical) {
      if (normalized.containsKey(alias) && !normalized.containsKey(canonical)) {
        normalized[canonical] = normalized[alias];
      }
    });
    return normalized;
  }
}
