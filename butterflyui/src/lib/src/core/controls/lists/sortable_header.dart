import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildSortableHeaderControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _SortableHeaderControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _SortableHeaderControl extends StatefulWidget {
  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const _SortableHeaderControl({
    required this.controlId,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<_SortableHeaderControl> createState() => _SortableHeaderControlState();
}

class _SortableHeaderControlState extends State<_SortableHeaderControl> {
  String? _sortColumn;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _sortColumn = widget.props['sort_column']?.toString();
    _sortAscending = widget.props['sort_ascending'] == null
        ? true
        : (widget.props['sort_ascending'] == true);
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _SortableHeaderControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_sort':
        setState(() {
          _sortColumn = args['column']?.toString();
          _sortAscending = args['ascending'] == null
              ? true
              : (args['ascending'] == true);
        });
        return <String, Object?>{
          'sort_column': _sortColumn,
          'sort_ascending': _sortAscending,
        };
      case 'clear_sort':
        setState(() {
          _sortColumn = null;
          _sortAscending = true;
        });
        return true;
      case 'get_state':
        return <String, Object?>{
          'sort_column': _sortColumn,
          'sort_ascending': _sortAscending,
        };
      case 'emit':
        final event = (args['event'] ?? 'custom').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        if (widget.controlId.isNotEmpty) {
          widget.sendEvent(widget.controlId, event, payload);
        }
        return true;
      default:
        throw UnsupportedError('Unknown sortable_header method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final dense = widget.props['dense'] == true;
    final columns = _coerceColumns(widget.props['columns']);
    if (columns.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: dense ? 4 : 8,
      runSpacing: dense ? 4 : 8,
      children: columns.map((column) {
        final key = (column['key'] ?? column['id'] ?? column['field'] ?? '').toString();
        final label = (column['label'] ?? column['title'] ?? key).toString();
        final selected = key.isNotEmpty && key == _sortColumn;
        final icon = selected
            ? (_sortAscending ? Icons.arrow_upward : Icons.arrow_downward)
            : Icons.unfold_more;
        return InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            if (key.isEmpty) return;
            final nextAscending = key == _sortColumn ? !_sortAscending : true;
            setState(() {
              _sortColumn = key;
              _sortAscending = nextAscending;
            });
            if (widget.controlId.isNotEmpty) {
              widget.sendEvent(widget.controlId, 'sort_change', {
                'column': key,
                'sort_column': key,
                'sort_ascending': nextAscending,
              });
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: dense ? 8 : 10,
              vertical: dense ? 5 : 7,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label),
                const SizedBox(width: 4),
                Icon(icon, size: dense ? 14 : 16),
              ],
            ),
          ),
        );
      }).toList(growable: false),
    );
  }
}

List<Map<String, Object?>> _coerceColumns(Object? raw) {
  if (raw is! List) return const <Map<String, Object?>>[];
  final out = <Map<String, Object?>>[];
  for (final item in raw) {
    if (item is Map) {
      out.add(coerceObjectMap(item));
    }
  }
  return out;
}
