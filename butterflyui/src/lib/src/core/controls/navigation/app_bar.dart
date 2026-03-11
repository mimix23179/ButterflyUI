import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_theme.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/common/icon_value.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class ButterflyUIAppBar extends StatefulWidget {
  const ButterflyUIAppBar({
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
  State<ButterflyUIAppBar> createState() => _ButterflyUIAppBarState();
}

class _ButterflyUIAppBarState extends State<ButterflyUIAppBar> {
  late TextEditingController _controller;
  Timer? _searchDebounce;
  Map<String, Object?> _liveProps = const <String, Object?>{};
  String _lastValue = '';
  String? _title;
  String? _subtitle;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _syncFromProps(widget.props);
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
    if (oldWidget.props != widget.props) {
      _syncFromProps(widget.props);
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

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_title':
        {
          setState(() {
            _title = args['title']?.toString() ?? _title;
            if (args.containsKey('subtitle')) {
              _subtitle = args['subtitle']?.toString();
            }
            _liveProps = <String, Object?>{
              ..._liveProps,
              'title': _title,
              'subtitle': _subtitle,
            };
          });
          return _state();
        }
      case 'set_search':
        {
          final nextValue =
              args['value']?.toString() ?? args['query']?.toString() ?? '';
          setState(() {
            _lastValue = nextValue;
            _controller.text = nextValue;
            _liveProps = <String, Object?>{
              ..._liveProps,
              'search_value': nextValue,
            };
          });
          return _state();
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
          return _state();
        }
      case 'get_state':
        return _state();
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
        throw UnsupportedError('Unknown app_bar method: $method');
    }
  }

  void _syncFromProps(Map<String, Object?> props) {
    _liveProps = <String, Object?>{...props};
    _title =
        _liveProps['title']?.toString() ??
        _liveProps['label']?.toString() ??
        _liveProps['text']?.toString();
    _subtitle = _liveProps['subtitle']?.toString();
    final searchValue = _liveProps['search_value']?.toString() ?? '';
    if (searchValue != _lastValue || _controller.text != searchValue) {
      _lastValue = searchValue;
      _controller.text = searchValue;
    }
  }

  Map<String, Object?> _state() {
    return <String, Object?>{
      'title': _title,
      'subtitle': _subtitle,
      'search_value': _lastValue,
      'show_search': _liveProps['show_search'] == true,
      'search_enabled': _liveProps['search_enabled'] == null
          ? true
          : (_liveProps['search_enabled'] == true),
      'action_count': _resolveActionDescriptors().length,
    };
  }

  bool _allowsEvent(String name) {
    final rawEvents = _liveProps['events'];
    if (rawEvents is! List || rawEvents.isEmpty) {
      return true;
    }
    return rawEvents.any((event) => event?.toString() == name);
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) {
      return;
    }
    if (!_allowsEvent(event)) {
      return;
    }
    widget.sendEvent(widget.controlId, event, payload);
  }

  void _onSearchChanged(String value) {
    _lastValue = value;
    _liveProps = <String, Object?>{..._liveProps, 'search_value': value};
    final emitOnSearchChange = _liveProps['emit_on_search_change'] == null
        ? true
        : (_liveProps['emit_on_search_change'] == true);
    if (!emitOnSearchChange) {
      return;
    }
    _searchDebounce?.cancel();
    final delay = coerceOptionalInt(_liveProps['search_debounce_ms']) ?? 180;
    if (delay <= 0) {
      _emit('search', {'query': value});
      return;
    }
    _searchDebounce = Timer(Duration(milliseconds: delay), () {
      _emit('search', {'query': value});
    });
  }

  bool _isControlMap(Map<String, Object?> value) {
    return value.containsKey('control_type') ||
        (value.containsKey('type') && value.containsKey('props')) ||
        value.containsKey('children');
  }

  Map<String, Object?> _coerceDescriptor(Object? raw, int index) {
    if (raw is Map) {
      final map = coerceObjectMap(raw);
      return <String, Object?>{
        'id': map['id'] ?? map['value'] ?? 'action-$index',
        'label': map['label'] ?? map['text'] ?? map['title'] ?? '',
        ...map,
      };
    }
    final label = raw?.toString() ?? 'Action';
    return <String, Object?>{'id': 'action-$index', 'label': label};
  }

  List<Map<String, Object?>> _resolveActionDescriptors() {
    final raw = _liveProps['actions'];
    if (raw is! List) {
      return const <Map<String, Object?>>[];
    }
    final items = <Map<String, Object?>>[];
    for (var i = 0; i < raw.length; i += 1) {
      items.add(_coerceDescriptor(raw[i], i));
    }
    return items;
  }

  Widget? _buildLeading(BuildContext context) {
    final leading = _liveProps['leading'];
    if (leading is Map) {
      final control = coerceObjectMap(leading);
      if (_isControlMap(control)) {
        return widget.buildChild(control);
      }
      return _buildDescriptorButton(
        context,
        control,
        source: 'leading',
        compact: true,
      );
    }
    if (leading != null) {
      return _buildDescriptorButton(
        context,
        <String, Object?>{'icon': leading, 'id': 'leading'},
        source: 'leading',
        compact: true,
      );
    }
    return null;
  }

  List<Widget> _buildActions(BuildContext context) {
    final actions = <Widget>[];
    final descriptors = _resolveActionDescriptors();
    for (var i = 0; i < descriptors.length; i += 1) {
      final descriptor = descriptors[i];
      if (_isControlMap(descriptor)) {
        actions.add(widget.buildChild(descriptor));
      } else {
        actions.add(
          _buildDescriptorButton(
            context,
            descriptor,
            source: 'action',
            compact: false,
          ),
        );
      }
    }
    for (final child in widget.rawChildren) {
      if (child is Map) {
        actions.add(widget.buildChild(coerceObjectMap(child)));
      }
    }
    return actions;
  }

  Widget _buildDescriptorButton(
    BuildContext context,
    Map<String, Object?> descriptor, {
    required String source,
    required bool compact,
  }) {
    final label =
        (descriptor['label'] ?? descriptor['text'] ?? descriptor['title'] ?? '')
            .toString();
    final icon = buildIconValue(
      descriptor['icon'] ?? descriptor['leading_icon'],
      size: compact ? 18 : 16,
    );
    final tooltip = descriptor['tooltip']?.toString();
    final badge = descriptor['badge']?.toString();
    final enabled = descriptor['enabled'] == null
        ? true
        : (descriptor['enabled'] == true);
    final id = (descriptor['id'] ?? descriptor['value'] ?? label).toString();

    void emitAction() {
      final payload = <String, Object?>{
        'id': id,
        'label': label,
        'source': source,
        'action': descriptor,
      };
      _emit('action', payload);
      _emit('change', payload);
    }

    final content = badge != null && badge.isNotEmpty
        ? Stack(
            clipBehavior: Clip.none,
            children: [
              if (icon != null) icon else Text(label.isEmpty ? '•' : label),
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: butterflyuiPrimary(context),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    badge,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: butterflyuiBackground(context),
                    ),
                  ),
                ),
              ),
            ],
          )
        : (icon ?? Text(label.isEmpty ? '•' : label));

    final button = label.isNotEmpty && icon == null
        ? TextButton(onPressed: enabled ? emitAction : null, child: Text(label))
        : IconButton(
            tooltip: tooltip ?? (label.isEmpty ? null : label),
            onPressed: enabled ? emitAction : null,
            icon: content,
          );
    return tooltip == null || tooltip.isEmpty
        ? button
        : Tooltip(message: tooltip, child: button);
  }

  @override
  Widget build(BuildContext context) {
    final titleWidget = (_title == null && _subtitle == null)
        ? const SizedBox.shrink()
        : Column(
            crossAxisAlignment: _liveProps['center_title'] == true
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_title != null)
                Text(
                  _title!,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: butterflyuiResolveSlotColor(
                      context,
                      _liveProps,
                      slot: 'label',
                      fallback: butterflyuiText(context),
                    ),
                  ),
                ),
              if (_subtitle != null)
                Text(
                  _subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: butterflyuiResolveSlotColor(
                      context,
                      _liveProps,
                      slot: 'helper',
                      fallback: butterflyuiMutedText(context),
                    ),
                  ),
                ),
            ],
          );

    final searchField = SizedBox(
      width: coerceDouble(_liveProps['search_width']) ?? 220,
      child: TextField(
        controller: _controller,
        enabled: _liveProps['search_enabled'] == null
            ? true
            : (_liveProps['search_enabled'] == true),
        onChanged: _onSearchChanged,
        onSubmitted: (value) {
          _lastValue = value;
          _emit('search_submit', {'query': value});
        },
        decoration: InputDecoration(
          isDense: true,
          prefixIcon: const Icon(Icons.search),
          hintText: _liveProps['search_placeholder']?.toString() ?? 'Search',
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
      child: _liveProps['show_search'] == true
          ? KeyedSubtree(
              key: const ValueKey<String>('search-visible'),
              child: searchField,
            )
          : const SizedBox(key: ValueKey<String>('search-hidden')),
    );

    final leading = _buildLeading(context);
    final actions = _buildActions(context);
    final row = Row(
      children: [
        ...?(leading == null ? null : <Widget>[leading]),
        Expanded(
          child: Align(
            alignment: _liveProps['center_title'] == true
                ? Alignment.center
                : Alignment.centerLeft,
            child: titleWidget,
          ),
        ),
        if (_liveProps['show_search'] == true) const SizedBox(width: 12),
        animatedSearchField,
        if (actions.isNotEmpty) ...actions,
      ],
    );

    final radius = coerceDouble(_liveProps['radius']) ?? 0.0;
    final clip = radius > 0 ? Clip.antiAlias : Clip.none;
    final bar = butterflyuiSurfaceContainer(
      context,
      props: _liveProps,
      fallbackBackground: butterflyuiSurface(context),
      fallbackPadding:
          coercePadding(_liveProps['padding']) ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      fallbackRadius: radius > 0 ? radius : null,
      clip: clip != Clip.none,
      child: SizedBox(
        height: coerceDouble(_liveProps['height']) ?? kToolbarHeight,
        child: row,
      ),
    );
    return applyControlFrameLayout(
      props: _liveProps,
      child: bar,
      clipToRadius: radius > 0,
      defaultRadius: radius > 0 ? radius : null,
    );
  }
}
