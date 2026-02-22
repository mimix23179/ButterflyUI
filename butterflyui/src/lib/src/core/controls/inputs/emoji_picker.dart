import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildEmojiPickerControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _EmojiPickerControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _EmojiPickerControl extends StatefulWidget {
  const _EmojiPickerControl({
    required this.controlId,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_EmojiPickerControl> createState() => _EmojiPickerControlState();
}

class _EmojiPickerControlState extends State<_EmojiPickerControl> {
  late String _value;
  late List<String> _emojis;

  @override
  void initState() {
    super.initState();
    _value = (widget.props['value'] ?? '').toString();
    _emojis = _coerceEmojis(widget.props['items'] ?? widget.props['emojis']);
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant _EmojiPickerControl oldWidget) {
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
      case 'get_value':
        return _value;
      case 'set_value':
        final next = (args['value'] ?? '').toString();
        setState(() => _value = next);
        widget.sendEvent(widget.controlId, 'change', {'value': _value});
        return _value;
      case 'emit':
        final event = (args['event'] ?? 'custom').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        widget.sendEvent(widget.controlId, event, payload);
        return true;
      default:
        throw UnsupportedError('Unknown emoji_picker method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final columns = (coerceOptionalInt(widget.props['columns']) ?? 8).clamp(2, 12);
    final spacing = coerceDouble(widget.props['spacing']) ?? 6;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_value.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text('Selected: $_value'),
          ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _emojis.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            mainAxisExtent: 32,
          ),
          itemBuilder: (context, index) {
            final emoji = _emojis[index];
            final selected = emoji == _value;
            return InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                setState(() => _value = emoji);
                widget.sendEvent(widget.controlId, 'select', {
                  'index': index,
                  'value': emoji,
                });
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: selected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outlineVariant,
                    width: selected ? 2 : 1,
                  ),
                ),
                child: Center(child: Text(emoji, style: const TextStyle(fontSize: 18))),
              ),
            );
          },
        ),
      ],
    );
  }
}

List<String> _coerceEmojis(Object? value) {
  if (value is List) {
    final out = <String>[];
    for (final item in value) {
      final text = item?.toString() ?? '';
      if (text.isNotEmpty) out.add(text);
    }
    if (out.isNotEmpty) return out;
  }
  return const [
    '😀',
    '😁',
    '😂',
    '😎',
    '😍',
    '🤖',
    '🎉',
    '✨',
    '🔥',
    '🚀',
    '🌈',
    '🦋',
    '🍀',
    '🍎',
    '⚡',
    '🌟',
    '💫',
    '🌙',
    '🌞',
    '🌊',
    '🌪',     
  ];
}
