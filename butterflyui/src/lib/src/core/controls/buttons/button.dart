import 'dart:async';

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/candy/theme.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/window/window_api.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildButtonControl(
  String? controlId,
  Map<String, Object?> props,
  CandyTokens tokens,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final label = (props['text'] ?? props['label'])?.toString() ?? 'Button';
  final enabled = props['enabled'] == null ? true : (props['enabled'] == true);
  final events = props['events'];
  final rawVariant =
      (props['variant']?.toString() ??
              tokens.string('button', 'variant') ??
              'elevated')
          .toLowerCase();
  final variant = rawVariant == 'filled' ? 'elevated' : rawVariant;
  final candyPrimary = tokens.color('primary');
  final candyOnPrimary = tokens.color('on_primary') ?? tokens.color('text');
  final bgColor =
      coerceColor(props['color'] ?? props['bgcolor'] ?? props['background']) ??
      ((variant == 'text' || variant == 'outlined') ? null : candyPrimary);
  final fgColor =
      coerceColor(
        props['text_color'] ?? props['fgcolor'] ?? props['foreground'],
      ) ??
      ((variant == 'text' || variant == 'outlined')
          ? candyPrimary
          : candyOnPrimary);
  final radius =
      coerceDouble(props['radius']) ??
      tokens.number('button', 'radius') ??
      tokens.number('radii', 'md');
  final padding = coercePadding(
    props['content_padding'] ?? tokens.padding('button', 'padding'),
  );
  final outlineColor = coerceColor(props['border_color']) ?? candyPrimary;
  final borderWidth = coerceDouble(props['border_width']) ?? 1.0;
  final elevation = coerceDouble(props['elevation']);
  final shadowColor = coerceColor(props['shadow_color']);
  final overlayColor = coerceColor(
    props['overlay_color'] ?? props['splash_color'],
  );
  final fontSize = coerceDouble(props['font_size']);
  final fontFamily = props['font_family']?.toString();
  final fontWeight = _parseWeight(props['font_weight'] ?? props['weight']);
  final letterSpacing = coerceDouble(props['letter_spacing']);
  final windowAction = props['window_action']?.toString();
  final windowActionDelayMs =
      (coerceOptionalInt(props['window_action_delay_ms']) ?? 0).clamp(0, 450);
  final textStyle =
      (fontSize != null ||
          fontFamily != null ||
          fontWeight != null ||
          letterSpacing != null)
      ? TextStyle(
          fontSize: fontSize,
          fontFamily: fontFamily,
          fontWeight: fontWeight,
          letterSpacing: letterSpacing,
        )
      : null;

  ButtonStyle? style;
  final shape = radius == null
      ? null
      : RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));
  final side = (variant == 'outlined' && outlineColor != null)
      ? BorderSide(color: outlineColor, width: borderWidth)
      : null;
  if (bgColor != null ||
      fgColor != null ||
      shape != null ||
      padding != null ||
      side != null ||
      elevation != null ||
      shadowColor != null ||
      overlayColor != null) {
    style = ButtonStyle(
      backgroundColor: bgColor == null
          ? null
          : WidgetStateProperty.all(bgColor),
      foregroundColor: fgColor == null
          ? null
          : WidgetStateProperty.all(fgColor),
      padding: padding == null ? null : WidgetStateProperty.all(padding),
      shape: shape == null ? null : WidgetStateProperty.all(shape),
      side: side == null ? null : WidgetStateProperty.all(side),
      elevation: elevation == null ? null : WidgetStateProperty.all(elevation),
      shadowColor: shadowColor == null
          ? null
          : WidgetStateProperty.all(shadowColor),
      overlayColor: overlayColor == null
          ? null
          : WidgetStateProperty.all(overlayColor),
    );
  }

  String normalizeEventName(String value) {
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

  final subscribedEvents = events is List
      ? events
            .map((e) => normalizeEventName(e?.toString() ?? ''))
            .where((name) => name.isNotEmpty)
            .toSet()
      : null;

  bool isSubscribed(String name) {
    if (subscribedEvents == null) return name == 'click';
    return subscribedEvents.contains(normalizeEventName(name));
  }

  void onPressed() {
    if (windowAction != null && windowAction.trim().isNotEmpty) {
      Future<void> dispatchWindowAction() async {
        if (windowActionDelayMs > 0) {
          await Future<void>.delayed(
            Duration(milliseconds: windowActionDelayMs),
          );
        }
        await ButterflyUIWindowApi.instance.performAction(windowAction);
      }

      unawaited(dispatchWindowAction());
    }
    final id = controlId;
    if (id == null || id.isEmpty) return;
    final payload = <String, Object?>{
      'label': label,
      'variant': variant,
      if (props['value'] != null) 'value': props['value'],
    };
    if (events is! List) {
      // Back-compat: if events isn't provided, behave like legacy.
      sendEvent(id, 'click', payload);
      return;
    }

    if (isSubscribed('click')) {
      sendEvent(id, 'click', payload);
    }
    // Many button handlers are registered as "press" in user code.
    if (isSubscribed('press')) {
      sendEvent(id, 'press', payload);
    }
    // Optional compatibility for clients using "tap".
    if (isSubscribed('tap')) {
      sendEvent(id, 'tap', payload);
    }
    if (isSubscribed('action')) {
      sendEvent(id, 'action', payload);
    }
  }

  if (variant == 'text') {
    return TextButton(
      onPressed: enabled ? onPressed : null,
      style: style,
      child: Text(label, style: textStyle),
    );
  }
  if (variant == 'outlined') {
    return OutlinedButton(
      onPressed: enabled ? onPressed : null,
      style: style,
      child: Text(label, style: textStyle),
    );
  }
  return ElevatedButton(
    onPressed: enabled ? onPressed : null,
    style: style,
    child: Text(label, style: textStyle),
  );
}

FontWeight? _parseWeight(Object? value) {
  if (value == null) return null;
  final s = value.toString().toLowerCase();
  final numeric = int.tryParse(s);
  if (numeric != null) {
    switch (numeric) {
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
    }
  }
  switch (s) {
    case 'w100':
    case 'thin':
      return FontWeight.w100;
    case 'w200':
    case 'extralight':
    case 'extra_light':
      return FontWeight.w200;
    case 'w300':
    case 'light':
      return FontWeight.w300;
    case 'w400':
    case 'normal':
      return FontWeight.w400;
    case 'w500':
    case 'medium':
      return FontWeight.w500;
    case 'w600':
    case 'semibold':
    case 'semi_bold':
      return FontWeight.w600;
    case 'w700':
    case 'bold':
      return FontWeight.w700;
    case 'w800':
    case 'extrabold':
    case 'extra_bold':
      return FontWeight.w800;
    case 'w900':
    case 'black':
      return FontWeight.w900;
  }
  return null;
}
