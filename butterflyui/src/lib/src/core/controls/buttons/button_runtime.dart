import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/candy/theme.dart';
import 'package:butterflyui_runtime/src/core/candy/theme_extension.dart';
import 'package:butterflyui_runtime/src/core/control_shells/base_control_shell.dart';
import 'package:butterflyui_runtime/src/core/control_shells/focusable_control_shell.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/common/color_value.dart';
import 'package:butterflyui_runtime/src/core/controls/common/icon_value.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';
import 'package:butterflyui_runtime/src/core/window/window_api.dart';

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

  final subscribedEvents = resolveSubscribedEvents(props['events']);
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
      // Keep the top-level props as the default action specification.
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

  if (props['events'] is! List) {
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
  final bool surfaceWrapped;

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
    required this.surfaceWrapped,
  });
}

ButterflyUIButtonVisualSpec buildButtonVisualSpec({
  required Map<String, Object?> props,
  required CandyTokens tokens,
  required String variant,
  required String fallbackLabel,
  Color? themePrimary,
  Color? themeOnPrimary,
  Color? themeText,
  Color? inheritedTint,
  bool surfaceWrapped = false,
}) {
  final label = (props['text'] ?? props['label'])?.toString() ?? fallbackLabel;
  final candyPrimary = tokens.color('primary') ?? inheritedTint ?? themePrimary;
  final candyOnPrimary =
      tokens.color('on_primary') ??
      themeOnPrimary ??
      tokens.color('text') ??
      themeText;
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
      backgroundColor: surfaceWrapped
          ? WidgetStateProperty.all(Colors.transparent)
          : bgColor == null
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
    surfaceWrapped: surfaceWrapped,
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

Widget buildButtonVariantControl({
  required String controlId,
  required Map<String, Object?> props,
  required CandyTokens tokens,
  required String variant,
  required ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  required ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  required ButterflyUISendRuntimeEvent sendEvent,
}) {
  return _ButterflyUIButtonControl(
    controlId: controlId,
    props: props,
    tokens: tokens,
    variant: variant,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _ButterflyUIButtonControl extends StatefulWidget {
  const _ButterflyUIButtonControl({
    required this.controlId,
    required this.props,
    required this.tokens,
    required this.variant,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final CandyTokens tokens;
  final String variant;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_ButterflyUIButtonControl> createState() =>
      _ButterflyUIButtonControlState();
}

class _ButterflyUIButtonControlState extends State<_ButterflyUIButtonControl> {
  late final FocusNode _focusNode = FocusNode(
    debugLabel: 'butterflyui:button:${widget.variant}:${widget.controlId}',
  );
  late bool _enabled;
  late bool _busy;
  bool _hovered = false;

  bool get _canPress => _enabled && !_busy;

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    registerInvokeHandlerIfNeeded(
      controlId: widget.controlId,
      registerInvokeHandler: widget.registerInvokeHandler,
      handler: _handleInvoke,
    );
  }

  @override
  void didUpdateWidget(covariant _ButterflyUIButtonControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    syncInvokeHandlerRegistration(
      previousControlId: oldWidget.controlId,
      currentControlId: widget.controlId,
      registerInvokeHandler: widget.registerInvokeHandler,
      unregisterInvokeHandler: widget.unregisterInvokeHandler,
      handler: _handleInvoke,
    );
    if (oldWidget.props != widget.props) {
      _syncFromProps();
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

  void _syncFromProps() {
    _enabled = coerceShellBool(widget.props['enabled'], fallback: true);
    _busy = coerceShellBool(
      widget.props['busy'] ?? widget.props['loading'],
      fallback: false,
    );
  }

  Map<String, Object?> _effectiveProps() {
    return <String, Object?>{
      'variant': widget.variant,
      ...widget.props,
      'enabled': _enabled,
      'busy': _busy,
      'loading': _busy,
    };
  }

  ButterflyUIButtonVisualSpec _currentSpec(
    BuildContext context,
    Map<String, Object?> effectiveProps, {
    required bool surfaceWrapped,
  }) {
    final theme = Theme.of(context);
    final themeTokens = theme.extension<ButterflyUIThemeTokens>();
    final inheritedTint = coerceColor(
      effectiveProps['surface_tint_color'] ??
          effectiveProps['__surface_tint_color'],
    );
    return buildButtonVisualSpec(
      props: effectiveProps,
      tokens: widget.tokens,
      variant: widget.variant,
      fallbackLabel: widget.variant == 'icon_button' ? '' : 'Button',
      themePrimary: themeTokens?.primary ?? theme.colorScheme.primary,
      themeOnPrimary: theme.colorScheme.onPrimary,
      themeText: themeTokens?.text ?? theme.colorScheme.onSurface,
      inheritedTint: inheritedTint,
      surfaceWrapped: surfaceWrapped,
    );
  }

  Map<String, Object?> _statePayload({
    ButterflyUIButtonVisualSpec? spec,
    Map<String, Object?>? effectiveProps,
  }) {
    final resolvedProps = effectiveProps ?? _effectiveProps();
    final resolvedSpec =
        spec ??
        _currentSpec(
          context,
          resolvedProps,
          surfaceWrapped: _usesDecoratedButtonSurface(resolvedProps),
        );
    return <String, Object?>{
      'label': resolvedSpec.label,
      'variant': widget.variant,
      'enabled': _enabled,
      'busy': _busy,
      'focused': _focusNode.hasFocus,
      'hovered': _hovered,
      if (resolvedProps['value'] != null) 'value': resolvedProps['value'],
    };
  }

  void _dispatchPress({
    ButterflyUIButtonVisualSpec? spec,
    Map<String, Object?>? effectiveProps,
  }) {
    final resolvedProps = effectiveProps ?? _effectiveProps();
    final resolvedSpec =
        spec ??
        _currentSpec(
          context,
          resolvedProps,
          surfaceWrapped: _usesDecoratedButtonSurface(resolvedProps),
        );
    if (!_canPress) return;
    unawaited(maybeDispatchWindowAction(resolvedProps));
    emitControlPressEvents(
      controlId: widget.controlId,
      props: resolvedProps,
      payload: buildBasePressPayload(
        label: resolvedSpec.label,
        variant: widget.variant,
        props: resolvedProps,
        busy: _busy,
      ),
      sendEvent: widget.sendEvent,
    );
  }

  void _handleHoverChange(bool value) {
    if (_hovered == value) return;
    setState(() {
      _hovered = value;
    });
    final payload = _statePayload();
    emitSubscribedEvent(
      controlId: widget.controlId,
      subscribedEventsSource: widget.props['events'],
      name: value ? 'hover_enter' : 'hover_exit',
      payload: payload,
      sendEvent: widget.sendEvent,
    );
    emitSubscribedEvent(
      controlId: widget.controlId,
      subscribedEventsSource: widget.props['events'],
      name: 'hover',
      payload: <String, Object?>{...payload, 'value': value},
      sendEvent: widget.sendEvent,
    );
  }

  void _handleFocusChange(bool value) {
    final payload = _statePayload();
    emitSubscribedEvent(
      controlId: widget.controlId,
      subscribedEventsSource: widget.props['events'],
      name: value ? 'focus' : 'blur',
      payload: payload,
      sendEvent: widget.sendEvent,
    );
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    return handleFocusableInvoke(
      context: context,
      focusNode: _focusNode,
      method: method,
      args: args,
      onUnhandled: (name, payload) async {
        switch (name) {
          case 'press':
            _dispatchPress();
            return _canPress;
          case 'set_enabled':
            final nextEnabled = coerceShellBoolOrNull(
              payload['enabled'] ?? payload['value'],
            );
            if (nextEnabled != null) {
              setState(() {
                _enabled = nextEnabled;
              });
            }
            return _enabled;
          case 'set_busy':
            final nextBusy = coerceShellBoolOrNull(
              payload['busy'] ?? payload['loading'] ?? payload['value'],
            );
            if (nextBusy != null) {
              setState(() {
                _busy = nextBusy;
              });
            }
            return _busy;
          case 'get_state':
            return _statePayload();
          default:
            throw UnsupportedError(
              'Unknown ${widget.variant} button method: $name',
            );
        }
      },
    );
  }

  Widget _buildBusyContent(Widget child) {
    final spinnerColor =
        _currentSpec(
          context,
          _effectiveProps(),
          surfaceWrapped: _usesDecoratedButtonSurface(_effectiveProps()),
        ).iconColor ??
        Theme.of(context).colorScheme.onPrimary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color?>(spinnerColor),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(fit: FlexFit.loose, child: child),
      ],
    );
  }

  Widget _buildIconButton(
    Map<String, Object?> effectiveProps,
    ButterflyUIButtonVisualSpec spec,
  ) {
    final iconValue =
        effectiveProps['icon'] ??
        effectiveProps['glyph'] ??
        effectiveProps['value'];
    final tooltip = effectiveProps['tooltip']?.toString();
    final background = resolveColorValue(
      effectiveProps['background'] ?? effectiveProps['bgcolor'],
      autoContrast: spec.autoContrast,
      minContrast: spec.minContrast,
    );
    final iconBackground = spec.surfaceWrapped ? null : background;
    final iconWidget = _busy
        ? SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color?>(spec.iconColor),
            ),
          )
        : (buildIconValue(
                iconValue,
                colorValue:
                    effectiveProps['color'] ??
                    effectiveProps['icon_color'] ??
                    spec.iconColor,
                color: spec.iconColor,
                background: iconBackground,
                size: spec.iconSize,
                autoContrast: spec.autoContrast,
                minContrast: spec.minContrast,
                fallbackIcon: Icons.help_outline,
              ) ??
              Icon(
                Icons.help_outline,
                size: spec.iconSize,
                color: spec.iconColor,
              ));
    final splashRadius = coerceDouble(effectiveProps['splash_radius']);
    final padding = coercePadding(effectiveProps['padding']);

    Widget button = IconButton(
      icon: iconWidget,
      splashRadius: splashRadius,
      tooltip: tooltip,
      onPressed: _canPress ? () => _dispatchPress(spec: spec) : null,
      color: spec.iconColor,
      style:
          (background != null ||
              effectiveProps['padding'] != null ||
              effectiveProps['shape'] != null)
          ? ButtonStyle(
              backgroundColor: spec.surfaceWrapped
                  ? WidgetStateProperty.all(Colors.transparent)
                  : background == null
                  ? null
                  : WidgetStateProperty.all(background),
              padding: padding == null
                  ? null
                  : WidgetStateProperty.all(padding),
            )
          : null,
    );
    if (tooltip != null && tooltip.isNotEmpty) {
      button = Tooltip(message: tooltip, child: button);
    }
    return button;
  }

  Widget _buildVariantButton(
    Map<String, Object?> effectiveProps,
    ButterflyUIButtonVisualSpec spec,
  ) {
    Widget content = buildButtonContent(
      spec: spec,
      fallbackLabel: widget.variant == 'icon_button' ? '' : 'Button',
    );
    if (_busy && widget.variant != 'icon_button') {
      content = _buildBusyContent(content);
    }

    switch (widget.variant) {
      case 'text':
      case 'text_button':
        return TextButton(
          onPressed: _canPress ? () => _dispatchPress(spec: spec) : null,
          style: spec.style,
          child: content,
        );
      case 'outlined':
      case 'outlined_button':
        return OutlinedButton(
          onPressed: _canPress ? () => _dispatchPress(spec: spec) : null,
          style: spec.style,
          child: content,
        );
      case 'filled':
      case 'filled_button':
        return FilledButton(
          onPressed: _canPress ? () => _dispatchPress(spec: spec) : null,
          style: spec.style,
          child: content,
        );
      case 'elevated':
      case 'elevated_button':
        return ElevatedButton(
          onPressed: _canPress ? () => _dispatchPress(spec: spec) : null,
          style: spec.style,
          child: content,
        );
      case 'icon_button':
        return _buildIconButton(effectiveProps, spec);
      default:
        return ElevatedButton(
          onPressed: _canPress ? () => _dispatchPress(spec: spec) : null,
          style: spec.style,
          child: content,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveProps = _effectiveProps();
    final surfaceWrapped = _usesDecoratedButtonSurface(effectiveProps);
    final spec = _currentSpec(
      context,
      effectiveProps,
      surfaceWrapped: surfaceWrapped,
    );
    Widget button = _buildVariantButton(effectiveProps, spec);
    button = FocusableActionDetector(
      focusNode: _focusNode,
      autofocus: effectiveProps['autofocus'] == true,
      enabled: true,
      mouseCursor: _canPress
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onShowHoverHighlight: _handleHoverChange,
      onFocusChange: _handleFocusChange,
      child: button,
    );
    if (surfaceWrapped) {
      button = _decorateButtonSurface(context, button, effectiveProps);
    }
    return applyControlTransparency(child: button, props: effectiveProps);
  }
}

bool _usesDecoratedButtonSurface(Map<String, Object?> props) {
  if (coerceShellBool(
    props['button_surface'] ??
        props['decorated'] ??
        props['glass'] ??
        props['surface'],
    fallback: false,
  )) {
    return true;
  }
  return props['gradient'] != null ||
      props['shadow'] != null ||
      props['image'] != null ||
      props['backdrop_color'] != null ||
      coerceDouble(props['backdrop_blur'] ?? props['blur']) != null ||
      props['glow'] == true;
}

Widget _decorateButtonSurface(
  BuildContext context,
  Widget child,
  Map<String, Object?> props,
) {
  final theme = Theme.of(context);
  final tokens = theme.extension<ButterflyUIThemeTokens>();
  final inheritedTint = coerceColor(
    props['surface_tint_color'] ?? props['__surface_tint_color'],
  );
  final explicitSurfaceFill =
      props.containsKey('color') ||
      props.containsKey('bgcolor') ||
      props.containsKey('background') ||
      props.containsKey('gradient');
  final variant = (props['variant'] ?? 'button')
      .toString()
      .trim()
      .toLowerCase();
  final variantAlpha = variant == 'text' || variant == 'text_button'
      ? 0.10
      : variant == 'outlined' || variant == 'outlined_button'
      ? 0.12
      : variant == 'icon_button'
      ? 0.14
      : 0.18;
  final baseTint =
      inheritedTint ?? tokens?.primary ?? theme.colorScheme.primary;
  final backgroundColor =
      coerceColor(props['bgcolor'] ?? props['background'] ?? props['color']) ??
      (!explicitSurfaceFill
          ? deriveInheritedSurfaceFill(baseTint, alpha: variantAlpha)
          : null);
  final gradient = coerceGradient(props['gradient']);
  final image = coerceDecorationImage(props['image']);
  final borderColor =
      coerceColor(props['border_color']) ??
      (!explicitSurfaceFill
          ? deriveInheritedSurfaceBorder(baseTint)
          : tokens?.border ?? theme.colorScheme.outlineVariant);
  final borderWidth =
      coerceDouble(props['border_width']) ??
      ((variant == 'outlined' || variant == 'outlined_button') ? 1.0 : 0.0);
  final radius =
      coerceDouble(props['radius']) ??
      coerceDouble(props['border_radius']) ??
      tokens?.radiusMd ??
      14.0;
  final shadow =
      coerceBoxShadow(props['shadow']) ??
      (props['glow'] == true
          ? <BoxShadow>[
              BoxShadow(
                color: baseTint.withValues(alpha: 0.30),
                blurRadius: 24,
                spreadRadius: 0.5,
                offset: const Offset(0, 8),
              ),
            ]
          : null);
  final backdropBlur =
      (coerceDouble(props['backdrop_blur'] ?? props['blur']) ?? 0.0).clamp(
        0.0,
        30.0,
      );
  final backdropColor = coerceColor(props['backdrop_color']);
  final margin = coercePadding(props['margin']);
  final shape = props['shape']?.toString().trim().toLowerCase() == 'circle'
      ? BoxShape.circle
      : BoxShape.rectangle;

  Widget surface = DecoratedBox(
    decoration: BoxDecoration(
      color: gradient == null ? backgroundColor : null,
      gradient: gradient,
      image: image,
      shape: shape,
      border: borderWidth <= 0
          ? null
          : Border.all(color: borderColor, width: borderWidth),
      borderRadius: shape == BoxShape.circle
          ? null
          : BorderRadius.circular(radius),
      boxShadow: shadow,
    ),
    child: child,
  );

  if (backdropBlur > 0 || backdropColor != null) {
    final filter = ImageFilter.blur(sigmaX: backdropBlur, sigmaY: backdropBlur);
    final decoratedBackdrop = DecoratedBox(
      decoration: BoxDecoration(
        color: backdropColor,
        shape: shape,
        borderRadius: shape == BoxShape.circle
            ? null
            : BorderRadius.circular(radius),
      ),
      child: surface,
    );
    surface = shape == BoxShape.circle
        ? ClipOval(
            child: BackdropFilter(filter: filter, child: decoratedBackdrop),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: BackdropFilter(filter: filter, child: decoratedBackdrop),
          );
  } else if (shape == BoxShape.circle) {
    surface = ClipOval(child: surface);
  } else {
    surface = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: surface,
    );
  }

  if (margin != null) {
    surface = Padding(padding: margin, child: surface);
  }
  return surface;
}
