import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildBubbleControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _BubbleControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _BubbleControl extends StatefulWidget {
  const _BubbleControl({
    required this.controlId,
    required this.props,
    required this.rawChildren,
    required this.buildChild,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final List<dynamic> rawChildren;
  final Widget Function(Map<String, Object?> child) buildChild;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_BubbleControl> createState() => _BubbleControlState();
}

class _BubbleControlState extends State<_BubbleControl> {
  late Map<String, Object?> _state;

  @override
  void initState() {
    super.initState();
    _state = {...widget.props};
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _BubbleControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    if (oldWidget.props != widget.props) {
      _state = {...widget.props};
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_props':
        setState(() {
          _state = {..._state, ...args};
        });
        return _state;
      case 'get_state':
        return _state;
      case 'emit':
        final event = (args['event'] ?? 'click').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        _emit(event, payload);
        return null;
      default:
        throw UnsupportedError('Unknown bubble method: $method');
    }
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  List<Widget> _children() {
    final out = <Widget>[];
    for (final raw in widget.rawChildren) {
      if (raw is Map) {
        out.add(widget.buildChild(coerceObjectMap(raw)));
      }
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final dense = _state['dense'] == true || _state['compact'] == true;
    final dividerLabel = (_state['divider_label'] ?? '').toString();
    final dividerColor = coerceColor(_state['divider_color']) ?? Colors.white24;
    final mentionLabel = (_state['mention_label'] ?? '').toString();
    final mentionColor =
        coerceColor(_state['mention_color']) ?? const Color(0xff2563eb);
    final mentionTextColor =
        coerceColor(_state['mention_text_color']) ?? Colors.white;
    final mentionClickable = _state['mention_clickable'] == true;
    final author = (_state['author'] ?? '').toString();
    final timestamp = (_state['timestamp'] ?? '').toString();
    final status = (_state['status'] ?? '').toString();
    final edited = _state['edited'] == true;
    final pinned = _state['pinned'] == true;
    final title = (_state['title'] ?? '').toString();
    final subtitle = (_state['subtitle'] ?? '').toString();
    final text = (_state['text'] ?? '').toString();
    final quoteText = (_state['quote_text'] ?? '').toString();
    final quoteAuthor = (_state['quote_author'] ?? '').toString();
    final quoteTimestamp = (_state['quote_timestamp'] ?? '').toString();
    final reactionsRaw = _state['reactions'];
    final reactionItems = <String>[];
    if (reactionsRaw is List) {
      for (final item in reactionsRaw) {
        if (item == null) continue;
        if (item is Map) {
          final map = coerceObjectMap(item);
          final label = (map['label'] ?? map['emoji'] ?? '').toString();
          final count = map['count'];
          reactionItems.add(count == null ? label : '$label $count');
        } else {
          reactionItems.add(item.toString());
        }
      }
    }

    final body = <Widget>[];
    if (dividerLabel.isNotEmpty) {
      body.add(
        Padding(
          padding: EdgeInsets.only(bottom: dense ? 6 : 10),
          child: Row(
            children: [
              Expanded(child: Divider(height: 1, color: dividerColor)),
              const SizedBox(width: 8),
              Text(
                dividerLabel,
                style: TextStyle(
                  fontSize: dense ? 11 : 12,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(child: Divider(height: 1, color: dividerColor)),
            ],
          ),
        ),
      );
    }

    if (mentionLabel.isNotEmpty) {
      Widget mention = Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: mentionColor,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(mentionLabel, style: TextStyle(color: mentionTextColor)),
      );
      if (mentionClickable) {
        mention = InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () => _emit('mention_click', {'label': mentionLabel}),
          child: mention,
        );
      }
      body.add(
        Padding(
          padding: EdgeInsets.only(bottom: dense ? 6 : 10),
          child: mention,
        ),
      );
    }

    final metaParts = <String>[];
    if (timestamp.isNotEmpty) metaParts.add(timestamp);
    if (status.isNotEmpty) metaParts.add(status);
    if (edited) metaParts.add('edited');
    if (pinned) metaParts.add('pinned');

    final cardChildren = <Widget>[];
    if (author.isNotEmpty || metaParts.isNotEmpty) {
      cardChildren.add(
        Row(
          children: [
            if (author.isNotEmpty)
              Expanded(
                child: Text(
                  author,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            if (metaParts.isNotEmpty)
              Text(
                metaParts.join(' • '),
                style: TextStyle(
                  fontSize: dense ? 10 : 11,
                  color: Colors.white70,
                ),
              ),
          ],
        ),
      );
    }
    if (title.isNotEmpty) {
      cardChildren.add(
        Padding(
          padding: EdgeInsets.only(
            top: cardChildren.isEmpty ? 0 : (dense ? 4 : 6),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: dense ? 13 : 15,
            ),
          ),
        ),
      );
    }
    if (subtitle.isNotEmpty) {
      cardChildren.add(
        Padding(
          padding: EdgeInsets.only(top: dense ? 2 : 4),
          child: Text(
            subtitle,
            style: TextStyle(color: Colors.white70, fontSize: dense ? 11 : 12),
          ),
        ),
      );
    }
    if (text.isNotEmpty) {
      cardChildren.add(
        Padding(
          padding: EdgeInsets.only(top: dense ? 6 : 8),
          child: Text(text),
        ),
      );
    }

    if (quoteText.isNotEmpty || quoteAuthor.isNotEmpty) {
      cardChildren.add(
        Container(
          margin: EdgeInsets.only(top: dense ? 6 : 10),
          padding: EdgeInsets.symmetric(
            horizontal: dense ? 8 : 10,
            vertical: dense ? 6 : 8,
          ),
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: Colors.white30, width: 3)),
            color: Colors.white.withValues(alpha: 0.03),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (quoteAuthor.isNotEmpty)
                Text(
                  quoteAuthor,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              if (quoteText.isNotEmpty) Text(quoteText),
              if (quoteTimestamp.isNotEmpty)
                Text(
                  quoteTimestamp,
                  style: TextStyle(
                    fontSize: dense ? 10 : 11,
                    color: Colors.white70,
                  ),
                ),
            ],
          ),
        ),
      );
    }

    if (reactionItems.isNotEmpty) {
      cardChildren.add(
        Padding(
          padding: EdgeInsets.only(top: dense ? 6 : 10),
          child: Wrap(
            spacing: dense ? 4 : 6,
            runSpacing: dense ? 4 : 6,
            children: reactionItems
                .map(
                  (label) => Chip(
                    label: Text(
                      label,
                      style: TextStyle(fontSize: dense ? 11 : 12),
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        ),
      );
    }

    cardChildren.addAll(_children());

    body.add(
      InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: widget.controlId.isEmpty ? null : () => _emit('click', _state),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(dense ? 10 : 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: cardChildren,
          ),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: body,
    );
  }
}
