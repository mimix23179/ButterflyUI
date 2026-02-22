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
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;

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
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
  });

  @override
  State<ButterflyUIMessageComposer> createState() => _ButterflyUIMessageComposerState();
}

class _ButterflyUIMessageComposerState extends State<ButterflyUIMessageComposer> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.value,
  );
  late final FocusNode _focusNode = FocusNode();
  Timer? _debounce;
  bool _suppressChange = false;
  late bool _enabled = widget.enabled;

  @override
  void initState() {
    super.initState();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

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
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    _enabled = widget.enabled;
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
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
    if (!_enabled) {
      return;
    }
    final value = _controller.text;
    widget.sendEvent(widget.controlId, 'submit', {'value': value});
    if (widget.clearOnSend) {
      _suppressChange = true;
      _controller.clear();
      _suppressChange = false;
      if (widget.emitOnChange) {
        widget.sendEvent(widget.controlId, 'change', {'value': ''});
      }
    }
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'get_value':
        return _controller.text;
      case 'set_value':
        final value = (args['value'] ?? '').toString();
        _suppressChange = true;
        _controller.value = _controller.value.copyWith(
          text: value,
          selection: TextSelection.collapsed(offset: value.length),
        );
        _suppressChange = false;
        return _controller.text;
      case 'submit':
        _submit();
        return null;
      case 'focus':
        if (mounted) {
          _focusNode.requestFocus();
        }
        return null;
      case 'blur':
        if (mounted) {
          FocusScope.of(context).unfocus();
        }
        return null;
      case 'attach':
        if (widget.showAttach) {
          widget.sendEvent(widget.controlId, 'attach', {});
        }
        return null;
      case 'set_enabled':
        setState(() {
          _enabled = args['enabled'] == true;
        });
        return _enabled;
      default:
        throw UnsupportedError('Unknown prompt_composer method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            enabled: _enabled,
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
              onPressed: _enabled
                  ? () => widget.sendEvent(widget.controlId, 'attach', {})
                  : null,
              icon: const Icon(Icons.attach_file_rounded),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: FilledButton(
            onPressed: _enabled ? _submit : null,
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
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
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
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
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
