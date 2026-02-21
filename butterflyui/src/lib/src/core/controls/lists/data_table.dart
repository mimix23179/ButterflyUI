import 'package:flutter/material.dart';

import 'package:conduit_runtime/src/core/control_utils.dart';
import 'package:conduit_runtime/src/core/webview/webview_api.dart';

Widget buildDataTableControl(
  String controlId,
  Map<String, Object?> props,
  ConduitRegisterInvokeHandler registerInvokeHandler,
  ConduitUnregisterInvokeHandler unregisterInvokeHandler,
  ConduitSendRuntimeEvent sendEvent,
) {
  return ConduitDataTableView(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class ConduitDataTableView extends StatefulWidget {
  final String controlId;
  final Map<String, Object?> props;
  final ConduitRegisterInvokeHandler registerInvokeHandler;
  final ConduitUnregisterInvokeHandler unregisterInvokeHandler;
  final ConduitSendRuntimeEvent sendEvent;

  const ConduitDataTableView({
    super.key,
    required this.controlId,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<ConduitDataTableView> createState() => _ConduitDataTableViewState();
}

class _ConduitDataTableViewState extends State<ConduitDataTableView> {
  String? _sortColumnId;
  bool _sortAscending = true;
  late final TextEditingController _filterController;
  String _filterQuery = '';
  final Set<String> _selectedKeys = <String>{};

  @override
  void initState() {
    super.initState();
    _sortColumnId = widget.props['sort_column']?.toString();
    _sortAscending = widget.props['sort_ascending'] == null
        ? true
        : (widget.props['sort_ascending'] == true);
    _filterQuery = (widget.props['filter_query'] ?? '').toString();
    _filterController = TextEditingController(text: _filterQuery);
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant ConduitDataTableView oldWidget) {
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
      final nextSort = widget.props['sort_column']?.toString();
      final nextAscending = widget.props['sort_ascending'] == null
          ? _sortAscending
          : (widget.props['sort_ascending'] == true);
      final nextFilter = (widget.props['filter_query'] ?? '').toString();
      if (nextSort != _sortColumnId || nextAscending != _sortAscending) {
        _sortColumnId = nextSort;
        _sortAscending = nextAscending;
      }
      if (nextFilter != _filterQuery) {
        _filterQuery = nextFilter;
        _filterController.value = _filterController.value.copyWith(
          text: nextFilter,
          selection: TextSelection.collapsed(offset: nextFilter.length),
        );
      }
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final columns = _coerceColumns(widget.props['columns']);
    final rows = _coerceRows(widget.props['rows'], columns);
    if (columns.isEmpty) {
      return const SizedBox.shrink();
    }

    final sortable = widget.props['sortable'] == null
        ? true
        : (widget.props['sortable'] == true);
    final filterable = widget.props['filterable'] == true;
    final selectable = widget.props['selectable'] == true;
    final dense = widget.props['dense'] == true;
    final striped = widget.props['striped'] == true;
    final showHeader = widget.props['show_header'] == null
        ? true
        : (widget.props['show_header'] == true);

    final filteredRows = _applyFilter(rows, _filterQuery);
    final sortedRows = _applySort(filteredRows, columns);

    final sortIndex = _sortColumnId == null
        ? null
        : columns.indexWhere((column) => column.id == _sortColumnId);

    final tableColumns = <DataColumn>[];
    for (var i = 0; i < columns.length; i += 1) {
      final col = columns[i];
      tableColumns.add(
        DataColumn(
          label: Text(col.label),
          numeric: col.numeric,
          onSort: sortable
              ? (_, ascending) {
                  setState(() {
                    _sortColumnId = col.id;
                    _sortAscending = ascending;
                  });
                  _emit('sort_change', {
                    'column': col.id,
                    'sort_column': col.id,
                    'sort_ascending': ascending,
                  });
                }
              : null,
        ),
      );
    }

    final tableRows = <DataRow>[];
    for (var i = 0; i < sortedRows.length; i += 1) {
      final row = sortedRows[i];
      final selected = _selectedKeys.contains(row.key);
      final color = striped && i.isOdd
          ? WidgetStateProperty.all(
              Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            )
          : null;

      tableRows.add(
        DataRow(
          selected: selected,
          color: color,
          onSelectChanged: selectable
              ? (value) {
                  setState(() {
                    if (value == true) {
                      _selectedKeys.add(row.key);
                    } else {
                      _selectedKeys.remove(row.key);
                    }
                  });
                  _emit('row_select', {
                    'index': row.index,
                    'selected': value == true,
                    'selected_keys': _selectedKeys.toList(growable: false),
                    'row': row.payload,
                  });
                }
              : null,
          cells: row.values
              .map(
                (cell) => DataCell(
                  Text(cell),
                  onTap: widget.controlId.isEmpty
                      ? null
                      : () {
                          _emit('row_tap', {
                            'index': row.index,
                            'row': row.payload,
                          });
                        },
                ),
              )
              .toList(growable: false),
        ),
      );
    }

    final table = DataTable(
      columns: tableColumns,
      rows: tableRows,
      sortColumnIndex: sortIndex == null || sortIndex < 0 ? null : sortIndex,
      sortAscending: _sortAscending,
      showCheckboxColumn: selectable,
      headingRowHeight: showHeader ? null : 0,
      dataRowMinHeight: dense ? 32 : null,
      dataRowMaxHeight: dense ? 40 : null,
      dividerThickness: 0.6,
      columnSpacing: dense ? 16 : 24,
    );

    Widget content = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: table,
      ),
    );

    if (!filterable) {
      return content;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _filterController,
          decoration: InputDecoration(
            isDense: dense,
            hintText: 'Filter rows',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _filterQuery.isEmpty
                ? null
                : IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _filterQuery = '';
                        _filterController.clear();
                      });
                      _emit('filter_change', {'filter_query': ''});
                    },
                  ),
          ),
          onChanged: (value) {
            setState(() {
              _filterQuery = value;
            });
            _emit('filter_change', {'filter_query': value});
          },
        ),
        const SizedBox(height: 8),
        Expanded(child: content),
      ],
    );
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_sort':
        setState(() {
          _sortColumnId = args['column']?.toString();
          _sortAscending = args['ascending'] == null
              ? true
              : (args['ascending'] == true);
        });
        return _state();
      case 'clear_sort':
        setState(() {
          _sortColumnId = null;
          _sortAscending = true;
        });
        return _state();
      case 'set_filter':
        final query = (args['query'] ?? args['filter_query'] ?? '').toString();
        setState(() {
          _filterQuery = query;
          _filterController.text = query;
        });
        return _state();
      case 'clear_filter':
        setState(() {
          _filterQuery = '';
          _filterController.clear();
        });
        return _state();
      case 'clear_selection':
        setState(() => _selectedKeys.clear());
        return _state();
      case 'get_state':
        return _state();
      default:
        throw UnsupportedError('Unknown data_table method: $method');
    }
  }

  Map<String, Object?> _state() {
    return <String, Object?>{
      'sort_column': _sortColumnId,
      'sort_ascending': _sortAscending,
      'filter_query': _filterQuery,
      'selected_keys': _selectedKeys.toList(growable: false),
    };
  }

  List<_TableRowData> _applyFilter(List<_TableRowData> rows, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return rows;
    return rows
        .where((row) {
          for (final cell in row.values) {
            if (cell.toLowerCase().contains(q)) return true;
          }
          return false;
        })
        .toList(growable: false);
  }

  List<_TableRowData> _applySort(
    List<_TableRowData> rows,
    List<_TableColumnData> columns,
  ) {
    final sortColumnId = _sortColumnId;
    if (sortColumnId == null || sortColumnId.isEmpty) return rows;
    final columnIndex = columns.indexWhere(
      (column) => column.id == sortColumnId,
    );
    if (columnIndex < 0) return rows;
    final sorted = List<_TableRowData>.from(rows);
    sorted.sort((a, b) {
      final left = columnIndex < a.values.length ? a.values[columnIndex] : '';
      final right = columnIndex < b.values.length ? b.values[columnIndex] : '';
      final leftNum = num.tryParse(left);
      final rightNum = num.tryParse(right);
      int result;
      if (leftNum != null && rightNum != null) {
        result = leftNum.compareTo(rightNum);
      } else {
        result = left.toLowerCase().compareTo(right.toLowerCase());
      }
      return _sortAscending ? result : -result;
    });
    return sorted;
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }
}

class _TableColumnData {
  final String id;
  final String label;
  final bool numeric;

  const _TableColumnData({
    required this.id,
    required this.label,
    required this.numeric,
  });
}

class _TableRowData {
  final int index;
  final String key;
  final List<String> values;
  final Map<String, Object?> payload;

  const _TableRowData({
    required this.index,
    required this.key,
    required this.values,
    required this.payload,
  });
}

List<_TableColumnData> _coerceColumns(Object? raw) {
  if (raw is! List) return const [];
  final out = <_TableColumnData>[];
  for (var i = 0; i < raw.length; i += 1) {
    final item = raw[i];
    if (item is Map) {
      final map = coerceObjectMap(item);
      final id =
          (map['id'] ?? map['key'] ?? map['value'] ?? map['label'] ?? 'col_$i')
              .toString();
      final label = (map['label'] ?? map['title'] ?? id).toString();
      out.add(
        _TableColumnData(id: id, label: label, numeric: map['numeric'] == true),
      );
      continue;
    }
    final text = item?.toString() ?? '';
    if (text.isEmpty) continue;
    out.add(_TableColumnData(id: text, label: text, numeric: false));
  }
  return out;
}

List<_TableRowData> _coerceRows(Object? raw, List<_TableColumnData> columns) {
  if (raw is! List) return const [];
  final out = <_TableRowData>[];
  for (var i = 0; i < raw.length; i += 1) {
    final item = raw[i];
    if (item is List) {
      final values = item.map((value) => value?.toString() ?? '').toList();
      out.add(
        _TableRowData(
          index: i,
          key: 'row_$i',
          values: _fit(values, columns.length),
          payload: {'cells': values},
        ),
      );
      continue;
    }
    if (item is Map) {
      final map = coerceObjectMap(item);
      final key = (map['id'] ?? map['key'] ?? 'row_$i').toString();
      final rawCells = map['cells'];
      if (rawCells is List) {
        final values = rawCells
            .map((value) => value?.toString() ?? '')
            .toList();
        out.add(
          _TableRowData(
            index: i,
            key: key,
            values: _fit(values, columns.length),
            payload: map,
          ),
        );
      } else {
        final values = <String>[];
        for (final column in columns) {
          values.add(map[column.id]?.toString() ?? '');
        }
        out.add(
          _TableRowData(
            index: i,
            key: key,
            values: _fit(values, columns.length),
            payload: map,
          ),
        );
      }
      continue;
    }
    out.add(
      _TableRowData(
        index: i,
        key: 'row_$i',
        values: _fit([item?.toString() ?? ''], columns.length),
        payload: {'value': item},
      ),
    );
  }
  return out;
}

List<String> _fit(List<String> values, int length) {
  final out = List<String>.from(values);
  while (out.length < length) {
    out.add('');
  }
  if (out.length > length) {
    out.removeRange(length, out.length);
  }
  return out;
}
