import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildDataSourceViewControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _DataSourceViewControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _DataSourceViewControl extends StatefulWidget {
  const _DataSourceViewControl({
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
  State<_DataSourceViewControl> createState() => _DataSourceViewControlState();
}

class _DataSourceViewControlState extends State<_DataSourceViewControl> {
  List<Map<String, Object?>> _sources = const <Map<String, Object?>>[];
  String _selectedId = '';
  String _query = '';

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _DataSourceViewControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    if (!mapEquals(oldWidget.props, widget.props)) {
      _syncFromProps();
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  void _syncFromProps() {
    _sources = _coerceSources(widget.props['sources']);
    _selectedId = widget.props['selected_id']?.toString() ?? '';
    _query = widget.props['query']?.toString() ?? '';
  }

  List<Map<String, Object?>> _coerceSources(Object? raw) {
    if (raw is! List) return const <Map<String, Object?>>[];
    return raw.whereType<Map>().map((item) => coerceObjectMap(item)).toList(growable: false);
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_sources':
        final raw = args['sources'];
        if (raw is List) {
          setState(() => _sources = _coerceSources(raw));
        }
        return _statePayload();
      case 'set_selected':
        setState(() => _selectedId = (args['selected_id'] ?? '').toString());
        return _statePayload();
      case 'set_query':
        setState(() => _query = (args['query'] ?? '').toString());
        return _statePayload();
      case 'get_state':
        return _statePayload();
      case 'emit':
        final event = (args['event'] ?? 'select').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        _emit(event, payload);
        return null;
      default:
        throw UnsupportedError('Unknown data_source_view method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      'sources': _sources,
      'selected_id': _selectedId,
      'query': _query,
    };
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  @override
  Widget build(BuildContext context) {
    final dense = widget.props['dense'] == true;
    final showSearch = widget.props['show_search'] == true;
    final visible = _query.trim().isEmpty
        ? _sources
        : _sources.where((source) {
            final title = (source['title'] ?? source['label'] ?? source['id'] ?? '').toString().toLowerCase();
            return title.contains(_query.toLowerCase());
          }).toList(growable: false);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showSearch)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: TextField(
              controller: TextEditingController(text: _query),
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search sources'),
              onChanged: (value) {
                setState(() => _query = value);
                _emit('query_change', _statePayload());
              },
            ),
          ),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: visible.length,
            itemBuilder: (context, index) {
              final source = visible[index];
              final id = (source['id'] ?? 'source_$index').toString();
              final selected = id == _selectedId;
              return ListTile(
                dense: dense,
                selected: selected,
                title: Text((source['title'] ?? source['label'] ?? id).toString()),
                subtitle: source['subtitle'] == null ? null : Text(source['subtitle'].toString()),
                onTap: () {
                  setState(() => _selectedId = id);
                  _emit('select', {'id': id, 'index': index, 'source': source, ..._statePayload()});
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
