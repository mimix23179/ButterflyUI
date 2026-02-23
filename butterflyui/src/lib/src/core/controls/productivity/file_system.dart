import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildFileSystemControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _FileSystemControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _FileSystemControl extends StatefulWidget {
  const _FileSystemControl({
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
  State<_FileSystemControl> createState() => _FileSystemControlState();
}

class _FileSystemControlState extends State<_FileSystemControl> {
  String? _selectedPath;

  @override
  void initState() {
    super.initState();
    _selectedPath = widget.props['selected_path']?.toString();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _FileSystemControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    final nextSelected = widget.props['selected_path']?.toString();
    final oldSelected = oldWidget.props['selected_path']?.toString();
    if (nextSelected != oldSelected && nextSelected != _selectedPath) {
      _selectedPath = nextSelected;
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
      case 'set_selected_path':
        setState(() {
          _selectedPath = args['path']?.toString();
        });
        return _state();
      case 'get_state':
        return _state();
      case 'emit':
        final event = (args['event'] ?? 'select').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        if (widget.controlId.isNotEmpty) {
          widget.sendEvent(widget.controlId, event, payload);
        }
        return true;
      default:
        throw UnsupportedError('Unknown file_system method: $method');
    }
  }

  Map<String, Object?> _state() => <String, Object?>{'selected_path': _selectedPath};

  @override
  Widget build(BuildContext context) {
    final nodes = widget.props['nodes'] is List ? widget.props['nodes'] as List : const <Object?>[];

    return ListView.builder(
      itemCount: nodes.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final node = nodes[index] is Map ? coerceObjectMap(nodes[index] as Map) : <String, Object?>{};
        final path = (node['path'] ?? node['id'] ?? '/$index').toString();
        final name = (node['name'] ?? path).toString();
        final isDir = node['is_dir'] == true;
        final selected = _selectedPath == path;

        return ListTile(
          dense: true,
          selected: selected,
          leading: Icon(isDir ? Icons.folder : Icons.description),
          title: Text(name),
          subtitle: Text(path),
          onTap: () {
            setState(() {
              _selectedPath = path;
            });
            if (widget.controlId.isNotEmpty) {
              widget.sendEvent(widget.controlId, 'select', {'path': path, 'node': node});
            }
          },
        );
      },
    );
  }
}
