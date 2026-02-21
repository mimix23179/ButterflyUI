import 'package:flutter/material.dart';

import 'candy/theme_extension.dart';

ConduitThemeTokens? conduitTokens(BuildContext context) {
  return Theme.of(context).extension<ConduitThemeTokens>();
}

Color conduitBackground(BuildContext context) {
  final theme = Theme.of(context);
  final tokens = conduitTokens(context);
  return tokens?.background ?? theme.colorScheme.background;
}

Color conduitSurface(BuildContext context) {
  final theme = Theme.of(context);
  final tokens = conduitTokens(context);
  return tokens?.surface ?? theme.colorScheme.surface;
}

Color conduitSurfaceAlt(BuildContext context) {
  final theme = Theme.of(context);
  final tokens = conduitTokens(context);
  return tokens?.surfaceAlt ?? theme.colorScheme.surfaceVariant;
}

Color conduitText(BuildContext context) {
  final theme = Theme.of(context);
  final tokens = conduitTokens(context);
  return tokens?.text ?? theme.colorScheme.onSurface;
}

Color conduitMutedText(BuildContext context) {
  final theme = Theme.of(context);
  final tokens = conduitTokens(context);
  return tokens?.mutedText ?? theme.colorScheme.onSurfaceVariant;
}

Color conduitBorder(BuildContext context) {
  final theme = Theme.of(context);
  final tokens = conduitTokens(context);
  return tokens?.border ?? theme.colorScheme.outlineVariant;
}

Color conduitPrimary(BuildContext context) {
  final theme = Theme.of(context);
  final tokens = conduitTokens(context);
  return tokens?.primary ?? theme.colorScheme.primary;
}

Color conduitSecondary(BuildContext context) {
  final theme = Theme.of(context);
  final tokens = conduitTokens(context);
  return tokens?.secondary ?? theme.colorScheme.secondary;
}

Color conduitStatusColor(BuildContext context, String? status) {
  final theme = Theme.of(context);
  final tokens = conduitTokens(context);
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

Color conduitScrim(BuildContext context, {double opacity = 0.45}) {
  final scrim = Theme.of(context).colorScheme.scrim;
  return scrim.withOpacity(opacity);
}

List<Color> conduitAccentPalette(BuildContext context) {
  final theme = Theme.of(context);
  final tokens = conduitTokens(context);
  return [
    tokens?.primary ?? theme.colorScheme.primary,
    tokens?.secondary ?? theme.colorScheme.secondary,
    tokens?.info ?? theme.colorScheme.primaryContainer,
    tokens?.warning ?? theme.colorScheme.tertiary,
    tokens?.error ?? theme.colorScheme.error,
  ];
}

