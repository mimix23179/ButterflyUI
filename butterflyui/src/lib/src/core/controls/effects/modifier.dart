import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/candy/theme.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/modifiers/control_capabilities.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildModifierControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ModifierControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _ModifierControl extends StatefulWidget {
  const _ModifierControl({
    required this.controlId,
    required this.props,
    required this.rawChildren,
    required this.buildChild,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final List<dynamic> rawChildren;
  final Widget Function(Map<String, Object?> child) buildChild;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_ModifierControl> createState() => _ModifierControlState();
}

class _ModifierControlState extends State<_ModifierControl> {
  late Map<String, Object?> _state;

  @override
  void initState() {
    super.initState();
    _state = {...widget.props};
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _ModifierControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    if (oldWidget.props != widget.props) {
      _state = {...widget.props};
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
    switch (method) {
      case 'set_props':
        setState(() {
          _state = {..._state, ...args};
        });
        return _state;
      case 'get_state':
        return _state;
      case 'emit':
        if (widget.controlId.isNotEmpty) {
          final event = (args['event'] ?? 'change').toString();
          final payload = args['payload'] is Map
              ? coerceObjectMap(args['payload'] as Map)
              : <String, Object?>{};
          widget.sendEvent(widget.controlId, event, payload);
        }
        return null;
      default:
        throw UnsupportedError('Unknown modifier method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (final child in _resolvedChildMaps()) {
      children.add(widget.buildChild(_applyModifiersToNode(child)));
    }
    if (children.isEmpty) return const SizedBox.shrink();
    if (children.length == 1) return children.first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  List<Map<String, Object?>> _resolvedChildMaps() {
    final out = <Map<String, Object?>>[];
    for (final raw in widget.rawChildren) {
      if (raw is Map) out.add(coerceObjectMap(raw));
    }
    final propChild = _state['child'];
    if (out.isEmpty && propChild is Map) {
      out.add(coerceObjectMap(propChild));
    }
    final propChildren = _state['children'];
    if (out.isEmpty && propChildren is List) {
      for (final raw in propChildren) {
        if (raw is Map) out.add(coerceObjectMap(raw));
      }
    }
    return out;
  }

  Map<String, Object?> _applyModifiersToNode(Map<String, Object?> input) {
    final node = _cloneNode(input);
    final props = node['props'] is Map
        ? coerceObjectMap(node['props'] as Map)
        : <String, Object?>{};
    final type = _normalizeType(node['type']);
    final capabilities = ControlModifierCapabilities.forControl(type);
    final canInjectModifiers =
        capabilities.supportsInteractiveModifiers ||
        capabilities.supportsGlassModifiers ||
        capabilities.supportsTransitionModifiers;
    final canInjectMotion = canInjectModifiers;
    final canInjectStylePatch = canInjectModifiers;

    if (canInjectModifiers) {
      final list = <Object?>[];
      final defaults = _state['modifiers'];
      if (defaults is List) {
        list.addAll(defaults);
      }
      _appendShorthandModifiers(list);
      final current = props['modifiers'];
      if (current is List) {
        list.addAll(current);
      }
      if (list.isNotEmpty) {
        props['modifiers'] = list;
      }
    }

    if (canInjectMotion && !props.containsKey('motion') && _state.containsKey('motion')) {
      props['motion'] = _state['motion'];
    }
    if (canInjectMotion) {
      for (final key in const <String>[
        'cursor',
        'padding',
        'margin',
        'align',
        'alignment',
        'max_width',
        'max_height',
        'min_width',
        'min_height',
        'hit_test',
      ]) {
        if (!props.containsKey(key) && _state.containsKey(key)) {
          props[key] = _state[key];
        }
      }
    }

    if (canInjectStylePatch) {
      final style = props['style'] is Map
          ? coerceObjectMap(props['style'] as Map)
          : <String, Object?>{};
      final stylePatch = <String, Object?>{};
      if (_state.containsKey('background')) {
        stylePatch['bgcolor'] = _state['background'];
      }
      if (_state.containsKey('border')) {
        stylePatch['border'] = _state['border'];
      }
      if (_state.containsKey('shadow')) {
        stylePatch['shadow'] = _state['shadow'];
      }
      if (stylePatch.isNotEmpty) {
        props['style'] = CandyTokens.mergeMaps(stylePatch, style);
      }
    }

    node['props'] = props;
    if (node['children'] is List) {
      final rawChildren = node['children'] as List;
      node['children'] = rawChildren
          .map((child) {
            if (child is Map) {
              return _applyModifiersToNode(coerceObjectMap(child));
            }
            return child;
          })
          .toList(growable: false);
    }
    return node;
  }

  String _normalizeType(Object? value) {
    return (value?.toString() ?? '')
        .trim()
        .toLowerCase()
        .replaceAll('-', '_')
        .replaceAll(' ', '_');
  }

  void _appendShorthandModifiers(List<Object?> list) {
    final glow = _state['glow'];
    if (glow != null) {
      if (glow is Map) {
        list.add({'type': 'glow', ...coerceObjectMap(glow)});
      } else if (glow == true) {
        list.add({'type': 'glow'});
      }
    }
    final glass = _state['glass'];
    if (glass != null) {
      if (glass is Map) {
        list.add({'type': 'glass', ...coerceObjectMap(glass)});
      } else if (glass == true) {
        list.add({'type': 'glass'});
      }
    }
    final focusRing = _state['focus_ring'];
    if (focusRing != null) {
      if (focusRing is Map) {
        list.add({'type': 'focus_ring', ...coerceObjectMap(focusRing)});
      } else if (focusRing == true) {
        list.add({'type': 'focus_ring'});
      }
    }
    final onHover = _state['on_hover'];
    final onPressed = _state['on_pressed'] ?? _state['on_press'];
    final onFocus = _state['on_focus'];
    if (onHover is List || onPressed is List || onFocus is List) {
      list.add({
        'type': 'state',
        if (onHover is List) 'hover': onHover,
        if (onPressed is List) 'press': onPressed,
        if (onFocus is List) 'focus': onFocus,
      });
    }
  }

  Map<String, Object?> _cloneNode(Map<String, Object?> node) {
    final out = <String, Object?>{};
    node.forEach((key, value) {
      if (value is Map) {
        out[key] = _cloneNode(coerceObjectMap(value));
      } else if (value is List) {
        out[key] = value
            .map((item) {
              if (item is Map) return _cloneNode(coerceObjectMap(item));
              return item;
            })
            .toList(growable: false);
      } else {
        out[key] = value;
      }
    });
    return out;
  }
}
