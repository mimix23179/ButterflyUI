import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/common/icon_value.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildBreadcrumbBarControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ButterflyUIBreadcrumbBar(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _ButterflyUIBreadcrumbBar extends StatefulWidget {
  const _ButterflyUIBreadcrumbBar({
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
  State<_ButterflyUIBreadcrumbBar> createState() =>
      _ButterflyUIBreadcrumbBarState();
}

class _ButterflyUIBreadcrumbBarState extends State<_ButterflyUIBreadcrumbBar> {
  Map<String, Object?> _liveProps = const <String, Object?>{};
  List<Map<String, Object?>> _items = const <Map<String, Object?>>[];
  int? _currentIndex;

  @override
  void initState() {
    super.initState();
    _syncFromProps(widget.props);
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _ButterflyUIBreadcrumbBar oldWidget) {
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
      _syncFromProps(widget.props);
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
      case 'set_items':
        {
          setState(() {
            final merged = <String, Object?>{
              ..._liveProps,
              'items': args['items'],
            };
            _syncFromProps(merged);
          });
          return _statePayload();
        }
      case 'set_index':
        {
          setState(() {
            _currentIndex = _clampIndex(coerceOptionalInt(args['index']));
          });
          return _statePayload();
        }
      case 'navigate_path':
        {
          final path = args['path']?.toString() ?? '';
          setState(() {
            _syncFromProps(<String, Object?>{..._liveProps, 'path': path});
          });
          return _statePayload();
        }
      case 'set_props':
        {
          final incoming = args['props'];
          if (incoming is Map) {
            setState(() {
              _syncFromProps(<String, Object?>{
                ..._liveProps,
                ...coerceObjectMap(incoming),
              });
            });
          }
          return _statePayload();
        }
      case 'get_state':
        return _statePayload();
      case 'emit':
      case 'trigger':
        {
          final fallback = method == 'trigger' ? 'navigate' : method;
          final event = (args['event'] ?? args['name'] ?? fallback).toString();
          final payload = args['payload'] is Map
              ? coerceObjectMap(args['payload'] as Map)
              : <String, Object?>{};
          _emit(event, payload);
          return true;
        }
      default:
        throw UnsupportedError('Unknown breadcrumb_bar method: $method');
    }
  }

  void _syncFromProps(Map<String, Object?> props) {
    _liveProps = <String, Object?>{...props};
    _items = _resolveItems(_liveProps);
    _currentIndex = _clampIndex(
      coerceOptionalInt(_liveProps['current_index']) ??
          coerceOptionalInt(_liveProps['index']) ??
          (_items.isEmpty ? null : _items.length - 1),
    );
  }

  int? _clampIndex(int? value) {
    if (value == null || _items.isEmpty) {
      return _items.isEmpty ? null : 0;
    }
    return value.clamp(0, _items.length - 1);
  }

  List<Map<String, Object?>> _resolveItems(Map<String, Object?> props) {
    final rawItems =
        props['items'] ??
        props['crumbs'] ??
        props['routes'] ??
        props['path_items'];
    final items = <Map<String, Object?>>[];
    if (rawItems is List) {
      for (final raw in rawItems) {
        if (raw is Map) {
          items.add(coerceObjectMap(raw));
        } else if (raw != null) {
          final label = raw.toString();
          items.add({'id': label, 'label': label});
        }
      }
    }
    if (items.isEmpty && props['path'] != null) {
      final path = props['path'].toString();
      for (final segment in path.split('/')) {
        if (segment.trim().isEmpty) {
          continue;
        }
        items.add({'id': segment, 'label': segment});
      }
    }
    if (props['show_root'] == true && items.isNotEmpty) {
      final first = items.first;
      if ((first['id']?.toString() ?? '') != '__root__') {
        items.insert(0, {'id': '__root__', 'label': 'root'});
      }
    }
    return items;
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      'items': _items,
      'current_index': _currentIndex,
      'count': _items.length,
      'path': _items
          .where((item) => item['id']?.toString() != '__root__')
          .map((item) => item['id']?.toString() ?? '')
          .where((value) => value.isNotEmpty)
          .join('/'),
    };
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) {
      return;
    }
    widget.sendEvent(widget.controlId, event, payload);
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) {
      return const SizedBox.shrink();
    }

    final separator = _liveProps['separator']?.toString() ?? '/';
    final dense = _liveProps['dense'] == true || _liveProps['compact'] == true;
    final maxItems = (coerceOptionalInt(_liveProps['max_items']) ?? 0).clamp(
      0,
      99,
    );

    final display = <Map<String, Object?>>[];
    if (maxItems > 0 && _items.length > maxItems && maxItems >= 2) {
      display.add(_items.first);
      display.add({'id': '__ellipsis__', 'label': '...'});
      display.addAll(_items.sublist(_items.length - (maxItems - 1)));
    } else {
      display.addAll(_items);
    }

    final children = <Widget>[];
    for (var i = 0; i < display.length; i += 1) {
      final item = display[i];
      final itemIndex = item['id']?.toString() == '__ellipsis__'
          ? null
          : _items.indexWhere(
              (candidate) =>
                  candidate['id']?.toString() == item['id']?.toString(),
            );
      final isLast = i == display.length - 1;
      final isEllipsis = item['id']?.toString() == '__ellipsis__';
      final label =
          item['label']?.toString() ?? item['id']?.toString() ?? 'item';
      final selectedByIndex = itemIndex != null && itemIndex == _currentIndex;

      Widget crumb;
      if (isEllipsis) {
        crumb = Text(label, style: Theme.of(context).textTheme.bodySmall);
      } else {
        final icon = buildIconValue(item['icon'], size: 14);
        crumb = InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: widget.controlId.isEmpty
              ? null
              : () {
                  if (itemIndex != null) {
                    setState(() => _currentIndex = itemIndex);
                  }
                  final payload = <String, Object?>{
                    'id': item['id']?.toString() ?? label,
                    'label': label,
                    ...?(itemIndex == null
                        ? null
                        : <String, Object?>{'index': itemIndex}),
                    'is_last': isLast,
                    'item': item,
                  };
                  _emit('select', payload);
                  _emit('navigate', payload);
                  _emit('change', payload);
                },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: dense ? 4 : 6,
              vertical: dense ? 2 : 4,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[icon, const SizedBox(width: 4)],
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: (isLast || selectedByIndex)
                      ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        )
                      : null,
                ),
              ],
            ),
          ),
        );
      }

      children.add(crumb);

      if (!isLast) {
        children.add(
          Padding(
            padding: EdgeInsets.symmetric(horizontal: dense ? 2 : 4),
            child: Text(
              separator,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        );
      }
    }

    final bar = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: children),
    );
    return applyControlFrameLayout(
      props: _liveProps,
      child: bar,
      clipToRadius: true,
      defaultRadius: coerceDouble(_liveProps['radius']),
    );
  }
}
