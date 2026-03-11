import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/styling/theme_extension.dart';
import 'package:butterflyui_runtime/src/core/styling/type_roles.dart';
import 'package:butterflyui_runtime/src/core/control_shells/base_control_shell.dart';
import 'package:butterflyui_runtime/src/core/control_shells/form_field_control_shell.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class ButterflyUITextField extends StatefulWidget {
  final String controlId;
  final String value;
  final String? placeholder;
  final String? label;
  final String? helperText;
  final String? errorText;
  final bool multiline;
  final int? minLines;
  final int? maxLines;
  final bool password;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final bool dense;
  final bool emitOnChange;
  final int debounceMs;
  final Object? events;
  final Map<String, Object?> props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUITextField({
    super.key,
    required this.controlId,
    required this.value,
    required this.placeholder,
    required this.label,
    required this.helperText,
    required this.errorText,
    required this.multiline,
    required this.minLines,
    required this.maxLines,
    required this.password,
    required this.enabled,
    required this.readOnly,
    required this.autofocus,
    required this.dense,
    this.emitOnChange = true,
    this.debounceMs = 250,
    this.events,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<ButterflyUITextField> createState() => _ButterflyUITextFieldState();
}

class _ButterflyUITextFieldState extends State<ButterflyUITextField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.value,
  );
  late final FocusNode _focusNode = FocusNode(
    debugLabel: 'butterflyui:text_field:${widget.controlId}',
  );
  bool _suppressChange = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    registerInvokeHandlerIfNeeded(
      controlId: widget.controlId,
      registerInvokeHandler: widget.registerInvokeHandler,
      handler: _handleInvoke,
    );
  }

  @override
  void didUpdateWidget(covariant ButterflyUITextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    syncInvokeHandlerRegistration(
      previousControlId: oldWidget.controlId,
      currentControlId: widget.controlId,
      registerInvokeHandler: widget.registerInvokeHandler,
      unregisterInvokeHandler: widget.unregisterInvokeHandler,
      handler: _handleInvoke,
    );
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _suppressChange = true;
      _controller.value = _controller.value.copyWith(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
      _suppressChange = false;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    unregisterInvokeHandlerIfNeeded(
      controlId: widget.controlId,
      unregisterInvokeHandler: widget.unregisterInvokeHandler,
    );
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
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
          case 'get_value':
            return <String, Object?>{'value': _controller.text};
          case 'get_state':
            return <String, Object?>{
              'value': _controller.text,
              'focused': _focusNode.hasFocus,
            };
          case 'set_value':
            final nextValue = payload['value']?.toString() ?? '';
            _suppressChange = true;
            _controller.value = _controller.value.copyWith(
              text: nextValue,
              selection: TextSelection.collapsed(offset: nextValue.length),
            );
            _suppressChange = false;
            return <String, Object?>{'value': _controller.text};
          default:
            throw Exception('Unknown text_field method: $name');
        }
      },
    );
  }

  void _handleChange(String value) {
    if (_suppressChange) return;
    if (!widget.emitOnChange) return;
    _debounce?.cancel();
    final ms = widget.debounceMs;
    if (ms <= 0) {
      emitFormFieldValueEvents(
        controlId: widget.controlId,
        subscribedEventsSource: widget.events,
        payload: <String, Object?>{'value': value},
        sendEvent: widget.sendEvent,
      );
      return;
    }
    _debounce = Timer(Duration(milliseconds: ms), () {
      emitFormFieldValueEvents(
        controlId: widget.controlId,
        subscribedEventsSource: widget.events,
        payload: <String, Object?>{'value': value},
        sendEvent: widget.sendEvent,
      );
    });
  }

  void _handleSubmit(String value) {
    _debounce?.cancel();
    emitFormFieldValueEvents(
      controlId: widget.controlId,
      subscribedEventsSource: widget.events,
      payload: <String, Object?>{'value': value},
      sendEvent: widget.sendEvent,
      emitInput: false,
      emitSubmit: true,
    );
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
        const EdgeInsets.symmetric(horizontal: 14, vertical: 10);
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
    final cursorColor =
        coerceColor(widget.props['cursor_color']) ??
        tokens?.primary ??
        theme.colorScheme.primary;
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
    final keyboardType = widget.multiline
        ? TextInputType.multiline
        : TextInputType.text;
    final minLines = widget.multiline ? widget.minLines : 1;
    final maxLines = widget.multiline ? widget.maxLines : 1;
    final decoration = InputDecoration(
      hintText: widget.placeholder,
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
      labelText: widget.label,
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
      helperText: widget.helperText,
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
      errorText: widget.errorText,
      isDense: widget.dense,
      filled: false,
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
      contentPadding: EdgeInsets.zero,
    );

    Widget field = Focus(
      onFocusChange: (value) {
        emitSubscribedEvent(
          controlId: widget.controlId,
          subscribedEventsSource: widget.events,
          name: value ? 'focus' : 'blur',
          payload: <String, Object?>{
            'focused': value,
            'value': _controller.text,
          },
          sendEvent: widget.sendEvent,
        );
      },
      child: TextField(
        controller: _controller,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        autofocus: widget.autofocus,
        obscureText: widget.password,
        focusNode: _focusNode,
        keyboardType: keyboardType,
        minLines: minLines,
        maxLines: maxLines,
        onChanged: _handleChange,
        onSubmitted: _handleSubmit,
        cursorColor: cursorColor,
        style: textStyle,
        decoration: decoration,
        onTapOutside: (_) {
          emitSubscribedEvent(
            controlId: widget.controlId,
            subscribedEventsSource: widget.events,
            name: 'tap_outside',
            payload: <String, Object?>{'value': _controller.text},
            sendEvent: widget.sendEvent,
          );
        },
      ),
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
    'normal' || 'w400' => FontWeight.w400,
    'medium' || 'w500' => FontWeight.w500,
    'semibold' || 'semi_bold' || 'w600' => FontWeight.w600,
    'bold' || 'w700' => FontWeight.w700,
    'extra_bold' || 'extrabold' || 'w800' => FontWeight.w800,
    'black' || 'w900' => FontWeight.w900,
    _ => null,
  };
}

FontStyle? _parseFontStyle(Object? value) {
  final normalized = value?.toString().trim().toLowerCase();
  if (value == true || normalized == 'italic') return FontStyle.italic;
  if (value == false || normalized == 'normal') return FontStyle.normal;
  return null;
}
