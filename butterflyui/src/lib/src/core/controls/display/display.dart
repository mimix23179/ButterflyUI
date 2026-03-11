import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_theme.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/common/icon_value.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildDisplayControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _DisplayControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _DisplayControl extends StatefulWidget {
  const _DisplayControl({
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
  State<_DisplayControl> createState() => _DisplayControlState();
}

class _DisplayControlState extends State<_DisplayControl> {
  late Map<String, Object?> _state;
  final Set<String> _checked = <String>{};
  final Set<String> _selectedReactions = <String>{};

  @override
  void initState() {
    super.initState();
    _state = {...widget.props};
    _syncSelectionSets();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _DisplayControl oldWidget) {
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
      _syncSelectionSets();
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  void _syncSelectionSets() {
    _checked
      ..clear()
      ..addAll(_toStringSet(_state['checked'] ?? _state['selected']));
    _selectedReactions
      ..clear()
      ..addAll(_toStringSet(_state['selected']));
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_props':
        setState(() {
          _state = {..._state, ...args};
          _syncSelectionSets();
        });
        return _statePayload();
      case 'set_checked':
        setState(() {
          _checked
            ..clear()
            ..addAll(_toStringSet(args['checked'] ?? args['values']));
        });
        return _statePayload();
      case 'get_state':
        return _statePayload();
      case 'emit':
        final event = (args['event'] ?? 'change').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        _emit(event, payload);
        return null;
      default:
        throw UnsupportedError('Unknown display method: $method');
    }
  }

  Set<String> _toStringSet(Object? raw) {
    final out = <String>{};
    if (raw is List) {
      for (final item in raw) {
        final text = item?.toString();
        if (text != null && text.isNotEmpty) out.add(text);
      }
    }
    return out;
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      ..._state,
      'checked': _checked.toList(growable: false),
      'selected': _selectedReactions.toList(growable: false),
    };
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  List<Widget> _children() {
    final out = <Widget>[];
    for (final raw in widget.rawChildren) {
      if (raw is Map) out.add(widget.buildChild(coerceObjectMap(raw)));
    }
    return out;
  }

  Widget? _buildSlot(Object? value) {
    if (value is Map) {
      return widget.buildChild(coerceObjectMap(value));
    }
    if (value == null) return null;
    final icon = buildIconValue(value, size: _isDense ? 16 : 18);
    if (icon != null) return icon;
    final text = value.toString().trim();
    if (text.isEmpty) return null;
    return Text(
      text,
      style: TextStyle(color: Colors.white70, fontSize: _isDense ? 11 : 12),
    );
  }

  bool get _isDense =>
      _state['dense'] == true ||
      _state['compact'] == true ||
      (_state['size']?.toString().toLowerCase() == 'sm');

  @override
  Widget build(BuildContext context) {
    final role = _resolveRole(
      (_state['role'] ?? _state['variant'] ?? 'identity').toString(),
    );
    final children = _children();
    final leading = _buildSlot(_state['leading']);
    final trailing = _buildSlot(_state['trailing']);
    final interactive =
        _state['interactive'] == true || _state['clickable'] == true;
    final tone = (_state['tone'] ?? _state['status'] ?? 'neutral').toString();
    final accent = _toneColor(tone);
    final body = switch (role) {
      _DisplayRole.identity => _buildIdentity(),
      _DisplayRole.status => _buildStatus(),
      _DisplayRole.rating => _buildRating(),
      _DisplayRole.reactions => _buildReactions(),
      _DisplayRole.check => _buildCheck(),
      _DisplayRole.ownership => _buildOwnership(),
    };

    final content = <Widget>[];
    content.add(
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (leading != null) ...[leading, SizedBox(width: _isDense ? 8 : 10)],
          Expanded(child: body),
          if (trailing != null) ...[
            SizedBox(width: _isDense ? 8 : 10),
            trailing,
          ],
        ],
      ),
    );
    if (children.isNotEmpty) {
      content.add(SizedBox(height: _isDense ? 8 : 10));
      content.addAll(children);
    }

    Widget card = Container(
      width: double.infinity,
      padding: EdgeInsets.all(_isDense ? 10 : 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_isDense ? 12 : 14),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xff13213a),
            const Color(0xff1b2a45).withValues(alpha: 0.88),
          ],
        ),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: content,
      ),
    );

    if (interactive) {
      card = InkWell(
        borderRadius: BorderRadius.circular(_isDense ? 12 : 14),
        onTap: () => _emit('tap', {
          'role': role.name,
          'title': (_state['title'] ?? _state['name'] ?? '').toString(),
        }),
        child: card,
      );
    }
    return card;
  }

  Widget _buildIdentity() {
    final name = (_state['title'] ?? _state['name'] ?? 'Identity').toString();
    final subtitle = (_state['subtitle'] ?? _state['description'] ?? '')
        .toString();
    final caption = (_state['caption'] ?? '').toString();
    final avatar = _state['avatar'];
    final initials = (_state['initials'] ?? _deriveInitials(name)).toString();
    final tags = _coerceItems(_state['tags']);
    final avatarColor =
        coerceColor(_state['avatar_color']) ?? const Color(0xff334155);
    final avatarWidget = avatar is Map
        ? widget.buildChild(coerceObjectMap(avatar))
        : CircleAvatar(
            radius: _isDense ? 14 : 16,
            backgroundColor: avatarColor,
            child: Text(
              initials,
              style: TextStyle(
                fontSize: _isDense ? 11 : 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            avatarWidget,
            SizedBox(width: _isDense ? 8 : 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: _isDense ? 13 : 15,
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: _isDense ? 11 : 12,
                      ),
                    ),
                  if (caption.isNotEmpty)
                    Text(
                      caption,
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: _isDense ? 10 : 11,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        if (tags.isNotEmpty) ...[
          SizedBox(height: _isDense ? 6 : 8),
          Wrap(
            spacing: _isDense ? 4 : 6,
            runSpacing: _isDense ? 4 : 6,
            children: tags
                .map(
                  (tag) => Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: _isDense ? 7 : 8,
                      vertical: _isDense ? 3 : 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      (tag['label'] ?? tag['title'] ?? tag['id'] ?? '')
                          .toString(),
                      style: TextStyle(fontSize: _isDense ? 10 : 11),
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        ],
      ],
    );
  }

  Widget _buildStatus() {
    final status = (_state['status'] ?? _state['value'] ?? 'info')
        .toString()
        .toLowerCase();
    final label =
        (_state['badge'] ?? _state['title'] ?? _state['status'] ?? status)
            .toString();
    final color = coerceColor(_state['color']) ?? _toneColor(status);
    return Wrap(
      spacing: _isDense ? 6 : 8,
      runSpacing: _isDense ? 6 : 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: _isDense ? 8 : 10,
            vertical: _isDense ? 4 : 5,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.18),
            border: Border.all(color: color.withValues(alpha: 0.45)),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: _isDense ? 11 : 12,
            ),
          ),
        ),
        if ((_state['caption'] ?? '').toString().isNotEmpty)
          Text(
            _state['caption']!.toString(),
            style: TextStyle(
              color: Colors.white70,
              fontSize: _isDense ? 11 : 12,
            ),
          ),
      ],
    );
  }

  Widget _buildRating() {
    final rawValue = coerceDouble(_state['value']) ?? 0;
    final max = (coerceOptionalInt(_state['max']) ?? 5).clamp(1, 10);
    final allowHalf = _state['allow_half'] == true;
    final starColor = coerceColor(_state['color']) ?? Colors.amber;
    final count = coerceOptionalInt(_state['count']);

    IconData iconFor(int index) {
      final full = index + 1 <= rawValue;
      final half = allowHalf && !full && (index + 0.5) <= rawValue;
      if (full) return Icons.star;
      if (half) return Icons.star_half;
      return Icons.star_border;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: _isDense ? 2 : 4,
          children: List<Widget>.generate(max, (index) {
            return InkWell(
              onTap: widget.controlId.isEmpty
                  ? null
                  : () => _emit('rate', {'value': index + 1, 'index': index}),
              child: Icon(
                iconFor(index),
                size: _isDense ? 16 : 20,
                color: starColor,
              ),
            );
          }),
        ),
        if (count != null)
          Text(
            '$count ratings',
            style: TextStyle(
              color: Colors.white70,
              fontSize: _isDense ? 10 : 11,
            ),
          ),
      ],
    );
  }

  Widget _buildReactions() {
    final items = _coerceItems(_state['items']);
    if (items.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: _isDense ? 4 : 6,
      runSpacing: _isDense ? 4 : 6,
      children: items
          .map((item) {
            final id = (item['id'] ?? item['key'] ?? item['emoji'] ?? '')
                .toString();
            final label = (item['label'] ?? item['emoji'] ?? id).toString();
            final count = coerceOptionalInt(item['count']);
            final isSelected = _selectedReactions.contains(id);
            return FilterChip(
              selected: isSelected,
              visualDensity: _isDense
                  ? VisualDensity.compact
                  : VisualDensity.standard,
              label: Text(count == null ? label : '$label $count'),
              onSelected: (next) {
                setState(() {
                  if (next) {
                    _selectedReactions.add(id);
                  } else {
                    _selectedReactions.remove(id);
                  }
                });
                _emit('react', {
                  'id': id,
                  'selected': next,
                  'selected_ids': _selectedReactions.toList(growable: false),
                });
              },
            );
          })
          .toList(growable: false),
    );
  }

  Widget _buildCheck() {
    final checkboxTheme = Theme.of(context).copyWith(
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return butterflyuiPrimary(context);
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStatePropertyAll(butterflyuiBackground(context)),
        side: BorderSide(color: butterflyuiBorder(context)),
      ),
      listTileTheme: butterflyuiListTileTheme(context, _state),
    );
    final single = _state['checked_value'];
    if (single != null) {
      final value = single == true;
      return Theme(
        data: checkboxTheme,
        child: CheckboxListTile(
          dense: _isDense,
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          value: value,
          title: Text(
            (_state['title'] ?? _state['label'] ?? 'Checked').toString(),
          ),
          onChanged: (next) {
            _state['checked_value'] = next == true;
            _emit('check_change', {'checked': next == true});
            setState(() {});
          },
        ),
      );
    }

    final items = _coerceItems(_state['items']);
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: items
          .map((item) {
            final id = (item['id'] ?? item['key'] ?? '').toString();
            final label = (item['label'] ?? item['title'] ?? id).toString();
            return Theme(
              data: checkboxTheme,
              child: CheckboxListTile(
                dense: _isDense,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                value: _checked.contains(id),
                title: Text(label),
                onChanged: (next) {
                  setState(() {
                    if (next == true) {
                      _checked.add(id);
                    } else {
                      _checked.remove(id);
                    }
                  });
                  _emit('check_change', {
                    'id': id,
                    'checked': _checked.toList(growable: false),
                  });
                },
              ),
            );
          })
          .toList(growable: false),
    );
  }

  Widget _buildOwnership() {
    final owners = _coerceItems(_state['owners']);
    final showAvatars = _state['show_avatars'] != false;
    final title = (_state['title'] ?? _state['document_id'] ?? 'Ownership')
        .toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.workspace_premium_outlined, size: 16),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: _isDense ? 12 : 14,
              ),
            ),
          ],
        ),
        if (owners.isNotEmpty) ...[
          SizedBox(height: _isDense ? 6 : 8),
          Wrap(
            spacing: _isDense ? 6 : 8,
            runSpacing: _isDense ? 6 : 8,
            children: owners
                .map((owner) {
                  final name =
                      (owner['name'] ?? owner['title'] ?? owner['id'] ?? '')
                          .toString();
                  final initials = _deriveInitials(name);
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: _isDense ? 8 : 10,
                      vertical: _isDense ? 5 : 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (showAvatars)
                          CircleAvatar(
                            radius: _isDense ? 9 : 10,
                            backgroundColor:
                                coerceColor(owner['color']) ??
                                const Color(0xff334155),
                            child: Text(
                              initials,
                              style: TextStyle(fontSize: _isDense ? 8 : 9),
                            ),
                          ),
                        if (showAvatars) const SizedBox(width: 6),
                        Text(
                          name,
                          style: TextStyle(fontSize: _isDense ? 10 : 11),
                        ),
                      ],
                    ),
                  );
                })
                .toList(growable: false),
          ),
        ],
      ],
    );
  }

  List<Map<String, Object?>> _coerceItems(Object? raw) {
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

  String _deriveInitials(String name) {
    final parts = name
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList(growable: false);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }

  Color _toneColor(String tone) {
    switch (tone.toLowerCase()) {
      case 'ok':
      case 'success':
        return Colors.greenAccent;
      case 'warn':
      case 'warning':
        return Colors.orangeAccent;
      case 'error':
      case 'danger':
        return Colors.redAccent;
      default:
        return Colors.lightBlueAccent;
    }
  }

  _DisplayRole _resolveRole(String raw) {
    final normalized = raw.toLowerCase().replaceAll('-', '_');
    switch (normalized) {
      case 'identity':
      case 'persona':
      case 'result_card':
      case 'summary':
        return _DisplayRole.identity;
      case 'status':
      case 'status_mark':
      case 'typing':
      case 'typing_indicator':
        return _DisplayRole.status;
      case 'rating':
      case 'rating_display':
        return _DisplayRole.rating;
      case 'reactions':
      case 'reaction_bar':
        return _DisplayRole.reactions;
      case 'check':
      case 'check_list':
      case 'checklist':
        return _DisplayRole.check;
      case 'ownership':
      case 'ownership_marker':
        return _DisplayRole.ownership;
      default:
        return _DisplayRole.identity;
    }
  }
}

enum _DisplayRole { identity, status, rating, reactions, check, ownership }
