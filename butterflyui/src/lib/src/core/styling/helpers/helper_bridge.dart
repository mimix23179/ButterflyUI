import 'package:butterflyui_runtime/src/core/control_utils.dart';

import '../stylesheet.dart';
import '../theme.dart';

Map<String, Object?> resolveStylingHelperProps(
  Map<String, Object?> props, {
  required String controlType,
  double viewportWidth = 1280,
}) {
  var resolved = <String, Object?>{...props};

  if (!resolved.containsKey('classes') && resolved.containsKey('class_name')) {
    resolved['classes'] = resolved['class_name'];
  }

  final structuredStyle = resolved['style'];
  if (structuredStyle is Map) {
    resolved = StylingTokens.mergeMaps(
      resolved,
      normalizeStylingDeclarations(coerceObjectMap(structuredStyle)),
    );
  }

  final stylesheetPayload = resolved['stylesheet'];
  if (stylesheetPayload != null) {
    resolved = _mergeResolvedStyleSheet(
      resolved,
      RuntimeStyleSheet.fromPayload(stylesheetPayload),
      controlType: controlType,
      viewportWidth: viewportWidth,
    );
  }

  final inlineCss = resolved['css']?.toString().trim();
  if (inlineCss != null && inlineCss.isNotEmpty) {
    resolved = _mergeResolvedStyleSheet(
      resolved,
      runtimeStyleSheetFromInlineCss(inlineCss, selector: controlType),
      controlType: controlType,
      viewportWidth: viewportWidth,
    );
  }

  return _injectAnimatedAssetLayers(resolved);
}

Map<String, Object?> _mergeResolvedStyleSheet(
  Map<String, Object?> props,
  RuntimeStyleSheet stylesheet, {
  required String controlType,
  required double viewportWidth,
}) {
  if (stylesheet.rules.isEmpty) {
    return props;
  }
  final resolvedProps = stylesheet.resolveProps(
    controlType: controlType,
    props: props,
    viewportWidth: viewportWidth,
  );
  var merged = StylingTokens.mergeMaps(props, resolvedProps);
  final tokenOverrides = stylesheet.resolveTokenOverrides(
    viewportWidth: viewportWidth,
  );
  if (tokenOverrides.isNotEmpty) {
    final existing = merged['style_tokens'] is Map
        ? coerceObjectMap(merged['style_tokens'] as Map)
        : <String, Object?>{};
    merged['style_tokens'] = StylingTokens.mergeMaps(existing, tokenOverrides);
  }
  return merged;
}

Map<String, Object?> _injectAnimatedAssetLayers(Map<String, Object?> props) {
  final overlayLayers = _coerceLayerList(
    props['foreground_layers'] ?? props['overlay_layers'],
  );
  final backgroundLayers = _coerceLayerList(props['background_layers']);

  final lottieLayer = _coerceLottieLayer(props);
  if (lottieLayer != null) {
    overlayLayers.add(lottieLayer);
  }

  final riveLayer = _coerceRiveLayer(props);
  if (riveLayer != null) {
    overlayLayers.add(riveLayer);
  }

  return <String, Object?>{
    ...props,
    if (backgroundLayers.isNotEmpty) 'background_layers': backgroundLayers,
    if (overlayLayers.isNotEmpty) 'foreground_layers': overlayLayers,
  };
}

List<Object?> _coerceLayerList(Object? value) {
  if (value == null) {
    return <Object?>[];
  }
  if (value is List) {
    return List<Object?>.from(value);
  }
  return <Object?>[value];
}

Map<String, Object?>? _coerceLottieLayer(Map<String, Object?> props) {
  final shorthand = props['lottie'];
  final asset = _coerceAssetReference(shorthand, key: 'lottie_asset');
  final url = _coerceUrlReference(shorthand, key: 'lottie_url');
  final data = shorthand is Map ? shorthand['data'] ?? shorthand['json'] : null;
  final json = shorthand is Map ? shorthand['json'] : null;
  final explicitAsset = props['lottie_asset'];
  final explicitUrl = props['lottie_url'];
  final explicitData = props['lottie_data'];
  final explicitJson = props['lottie_json'];
  final resolvedAsset = explicitAsset ?? asset;
  final resolvedUrl = explicitUrl ?? url;
  final resolvedData = explicitData ?? data;
  final resolvedJson = explicitJson ?? json;
  final hasLayer =
      resolvedAsset != null ||
      resolvedUrl != null ||
      resolvedData != null ||
      resolvedJson != null;
  if (!hasLayer) {
    return null;
  }
  return <String, Object?>{
    'type': 'lottie',
    'position': 'overlay',
    if (resolvedAsset != null) 'lottie_asset': resolvedAsset,
    if (resolvedUrl != null) 'lottie_url': resolvedUrl,
    if (resolvedData != null) 'lottie_data': resolvedData,
    if (resolvedJson != null) 'lottie_json': resolvedJson,
    ..._assetLayerPresentation(props),
  };
}

Map<String, Object?>? _coerceRiveLayer(Map<String, Object?> props) {
  final shorthand = props['rive'];
  final asset = _coerceAssetReference(shorthand, key: 'rive_asset');
  final url = _coerceUrlReference(shorthand, key: 'rive_url');
  final artboard = shorthand is Map ? shorthand['artboard'] : null;
  final stateMachine = shorthand is Map
      ? shorthand['state_machine'] ?? shorthand['stateMachine']
      : null;
  final explicitAsset = props['rive_asset'];
  final explicitUrl = props['rive_url'];
  final explicitArtboard = props['rive_artboard'];
  final explicitStateMachine = props['rive_state_machine'];
  final resolvedAsset = explicitAsset ?? asset;
  final resolvedUrl = explicitUrl ?? url;
  final resolvedArtboard = explicitArtboard ?? artboard;
  final resolvedStateMachine = explicitStateMachine ?? stateMachine;
  final hasLayer =
      resolvedAsset != null ||
      resolvedUrl != null ||
      resolvedArtboard != null ||
      resolvedStateMachine != null;
  if (!hasLayer) {
    return null;
  }
  return <String, Object?>{
    'type': 'rive',
    'position': 'overlay',
    if (resolvedAsset != null) 'rive_asset': resolvedAsset,
    if (resolvedUrl != null) 'rive_url': resolvedUrl,
    if (resolvedArtboard != null) 'rive_artboard': resolvedArtboard,
    if (resolvedStateMachine != null) 'rive_state_machine': resolvedStateMachine,
    ..._assetLayerPresentation(props),
  };
}

Object? _coerceAssetReference(Object? value, {required String key}) {
  if (value is Map) {
    return value[key] ?? value['asset'];
  }
  if (value is String && !_looksLikeUrl(value)) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
  return null;
}

Object? _coerceUrlReference(Object? value, {required String key}) {
  if (value is Map) {
    return value[key] ?? value['url'];
  }
  if (value is String && _looksLikeUrl(value)) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
  return null;
}

bool _looksLikeUrl(String value) {
  final trimmed = value.trim().toLowerCase();
  return trimmed.startsWith('http://') || trimmed.startsWith('https://');
}

Map<String, Object?> _assetLayerPresentation(Map<String, Object?> props) {
  return <String, Object?>{
    if (props['asset_alignment'] != null) 'alignment': props['asset_alignment'],
    if (props['asset_fit'] != null) 'fit': props['asset_fit'],
    if (props['asset_width'] != null) 'width': props['asset_width'],
    if (props['asset_height'] != null) 'height': props['asset_height'],
    if (props['asset_size'] != null) 'size': props['asset_size'],
    if (props['asset_opacity'] != null) 'opacity': props['asset_opacity'],
    if (props['asset_padding'] != null) 'padding': props['asset_padding'],
  };
}
