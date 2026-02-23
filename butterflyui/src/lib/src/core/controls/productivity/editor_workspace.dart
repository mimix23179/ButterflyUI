import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class _EditorDoc {
  final String id;
  final String title;
  final bool dirty;

  const _EditorDoc({required this.id, required this.title, required this.dirty});
}

_EditorDoc _parseDoc(Object? raw, int index) {
  final map = raw is Map ? coerceObjectMap(raw) : const <String, Object?>{};
  final id = (map['id'] ?? map['path'] ?? 'doc_$index').toString();
  return _EditorDoc(
    id: id,
    title: (map['title'] ?? map['name'] ?? id).toString(),
    dirty: map['dirty'] == true,
  );
}

class _EditorWorkspaceControl extends StatefulWidget {
  const _EditorWorkspaceControl({
    required this.controlId,
    required this.props,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_EditorWorkspaceControl> createState() => _EditorWorkspaceControlState();
}

class _EditorWorkspaceControlState extends State<_EditorWorkspaceControl> {
  late final List<_EditorDoc> _docs;
  late String _activeDocId;

  void _syncFromProps(Map<String, Object?> props) {
    _docs
      ..clear()
      ..addAll(() {
        final rawDocs = props['documents'] ?? props['tabs'] ?? const [];
        final docs = <_EditorDoc>[];
        if (rawDocs is List) {
          for (var i = 0; i < rawDocs.length; i += 1) {
            docs.add(_parseDoc(rawDocs[i], i));
          }
        }
        return docs;
      }());

    final nextActive = (props['active_id'] ?? (_docs.isNotEmpty ? _docs.first.id : '')).toString();
    if (nextActive.isNotEmpty) {
      _activeDocId = nextActive;
      return;
    }
    if (_docs.any((doc) => doc.id == _activeDocId)) {
      return;
    }
    _activeDocId = _docs.isNotEmpty ? _docs.first.id : '';
  }

  @override
  void initState() {
    super.initState();
    _docs = <_EditorDoc>[];
    _activeDocId = '';
    _syncFromProps(widget.props);
  }

  @override
  void didUpdateWidget(covariant _EditorWorkspaceControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.props != widget.props || oldWidget.controlId != widget.controlId) {
      _syncFromProps(widget.props);
    }
  }

  @override
  Widget build(BuildContext context) {
    final showExplorer = widget.props['show_explorer'] != false;
    final showProblems = widget.props['show_problems'] == true;
    final showStatusBar = widget.props['show_status_bar'] != false;
    final editorRow = Row(
      children: [
        if (showExplorer)
          Container(
            width: 220,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: _ExplorerPane(
              items: widget.props['workspace_nodes'],
              onOpen: (payload) =>
                  widget.sendEvent(widget.controlId, 'open_node', payload),
            ),
          ),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    _activeDocId.isEmpty
                        ? 'No active document'
                        : 'Editor region: $_activeDocId',
                  ),
                ),
              ),
              if (showProblems)
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Theme.of(context).dividerColor),
                    ),
                  ),
                  child: _ProblemsPane(
                    items: widget.props['problems'],
                    onSelect: (payload) =>
                        widget.sendEvent(widget.controlId, 'select_problem', payload),
                  ),
                ),
            ],
          ),
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final hasBoundedHeight = constraints.hasBoundedHeight;
        final body = hasBoundedHeight
            ? Expanded(child: editorRow)
            : SizedBox(height: 360, child: editorRow);

        return Column(
          mainAxisSize: hasBoundedHeight ? MainAxisSize.max : MainAxisSize.min,
          children: [
            SizedBox(
              height: 36,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _docs.length,
                itemBuilder: (context, index) {
                  final doc = _docs[index];
                  final active = doc.id == _activeDocId;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _activeDocId = doc.id;
                      });
                      widget.sendEvent(widget.controlId, 'select_tab', {
                        'id': doc.id,
                        'title': doc.title,
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: active
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(doc.title),
                          if (doc.dirty)
                            Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: Icon(
                                Icons.circle,
                                size: 8,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            body,
            if (showStatusBar)
              Container(
                height: 24,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Theme.of(context).dividerColor),
                  ),
                ),
                child: Text((widget.props['status_text'] ?? 'Ready').toString()),
              ),
          ],
        );
      },
    );
  }
}

class _ExplorerPane extends StatelessWidget {
  const _ExplorerPane({required this.items, required this.onOpen});

  final Object? items;
  final void Function(Map<String, Object?> payload) onOpen;

  @override
  Widget build(BuildContext context) {
    if (items is! List || (items as List).isEmpty) {
      return const Center(child: Text('No files'));
    }
    final list = items as List;
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final map = coerceObjectMap(list[index]);
        final id = (map['id'] ?? map['path'] ?? 'node_$index').toString();
        final label = (map['label'] ?? map['name'] ?? id).toString();
        return ListTile(
          dense: true,
          leading: const Icon(Icons.description_outlined, size: 18),
          title: Text(label, overflow: TextOverflow.ellipsis),
          onTap: () => onOpen({'id': id, 'label': label}),
        );
      },
    );
  }
}

class _ProblemsPane extends StatelessWidget {
  const _ProblemsPane({required this.items, required this.onSelect});

  final Object? items;
  final void Function(Map<String, Object?> payload) onSelect;

  @override
  Widget build(BuildContext context) {
    if (items is! List || (items as List).isEmpty) {
      return const Center(child: Text('No problems'));
    }
    final list = items as List;
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final map = coerceObjectMap(list[index]);
        final message = (map['message'] ?? 'Problem ${index + 1}').toString();
        final severity = (map['severity'] ?? 'info').toString();
        return ListTile(
          dense: true,
          leading: Icon(
            severity == 'error'
                ? Icons.error_outline
                : (severity == 'warning'
                    ? Icons.warning_amber_outlined
                    : Icons.info_outline),
            size: 18,
          ),
          title: Text(message, overflow: TextOverflow.ellipsis),
          onTap: () => onSelect({
            'severity': severity,
            'message': message,
            if (map['file'] != null) 'file': map['file'].toString(),
            if (map['line'] != null) 'line': map['line'],
            if (map['column'] != null) 'column': map['column'],
          }),
        );
      },
    );
  }
}

Widget buildEditorWorkspaceControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _EditorWorkspaceControl(
    controlId: controlId,
    props: props,
    sendEvent: sendEvent,
  );
}
