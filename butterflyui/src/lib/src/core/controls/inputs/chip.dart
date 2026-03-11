import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/styling/theme_extension.dart';
import 'package:butterflyui_runtime/src/core/styling/type_roles.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class _ChipOption {
  const _ChipOption({
    required this.id,
    required this.label,
    required this.enabled,
    required this.color,
  });

  final String id;
  final String label;
  final bool enabled;
  final Color? color;
}

Widget buildChipControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ChipControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _ChipControl extends StatefulWidget {
  const _ChipControl({
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
  State<_ChipControl> createState() => _ChipControlState();
}

class _ChipControlState extends State<_ChipControl> {
  bool _selected = false;
  List<_ChipOption> _options = const <_ChipOption>[];
  final Set<String> _selectedValues = <String>{};

  bool get _isGroup => _options.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _ChipControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    if (!mapEquals(oldWidget.props, widget.props)) {
      _syncFromProps();
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
      case 'set_selected':
        setState(() => _selected = args['value'] == true);
        _emit('change', _singleStatePayload());
        return _singleStatePayload();
      case 'set_values':
        setState(() {
          _selectedValues
            ..clear()
            ..addAll(_coerceValueSet(args['values']));
        });
        _emit('change', _groupStatePayload());
        return _groupStatePayload();
      case 'get_values':
        return _groupStatePayload();
      case 'get_state':
        return _isGroup ? _groupStatePayload() : _singleStatePayload();
      case 'emit':
        final event = (args['event'] ?? 'change').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        _emit(event, payload);
        return null;
      default:
        throw UnsupportedError('Unknown chip method: $method');
    }
  }

  void _syncFromProps() {
    _selected = widget.props['selected'] == true;
    _options = _coerceOptions(widget.props['options'] ?? widget.props['items']);
    _selectedValues
      ..clear()
      ..addAll(_coerceSelected(widget.props));
  }

  Map<String, Object?> _singleStatePayload() {
    return <String, Object?>{
      'selected': _selected,
      'value': widget.props['value'],
      'label': widget.props['label']?.toString() ?? '',
    };
  }

  Map<String, Object?> _groupStatePayload() {
    final values = _selectedValues.toList(growable: false);
    return <String, Object?>{
      'values': values,
      'selected': values,
      'value': values.isEmpty ? null : values.first,
    };
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  bool _isMultiSelect() {
    if (widget.props['multi_select'] is bool) {
      return widget.props['multi_select'] == true;
    }
    if (widget.props['multiple'] is bool) {
      return widget.props['multiple'] == true;
    }
    return true;
  }

  Set<String> _coerceSelected(Map<String, Object?> props) {
    final out = <String>{};
    final values = props['values'] ?? props['selected'];
    if (values is List) {
      for (final value in values) {
        final text = value?.toString();
        if (text != null && text.isNotEmpty) out.add(text);
      }
    }
    final value = props['value']?.toString();
    if (value != null && value.isNotEmpty && out.isEmpty) {
      out.add(value);
    }
    if (!_isMultiSelect() && out.isNotEmpty) {
      return <String>{out.first};
    }
    return out;
  }

  Set<String> _coerceValueSet(Object? raw) {
    final out = <String>{};
    if (raw is List) {
      for (final item in raw) {
        final text = item?.toString();
        if (text != null && text.isNotEmpty) out.add(text);
      }
    }
    return out;
  }

  List<_ChipOption> _coerceOptions(Object? raw) {
    if (raw is! List) return const <_ChipOption>[];
    final out = <_ChipOption>[];
    for (var i = 0; i < raw.length; i += 1) {
      final item = raw[i];
      if (item is Map) {
        final map = coerceObjectMap(item);
        final id =
            (map['id'] ??
                    map['value'] ??
                    map['key'] ??
                    map['label'] ??
                    'chip_$i')
                .toString();
        final label = (map['label'] ?? map['title'] ?? map['text'] ?? id)
            .toString();
        out.add(
          _ChipOption(
            id: id,
            label: label,
            enabled: map['enabled'] == null ? true : (map['enabled'] == true),
            color: coerceColor(map['color'] ?? map['bgcolor']),
          ),
        );
      } else if (item != null) {
        final text = item.toString();
        if (text.isNotEmpty) {
          out.add(
            _ChipOption(id: text, label: text, enabled: true, color: null),
          );
        }
      }
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<ButterflyUIThemeTokens>();
    final slotStyles = widget.props['__slot_styles'] is Map
        ? coerceObjectMap(widget.props['__slot_styles'] as Map)
        : <String, Object?>{};
    final labelSlot = slotStyles['label'] is Map
        ? coerceObjectMap(slotStyles['label'] as Map)
        : <String, Object?>{};
    final backgroundSlot = slotStyles['background'] is Map
        ? coerceObjectMap(slotStyles['background'] as Map)
        : <String, Object?>{};
    final borderSlot = slotStyles['border'] is Map
        ? coerceObjectMap(slotStyles['border'] as Map)
        : <String, Object?>{};
    final contentSlot = slotStyles['content'] is Map
        ? coerceObjectMap(slotStyles['content'] as Map)
        : <String, Object?>{};
    final labelRole = resolveStylingTypeRole(
      tokens,
      widget.props['type_role'] ?? widget.props['text_role'],
      secondary: labelSlot['type_role'] ?? labelSlot['text_role'],
      fallback: 'caption',
    );
    final enabled =
        widget.props['enabled'] == null || widget.props['enabled'] == true;
    final dense = widget.props['dense'] == true;
    final spacing =
        coerceDouble(widget.props['spacing'] ?? contentSlot['spacing']) ??
        (dense ? 4.0 : 8.0);
    final runSpacing =
        coerceDouble(widget.props['run_spacing'] ?? contentSlot['run_spacing']) ??
        (dense ? 4.0 : 8.0);
    final baseForeground =
        coerceColor(
          widget.props['text_color'] ??
              widget.props['foreground'] ??
              labelSlot['text_color'] ??
              labelSlot['foreground'] ??
              labelSlot['color'],
        ) ??
        stylingTypeRoleColor(labelRole) ??
        tokens?.text ??
        theme.colorScheme.onSurface;
    final baseBackground =
        coerceColor(
          backgroundSlot['bgcolor'] ??
              backgroundSlot['background'] ??
              widget.props['bgcolor'] ??
              widget.props['background'] ??
              widget.props['color'],
        ) ??
        tokens?.surfaceAlt ??
        theme.colorScheme.surfaceContainerHighest;
    final selectedBackground =
        coerceColor(
          widget.props['selected_bgcolor'] ??
              widget.props['selected_background'] ??
              backgroundSlot['selected_bgcolor'] ??
              backgroundSlot['selected_background'],
        ) ??
        tokens?.primary.withValues(alpha: 0.16) ??
        theme.colorScheme.primaryContainer.withValues(alpha: 0.72);
    final selectedForeground =
        coerceColor(
          widget.props['selected_text_color'] ??
              widget.props['selected_foreground'] ??
              labelSlot['selected_text_color'] ??
              labelSlot['selected_foreground'],
        ) ??
        tokens?.primary ??
        theme.colorScheme.primary;
    final borderColor =
        coerceColor(
          widget.props['border_color'] ??
              borderSlot['border_color'] ??
              borderSlot['foreground'] ??
              borderSlot['color'],
        ) ??
        tokens?.border ??
        theme.colorScheme.outlineVariant;
    final borderWidth =
        coerceDouble(widget.props['border_width'] ?? borderSlot['border_width']) ??
        1.0;
    final radius =
        coerceDouble(
          widget.props['radius'] ??
              widget.props['border_radius'] ??
              borderSlot['radius'] ??
              borderSlot['border_radius'],
        ) ??
        tokens?.radiusLg ??
        999.0;
    final labelStyle = TextStyle(
      color: baseForeground,
      fontSize:
          coerceDouble(
            widget.props['font_size'] ??
                labelSlot['font_size'] ??
                stylingTypeRoleDouble(labelRole, 'font_size'),
          ) ??
          (dense ? 11 : 12),
      fontWeight: _coerceFontWeight(
            widget.props['font_weight'] ??
                labelSlot['font_weight'] ??
                stylingTypeRoleString(labelRole, 'font_weight'),
          ) ??
          FontWeight.w600,
    );
    final selectedLabelStyle = labelStyle.copyWith(color: selectedForeground);

    if (_isGroup) {
      final multiSelect = _isMultiSelect();
      return Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        children: _options
            .map((option) {
              final selected = _selectedValues.contains(option.id);
              final chipBackground = option.color?.withValues(alpha: 0.12) ?? baseBackground;
              final chipSelectedBackground =
                  option.color?.withValues(alpha: 0.24) ?? selectedBackground;
              final chipSelectedForeground = option.color ?? selectedForeground;
              return FilterChip(
                label: Text(option.label, style: selected ? selectedLabelStyle.copyWith(color: chipSelectedForeground) : labelStyle),
                selected: selected,
                selectedColor: chipSelectedBackground,
                checkmarkColor: chipSelectedForeground,
                backgroundColor: chipBackground,
                side: BorderSide(color: borderColor, width: borderWidth),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius),
                ),
                onSelected: option.enabled && enabled
                    ? (next) {
                        setState(() {
                          if (multiSelect) {
                            if (next) {
                              _selectedValues.add(option.id);
                            } else {
                              _selectedValues.remove(option.id);
                            }
                          } else {
                            _selectedValues
                              ..clear()
                              ..add(option.id);
                          }
                        });
                        final state = _groupStatePayload();
                        _emit('change', {
                          ...state,
                          'id': option.id,
                          'label': option.label,
                        });
                        _emit('select', {
                          ...state,
                          'id': option.id,
                          'label': option.label,
                        });
                      }
                    : null,
              );
            })
            .toList(growable: false),
      );
    }

    final dismissible = widget.props['dismissible'] == true;
    final label =
        (widget.props['label'] ??
                widget.props['text'] ??
                widget.props['value'] ??
                'chip')
            .toString();
    return FilterChip(
      label: Text(label, style: _selected ? selectedLabelStyle : labelStyle),
      selected: _selected,
      selectedColor: selectedBackground,
      backgroundColor: baseBackground,
      checkmarkColor: selectedForeground,
      side: BorderSide(color: borderColor, width: borderWidth),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      onSelected: enabled
          ? (next) {
              setState(() => _selected = next);
              final state = _singleStatePayload();
              _emit('change', state);
              _emit('select', state);
            }
          : null,
      onDeleted: dismissible
          ? () {
              _emit('dismiss', _singleStatePayload());
            }
          : null,
    );
  }
}

FontWeight? _coerceFontWeight(Object? value) {
  if (value == null) return null;
  final normalized = value.toString().trim().toLowerCase();
  switch (normalized) {
    case '100':
    case 'thin':
      return FontWeight.w100;
    case '200':
    case 'extra_light':
    case 'extralight':
      return FontWeight.w200;
    case '300':
    case 'light':
      return FontWeight.w300;
    case '400':
    case 'normal':
    case 'regular':
      return FontWeight.w400;
    case '500':
    case 'medium':
      return FontWeight.w500;
    case '600':
    case 'semi_bold':
    case 'semibold':
      return FontWeight.w600;
    case '700':
    case 'bold':
      return FontWeight.w700;
    case '800':
    case 'extra_bold':
    case 'extrabold':
      return FontWeight.w800;
    case '900':
    case 'black':
      return FontWeight.w900;
    default:
      return null;
  }
}
