import 'dart:async';

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildChatMessageControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final text = (props['text'] ?? props['value'] ?? props['message'] ?? '')
      .toString();
  final role = (props['role'] ?? '').toString().toLowerCase();
  final name = (props['name'] ?? '').toString();
  final showName = props['show_name'] == true && name.isNotEmpty;
  final clickable = props['clickable'] == true;
  final align = (props['align']?.toString().toLowerCase() ?? '').trim();
  final isUser = role == 'user' || align == 'right' || align == 'end';
  final bubbleBg =
      coerceColor(props['bgcolor']) ??
      (isUser ? const Color(0xff1d4ed8) : const Color(0xff111827));
  final bubbleFg = coerceColor(props['text_color']) ?? const Color(0xffe5e7eb);
  final radius = coerceDouble(props['radius']) ?? 14;
  final borderWidth = coerceDouble(props['border_width']) ?? 0.0;
  final borderColor = coerceColor(props['border_color']);
  final outerAlignment = isUser ? Alignment.centerRight : Alignment.centerLeft;

  Widget bubble = Container(
    constraints: const BoxConstraints(maxWidth: 700),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: bubbleBg,
      borderRadius: BorderRadius.circular(radius),
      border: borderColor != null && borderWidth > 0
          ? Border.all(color: borderColor, width: borderWidth)
          : null,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showName)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              name,
              style: TextStyle(
                color: bubbleFg.withOpacity(0.75),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        Text(text, style: TextStyle(color: bubbleFg, height: 1.35)),
      ],
    ),
  );

  if (clickable && controlId.isNotEmpty) {
    bubble = InkWell(
      borderRadius: BorderRadius.circular(radius),
      onTap: () {
        sendEvent(controlId, 'click', {
          'role': role,
          'name': name,
          'text': text,
        });
      },
      child: bubble,
    );
  }

  return Align(alignment: outerAlignment, child: bubble);
}

Widget buildChatThreadControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final spacing = coerceDouble(props['spacing']) ?? 8;
  final padding =
      coercePadding(props['padding'] ?? props['content_padding']) ??
      const EdgeInsets.all(8);
  final reverse = props['reverse'] == true;
  final scrollable = props['scrollable'] == null
      ? true
      : (props['scrollable'] == true);

  final children = <Widget>[];
  for (final raw in rawChildren) {
    if (raw is Map) {
      children.add(buildChild(coerceObjectMap(raw)));
    }
  }

  if (children.isEmpty && props['messages'] is List) {
    final messages = props['messages'] as List;
    for (var i = 0; i < messages.length; i += 1) {
      final message = messages[i];
      if (message is Map) {
        final map = coerceObjectMap(message);
        final entryId =
            map['id']?.toString() ??
            map['message_id']?.toString() ??
            '$controlId-$i';
        children.add(buildChatMessageControl(entryId, map, sendEvent));
      } else if (message != null) {
        children.add(
          buildChatMessageControl('$controlId-$i', {
            'text': message.toString(),
            'role': 'assistant',
          }, sendEvent),
        );
      }
    }
  }

  if (children.isEmpty) {
    return const SizedBox.shrink();
  }

  if (!scrollable) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _withSpacing(children, spacing),
      ),
    );
  }

  return ListView(
    reverse: reverse,
    shrinkWrap: true,
    padding: padding,
    children: _withSpacing(children, spacing),
  );
}

class ButterflyUIMessageComposer extends StatefulWidget {
  final String controlId;
  final String value;
  final bool enabled;
  final bool emitOnChange;
  final bool clearOnSend;
  final int debounceMs;
  final int minLines;
  final int maxLines;
  final String placeholder;
  final String sendLabel;
  final bool showAttach;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUIMessageComposer({
    super.key,
    required this.controlId,
    required this.value,
    required this.enabled,
    required this.emitOnChange,
    required this.clearOnSend,
    required this.debounceMs,
    required this.minLines,
    required this.maxLines,
    required this.placeholder,
    required this.sendLabel,
    required this.showAttach,
    required this.sendEvent,
  });

  @override
  State<ButterflyUIMessageComposer> createState() => _ButterflyUIMessageComposerState();
}

class _ButterflyUIMessageComposerState extends State<ButterflyUIMessageComposer> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.value,
  );
  Timer? _debounce;
  bool _suppressChange = false;

  @override
  void didUpdateWidget(covariant ButterflyUIMessageComposer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _suppressChange = true;
      _controller.value = _controller.value.copyWith(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
      _suppressChange = false;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _emitChange(String value) {
    if (_suppressChange || !widget.emitOnChange) return;
    _debounce?.cancel();
    if (widget.debounceMs <= 0) {
      widget.sendEvent(widget.controlId, 'change', {'value': value});
      return;
    }
    _debounce = Timer(Duration(milliseconds: widget.debounceMs), () {
      widget.sendEvent(widget.controlId, 'change', {'value': value});
    });
  }

  void _submit() {
    final value = _controller.text;
    if (value.trim().isEmpty) return;
    widget.sendEvent(widget.controlId, 'submit', {'value': value});
    if (widget.clearOnSend) {
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            enabled: widget.enabled,
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            keyboardType: TextInputType.multiline,
            onChanged: _emitChange,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              hintText: widget.placeholder,
              isDense: true,
            ),
          ),
        ),
        if (widget.showAttach)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: IconButton(
              onPressed: widget.enabled
                  ? () => widget.sendEvent(widget.controlId, 'attach', {})
                  : null,
              icon: const Icon(Icons.attach_file_rounded),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: FilledButton(
            onPressed: widget.enabled ? _submit : null,
            child: Text(widget.sendLabel),
          ),
        ),
      ],
    );
  }
}

Widget buildMessageComposerControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final showAttach =
      props['show_attachments'] == true || props['show_attach'] == true;
  return ButterflyUIMessageComposer(
    controlId: controlId,
    value: (props['value'] ?? '').toString(),
    enabled: props['enabled'] == null ? true : (props['enabled'] == true),
    emitOnChange: props['emit_on_change'] == null
        ? true
        : (props['emit_on_change'] == true),
    clearOnSend: props['clear_on_send'] == null
        ? true
        : (props['clear_on_send'] == true),
    debounceMs: (coerceOptionalInt(props['debounce_ms']) ?? 120).clamp(0, 2000),
    minLines: (coerceOptionalInt(props['min_lines']) ?? 1).clamp(1, 6),
    maxLines: (coerceOptionalInt(props['max_lines']) ?? 6).clamp(1, 24),
    placeholder: (props['placeholder'] ?? 'Message').toString(),
    sendLabel: (props['send_label'] ?? 'Send').toString(),
    showAttach: showAttach,
    sendEvent: sendEvent,
  );
}

List<Widget> _withSpacing(List<Widget> children, double spacing) {
  if (children.isEmpty) return const [];
  if (spacing <= 0) return children;
  final out = <Widget>[];
  for (var i = 0; i < children.length; i += 1) {
    if (i > 0) out.add(SizedBox(height: spacing));
    out.add(children[i]);
  }
  return out;
}
