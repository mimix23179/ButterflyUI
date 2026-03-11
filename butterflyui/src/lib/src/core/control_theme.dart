import 'package:flutter/material.dart';

import 'control_utils.dart';
import 'styling/theme_extension.dart';

ButterflyUIThemeTokens? butterflyuiTokens(BuildContext context) {
  return Theme.of(context).extension<ButterflyUIThemeTokens>();
}

Color butterflyuiBackground(BuildContext context) {
  final theme = Theme.of(context);
  final tokens = butterflyuiTokens(context);
  return tokens?.background ?? theme.scaffoldBackgroundColor;
}

Color butterflyuiSurface(BuildContext context) {
  final theme = Theme.of(context);
  final tokens = butterflyuiTokens(context);
  return tokens?.surface ?? theme.colorScheme.surface;
}

Color butterflyuiSurfaceAlt(BuildContext context) {
  final theme = Theme.of(context);
  final tokens = butterflyuiTokens(context);
  return tokens?.surfaceAlt ?? theme.colorScheme.surfaceContainerHighest;
}

Color butterflyuiText(BuildContext context) {
  final theme = Theme.of(context);
  final tokens = butterflyuiTokens(context);
  return tokens?.text ?? theme.colorScheme.onSurface;
}

Color butterflyuiMutedText(BuildContext context) {
  final theme = Theme.of(context);
  final tokens = butterflyuiTokens(context);
  return tokens?.mutedText ?? theme.colorScheme.onSurfaceVariant;
}

Color butterflyuiBorder(BuildContext context) {
  final theme = Theme.of(context);
  final tokens = butterflyuiTokens(context);
  return tokens?.border ?? theme.colorScheme.outlineVariant;
}

Color butterflyuiPrimary(BuildContext context) {
  final theme = Theme.of(context);
  final tokens = butterflyuiTokens(context);
  return tokens?.primary ?? theme.colorScheme.primary;
}

Color butterflyuiSecondary(BuildContext context) {
  final theme = Theme.of(context);
  final tokens = butterflyuiTokens(context);
  return tokens?.secondary ?? theme.colorScheme.secondary;
}

Color butterflyuiStatusColor(BuildContext context, String? status) {
  final theme = Theme.of(context);
  final tokens = butterflyuiTokens(context);
  switch ((status ?? '').toLowerCase()) {
    case 'success':
    case 'ok':
      return tokens?.success ?? theme.colorScheme.secondary;
    case 'warning':
    case 'warn':
      return tokens?.warning ?? theme.colorScheme.tertiary;
    case 'info':
      return tokens?.info ?? theme.colorScheme.primaryContainer;
    case 'error':
    case 'danger':
    case 'fatal':
      return tokens?.error ?? theme.colorScheme.error;
    default:
      return tokens?.primary ?? theme.colorScheme.primary;
  }
}

Color butterflyuiScrim(BuildContext context, {double opacity = 0.45}) {
  final scrim = Theme.of(context).colorScheme.scrim;
  return scrim.withValues(alpha: opacity);
}

List<Color> butterflyuiAccentPalette(BuildContext context) {
  final theme = Theme.of(context);
  final tokens = butterflyuiTokens(context);
  return [
    tokens?.primary ?? theme.colorScheme.primary,
    tokens?.secondary ?? theme.colorScheme.secondary,
    tokens?.info ?? theme.colorScheme.primaryContainer,
    tokens?.warning ?? theme.colorScheme.tertiary,
    tokens?.error ?? theme.colorScheme.error,
  ];
}

Map<String, Object?> butterflyuiSlotStyle(
  Map<String, Object?> props,
  String slot,
) {
  final slotStyles = props['__slot_styles'];
  if (slotStyles is! Map) return const <String, Object?>{};
  final map = coerceObjectMap(slotStyles);
  final slotMap = map[slot];
  if (slotMap is! Map) return const <String, Object?>{};
  return coerceObjectMap(slotMap);
}

Color butterflyuiResolveSlotColor(
  BuildContext context,
  Map<String, Object?> props, {
  required String slot,
  Object? explicit,
  Color? fallback,
  bool muted = false,
}) {
  final slotMap = butterflyuiSlotStyle(props, slot);
  return coerceColor(
        explicit ??
            slotMap['text_color'] ??
            slotMap['foreground'] ??
            slotMap['color'],
      ) ??
      fallback ??
      (muted ? butterflyuiMutedText(context) : butterflyuiText(context));
}

class ButterflyUISurfaceChrome {
  const ButterflyUISurfaceChrome({
    required this.backgroundColor,
    required this.gradient,
    required this.borderColor,
    required this.borderWidth,
    required this.radius,
    required this.boxShadow,
    required this.contentPadding,
    required this.scrimColor,
  });

  final Color? backgroundColor;
  final Gradient? gradient;
  final Color borderColor;
  final double borderWidth;
  final double radius;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? contentPadding;
  final Color scrimColor;
}

Widget butterflyuiSurfaceContainer(
  BuildContext context, {
  required Map<String, Object?> props,
  required Widget child,
  Color? fallbackBackground,
  Color? fallbackBorder,
  double? fallbackRadius,
  double? fallbackBorderWidth,
  EdgeInsetsGeometry? fallbackPadding,
  List<BoxShadow>? fallbackShadow,
  bool clip = true,
  String backgroundSlot = 'background',
  String borderSlot = 'border',
  String contentSlot = 'content',
}) {
  final surface = butterflyuiResolveSurfaceChrome(
    context,
    props,
    fallbackBackground: fallbackBackground,
    fallbackBorder: fallbackBorder,
    fallbackRadius: fallbackRadius,
    fallbackBorderWidth: fallbackBorderWidth,
    fallbackPadding: fallbackPadding,
    fallbackShadow: fallbackShadow,
    backgroundSlot: backgroundSlot,
    borderSlot: borderSlot,
    contentSlot: contentSlot,
  );
  return Container(
    clipBehavior: clip ? Clip.antiAlias : Clip.none,
    decoration: BoxDecoration(
      color: surface.backgroundColor,
      gradient: surface.gradient,
      borderRadius: BorderRadius.circular(surface.radius),
      border: Border.all(
        color: surface.borderColor,
        width: surface.borderWidth,
      ),
      boxShadow: surface.boxShadow,
    ),
    child: Padding(
      padding: surface.contentPadding ?? EdgeInsets.zero,
      child: child,
    ),
  );
}

ListTileThemeData butterflyuiListTileTheme(
  BuildContext context,
  Map<String, Object?> props, {
  Color? titleColor,
  Color? subtitleColor,
  Color? iconColor,
  Color? selectedColor,
  Color? selectedTileColor,
}) {
  final title =
      titleColor ??
      butterflyuiResolveSlotColor(
        context,
        props,
        slot: 'label',
        fallback: butterflyuiText(context),
      );
  final subtitle =
      subtitleColor ??
      butterflyuiResolveSlotColor(
        context,
        props,
        slot: 'helper',
        fallback: butterflyuiMutedText(context),
      );
  final icon =
      iconColor ??
      butterflyuiResolveSlotColor(
        context,
        props,
        slot: 'icon',
        fallback: title,
      );
  final selected =
      selectedColor ??
      butterflyuiResolveSlotColor(
        context,
        props,
        slot: 'label',
        explicit: props['selected_text_color'],
        fallback: butterflyuiPrimary(context),
      );
  final tileColor =
      selectedTileColor ??
      coerceColor(props['selected_bgcolor']) ??
      butterflyuiPrimary(context).withValues(alpha: 0.1);
  return ListTileThemeData(
    textColor: title,
    iconColor: icon,
    selectedColor: selected,
    selectedTileColor: tileColor,
    subtitleTextStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
      color: subtitle,
    ),
    titleTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: title,
    ),
  );
}

ButterflyUISurfaceChrome butterflyuiResolveSurfaceChrome(
  BuildContext context,
  Map<String, Object?> props, {
  Color? fallbackBackground,
  Color? fallbackBorder,
  double? fallbackRadius,
  double? fallbackBorderWidth,
  EdgeInsetsGeometry? fallbackPadding,
  List<BoxShadow>? fallbackShadow,
  String backgroundSlot = 'background',
  String borderSlot = 'border',
  String contentSlot = 'content',
  double inheritedAlpha = 0.18,
}) {
  final theme = Theme.of(context);
  final tokens = butterflyuiTokens(context);
  final bgSlot = butterflyuiSlotStyle(props, backgroundSlot);
  final bdSlot = butterflyuiSlotStyle(props, borderSlot);
  final content = butterflyuiSlotStyle(props, contentSlot);
  final inheritedTint = coerceColor(
    props['surface_tint_color'] ?? props['__surface_tint_color'] ?? props['color'],
  );
  final explicitSurfaceFill =
      bgSlot['bgcolor'] != null ||
      bgSlot['background'] != null ||
      bgSlot['gradient'] != null ||
      props['bgcolor'] != null ||
      props['background'] != null ||
      props['gradient'] != null;
  final background =
      coerceColor(
        bgSlot['bgcolor'] ?? bgSlot['background'] ?? props['bgcolor'] ?? props['background'],
      ) ??
      (!explicitSurfaceFill && inheritedTint != null
          ? deriveInheritedSurfaceFill(inheritedTint, alpha: inheritedAlpha)
          : fallbackBackground ?? tokens?.surface ?? theme.colorScheme.surface);
  final gradient = coerceGradient(bgSlot['gradient'] ?? props['gradient']);
  final borderColor =
      coerceColor(
        bdSlot['border_color'] ?? bdSlot['foreground'] ?? bdSlot['color'] ?? props['border_color'],
      ) ??
      (!explicitSurfaceFill && inheritedTint != null
          ? deriveInheritedSurfaceBorder(inheritedTint)
          : fallbackBorder ?? tokens?.border ?? theme.colorScheme.outlineVariant);
  final borderWidth =
      coerceDouble(bdSlot['border_width'] ?? props['border_width']) ??
      fallbackBorderWidth ??
      1.0;
  final radius =
      coerceDouble(
        bdSlot['radius'] ?? bdSlot['border_radius'] ?? props['radius'],
      ) ??
      fallbackRadius ??
      tokens?.radiusLg ??
      16.0;
  final contentPadding =
      coercePadding(
        props['content_padding'] ??
            content['padding'] ??
            content['content_padding'],
      ) ??
      fallbackPadding;
  final shadow =
      coerceBoxShadow(props['shadow'] ?? bgSlot['shadow']) ?? fallbackShadow;
  final scrimColor =
      coerceColor(props['scrim_color']) ??
      tokens?.overlayScrim ??
      theme.colorScheme.scrim.withValues(alpha: 0.54);
  return ButterflyUISurfaceChrome(
    backgroundColor: gradient == null ? background : null,
    gradient: gradient,
    borderColor: borderColor,
    borderWidth: borderWidth,
    radius: radius,
    boxShadow: shadow,
    contentPadding: contentPadding,
    scrimColor: scrimColor,
  );
}
