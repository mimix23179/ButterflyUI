import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/candy/theme.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildStyleControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _StyleControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _StyleControl extends StatefulWidget {
  const _StyleControl({
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
  State<_StyleControl> createState() => _StyleControlState();
}

class _StyleControlState extends State<_StyleControl> {
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
  void didUpdateWidget(covariant _StyleControl oldWidget) {
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
        throw UnsupportedError('Unknown style method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    final childMaps = _resolvedChildMaps();
    for (final child in childMaps) {
      children.add(widget.buildChild(_applyStyleToNode(child)));
    }

    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    final tokenMap = _tokenOverrides();
    final stylePack = (_state['style_pack'] ?? _state['pack'] ?? '').toString();
    final cardBg = coerceColor(
      _state['bgcolor'] ??
          _state['background'] ??
          _state['surface'] ??
          tokenMap['surface'],
    );
    final borderColor = coerceColor(_state['border_color']);
    final radius = coerceDouble(_state['radius']);
    final padding = coercePadding(_state['padding']);
    final margin = coercePadding(_state['margin']);

    Widget body = children.length == 1
        ? children.first
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: children,
          );

    if (cardBg != null ||
        borderColor != null ||
        radius != null ||
        padding != null ||
        margin != null) {
      body = Container(
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          color: cardBg,
          border: borderColor == null ? null : Border.all(color: borderColor),
          borderRadius: radius == null ? null : BorderRadius.circular(radius),
        ),
        child: body,
      );
    }

    if (stylePack.isNotEmpty) {
      final labelColor = coerceColor(tokenMap['primary']) ?? Colors.white54;
      body = Stack(
        children: [
          body,
          Positioned(
            right: 8,
            top: 6,
            child: Text(
              stylePack,
              style: TextStyle(
                color: labelColor.withValues(alpha: 0.75),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    }

    return body;
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

  Map<String, Object?> _tokenOverrides() {
    final out = <String, Object?>{};
    final direct = _state['tokens'];
    if (direct is Map) out.addAll(coerceObjectMap(direct));
    final alias = _state['token_overrides'];
    if (alias is Map) out.addAll(coerceObjectMap(alias));
    final styleTokens = _state['style_tokens'];
    if (styleTokens is Map) out.addAll(coerceObjectMap(styleTokens));
    return out;
  }

  Map<String, Object?> _applyStyleToNode(Map<String, Object?> input) {
    final node = _cloneNode(input);
    final props = node['props'] is Map
        ? coerceObjectMap(node['props'] as Map)
        : <String, Object?>{};

    final stylePack = (_state['style_pack'] ?? _state['pack'])?.toString();
    if (stylePack != null &&
        stylePack.isNotEmpty &&
        !props.containsKey('style_pack')) {
      props['style_pack'] = stylePack;
    }

    final tokenOverrides = _tokenOverrides();
    if (tokenOverrides.isNotEmpty) {
      final existingTokens = props['tokens'] is Map
          ? coerceObjectMap(props['tokens'] as Map)
          : <String, Object?>{};
      props['tokens'] = CandyTokens.mergeMaps(existingTokens, tokenOverrides);
      props['token_overrides'] = props['tokens'];
      props['style_tokens'] = props['tokens'];
    }

    final defaultStyle = _state['default_style'] is Map
        ? coerceObjectMap(_state['default_style'] as Map)
        : <String, Object?>{};
    final recipe = _recipeForType(node['type']?.toString());
    final existingStyle = props['style'] is Map
        ? coerceObjectMap(props['style'] as Map)
        : <String, Object?>{};
    props['style'] = CandyTokens.mergeMaps(
      CandyTokens.mergeMaps(defaultStyle, recipe),
      existingStyle,
    );

    final defaultModifiers = _state['default_modifiers'];
    if (defaultModifiers is List) {
      final existing = props['modifiers'] is List
          ? List<Object?>.from(props['modifiers'] as List)
          : <Object?>[];
      props['modifiers'] = <Object?>[...defaultModifiers, ...existing];
    }
    if (!props.containsKey('motion') && _state.containsKey('default_motion')) {
      props['motion'] = _state['default_motion'];
    }
    if (!props.containsKey('state') && _state.containsKey('state')) {
      props['state'] = _state['state'];
    }
    if (!props.containsKey('variant') && _state.containsKey('variant')) {
      props['variant'] = _state['variant'];
    }

    node['props'] = props;

    final rawChildren = node['children'];
    if (rawChildren is List) {
      node['children'] = rawChildren
          .map((child) {
            if (child is Map) return _applyStyleToNode(coerceObjectMap(child));
            return child;
          })
          .toList(growable: false);
    }
    return node;
  }

  Map<String, Object?> _recipeForType(String? rawType) {
    final recipes = _state['recipes'];
    if (recipes is! Map) return const <String, Object?>{};
    final map = coerceObjectMap(recipes);
    final type = (rawType ?? '').toLowerCase();
    if (type.isNotEmpty && map[type] is Map) {
      return coerceObjectMap(map[type] as Map);
    }
    final wildcard = map['*'];
    if (wildcard is Map) return coerceObjectMap(wildcard);
    return const <String, Object?>{};
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
