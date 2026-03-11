import 'dart:math' as math;

import 'package:csslib/parser.dart' as css;

import 'theme.dart';
import '../control_utils.dart';

String _normStyleToken(String value) {
  return value.trim().toLowerCase().replaceAll('-', '_').replaceAll(' ', '_');
}

/// Normalizes `class_name`, `classes`, or `class` payloads into one internal
/// list of Styling class tokens.
List<String> normalizeStylingClassNames(Object? value) {
  if (value == null) return const <String>[];
  if (value is String) {
    return value
        .split(RegExp(r'[\s,]+'))
        .map((part) => _normStyleToken(part))
        .where((part) => part.isNotEmpty)
        .toList(growable: false);
  }
  if (value is List) {
    return value
        .where((item) => item != null)
        .map((item) => _normStyleToken(item.toString()))
        .where((part) => part.isNotEmpty)
        .toList(growable: false);
  }
  final normalized = _normStyleToken(value.toString());
  if (normalized.isEmpty) return const <String>[];
  return <String>[normalized];
}

double? _breakpointWidth(String? value) {
  switch (_normStyleToken(value ?? '')) {
    case 'sm':
      return 640;
    case 'md':
      return 768;
    case 'lg':
      return 1024;
    case 'xl':
      return 1280;
    case '2xl':
    case 'xxl':
      return 1536;
    default:
      return null;
  }
}

Map<String, Object?> _asObjectMap(Object? value) {
  if (value is Map) {
    return coerceObjectMap(value);
  }
  return <String, Object?>{};
}

List<String> _coerceStringList(Object? value) {
  return normalizeStylingClassNames(value);
}

String _resolveControlState(Map<String, Object?> props) {
  final explicitState = props['state']?.toString().trim();
  if (explicitState != null && explicitState.isNotEmpty) {
    return _normStyleToken(explicitState);
  }
  if (props['pressed'] == true ||
      props['is_pressed'] == true ||
      props['active'] == true) {
    return 'pressed';
  }
  if (props['hovered'] == true || props['is_hovered'] == true) {
    return 'hover';
  }
  if (props['focused'] == true || props['is_focused'] == true) {
    return 'focused';
  }
  if (props['disabled'] == true || props['enabled'] == false) {
    return 'disabled';
  }
  return 'idle';
}

Object? _normalizeDeclarationValue(Object? value) {
  if (value is Map) {
    final normalized = <String, Object?>{};
    value.forEach((key, nestedValue) {
      normalized[_normStyleToken(key.toString())] = _normalizeDeclarationValue(
        nestedValue,
      );
    });
    return normalized;
  }
  if (value is List) {
    return value.map(_normalizeDeclarationValue).toList(growable: false);
  }
  return value;
}

Object? _coerceEffectPresetValue(Object? value, {required String position}) {
  if (value == null) return null;
  if (value is List) {
    return value
        .where((item) => item != null)
        .map((item) => _coerceEffectPresetValue(item, position: position))
        .whereType<Object?>()
        .expand((item) => item is List ? item : <Object?>[item])
        .toList(growable: false);
  }
  if (value is Map) {
    final map = _asObjectMap(value);
    return <String, Object?>{
      if (!map.containsKey('position')) 'position': position,
      ...map,
    };
  }
  final token = _normStyleToken(value.toString());
  if (token.isEmpty) return null;
  return <String, Object?>{'type': token, 'position': position};
}

Object? _coerceEffectsValue(Object? value) {
  if (value == null) return null;
  if (value is List) {
    return value
        .where((item) => item != null)
        .map(_coerceEffectsValue)
        .whereType<Object?>()
        .expand((item) => item is List ? item : <Object?>[item])
        .toList(growable: false);
  }
  if (value is Map) {
    return _asObjectMap(value);
  }
  final token = _normStyleToken(value.toString());
  if (token.isEmpty) return null;
  return <String, Object?>{'type': token};
}

Map<String, Object?> _normalizeDeclarations(Map<String, Object?> source) {
  final normalized = <String, Object?>{};
  final slotStyles = <String, Object?>{};
  final tokenOverrides = <String, Object?>{};
  source.forEach((rawKey, rawValue) {
    final key = rawKey.startsWith('token:')
        ? rawKey
        : _normStyleToken(rawKey);
    final value = _normalizeDeclarationValue(rawValue);
    if (key.startsWith('token:')) {
      _writeTokenOverride(tokenOverrides, key.substring(6), value);
      return;
    }
    final slotMatch = RegExp(
      r'^(label|icon|content|field|placeholder|helper|surface)_(.+)$',
    ).firstMatch(key);
    if (slotMatch != null) {
      _writeSlotDeclaration(
        slotStyles,
        slotMatch.group(1)!,
        slotMatch.group(2)!,
        value,
      );
      return;
    }
    switch (key) {
      case 'role':
      case 'text_role':
        normalized['type_role'] = value;
        break;
      case 'background_color':
        normalized['bgcolor'] = value;
        break;
      case 'border_radius':
        normalized['radius'] = value;
        break;
      case 'box_shadow':
        normalized['shadow'] = value;
        break;
      case 'motion_preset':
        normalized['motion'] = value;
        break;
      case 'mix_blend_mode':
      case 'blend_mode':
      case 'background_blend_mode':
      case 'foreground_blend_mode':
      case 'scene_blend_mode':
      case 'clip_behavior':
      case 'scene_opacity':
      case 'background_layer_opacity':
      case 'foreground_layer_opacity':
      case 'scene_scrim':
      case 'scene_scrim_color':
      case 'scene_scrim_opacity':
      case 'scene_isolation':
        normalized[key] = value;
        break;
      case 'background_effect':
        final resolved = _coerceEffectPresetValue(
          value,
          position: 'background',
        );
        if (resolved != null) {
          normalized['background_layers'] = resolved;
        }
        break;
      case 'foreground_effect':
        final resolved = _coerceEffectPresetValue(value, position: 'overlay');
        if (resolved != null) {
          normalized['foreground_layers'] = resolved;
        }
        break;
      case 'overlay_effect':
        final resolved = _coerceEffectPresetValue(value, position: 'overlay');
        if (resolved != null) {
          normalized['overlay_layers'] = resolved;
        }
        break;
      case 'hover_background_effect':
      case 'hover_effect':
        final resolved = _coerceEffectPresetValue(
          value,
          position: 'background',
        );
        if (resolved != null) {
          normalized['hover_background_layers'] = resolved;
        }
        break;
      case 'effect':
      case 'effects':
        final resolved = _coerceEffectsValue(value);
        if (resolved != null) {
          normalized['effects'] = resolved;
        }
        break;
      default:
        normalized[key] = value;
        break;
    }
  });
  if (slotStyles.isNotEmpty) {
    normalized['style_slots'] = slotStyles;
  }
  if (tokenOverrides.isNotEmpty) {
    normalized['style_tokens'] = tokenOverrides;
  }
  return normalized;
}

Map<String, Object?> normalizeStylingDeclarations(Map<String, Object?> source) {
  return _normalizeDeclarations(source);
}

Object? resolveStylingTokenValue(Object? value, StylingTokens tokens) {
  if (value is Map) {
    final resolved = <String, Object?>{};
    value.forEach((key, nestedValue) {
      resolved[key.toString()] = resolveStylingTokenValue(nestedValue, tokens);
    });
    return resolved;
  }
  if (value is List) {
    return value
        .map((item) => resolveStylingTokenValue(item, tokens))
        .toList(growable: false);
  }
  if (value is! String) return value;

  final raw = value.trim();
  final varMatch = RegExp(
    r'^var\(\s*--([A-Za-z0-9_.\-]+)\s*(?:,\s*(.+))?\)$',
  ).firstMatch(raw);
  final tokenMatch = RegExp(
    r'^token\(\s*([A-Za-z0-9_.\-]+)\s*(?:,\s*(.+))?\)$',
  ).firstMatch(raw);
  final tokenName = varMatch?.group(1) ?? tokenMatch?.group(1);
  if (tokenName == null || tokenName.trim().isEmpty) {
    return value;
  }
  final resolved = _lookupStylingTokenValue(tokenName, tokens);
  if (resolved != null) {
    return resolved;
  }
  final fallback = varMatch?.group(2) ?? tokenMatch?.group(2);
  if (fallback == null || fallback.trim().isEmpty) {
    return value;
  }
  return resolveStylingTokenValue(_parseTokenFallbackLiteral(fallback), tokens);
}

Map<String, Object?> resolveStylingTokenReferences(
  Map<String, Object?> source,
  StylingTokens tokens,
) {
  final resolved = resolveStylingTokenValue(source, tokens);
  if (resolved is Map) {
    return coerceObjectMap(resolved);
  }
  return Map<String, Object?>.from(source);
}

RuntimeStyleSheet runtimeStyleSheetFromInlineCss(
  String source, {
  String selector = '*',
}) {
  final trimmed = source.trim();
  if (trimmed.isEmpty) {
    return RuntimeStyleSheet.empty;
  }
  final hasRuleBlock = trimmed.contains('{') && trimmed.contains('}');
  if (hasRuleBlock) {
    return RuntimeStyleSheet.fromSource(trimmed);
  }
  return RuntimeStyleSheet.fromSource('$selector { $trimmed }');
}

Object? _lookupStylingTokenValue(String tokenName, StylingTokens tokens) {
  final normalized = _normStyleToken(tokenName);
  if (normalized.contains('.')) {
    final parts = normalized
        .split('.')
        .where((part) => part.isNotEmpty)
        .toList(growable: false);
    if (parts.isNotEmpty) {
      return _lookupNestedTokenValue(tokens.toJson(), parts);
    }
  }
  switch (normalized) {
    case 'surface':
    case 'background':
    case 'text':
    case 'muted_text':
    case 'border':
    case 'primary':
    case 'secondary':
    case 'success':
    case 'warning':
    case 'info':
    case 'error':
    case 'on_primary':
    case 'on_surface':
      return tokens.color(normalized);
    case 'radius_sm':
      return tokens.number('radii', 'sm');
    case 'radius_md':
      return tokens.number('radii', 'md');
    case 'radius_lg':
      return tokens.number('radii', 'lg');
    case 'spacing_xs':
      return tokens.number('spacing', 'xs');
    case 'spacing_sm':
      return tokens.number('spacing', 'sm');
    case 'spacing_md':
      return tokens.number('spacing', 'md');
    case 'spacing_lg':
      return tokens.number('spacing', 'lg');
    case 'font_family':
      return tokens.string('typography', 'font_family');
    case 'mono_family':
      return tokens.string('typography', 'mono_family');
    case 'body_size':
      return tokens.number('typography', 'body_size');
    case 'title_size':
      return tokens.number('typography', 'title_size');
    case 'label_size':
      return tokens.number('typography', 'label_size');
    case 'type_display_hero':
      return tokens.section('typography')['roles'] is Map
          ? coerceObjectMap(tokens.section('typography')['roles'] as Map)['display_hero']
          : null;
    case 'brightness':
      return tokens.themeString('brightness');
  }
  return null;
}

Object? _parseTokenFallbackLiteral(String source) {
  final text = source.trim();
  if (text.isEmpty) return null;
  if ((text.startsWith('"') && text.endsWith('"')) ||
      (text.startsWith("'") && text.endsWith("'"))) {
    return text.substring(1, text.length - 1);
  }
  if (text == 'true') return true;
  if (text == 'false') return false;
  if (text == 'null' || text == 'none') return null;
  final number = double.tryParse(text);
  if (number != null) {
    return text.contains('.') ? number : number.toInt();
  }
  return coerceColor(text) ?? text;
}

void _writeSlotDeclaration(
  Map<String, Object?> slotStyles,
  String slot,
  String prop,
  Object? value,
) {
  final existing = slotStyles[slot] is Map
      ? coerceObjectMap(slotStyles[slot] as Map)
      : <String, Object?>{};
  existing[prop] = value;
  slotStyles[slot] = existing;
}

void _writeTokenOverride(
  Map<String, Object?> tokenOverrides,
  String tokenName,
  Object? value,
) {
  final normalized = _normStyleToken(tokenName);
  if (normalized.isEmpty) return;
  final path = _tokenOverridePath(normalized);
  if (path.isEmpty) return;
  Map<String, Object?> cursor = tokenOverrides;
  for (var index = 0; index < path.length - 1; index += 1) {
    final segment = path[index];
    final next = cursor[segment] is Map
        ? coerceObjectMap(cursor[segment] as Map)
        : <String, Object?>{};
    cursor[segment] = next;
    cursor = next;
  }
  cursor[path.last] = value;
}

List<String> _tokenOverridePath(String token) {
  if (token.contains('.')) {
    return token
        .split('.')
        .map(_normStyleToken)
        .where((part) => part.isNotEmpty)
        .toList(growable: false);
  }
  switch (token) {
    case 'surface':
    case 'background':
    case 'text':
    case 'muted_text':
    case 'border':
    case 'primary':
    case 'secondary':
    case 'success':
    case 'warning':
    case 'info':
    case 'error':
    case 'on_primary':
    case 'on_surface':
      return <String>['colors', token];
    case 'radius_sm':
      return <String>['radii', 'sm'];
    case 'radius_md':
      return <String>['radii', 'md'];
    case 'radius_lg':
      return <String>['radii', 'lg'];
    case 'spacing_xs':
      return <String>['spacing', 'xs'];
    case 'spacing_sm':
      return <String>['spacing', 'sm'];
    case 'spacing_md':
      return <String>['spacing', 'md'];
    case 'spacing_lg':
      return <String>['spacing', 'lg'];
    case 'font_family':
      return <String>['typography', 'font_family'];
    case 'mono_family':
      return <String>['typography', 'mono_family'];
    case 'body_size':
      return <String>['typography', 'body_size'];
    case 'title_size':
      return <String>['typography', 'title_size'];
    case 'label_size':
      return <String>['typography', 'label_size'];
    case 'brightness':
      return <String>['theme', 'brightness'];
    default:
      return const <String>[];
  }
}

Object? _lookupNestedTokenValue(
  Map<String, Object?> source,
  List<String> path,
) {
  Object? cursor = source;
  for (final segment in path) {
    if (cursor is! Map) return null;
    cursor = coerceObjectMap(cursor)[segment];
  }
  return cursor;
}

Map<String, Object?> _mergeStyleMaps(
  Map<String, Object?> base,
  Map<String, Object?> overlay,
) {
  final merged = <String, Object?>{...base};
  overlay.forEach((key, value) {
    final existing = merged[key];
    if (existing is Map && value is Map) {
      merged[key] = StylingTokens.mergeMaps(
        coerceObjectMap(existing),
        coerceObjectMap(value),
      );
      return;
    }
    if (existing is List && value is List) {
      merged[key] = <Object?>[...existing, ...value];
      return;
    }
    merged[key] = value;
  });
  return merged;
}

class RuntimeStyleSelector {
  final bool isRoot;
  final String? controlType;
  final String? elementId;
  final List<String> classes;
  final String? state;
  final double? minWidth;

  const RuntimeStyleSelector({
    required this.isRoot,
    required this.controlType,
    required this.elementId,
    required this.classes,
    required this.state,
    required this.minWidth,
  });

  factory RuntimeStyleSelector.fromPayload(Object? payload) {
    final map = _asObjectMap(payload);
    return RuntimeStyleSelector(
      isRoot: map['root'] == true,
      controlType: map['type'] == null
          ? null
          : _normStyleToken(map['type'].toString()),
      elementId: map['id']?.toString(),
      classes: _coerceStringList(map['classes']),
      state: map['state'] == null
          ? null
          : _normStyleToken(map['state'].toString()),
      minWidth:
          coerceDouble(map['min_width']) ??
          _breakpointWidth(map['breakpoint']?.toString()),
    );
  }

  int get specificity =>
      isRoot
          ? 0
          :
      (elementId == null ? 0 : 100) +
      ((classes.length + (state == null ? 0 : 1)) * 10) +
      (controlType == null ? 0 : 1);

  bool matches({
    required String controlType,
    required String? elementId,
    required List<String> classes,
    required String state,
    required double viewportWidth,
  }) {
    if (isRoot) {
      return false;
    }
    if (minWidth != null && viewportWidth < minWidth!) {
      return false;
    }
    if (this.controlType != null && this.controlType != controlType) {
      return false;
    }
    if (this.elementId != null && this.elementId != elementId) {
      return false;
    }
    final matchesState =
        this.state == null ||
        this.state == state ||
        ((this.state == 'focus' || this.state == 'focused') &&
            (state == 'focus' || state == 'focused'));
    if (!matchesState) {
      return false;
    }
    for (final className in this.classes) {
      if (!classes.contains(className)) {
        return false;
      }
    }
    return true;
  }
}

class RuntimeStyleRule {
  final List<RuntimeStyleSelector> selectors;
  final Map<String, Object?> declarations;

  const RuntimeStyleRule({required this.selectors, required this.declarations});

  factory RuntimeStyleRule.fromPayload(Object? payload) {
    final map = _asObjectMap(payload);
    final selectors = <RuntimeStyleSelector>[];
    final rawSelectors = map['selectors'];
    if (rawSelectors is List) {
      for (final selector in rawSelectors) {
        selectors.add(RuntimeStyleSelector.fromPayload(selector));
      }
    }
    return RuntimeStyleRule(
      selectors: selectors,
      declarations: _normalizeDeclarations(_asObjectMap(map['declarations'])),
    );
  }
}

class RuntimeStyleSheet {
  final List<RuntimeStyleRule> rules;

  const RuntimeStyleSheet(this.rules);

  static const RuntimeStyleSheet empty = RuntimeStyleSheet(
    <RuntimeStyleRule>[],
  );

  factory RuntimeStyleSheet.fromPayload(Object? payload) {
    if (payload == null) return empty;
    if (payload is String) {
      return RuntimeStyleSheet.fromSource(payload);
    }
    final map = _asObjectMap(payload);
    final source = map['source'];
    if (source is String && source.trim().isNotEmpty) {
      return RuntimeStyleSheet.fromSource(source);
    }
    final rawRules = map['rules'];
    if (rawRules is! List) return empty;
    final rules = <RuntimeStyleRule>[];
    for (final rawRule in rawRules) {
      final rule = RuntimeStyleRule.fromPayload(rawRule);
      if (rule.selectors.isNotEmpty && rule.declarations.isNotEmpty) {
        rules.add(rule);
      }
    }
    if (rules.isEmpty) return empty;
    return RuntimeStyleSheet(rules);
  }

  factory RuntimeStyleSheet.fromSource(String source) {
    final text = source.trim();
    if (text.isEmpty) return empty;
    try {
      css.parse(text);
    } catch (_) {
      // Keep the runtime forgiving: fall back to a minimal block parser.
    }
    final rules = <RuntimeStyleRule>[];
    for (final block in _iterRuleBlocks(text)) {
      final selectors = block.$1
          .split(',')
          .map((part) => _parseInlineSelector(part))
          .whereType<RuntimeStyleSelector>()
          .toList(growable: false);
      final declarations = _parseInlineDeclarations(block.$2);
      if (selectors.isEmpty || declarations.isEmpty) continue;
      rules.add(
        RuntimeStyleRule(selectors: selectors, declarations: declarations),
      );
    }
    if (rules.isEmpty) return empty;
    return RuntimeStyleSheet(rules);
  }

  bool get isEmpty => rules.isEmpty;

  Map<String, Object?> resolveProps({
    required String controlType,
    required Map<String, Object?> props,
    double viewportWidth = 1280,
  }) {
    if (rules.isEmpty) return const <String, Object?>{};
    final elementId = props['id']?.toString() ?? props['key']?.toString();
    final classes = <String>{
      ..._coerceStringList(props['classes']),
      ..._coerceStringList(props['class_name']),
      ..._coerceStringList(props['class']),
    }.toList(growable: false);
    final state = _resolveControlState(props);
    final normalizedType = _normStyleToken(controlType);
    final matchedRules = <_RuntimeRuleMatch>[];
    for (var index = 0; index < rules.length; index += 1) {
      final rule = rules[index];
      final matchingSpecificities = rule.selectors
          .where(
            (selector) => selector.matches(
              controlType: normalizedType,
              elementId: elementId,
              classes: classes,
              state: state,
              viewportWidth: viewportWidth,
            ),
          )
          .map((selector) => selector.specificity)
          .toList(growable: false);
      if (matchingSpecificities.isEmpty) continue;
      matchedRules.add(
        _RuntimeRuleMatch(
          order: index,
          specificity: matchingSpecificities.reduce(math.max),
          declarations: rule.declarations,
        ),
      );
    }
    matchedRules.sort((left, right) {
      final specificityCompare = left.specificity.compareTo(right.specificity);
      if (specificityCompare != 0) return specificityCompare;
      return left.order.compareTo(right.order);
    });
    var resolved = <String, Object?>{};
    for (final match in matchedRules) {
      resolved = _mergeStyleMaps(resolved, match.declarations);
    }
    return resolved;
  }

  Map<String, Object?> resolveTokenOverrides({
    double viewportWidth = 1280,
  }) {
    if (rules.isEmpty) return const <String, Object?>{};
    var resolved = <String, Object?>{};
    for (var index = 0; index < rules.length; index += 1) {
      final rule = rules[index];
      final matchingRoot = rule.selectors.any(
        (selector) =>
            selector.isRoot &&
            (selector.minWidth == null || viewportWidth >= selector.minWidth!),
      );
      if (!matchingRoot) continue;
      final tokenLayer = _asObjectMap(rule.declarations['style_tokens']);
      if (tokenLayer.isEmpty) continue;
      resolved = StylingTokens.mergeMaps(resolved, tokenLayer);
    }
    return resolved;
  }
}

class _RuntimeRuleMatch {
  final int order;
  final int specificity;
  final Map<String, Object?> declarations;

  const _RuntimeRuleMatch({
    required this.order,
    required this.specificity,
    required this.declarations,
  });
}

List<(String, String)> _iterRuleBlocks(String source) {
  final blocks = <(String, String)>[];
  final length = source.length;
  var index = 0;
  while (index < length) {
    while (index < length && source[index].trim().isEmpty) {
      index += 1;
    }
    if (index >= length) break;
    final selectorStart = index;
    while (index < length && source[index] != '{') {
      index += 1;
    }
    if (index >= length) break;
    final selector = source.substring(selectorStart, index).trim();
    index += 1;
    final bodyStart = index;
    var depth = 1;
    while (index < length && depth > 0) {
      final char = source[index];
      if (char == '{') {
        depth += 1;
      } else if (char == '}') {
        depth -= 1;
      }
      index += 1;
    }
    if (selector.isEmpty) continue;
    final body = source.substring(bodyStart, index - 1).trim();
    if (body.isEmpty) continue;
    blocks.add((selector, body));
  }
  return blocks;
}

RuntimeStyleSelector? _parseInlineSelector(String selector) {
  var raw = selector.trim();
  if (raw.isEmpty) return null;
  double? minWidth;
  if (raw.startsWith('@')) {
    final breakpointMatch = RegExp(r'^@([A-Za-z0-9_]+)\s+(.*)$').firstMatch(raw);
    if (breakpointMatch != null) {
      minWidth = _breakpointWidth(breakpointMatch.group(1));
      raw = (breakpointMatch.group(2) ?? '').trim();
    }
  }
  if (raw.isEmpty) return null;
  final isRoot = raw == ':root' || _normStyleToken(raw) == 'root';
  if (isRoot) {
    return RuntimeStyleSelector(
      isRoot: true,
      controlType: null,
      elementId: null,
      classes: const <String>[],
      state: null,
      minWidth: minWidth,
    );
  }
  var main = raw;
  String? state;
  final stateIndex = raw.indexOf(':');
  if (stateIndex >= 0) {
    main = raw.substring(0, stateIndex);
    state = _normStyleToken(raw.substring(stateIndex + 1));
  }
  String? controlType;
  String? elementId;
  final classes = <String>[];
  final matches = RegExp(r'(#[A-Za-z_][\w-]*)|(\.[A-Za-z_][\w-]*)|([A-Za-z_*][\w-]*)')
      .allMatches(main);
  for (final match in matches) {
    final token = match.group(0);
    if (token == null || token.isEmpty || token == '*') continue;
    if (token.startsWith('#')) {
      elementId = token.substring(1);
      continue;
    }
    if (token.startsWith('.')) {
      classes.add(_normStyleToken(token.substring(1)));
      continue;
    }
    controlType = _normStyleToken(token);
  }
  return RuntimeStyleSelector(
    isRoot: false,
    controlType: controlType,
    elementId: elementId,
    classes: classes,
    state: state,
    minWidth: minWidth,
  );
}

Map<String, Object?> _parseInlineDeclarations(String body) {
  final declarations = <String, Object?>{};
  for (final entry in body.split(';')) {
    final trimmed = entry.trim();
    if (trimmed.isEmpty) continue;
    final colon = trimmed.indexOf(':');
    if (colon <= 0) continue;
    final rawName = trimmed.substring(0, colon).trim();
    final name = rawName.startsWith('--')
        ? 'token:${_normStyleToken(rawName.substring(2))}'
        : _normStyleToken(rawName);
    final rawValue = trimmed.substring(colon + 1).trim();
    if (rawValue.isEmpty) continue;
    final normalizedName = switch (name) {
      'role' => 'type_role',
      'background_color' => 'bgcolor',
      'border_radius' => 'radius',
      'box_shadow' => 'shadow',
      _ => name,
    };
    declarations[normalizedName] = _parseInlineValue(
      normalizedName,
      rawValue,
    );
  }
  return _normalizeDeclarations(declarations);
}

Object? _parseInlineValue(String name, String rawValue) {
  final trimmed = rawValue.trim();
  if (trimmed.isEmpty) return null;
  if ((trimmed.startsWith('"') && trimmed.endsWith('"')) ||
      (trimmed.startsWith("'") && trimmed.endsWith("'"))) {
    return trimmed.substring(1, trimmed.length - 1);
  }
  if (trimmed == 'true') return true;
  if (trimmed == 'false') return false;
  if (trimmed == 'null' || trimmed == 'none') return null;
  final number = double.tryParse(trimmed);
  if (number != null) {
    return trimmed.contains('.') ? number : number.toInt();
  }
  if ((name == 'effect' ||
          name == 'effects' ||
          name == 'background_effect' ||
          name == 'foreground_effect' ||
          name == 'overlay_effect' ||
          name == 'hover_effect' ||
          name == 'hover_background_effect') &&
      trimmed.contains(',')) {
    return trimmed
        .split(',')
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList(growable: false);
  }
  return trimmed;
}
