import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildAvatarControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final source = (props['src'] ?? props['image'])?.toString() ?? '';
  final size = coerceDouble(props['size']);
  final radius =
      coerceDouble(props['radius']) ?? (size == null ? 20.0 : size / 2.0);
  final fgColor = coerceColor(props['color']);
  final bgColor =
      coerceColor(props['bgcolor'] ?? props['background'] ?? props['color']);
  final iconName = props['icon']?.toString();
  final label = props['label']?.toString() ?? props['name']?.toString() ?? '';
  final initials = _resolveInitials(props, label);
  final status = props['status']?.toString();
  final enabled = props['enabled'] == null ? true : (props['enabled'] == true);

  final imageProvider = source.isEmpty ? null : resolveImageProvider(source);
  final avatar = CircleAvatar(
    radius: radius,
    backgroundColor: bgColor,
    foregroundColor: fgColor,
    backgroundImage: imageProvider,
    child: imageProvider != null
        ? null
        : _avatarInner(iconName: iconName, initials: initials, radius: radius),
  );

  Widget built = avatar;
  if (status != null && status.isNotEmpty) {
    built = Stack(
      clipBehavior: Clip.none,
      children: [
        avatar,
        Positioned(
          right: -1,
          bottom: -1,
          child: _StatusDot(status: status, size: radius * 0.5),
        ),
      ],
    );
  }

  if (!enabled || controlId.isEmpty) return built;
  return InkWell(
    borderRadius: BorderRadius.circular(radius + 4),
    onTap: () {
      final payload = <String, Object?>{
        'name': label,
        'src': source,
      };
      if (status != null) {
        payload['status'] = status;
      }
      sendEvent(controlId, 'click', payload);
    },
    child: built,
  );
}

Widget _avatarInner({
  required String? iconName,
  required String initials,
  required double radius,
}) {
  if (iconName != null && iconName.isNotEmpty) {
    return Icon(_iconFromName(iconName), size: radius);
  }
  final text = initials.isEmpty ? '?' : initials;
  return Text(
    text,
    style: TextStyle(
      fontSize: radius * 0.75,
      fontWeight: FontWeight.w600,
    ),
  );
}

String _resolveInitials(Map<String, Object?> props, String name) {
  final explicit = props['initials']?.toString();
  if (explicit != null && explicit.trim().isNotEmpty) {
    return explicit.trim().toUpperCase();
  }
  final parts = name
      .split(RegExp(r'\s+'))
      .where((part) => part.trim().isNotEmpty)
      .toList(growable: false);
  if (parts.isEmpty) return '';
  if (parts.length == 1) {
    return parts.first.substring(0, 1).toUpperCase();
  }
  final first = parts.first.substring(0, 1);
  final last = parts.last.substring(0, 1);
  return '$first$last'.toUpperCase();
}

IconData _iconFromName(String value) {
  switch (value.toLowerCase().replaceAll('-', '_')) {
    case 'person':
    case 'user':
      return Icons.person_outline;
    case 'bot':
    case 'robot':
      return Icons.smart_toy_outlined;
    case 'group':
    case 'team':
      return Icons.groups_outlined;
    default:
      return Icons.account_circle_outlined;
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.status, required this.size});

  final String status;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.white, width: 1.5),
        shape: BoxShape.circle,
      ),
    );
  }

  Color _statusColor(String value) {
    switch (value.toLowerCase()) {
      case 'online':
      case 'success':
      case 'active':
        return const Color(0xFF22C55E);
      case 'away':
      case 'warning':
        return const Color(0xFFF59E0B);
      case 'busy':
      case 'error':
      case 'offline':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF94A3B8);
    }
  }
}
