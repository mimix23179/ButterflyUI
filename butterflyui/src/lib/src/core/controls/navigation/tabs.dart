import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class ButterflyUITabsWidget extends StatefulWidget {
  final String controlId;
  final List<String> labels;
  final List<Widget> children;
  final int index;
  final bool scrollable;
  final bool closable;
  final bool showAdd;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUITabsWidget({
    super.key,
    required this.controlId,
    required this.labels,
    required this.children,
    required this.index,
    required this.scrollable,
    required this.closable,
    required this.showAdd,
    required this.sendEvent,
  });

  @override
  State<ButterflyUITabsWidget> createState() => _ButterflyUITabsWidgetState();
}

class _ButterflyUITabsWidgetState extends State<ButterflyUITabsWidget>
    with SingleTickerProviderStateMixin {
  TabController? _controller;
  int _lastReported = 0;
  int _activeIndex = 0;
  bool _suppressEvents = false;

  @override
  void initState() {
    super.initState();
    _syncController();
  }

  @override
  void didUpdateWidget(covariant ButterflyUITabsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldCount = oldWidget.children.length;
    _syncController();
    final controller = _controller;
    if (controller == null) return;

    if (oldWidget.index != widget.index) {
      _setIndex(widget.index);
      return;
    }

    if (oldCount != widget.children.length) {
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
    }
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  int get _tabCount => widget.children.length;

  void _syncController() {
    final count = _tabCount;
    if (count <= 0) {
      _disposeController();
      return;
    }
    if (_controller == null || _controller!.length != count) {
      final hadController = _controller != null;
      _disposeController();
      final seedIndex = hadController ? _activeIndex : widget.index;
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
    if (controller == null) return;
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
    if (count <= 0) return 0;
    return value.clamp(0, count - 1);
  }

  void _handleTabChange() {
    final controller = _controller;
    if (controller == null || _suppressEvents) return;
    final nextIndex = controller.index;
    if (nextIndex != _activeIndex && mounted) {
      setState(() => _activeIndex = nextIndex);
    }
    if (controller.index != _lastReported) {
      _lastReported = controller.index;
      widget.sendEvent(widget.controlId, 'change', {'index': controller.index});
    }
  }

  List<String> _resolveLabels() {
    final count = _tabCount;
    final out = <String>[];
    for (var i = 0; i < count; i += 1) {
      final raw = i < widget.labels.length ? widget.labels[i] : '';
      final label = raw.trim().isEmpty ? 'Tab ${i + 1}' : raw;
      out.add(label);
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null || _tabCount <= 0) {
      return const SizedBox.shrink();
    }

    final labels = _resolveLabels();
    final safeIndex = _safeIndex(_activeIndex, _tabCount);
    final tabs = labels.asMap().entries.map((entry) {
      final idx = entry.key;
      final label = entry.value;
      if (!widget.closable) {
        return Tab(text: label);
      }
      return Tab(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () => widget.sendEvent(widget.controlId, 'close', {
                'index': idx,
                'label': label,
              }),
              child: const Icon(Icons.close, size: 14),
            ),
          ],
        ),
      );
    }).toList();

    final tabBar = TabBar(
      controller: controller,
      isScrollable: widget.scrollable,
      tabs: tabs,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: tabBar),
            if (widget.showAdd)
              IconButton(
                onPressed: () => widget.sendEvent(widget.controlId, 'add', {}),
                icon: const Icon(Icons.add),
              ),
          ],
        ),
        Expanded(child: SizedBox.expand(child: widget.children[safeIndex])),
      ],
    );
  }
}
