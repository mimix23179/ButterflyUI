import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class _AvatarStackControl extends StatefulWidget {
  const _AvatarStackControl({
    required this.controlId,
    required this.props,
    required this.sendEvent,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;

  @override
  State<_AvatarStackControl> createState() => _AvatarStackControlState();
}

class _AvatarStackControlState extends State<_AvatarStackControl> {
  late List<Map<String, Object?>> _avatars;

  @override
  void initState() {
    super.initState();
    _avatars = _coerceAvatars(widget.props['avatars']);
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant _AvatarStackControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
    if (oldWidget.props != widget.props) {
      setState(() {
        _avatars = _coerceAvatars(widget.props['avatars']);
      });
    }
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'get_avatars':
        return List<Map<String, Object?>>.from(_avatars);
      case 'set_avatars':
        setState(() {
          _avatars = _coerceAvatars(args['avatars']);
        });
        widget.sendEvent(widget.controlId, 'change', {'avatars': _avatars});
        return _avatars;
      default:
        throw UnsupportedError('Unknown avatar_stack method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatars = _avatars.isEmpty
        ? const <Map<String, Object?>>[
            {'label': 'A'},
            {'label': 'B'},
            {'label': 'C'},
          ]
        : _avatars;
    final maxItems = (coerceOptionalInt(widget.props['max'] ?? widget.props['max_visible'] ?? widget.props['max_count']) ?? avatars.length)
        .clamp(1, 9999);
    final showOverflow = avatars.length > maxItems;
    final visible = avatars.take(maxItems).toList(growable: false);
    final size = coerceDouble(widget.props['size']) ?? 28;
    final overlap = coerceDouble(widget.props['overlap']) ?? 8;
    final reverse = (widget.props['stack_order']?.toString().toLowerCase() == 'reverse');
    final rendered = reverse ? visible.reversed.toList(growable: false) : visible;
    final totalSlots = rendered.length + (showOverflow ? 1 : 0);
    final width = size + ((totalSlots - 1) * (size - overlap));
    final overflowLabel = widget.props['overflow_label']?.toString();

    return SizedBox(
      width: width,
      height: size,
      child: Stack(
        children: [
          for (var i = 0; i < rendered.length; i += 1)
            Positioned(
              left: i * (size - overlap),
              child: InkWell(
                onTap: () {
                  final avatar = rendered[i];
                  widget.sendEvent(widget.controlId, 'select', {
                    'index': i,
                    'avatar': avatar,
                    'id': avatar['id']?.toString(),
                    'label': _avatarLabel(avatar),
                  });
                },
                child: _AvatarBubble(size: size, avatar: rendered[i]),
              ),
            ),
          if (showOverflow)
            Positioned(
              left: rendered.length * (size - overlap),
              child: CircleAvatar(
                radius: size / 2,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Text(
                  overflowLabel == null || overflowLabel.isEmpty
                      ? '+${avatars.length - maxItems}'
                      : overflowLabel,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AvatarBubble extends StatelessWidget {
  const _AvatarBubble({required this.size, required this.avatar});

  final double size;
  final Map<String, Object?> avatar;

  @override
  Widget build(BuildContext context) {
    final background = coerceColor(avatar['color'] ?? avatar['bgcolor']) ??
        Theme.of(context).colorScheme.primaryContainer;
    final foreground = coerceColor(avatar['text_color'] ?? avatar['foreground']) ??
        Theme.of(context).colorScheme.onPrimaryContainer;
    final label = _avatarLabel(avatar);
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: background,
      child: Text(
        label.isEmpty ? '?' : label.substring(0, 1).toUpperCase(),
        style: TextStyle(color: foreground),
      ),
    );
  }
}

List<Map<String, Object?>> _coerceAvatars(Object? avatarsRaw) {
  final avatars = <Map<String, Object?>>[];
  if (avatarsRaw is List) {
    for (final item in avatarsRaw) {
      if (item is Map) {
        final avatar = coerceObjectMap(item);
        if (_avatarLabel(avatar).isNotEmpty) {
          avatars.add(avatar);
        }
      } else {
        final text = item?.toString().trim() ?? '';
        if (text.isNotEmpty) {
          avatars.add({'label': text});
        }
      }
    }
  }
  return avatars;
}

String _avatarLabel(Map<String, Object?> avatar) {
  return (avatar['label'] ?? avatar['name'] ?? avatar['text'] ?? '')
      .toString()
      .trim();
}

Widget buildAvatarStackControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _AvatarStackControl(
    controlId: controlId,
    props: props,
    sendEvent: sendEvent,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
  );
}
