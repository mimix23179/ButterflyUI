import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/candy/theme.dart';
import '../../core/control_utils.dart';
import '../../core/control_renderer.dart';
import '../../core/control_registry.dart';
import '../../core/webview/webview_api.dart';
import '../protocol/message.dart';
import '../runtime_client.dart';
import '../../core/style/style_packs.dart';
import '../../core/style/style_pack.dart';
import '../../core/modifiers/control_capabilities.dart';

class _PatchApplyResult {
  final bool patched;
  final bool usedFallback;

  const _PatchApplyResult({required this.patched, required this.usedFallback});
}

class AppRenderer extends StatefulWidget {
  final RuntimeClient client;
  final ValueChanged<ThemeData?> onThemeChanged;
  final ValueChanged<bool>? onRootChanged;

  const AppRenderer({
    super.key,
    required this.client,
    required this.onThemeChanged,
    this.onRootChanged,
  });

  @override
  State<AppRenderer> createState() => _AppRendererState();
}

class _AppRendererState extends State<AppRenderer> {
  static const Set<String> _embeddedControlMapKeys = <String>{
    'child',
    'content',
    'anchor',
    'base',
    'portal',
    'overlay',
    'first',
    'second',
    'leading',
    'trailing',
    'title_leading',
    'title_content',
    'title_widget',
    'title_trailing',
    'window_controls',
    'background_layer',
    'ambient_layer',
    'hero_layer',
    'content_layer',
    'overlay_layer',
    'left',
    'right',
    'top',
    'bottom',
    'main',
    'detail',
    'pane',
    'primary',
    'secondary',
    'start',
    'end',
    'header',
    'footer',
    'center',
    'left_pane',
    'right_pane',
    'top_pane',
    'bottom_pane',
  };
  static const Set<String> _embeddedControlListKeys = <String>{
    'children',
    'pages',
    'overlays',
    'layers',
    'routes',
    'actions',
    'menus',
    'commands',
    'tabs',
    'scenes',
    'panes',
    'toasts',
  };

  final CandyTokens _tokens = CandyTokens();
  Map<String, Object?> _rawTokens = {};
  Map<String, Object?>? _root;
  Map<String, Object?>? _screen;
  Map<String, Object?>? _overlay;
  Map<String, Object?>? _splash;
  Object? _backgroundSpec;
  String? _stylePackName;
  StylePack _stylePack = stylePackRegistry.defaultPack;
  StreamSubscription<RuntimeMessage>? _subscription;
  final Map<String, ButterflyUIInvokeHandler> _invokeHandlers = {};
  final Map<String, Map<String, Object?>> _nodeIndex =
      <String, Map<String, Object?>>{};
  bool _hasRoot = false;
  bool _sentFirstRender = false;
  int _protocolVersion = 1;
  String? _contractVersion;
  int? _stylePackRevision;
  String? _stylePackHash;
  int? _lastStyleAckRevision;
  String? _lastStyleAckHash;

  @override
  void initState() {
    super.initState();
    _refreshTheme();
    _subscription = widget.client.messages.listen(_handleMessage);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _handleMessage(RuntimeMessage message) {
    switch (message.type) {
      case 'ui.reset':
        setState(() {
          _root = null;
          _screen = null;
          _overlay = null;
          _splash = null;
          _nodeIndex.clear();
        });
        _notifyRootChanged(false);
        _sentFirstRender = false;
        return;
      case 'ui.apply':
        final hadRoot = _root != null;
        final payload = message.payload;
        if (payload.containsKey('modifier_capabilities')) {
          ControlModifierCapabilities.applySerializedManifest(
            payload['modifier_capabilities'],
          );
        }
        if (payload.containsKey('protocol_version')) {
          final raw = payload['protocol_version'];
          if (raw is num) {
            _protocolVersion = raw.toInt();
          } else if (raw is String) {
            final parsed = int.tryParse(raw);
            if (parsed != null) {
              _protocolVersion = parsed;
            }
          }
        }
        if (payload.containsKey('contract_version')) {
          final raw = payload['contract_version']?.toString().trim();
          _contractVersion = (raw == null || raw.isEmpty) ? null : raw;
        }
        final hasStyleSyncFields =
            payload.containsKey('style_pack_revision') ||
            payload.containsKey('style_pack_hash');
        if (payload.containsKey('style_pack_revision')) {
          final raw = payload['style_pack_revision'];
          if (raw is num) {
            _stylePackRevision = raw.toInt();
          } else if (raw is String) {
            _stylePackRevision = int.tryParse(raw);
          }
        }
        if (payload.containsKey('style_pack_hash')) {
          final raw = payload['style_pack_hash']?.toString().trim();
          _stylePackHash = (raw == null || raw.isEmpty) ? null : raw;
        }
        final patchesRaw = payload['patches'];
        final patchRaw = payload['patch'];
        final hasRootUpdate = payload.containsKey('root');
        final hasScreenUpdate = payload.containsKey('screen');
        final hasOverlayUpdate = payload.containsKey('overlay');
        final hasSplashUpdate = payload.containsKey('splash');
        final structureChanged =
            hasRootUpdate ||
            hasScreenUpdate ||
            hasOverlayUpdate ||
            hasSplashUpdate;
        final hasPatches = patchesRaw is List || patchRaw is Map;
        var usedFallbackPatch = false;

        if (structureChanged || hasPatches) {
          setState(() {
            if (hasRootUpdate) {
              final rootRaw = payload['root'];
              _root = rootRaw is Map ? rootRaw.cast<String, Object?>() : null;
            }
            if (hasScreenUpdate) {
              final screenRaw = payload['screen'];
              _screen = screenRaw is Map
                  ? screenRaw.cast<String, Object?>()
                  : null;
            }
            if (hasOverlayUpdate) {
              final overlayRaw = payload['overlay'];
              _overlay = overlayRaw is Map
                  ? overlayRaw.cast<String, Object?>()
                  : null;
            }
            if (hasSplashUpdate) {
              final splashRaw = payload['splash'];
              _splash = splashRaw is Map
                  ? splashRaw.cast<String, Object?>()
                  : null;
            }

            if (structureChanged) {
              _rebuildNodeIndex();
            }

            if (patchesRaw is List) {
              for (final entry in patchesRaw) {
                if (entry is! Map) continue;
                final patch = entry.cast<Object?, Object?>();
                final id = patch['id']?.toString();
                final propsRaw = patch['props'];
                if (id == null || id.isEmpty || propsRaw is! Map) continue;
                final props = propsRaw.cast<String, Object?>();
                final result = _applyPatchFast(id, props);
                usedFallbackPatch = usedFallbackPatch || result.usedFallback;
              }
            }

            if (patchRaw is Map) {
              final id = patchRaw['id']?.toString();
              final propsRaw = patchRaw['props'];
              if (id != null && propsRaw is Map) {
                final props = propsRaw.cast<String, Object?>();
                final result = _applyPatchFast(id, props);
                usedFallbackPatch = usedFallbackPatch || result.usedFallback;
              }
            }
          });
          if (usedFallbackPatch) {
            _rebuildNodeIndex();
          }
        }
        final registeredPacks = _registerStylePacks(payload['style_packs']);
        final hasTokens =
            payload.containsKey('tokens') ||
            payload.containsKey('theme') ||
            payload.containsKey('candy');
        if (hasTokens) {
          _rawTokens = _extractRuntimeTokens(payload);
        }
        if (payload.containsKey('style_pack')) {
          _stylePackName = payload['style_pack']?.toString();
        }
        if (payload.containsKey('background')) {
          _backgroundSpec = payload['background'];
        } else if (payload.containsKey('bgcolor')) {
          _backgroundSpec = payload['bgcolor'];
        }
        final stylePayloadChanged =
            hasTokens || payload.containsKey('style_pack') || registeredPacks;
        if (stylePayloadChanged) {
          _refreshTheme();
        }
        final shouldAckStyleSync =
            hasStyleSyncFields &&
            (_stylePackRevision != _lastStyleAckRevision ||
                _stylePackHash != _lastStyleAckHash ||
                stylePayloadChanged);
        if (shouldAckStyleSync) {
          _sendUiAppliedAck(includeStyleSync: true);
          _lastStyleAckRevision = _stylePackRevision;
          _lastStyleAckHash = _stylePackHash;
        }
        final hasRootNow = (_root ?? _screen) != null;
        if (hadRoot != hasRootNow) {
          _notifyRootChanged(hasRootNow);
        }
        if (hasRootNow) {
          _notifyFirstRender();
        }
        return;
      case 'invoke':
        _handleInvoke(message);
        return;
    }
  }

  Future<void> _handleInvoke(RuntimeMessage message) async {
    final payload = message.payload;
    final controlId = payload['control_id']?.toString() ?? '';
    final method = payload['method']?.toString() ?? '';
    final argsRaw = payload['args'];
    final args = argsRaw is Map
        ? argsRaw.cast<String, Object?>()
        : <String, Object?>{};

    final handler = _invokeHandlers[controlId];
    if (handler == null) {
      await widget.client.send(
        RuntimeMessage(
          type: 'invoke.result',
          payload: {'ok': false, 'error': 'Invoke handler not found'},
          replyTo: message.id,
        ),
      );
      return;
    }

    try {
      final result = await handler(method, args);
      await widget.client.send(
        RuntimeMessage(
          type: 'invoke.result',
          payload: {'ok': true, 'result': result},
          replyTo: message.id,
        ),
      );
    } catch (exc) {
      await widget.client.send(
        RuntimeMessage(
          type: 'invoke.result',
          payload: {'ok': false, 'error': exc.toString()},
          replyTo: message.id,
        ),
      );
    }
  }

  bool _applyPatch(
    Map<String, Object?>? node,
    String id,
    Map<String, Object?> props,
  ) {
    if (node == null) return false;
    final nodeId = node['id']?.toString();
    if (nodeId == id) {
      final rawProps = node['props'];
      final mapProps = rawProps is Map
          ? rawProps.cast<String, Object?>()
          : <String, Object?>{};
      mapProps.addAll(props);
      node['props'] = mapProps;
      return true;
    }

    final nodeProps = node['props'];
    if (_applyPatchInValue(nodeProps, id, props, parentKey: 'props')) {
      return true;
    }

    final childrenRaw = node['children'];
    if (childrenRaw is List) {
      for (final child in childrenRaw) {
        if (child is Map &&
            _applyPatch(child.cast<String, Object?>(), id, props)) {
          return true;
        }
      }
    }
    return false;
  }

  _PatchApplyResult _applyPatchFast(String id, Map<String, Object?> props) {
    final indexed = _nodeIndex[id];
    if (indexed != null) {
      final rawProps = indexed['props'];
      final mapProps = rawProps is Map
          ? rawProps.cast<String, Object?>()
          : <String, Object?>{};
      mapProps.addAll(props);
      indexed['props'] = mapProps;
      return const _PatchApplyResult(patched: true, usedFallback: false);
    }
    final patched =
        _applyPatch(_root, id, props) ||
        _applyPatch(_screen, id, props) ||
        _applyPatch(_overlay, id, props) ||
        _applyPatch(_splash, id, props);
    return _PatchApplyResult(patched: patched, usedFallback: patched);
  }

  void _rebuildNodeIndex() {
    _nodeIndex.clear();
    _indexControlNode(_root);
    _indexControlNode(_screen);
    _indexControlNode(_overlay);
    _indexControlNode(_splash);
  }

  void _indexControlNode(Map<String, Object?>? node) {
    if (node == null) return;
    final id = node['id']?.toString();
    if (id != null && id.isNotEmpty) {
      _nodeIndex[id] = node;
    }
    _indexControlValue(node['props'], parentKey: 'props');
    _indexControlValue(node['children'], parentKey: 'children');
  }

  void _indexControlValue(Object? value, {String? parentKey}) {
    final canScanList =
        parentKey == null || _embeddedControlListKeys.contains(parentKey);
    if (value is List && !canScanList) return;

    if (value is List) {
      for (final item in value) {
        _indexControlValue(item, parentKey: parentKey);
      }
      return;
    }

    if (value is! Map) return;
    final map = value.cast<Object?, Object?>();
    final isControlNode =
        map.containsKey('id') &&
        (map.containsKey('type') ||
            map.containsKey('props') ||
            map.containsKey('children'));
    if (isControlNode) {
      _indexControlNode(map.cast<String, Object?>());
      return;
    }

    for (final entry in map.entries) {
      final key = entry.key?.toString();
      if (key == null) continue;
      if (_embeddedControlMapKeys.contains(key) ||
          _embeddedControlListKeys.contains(key)) {
        _indexControlValue(entry.value, parentKey: key);
      }
    }
  }

  bool _applyPatchInValue(
    Object? value,
    String id,
    Map<String, Object?> props, {
    String? parentKey,
  }) {
    final canScanList =
        parentKey == null || _embeddedControlListKeys.contains(parentKey);
    if (value is List && !canScanList) {
      return false;
    }

    if (value is List) {
      for (final item in value) {
        if (_applyPatchInValue(item, id, props, parentKey: parentKey)) {
          return true;
        }
      }
      return false;
    }

    if (value is! Map) {
      return false;
    }

    final map = value.cast<Object?, Object?>();
    final isControlNode =
        map.containsKey('id') &&
        (map.containsKey('type') ||
            map.containsKey('props') ||
            map.containsKey('children'));
    if (isControlNode) {
      final controlMap = map.cast<String, Object?>();
      if (_applyPatch(controlMap, id, props)) {
        return true;
      }
    }

    for (final entry in map.entries) {
      final key = entry.key?.toString();
      if (key == null) continue;
      if ((_embeddedControlMapKeys.contains(key) ||
              _embeddedControlListKeys.contains(key)) &&
          _applyPatchInValue(entry.value, id, props, parentKey: key)) {
        return true;
      }
    }

    return false;
  }

  bool _registerStylePacks(Object? raw) {
    if (raw == null) return false;
    final specs = <Map<String, Object?>>[];
    if (raw is List) {
      for (final item in raw) {
        if (item is Map) {
          specs.add(coerceObjectMap(item));
        }
      }
    } else if (raw is Map) {
      for (final entry in raw.entries) {
        final value = entry.value;
        if (value is Map) {
          final spec = coerceObjectMap(value);
          spec.putIfAbsent('name', () => entry.key.toString());
          specs.add(spec);
        }
      }
    }
    var updated = false;
    for (final spec in specs) {
      if (_registerStylePackSpec(spec)) {
        updated = true;
      }
    }
    return updated;
  }

  bool _registerStylePackSpec(Map<String, Object?> spec) {
    final rawName = spec['name']?.toString() ?? spec['id']?.toString();
    if (rawName == null || rawName.isEmpty) return false;
    final baseName = spec['base']?.toString() ?? spec['extends']?.toString();
    final basePack = (baseName == null || baseName.isEmpty)
        ? stylePackRegistry.defaultPack
        : stylePackRegistry.resolve(baseName);
    final tokenMap = _extractStylePackTokens(spec);
    final mergedTokens = CandyTokens.mergeMaps(
      basePack.defaultTokens,
      tokenMap,
    );
    final overrides = _resolveStyleOverrides(
      spec['overrides'],
      basePack.overrides,
    );
    final componentStyles = CandyTokens.mergeMaps(
      basePack.componentStyles,
      _coerceMapSection(
        spec['components'] ?? spec['component_styles'] ?? spec['controls'],
      ),
    );
    final motionPack = CandyTokens.mergeMaps(
      basePack.motionPack,
      _coerceMapSection(spec['motion'] ?? spec['motion_pack']),
    );
    final effectPresets = CandyTokens.mergeMaps(
      basePack.effectPresets,
      _coerceMapSection(spec['effects'] ?? spec['effect_presets']),
    );
    final backgroundSpec = spec['background'] ?? spec['bgcolor'];
    final background = backgroundSpec == null
        ? basePack.background
        : _backgroundFromSpec(backgroundSpec, basePack.background);
    final pack = StylePack(
      name: rawName,
      defaultTokens: mergedTokens,
      componentStyles: componentStyles,
      motionPack: motionPack,
      effectPresets: effectPresets,
      themeBuilder: basePack.themeBuilder,
      overrides: overrides,
      background: background,
      wrapRoot: basePack.wrapRoot,
    );
    stylePackRegistry.register(pack, replace: true);
    return true;
  }

  Map<String, StyleControlOverride> _resolveStyleOverrides(
    Object? raw,
    Map<String, StyleControlOverride> base,
  ) {
    final merged = Map<String, StyleControlOverride>.from(base);
    if (raw is! Map) return merged;
    final overrides = raw.cast<String, Object?>();
    for (final entry in overrides.entries) {
      final controlType = entry.key;
      final value = entry.value;
      String? overrideId;
      if (value is String) {
        overrideId = value;
      } else if (value is Map) {
        overrideId = value['id']?.toString() ?? value['type']?.toString();
      }
      if (overrideId == null || overrideId.isEmpty) continue;
      final resolved =
          styleOverrideRegistry[overrideId] ??
          styleOverrideRegistry[overrideId.toLowerCase()];
      if (resolved != null) {
        merged[controlType] = resolved;
      }
    }
    return merged;
  }

  Map<String, Object?> _coerceMapSection(Object? raw) {
    if (raw is! Map) return const <String, Object?>{};
    return coerceObjectMap(raw);
  }

  Map<String, Object?> _extractRuntimeTokens(Map<String, Object?> payload) {
    final direct = _extractTokenMap(payload['tokens']);
    if (direct.isNotEmpty) return direct;

    final theme = _extractTokenMap(payload['theme']);
    if (theme.isNotEmpty) return theme;

    final candy = _extractTokenMap(payload['candy']);
    if (candy.isNotEmpty) return candy;

    return <String, Object?>{};
  }

  Map<String, Object?> _extractStylePackTokens(Map<String, Object?> spec) {
    final direct = _extractTokenMap(spec['tokens']);
    if (direct.isNotEmpty) return direct;

    final candy = _extractTokenMap(spec['candy']);
    if (candy.isNotEmpty) return candy;

    final theme = _extractTokenMap(spec['theme']);
    if (theme.isNotEmpty) return theme;

    return <String, Object?>{};
  }

  Map<String, Object?> _extractTokenMap(Object? raw) {
    if (raw is! Map) return <String, Object?>{};

    final map = coerceObjectMap(raw);

    final nestedTokens = map['tokens'];
    if (nestedTokens is Map) {
      return coerceObjectMap(nestedTokens);
    }

    final nestedTheme = map['theme'];
    if (nestedTheme is Map) {
      final themeMap = coerceObjectMap(nestedTheme);
      final themedTokens = themeMap['tokens'];
      if (themedTokens is Map) {
        return coerceObjectMap(themedTokens);
      }
    }

    final looksLikeCandyControl =
        map.containsKey('module') ||
        map.containsKey('modules') ||
        map.containsKey('state') ||
        map.containsKey('schema_version');

    if (looksLikeCandyControl) {
      return <String, Object?>{};
    }

    return map;
  }

  Widget Function(BuildContext, CandyTokens) _backgroundFromSpec(
    Object spec,
    Widget Function(BuildContext, CandyTokens)? fallback,
  ) {
    return (context, tokens) {
      if (spec is String) {
        final color = coerceColor(spec);
        if (color != null) {
          return DecoratedBox(decoration: BoxDecoration(color: color));
        }
      } else if (spec is Map) {
        final map = coerceObjectMap(spec);
        final color = coerceColor(
          map['bgcolor'] ?? map['color'] ?? map['background'],
        );
        final gradient = coerceGradient(map['gradient']);
        final image = coerceDecorationImage(map['image']);
        if (color != null || gradient != null || image != null) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: color,
              gradient: gradient,
              image: image,
            ),
          );
        }
      }
      if (fallback != null) {
        return fallback(context, tokens);
      }
      return Container(color: Theme.of(context).colorScheme.background);
    };
  }

  @override
  Widget build(BuildContext context) {
    final baseRoot = _root ?? _screen;
    if (baseRoot == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F1216),
        body: SizedBox.shrink(),
      );
    }

    final renderer = ControlRenderer(
      tokens: _tokens,
      registry: ButterflyUIControlRegistry(),
      registerInvokeHandler: _registerInvokeHandler,
      unregisterInvokeHandler: _unregisterInvokeHandler,
      sendEvent: _sendEvent,
      sendSystemEvent: _sendSystemEvent,
      stylePack: _stylePack,
      styleTokens: _rawTokens,
    );

    final base = renderer.buildFromControl(baseRoot);
    final overlay = _overlay != null
        ? renderer.buildFromControl(_overlay!)
        : null;
    final splash = _splash != null ? renderer.buildFromControl(_splash!) : null;
    final background = _buildBackground(context);

    Widget content = _root != null
        ? Scaffold(backgroundColor: Colors.transparent, body: base)
        : base;
    if (_stylePack.wrapRoot != null) {
      content = _stylePack.wrapRoot!(context, _tokens, content);
    }

    return Stack(
      children: [
        Positioned.fill(child: background),
        Positioned.fill(child: content),
        if (overlay != null) Positioned.fill(child: overlay),
        if (splash != null) Positioned.fill(child: splash),
      ],
    );
  }

  void _refreshTheme() {
    _stylePack = stylePackRegistry.resolve(_stylePackName);
    final effective = _stylePack.buildTokens(_rawTokens);
    _tokens.update(effective.toJson());
    setTokenColorResolver((token) => _tokens.color(token));
    widget.onThemeChanged(_stylePack.applyTheme(_tokens));
  }

  Widget _buildBackground(BuildContext context) {
    final fallback =
        _stylePack.background?.call(context, _tokens) ??
        Container(color: Theme.of(context).colorScheme.background);
    final spec = _backgroundSpec;
    if (spec == null) return fallback;
    if (spec is String) {
      final color = coerceColor(spec);
      if (color == null) return fallback;
      return DecoratedBox(decoration: BoxDecoration(color: color));
    }
    if (spec is Map) {
      final map = coerceObjectMap(spec);
      final color = coerceColor(
        map['bgcolor'] ?? map['color'] ?? map['background'],
      );
      final gradient = coerceGradient(map['gradient']);
      final image = coerceDecorationImage(map['image']);
      if (color == null && gradient == null && image == null) return fallback;
      return DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          gradient: gradient,
          image: image,
        ),
      );
    }
    return fallback;
  }

  void _registerInvokeHandler(
    String controlId,
    ButterflyUIInvokeHandler handler,
  ) {
    _invokeHandlers[controlId] = handler;
  }

  void _unregisterInvokeHandler(String controlId) {
    _invokeHandlers.remove(controlId);
  }

  void _sendEvent(
    String controlId,
    String event,
    Map<String, Object?> payload,
  ) {
    widget.client.send(
      RuntimeMessage(
        type: 'ui.event',
        payload: {
          'control_id': controlId,
          'event': event,
          'payload': payload,
          'kind': 'ui',
        },
      ),
    );
  }

  void _sendSystemEvent(String kind, Map<String, Object?> payload) {
    widget.client.send(
      RuntimeMessage(
        type: 'ui.event',
        payload: {
          'control_id': payload['control_id']?.toString() ?? '',
          'event': kind,
          'payload': payload,
          'kind': 'system',
        },
      ),
    );
  }

  void _notifyRootChanged(bool hasRoot) {
    if (_hasRoot == hasRoot) return;
    _hasRoot = hasRoot;
    widget.onRootChanged?.call(hasRoot);
  }

  void _notifyFirstRender() {
    if (_sentFirstRender) return;
    _sentFirstRender = true;
    _sendUiAppliedAck(firstRender: true, hasRoot: true, includeStyleSync: true);
  }

  void _sendUiAppliedAck({
    bool firstRender = false,
    bool hasRoot = false,
    bool includeStyleSync = false,
  }) {
    final payload = <String, Object?>{
      'first_render': firstRender,
      'has_root': hasRoot,
      'protocol_version': _protocolVersion,
      if (_contractVersion != null) 'contract_version': _contractVersion,
      'modifier_capabilities_version':
          ControlModifierCapabilities.manifestVersion,
    };
    if (includeStyleSync) {
      if (_stylePackRevision != null) {
        payload['style_pack_revision'] = _stylePackRevision;
      }
      if (_stylePackHash != null && _stylePackHash!.isNotEmpty) {
        payload['style_pack_hash'] = _stylePackHash;
      }
      payload['style_pack'] = _stylePack.name;
    }
    widget.client.send(RuntimeMessage(type: 'ui.applied', payload: payload));
  }
}
