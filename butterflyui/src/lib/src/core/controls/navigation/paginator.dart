import 'package:flutter/material.dart';

import 'package:conduit_runtime/src/core/control_utils.dart';
import 'package:conduit_runtime/src/core/webview/webview_api.dart';

Widget buildPaginatorControl(
  String controlId,
  Map<String, Object?> props,
  ConduitRegisterInvokeHandler registerInvokeHandler,
  ConduitUnregisterInvokeHandler unregisterInvokeHandler,
  ConduitSendRuntimeEvent sendEvent,
) {
  return ConduitPaginator(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class ConduitPaginator extends StatefulWidget {
  final String controlId;
  final Map<String, Object?> props;
  final ConduitRegisterInvokeHandler registerInvokeHandler;
  final ConduitUnregisterInvokeHandler unregisterInvokeHandler;
  final ConduitSendRuntimeEvent sendEvent;

  const ConduitPaginator({
    super.key,
    required this.controlId,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<ConduitPaginator> createState() => _ConduitPaginatorState();
}

class _ConduitPaginatorState extends State<ConduitPaginator> {
  int _page = 1;
  int _pageCount = 1;

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant ConduitPaginator oldWidget) {
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

  @override
  Widget build(BuildContext context) {
    final dense = widget.props['dense'] == true;
    final enabled = widget.props['enabled'] == null
        ? true
        : (widget.props['enabled'] == true);
    final showEdges = widget.props['show_edges'] == true;
    final maxVisible = (coerceOptionalInt(widget.props['max_visible']) ?? 7)
        .clamp(3, 15);
    final previousLabel = (widget.props['prev_label'] ?? 'Prev').toString();
    final nextLabel = (widget.props['next_label'] ?? 'Next').toString();

    final pageButtons = _buildPageButtonModels(maxVisible, showEdges);
    final spacing = dense ? 4.0 : 6.0;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _buildActionButton(
          context: context,
          label: previousLabel,
          onPressed: enabled && _page > 1 ? () => _setPage(_page - 1) : null,
          dense: dense,
        ),
        ...pageButtons.map(
          (model) => model.isGap
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: dense ? 2 : 4),
                  child: Text(
                    '...',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                )
              : _buildPageButton(
                  context: context,
                  page: model.page,
                  selected: model.page == _page,
                  enabled: enabled,
                  dense: dense,
                ),
        ),
        _buildActionButton(
          context: context,
          label: nextLabel,
          onPressed: enabled && _page < _pageCount
              ? () => _setPage(_page + 1)
              : null,
          dense: dense,
        ),
      ],
    );
  }

  void _syncFromProps() {
    final pageCount = _resolvePageCount(widget.props);
    final page = (coerceOptionalInt(widget.props['page']) ?? 1).clamp(
      1,
      pageCount,
    );
    setState(() {
      _pageCount = pageCount;
      _page = page;
    });
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_page':
        final requested = coerceOptionalInt(args['page']) ?? _page;
        _setPage(requested);
        return _statePayload();
      case 'next':
        _setPage(_page + 1);
        return _statePayload();
      case 'prev':
        _setPage(_page - 1);
        return _statePayload();
      case 'first':
        _setPage(1);
        return _statePayload();
      case 'last':
        _setPage(_pageCount);
        return _statePayload();
      case 'get_state':
        return _statePayload();
      default:
        throw Exception('Unknown paginator method: $method');
    }
  }

  void _setPage(int value) {
    final next = value.clamp(1, _pageCount);
    if (next == _page) return;
    setState(() {
      _page = next;
    });
    final payload = _statePayload();
    _emit('change', payload);
    _emit('input', payload);
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      'page': _page,
      'page_count': _pageCount,
      'has_prev': _page > 1,
      'has_next': _page < _pageCount,
    };
  }

  void _emit(String name, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, name, payload);
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required VoidCallback? onPressed,
    required bool dense,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        visualDensity: dense ? VisualDensity.compact : VisualDensity.standard,
        minimumSize: Size(0, dense ? 30 : 36),
      ),
      child: Text(label),
    );
  }

  Widget _buildPageButton({
    required BuildContext context,
    required int page,
    required bool selected,
    required bool enabled,
    required bool dense,
  }) {
    final style = selected
        ? FilledButton.styleFrom(
            visualDensity: dense
                ? VisualDensity.compact
                : VisualDensity.standard,
            minimumSize: Size(dense ? 32 : 36, dense ? 30 : 36),
            padding: EdgeInsets.symmetric(horizontal: dense ? 8 : 10),
          )
        : OutlinedButton.styleFrom(
            visualDensity: dense
                ? VisualDensity.compact
                : VisualDensity.standard,
            minimumSize: Size(dense ? 32 : 36, dense ? 30 : 36),
            padding: EdgeInsets.symmetric(horizontal: dense ? 8 : 10),
          );

    final button = selected
        ? FilledButton(
            onPressed: enabled ? () => _setPage(page) : null,
            style: style,
            child: Text(page.toString()),
          )
        : OutlinedButton(
            onPressed: enabled ? () => _setPage(page) : null,
            style: style,
            child: Text(page.toString()),
          );
    return button;
  }

  List<_PageButtonModel> _buildPageButtonModels(
    int maxVisible,
    bool showEdges,
  ) {
    if (_pageCount <= maxVisible) {
      return List.generate(
        _pageCount,
        (index) => _PageButtonModel.page(index + 1),
      );
    }

    final half = maxVisible ~/ 2;
    var start = _page - half;
    var end = start + maxVisible - 1;
    if (start < 1) {
      start = 1;
      end = maxVisible;
    }
    if (end > _pageCount) {
      end = _pageCount;
      start = end - maxVisible + 1;
    }

    final pages = <_PageButtonModel>[];
    if (showEdges && start > 1) {
      pages.add(_PageButtonModel.page(1));
      if (start > 2) {
        pages.add(const _PageButtonModel.gap());
      }
    }
    for (var i = start; i <= end; i += 1) {
      pages.add(_PageButtonModel.page(i));
    }
    if (showEdges && end < _pageCount) {
      if (end < _pageCount - 1) {
        pages.add(const _PageButtonModel.gap());
      }
      pages.add(_PageButtonModel.page(_pageCount));
    }
    return pages;
  }
}

int _resolvePageCount(Map<String, Object?> props) {
  final explicit = coerceOptionalInt(props['page_count']);
  if (explicit != null && explicit > 0) {
    return explicit;
  }
  final totalItems = coerceOptionalInt(props['total_items']) ?? 0;
  final pageSize = (coerceOptionalInt(props['page_size']) ?? 1).clamp(
    1,
    100000,
  );
  if (totalItems <= 0) return 1;
  return (totalItems / pageSize).ceil().clamp(1, 100000);
}

class _PageButtonModel {
  final bool isGap;
  final int page;

  const _PageButtonModel.page(this.page) : isGap = false;
  const _PageButtonModel.gap() : isGap = true, page = -1;
}
