import '../candy/theme.dart';
import '../control_utils.dart';
import 'style_pack.dart';

class ResolvedControlStyle {
  final String controlType;
  final CandyTokens tokens;
  final Map<String, Object?> component;
  final Map<String, Object?> local;
  final Map<String, String> variantSelection;
  final String state;
  final StylePack stylePack;

  const ResolvedControlStyle({
    required this.controlType,
    required this.tokens,
    required this.component,
    required this.local,
    required this.variantSelection,
    required this.state,
    required this.stylePack,
  });

  Map<String, Object?> slot(String slot, {String? state}) {
    final normalizedSlot = _norm(slot);
    final resolvedState = _norm(state ?? this.state);
    var merged = <String, Object?>{};

    merged = CandyTokens.mergeMaps(
      merged,
      _readSlotMap(component, normalizedSlot),
    );

    final variants = _asMap(component['variants']);
    for (final entry in variantSelection.entries) {
      final axis = _asMap(variants[entry.key]);
      if (axis.isEmpty) continue;
      final choice = _asMap(axis[entry.value]);
      if (choice.isEmpty) continue;
      merged = CandyTokens.mergeMaps(merged, _readSlotMap(choice, normalizedSlot));
    }

    final states = _asMap(component['states']);
    final stateLayer = _asMap(states[resolvedState]);
    if (stateLayer.isNotEmpty) {
      merged = CandyTokens.mergeMaps(merged, _readSlotMap(stateLayer, normalizedSlot));
    }

    merged = CandyTokens.mergeMaps(merged, _readSlotMap(local, normalizedSlot));
    return merged;
  }

  List<Object?> defaultModifiers() {
    final localMods = local['modifiers'];
    if (localMods is List) return localMods.cast<Object?>();
    final componentMods = component['modifiers'];
    if (componentMods is List) return componentMods.cast<Object?>();
    return const <Object?>[];
  }

  Object? defaultMotion() {
    if (local.containsKey('motion')) return local['motion'];
    if (component.containsKey('motion')) return component['motion'];
    return null;
  }

  Object? value(String key) {
    if (local.containsKey(key)) return local[key];
    if (component.containsKey(key)) return component[key];
    return null;
  }

  Map<String, Object?> _readSlotMap(
    Map<String, Object?> source,
    String normalizedSlot,
  ) {
    if (source.isEmpty) return const <String, Object?>{};
    final out = <String, Object?>{};

    final slots = _asMap(source['slots']);
    if (slots.isNotEmpty) {
      out.addAll(_asMap(slots[normalizedSlot]));
    }

    out.addAll(_asMap(source[normalizedSlot]));

    if (normalizedSlot == 'surface') {
      for (final entry in source.entries) {
        final key = _norm(entry.key);
        if (_reservedKeys.contains(key)) continue;
        if (entry.value is Map) continue;
        out[entry.key] = entry.value;
      }
    }
    return out;
  }

  static Map<String, Object?> _asMap(Object? value) {
    if (value is Map) return coerceObjectMap(value);
    return <String, Object?>{};
  }

  static String _norm(String value) {
    return value.trim().toLowerCase().replaceAll('-', '_').replaceAll(' ', '_');
  }

  static const Set<String> _reservedKeys = <String>{
    'slots',
    'variants',
    'states',
    'modifiers',
    'motion',
  };
}

class ControlStyleResolver {
  static ResolvedControlStyle resolve({
    required String controlType,
    required Map<String, Object?> props,
    required CandyTokens tokens,
    required StylePack stylePack,
  }) {
    final normalizedType = _canonicalControlType(controlType);
    final componentStyles = _asMap(stylePack.componentStyles);
    final component = _asMap(componentStyles[normalizedType]);
    final local = _asMap(props['style']);
    final state = _resolveState(props, local);
    final variants = _resolveVariants(props, local);
    return ResolvedControlStyle(
      controlType: normalizedType,
      tokens: tokens,
      component: component,
      local: local,
      variantSelection: variants,
      state: state,
      stylePack: stylePack,
    );
  }

  static Map<String, String> _resolveVariants(
    Map<String, Object?> props,
    Map<String, Object?> local,
  ) {
    final out = <String, String>{};
    final variantRaw = local['variant'] ?? props['variant'];
    if (variantRaw is String && variantRaw.trim().isNotEmpty) {
      out['intent'] = _norm(variantRaw);
    } else if (variantRaw is Map) {
      for (final entry in variantRaw.entries) {
        if (entry.value == null) continue;
        out[_norm(entry.key.toString())] = _norm(entry.value.toString());
      }
    }

    for (final axis in <String>['intent', 'size', 'density', 'tone']) {
      final localValue = local[axis];
      final propValue = props[axis];
      final value = localValue ?? propValue;
      if (value != null) {
        out[axis] = _norm(value.toString());
      }
    }
    return out;
  }

  static String _resolveState(
    Map<String, Object?> props,
    Map<String, Object?> local,
  ) {
    final localState = local['state']?.toString();
    if (localState != null && localState.trim().isNotEmpty) {
      return _norm(localState);
    }
    final propState = props['state']?.toString();
    if (propState != null && propState.trim().isNotEmpty) {
      return _norm(propState);
    }
    final pressed =
        props['pressed'] == true ||
        props['is_pressed'] == true ||
        props['active'] == true;
    if (pressed) return 'pressed';
    final hovered = props['hovered'] == true || props['is_hovered'] == true;
    if (hovered) return 'hover';
    final focused = props['focused'] == true || props['is_focused'] == true;
    if (focused) return 'focused';
    if (props['disabled'] == true || props['enabled'] == false) {
      return 'disabled';
    }
    if (props['loading'] == true) {
      return 'loading';
    }
    return 'idle';
  }

  static Map<String, Object?> _asMap(Object? value) {
    if (value is Map) return coerceObjectMap(value);
    return const <String, Object?>{};
  }

  static String _norm(String value) {
    return value.trim().toLowerCase().replaceAll('-', '_').replaceAll(' ', '_');
  }

  static String _canonicalControlType(String value) {
    var normalized = _norm(value);
    switch (normalized) {
      case 'container':
      case 'box':
        return 'surface';
      default:
        return normalized;
    }
  }
}
