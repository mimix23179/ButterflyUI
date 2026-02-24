import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/candy/theme.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/common/umbrella_runtime.dart';
import 'package:butterflyui_runtime/src/core/controls/buttons/button.dart';
import 'package:butterflyui_runtime/src/core/controls/customization/badge.dart';
import 'package:butterflyui_runtime/src/core/controls/customization/border.dart';
import 'package:butterflyui_runtime/src/core/controls/customization/color_tools.dart';
import 'package:butterflyui_runtime/src/core/controls/display/canvas_control.dart';
import 'package:butterflyui_runtime/src/core/controls/effects/layer.dart';
import 'package:butterflyui_runtime/src/core/controls/effects/motion.dart';
import 'package:butterflyui_runtime/src/core/controls/effects/particle_field.dart';
import 'package:butterflyui_runtime/src/core/controls/effects/shimmer_shadow.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/align_control.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/card.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/column.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/container.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/row.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/stack.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/wrap.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

const int _candySchemaVersion = 2;

const Set<String> _candyModules = {
  'button',
  'card',
  'column',
  'container',
  'row',
  'stack',
  'surface',
  'wrap',
  'align',
  'center',
  'spacer',
  'aspect_ratio',
  'overflow_box',
  'fitted_box',
  'effects',
  'particles',
  'border',
  'shadow',
  'outline',
  'gradient',
  'animation',
  'transition',
  'canvas',
  'clip',
  'decorated_box',
  'badge',
  'avatar',
  'icon',
  'text',
  'motion',
};

const Set<String> _candyStates = {
  'idle',
  'hover',
  'pressed',
  'focused',
  'disabled',
  'selected',
  'loading',
};

const Set<String> _candyEvents = {
  'change',
  'state_change',
  'module_change',
  'click',
  'tap',
  'double_tap',
  'long_press',
  'hover_enter',
  'hover_exit',
  'hover_move',
  'focus',
  'blur',
  'focus_change',
  'animation_start',
  'animation_end',
  'transition_start',
  'transition_end',
  'gesture_pan_start',
  'gesture_pan_update',
  'gesture_pan_end',
  'gesture_scale_start',
  'gesture_scale_update',
  'gesture_scale_end',
};

const Map<String, String> _candyRegistryRoleAliases = {
  'module': 'module_registry',
  'modules': 'module_registry',
  'foundation': 'foundation_registry',
  'foundations': 'foundation_registry',
  'interaction': 'interaction_registry',
  'interactions': 'interaction_registry',
  'motion_pack': 'motion_registry',
  'motion': 'motion_registry',
  'motions': 'motion_registry',
  'effect': 'effect_registry',
  'effects_pack': 'effect_registry',
  'effects': 'effect_registry',
  'recipe': 'recipe_registry',
  'recipes': 'recipe_registry',
  'provider': 'provider_registry',
  'providers': 'provider_registry',
  'command': 'command_registry',
  'commands': 'command_registry',
  'module_registry': 'module_registry',
  'foundation_registry': 'foundation_registry',
  'interaction_registry': 'interaction_registry',
  'motion_registry': 'motion_registry',
  'effect_registry': 'effect_registry',
  'recipe_registry': 'recipe_registry',
  'provider_registry': 'provider_registry',
  'command_registry': 'command_registry',
};

const Map<String, String> _candyRegistryManifestLists = {
  'module_registry': 'enabled_modules',
  'foundation_registry': 'enabled_foundations',
  'interaction_registry': 'enabled_interactions',
  'motion_registry': 'enabled_motion',
  'effect_registry': 'enabled_effects',
  'recipe_registry': 'enabled_recipes',
  'command_registry': 'enabled_commands',
};

const Map<String, List<String>> _candyManifestDefaults = {
  'enabled_modules': <String>[
    'surface',
    'container',
    'row',
    'column',
    'stack',
    'wrap',
    'button',
    'text',
    'icon',
    'badge',
    'avatar',
    'border',
    'shadow',
    'outline',
    'gradient',
    'animation',
    'transition',
    'motion',
    'effects',
    'particles',
    'canvas',
    'clip',
    'decorated_box',
  ],
  'enabled_foundations': <String>[
    'row',
    'column',
    'stack',
    'wrap',
    'container',
    'surface',
    'align',
    'center',
    'spacer',
    'aspect_ratio',
    'overflow_box',
    'fitted_box',
    'text',
    'icon',
    'avatar',
    'badge',
  ],
  'enabled_interactions': <String>['button', 'motion'],
  'enabled_motion': <String>['animation', 'transition', 'motion'],
  'enabled_effects': <String>[
    'effects',
    'particles',
    'gradient',
    'border',
    'shadow',
    'outline',
    'clip',
    'decorated_box',
    'canvas',
  ],
  'enabled_recipes': <String>['button', 'card', 'surface'],
  'enabled_commands': <String>['button', 'animation', 'transition', 'motion'],
};

const Set<String> _candyCommonPayloadKeys = {
  'enabled',
  'variant',
  'state',
  'slots',
  'leading',
  'trailing',
  'overlay',
  'background',
  'content',
  'animation',
  'transition',
  'motion',
  'events',
  'semantics',
  'accessibility',
  'performance',
};

const Map<String, String> _candyCommonPayloadTypes = {
  'enabled': 'bool',
  'variant': 'string',
  'state': 'state',
  'slots': 'map',
  'leading': 'any',
  'trailing': 'any',
  'overlay': 'any',
  'background': 'any',
  'content': 'any',
  'animation': 'map',
  'transition': 'map',
  'motion': 'map',
  'events': 'events',
  'semantics': 'map',
  'accessibility': 'map',
  'performance': 'map',
};

const Map<String, Set<String>> _candyModuleAllowedKeys = {
  'button': {
    'label',
    'text',
    'icon',
    'loading',
    'disabled',
    'radius',
    'padding',
    'bgcolor',
    'text_color',
  },
  'card': {'elevation', 'radius', 'padding', 'margin', 'bgcolor'},
  'column': {'spacing', 'alignment', 'main_axis', 'cross_axis'},
  'container': {
    'width',
    'height',
    'padding',
    'margin',
    'alignment',
    'bgcolor',
    'radius',
  },
  'row': {'spacing', 'alignment', 'main_axis', 'cross_axis'},
  'stack': {'alignment', 'fit'},
  'surface': {'bgcolor', 'elevation', 'radius', 'border_color', 'border_width'},
  'wrap': {'spacing', 'run_spacing', 'alignment', 'run_alignment'},
  'align': {'alignment', 'width_factor', 'height_factor'},
  'center': {'width_factor', 'height_factor'},
  'spacer': {'width', 'height', 'flex'},
  'aspect_ratio': {'ratio', 'value'},
  'overflow_box': {
    'alignment',
    'min_width',
    'max_width',
    'min_height',
    'max_height',
  },
  'fitted_box': {'fit', 'alignment', 'clip_behavior'},
  'effects': {'shimmer', 'blur', 'opacity', 'overlay'},
  'particles': {
    'count',
    'speed',
    'size',
    'gravity',
    'drift',
    'overlay',
    'colors',
  },
  'border': {'color', 'width', 'radius', 'side', 'padding'},
  'shadow': {'color', 'blur', 'spread', 'dx', 'dy'},
  'outline': {'outline_color', 'outline_width', 'radius'},
  'gradient': {'variant', 'colors', 'stops', 'begin', 'end', 'angle'},
  'animation': {
    'duration_ms',
    'curve',
    'opacity',
    'scale',
    'autoplay',
    'loop',
    'reverse',
  },
  'transition': {'duration_ms', 'curve', 'preset', 'key'},
  'canvas': {'width', 'height', 'commands'},
  'clip': {'shape', 'clip_shape', 'clip_behavior', 'radius'},
  'decorated_box': {
    'bgcolor',
    'gradient',
    'border_color',
    'border_width',
    'radius',
    'shadow',
  },
  'badge': {
    'label',
    'text',
    'value',
    'color',
    'bgcolor',
    'text_color',
    'radius',
  },
  'avatar': {'src', 'label', 'text', 'size', 'color', 'bgcolor'},
  'icon': {'icon', 'size', 'color'},
  'text': {
    'text',
    'value',
    'color',
    'font_size',
    'size',
    'font_weight',
    'weight',
    'align',
    'max_lines',
    'overflow',
  },
  'motion': {
    'duration_ms',
    'curve',
    'opacity',
    'scale',
    'autoplay',
    'loop',
    'reverse',
  },
};

const Map<String, Map<String, String>> _candyModulePayloadTypes = {
  'button': {
    'label': 'string',
    'text': 'string',
    'icon': 'string',
    'loading': 'bool',
    'disabled': 'bool',
    'radius': 'num',
    'padding': 'padding',
    'bgcolor': 'color',
    'text_color': 'color',
  },
  'card': {
    'elevation': 'num',
    'radius': 'num',
    'padding': 'padding',
    'margin': 'padding',
    'bgcolor': 'color',
  },
  'column': {
    'spacing': 'num',
    'alignment': 'string',
    'main_axis': 'string',
    'cross_axis': 'string',
  },
  'container': {
    'width': 'dimension',
    'height': 'dimension',
    'padding': 'padding',
    'margin': 'padding',
    'alignment': 'alignment',
    'bgcolor': 'color',
    'radius': 'num',
  },
  'row': {
    'spacing': 'num',
    'alignment': 'string',
    'main_axis': 'string',
    'cross_axis': 'string',
  },
  'stack': {'alignment': 'alignment', 'fit': 'string'},
  'surface': {
    'bgcolor': 'color',
    'elevation': 'num',
    'radius': 'num',
    'border_color': 'color',
    'border_width': 'num',
  },
  'wrap': {
    'spacing': 'num',
    'run_spacing': 'num',
    'alignment': 'string',
    'run_alignment': 'string',
  },
  'align': {
    'alignment': 'alignment',
    'width_factor': 'num',
    'height_factor': 'num',
  },
  'center': {'width_factor': 'num', 'height_factor': 'num'},
  'spacer': {'width': 'dimension', 'height': 'dimension', 'flex': 'int'},
  'aspect_ratio': {'ratio': 'num', 'value': 'num'},
  'overflow_box': {
    'alignment': 'alignment',
    'min_width': 'dimension',
    'max_width': 'dimension',
    'min_height': 'dimension',
    'max_height': 'dimension',
  },
  'fitted_box': {
    'fit': 'string',
    'alignment': 'alignment',
    'clip_behavior': 'string',
  },
  'effects': {
    'shimmer': 'bool',
    'blur': 'num',
    'opacity': 'num',
    'overlay': 'bool',
  },
  'particles': {
    'count': 'int',
    'speed': 'num',
    'size': 'num',
    'gravity': 'num',
    'drift': 'num',
    'overlay': 'bool',
    'colors': 'list',
  },
  'border': {
    'color': 'color',
    'width': 'num',
    'radius': 'num',
    'side': 'string',
    'padding': 'padding',
  },
  'shadow': {
    'color': 'color',
    'blur': 'num',
    'spread': 'num',
    'dx': 'num',
    'dy': 'num',
  },
  'outline': {
    'outline_color': 'color',
    'outline_width': 'num',
    'radius': 'num',
  },
  'gradient': {
    'variant': 'string',
    'colors': 'list',
    'stops': 'list',
    'begin': 'any',
    'end': 'any',
    'angle': 'num',
  },
  'animation': {
    'duration_ms': 'int',
    'curve': 'string',
    'opacity': 'num',
    'scale': 'num',
    'autoplay': 'bool',
    'loop': 'bool',
    'reverse': 'bool',
  },
  'transition': {
    'duration_ms': 'int',
    'curve': 'string',
    'preset': 'string',
    'key': 'any',
  },
  'canvas': {'width': 'dimension', 'height': 'dimension', 'commands': 'list'},
  'clip': {
    'shape': 'string',
    'clip_shape': 'string',
    'clip_behavior': 'string',
    'radius': 'num',
  },
  'decorated_box': {
    'bgcolor': 'color',
    'gradient': 'any',
    'border_color': 'color',
    'border_width': 'num',
    'radius': 'num',
    'shadow': 'any',
  },
  'badge': {
    'label': 'string',
    'text': 'string',
    'value': 'any',
    'color': 'color',
    'bgcolor': 'color',
    'text_color': 'color',
    'radius': 'num',
  },
  'avatar': {
    'src': 'string',
    'label': 'string',
    'text': 'string',
    'size': 'num',
    'color': 'color',
    'bgcolor': 'color',
  },
  'icon': {'icon': 'string', 'size': 'num', 'color': 'color'},
  'text': {
    'text': 'string',
    'value': 'string',
    'color': 'color',
    'font_size': 'num',
    'size': 'num',
    'font_weight': 'any',
    'weight': 'any',
    'align': 'string',
    'max_lines': 'int',
    'overflow': 'string',
  },
  'motion': {
    'duration_ms': 'int',
    'curve': 'string',
    'opacity': 'num',
    'scale': 'num',
    'autoplay': 'bool',
    'loop': 'bool',
    'reverse': 'bool',
  },
};

Widget buildCandyFamilyControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  CandyTokens tokens,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _CandyFamily(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    tokens: tokens,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _CandyFamily extends StatefulWidget {
  const _CandyFamily({
    required this.controlId,
    required this.props,
    required this.rawChildren,
    required this.tokens,
    required this.buildChild,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final List<dynamic> rawChildren;
  final CandyTokens tokens;
  final Widget Function(Map<String, Object?> child) buildChild;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_CandyFamily> createState() => _CandyFamilyState();
}

class _CandyFamilyState extends State<_CandyFamily> {
  late Map<String, Object?> _runtimeProps;
  late String _state;
  late String _module;
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _runtimeProps = _normalizeProps(widget.props);
    _module = _resolveModule(_runtimeProps);
    _state = _resolveState(
      _runtimeProps,
      hovered: false,
      focused: false,
      pressed: false,
    );
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _CandyFamily oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runtimeProps = _normalizeProps(widget.props);
    _module = _resolveModule(_runtimeProps);
    _state = _resolveState(
      _runtimeProps,
      hovered: _hovered,
      focused: _focused,
      pressed: _pressed,
    );

    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (_norm(method)) {
      case 'get_state':
        return {
          'schema_version': _runtimeProps['schema_version'],
          'module': _module,
          'state': _state,
          'manifest': _runtimeProps['manifest'],
          'registries': _runtimeProps['registries'],
          'props': _runtimeProps,
        };

      case 'set_props':
        final incoming = args['props'];
        if (incoming is Map) {
          setState(() {
            _runtimeProps.addAll(coerceObjectMap(incoming));
            _runtimeProps = _normalizeProps(_runtimeProps);
            _module = _resolveModule(_runtimeProps);
            _state = _resolveState(
              _runtimeProps,
              hovered: _hovered,
              focused: _focused,
              pressed: _pressed,
            );
          });
          _emit('change', {'module': _module, 'state': _state});
        }
        return _runtimeProps;
      case 'set_manifest':
        {
          final manifestPayload = _coerceObjectMap(args['manifest']);
          setState(() {
            final manifest = _coerceObjectMap(_runtimeProps['manifest']);
            manifest.addAll(manifestPayload);
            _runtimeProps['manifest'] = manifest;
            _runtimeProps = _normalizeProps(_runtimeProps);
            _module = _resolveModule(_runtimeProps);
          });
          _emit('change', {
            'module': _module,
            'intent': 'set_manifest',
            'manifest': _runtimeProps['manifest'],
          });
          return {'ok': true, 'manifest': _runtimeProps['manifest']};
        }

      case 'set_module':
        final module = _norm(args['module']?.toString() ?? '');
        if (module.isEmpty) return {'ok': false, 'error': 'module is empty'};
        if (!_candyModules.contains(module)) {
          return {'ok': false, 'error': 'unknown module: $module'};
        }
        setState(() {
          _runtimeProps['module'] = module;
          final payload = args['payload'];
          if (payload is Map) {
            final payloadMap = _sanitizeModulePayload(
              module,
              coerceObjectMap(payload),
            );
            _runtimeProps[module] = payloadMap;
            final modules = _coerceObjectMap(_runtimeProps['modules']);
            modules[module] = payloadMap;
            _runtimeProps['modules'] = modules;
          }
          _module = _resolveModule(_runtimeProps);
        });
        _emit('module_change', {'module': _module});
        return {'ok': true, 'module': _module};

      case 'set_state':
        final state = _norm(args['state']?.toString() ?? '');
        if (state.isNotEmpty) {
          if (!_candyStates.contains(state)) {
            return {'ok': false, 'error': 'unknown state: $state'};
          }
          setState(() {
            _runtimeProps['state'] = state;
            _state = _resolveState(
              _runtimeProps,
              hovered: _hovered,
              focused: _focused,
              pressed: _pressed,
            );
          });
          _emit('state_change', {'state': _state});
        }
        return {'state': _state};

      case 'set_tokens':
        {
          final tokens = _coerceObjectMap(args['tokens']);
          setState(() {
            _runtimeProps['tokens'] = tokens;
          });
          _emit('change', {'tokens': tokens});
          return {'ok': true};
        }

      case 'set_token_overrides':
        {
          final tokenOverrides = _coerceObjectMap(args['token_overrides']);
          setState(() {
            _runtimeProps['token_overrides'] = tokenOverrides;
          });
          _emit('change', {'token_overrides': tokenOverrides});
          return {'ok': true};
        }

      case 'set_slots':
        {
          final slots = _coerceObjectMap(args['slots']);
          setState(() {
            _runtimeProps['slots'] = slots;
          });
          return {'ok': true};
        }

      case 'set_accessibility':
        {
          final accessibility = _coerceObjectMap(args['accessibility']);
          setState(() {
            _runtimeProps['accessibility'] = accessibility;
          });
          return {'ok': true};
        }

      case 'emit':
      case 'trigger':
        {
          final fallback = method == 'trigger' ? 'change' : method;
          final event = _norm(
            (args['event'] ?? args['name'] ?? fallback).toString(),
          );
          if (!_candyEvents.contains(event)) {
            return {'ok': false, 'error': 'unknown event: $event'};
          }
          final payload = args['payload'];
          _emit(event, payload is Map ? coerceObjectMap(payload) : args);
          return {'ok': true};
        }

      case 'focus':
        {
          _emit('focus', {'module': _module});
          return {'ok': true};
        }

      case 'blur':
        {
          _emit('blur', {'module': _module});
          return {'ok': true};
        }

      case 'click':
      case 'tap':
        {
          _emit('click', {
            'module': _module,
            'state': _state,
            'payload': args['payload'],
          });
          return {'ok': true};
        }

      case 'play_motion':
        {
          _emit('animation_start', {'module': _module, 'key': args['key']});
          return {'ok': true};
        }

      case 'pause_motion':
        {
          _emit('animation_end', {'module': _module, 'key': args['key']});
          return {'ok': true};
        }

      default:
        final normalizedMethod = _norm(method);
        if (normalizedMethod.startsWith('register_')) {
          final role = normalizedMethod == 'register_module'
              ? (args['role'] ?? 'module').toString()
              : normalizedMethod.replaceFirst('register_', '');
          final moduleId =
              (args['module_id'] ??
                      args['id'] ??
                      args['name'] ??
                      args['module'] ??
                      '')
                  .toString();
          final definition = _coerceObjectMap(args['definition']);
          late Map<String, Object?> result;
          setState(() {
            result = registerUmbrellaModule(
              props: _runtimeProps,
              role: role,
              moduleId: moduleId,
              definition: definition,
              modules: _candyModules,
              roleAliases: _candyRegistryRoleAliases,
              roleManifestLists: _candyRegistryManifestLists,
              manifestDefaults: _candyManifestDefaults,
            );
            _runtimeProps = _normalizeProps(_runtimeProps);
            _module = _resolveModule(_runtimeProps);
          });
          if (result['ok'] == true) {
            _emit('change', {
              'module': _module,
              'intent': normalizedMethod,
              'role': result['role'],
              'module_id': result['module_id'],
            });
          }
          return result;
        }
        throw UnsupportedError('Unknown candy method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final module = _module;
    final merged = _mergeModuleProps(_runtimeProps, module);
    final style = _resolveStyle(context, widget.tokens, _runtimeProps, merged);

    Widget base = _buildModule(context, module, merged, style);

    base = _composeSlots(
      base,
      _runtimeProps,
      merged,
      widget.rawChildren,
      widget.buildChild,
    );
    base = _applyVisualPipeline(base, merged, style);
    base = _wrapWithMotion(base, merged);
    base = _wrapWithSemantics(base, merged, module);
    base = _wrapWithPerformance(base, merged);
    base = _wrapWithInteraction(base, merged, module);

    return base;
  }

  Widget _buildModule(
    BuildContext context,
    String module,
    Map<String, Object?> merged,
    _CandyStyle style,
  ) {
    final customLayout =
        merged['custom_layout'] == true ||
        _norm((merged['layout'] ?? '').toString()) == 'custom';
    if (customLayout && widget.rawChildren.isNotEmpty) {
      return buildContainerControl(
        merged,
        widget.rawChildren,
        widget.buildChild,
      );
    }

    switch (module) {
      case 'button':
        return buildButtonControl(
          widget.controlId,
          merged,
          widget.tokens,
          widget.sendEvent,
        );

      case 'card':
        return buildCardControl(
          merged,
          widget.rawChildren,
          widget.tokens,
          widget.buildChild,
        );

      case 'column':
        return buildColumnControl(
          merged,
          widget.rawChildren,
          widget.tokens,
          widget.buildChild,
        );

      case 'container':
      case 'surface':
        return buildContainerControl(
          merged,
          widget.rawChildren,
          widget.buildChild,
        );

      case 'row':
        return buildRowControl(
          merged,
          widget.rawChildren,
          widget.tokens,
          widget.buildChild,
        );

      case 'stack':
        return buildStackControl(merged, widget.rawChildren, widget.buildChild);

      case 'wrap':
        return buildWrapControl(
          merged,
          widget.rawChildren,
          widget.tokens,
          widget.buildChild,
        );

      case 'align':
        return buildAlignControl(
          '${widget.controlId}::align',
          merged,
          widget.rawChildren,
          widget.buildChild,
          widget.registerInvokeHandler,
          widget.unregisterInvokeHandler,
          widget.sendEvent,
        );

      case 'center':
        return Align(
          alignment: Alignment.center,
          child: _firstChildOrEmpty(widget.rawChildren, widget.buildChild),
        );

      case 'spacer':
        return SizedBox(
          width: coerceDouble(merged['width']),
          height: coerceDouble(merged['height']),
        );

      case 'aspect_ratio':
        return AspectRatio(
          aspectRatio: coerceDouble(merged['value'] ?? merged['ratio']) ?? 1.0,
          child: _firstChildOrEmpty(widget.rawChildren, widget.buildChild),
        );

      case 'overflow_box':
        return OverflowBox(
          alignment: _parseAlignment(merged['alignment']) ?? Alignment.center,
          minWidth: coerceDouble(merged['min_width']),
          maxWidth: coerceDouble(merged['max_width']),
          minHeight: coerceDouble(merged['min_height']),
          maxHeight: coerceDouble(merged['max_height']),
          child: _firstChildOrEmpty(widget.rawChildren, widget.buildChild),
        );

      case 'fitted_box':
        return FittedBox(
          fit: _parseBoxFit(merged['fit']) ?? BoxFit.contain,
          alignment: _parseAlignment(merged['alignment']) ?? Alignment.center,
          clipBehavior: _parseClip(merged['clip_behavior']) ?? Clip.none,
          child: _firstChildOrEmpty(widget.rawChildren, widget.buildChild),
        );

      case 'effects':
        {
          Widget child = buildLayerControl(
            merged,
            widget.rawChildren,
            widget.buildChild,
          );
          if (merged['shimmer'] == true) {
            child = buildShimmerControl(
              '${widget.controlId}::effects',
              merged,
              child,
              widget.registerInvokeHandler,
              widget.unregisterInvokeHandler,
            );
          }
          return child;
        }

      case 'particles':
        {
          final particle = buildParticleFieldControl(
            '${widget.controlId}::particles',
            merged,
            widget.registerInvokeHandler,
            widget.unregisterInvokeHandler,
            widget.sendEvent,
          );
          final child = _firstChildOrEmpty(
            widget.rawChildren,
            widget.buildChild,
          );
          final overlay = merged['overlay'] == null
              ? true
              : (merged['overlay'] == true);
          if (!overlay) {
            return particle;
          }
          return Stack(
            fit: StackFit.expand,
            children: [
              child,
              IgnorePointer(child: particle),
            ],
          );
        }

      case 'border':
        return buildBorderControl(
          '${widget.controlId}::border',
          merged,
          widget.rawChildren,
          widget.buildChild,
          widget.registerInvokeHandler,
          widget.unregisterInvokeHandler,
        );

      case 'shadow':
        return buildShadowStackControl(
          merged,
          _firstChildOrEmpty(widget.rawChildren, widget.buildChild),
        );

      case 'outline':
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: style.outlineColor,
              width: style.outlineWidth,
            ),
            borderRadius: BorderRadius.circular(style.radius),
          ),
          child: _firstChildOrEmpty(widget.rawChildren, widget.buildChild),
        );

      case 'gradient':
        return buildGradientControl(
          merged,
          widget.rawChildren,
          widget.buildChild,
        );

      case 'animation':
      case 'motion':
        return buildMotionControl(
          merged,
          widget.rawChildren,
          widget.buildChild,
        );

      case 'transition':
        return _buildTransitionControl(merged);

      case 'canvas':
        return buildCanvasControl(
          '${widget.controlId}::canvas',
          merged,
          widget.registerInvokeHandler,
          widget.unregisterInvokeHandler,
          widget.sendEvent,
        );

      case 'clip':
        {
          final child = _firstChildOrEmpty(
            widget.rawChildren,
            widget.buildChild,
          );
          final shape = _norm(
            (merged['shape'] ?? merged['clip_shape'] ?? 'rect').toString(),
          );
          final clipBehavior =
              _parseClip(merged['clip_behavior']) ?? Clip.antiAlias;
          if (shape == 'oval' || shape == 'circle') {
            return ClipOval(clipBehavior: clipBehavior, child: child);
          }
          return ClipRRect(
            clipBehavior: clipBehavior,
            borderRadius: BorderRadius.circular(style.radius),
            child: child,
          );
        }

      case 'decorated_box':
        return DecoratedBox(
          decoration: BoxDecoration(
            color: style.background,
            gradient: coerceGradient(merged['gradient']),
            border: _coerceBorder(merged),
            borderRadius: BorderRadius.circular(style.radius),
            boxShadow: coerceBoxShadow(merged['shadow']),
          ),
          child: _firstChildOrEmpty(widget.rawChildren, widget.buildChild),
        );

      case 'badge':
        return buildBadgeControl(
          '${widget.controlId}::badge',
          merged,
          widget.rawChildren,
          widget.buildChild,
          widget.registerInvokeHandler,
          widget.unregisterInvokeHandler,
          widget.sendEvent,
        );

      case 'avatar':
        {
          final size = coerceDouble(merged['size']) ?? 36.0;
          final label = (merged['label'] ?? merged['text'] ?? '').toString();
          final src = merged['src']?.toString();
          final image = (src != null && src.isNotEmpty)
              ? NetworkImage(src)
              : null;
          return CircleAvatar(
            radius: size / 2,
            backgroundColor: style.background,
            foregroundColor: style.foreground,
            backgroundImage: image,
            child: image == null
                ? Text(
                    label.isNotEmpty
                        ? label.substring(0, 1).toUpperCase()
                        : '?',
                  )
                : null,
          );
        }

      case 'icon':
        return Icon(
          _parseIcon(merged['icon']) ?? Icons.help_outline,
          size: coerceDouble(merged['size']),
          color: coerceColor(merged['color']) ?? style.foreground,
        );

      case 'text':
        return Text(
          (merged['text'] ?? merged['value'] ?? '').toString(),
          textAlign: _parseTextAlign(merged['align']) ?? TextAlign.start,
          maxLines: coerceOptionalInt(merged['max_lines']),
          overflow: _parseTextOverflow(merged['overflow']),
          style: TextStyle(
            color:
                coerceColor(merged['color'] ?? merged['text_color']) ??
                style.foreground,
            fontSize: coerceDouble(merged['size'] ?? merged['font_size']),
            fontWeight: _parseWeight(merged['weight'] ?? merged['font_weight']),
          ),
        );

      default:
        return buildContainerControl(
          merged,
          widget.rawChildren,
          widget.buildChild,
        );
    }
  }

  Widget _buildTransitionControl(Map<String, Object?> merged) {
    return AnimatedSwitcher(
      duration: Duration(
        milliseconds: (coerceOptionalInt(merged['duration_ms']) ?? 220).clamp(
          1,
          120000,
        ),
      ),
      switchInCurve: _parseCurve(merged['curve']) ?? Curves.easeOutCubic,
      switchOutCurve: _parseCurve(merged['curve']) ?? Curves.easeOutCubic,
      transitionBuilder: (child, animation) {
        final preset = _norm((merged['preset'] ?? 'fade').toString());
        if (preset == 'scale') {
          return ScaleTransition(scale: animation, child: child);
        }
        if (preset == 'slide') {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.08, 0),
              end: Offset.zero,
            ).animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          );
        }
        return FadeTransition(opacity: animation, child: child);
      },
      child: KeyedSubtree(
        key: ValueKey(
          merged['key'] ?? merged['state'] ?? merged['value'] ?? _module,
        ),
        child: _firstChildOrEmpty(widget.rawChildren, widget.buildChild),
      ),
    );
  }

  Widget _composeSlots(
    Widget base,
    Map<String, Object?> root,
    Map<String, Object?> merged,
    List<dynamic> rawChildren,
    Widget Function(Map<String, Object?> child) buildChild,
  ) {
    final slots = _coerceObjectMap(root['slots']);

    Widget childFromSlot(Object? value) {
      if (value is Map) {
        return buildChild(coerceObjectMap(value));
      }
      return const SizedBox.shrink();
    }

    final leading = childFromSlot(slots['leading'] ?? merged['leading']);
    final trailing = childFromSlot(slots['trailing'] ?? merged['trailing']);
    final overlay = childFromSlot(slots['overlay'] ?? merged['overlay']);
    final background = childFromSlot(
      slots['background'] ?? merged['background'],
    );
    final content = childFromSlot(slots['content']);

    Widget composed = base;

    if (content is! SizedBox) {
      composed = content;
    }

    if (leading is! SizedBox || trailing is! SizedBox) {
      composed = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading is! SizedBox) leading,
          Flexible(child: composed),
          if (trailing is! SizedBox) trailing,
        ],
      );
    }

    if (background is! SizedBox || overlay is! SizedBox) {
      composed = Stack(
        fit: StackFit.passthrough,
        children: [
          if (background is! SizedBox)
            Positioned.fill(child: IgnorePointer(child: background)),
          composed,
          if (overlay is! SizedBox)
            Positioned.fill(child: IgnorePointer(child: overlay)),
        ],
      );
    }

    if (rawChildren.isNotEmpty && slots['content'] == null) {
      final child = _firstChildOrEmpty(rawChildren, buildChild);
      if (child is! SizedBox) {
        composed = Stack(
          fit: StackFit.passthrough,
          children: [composed, child],
        );
      }
    }

    return composed;
  }

  Widget _applyVisualPipeline(
    Widget base,
    Map<String, Object?> merged,
    _CandyStyle style,
  ) {
    Widget out = base;

    final clipBehavior = _parseClip(merged['clip_behavior']);
    if (clipBehavior != null && clipBehavior != Clip.none) {
      out = ClipRRect(
        borderRadius: BorderRadius.circular(style.radius),
        clipBehavior: clipBehavior,
        child: out,
      );
    }

    final shadow = coerceBoxShadow(merged['shadow']);
    final border = _coerceBorder(merged);
    final gradient = coerceGradient(merged['gradient']);

    if (shadow != null ||
        border != null ||
        gradient != null ||
        style.background != null) {
      out = DecoratedBox(
        decoration: BoxDecoration(
          color: style.background,
          gradient: gradient,
          border: border,
          boxShadow: shadow,
          borderRadius: BorderRadius.circular(style.radius),
        ),
        child: out,
      );
    }

    final opacity = coerceDouble(merged['opacity']);
    if (opacity != null && opacity < 1.0) {
      out = Opacity(opacity: opacity.clamp(0.0, 1.0), child: out);
    }

    return out;
  }

  Widget _wrapWithMotion(Widget base, Map<String, Object?> merged) {
    final animation = _coerceObjectMap(merged['animation']);
    final transition = _coerceObjectMap(merged['transition']);
    final motion = _coerceObjectMap(merged['motion']);
    if (animation.isEmpty && transition.isEmpty && motion.isEmpty) {
      return base;
    }

    final durationMs =
        (coerceOptionalInt(
                  animation['duration_ms'] ??
                      transition['duration_ms'] ??
                      motion['duration_ms'],
                ) ??
                220)
            .clamp(1, 120000);
    final curve =
        _parseCurve(
          animation['curve'] ?? transition['curve'] ?? motion['curve'],
        ) ??
        Curves.easeOutCubic;
    final scale = coerceDouble(animation['scale'] ?? motion['scale']) ?? 1.0;
    final targetOpacity =
        coerceDouble(animation['opacity'] ?? motion['opacity']) ?? 1.0;

    return AnimatedContainer(
      duration: Duration(milliseconds: durationMs),
      curve: curve,
      transform: Matrix4.identity()..scale(scale),
      child: AnimatedOpacity(
        duration: Duration(milliseconds: durationMs),
        curve: curve,
        opacity: targetOpacity.clamp(0.0, 1.0),
        child: base,
      ),
    );
  }

  Widget _wrapWithSemantics(
    Widget base,
    Map<String, Object?> merged,
    String module,
  ) {
    final semantics = _coerceObjectMap(merged['semantics']);
    final accessibility = _coerceObjectMap(merged['accessibility']);
    final label =
        (accessibility['label'] ??
                semantics['label'] ??
                merged['label'] ??
                merged['text'])
            ?.toString();
    final hint = (accessibility['hint'] ?? semantics['hint'])?.toString();
    final value =
        (accessibility['value'] ?? semantics['value'] ?? merged['value'])
            ?.toString();
    final button =
        accessibility['button'] == true ||
        semantics['button'] == true ||
        module == 'button';
    final enabled = merged['enabled'] == null
        ? true
        : (merged['enabled'] == true);

    return Semantics(
      label: label,
      hint: hint,
      value: value,
      button: button,
      enabled: enabled,
      focusable:
          accessibility['focusable'] == true || semantics['focusable'] == true,
      liveRegion:
          accessibility['live_region'] == true ||
          semantics['live_region'] == true,
      child: base,
    );
  }

  Widget _wrapWithPerformance(Widget base, Map<String, Object?> merged) {
    final perf = _coerceObjectMap(merged['performance']);
    final cache = merged['cache'] == true || perf['cache'] == true;
    final repaintBoundary = cache || perf['repaint_boundary'] == true;

    Widget out = base;
    if (repaintBoundary) {
      out = RepaintBoundary(child: out);
    }

    final keyValue = merged['key'] ?? merged['revision'] ?? perf['revision'];
    if (keyValue != null) {
      out = KeyedSubtree(key: ValueKey(keyValue), child: out);
    }

    return out;
  }

  Widget _wrapWithInteraction(
    Widget base,
    Map<String, Object?> merged,
    String module,
  ) {
    final enabled = merged['enabled'] == null
        ? true
        : (merged['enabled'] == true);
    final interactive = enabled && _isInteractive(module);

    if (!interactive) {
      return base;
    }

    return FocusableActionDetector(
      enabled: enabled,
      onShowFocusHighlight: (value) {
        setState(() {
          _focused = value;
          _state = _resolveState(
            _runtimeProps,
            hovered: _hovered,
            focused: _focused,
            pressed: _pressed,
          );
        });
        _emit('focus_change', {'focused': value, 'state': _state});
      },
      onShowHoverHighlight: (value) {
        setState(() {
          _hovered = value;
          _state = _resolveState(
            _runtimeProps,
            hovered: _hovered,
            focused: _focused,
            pressed: _pressed,
          );
        });
        _emit(value ? 'hover_enter' : 'hover_exit', {
          'hovered': value,
          'state': _state,
        });
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _emit('tap', {'module': module, 'state': _state});
          _emit('click', {'module': module, 'state': _state});
        },
        onDoubleTap: () {
          _emit('double_tap', {'module': module, 'state': _state});
        },
        onLongPress: () {
          _emit('long_press', {'module': module, 'state': _state});
        },
        onTapDown: (_) {
          setState(() {
            _pressed = true;
            _state = _resolveState(
              _runtimeProps,
              hovered: _hovered,
              focused: _focused,
              pressed: _pressed,
            );
          });
          _emit('state_change', {'state': _state});
        },
        onTapUp: (_) {
          setState(() {
            _pressed = false;
            _state = _resolveState(
              _runtimeProps,
              hovered: _hovered,
              focused: _focused,
              pressed: _pressed,
            );
          });
          _emit('state_change', {'state': _state});
        },
        onTapCancel: () {
          setState(() {
            _pressed = false;
            _state = _resolveState(
              _runtimeProps,
              hovered: _hovered,
              focused: _focused,
              pressed: _pressed,
            );
          });
          _emit('state_change', {'state': _state});
        },
        child: base,
      ),
    );
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    final eventName = _norm(event);
    if (!_candyEvents.contains(eventName)) return;
    final configured = _configuredEvents(_runtimeProps);
    if (configured.isNotEmpty && !configured.contains(eventName)) return;
    widget.sendEvent(widget.controlId, eventName, {
      'schema_version': _runtimeProps['schema_version'],
      'module': _module,
      'state': _state,
      ...payload,
    });
  }
}

class _CandyStyle {
  const _CandyStyle({
    required this.background,
    required this.foreground,
    required this.outlineColor,
    required this.outlineWidth,
    required this.radius,
  });

  final Color? background;
  final Color? foreground;
  final Color outlineColor;
  final double outlineWidth;
  final double radius;
}

_CandyStyle _resolveStyle(
  BuildContext context,
  CandyTokens tokens,
  Map<String, Object?> root,
  Map<String, Object?> merged,
) {
  final theme = _coerceObjectMap(root['theme']);
  final tokenMap = _coerceObjectMap(root['tokens']);
  final tokenOverrides = _coerceObjectMap(root['token_overrides']);

  Color? pickColor(List<Object?> candidates) {
    for (final raw in candidates) {
      final resolved = coerceColor(raw);
      if (resolved != null) return resolved;
      if (raw is String) {
        final tokenKey = _norm(raw);
        final fromOverride = coerceColor(tokenOverrides[tokenKey]);
        if (fromOverride != null) return fromOverride;
        final fromTokens = coerceColor(tokenMap[tokenKey]);
        if (fromTokens != null) return fromTokens;
      }
    }
    return null;
  }

  final background = pickColor([
    merged['bgcolor'],
    merged['background'],
    theme['background'],
    tokenOverrides['background'],
    tokenMap['background'],
    tokens.color('surface'),
    Theme.of(context).colorScheme.surface,
  ]);

  final foreground = pickColor([
    merged['text_color'],
    merged['color'],
    theme['foreground'],
    theme['text'],
    tokenOverrides['text'],
    tokenMap['text'],
    tokens.color('text'),
    Theme.of(context).colorScheme.onSurface,
  ]);

  final outlineColor =
      pickColor([
        merged['outline_color'],
        merged['border_color'],
        tokenOverrides['outline'],
        tokenMap['outline'],
        tokens.color('border'),
        Theme.of(context).colorScheme.outline,
      ]) ??
      Theme.of(context).colorScheme.outline;

  final outlineWidth =
      coerceDouble(
        merged['outline_width'] ??
            merged['border_width'] ??
            tokenOverrides['outline_width'] ??
            tokenMap['outline_width'],
      ) ??
      1.0;

  final radius =
      coerceDouble(
        merged['radius'] ??
            tokenOverrides['radius'] ??
            tokenMap['radius'] ??
            tokens.number('radii', 'md'),
      ) ??
      0.0;

  return _CandyStyle(
    background: background,
    foreground: foreground,
    outlineColor: outlineColor,
    outlineWidth: outlineWidth,
    radius: radius,
  );
}

Map<String, Object?> _normalizeProps(Map<String, Object?> input) {
  final out = Map<String, Object?>.from(input);
  out['schema_version'] =
      (coerceOptionalInt(out['schema_version']) ?? _candySchemaVersion).clamp(
        1,
        9999,
      );

  final module = _norm(out['module']?.toString() ?? '');
  if (module.isNotEmpty && _candyModules.contains(module)) {
    out['module'] = module;
  } else if (module.isNotEmpty) {
    out.remove('module');
  }

  final state = _norm(out['state']?.toString() ?? '');
  if (state.isNotEmpty && _candyStates.contains(state)) {
    out['state'] = state;
  } else if (state.isNotEmpty) {
    out.remove('state');
  }

  final events = out['events'];
  if (events is List) {
    out['events'] = events
        .map((e) => _norm(e?.toString() ?? ''))
        .where((e) => e.isNotEmpty && _candyEvents.contains(e))
        .toSet()
        .toList(growable: false);
  }

  final modules = _coerceObjectMap(out['modules']);
  if (modules.isNotEmpty) {
    final normalizedModules = <String, Object?>{};
    for (final entry in modules.entries) {
      final normalizedModule = _norm(entry.key);
      if (!_candyModules.contains(normalizedModule)) continue;
      if (entry.value == true) {
        normalizedModules[normalizedModule] = <String, Object?>{};
        continue;
      }
      final payload = _coerceObjectMap(entry.value);
      if (payload.isEmpty && entry.value is! Map) continue;
      normalizedModules[normalizedModule] = _sanitizeModulePayload(
        normalizedModule,
        payload,
      );
    }
    out['modules'] = normalizedModules;
  }

  for (final moduleKey in _candyModules) {
    final payload = _coerceObjectMap(out[moduleKey]);
    if (payload.isNotEmpty) {
      out[moduleKey] = _sanitizeModulePayload(moduleKey, payload);
    }
  }
  final umbrella = normalizeUmbrellaHostProps(
    props: out,
    modules: _candyModules,
    roleAliases: _candyRegistryRoleAliases,
    manifestDefaults: _candyManifestDefaults,
  );
  out['manifest'] = umbrella['manifest'];
  out['registries'] = umbrella['registries'];
  return out;
}

String _resolveModule(Map<String, Object?> props) {
  final explicit = _norm(props['module']?.toString() ?? '');
  if (explicit.isNotEmpty && _candyModules.contains(explicit)) {
    return explicit;
  }

  final manifest = _coerceObjectMap(props['manifest']);
  final enabledModules = umbrellaRuntimeStringList(
    manifest['enabled_modules'],
    allowed: _candyModules,
  );
  if (enabledModules.isNotEmpty) {
    for (final module in enabledModules) {
      if (!props.containsKey(module)) continue;
      final value = props[module];
      if (value == null || value == false) continue;
      return module;
    }
    final moduleMap = _coerceObjectMap(props['modules']);
    for (final module in enabledModules) {
      final value = moduleMap[module];
      if (value == null || value == false) continue;
      return module;
    }
    return enabledModules.first;
  }

  for (final module in _candyModules) {
    if (!props.containsKey(module)) continue;
    final value = props[module];
    if (value == null || value == false) continue;
    return module;
  }

  final modules = _coerceObjectMap(props['modules']);
  for (final entry in modules.entries) {
    final module = _norm(entry.key);
    if (_candyModules.contains(module)) {
      return module;
    }
  }

  return 'surface';
}

String _resolveState(
  Map<String, Object?> props, {
  required bool hovered,
  required bool focused,
  required bool pressed,
}) {
  final explicit = _norm(props['state']?.toString() ?? '');
  if (explicit.isNotEmpty && _candyStates.contains(explicit)) {
    return explicit;
  }

  if (props['disabled'] == true || props['enabled'] == false) return 'disabled';
  if (props['loading'] == true) return 'loading';
  if (pressed || props['pressed'] == true) return 'pressed';
  if (hovered || props['hovered'] == true) return 'hover';
  if (focused || props['focused'] == true) return 'focused';
  if (props['selected'] == true) return 'selected';
  return 'idle';
}

Map<String, Object?> _mergeModuleProps(
  Map<String, Object?> props,
  String module,
) {
  final out = Map<String, Object?>.from(props);
  final modules = _coerceObjectMap(props['modules']);
  final fromModules = modules[module];
  if (fromModules is Map) {
    out.addAll(coerceObjectMap(fromModules));
  }

  final modulePayload = props[module];
  if (modulePayload is Map) {
    out.addAll(coerceObjectMap(modulePayload));
  }

  return out;
}

Set<String> _configuredEvents(Map<String, Object?> props) {
  final raw = props['events'];
  final out = <String>{};
  if (raw is List) {
    for (final entry in raw) {
      final value = _norm(entry?.toString() ?? '');
      if (value.isNotEmpty) {
        out.add(value);
      }
    }
  }
  return out;
}

Map<String, Object?> _coerceObjectMap(Object? value) {
  if (value is Map) return coerceObjectMap(value);
  return <String, Object?>{};
}

Map<String, Object?> _sanitizeModulePayload(
  String module,
  Map<String, Object?> payload,
) {
  final normalizedModule = _norm(module);
  final allowed = {
    ..._candyCommonPayloadKeys,
    ...(_candyModuleAllowedKeys[normalizedModule] ?? const <String>{}),
  };
  final expectedTypes = {
    ..._candyCommonPayloadTypes,
    ...(_candyModulePayloadTypes[normalizedModule] ?? const <String, String>{}),
  };
  final out = <String, Object?>{};
  for (final entry in payload.entries) {
    final key = _norm(entry.key);
    if (!allowed.contains(key)) continue;
    final type = expectedTypes[key] ?? 'any';
    if (_isCandyTypeMatch(type, entry.value)) {
      out[key] = entry.value;
    }
  }
  return out;
}

bool _isCandyTypeMatch(String type, Object? value) {
  if (value == null) return true;
  switch (type) {
    case 'any':
      return true;
    case 'bool':
      return value is bool;
    case 'string':
      return value is String;
    case 'num':
      return value is num;
    case 'int':
      return value is int;
    case 'map':
      return value is Map;
    case 'list':
      return value is List;
    case 'events':
      return value is List &&
          value.every(
            (item) => item is String && _candyEvents.contains(_norm(item)),
          );
    case 'state':
      return value is String && _candyStates.contains(_norm(value));
    case 'color':
      return coerceColor(value) != null;
    case 'dimension':
      return value is num || value is String;
    case 'alignment':
      return _parseAlignment(value) != null ||
          (value is String && _norm(value) == 'center');
    case 'padding':
      return value is num || value is List || value is Map;
    default:
      return true;
  }
}

bool _isInteractive(String module) {
  return switch (module) {
    'button' || 'badge' || 'avatar' || 'icon' || 'text' => true,
    _ => false,
  };
}

Widget _firstChildOrEmpty(
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
) {
  for (final raw in rawChildren) {
    if (raw is Map) {
      return buildChild(coerceObjectMap(raw));
    }
  }
  return const SizedBox.shrink();
}

String _norm(String value) {
  return value.trim().toLowerCase().replaceAll('-', '_').replaceAll(' ', '_');
}

Border? _coerceBorder(Map<String, Object?> props) {
  final color = coerceColor(props['border_color']);
  final width = coerceDouble(props['border_width']) ?? 1.0;
  if (color == null) return null;
  return Border.all(color: color, width: width);
}

Alignment? _parseAlignment(Object? value) {
  if (value == null) return null;
  if (value is List && value.length >= 2) {
    final x = coerceDouble(value[0]) ?? 0.0;
    final y = coerceDouble(value[1]) ?? 0.0;
    return Alignment(x, y);
  }
  if (value is Map) {
    final map = coerceObjectMap(value);
    final x = coerceDouble(map['x']);
    final y = coerceDouble(map['y']);
    if (x != null || y != null) {
      return Alignment(x ?? 0.0, y ?? 0.0);
    }
  }
  final s = _norm(value.toString());
  switch (s) {
    case 'center':
      return Alignment.center;
    case 'top':
    case 'top_center':
      return Alignment.topCenter;
    case 'bottom':
    case 'bottom_center':
      return Alignment.bottomCenter;
    case 'left':
    case 'center_left':
    case 'start':
      return Alignment.centerLeft;
    case 'right':
    case 'center_right':
    case 'end':
      return Alignment.centerRight;
    case 'top_left':
      return Alignment.topLeft;
    case 'top_right':
      return Alignment.topRight;
    case 'bottom_left':
      return Alignment.bottomLeft;
    case 'bottom_right':
      return Alignment.bottomRight;
    default:
      return null;
  }
}

Clip? _parseClip(Object? value) {
  final s = _norm(value?.toString() ?? '');
  switch (s) {
    case 'none':
      return Clip.none;
    case 'hardedge':
    case 'hard_edge':
      return Clip.hardEdge;
    case 'antialias':
    case 'anti_alias':
      return Clip.antiAlias;
    case 'antialiaswithsavelayer':
    case 'anti_alias_with_save_layer':
      return Clip.antiAliasWithSaveLayer;
    default:
      return null;
  }
}

BoxFit? _parseBoxFit(Object? value) {
  final s = _norm(value?.toString() ?? '');
  switch (s) {
    case 'fill':
      return BoxFit.fill;
    case 'contain':
      return BoxFit.contain;
    case 'cover':
      return BoxFit.cover;
    case 'fit_width':
    case 'fitwidth':
      return BoxFit.fitWidth;
    case 'fit_height':
    case 'fitheight':
      return BoxFit.fitHeight;
    case 'none':
      return BoxFit.none;
    case 'scale_down':
    case 'scaledown':
      return BoxFit.scaleDown;
    default:
      return null;
  }
}

Curve? _parseCurve(Object? value) {
  final s = _norm(value?.toString() ?? '');
  switch (s) {
    case 'linear':
      return Curves.linear;
    case 'ease_in':
    case 'easein':
      return Curves.easeIn;
    case 'ease_out':
    case 'easeout':
      return Curves.easeOut;
    case 'ease_in_out':
    case 'easeinout':
      return Curves.easeInOut;
    case 'fast_out_slow_in':
    case 'fastoutslowin':
      return Curves.fastOutSlowIn;
    default:
      return null;
  }
}

TextAlign? _parseTextAlign(Object? value) {
  final s = _norm(value?.toString() ?? '');
  switch (s) {
    case 'left':
    case 'start':
      return TextAlign.start;
    case 'right':
    case 'end':
      return TextAlign.end;
    case 'center':
      return TextAlign.center;
    case 'justify':
      return TextAlign.justify;
    default:
      return null;
  }
}

TextOverflow? _parseTextOverflow(Object? value) {
  final s = _norm(value?.toString() ?? '');
  switch (s) {
    case 'clip':
      return TextOverflow.clip;
    case 'fade':
      return TextOverflow.fade;
    case 'visible':
      return TextOverflow.visible;
    case 'ellipsis':
      return TextOverflow.ellipsis;
    default:
      return null;
  }
}

FontWeight? _parseWeight(Object? value) {
  if (value == null) return null;
  if (value is int) {
    switch (value) {
      case 100:
        return FontWeight.w100;
      case 200:
        return FontWeight.w200;
      case 300:
        return FontWeight.w300;
      case 400:
        return FontWeight.w400;
      case 500:
        return FontWeight.w500;
      case 600:
        return FontWeight.w600;
      case 700:
        return FontWeight.w700;
      case 800:
        return FontWeight.w800;
      case 900:
        return FontWeight.w900;
      default:
        return null;
    }
  }
  final s = _norm(value.toString());
  if (s == 'normal') return FontWeight.w400;
  if (s == 'bold') return FontWeight.w700;
  if (s.startsWith('w')) {
    final parsed = int.tryParse(s.substring(1));
    return _parseWeight(parsed);
  }
  final parsed = int.tryParse(s);
  return _parseWeight(parsed);
}

IconData? _parseIcon(Object? value) {
  final key = _norm(value?.toString() ?? '');
  switch (key) {
    case 'add':
    case 'plus':
      return Icons.add;
    case 'remove':
    case 'minus':
      return Icons.remove;
    case 'close':
    case 'x':
      return Icons.close;
    case 'check':
    case 'done':
      return Icons.check;
    case 'warning':
      return Icons.warning_amber_rounded;
    case 'error':
      return Icons.error_outline;
    case 'info':
      return Icons.info_outline;
    case 'search':
      return Icons.search;
    case 'menu':
      return Icons.menu;
    case 'settings':
      return Icons.settings;
    case 'home':
      return Icons.home_outlined;
    case 'arrow_back':
    case 'back':
      return Icons.arrow_back;
    case 'arrow_forward':
    case 'forward':
      return Icons.arrow_forward;
    default:
      return null;
  }
}
