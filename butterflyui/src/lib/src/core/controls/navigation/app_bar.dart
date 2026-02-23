import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class ButterflyUIAppBar extends StatefulWidget {
  final String controlId;
  final String? title;
  final String? subtitle;
  final bool centerTitle;
  final double height;
  final Color? bgcolor;
  final double elevation;
  final EdgeInsets padding;
  final Widget? leading;
  final List<Widget> actions;
  final bool showSearch;
  final String searchValue;
  final String? searchPlaceholder;
  final bool searchEnabled;
  final bool emitOnSearchChange;
  final int searchDebounceMs;
  final Set<String> events;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUIAppBar({
    super.key,
    required this.controlId,
    required this.title,
    required this.subtitle,
    required this.centerTitle,
    required this.height,
    required this.bgcolor,
    required this.elevation,
    required this.padding,
    required this.leading,
    required this.actions,
    required this.showSearch,
    required this.searchValue,
    required this.searchPlaceholder,
    required this.searchEnabled,
    required this.emitOnSearchChange,
    required this.searchDebounceMs,
    required this.events,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<ButterflyUIAppBar> createState() => _ButterflyUIAppBarState();
}

class _ButterflyUIAppBarState extends State<ButterflyUIAppBar> {
  late TextEditingController _controller;
  Timer? _searchDebounce;
  String _lastValue = '';
  String? _title;
  String? _subtitle;

  @override
  void initState() {
    super.initState();
    _lastValue = widget.searchValue;
    _title = widget.title;
    _subtitle = widget.subtitle;
    _controller = TextEditingController(text: widget.searchValue);
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant ButterflyUIAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    if (widget.searchValue != _lastValue) {
      _lastValue = widget.searchValue;
      _controller.text = widget.searchValue;
    }
    if (widget.title != oldWidget.title) {
      _title = widget.title;
    }
    if (widget.subtitle != oldWidget.subtitle) {
      _subtitle = widget.subtitle;
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    _searchDebounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_title':
        setState(() {
          _title = args['title']?.toString() ?? _title;
          if (args.containsKey('subtitle')) {
            _subtitle = args['subtitle']?.toString();
          }
        });
        return _state();
      case 'set_props':
        final incoming = args['props'];
        if (incoming is Map) {
          final props = Map<String, Object?>.from(incoming);
          setState(() {
            if (props.containsKey('title')) {
              _title = props['title']?.toString();
            }
            if (props.containsKey('subtitle')) {
              _subtitle = props['subtitle']?.toString();
            }
            final nextSearchValue = props['search_value']?.toString();
            if (nextSearchValue != null && nextSearchValue != _lastValue) {
              _lastValue = nextSearchValue;
              _controller.text = nextSearchValue;
            }
          });
        }
        return _state();
      case 'get_state':
        return _state();
      case 'emit':
      case 'trigger':
        {
          final fallback = method == 'trigger' ? 'change' : method;
          final event = (args['event'] ?? args['name'] ?? fallback).toString();
          final payload = args['payload'] is Map
              ? Map<String, Object?>.from(args['payload'] as Map)
              : <String, Object?>{};
          _emit(event, payload);
          return true;
        }
      default:
        throw UnsupportedError('Unknown app_bar method: $method');
    }
  }

  Map<String, Object?> _state() {
    return <String, Object?>{
      'title': _title,
      'subtitle': _subtitle,
      'search_value': _lastValue,
      'show_search': widget.showSearch,
      'search_enabled': widget.searchEnabled,
    };
  }

  bool _allowsEvent(String name) {
    if (widget.events.isEmpty) {
      return true;
    }
    return widget.events.contains(name);
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    if (!_allowsEvent(event)) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  void _onSearchChanged(String value) {
    _lastValue = value;
    if (!widget.emitOnSearchChange) {
      return;
    }
    _searchDebounce?.cancel();
    final delay = widget.searchDebounceMs < 0 ? 0 : widget.searchDebounceMs;
    if (delay == 0) {
      _emit('search', {'query': value});
      return;
    }
    _searchDebounce = Timer(Duration(milliseconds: delay), () {
      _emit('search', {'query': value});
    });
  }

  @override
  Widget build(BuildContext context) {
    final titleWidget = (widget.title == null && widget.subtitle == null)
        ? const SizedBox.shrink()
        : Column(
            crossAxisAlignment: widget.centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_title != null)
                Text(_title!, style: const TextStyle(fontWeight: FontWeight.w600)),
              if (_subtitle != null) Text(_subtitle!, style: Theme.of(context).textTheme.bodySmall),
            ],
          );

    final searchField = SizedBox(
      width: 220,
      child: TextField(
        controller: _controller,
        enabled: widget.searchEnabled,
        onChanged: _onSearchChanged,
        onSubmitted: (value) {
          _lastValue = value;
          _emit('search_submit', {'query': value});
        },
        decoration: InputDecoration(
          isDense: true,
          prefixIcon: const Icon(Icons.search),
          hintText: widget.searchPlaceholder ?? 'Search',
        ),
      ),
    );

    final animatedSearchField = PageTransitionSwitcher(
      duration: const Duration(milliseconds: 180),
      transitionBuilder: (child, animation, secondaryAnimation) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          fillColor: Colors.transparent,
          child: child,
        );
      },
      child: widget.showSearch
          ? KeyedSubtree(
              key: const ValueKey<String>('search-visible'),
              child: searchField,
            )
          : const SizedBox(key: ValueKey<String>('search-hidden')),
    );

    final row = Row(
      children: [
        if (widget.leading != null) widget.leading!,
        Expanded(
          child: Align(
            alignment: widget.centerTitle ? Alignment.center : Alignment.centerLeft,
            child: titleWidget,
          ),
        ),
        if (widget.showSearch) const SizedBox(width: 12),
        animatedSearchField,
        if (widget.actions.isNotEmpty) ...widget.actions,
      ],
    );

    return Material(
      color: widget.bgcolor ?? Theme.of(context).colorScheme.surface,
      elevation: widget.elevation,
      child: SizedBox(
        height: widget.height,
        child: Padding(padding: widget.padding, child: row),
      ),
    );
  }
}

