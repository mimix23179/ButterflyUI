import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildColorPickerControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ColorPickerControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _ColorPickerControl extends StatefulWidget {
  const _ColorPickerControl({
    required this.controlId,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_ColorPickerControl> createState() => _ColorPickerControlState();
}

class _ColorPickerControlState extends State<_ColorPickerControl> {
  late Color _value;
  late TextEditingController _text;

  @override
  void initState() {
    super.initState();
    _value = _coerceColor(widget.props['value'] ?? widget.props['color']);
    _text = TextEditingController(text: _toHex(_value));
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant _ColorPickerControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
    if (oldWidget.props != widget.props) {
      final next = _coerceColor(widget.props['value'] ?? widget.props['color']);
      if (next != _value) {
        setState(() {
          _value = next;
          _text.text = _toHex(next);
        });
      }
    }
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    _text.dispose();
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'get_value':
        return _valuePayload(_value);
      case 'set_value':
        final next = _coerceColor(args['value'] ?? args['color']);
        setState(() {
          _value = next;
          _text.text = _toHex(next);
        });
        _emitChange();
        return _valuePayload(_value);
      default:
        throw UnsupportedError('Unknown color_picker method: $method');
    }
  }

  void _emitChange() {
    widget.sendEvent(widget.controlId, 'change', {
      'value': _toHex(_value),
      'color': _valuePayload(_value),
    });
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.props['enabled'] != false;
    final presets = _coerceColors(widget.props['presets']);
    final showInput = widget.props['show_input'] != false;
    final showPresets = widget.props['show_presets'] != false;
    final showAlpha = widget.props['show_alpha'] == true || widget.props['alpha'] == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _value,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
              ),
            ),
            const SizedBox(width: 8),
            if (showInput)
              Expanded(
                child: TextField(
                  controller: _text,
                  enabled: enabled,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    isDense: true,
                    labelText: widget.props['input_label']?.toString(),
                    hintText: widget.props['input_placeholder']?.toString(),
                  ),
                  onSubmitted: (value) {
                    final next = _coerceColor(value);
                    setState(() {
                      _value = next;
                      _text.text = _toHex(next);
                    });
                    _emitChange();
                  },
                ),
              ),
          ],
        ),
        if (showAlpha) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Alpha'),
              const SizedBox(width: 8),
              Expanded(
                child: Slider(
                  value: _value.opacity,
                  min: 0,
                  max: 1,
                  onChanged: !enabled
                      ? null
                      : (next) {
                          setState(() {
                            _value = _value.withOpacity(next);
                            _text.text = _toHex(_value);
                          });
                          _emitChange();
                        },
                ),
              ),
            ],
          ),
        ],
        if (showPresets && presets.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: coerceDouble(widget.props['preset_spacing']) ?? 6,
            runSpacing: coerceDouble(widget.props['preset_spacing']) ?? 6,
            children: [
              for (final color in presets)
                GestureDetector(
                  onTap: !enabled
                      ? null
                      : () {
                          setState(() {
                            _value = color;
                            _text.text = _toHex(color);
                          });
                          _emitChange();
                        },
                  child: Container(
                    width: coerceDouble(widget.props['preset_size']) ?? 20,
                    height: coerceDouble(widget.props['preset_size']) ?? 20,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

Widget buildColorSwatchGridControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ColorSwatchGridControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _ColorSwatchGridControl extends StatefulWidget {
  const _ColorSwatchGridControl({
    required this.controlId,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_ColorSwatchGridControl> createState() => _ColorSwatchGridControlState();
}

class _ColorSwatchGridControlState extends State<_ColorSwatchGridControl> {
  late List<Map<String, Object?>> _swatches;
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _swatches = _coerceSwatches(widget.props['swatches']);
    _selectedIndex = _resolveSelected(widget.props, _swatches);
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant _ColorSwatchGridControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
    if (oldWidget.props != widget.props) {
      setState(() {
        _swatches = _coerceSwatches(widget.props['swatches']);
        _selectedIndex = _resolveSelected(widget.props, _swatches);
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
      case 'get_state':
        return {'selected_index': _selectedIndex, 'swatches': _swatches};
      case 'set_selected':
        final selectedIndex = coerceOptionalInt(args['selected_index']);
        if (selectedIndex != null && selectedIndex >= 0 && selectedIndex < _swatches.length) {
          setState(() => _selectedIndex = selectedIndex);
          final selected = _swatches[selectedIndex];
          widget.sendEvent(widget.controlId, 'select', {
            'index': selectedIndex,
            'id': selected['id']?.toString() ?? '',
            'value': _toHex(_coerceColor(selected['color'] ?? selected['value'])),
          });
        }
        return _selectedIndex;
      default:
        throw UnsupportedError('Unknown color_swatch_grid method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final columns = (coerceOptionalInt(widget.props['columns']) ?? 6).clamp(1, 20);
    final spacing = coerceDouble(widget.props['spacing']) ?? 6;
    final size = coerceDouble(widget.props['size']) ?? 24;
    final showLabels = widget.props['show_labels'] == true;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        mainAxisExtent: size,
      ),
      itemCount: _swatches.length,
      itemBuilder: (context, index) {
        final swatch = _swatches[index];
        final selected = index == _selectedIndex;
        final color = _coerceColor(swatch['color'] ?? swatch['value']);
        final label = swatch['label']?.toString() ?? '';
        return GestureDetector(
          onTap: () {
            setState(() => _selectedIndex = index);
            widget.sendEvent(widget.controlId, 'select', {
              'index': index,
              'id': swatch['id']?.toString() ?? '',
              'value': _toHex(color),
            });
          },
          child: Column(
            children: [
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outlineVariant,
                      width: selected ? 2 : 1,
                    ),
                  ),
                ),
              ),
              if (showLabels && label.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

Widget buildContainerStyleControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler? registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler? unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent? sendEvent,
) {
  return _ContainerStyleControl(
    controlId: controlId,
    initialProps: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

Widget buildGradientControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  {String controlId = '',
  ButterflyUIRegisterInvokeHandler? registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler? unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent? sendEvent,}
) {
  return _GradientControl(
    controlId: controlId,
    initialProps: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _ContainerStyleControl extends StatefulWidget {
  const _ContainerStyleControl({
    required this.controlId,
    required this.initialProps,
    required this.rawChildren,
    required this.buildChild,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> initialProps;
  final List<dynamic> rawChildren;
  final Widget Function(Map<String, Object?> child) buildChild;
  final ButterflyUIRegisterInvokeHandler? registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler? unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent? sendEvent;

  @override
  State<_ContainerStyleControl> createState() => _ContainerStyleControlState();
}

class _ContainerStyleControlState extends State<_ContainerStyleControl> {
  late Map<String, Object?> _props;

  @override
  void initState() {
    super.initState();
    _props = Map<String, Object?>.from(widget.initialProps);
    if (widget.controlId.isNotEmpty &&
        widget.registerInvokeHandler != null) {
      widget.registerInvokeHandler!(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _ContainerStyleControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialProps != widget.initialProps) {
      _props = Map<String, Object?>.from(widget.initialProps);
    }
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty &&
          oldWidget.unregisterInvokeHandler != null) {
        oldWidget.unregisterInvokeHandler!(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty && widget.registerInvokeHandler != null) {
        widget.registerInvokeHandler!(widget.controlId, _handleInvoke);
      }
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty && widget.unregisterInvokeHandler != null) {
      widget.unregisterInvokeHandler!(widget.controlId);
    }
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_style':
        setState(() {
          _props.addAll(args);
        });
        widget.sendEvent?.call(widget.controlId, 'change', {'props': _props});
        return true;
      case 'get_state':
        return {'props': _props};
      default:
        throw UnsupportedError('Unknown container_style method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child = const SizedBox.shrink();
    for (final raw in widget.rawChildren) {
      if (raw is Map) {
        child = widget.buildChild(coerceObjectMap(raw));
        break;
      }
    }
    final padding =
        coercePadding(_props['content_padding'] ?? _props['padding']) ??
        const EdgeInsets.all(8);
    final bg = coerceColor(
      _props['bgcolor'] ?? _props['background'] ?? _props['bg_color'],
    );
    final gradient = coerceGradient(_props['gradient']);
    final borderColor = coerceColor(_props['border_color']);
    final borderWidth = coerceDouble(_props['border_width']) ?? 1;
    final radius = coerceDouble(_props['radius']) ?? 8;
    final shadowColor = coerceColor(_props['shadow_color']);
    final shadowBlur = coerceDouble(_props['shadow_blur']) ?? 0;
    final shadowDx = coerceDouble(_props['shadow_dx']) ?? 0;
    final shadowDy = coerceDouble(_props['shadow_dy']) ?? 0;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        gradient: gradient,
        border: borderColor == null
            ? null
            : Border.all(color: borderColor, width: borderWidth),
        borderRadius: BorderRadius.circular(radius),
        boxShadow: shadowColor == null || shadowBlur <= 0
            ? null
            : [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: shadowBlur,
                  offset: Offset(shadowDx, shadowDy),
                ),
              ],
      ),
      child: child,
    );
  }
}

class _GradientControl extends StatefulWidget {
  const _GradientControl({
    required this.controlId,
    required this.initialProps,
    required this.rawChildren,
    required this.buildChild,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> initialProps;
  final List<dynamic> rawChildren;
  final Widget Function(Map<String, Object?> child) buildChild;
  final ButterflyUIRegisterInvokeHandler? registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler? unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent? sendEvent;

  @override
  State<_GradientControl> createState() => _GradientControlState();
}

class _GradientControlState extends State<_GradientControl> {
  late Map<String, Object?> _props;

  @override
  void initState() {
    super.initState();
    _props = Map<String, Object?>.from(widget.initialProps);
    if (widget.controlId.isNotEmpty && widget.registerInvokeHandler != null) {
      widget.registerInvokeHandler!(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _GradientControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialProps != widget.initialProps) {
      _props = Map<String, Object?>.from(widget.initialProps);
    }
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty &&
          oldWidget.unregisterInvokeHandler != null) {
        oldWidget.unregisterInvokeHandler!(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty && widget.registerInvokeHandler != null) {
        widget.registerInvokeHandler!(widget.controlId, _handleInvoke);
      }
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty && widget.unregisterInvokeHandler != null) {
      widget.unregisterInvokeHandler!(widget.controlId);
    }
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_colors':
        setState(() {
          _props['colors'] = args['colors'];
        });
        widget.sendEvent?.call(widget.controlId, 'change', {'colors': _props['colors']});
        return true;
      case 'set_style':
        setState(() {
          _props.addAll(args);
        });
        widget.sendEvent?.call(widget.controlId, 'change', {'props': _props});
        return true;
      case 'get_state':
        return {'props': _props};
      default:
        throw UnsupportedError('Unknown gradient method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child = const SizedBox.shrink();
    for (final raw in widget.rawChildren) {
      if (raw is Map) {
        child = widget.buildChild(coerceObjectMap(raw));
        break;
      }
    }
    final gradient = coerceGradient(_props['gradient'] ?? _props);
    final opacity = (coerceDouble(_props['opacity']) ?? 1).clamp(0, 1).toDouble();
    return Container(
      decoration: BoxDecoration(gradient: gradient),
      child: Opacity(opacity: opacity, child: child),
    );
  }
}

Widget buildGradientEditorControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _GradientEditorControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _GradientEditorControl extends StatefulWidget {
  const _GradientEditorControl({
    required this.controlId,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_GradientEditorControl> createState() => _GradientEditorControlState();
}

class _GradientEditorControlState extends State<_GradientEditorControl> {
  late List<Map<String, Object?>> _stops;
  late double _angle;

  @override
  void initState() {
    super.initState();
    _stops = _coerceStops(widget.props['stops']);
    _angle = coerceDouble(widget.props['angle']) ?? 0;
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant _GradientEditorControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
    if (oldWidget.props != widget.props) {
      setState(() {
        _stops = _coerceStops(widget.props['stops']);
        _angle = coerceDouble(widget.props['angle']) ?? 0;
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
      case 'get_state':
        return {'stops': _stops, 'angle': _angle};
      case 'set_stops':
        setState(() {
          _stops = _coerceStops(args['stops']);
        });
        return _stops;
      case 'set_angle':
        final next = coerceDouble(args['angle']);
        if (next != null) {
          setState(() => _angle = next);
        }
        return _angle;
      case 'add_stop':
        final position = (coerceDouble(args['position']) ?? 0).clamp(0, 1).toDouble();
        final color = args['color'];
        setState(() {
          _stops = [
            ..._stops,
            {'position': position, 'color': color},
          ]..sort((a, b) => ((coerceDouble(a['position']) ?? 0).compareTo(coerceDouble(b['position']) ?? 0)));
        });
        widget.sendEvent(widget.controlId, 'stops_change', {'stops': _stops});
        return _stops;
      case 'remove_stop':
        final index = coerceOptionalInt(args['index']);
        if (index != null && index >= 0 && index < _stops.length) {
          setState(() {
            _stops = [..._stops]..removeAt(index);
          });
          widget.sendEvent(widget.controlId, 'stops_change', {'stops': _stops});
        }
        return _stops;
      default:
        throw UnsupportedError('Unknown gradient_editor method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.props['show_angle'] != false)
          Slider(
            value: _angle.clamp(0, 360),
            min: 0,
            max: 360,
            onChanged: (next) {
              setState(() => _angle = next);
              widget.sendEvent(widget.controlId, 'angle_change', {'angle': _angle});
            },
          ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var i = 0; i < _stops.length; i++)
              GestureDetector(
                onTap: widget.props['show_remove'] != false
                    ? () {
                        setState(() {
                          _stops = [..._stops]..removeAt(i);
                        });
                        widget.sendEvent(widget.controlId, 'stops_change', {'stops': _stops});
                      }
                    : null,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _coerceColor(_stops[i]['color']),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                  ),
                ),
              ),
          ],
        ),
        if (widget.props['show_add'] != false)
          TextButton.icon(
            onPressed: () {
              setState(() {
                _stops = [
                  ..._stops,
                  {'position': 1.0, 'color': '#FFFFFF'},
                ];
              });
              widget.sendEvent(widget.controlId, 'stops_change', {'stops': _stops});
            },
            icon: const Icon(Icons.add),
            label: const Text('Add stop'),
          ),
      ],
    );
  }
}

Color _coerceColor(Object? value) => coerceColor(value) ?? const Color(0xFFFFFFFF);

String _toHex(Color color) {
  final value = color.toARGB32();
  return '#${value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
}

Map<String, Object?> _valuePayload(Color color) {
  return {
    'hex': _toHex(color),
    'argb': color.toARGB32(),
    'alpha': color.alpha / 255.0,
    'r': color.red,
    'g': color.green,
    'b': color.blue,
  };
}

List<Color> _coerceColors(Object? value) {
  if (value is! List) return const <Color>[];
  return value.map(_coerceColor).toList(growable: false);
}

List<Map<String, Object?>> _coerceSwatches(Object? value) {
  if (value is! List) return const <Map<String, Object?>>[];
  return value.whereType<Map>().map(coerceObjectMap).toList(growable: false);
}

int _resolveSelected(Map<String, Object?> props, List<Map<String, Object?>> swatches) {
  final selectedIndex = coerceOptionalInt(props['selected_index']);
  if (selectedIndex != null && selectedIndex >= 0 && selectedIndex < swatches.length) {
    return selectedIndex;
  }
  final selectedId = props['selected_id']?.toString();
  if (selectedId != null && selectedId.isNotEmpty) {
    for (var i = 0; i < swatches.length; i++) {
      if (swatches[i]['id']?.toString() == selectedId) return i;
    }
  }
  return swatches.isEmpty ? -1 : 0;
}

List<Map<String, Object?>> _coerceStops(Object? value) {
  if (value is! List) return const <Map<String, Object?>>[];
  return value.whereType<Map>().map(coerceObjectMap).toList(growable: false);
}
