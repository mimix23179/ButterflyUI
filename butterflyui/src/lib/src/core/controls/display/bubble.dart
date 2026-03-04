import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

final Map<String, String> _bubbleDraftStore = <String, String>{};

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
  late final TextEditingController _composerController;
  late final FocusNode _composerFocusNode;
  late final ScrollController _threadController;
  bool _reachTopNotified = false;
  bool _atBottom = true;
  int _lastMessageCount = 0;
  DateTime? _cooldownUntil;

  @override
  void initState() {
    super.initState();
    _state = {...widget.props};
    _composerController = TextEditingController();
    _composerFocusNode = FocusNode();
    _threadController = ScrollController();
    _syncComposerFromState(force: true);
    _lastMessageCount = _messages().length;
    _composerController.addListener(_onComposerChanged);
    _composerFocusNode.addListener(_onComposerFocusChange);
    _threadController.addListener(_onThreadScroll);
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom(animated: false);
    });
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
      _syncComposerFromState();
      _handleThreadAutoScroll();
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    _threadController.dispose();
    _composerFocusNode.dispose();
    _composerController.dispose();
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
          _syncComposerFromState();
          _handleThreadAutoScroll();
        });
        return _statePayload();
      case 'get_state':
        return _statePayload();
      case 'set_value':
        final value = (args['value'] ?? '').toString();
        _setComposerValue(value, notify: false);
        _state['value'] = value;
        return _statePayload();
      case 'submit':
        _submitComposer();
        return _statePayload();
      case 'append_message':
        final rawMessage = args['message'];
        if (rawMessage is Map) {
          final list = _messagesRawMutable();
          list.add(coerceObjectMap(rawMessage));
          _state['messages'] = list;
          _state['items'] = list;
          setState(() {
            _handleThreadAutoScroll(force: true);
          });
        }
        return _statePayload();
      case 'prepend_messages':
        final rawMessages = args['messages'];
        if (rawMessages is List) {
          final prepend = <Object?>[];
          for (final item in rawMessages) {
            if (item is Map) prepend.add(coerceObjectMap(item));
          }
          final list = _messagesRawMutable();
          _state['messages'] = <Object?>[...prepend, ...list];
          _state['items'] = _state['messages'];
          setState(() {});
        }
        return _statePayload();
      case 'jump_to_bottom':
        _scrollToBottom(
          animated: _coerceBool(args['animated'], fallback: true),
        );
        return _statePayload();
      case 'jump_to_message':
        _jumpToMessage(
          messageId: args['message_id']?.toString(),
          index: coerceOptionalInt(args['index']),
          align: args['align']?.toString(),
          animated: _coerceBool(args['animated'], fallback: true),
        );
        return _statePayload();
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

  Map<String, Object?> _statePayload() {
    final messages = _messagesRawMutable();
    return <String, Object?>{
      ..._state,
      'value': _composerController.text,
      'at_bottom': _atBottom,
      'messages': messages,
      'items': messages,
    };
  }

  void _onComposerChanged() {
    _state['value'] = _composerController.text;
    _persistDraft(_composerController.text);
    if (_state['emit_on_change'] == true) {
      _emit('change', {'value': _composerController.text});
    }
    setState(() {});
  }

  void _onComposerFocusChange() {
    _emit(_composerFocusNode.hasFocus ? 'focus' : 'blur', {
      'value': _composerController.text,
      'focused': _composerFocusNode.hasFocus,
    });
  }

  void _onThreadScroll() {
    if (!_threadController.hasClients) return;
    final pos = _threadController.position;
    final atTop = pos.pixels <= 24;
    if (atTop && !_reachTopNotified) {
      _reachTopNotified = true;
      _emit('reach_top', {'offset': pos.pixels});
    } else if (!atTop && _reachTopNotified) {
      _reachTopNotified = false;
    }
    final nextAtBottom = (pos.maxScrollExtent - pos.pixels) <= 28;
    if (_atBottom != nextAtBottom) {
      _atBottom = nextAtBottom;
      _emit('scroll_state_changed', {
        'at_bottom': _atBottom,
        'offset': pos.pixels,
        'max': pos.maxScrollExtent,
      });
      setState(() {});
    }
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  String? _draftKey() {
    final key = _state['draft_key']?.toString();
    if (key == null || key.isEmpty) return null;
    return key;
  }

  void _persistDraft(String value) {
    final key = _draftKey();
    if (key == null) return;
    _bubbleDraftStore[key] = value;
  }

  void _syncComposerFromState({bool force = false}) {
    final key = _draftKey();
    String? incoming;
    final rawValue = _state['value'] ?? _state['text'];
    if (rawValue != null) {
      incoming = rawValue.toString();
    } else if (key != null) {
      incoming = _bubbleDraftStore[key];
    }
    incoming ??= '';
    if (force || _composerController.text != incoming) {
      _setComposerValue(incoming, notify: false);
    }
  }

  void _setComposerValue(String value, {required bool notify}) {
    _composerController.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
      composing: TextRange.empty,
    );
    if (notify) {
      _emit('change', {'value': value});
    }
  }

  bool _isRateLimited() {
    final until = _cooldownUntil;
    if (until == null) return false;
    return DateTime.now().isBefore(until);
  }

  void _submitComposer() {
    if (_state['disabled'] == true || _state['read_only'] == true) return;
    if (_isRateLimited()) {
      _emit('rate_limited', {'until': _cooldownUntil?.toIso8601String()});
      return;
    }
    final value = _composerController.text;
    if (value.trim().isEmpty) return;
    _emit('submit', {'value': value, 'char_count': value.characters.length});
    final cooldownMs = coerceOptionalInt(_state['cooldown_ms']) ?? 0;
    if (cooldownMs > 0) {
      _cooldownUntil = DateTime.now().add(Duration(milliseconds: cooldownMs));
    }
    if (_state['clear_on_send'] == true) {
      _setComposerValue('', notify: false);
      final key = _draftKey();
      if (key != null) _bubbleDraftStore.remove(key);
    }
    setState(() {});
  }

  List<Map<String, Object?>> _messages() {
    final source = _state['messages'] is List
        ? _state['messages']
        : _state['items'];
    if (source is! List) return const <Map<String, Object?>>[];
    final out = <Map<String, Object?>>[];
    for (final item in source) {
      if (item is Map) out.add(coerceObjectMap(item));
    }
    return out;
  }

  List<Object?> _messagesRawMutable() {
    final source = _state['messages'] is List
        ? _state['messages']
        : _state['items'];
    if (source is! List) return <Object?>[];
    return List<Object?>.from(source);
  }

  List<Map<String, Object?>> _pinnedMessages() {
    final raw = _state['pinned_messages'];
    if (raw is! List) return const <Map<String, Object?>>[];
    final out = <Map<String, Object?>>[];
    for (final item in raw) {
      if (item is Map) out.add(coerceObjectMap(item));
    }
    return out;
  }

  bool _followLatest() {
    final autoscroll = _state['autoscroll']?.toString().toLowerCase();
    if (autoscroll == 'follow_latest' || autoscroll == 'follow') return true;
    if (autoscroll == 'manual' || autoscroll == 'off') return false;
    if (_state['follow_latest'] != null) return _state['follow_latest'] == true;
    return true;
  }

  void _handleThreadAutoScroll({bool force = false}) {
    final count = _messages().length;
    final changed = count != _lastMessageCount;
    _lastMessageCount = count;
    if (!force && !changed) return;
    if (!_followLatest()) return;
    if (!_atBottom && !force) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom(animated: true);
    });
  }

  void _scrollToBottom({required bool animated}) {
    if (!_threadController.hasClients) return;
    final target = _threadController.position.maxScrollExtent;
    if (animated) {
      _threadController.animateTo(
        target,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
      );
    } else {
      _threadController.jumpTo(target);
    }
    _emit('jump_bottom', {'animated': animated});
  }

  void _jumpToMessage({
    String? messageId,
    int? index,
    String? align,
    required bool animated,
  }) {
    final messages = _messages();
    var resolvedIndex = index ?? -1;
    if (resolvedIndex < 0 && messageId != null && messageId.isNotEmpty) {
      for (var i = 0; i < messages.length; i += 1) {
        final id = (messages[i]['id'] ?? '').toString();
        if (id == messageId) {
          resolvedIndex = i;
          break;
        }
      }
    }
    if (resolvedIndex < 0 || !_threadController.hasClients) return;
    final estimatedRowHeight = switch (_density()) {
      _BubbleDensity.compact => 86.0,
      _BubbleDensity.normal => 104.0,
      _BubbleDensity.cozy => 122.0,
    };
    final viewport = _threadController.position.viewportDimension;
    final max = _threadController.position.maxScrollExtent;
    var target = resolvedIndex * estimatedRowHeight;
    if ((align ?? '').toLowerCase() == 'center') {
      target = math.max(0, target - (viewport * 0.35));
    }
    target = target.clamp(0, max);
    if (animated) {
      _threadController.animateTo(
        target,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
      );
    } else {
      _threadController.jumpTo(target);
    }
    _emit('jump', {
      'message_id': messageId,
      'index': resolvedIndex,
      'align': align ?? 'start',
      'animated': animated,
    });
  }

  List<Widget> _extraChildren() {
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
    final variant = (_state['variant'] ?? 'message').toString().toLowerCase();
    switch (variant) {
      case 'composer':
        return _buildComposerSurface(integrated: false);
      case 'thread':
      case 'chat':
        return _buildThreadSurface();
      default:
        return _buildMessageSurface(
          _state,
          allowTap: _state['clickable'] == true,
        );
    }
  }

  Widget _buildThreadSurface() {
    final density = _density();
    final spacing =
        coerceDouble(_state['spacing']) ??
        (density == _BubbleDensity.compact ? 8 : 12);
    final scrollable = _state['scrollable'] != false;
    final reverse = _state['reverse'] == true;
    final rows = <Widget>[];
    final messages = _messages();
    final pinned = _pinnedMessages();

    if (pinned.isNotEmpty) {
      rows.add(
        _sectionLabel(
          (_state['pinned_label'] ?? 'Pinned').toString(),
          icon: Icons.push_pin_rounded,
        ),
      );
      for (var i = 0; i < pinned.length; i += 1) {
        rows.add(_buildMessageSurface(pinned[i], allowTap: true, pinned: true));
        rows.add(SizedBox(height: spacing));
      }
      rows.add(
        _sectionLabel(
          (_state['timeline_label'] ?? 'Messages').toString(),
          icon: Icons.forum_outlined,
        ),
      );
    }

    if (messages.isEmpty) {
      rows.add(_buildEmptyState());
    } else {
      final grouping =
          _state['group_messages'] == true ||
          (_state['grouping']?.toString().toLowerCase() == 'auto');
      final unreadAfterId = (_state['unread_after_id'] ?? '').toString();
      final unreadIndex = coerceOptionalInt(_state['unread_index']);
      final unreadLabel = (_state['unread_divider_label'] ?? 'Unread messages')
          .toString();

      List<Map<String, Object?>> list = messages;
      if (reverse) {
        list = List<Map<String, Object?>>.from(messages.reversed);
      }

      for (var i = 0; i < list.length; i += 1) {
        final item = list[i];
        final previous = i > 0 ? list[i - 1] : null;
        final next = i + 1 < list.length ? list[i + 1] : null;
        final groupedWithPrev = grouping && _sameAuthor(previous, item);
        final groupedWithNext = grouping && _sameAuthor(item, next);

        final separator =
            (item['date_separator'] ??
                    item['separator'] ??
                    item['divider_label'] ??
                    '')
                .toString();
        if (separator.isNotEmpty) {
          rows.add(_threadDivider(separator));
          rows.add(SizedBox(height: density == _BubbleDensity.compact ? 6 : 8));
        }

        final itemId = (item['id'] ?? '').toString();
        final insertUnreadById =
            unreadAfterId.isNotEmpty &&
            previous != null &&
            (previous['id']?.toString() ?? '') == unreadAfterId;
        final insertUnreadByIndex = unreadIndex != null && i == unreadIndex;
        if ((insertUnreadById || insertUnreadByIndex) &&
            unreadLabel.isNotEmpty) {
          rows.add(_threadDivider(unreadLabel, unread: true));
          rows.add(SizedBox(height: density == _BubbleDensity.compact ? 6 : 8));
        }

        rows.add(
          _buildMessageSurface(
            item,
            allowTap: true,
            groupedWithPrev: groupedWithPrev,
            groupedWithNext: groupedWithNext,
            messageId: itemId,
          ),
        );
        if (i < list.length - 1) {
          rows.add(SizedBox(height: spacing));
        }
      }
    }

    final typing = _buildTypingIndicator();
    if (typing != null) {
      rows.add(SizedBox(height: spacing));
      rows.add(typing);
    }
    if (_state['show_input'] == true) {
      rows.add(SizedBox(height: spacing));
      rows.add(_buildComposerSurface(integrated: true));
    }
    rows.addAll(_extraChildren());

    return ListView(
      controller: _threadController,
      shrinkWrap: true,
      physics: scrollable
          ? const ClampingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      children: rows,
    );
  }

  bool _sameAuthor(Map<String, Object?>? a, Map<String, Object?>? b) {
    if (a == null || b == null) return false;
    final aRole = (a['role'] ?? '').toString();
    final bRole = (b['role'] ?? '').toString();
    if (aRole.isNotEmpty && bRole.isNotEmpty) return aRole == bRole;
    final aName = (a['sender_name'] ?? a['author'] ?? a['name'] ?? '')
        .toString();
    final bName = (b['sender_name'] ?? b['author'] ?? b['name'] ?? '')
        .toString();
    return aName.isNotEmpty && aName == bName;
  }

  Widget _buildMessageSurface(
    Map<String, Object?> message, {
    required bool allowTap,
    bool pinned = false,
    bool groupedWithPrev = false,
    bool groupedWithNext = false,
    String? messageId,
  }) {
    final density = _density();
    final maxWidth = coerceDouble(message['max_width'] ?? _state['max_width']);
    final sender =
        (message['sender_name'] ??
                message['author'] ??
                message['name'] ??
                _state['sender_name'] ??
                _state['author'] ??
                '')
            .toString();
    final role = (message['role'] ?? _state['role'] ?? '').toString();
    final align = _resolveAlign(
      (message['align'] ?? _state['align'])?.toString(),
      role,
    );
    final tone = (message['tone'] ?? _state['tone'] ?? 'neutral').toString();
    final dense = density == _BubbleDensity.compact;
    final cozy = density == _BubbleDensity.cozy;
    final text = (message['text'] ?? message['value'] ?? '').toString();
    final markdown = (message['markdown'] ?? '').toString();
    final bodyText = text.isNotEmpty ? text : markdown;
    final title = (message['title'] ?? '').toString();
    final subtitle = (message['subtitle'] ?? '').toString();
    final timestamp = (message['timestamp'] ?? '').toString();
    final edited = message['edited'] == true;
    final delivered = message['delivered'] == true;
    final read = message['read'] == true;
    final status = (message['status'] ?? '').toString();
    final roleBadge = (message['role_badge'] ?? '').toString();
    final selectable =
        message['selectable'] == true || _state['selectable'] == true;
    final quoteText = (message['quote_text'] ?? '').toString();
    final quoteAuthor = (message['quote_author'] ?? '').toString();
    final quoteTimestamp = (message['quote_timestamp'] ?? '').toString();
    final quoteCompact = message['quote_compact'] == true;
    final mentionLabel = (message['mention_label'] ?? '').toString();
    final mentionClickable = message['mention_clickable'] == true;
    final mentionColor =
        coerceColor(message['mention_color']) ?? const Color(0xff2563eb);
    final mentionTextColor =
        coerceColor(message['mention_text_color']) ?? Colors.white;
    final errorNotice = (message['error_notice'] ?? '').toString();
    final notice = (message['notice'] ?? '').toString();
    final dividerLabel = (message['divider_label'] ?? '').toString();
    final dividerColor =
        coerceColor(message['divider_color']) ?? Colors.white24;
    final attachments = _coerceMapList(message['attachments']);
    final actions = _coerceMapList(message['actions']);
    final reactions = _coerceMapList(message['reactions']);

    final headerMeta = <String>[];
    if (timestamp.isNotEmpty) headerMeta.add(timestamp);
    if (status.isNotEmpty) headerMeta.add(status);
    if (edited) headerMeta.add('edited');
    if (delivered) headerMeta.add('delivered');
    if (read) headerMeta.add('read');
    if (pinned) headerMeta.add('pinned');

    final verticalPadding = dense ? 10.0 : (cozy ? 14.0 : 12.0);
    final horizontalPadding = dense ? 10.0 : (cozy ? 14.0 : 12.0);
    final radius = dense ? 12.0 : 16.0;
    final accent = _toneColor(tone);

    final content = <Widget>[];
    if (dividerLabel.isNotEmpty) {
      content.add(_threadDivider(dividerLabel, color: dividerColor));
      content.add(SizedBox(height: dense ? 6 : 8));
    }
    if (mentionLabel.isNotEmpty) {
      Widget mention = Container(
        padding: EdgeInsets.symmetric(
          horizontal: dense ? 8 : 10,
          vertical: dense ? 4 : 5,
        ),
        decoration: BoxDecoration(
          color: mentionColor.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          mentionLabel,
          style: TextStyle(
            color: mentionTextColor,
            fontWeight: FontWeight.w600,
            fontSize: dense ? 11 : 12,
          ),
        ),
      );
      if (mentionClickable) {
        mention = InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () => _emit('mention_click', {'label': mentionLabel}),
          child: mention,
        );
      }
      content.add(mention);
      content.add(SizedBox(height: dense ? 6 : 8));
    }

    final showHeader = !groupedWithPrev || roleBadge.isNotEmpty;
    if (showHeader &&
        (sender.isNotEmpty || headerMeta.isNotEmpty || roleBadge.isNotEmpty)) {
      content.add(
        Row(
          children: [
            if (sender.isNotEmpty)
              Expanded(
                child: Text(
                  sender,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: dense ? 12 : 13,
                  ),
                ),
              ),
            if (roleBadge.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: accent.withValues(alpha: 0.45)),
                ),
                child: Text(
                  roleBadge,
                  style: TextStyle(
                    color: accent,
                    fontWeight: FontWeight.w600,
                    fontSize: dense ? 10 : 11,
                  ),
                ),
              ),
            if (headerMeta.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  headerMeta.join(' • '),
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: dense ? 10 : 11,
                  ),
                ),
              ),
          ],
        ),
      );
      content.add(SizedBox(height: dense ? 5 : 7));
    }
    if (title.isNotEmpty) {
      content.add(
        Text(
          title,
          style: TextStyle(
            fontSize: dense ? 13 : 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
      content.add(SizedBox(height: dense ? 2 : 4));
    }
    if (subtitle.isNotEmpty) {
      content.add(
        Text(
          subtitle,
          style: TextStyle(color: Colors.white70, fontSize: dense ? 11 : 12),
        ),
      );
      content.add(SizedBox(height: dense ? 4 : 6));
    }
    if (bodyText.isNotEmpty) {
      if (selectable) {
        content.add(
          SelectableText(bodyText, style: TextStyle(fontSize: dense ? 12 : 13)),
        );
      } else {
        content.add(
          Text(bodyText, style: TextStyle(fontSize: dense ? 12 : 13)),
        );
      }
      content.add(SizedBox(height: dense ? 6 : 8));
    }

    if (quoteText.isNotEmpty ||
        quoteAuthor.isNotEmpty ||
        quoteTimestamp.isNotEmpty) {
      content.add(
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: quoteCompact ? 8 : 10,
            vertical: quoteCompact ? 6 : 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white.withValues(alpha: 0.04),
            border: Border(
              left: BorderSide(width: 3, color: accent.withValues(alpha: 0.65)),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (quoteAuthor.isNotEmpty)
                Text(
                  quoteAuthor,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: dense ? 11 : 12,
                  ),
                ),
              if (quoteText.isNotEmpty)
                Text(quoteText, style: TextStyle(fontSize: dense ? 11 : 12)),
              if (quoteTimestamp.isNotEmpty)
                Text(
                  quoteTimestamp,
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: dense ? 10 : 11,
                  ),
                ),
            ],
          ),
        ),
      );
      content.add(SizedBox(height: dense ? 6 : 8));
    }

    if (attachments.isNotEmpty) {
      content.add(
        Wrap(
          spacing: dense ? 6 : 8,
          runSpacing: dense ? 6 : 8,
          children: attachments
              .map((item) => _buildAttachmentTile(item, dense: dense))
              .toList(growable: false),
        ),
      );
      content.add(SizedBox(height: dense ? 6 : 8));
    }

    if (reactions.isNotEmpty) {
      content.add(
        Wrap(
          spacing: dense ? 4 : 6,
          runSpacing: dense ? 4 : 6,
          children: reactions
              .map((item) => _buildReactionChip(item, dense: dense))
              .toList(growable: false),
        ),
      );
      content.add(SizedBox(height: dense ? 6 : 8));
    }

    if (actions.isNotEmpty) {
      content.add(
        Wrap(
          spacing: dense ? 6 : 8,
          runSpacing: dense ? 6 : 8,
          children: actions
              .map((item) => _buildActionButton(item, dense: dense))
              .toList(growable: false),
        ),
      );
      content.add(SizedBox(height: dense ? 6 : 8));
    }

    if (notice.isNotEmpty) {
      content.add(
        _noticeBadge(notice, color: Colors.lightBlueAccent, dense: dense),
      );
      content.add(SizedBox(height: dense ? 6 : 8));
    }
    if (errorNotice.isNotEmpty) {
      content.add(
        _noticeBadge(errorNotice, color: Colors.redAccent, dense: dense),
      );
      content.add(SizedBox(height: dense ? 6 : 8));
    }

    if (!groupedWithNext &&
        !pinned &&
        _state['show_timestamps'] == true &&
        timestamp.isNotEmpty) {
      content.add(
        Text(
          timestamp,
          style: TextStyle(color: Colors.white60, fontSize: dense ? 10 : 11),
        ),
      );
    }

    if (content.isNotEmpty && content.last is SizedBox) {
      content.removeLast();
    }
    if (content.isEmpty) content.add(const SizedBox.shrink());

    final bubble = Container(
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? (MediaQuery.of(context).size.width * 0.82),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _baseToneSurface(tone),
            _baseToneSurface(tone).withValues(alpha: 0.78),
          ],
        ),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.12),
            blurRadius: dense ? 10 : 14,
            spreadRadius: 1.2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: content,
      ),
    );

    Widget wrapped = Align(
      alignment: switch (align) {
        _BubbleAlign.right => Alignment.centerRight,
        _BubbleAlign.left => Alignment.centerLeft,
      },
      child: bubble,
    );
    if (allowTap) {
      wrapped = InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: () => _emit('message_click', {
          'id': messageId,
          'sender_name': sender,
          'role': role,
          'text': bodyText,
        }),
        child: wrapped,
      );
    }
    return wrapped;
  }

  Widget _buildAttachmentTile(
    Map<String, Object?> item, {
    required bool dense,
  }) {
    final type = (item['type'] ?? item['kind'] ?? '').toString().toLowerCase();
    final id = (item['id'] ?? item['key'] ?? '').toString();
    final label =
        (item['label'] ??
                item['name'] ??
                item['title'] ??
                item['file_name'] ??
                type)
            .toString();
    final icon = switch (type) {
      'image' => Icons.image_outlined,
      'video' => Icons.videocam_outlined,
      'audio' => Icons.graphic_eq_outlined,
      'document' || 'doc' || 'pdf' => Icons.description_outlined,
      _ => Icons.attachment_outlined,
    };
    final width = dense ? 110.0 : 132.0;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => _emit('attachment_click', {'id': id, 'type': type, ...item}),
      child: Container(
        width: width,
        padding: EdgeInsets.all(dense ? 7 : 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white.withValues(alpha: 0.05),
          border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
        ),
        child: Row(
          children: [
            Icon(icon, size: dense ? 16 : 18, color: Colors.white70),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: dense ? 10 : 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReactionChip(
    Map<String, Object?> reaction, {
    required bool dense,
  }) {
    final id = (reaction['id'] ?? reaction['key'] ?? reaction['emoji'] ?? '')
        .toString();
    final emoji = (reaction['emoji'] ?? reaction['label'] ?? '').toString();
    final count = coerceOptionalInt(reaction['count']);
    final selected =
        reaction['selected'] == true || reaction['you_reacted'] == true;
    final label = count == null ? emoji : '$emoji $count';
    final chipLabel = label.trim().isEmpty ? 'react' : label;
    return ChoiceChip(
      selected: selected,
      visualDensity: dense ? VisualDensity.compact : VisualDensity.standard,
      label: Text(chipLabel, style: TextStyle(fontSize: dense ? 11 : 12)),
      onSelected: (_) =>
          _emit('react', {'id': id, 'emoji': emoji, 'selected': !selected}),
    );
  }

  Widget _buildActionButton(
    Map<String, Object?> action, {
    required bool dense,
  }) {
    final id = (action['id'] ?? action['key'] ?? action['event'] ?? '')
        .toString();
    final label = (action['label'] ?? action['title'] ?? id).toString();
    final event = (action['event'] ?? 'action').toString();
    final style = (action['style'] ?? action['variant'] ?? '').toString();
    final filled = style == 'filled' || style == 'primary';
    final onPressed = () => _emit(event, {'id': id, 'label': label, ...action});
    if (filled) {
      return FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          visualDensity: dense ? VisualDensity.compact : VisualDensity.standard,
          padding: EdgeInsets.symmetric(
            horizontal: dense ? 10 : 12,
            vertical: dense ? 6 : 8,
          ),
        ),
        child: Text(label),
      );
    }
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        visualDensity: dense ? VisualDensity.compact : VisualDensity.standard,
        padding: EdgeInsets.symmetric(
          horizontal: dense ? 10 : 12,
          vertical: dense ? 6 : 8,
        ),
      ),
      child: Text(label),
    );
  }

  Widget _noticeBadge(
    String text, {
    required Color color,
    required bool dense,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 8 : 9,
        vertical: dense ? 4 : 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.42)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: dense ? 10 : 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildComposerSurface({required bool integrated}) {
    final density = _density();
    final dense = density == _BubbleDensity.compact;
    final cozy = density == _BubbleDensity.cozy;
    final placeholder =
        (_state['placeholder'] ??
                _state['input_placeholder'] ??
                'Write a message...')
            .toString();
    final minLines = (coerceOptionalInt(_state['min_lines']) ?? 1).clamp(1, 32);
    final maxLines = (coerceOptionalInt(_state['max_lines']) ?? 6).clamp(
      minLines,
      80,
    );
    final autoExpand = _state['auto_expand'] != false;
    final sendOnEnter = _state['send_on_enter'] != false;
    final showAttach = _state['show_attach'] == true;
    final sendLabel = (_state['send_label'] ?? 'Send').toString();
    final disabled = _state['disabled'] == true || _isRateLimited();
    final readOnly = _state['read_only'] == true;
    final charLimit = coerceOptionalInt(_state['char_limit']);
    final showCounter = _state['show_counter'] == true || charLimit != null;
    final valueLength = _composerController.text.characters.length;
    final overLimit = charLimit != null && valueLength > charLimit;
    final canSubmit =
        !disabled &&
        !readOnly &&
        !overLimit &&
        _composerController.text.trim().isNotEmpty;
    final maxWidth = coerceDouble(_state['max_width']);

    Widget input = TextField(
      controller: _composerController,
      focusNode: _composerFocusNode,
      enabled: !disabled,
      readOnly: readOnly,
      minLines: autoExpand ? minLines : 1,
      maxLines: autoExpand ? maxLines : 1,
      decoration: InputDecoration(
        hintText: placeholder,
        counterText: showCounter && charLimit != null
            ? '$valueLength/$charLimit'
            : null,
        errorText: overLimit
            ? (_state['char_limit_error'] ?? 'Character limit exceeded')
                  .toString()
            : null,
        border: InputBorder.none,
        isDense: dense,
      ),
      onSubmitted: (_) {
        if (sendOnEnter) _submitComposer();
      },
    );

    if (sendOnEnter) {
      input = Focus(
        onKeyEvent: (_, event) {
          if (event is! KeyDownEvent) return KeyEventResult.ignored;
          if (event.logicalKey != LogicalKeyboardKey.enter &&
              event.logicalKey != LogicalKeyboardKey.numpadEnter) {
            return KeyEventResult.ignored;
          }
          if (HardwareKeyboard.instance.isShiftPressed) {
            return KeyEventResult.ignored;
          }
          _submitComposer();
          return KeyEventResult.handled;
        },
        child: input,
      );
    }

    Widget composer = Container(
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? (MediaQuery.of(context).size.width * 0.9),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 10 : (cozy ? 14 : 12),
        vertical: dense ? 8 : (cozy ? 12 : 10),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(dense ? 12 : 16),
        color: Colors.white.withValues(alpha: 0.06),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (showAttach)
                IconButton(
                  onPressed: disabled
                      ? null
                      : () => _emit('attach', {
                          'value': _composerController.text,
                        }),
                  icon: const Icon(Icons.attach_file_rounded),
                  tooltip: 'Attach',
                ),
              Expanded(child: input),
              const SizedBox(width: 6),
              FilledButton(
                onPressed: canSubmit ? _submitComposer : null,
                child: Text(sendLabel),
              ),
            ],
          ),
          if (showCounter && charLimit == null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '$valueLength chars',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: dense ? 10 : 11,
                ),
              ),
            ),
          if (_isRateLimited())
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                (_state['rate_limited_label'] ??
                        'Please wait before sending again.')
                    .toString(),
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: dense ? 10 : 11,
                ),
              ),
            ),
        ],
      ),
    );
    if (!integrated) {
      composer = Align(alignment: Alignment.centerLeft, child: composer);
    }
    return composer;
  }

  Widget _buildEmptyState() {
    final empty = _state['empty_state'];
    if (empty is Map) {
      return widget.buildChild(coerceObjectMap(empty));
    }
    final label = (empty ?? 'No messages yet.').toString();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white.withValues(alpha: 0.04),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.chat_bubble_outline, color: Colors.white70),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  Widget? _buildTypingIndicator() {
    final indicator = _state['typing_indicator'];
    if (indicator == null) return null;
    if (indicator is Map) {
      final map = coerceObjectMap(indicator);
      if (map['child'] is Map) {
        return widget.buildChild(coerceObjectMap(map['child'] as Map));
      }
      final text = (map['label'] ?? map['text'] ?? 'Typing...').toString();
      final count = (coerceOptionalInt(map['dot_count']) ?? 3).clamp(1, 6);
      return _typingRow(text: text, dots: count);
    }
    return _typingRow(text: indicator.toString(), dots: 3);
  }

  Widget _typingRow({required String text, required int dots}) {
    final dense = _density() == _BubbleDensity.compact;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 10 : 12,
        vertical: dense ? 7 : 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withValues(alpha: 0.06),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < dots; i += 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Container(
                width: dense ? 5 : 6,
                height: dense ? 5 : 6,
                decoration: const BoxDecoration(
                  color: Colors.white70,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(fontSize: dense ? 11 : 12, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label, {required IconData icon}) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.white60),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _threadDivider(String label, {bool unread = false, Color? color}) {
    final dividerColor =
        color ??
        (unread
            ? Colors.lightBlueAccent
            : Colors.white.withValues(alpha: 0.18));
    return Row(
      children: [
        Expanded(child: Divider(color: dividerColor, height: 1)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: dividerColor.withValues(alpha: unread ? 0.2 : 0.12),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: unread ? Colors.lightBlueAccent : Colors.white70,
              fontSize: 11,
              fontWeight: unread ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Divider(color: dividerColor, height: 1)),
      ],
    );
  }

  _BubbleDensity _density() {
    final raw = (_state['density'] ?? '').toString().toLowerCase();
    if (raw == 'compact' ||
        _state['dense'] == true ||
        _state['compact'] == true) {
      return _BubbleDensity.compact;
    }
    if (raw == 'cozy') return _BubbleDensity.cozy;
    return _BubbleDensity.normal;
  }

  Color _toneColor(String tone) {
    switch (tone.toLowerCase()) {
      case 'info':
        return Colors.lightBlueAccent;
      case 'success':
        return Colors.greenAccent;
      case 'warn':
      case 'warning':
        return Colors.orangeAccent;
      case 'danger':
      case 'error':
        return Colors.redAccent;
      default:
        return const Color(0xff7dd3fc);
    }
  }

  Color _baseToneSurface(String tone) {
    switch (tone.toLowerCase()) {
      case 'info':
        return const Color(0xff132f55);
      case 'success':
        return const Color(0xff153823);
      case 'warn':
      case 'warning':
        return const Color(0xff3b2a14);
      case 'danger':
      case 'error':
        return const Color(0xff3f1820);
      default:
        return const Color(0xff162a4b);
    }
  }

  _BubbleAlign _resolveAlign(String? align, String role) {
    final normalized = (align ?? '').toLowerCase().replaceAll('-', '_');
    if (normalized == 'right' || normalized == 'end') return _BubbleAlign.right;
    if (normalized == 'left' || normalized == 'start') return _BubbleAlign.left;
    if (normalized == 'auto') {
      final roleNorm = role.toLowerCase();
      if (roleNorm == 'user' || roleNorm == 'self' || roleNorm == 'me') {
        return _BubbleAlign.right;
      }
    }
    return _BubbleAlign.left;
  }

  List<Map<String, Object?>> _coerceMapList(Object? raw) {
    if (raw is! List) return const <Map<String, Object?>>[];
    final out = <Map<String, Object?>>[];
    for (var i = 0; i < raw.length; i += 1) {
      final item = raw[i];
      if (item is Map) {
        out.add(coerceObjectMap(item));
      } else if (item != null) {
        out.add(<String, Object?>{'id': '$i', 'label': item.toString()});
      }
    }
    return out;
  }

  bool _coerceBool(Object? value, {required bool fallback}) {
    if (value == null) return fallback;
    if (value is bool) return value;
    if (value is num) return value != 0;
    final normalized = value.toString().toLowerCase();
    if (normalized == 'true' || normalized == '1' || normalized == 'yes') {
      return true;
    }
    if (normalized == 'false' || normalized == '0' || normalized == 'no') {
      return false;
    }
    return fallback;
  }
}

enum _BubbleDensity { compact, normal, cozy }

enum _BubbleAlign { left, right }
