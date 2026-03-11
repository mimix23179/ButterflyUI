import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/animation/animation_spec.dart';
import 'package:butterflyui_runtime/src/core/styling/theme_extension.dart';
import 'package:butterflyui_runtime/src/core/styling/type_roles.dart';
import 'package:butterflyui_runtime/src/core/control_shells/base_control_shell.dart';
import 'package:butterflyui_runtime/src/core/control_shells/form_field_control_shell.dart';
import 'package:butterflyui_runtime/src/core/controls/common/option_types.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class ButterflyUISelect extends StatefulWidget {
  final String controlId;
  final List<ButterflyUIOption> options;
  final int index;
  final Object? explicitValue;
  final bool enabled;
  final bool dense;
  final String? label;
  final String? hint;
  final bool autofocus;
  final Object? events;
  final Map<String, Object?> props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUISelect({
    super.key,
    required this.controlId,
    required this.options,
    required this.index,
    required this.explicitValue,
    required this.enabled,
    required this.dense,
    required this.label,
    required this.hint,
    this.autofocus = false,
    this.events,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<ButterflyUISelect> createState() => _ButterflyUISelectState();
}

class _ButterflyUISelectState extends State<ButterflyUISelect> {
  late final FocusNode _focusNode = FocusNode(
    debugLabel: 'butterflyui:select:${widget.controlId}',
  );
  String? _valueKey;

  @override
  void initState() {
    super.initState();
    _valueKey = _resolveValue();
    registerInvokeHandlerIfNeeded(
      controlId: widget.controlId,
      registerInvokeHandler: widget.registerInvokeHandler,
      handler: _handleInvoke,
    );
  }

  @override
  void didUpdateWidget(covariant ButterflyUISelect oldWidget) {
    super.didUpdateWidget(oldWidget);
    syncInvokeHandlerRegistration(
      previousControlId: oldWidget.controlId,
      currentControlId: widget.controlId,
      registerInvokeHandler: widget.registerInvokeHandler,
      unregisterInvokeHandler: widget.unregisterInvokeHandler,
      handler: _handleInvoke,
    );
    final next = _resolveValue(current: _valueKey);
    if (next != _valueKey) {
      setState(() {
        _valueKey = next;
      });
    }
  }

  @override
  void dispose() {
    unregisterInvokeHandlerIfNeeded(
      controlId: widget.controlId,
      unregisterInvokeHandler: widget.unregisterInvokeHandler,
    );
    _focusNode.dispose();
    super.dispose();
  }

  String? _resolveValue({String? current}) {
    final options = widget.options;
    final explicitValue = widget.explicitValue?.toString();
    if (explicitValue != null &&
        options.any((option) => option.key == explicitValue)) {
      return explicitValue;
    }
    if (current != null && options.any((option) => option.key == current)) {
      return current;
    }
    if (options.isEmpty) return null;
    if (widget.index >= 0 && widget.index < options.length) {
      return options[widget.index].key;
    }
    return options.first.key;
  }

  Map<String, Object?> _selectionPayload(String next) {
    final idx = widget.options.indexWhere((option) => option.key == next);
    if (idx < 0) {
      return <String, Object?>{'value_key': next};
    }
    final option = widget.options[idx];
    return <String, Object?>{
      'value': option.value ?? option.label,
      'value_key': option.key,
      'label': option.label,
      'index': idx,
    };
  }

  void _emitSelection(String next) {
    emitFormFieldValueEvents(
      controlId: widget.controlId,
      subscribedEventsSource: widget.events,
      payload: _selectionPayload(next),
      sendEvent: widget.sendEvent,
    );
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    return handleFormFieldInvoke(
      context: context,
      focusNode: _focusNode,
      method: method,
      args: args,
      onUnhandled: (name, payload) async {
        switch (name) {
          case 'set_value':
            final next =
                payload['value_key']?.toString() ??
                payload['value']?.toString();
            if (next != null &&
                widget.options.any((option) => option.key == next)) {
              setState(() {
                _valueKey = next;
              });
            }
            return _valueKey == null ? null : _selectionPayload(_valueKey!);
          case 'select_next':
          case 'select_previous':
            final keys = widget.options
                .where((option) => option.enabled)
                .map((option) => option.key)
                .toList();
            final delta = name == 'select_next' ? 1 : -1;
            final next = stepSelectionKey(keys, _valueKey, delta);
            if (next != null) {
              setState(() {
                _valueKey = next;
              });
            }
            return _valueKey == null ? null : _selectionPayload(_valueKey!);
          case 'get_value':
          case 'get_state':
            return _valueKey == null ? null : _selectionPayload(_valueKey!);
          default:
            throw UnsupportedError('Unknown select method: $name');
        }
      },
    );
  }

  void _handleChanged(String? next) {
    if (next == null) return;
    if (next == _valueKey) return;
    setState(() {
      _valueKey = next;
    });
    _emitSelection(next);
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
    final placeholderSlot = slotStyles['placeholder'] is Map
        ? coerceObjectMap(slotStyles['placeholder'] as Map)
        : <String, Object?>{};
    final helperSlot = slotStyles['helper'] is Map
        ? coerceObjectMap(slotStyles['helper'] as Map)
        : <String, Object?>{};
    final fieldSlot = slotStyles['field'] is Map
        ? coerceObjectMap(slotStyles['field'] as Map)
        : <String, Object?>{};
    final contentSlot = slotStyles['content'] is Map
        ? coerceObjectMap(slotStyles['content'] as Map)
        : <String, Object?>{};
    final borderSlot = slotStyles['border'] is Map
        ? coerceObjectMap(slotStyles['border'] as Map)
        : <String, Object?>{};
    final backgroundSlot = slotStyles['background'] is Map
        ? coerceObjectMap(slotStyles['background'] as Map)
        : <String, Object?>{};
    final fieldRole = resolveStylingTypeRole(
      tokens,
      widget.props['type_role'] ?? widget.props['text_role'],
      secondary: fieldSlot['type_role'] ?? fieldSlot['text_role'],
      fallback: 'input',
    );
    final labelRole = resolveStylingTypeRole(
      tokens,
      widget.props['label_type_role'] ?? labelSlot['type_role'],
      secondary: labelSlot['text_role'],
      fallback: 'caption',
    );
    final helperRole = resolveStylingTypeRole(
      tokens,
      widget.props['helper_type_role'] ?? helperSlot['type_role'],
      secondary: helperSlot['text_role'],
      fallback: 'helper',
    );
    final placeholderRole = resolveStylingTypeRole(
      tokens,
      widget.props['placeholder_type_role'] ?? placeholderSlot['type_role'],
      secondary: placeholderSlot['text_role'],
      fallback: 'helper',
    );
    final sceneAwareSurface =
        (widget.props['background_layers'] != null ||
            widget.props['background_layer'] != null ||
            widget.props['surface_layers'] != null ||
            widget.props['surface'] != null) &&
        coerceShellBool(widget.props['preserve_scene_fill'], fallback: false) ==
            false;
    final backgroundColor = _sceneAwareColor(
      coerceColor(
            backgroundSlot['bgcolor'] ??
                backgroundSlot['background'] ??
                fieldSlot['bgcolor'] ??
                fieldSlot['background'] ??
                widget.props['bgcolor'] ??
                widget.props['background'] ??
                widget.props['color'],
          ) ??
          (tokens == null
              ? theme.colorScheme.surface.withValues(alpha: 0.22)
              : tokens.surface.withValues(alpha: 0.22)),
      enabled: sceneAwareSurface,
    );
    final borderColor =
        coerceColor(
          borderSlot['border_color'] ??
              borderSlot['foreground'] ??
              borderSlot['color'] ??
              widget.props['border_color'],
        ) ??
        tokens?.border ??
        theme.colorScheme.outlineVariant;
    final borderWidth =
        coerceDouble(widget.props['border_width'] ?? borderSlot['border_width']) ??
        tokens?.borderWidthMd ??
        1.0;
    final radius =
        coerceDouble(
              widget.props['radius'] ??
                  widget.props['border_radius'] ??
                  borderSlot['radius'] ??
                  borderSlot['border_radius'],
            ) ??
        tokens?.radiusMd ??
        16.0;
    final shadow = coerceBoxShadow(
      widget.props['shadow'] ?? fieldSlot['shadow'] ?? backgroundSlot['shadow'],
    );
    final blur = (coerceDouble(
          widget.props['backdrop_blur'] ??
              widget.props['blur'] ??
              backgroundSlot['blur'],
        ) ??
        0.0)
        .clamp(0.0, 24.0);
    final padding =
        coercePadding(
          widget.props['content_padding'] ??
              contentSlot['padding'] ??
              contentSlot['content_padding'] ??
              fieldSlot['padding'],
        ) ??
        const EdgeInsets.symmetric(horizontal: 14, vertical: 6);
    final textColor =
        coerceColor(
          widget.props['text_color'] ??
              widget.props['foreground'] ??
              fieldSlot['text_color'] ??
              fieldSlot['foreground'] ??
              fieldSlot['color'],
        ) ??
        stylingTypeRoleColor(fieldRole) ??
        tokens?.text ??
        theme.colorScheme.onSurface;
    final labelColor =
        coerceColor(
          widget.props['label_color'] ??
              labelSlot['text_color'] ??
              labelSlot['foreground'] ??
              labelSlot['color'],
        ) ??
        stylingTypeRoleColor(labelRole) ??
        tokens?.mutedText ??
        theme.colorScheme.onSurfaceVariant;
    final helperColor =
        coerceColor(
          widget.props['helper_color'] ??
              helperSlot['text_color'] ??
              helperSlot['foreground'] ??
              helperSlot['color'],
        ) ??
        stylingTypeRoleColor(helperRole) ??
        tokens?.mutedText ??
        theme.colorScheme.onSurfaceVariant;
    final hintColor =
        coerceColor(
          widget.props['placeholder_color'] ??
              placeholderSlot['text_color'] ??
              placeholderSlot['foreground'] ??
              placeholderSlot['color'],
        ) ??
        stylingTypeRoleColor(placeholderRole) ??
        tokens?.mutedText.withValues(alpha: 0.8) ??
        theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8);
    final iconColor =
        coerceColor(
          widget.props['icon_color'] ??
              contentSlot['icon_color'] ??
              contentSlot['foreground'],
        ) ??
        hintColor;
    final fieldGradient = _sceneAwareGradient(
      coerceGradient(
        widget.props['gradient'] ??
            fieldSlot['gradient'] ??
            backgroundSlot['gradient'],
      ),
      enabled: sceneAwareSurface,
    );
    final textStyle = TextStyle(
      color: textColor,
      fontSize: coerceDouble(
        widget.props['font_size'] ??
            fieldSlot['font_size'] ??
            fieldSlot['size'] ??
            stylingTypeRoleDouble(fieldRole, 'font_size'),
      ),
      fontWeight: _parseFontWeight(
        widget.props['font_weight'] ??
            widget.props['weight'] ??
            fieldSlot['font_weight'] ??
            fieldSlot['weight'] ??
            stylingTypeRoleString(fieldRole, 'font_weight'),
      ),
      fontFamily:
          widget.props['font_family']?.toString() ??
          fieldSlot['font_family']?.toString() ??
          stylingTypeRoleString(fieldRole, 'font_family'),
      letterSpacing: coerceDouble(
        widget.props['letter_spacing'] ??
            fieldSlot['letter_spacing'] ??
            stylingTypeRoleDouble(fieldRole, 'letter_spacing'),
      ),
      fontStyle: _parseFontStyle(
        widget.props['font_style'] ??
            widget.props['italic'] ??
            fieldSlot['font_style'] ??
            fieldSlot['italic'] ??
            stylingTypeRoleString(fieldRole, 'font_style'),
      ),
      height: coerceDouble(
        widget.props['line_height'] ??
            fieldSlot['line_height'] ??
            stylingTypeRoleDouble(fieldRole, 'line_height'),
      ),
    );
    final dropdown = DropdownButtonFormField<String>(
      value: _valueKey,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        helperText: widget.props['helper_text']?.toString(),
        isDense: widget.dense,
        hintStyle: TextStyle(
          color: hintColor,
          fontSize: coerceDouble(
            placeholderSlot['font_size'] ??
                placeholderSlot['size'] ??
                stylingTypeRoleDouble(placeholderRole, 'font_size'),
          ),
          fontWeight: _parseFontWeight(
            placeholderSlot['font_weight'] ??
                placeholderSlot['weight'] ??
                stylingTypeRoleString(placeholderRole, 'font_weight'),
          ),
          fontFamily:
              placeholderSlot['font_family']?.toString() ??
              stylingTypeRoleString(placeholderRole, 'font_family'),
          letterSpacing: coerceDouble(
            placeholderSlot['letter_spacing'] ??
                stylingTypeRoleDouble(placeholderRole, 'letter_spacing'),
          ),
          fontStyle: _parseFontStyle(
            placeholderSlot['font_style'] ??
                placeholderSlot['italic'] ??
                stylingTypeRoleString(placeholderRole, 'font_style'),
          ),
        ),
        labelStyle: TextStyle(
          color: labelColor,
          fontSize: coerceDouble(
            labelSlot['font_size'] ??
                labelSlot['size'] ??
                stylingTypeRoleDouble(labelRole, 'font_size'),
          ),
          fontWeight: _parseFontWeight(
            labelSlot['font_weight'] ??
                labelSlot['weight'] ??
                stylingTypeRoleString(labelRole, 'font_weight'),
          ),
          fontFamily:
              labelSlot['font_family']?.toString() ??
              stylingTypeRoleString(labelRole, 'font_family'),
          letterSpacing: coerceDouble(
            labelSlot['letter_spacing'] ??
                stylingTypeRoleDouble(labelRole, 'letter_spacing'),
          ),
          fontStyle: _parseFontStyle(
            labelSlot['font_style'] ??
                labelSlot['italic'] ??
                stylingTypeRoleString(labelRole, 'font_style'),
          ),
        ),
        helperStyle: TextStyle(
          color: helperColor,
          fontSize: coerceDouble(
            helperSlot['font_size'] ??
                helperSlot['size'] ??
                stylingTypeRoleDouble(helperRole, 'font_size'),
          ),
          fontWeight: _parseFontWeight(
            helperSlot['font_weight'] ??
                helperSlot['weight'] ??
                stylingTypeRoleString(helperRole, 'font_weight'),
          ),
          fontFamily:
              helperSlot['font_family']?.toString() ??
              stylingTypeRoleString(helperRole, 'font_family'),
          letterSpacing: coerceDouble(
            helperSlot['letter_spacing'] ??
                stylingTypeRoleDouble(helperRole, 'letter_spacing'),
          ),
          fontStyle: _parseFontStyle(
            helperSlot['font_style'] ??
                helperSlot['italic'] ??
                stylingTypeRoleString(helperRole, 'font_style'),
          ),
        ),
        filled: false,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
      iconEnabledColor: iconColor,
      iconDisabledColor: iconColor.withValues(alpha: 0.42),
      dropdownColor: fieldGradient == null
          ? backgroundColor
          : (tokens?.surfaceAlt ?? theme.colorScheme.surfaceContainerHighest),
      style: textStyle,
      items: widget.options
          .map(
            (option) => DropdownMenuItem<String>(
              value: option.key,
              enabled: option.enabled,
              child: option.animation != null
                  ? AnimationSpec.fromJson(
                      option.animation,
                    ).wrap(
                      Text(
                        option.label,
                        style: option.enabled
                            ? textStyle
                            : textStyle.copyWith(
                                color: textColor.withValues(alpha: 0.42),
                              ),
                      ),
                    )
                  : Text(
                      option.label,
                      style: option.enabled
                          ? textStyle
                          : textStyle.copyWith(
                              color: textColor.withValues(alpha: 0.42),
                            ),
                    ),
            ),
          )
          .toList(),
      onChanged: widget.enabled ? _handleChanged : null,
    );
    Widget field = wrapFocusableFormField(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      onFocusChange: (value) {
        emitSubscribedEvent(
          controlId: widget.controlId,
          subscribedEventsSource: widget.events,
          name: value ? 'focus' : 'blur',
          payload: <String, Object?>{'focused': value},
          sendEvent: widget.sendEvent,
        );
      },
      child: dropdown,
    );
    field = DecoratedBox(
      decoration: BoxDecoration(
        color: fieldGradient == null ? backgroundColor : null,
        gradient: fieldGradient,
        border: Border.all(color: borderColor, width: borderWidth),
        borderRadius: BorderRadius.circular(radius),
        boxShadow: shadow,
      ),
      child: Padding(padding: padding, child: field),
    );
    if (blur > 0) {
      field = ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: field,
        ),
      );
    } else {
      field = ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: field,
      );
    }
    return field;
  }
}

Color _sceneAwareColor(Color color, {required bool enabled}) {
  if (!enabled) return color;
  return color.withValues(alpha: color.a.clamp(0.0, 0.38));
}

Gradient? _sceneAwareGradient(Gradient? gradient, {required bool enabled}) {
  if (!enabled || gradient == null) return gradient;
  List<Color> toneDown(List<Color> colors) => colors
      .map((color) => color.withValues(alpha: color.a.clamp(0.0, 0.26)))
      .toList(growable: false);
  if (gradient is LinearGradient) {
    return LinearGradient(
      begin: gradient.begin,
      end: gradient.end,
      colors: toneDown(gradient.colors),
      stops: gradient.stops,
      tileMode: gradient.tileMode,
      transform: gradient.transform,
    );
  }
  if (gradient is RadialGradient) {
    return RadialGradient(
      center: gradient.center,
      radius: gradient.radius,
      colors: toneDown(gradient.colors),
      stops: gradient.stops,
      tileMode: gradient.tileMode,
      focal: gradient.focal,
      focalRadius: gradient.focalRadius,
      transform: gradient.transform,
    );
  }
  if (gradient is SweepGradient) {
    return SweepGradient(
      center: gradient.center,
      startAngle: gradient.startAngle,
      endAngle: gradient.endAngle,
      colors: toneDown(gradient.colors),
      stops: gradient.stops,
      tileMode: gradient.tileMode,
      transform: gradient.transform,
    );
  }
  return gradient;
}

FontWeight? _parseFontWeight(Object? value) {
  if (value == null) return null;
  final normalized = value.toString().trim().toLowerCase();
  final numeric = int.tryParse(normalized);
  if (numeric != null) {
    return switch (numeric) {
      100 => FontWeight.w100,
      200 => FontWeight.w200,
      300 => FontWeight.w300,
      400 => FontWeight.w400,
      500 => FontWeight.w500,
      600 => FontWeight.w600,
      700 => FontWeight.w700,
      800 => FontWeight.w800,
      900 => FontWeight.w900,
      _ => null,
    };
  }
  return switch (normalized) {
    'thin' || 'w100' => FontWeight.w100,
    'extra_light' || 'extralight' || 'w200' => FontWeight.w200,
    'light' || 'w300' => FontWeight.w300,
    'normal' || 'regular' || 'w400' => FontWeight.w400,
    'medium' || 'w500' => FontWeight.w500,
    'semi_bold' || 'semibold' || 'w600' => FontWeight.w600,
    'bold' || 'w700' => FontWeight.w700,
    'extra_bold' || 'extrabold' || 'w800' => FontWeight.w800,
    'black' || 'w900' => FontWeight.w900,
    _ => null,
  };
}

FontStyle? _parseFontStyle(Object? value) {
  if (value == null) return null;
  if (value is bool) {
    return value ? FontStyle.italic : FontStyle.normal;
  }
  final normalized = value.toString().trim().toLowerCase();
  return switch (normalized) {
    'italic' || 'true' => FontStyle.italic,
    'normal' || 'false' => FontStyle.normal,
    _ => null,
  };
}
