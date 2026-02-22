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
        return _toHex(_value);
      case 'set_value':
        final next = _coerceColor(args['value'] ?? args['color']);
        setState(() {
          _value = next;
          _text.text = _toHex(next);
        });
        widget.sendEvent(widget.controlId, 'change', {'value': _toHex(_value)});
        return _toHex(_value);
      default:
        throw UnsupportedError('Unknown color_picker method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.props['enabled'] != false;
    final presets = _coerceColors(widget.props['presets']);

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
            Expanded(
              child: TextField(
                controller: _text,
                enabled: enabled,
                decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
                onSubmitted: (value) {
                  final next = _coerceColor(value);
                  setState(() {
                    _value = next;
                    _text.text = _toHex(next);
                  });
                  widget.sendEvent(widget.controlId, 'change', {'value': _toHex(_value)});
                },
              ),
            ),
          ],
        ),
        if (presets.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
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
                          widget.sendEvent(widget.controlId, 'change', {'value': _toHex(_value)});
                        },
                  child: Container(
                    width: 20,
                    height: 20,
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
        return GestureDetector(
          onTap: () {
            setState(() => _selectedIndex = index);
            widget.sendEvent(widget.controlId, 'select', {
              'index': index,
              'id': swatch['id']?.toString() ?? '',
              'value': _toHex(color),
            });
          },
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
        );
      },
    );
  }
}

Widget buildContainerStyleControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
) {
  Widget child = const SizedBox.shrink();
  for (final raw in rawChildren) {
    if (raw is Map) {
      child = buildChild(coerceObjectMap(raw));
      break;
    }
  }
  final padding = coercePadding(props['content_padding'] ?? props['padding']) ?? const EdgeInsets.all(8);
  final bg = coerceColor(props['bgcolor'] ?? props['background']);
  final borderColor = coerceColor(props['border_color']);
  final borderWidth = coerceDouble(props['border_width']) ?? 1;
  final radius = coerceDouble(props['radius']) ?? 8;
  return Container(
    padding: padding,
    decoration: BoxDecoration(
      color: bg,
      border: borderColor == null ? null : Border.all(color: borderColor, width: borderWidth),
      borderRadius: BorderRadius.circular(radius),
    ),
    child: child,
  );
}

Widget buildGradientControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
) {
  Widget child = const SizedBox.shrink();
  for (final raw in rawChildren) {
    if (raw is Map) {
      child = buildChild(coerceObjectMap(raw));
      break;
    }
  }
  final gradient = coerceGradient(props);
  return Container(
    decoration: BoxDecoration(gradient: gradient),
    child: child,
  );
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
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _coerceColor(_stops[i]['color']),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                ),
              ),
          ],
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
