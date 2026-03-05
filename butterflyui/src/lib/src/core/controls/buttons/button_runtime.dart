import 'dart:async';

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/candy/theme.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/common/icon_value.dart';
import 'package:butterflyui_runtime/src/core/controls/common/color_value.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';
import 'package:butterflyui_runtime/src/core/window/window_api.dart';

String normalizeControlEventName(String value) {
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

Set<String>? resolveSubscribedEvents(Object? events) {
  if (events is! List) return null;
  return events
      .map((e) => normalizeControlEventName(e?.toString() ?? ''))
      .where((name) => name.isNotEmpty)
      .toSet();
}

bool isControlEventSubscribed(Set<String>? subscribedEvents, String name) {
  if (subscribedEvents == null) return name == 'click';
  return subscribedEvents.contains(normalizeControlEventName(name));
}

Future<void> maybeDispatchWindowAction(Map<String, Object?> props) async {
  final windowAction = props['window_action']?.toString();
  if (windowAction == null || windowAction.trim().isEmpty) return;
  final windowActionDelayMs =
      (coerceOptionalInt(props['window_action_delay_ms']) ?? 0).clamp(0, 450);
  if (windowActionDelayMs > 0) {
    await Future<void>.delayed(Duration(milliseconds: windowActionDelayMs));
  }
  await ButterflyUIWindowApi.instance.performAction(windowAction);
}

Map<String, Object?> buildBasePressPayload({
  required String label,
  required String variant,
  required Map<String, Object?> props,
  bool? busy,
}) {
  return <String, Object?>{
    'label': label,
    'variant': variant,
    if (props['value'] != null) 'value': props['value'],
    if (busy != null) 'busy': busy,
    if (busy != null) 'loading': busy,
  };
}

void emitControlPressEvents({
  required String controlId,
  required Map<String, Object?> props,
  required Map<String, Object?> payload,
  required ButterflyUISendRuntimeEvent sendEvent,
}) {
  if (controlId.isEmpty) return;

  final events = props['events'];
  final subscribedEvents = resolveSubscribedEvents(events);
  final actionId = props['action_id']?.toString();
  final actionEventName = props['action_event']?.toString();
  final actionPayload = props['action_payload'];

  final payloadWithActions = <String, Object?>{
    ...payload,
    if (actionId != null && actionId.isNotEmpty) 'action_id': actionId,
    if (actionEventName != null && actionEventName.isNotEmpty)
      'action_event': actionEventName,
    if (actionPayload != null) 'action_payload': actionPayload,
  };

  void emitDeclarativeAction(Object? actionSpec, {bool force = false}) {
    var eventName = actionEventName;
    String? resolvedActionId = actionId;
    Object? resolvedActionPayload = actionPayload;
    String? targetControlId;
    String? actionType;
    String? actionMethod;
    Object? actionArgs;

    if (actionSpec == null) {
      // Keep defaults from top-level props.
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
      targetControlId =
          map['target']?.toString() ??
          map['target_id']?.toString() ??
          map['control_id']?.toString();
      actionType = map['type']?.toString() ?? map['kind']?.toString();
      actionMethod = map['method']?.toString() ?? map['invoke']?.toString();
      if (map.containsKey('args')) {
        actionArgs = map['args'];
      }
    }

    final resolvedEvent = normalizeControlEventName(
      (eventName == null || eventName.isEmpty) ? 'action' : eventName,
    );
    if (resolvedEvent.isEmpty ||
        (!force &&
            !isControlEventSubscribed(subscribedEvents, resolvedEvent))) {
      return;
    }

    final actionEventPayload = <String, Object?>{
      ...payloadWithActions,
      if (resolvedActionId != null && resolvedActionId.isNotEmpty)
        'action_id': resolvedActionId,
      if (targetControlId != null && targetControlId.isNotEmpty)
        'target': targetControlId,
      if (actionType != null && actionType.isNotEmpty) 'type': actionType,
      if (actionMethod != null && actionMethod.isNotEmpty)
        'method': actionMethod,
      if (actionArgs != null) 'args': actionArgs,
    };
    if (resolvedActionPayload is Map) {
      actionEventPayload.addAll(coerceObjectMap(resolvedActionPayload));
    } else if (resolvedActionPayload != null) {
      actionEventPayload['action_payload'] = resolvedActionPayload;
    }
    sendEvent(controlId, resolvedEvent, actionEventPayload);
  }

  if (events is! List) {
    sendEvent(controlId, 'click', payloadWithActions);
    emitDeclarativeAction(props['action'], force: true);
    if (props['actions'] is List) {
      for (final actionSpec in props['actions'] as List) {
        emitDeclarativeAction(actionSpec, force: true);
      }
    } else if (actionId != null || actionPayload != null) {
      emitDeclarativeAction(const <String, Object?>{}, force: true);
    }
    return;
  }

  if (isControlEventSubscribed(subscribedEvents, 'click')) {
    sendEvent(controlId, 'click', payloadWithActions);
  }
  if (isControlEventSubscribed(subscribedEvents, 'press')) {
    sendEvent(controlId, 'press', payloadWithActions);
  }
  if (isControlEventSubscribed(subscribedEvents, 'tap')) {
    sendEvent(controlId, 'tap', payloadWithActions);
  }
  if (isControlEventSubscribed(subscribedEvents, 'action')) {
    sendEvent(controlId, 'action', payloadWithActions);
  }
  emitDeclarativeAction(props['action']);
  if (props['actions'] is List) {
    for (final actionSpec in props['actions'] as List) {
      emitDeclarativeAction(actionSpec);
    }
  } else if (actionId != null || actionPayload != null) {
    emitDeclarativeAction(const <String, Object?>{});
  }
}

class ButterflyUIButtonVisualSpec {
  final String label;
  final ButtonStyle? style;
  final TextStyle? textStyle;
  final Color? iconColor;
  final double? iconSize;
  final double iconSpacing;
  final Object? leadingIcon;
  final Object? trailingIcon;
  final Color? iconBackground;
  final bool autoContrast;
  final double minContrast;

  const ButterflyUIButtonVisualSpec({
    required this.label,
    required this.style,
    required this.textStyle,
    required this.iconColor,
    required this.iconSize,
    required this.iconSpacing,
    required this.leadingIcon,
    required this.trailingIcon,
    required this.iconBackground,
    required this.autoContrast,
    required this.minContrast,
  });
}

ButterflyUIButtonVisualSpec buildButtonVisualSpec({
  required Map<String, Object?> props,
  required CandyTokens tokens,
  required String variant,
  required String fallbackLabel,
}) {
  final label = (props['text'] ?? props['label'])?.toString() ?? fallbackLabel;
  final candyPrimary = tokens.color('primary');
  final candyOnPrimary = tokens.color('on_primary') ?? tokens.color('text');
  final bgColor = resolveColorValue(
    props['color'] ?? props['bgcolor'] ?? props['background'],
    fallback: (variant == 'text' || variant == 'outlined')
        ? null
        : candyPrimary,
    autoContrast: coerceBool(props['auto_contrast']) ?? true,
    minContrast: coerceDouble(props['min_contrast']) ?? 4.5,
  );
  final fgColor = resolveColorValue(
    props['text_color'] ?? props['fgcolor'] ?? props['foreground'],
    fallback: (variant == 'text' || variant == 'outlined')
        ? candyPrimary
        : candyOnPrimary,
    background: bgColor,
    autoContrast: coerceBool(props['auto_contrast']) ?? true,
    minContrast: coerceDouble(props['min_contrast']) ?? 4.5,
  );
  final radius =
      coerceDouble(props['radius']) ??
      tokens.number('button', 'radius') ??
      tokens.number('radii', 'md');
  final padding = coercePadding(
    props['content_padding'] ?? tokens.padding('button', 'padding'),
  );
  final outlineColor = resolveColorValue(
    props['border_color'],
    fallback: candyPrimary,
  );
  final borderWidth = coerceDouble(props['border_width']) ?? 1.0;
  final elevation = coerceDouble(props['elevation']);
  final shadowColor = resolveColorValue(props['shadow_color']);
  final overlayColor = resolveColorValue(
    props['overlay_color'] ?? props['splash_color'],
  );
  final fontSize = coerceDouble(props['font_size']);
  final fontFamily = props['font_family']?.toString();
  final fontWeight = parseButtonFontWeight(
    props['font_weight'] ?? props['weight'],
  );
  final letterSpacing = coerceDouble(props['letter_spacing']);
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
          color: fgColor,
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

  final iconPosition =
      (props['icon_position'] ?? props['glyph_position'] ?? 'leading')
          .toString()
          .trim()
          .toLowerCase();
  final rawIcon = props['icon'] ?? props['glyph'] ?? props['leading_icon'];
  final leadingIcon = iconPosition == 'trailing' ? null : rawIcon;
  final trailingIcon = iconPosition == 'trailing'
      ? (props['trailing_icon'] ?? rawIcon)
      : props['trailing_icon'];
  final iconColor = resolveColorValue(
    props['icon_color'] ?? props['icon_foreground'] ?? fgColor,
    background: bgColor,
    autoContrast: coerceBool(props['auto_contrast']) ?? true,
    minContrast: coerceDouble(props['min_contrast']) ?? 4.5,
  );
  final iconBackground = resolveColorValue(props['icon_background']);
  final iconSize =
      coerceDouble(props['icon_size']) ?? coerceDouble(props['size']);
  final iconSpacing = coerceDouble(props['icon_spacing']) ?? 8.0;
  final autoContrast = coerceBool(props['auto_contrast']) ?? true;
  final minContrast = coerceDouble(props['min_contrast']) ?? 4.5;

  return ButterflyUIButtonVisualSpec(
    label: label,
    style: style,
    textStyle: textStyle,
    iconColor: iconColor,
    iconSize: iconSize,
    iconSpacing: iconSpacing,
    leadingIcon: leadingIcon,
    trailingIcon: trailingIcon,
    iconBackground: iconBackground,
    autoContrast: autoContrast,
    minContrast: minContrast,
  );
}

Widget buildButtonContent({
  required ButterflyUIButtonVisualSpec spec,
  required String fallbackLabel,
}) {
  final label = spec.label.isEmpty ? fallbackLabel : spec.label;
  final text = Text(label, style: spec.textStyle);

  Widget? iconFor(Object? value) {
    if (value == null) return null;
    return buildIconValue(
      value,
      colorValue: spec.iconColor,
      color: spec.iconColor,
      background: spec.iconBackground,
      size: spec.iconSize,
      autoContrast: spec.autoContrast,
      minContrast: spec.minContrast,
      fallbackIcon: Icons.help_outline,
    );
  }

  final leading = iconFor(spec.leadingIcon);
  final trailing = iconFor(spec.trailingIcon);

  if (leading == null && trailing == null) {
    return text;
  }
  if (label.isEmpty) {
    return leading ?? trailing ?? text;
  }
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (leading != null) ...[leading, SizedBox(width: spec.iconSpacing)],
      text,
      if (trailing != null) ...[SizedBox(width: spec.iconSpacing), trailing],
    ],
  );
}

Widget applyControlTransparency({
  required Widget child,
  required Map<String, Object?> props,
}) {
  final explicitOpacity = coerceDouble(props['opacity']);
  final transparency = coerceDouble(
    props['transparency'] ?? props['alpha'] ?? props['translucency'],
  );
  double? resolvedOpacity = explicitOpacity;
  if (transparency != null) {
    final normalized = transparency > 1
        ? (transparency / 100.0).clamp(0.0, 1.0)
        : transparency.clamp(0.0, 1.0);
    final transparencyOpacity = 1.0 - normalized;
    resolvedOpacity = resolvedOpacity == null
        ? transparencyOpacity
        : (resolvedOpacity * transparencyOpacity).clamp(0.0, 1.0);
  }
  if (resolvedOpacity == null || resolvedOpacity >= 1.0) {
    return child;
  }
  return Opacity(opacity: resolvedOpacity.clamp(0.0, 1.0), child: child);
}

FontWeight? parseButtonFontWeight(Object? value) {
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
