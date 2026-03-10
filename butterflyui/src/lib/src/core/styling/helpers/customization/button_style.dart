import 'package:flutter/material.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/styling/helpers/helper_bridge.dart';
import 'package:butterflyui_runtime/src/core/styling/stylesheet.dart';
import 'package:butterflyui_runtime/src/core/styling/theme.dart';
import 'package:butterflyui_runtime/src/core/styling/effects/visuals/renderers/render_layers.dart';

import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class _ButtonStylePreset {
  final String id;
  final String label;

  const _ButtonStylePreset({required this.id, required this.label});
}

class _ButtonStyleControl extends StatefulWidget {
  const _ButtonStyleControl({
    required this.controlId,
    required this.props,
    required this.sendEvent,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;

  @override
  State<_ButtonStyleControl> createState() => _ButtonStyleControlState();
}

class _ButtonStyleControlState extends State<_ButtonStyleControl> {
  late List<_ButtonStylePreset> _options;
  late String _current;

  String _normalizeEventName(String value) {
    final input = value.trim().replaceAll('-', '_');
    if (input.isEmpty) return '';
    final out = StringBuffer();
    for (var i = 0; i < input.length; i += 1) {
      final ch = input[i];
      final isUpper = ch.toUpperCase() == ch && ch.toLowerCase() != ch;
      if (isUpper && i > 0 && input[i - 1] != '_') {
        out.write('_');
      }
      out.write(ch.toLowerCase());
    }
    return out.toString();
  }

  Set<String>? _subscribedEvents() {
    final events = widget.props['events'];
    if (events is! List) return null;
    return events
        .map((e) => _normalizeEventName(e?.toString() ?? ''))
        .where((name) => name.isNotEmpty)
        .toSet();
  }

  bool _isSubscribed(String name) {
    final subscribed = _subscribedEvents();
    if (subscribed == null) return name == 'change';
    return subscribed.contains(_normalizeEventName(name));
  }

  void _emitSelectionEvents(String value) {
    final payload = <String, Object?>{'value': value};
    final actionId = widget.props['action_id']?.toString();
    final actionEventName = widget.props['action_event']?.toString();
    final actionPayload = widget.props['action_payload'];
    if (actionId != null && actionId.isNotEmpty) {
      payload['action_id'] = actionId;
    }
    if (actionEventName != null && actionEventName.isNotEmpty) {
      payload['action_event'] = actionEventName;
    }
    if (actionPayload != null) {
      payload['action_payload'] = actionPayload;
    }

    final events = widget.props['events'];
    if (events is! List || _isSubscribed('change')) {
      widget.sendEvent(widget.controlId, 'change', payload);
    }

    void emitDeclarativeAction(Object? actionSpec, {bool force = false}) {
      var eventName = actionEventName;
      String? resolvedActionId = actionId;
      Object? resolvedActionPayload = actionPayload;

      if (actionSpec == null) {
      } else if (actionSpec is String) {
        final trimmed = actionSpec.trim();
        if (trimmed.isNotEmpty) {
          resolvedActionId = trimmed;
        }
      } else if (actionSpec is Map) {
        final map = coerceObjectMap(actionSpec);
        final mapId =
            map['id']?.toString() ??
            map['action_id']?.toString() ??
            map['name']?.toString();
        if (mapId != null && mapId.isNotEmpty) {
          resolvedActionId = mapId;
        }
        final mapEvent = map['event']?.toString();
        if (mapEvent != null && mapEvent.trim().isNotEmpty) {
          eventName = mapEvent;
        }
        if (map.containsKey('payload')) {
          resolvedActionPayload = map['payload'];
        }
      }

      final resolvedEvent = _normalizeEventName(
        (eventName == null || eventName.isEmpty) ? 'action' : eventName,
      );
      if (resolvedEvent.isEmpty || (!force && !_isSubscribed(resolvedEvent))) {
        return;
      }

      final actionEventPayload = <String, Object?>{
        ...payload,
        if (resolvedActionId != null && resolvedActionId.isNotEmpty)
          'action_id': resolvedActionId,
      };
      if (resolvedActionPayload is Map) {
        actionEventPayload.addAll(coerceObjectMap(resolvedActionPayload));
      } else if (resolvedActionPayload != null) {
        actionEventPayload['action_payload'] = resolvedActionPayload;
      }
      widget.sendEvent(widget.controlId, resolvedEvent, actionEventPayload);
    }

    if (events is! List) {
      emitDeclarativeAction(widget.props['action'], force: true);
      if (widget.props['actions'] is List) {
        for (final actionSpec in widget.props['actions'] as List) {
          emitDeclarativeAction(actionSpec, force: true);
        }
      } else if (actionId != null || actionPayload != null) {
        emitDeclarativeAction(const <String, Object?>{}, force: true);
      }
      return;
    }

    emitDeclarativeAction(widget.props['action']);
    if (widget.props['actions'] is List) {
      for (final actionSpec in widget.props['actions'] as List) {
        emitDeclarativeAction(actionSpec);
      }
    } else if (actionId != null || actionPayload != null) {
      emitDeclarativeAction(const <String, Object?>{});
    }
  }

  @override
  void initState() {
    super.initState();
    _options = _coerceOptions(widget.props);
    _current = _coerceCurrent(widget.props, _options);
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant _ButtonStyleControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
    if (oldWidget.props != widget.props) {
      final options = _coerceOptions(widget.props);
      setState(() {
        _options = options;
        _current = _coerceCurrent(widget.props, options);
      });
    }
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'get_value':
        return _current;
      case 'set_value':
        final value = args['value']?.toString();
        if (value == null || !_options.any((item) => item.id == value)) return null;
        setState(() {
          _current = value;
        });
        _emitSelectionEvents(value);
        return value;
      case 'set_options':
        final next = _coerceOptions({'options': args['options'] ?? args['items']});
        setState(() {
          _options = next;
          if (!_options.any((item) => item.id == _current)) {
            _current = _options.first.id;
          }
        });
        widget.sendEvent(widget.controlId, 'options_changed', {
          'options': [for (final option in _options) {'id': option.id, 'label': option.label}],
        });
        return _current;
      case 'set_state_style':
        final state = (args['state'] ?? '').toString();
        final style = args['style'] is Map
            ? coerceObjectMap(args['style'] as Map)
            : <String, Object?>{};
        widget.sendEvent(widget.controlId, 'state_style_change', {
          'state': state,
          'style': style,
        });
        return true;
      default:
        throw UnsupportedError('Unknown button_style method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final helperProps = resolveStylingHelperProps(
      widget.props,
      controlType: 'button_style',
    );
    final base = _resolveStateProps(helperProps, 'base');
    final hover = _resolveStateProps(helperProps, 'hover');
    final pressed = _resolveStateProps(helperProps, 'pressed');
    final currentOption = _options.firstWhere(
      (item) => item.id == _current,
      orElse: () => _options.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in _options)
              ChoiceChip(
                label: Text(option.label),
                selected: option.id == _current,
                onSelected: (_) {
                  setState(() {
                    _current = option.id;
                  });
                  _emitSelectionEvents(option.id);
                },
              ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildPreviewSurface(
              context,
              '$currentOption.label base',
              base,
              subtitle: 'base styling helper',
            ),
            if (hover.isNotEmpty)
              _buildPreviewSurface(
                context,
                '${currentOption.label} hover',
                hover,
                subtitle: 'hover styling',
              ),
            if (pressed.isNotEmpty)
              _buildPreviewSurface(
                context,
                '${currentOption.label} pressed',
                pressed,
                subtitle: 'pressed styling',
              ),
          ],
        ),
      ],
    );
  }

  Map<String, Object?> _resolveStateProps(
    Map<String, Object?> helperProps,
    String stateKey,
  ) {
    final stateMap = helperProps[stateKey] is Map
        ? normalizeStylingDeclarations(coerceObjectMap(helperProps[stateKey] as Map))
        : const <String, Object?>{};
    return resolveStylingHelperProps(
      StylingTokens.mergeMaps(helperProps, stateMap),
      controlType: 'button_style',
    );
  }

  Widget _buildPreviewSurface(
    BuildContext context,
    String title,
    Map<String, Object?> props, {
    String? subtitle,
  }) {
    final fill =
        coerceColor(props['bgcolor'] ?? props['background']) ??
        Theme.of(context).colorScheme.primaryContainer;
    final foreground =
        coerceColor(props['color'] ?? props['text_color']) ??
        Theme.of(context).colorScheme.onPrimaryContainer;
    final borderColor =
        coerceColor(props['border_color'] ?? props['outline_color']) ??
        coerceColor(props['border']);
    final borderWidth =
        coerceDouble(props['border_width']) ??
        (borderColor == null ? 0.0 : 1.0);
    final radius = coerceDouble(props['radius']) ?? 18.0;
    final padding =
        coercePadding(props['padding']) ??
        const EdgeInsets.symmetric(horizontal: 18, vertical: 12);
    final gradient = coerceGradient(props['gradient']);
    final shadows = coerceBoxShadow(props['shadow']) ?? const <BoxShadow>[];
    final labelStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
      color: foreground,
      fontWeight: FontWeight.w700,
    );
    final subtitleStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
      color: foreground.withValues(alpha: 0.78),
    );

    Widget card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? fill : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
        border: borderColor == null || borderWidth <= 0
            ? null
            : Border.all(color: borderColor, width: borderWidth),
        boxShadow: shadows,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: labelStyle),
          if (subtitle != null && subtitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(subtitle, style: subtitleStyle),
          ],
        ],
      ),
    );

    card = wrapWithEffectRenderLayers(
      controlId: '${widget.controlId}_${title.replaceAll(' ', '_').toLowerCase()}',
      props: props,
      child: card,
    );

    return card;
  }
}

List<_ButtonStylePreset> _coerceOptions(Map<String, Object?> props) {
  final optionsRaw = props['options'] ?? props['items'];
  final options = <_ButtonStylePreset>[];
  if (optionsRaw is List) {
    for (var i = 0; i < optionsRaw.length; i += 1) {
      final item = optionsRaw[i];
      if (item is Map) {
        final id = (item['id'] ?? item['value'] ?? 'style_$i').toString();
        options.add(
          _ButtonStylePreset(
            id: id,
            label: (item['label'] ?? item['name'] ?? id).toString(),
          ),
        );
      } else {
        final text = item?.toString().trim() ?? '';
        if (text.isNotEmpty) {
          options.add(_ButtonStylePreset(id: text, label: text));
        }
      }
    }
  }
  if (options.isEmpty) {
    options.addAll(const [
      _ButtonStylePreset(id: 'solid', label: 'Solid'),
      _ButtonStylePreset(id: 'outline', label: 'Outline'),
      _ButtonStylePreset(id: 'ghost', label: 'Ghost'),
    ]);
  }
  return options;
}

String _coerceCurrent(Map<String, Object?> props, List<_ButtonStylePreset> options) {
  final current = (props['value'] ?? options.first.id).toString();
  return options.any((item) => item.id == current) ? current : options.first.id;
}

Widget buildButtonStyleControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ButtonStyleControl(
    controlId: controlId,
    props: props,
    sendEvent: sendEvent,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
  );
}
