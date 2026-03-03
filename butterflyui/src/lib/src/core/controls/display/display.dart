import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    final variant = (_state['variant'] ?? 'summary').toString().toLowerCase();
    final dense = _state['dense'] == true || _state['compact'] == true;
    final title = (_state['title'] ?? _state['name'] ?? '').toString();
    final subtitle = (_state['subtitle'] ?? _state['description'] ?? '')
        .toString();
    final status = (_state['status'] ?? '').toString();
    final icon = buildIconValue(_state['icon'], size: dense ? 16 : 18);
    final children = _children();

    Widget content;
    switch (variant) {
      case 'rating':
        content = _buildRating(dense);
        break;
      case 'reactions':
        content = _buildReactions(dense);
        break;
      case 'checklist':
        content = _buildChecklist(dense);
        break;
      case 'typing':
        content = _buildTyping(dense);
        break;
      case 'status':
        content = _buildStatusChip(dense);
        break;
      case 'persona':
        content = _buildPersona(dense);
        break;
      default:
        content = _buildSummary(
          dense,
          icon: icon,
          title: title,
          subtitle: subtitle,
          status: status,
        );
        break;
    }

    final columnChildren = <Widget>[content, ...children];
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(dense ? 10 : 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withValues(alpha: 0.04),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: columnChildren
            .asMap()
            .entries
            .map(
              (entry) => Padding(
                padding: EdgeInsets.only(
                  bottom: entry.key == columnChildren.length - 1
                      ? 0
                      : (dense ? 8 : 10),
                ),
                child: entry.value,
              ),
            )
            .toList(growable: false),
      ),
    );
  }

  Widget _buildSummary(
    bool dense, {
    Widget? icon,
    required String title,
    required String subtitle,
    required String status,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[icon, SizedBox(width: dense ? 8 : 10)],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.isEmpty ? 'Display' : title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: dense ? 13 : 15,
                ),
              ),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: dense ? 11 : 12,
                  ),
                ),
            ],
          ),
        ),
        if (status.isNotEmpty) _buildStatusChip(dense),
      ],
    );
  }

  Widget _buildPersona(bool dense) {
    final name = (_state['name'] ?? _state['title'] ?? 'Persona').toString();
    final subtitle = (_state['subtitle'] ?? '').toString();
    final initials = (_state['initials'] ?? _deriveInitials(name)).toString();
    final avatarColor =
        coerceColor(_state['avatar_color']) ?? const Color(0xff334155);
    return InkWell(
      onTap: widget.controlId.isEmpty
          ? null
          : () => _emit('click', {'name': name, 'subtitle': subtitle}),
      child: Row(
        children: [
          CircleAvatar(
            radius: dense ? 14 : 16,
            backgroundColor: avatarColor,
            child: Text(
              initials,
              style: TextStyle(
                fontSize: dense ? 11 : 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: dense ? 8 : 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: dense ? 11 : 12,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(bool dense) {
    final status = (_state['status'] ?? 'info').toString().toLowerCase();
    final label = (_state['badge'] ?? _state['status'] ?? '').toString();
    final color = coerceColor(_state['color']) ?? _statusColor(status);
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: widget.controlId.isEmpty
          ? null
          : () => _emit('select', {'status': status, 'label': label}),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: dense ? 7 : 9,
          vertical: dense ? 3 : 4,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.18),
          border: Border.all(color: color.withValues(alpha: 0.45)),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label.isEmpty ? status : label,
          style: TextStyle(color: color, fontSize: dense ? 11 : 12),
        ),
      ),
    );
  }

  Widget _buildTyping(bool dense) {
    final count = (coerceOptionalInt(_state['dot_count']) ?? 3).clamp(1, 6);
    final color = coerceColor(_state['color']) ?? Colors.white70;
    final size = coerceDouble(_state['size']) ?? (dense ? 6 : 7);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(
        count,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }

  Widget _buildRating(bool dense) {
    final rawValue = coerceDouble(_state['value']) ?? 0;
    final max = (coerceOptionalInt(_state['max']) ?? 5).clamp(1, 10);
    final allowHalf = _state['allow_half'] == true;
    final starColor = coerceColor(_state['color']) ?? Colors.amber;

    IconData iconFor(int index) {
      final full = index + 1 <= rawValue;
      final half = allowHalf && !full && (index + 0.5) <= rawValue;
      if (full) return Icons.star;
      if (half) return Icons.star_half;
      return Icons.star_border;
    }

    return Wrap(
      spacing: dense ? 2 : 4,
      children: List<Widget>.generate(max, (index) {
        return InkWell(
          onTap: widget.controlId.isEmpty
              ? null
              : () => _emit('rate', {'value': index + 1, 'index': index}),
          child: Icon(iconFor(index), size: dense ? 16 : 20, color: starColor),
        );
      }),
    );
  }

  Widget _buildReactions(bool dense) {
    final items = _coerceItems(_state['items']);
    if (items.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: dense ? 4 : 6,
      runSpacing: dense ? 4 : 6,
      children: items
          .map((item) {
            final id = (item['id'] ?? item['key'] ?? item['emoji'] ?? '')
                .toString();
            final label = (item['label'] ?? item['emoji'] ?? id).toString();
            final count = coerceOptionalInt(item['count']);
            final isSelected = _selectedReactions.contains(id);
            return FilterChip(
              selected: isSelected,
              visualDensity: dense
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

  Widget _buildChecklist(bool dense) {
    final items = _coerceItems(_state['items']);
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: items
          .map((item) {
            final id = (item['id'] ?? item['key'] ?? '').toString();
            final label = (item['label'] ?? item['title'] ?? id).toString();
            return CheckboxListTile(
              dense: dense,
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
                _emit('change', {
                  'id': id,
                  'checked': _checked.toList(growable: false),
                });
              },
            );
          })
          .toList(growable: false),
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
        .split(RegExp(r'\\s+'))
        .where((part) => part.isNotEmpty)
        .toList(growable: false);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }

  Color _statusColor(String status) {
    switch (status) {
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
}
