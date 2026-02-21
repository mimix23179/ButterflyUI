import 'package:flutter/material.dart';

import 'notification.dart';

class ToastNotificationWidget extends StatelessWidget {
  final NotificationPayload data;
  final VoidCallback onClose;
  final VoidCallback onAction;

  const ToastNotificationWidget({super.key, required this.data, required this.onClose, required this.onAction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surface;
    final onSurface = theme.colorScheme.onSurface;
    final resolvedStyle = (data.style ?? '').isEmpty ? 'card' : data.style!;
    final onPrimary = theme.colorScheme.onPrimary;

    Color background = surface;
    Color border = theme.dividerColor;
    Color accent = Theme.of(context).colorScheme.primary;
    Color foreground = onSurface;
    Color headerColor = accent;

    switch (resolvedStyle) {
      case 'solid':
        background = accent;
        border = accent.withOpacity(0.8);
        foreground = onPrimary;
        headerColor = onPrimary;
        break;
      case 'soft':
        background = accent.withOpacity(0.12);
        border = accent.withOpacity(0.4);
        headerColor = accent;
        break;
      case 'outline':
        background = surface;
        border = accent;
        headerColor = accent;
        break;
      case 'glass':
        background = surface.withOpacity(0.82);
        border = accent.withOpacity(0.35);
        headerColor = accent;
        break;
      case 'card':
      default:
        background = surface;
        border = theme.dividerColor;
        headerColor = accent;
        break;
    }

    final icon = data.icon;
    final variantKey = _normalizeKey(data.variant);
    final headerText = (data.label != null && data.label!.isNotEmpty)
        ? data.label!
        : (variantKey.isEmpty ? 'Conduit' : 'Conduit / ${_titleCase(variantKey)}');

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.18),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Icon(icon, color: accent),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(headerText, style: theme.textTheme.labelSmall?.copyWith(color: headerColor)),
                  const SizedBox(height: 2),
                  Text(data.message, style: theme.textTheme.bodyMedium?.copyWith(color: foreground)),
                  if (data.actionLabel != null && data.actionLabel!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    TextButton(
                      onPressed: onAction,
                      style: TextButton.styleFrom(foregroundColor: accent),
                      child: Text(data.actionLabel!),
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.close, color: foreground),
              onPressed: onClose,
              splashRadius: 18,
            ),
          ],
        ),
      ),
    );
  }

  String _normalizeKey(String? value) {
    return value?.toString().toLowerCase().trim() ?? '';
  }

  String _titleCase(String value) {
    final parts = value.split(RegExp(r'[_\s-]+'));
    final titled = parts.map((part) {
      if (part.isEmpty) return '';
      return '${part[0].toUpperCase()}${part.substring(1)}';
    }).where((part) => part.isNotEmpty);
    return titled.join(' ');
  }
}

