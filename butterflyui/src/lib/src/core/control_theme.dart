import 'package:flutter/material.dart';

import 'candy/theme_extension.dart';

ButterflyUIThemeTokens? butterflyuiTokens(BuildContext context) {
  return Theme.of(context).extension<ButterflyUIThemeTokens>();
}

Color butterflyuiBackground(BuildContext context) {
  final theme = Theme.of(context);
  final tokens = butterflyuiTokens(context);
  return tokens?.background ?? theme.colorScheme.background;
}

Color butterflyuiSurface(BuildContext context) {
  final theme = Theme.of(context);
  final tokens = butterflyuiTokens(context);
  return tokens?.surface ?? theme.colorScheme.surface;
}

Color butterflyuiSurfaceAlt(BuildContext context) {
  final theme = Theme.of(context);
  final tokens = butterflyuiTokens(context);
  return tokens?.surfaceAlt ?? theme.colorScheme.surfaceVariant;
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
  return scrim.withOpacity(opacity);
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

