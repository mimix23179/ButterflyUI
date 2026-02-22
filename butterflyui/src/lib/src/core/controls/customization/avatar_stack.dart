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
  late List<String> _labels;

  @override
  void initState() {
    super.initState();
    _labels = _coerceAvatarLabels(widget.props['avatars']);
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant _AvatarStackControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
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
        return List<String>.from(_labels);
      case 'set_avatars':
        setState(() {
          _labels = _coerceAvatarLabels(args['avatars']);
        });
        widget.sendEvent(widget.controlId, 'change', {'avatars': _labels});
        return _labels;
      default:
        throw UnsupportedError('Unknown avatar_stack method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final labels = _labels.isEmpty ? const ['A', 'B', 'C'] : _labels;
    final maxItems = coerceOptionalInt(widget.props['max']) ?? labels.length;
    final visible = labels.take(maxItems).toList(growable: false);
    final size = coerceDouble(widget.props['size']) ?? 28;
    final overlap = coerceDouble(widget.props['overlap']) ?? 8;

    return SizedBox(
      height: size,
      child: Stack(
        children: [
          for (var i = 0; i < visible.length; i += 1)
            Positioned(
              left: i * (size - overlap),
              child: InkWell(
                onTap: () {
                  widget.sendEvent(widget.controlId, 'select', {
                    'index': i,
                    'label': visible[i],
                  });
                },
                child: CircleAvatar(
                  radius: size / 2,
                  child: Text(visible[i].substring(0, 1).toUpperCase()),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

List<String> _coerceAvatarLabels(Object? avatarsRaw) {
  final avatarLabels = <String>[];
  if (avatarsRaw is List) {
    for (final item in avatarsRaw) {
      if (item is Map) {
        final label = (item['label'] ?? item['name'] ?? item['text'] ?? '')
            .toString()
            .trim();
        if (label.isNotEmpty) {
          avatarLabels.add(label);
        }
      } else {
        final text = item?.toString().trim() ?? '';
        if (text.isNotEmpty) {
          avatarLabels.add(text);
        }
      }
    }
  }
  return avatarLabels;
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
