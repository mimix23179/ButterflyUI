import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class ButterflyUITabsWidget extends StatefulWidget {
  const ButterflyUITabsWidget({
    super.key,
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
  State<ButterflyUITabsWidget> createState() => _ButterflyUITabsWidgetState();
}

class _ButterflyUITabsWidgetState extends State<ButterflyUITabsWidget>
    with SingleTickerProviderStateMixin {
  TabController? _controller;
  Map<String, Object?> _liveProps = const <String, Object?>{};
  int _lastReported = 0;
  int _activeIndex = 0;
  bool _suppressEvents = false;

  @override
  void initState() {
    super.initState();
    _syncFromProps(widget.props);
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
    _syncController();
  }

  @override
  void didUpdateWidget(covariant ButterflyUITabsWidget oldWidget) {
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

    final oldCount = _resolveChildren(oldWidget.rawChildren).length;
    _syncController();
    final controller = _controller;
    if (controller == null) {
      return;
    }

    if (oldCount != _resolveChildren(widget.rawChildren).length) {
      final safeIndex = _safeIndex(_activeIndex, controller.length);
      if (controller.index != safeIndex) {
        _suppressEvents = true;
        controller.index = safeIndex;
        _suppressEvents = false;
      }
      _lastReported = safeIndex;
      if (_activeIndex != safeIndex && mounted) {
        setState(() => _activeIndex = safeIndex);
      }
    } else {
      _setIndex(_resolveInitialIndex());
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    _disposeController();
    super.dispose();
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_index':
      case 'set_selected':
        {
          final nextIndex =
              coerceOptionalInt(
                args['index'] ?? args['selected_index'] ?? args['selected'],
              ) ??
              _activeIndex;
          _setIndex(nextIndex);
          return _statePayload();
        }
      case 'set_props':
        {
          final incoming = args['props'];
          if (incoming is Map) {
            final nextProps = coerceObjectMap(incoming);
            setState(() {
              _syncFromProps(<String, Object?>{..._liveProps, ...nextProps});
              if (nextProps.containsKey('children') ||
                  nextProps.containsKey('controls') ||
                  nextProps.containsKey('labels')) {
                _syncController();
              }
              _setIndex(_resolveInitialIndex());
            });
          }
          return _statePayload();
        }
      case 'get_state':
        return _statePayload();
      case 'emit':
      case 'trigger':
        {
          final fallback = method == 'trigger' ? 'change' : method;
          final event = (args['event'] ?? args['name'] ?? fallback).toString();
          final payload = args['payload'] is Map
              ? coerceObjectMap(args['payload'] as Map)
              : <String, Object?>{};
          _emit(event, payload);
          return true;
        }
      default:
        throw UnsupportedError('Unknown tabs method: $method');
    }
  }

  void _syncFromProps(Map<String, Object?> props) {
    _liveProps = <String, Object?>{...props};
  }

  List<Map<String, Object?>> _resolveChildren(List<dynamic> rawChildren) {
    final out = <Map<String, Object?>>[];
    for (final child in rawChildren) {
      if (child is Map) {
        out.add(coerceObjectMap(child));
      }
    }
    if (out.isNotEmpty) {
      return out;
    }
    final propChildren = _liveProps['children'] ?? _liveProps['controls'];
    if (propChildren is List) {
      for (final child in propChildren) {
        if (child is Map) {
          out.add(coerceObjectMap(child));
        }
      }
    }
    return out;
  }

  int get _tabCount {
    final childCount = _resolveChildren(widget.rawChildren).length;
    final labelCount = _resolveLabels().length;
    if (childCount == 0) {
      return labelCount;
    }
    return childCount > labelCount ? childCount : labelCount;
  }

  int _resolveInitialIndex() {
    return coerceOptionalInt(
          _liveProps['index'] ??
              _liveProps['selected_index'] ??
              _liveProps['selected'],
        ) ??
        0;
  }

  void _syncController() {
    final count = _tabCount;
    if (count <= 0) {
      _disposeController();
      return;
    }
    if (_controller == null || _controller!.length != count) {
      final hadController = _controller != null;
      _disposeController();
      final seedIndex = hadController ? _activeIndex : _resolveInitialIndex();
      final safeIndex = _safeIndex(seedIndex, count);
      _controller = TabController(
        length: count,
        vsync: this,
        initialIndex: safeIndex,
      );
      _lastReported = safeIndex;
      _activeIndex = safeIndex;
      _controller!.addListener(_handleTabChange);
    }
  }

  void _disposeController() {
    _controller?.removeListener(_handleTabChange);
    _controller?.dispose();
    _controller = null;
  }

  void _setIndex(int value) {
    final controller = _controller;
    if (controller == null) {
      return;
    }
    final safeIndex = _safeIndex(value, controller.length);
    if (safeIndex == controller.index) {
      if (_activeIndex != safeIndex && mounted) {
        setState(() => _activeIndex = safeIndex);
      }
      return;
    }
    _suppressEvents = true;
    controller.index = safeIndex;
    _lastReported = safeIndex;
    if (_activeIndex != safeIndex && mounted) {
      setState(() => _activeIndex = safeIndex);
    }
    _suppressEvents = false;
  }

  int _safeIndex(int value, int count) {
    if (count <= 0) {
      return 0;
    }
    return value.clamp(0, count - 1);
  }

  void _handleTabChange() {
    final controller = _controller;
    if (controller == null || _suppressEvents) {
      return;
    }
    final nextIndex = controller.index;
    if (nextIndex != _activeIndex && mounted) {
      setState(() => _activeIndex = nextIndex);
    }
    if (controller.index != _lastReported) {
      _lastReported = controller.index;
      _emit('change', {
        'index': controller.index,
        'label': _labelAt(controller.index),
      });
    }
  }

  List<String> _resolveLabels() {
    final raw = _liveProps['labels'];
    if (raw is List) {
      return raw
          .map((value) => value?.toString() ?? '')
          .toList(growable: false);
    }
    return const <String>[];
  }

  String _labelAt(int index) {
    final labels = _resolveLabels();
    if (index >= 0 && index < labels.length) {
      final label = labels[index].trim();
      if (label.isNotEmpty) {
        return label;
      }
    }
    return 'Tab ${index + 1}';
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      'index': _activeIndex,
      'selected_index': _activeIndex,
      'label': _labelAt(_activeIndex),
      'count': _tabCount,
      'labels': _resolveLabels(),
      'scrollable': _liveProps['scrollable'] == true,
      'closable': _liveProps['closable'] == true,
      'show_add': _liveProps['show_add'] == true,
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
    final controller = _controller;
    if (controller == null || _tabCount <= 0) {
      return const SizedBox.shrink();
    }

    final children = _resolveChildren(widget.rawChildren);
    final labels = List<String>.generate(_tabCount, _labelAt, growable: false);
    final safeIndex = _safeIndex(_activeIndex, _tabCount);
    final tabs = labels
        .asMap()
        .entries
        .map((entry) {
          final index = entry.key;
          final label = entry.value;
          if (_liveProps['closable'] != true) {
            return Tab(text: label);
          }
          return Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => _emit('close', {'index': index, 'label': label}),
                  child: const Icon(Icons.close, size: 14),
                ),
              ],
            ),
          );
        })
        .toList(growable: false);

    final tabBar = TabBar(
      controller: controller,
      isScrollable: _liveProps['scrollable'] == true,
      tabs: tabs,
    );

    final activeChild = children.isNotEmpty && safeIndex < children.length
        ? widget.buildChild(children[safeIndex])
        : SizedBox.expand(
            child: Center(
              child: Text(
                labels[safeIndex],
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          );

    final tabsBody = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: tabBar),
            if (_liveProps['show_add'] == true)
              IconButton(
                onPressed: () => _emit('add', {'count': _tabCount}),
                icon: const Icon(Icons.add),
              ),
          ],
        ),
        Expanded(child: SizedBox.expand(child: activeChild)),
      ],
    );

    final radius = coerceDouble(_liveProps['radius']);
    return applyControlFrameLayout(
      props: _liveProps,
      child: tabsBody,
      clipToRadius: true,
      defaultRadius: radius,
    );
  }
}
