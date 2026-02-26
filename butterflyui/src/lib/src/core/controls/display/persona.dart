import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildPersonaControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _PersonaControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _PersonaControl extends StatefulWidget {
  const _PersonaControl({
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
  State<_PersonaControl> createState() => _PersonaControlState();
}

class _PersonaControlState extends State<_PersonaControl> {
  late String _name;
  late String _subtitle;
  late String _status;

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _PersonaControl oldWidget) {
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

  void _syncFromProps() {
    _name = (widget.props['name'] ?? '').toString();
    _subtitle = widget.props['subtitle']?.toString() ?? '';
    _status = widget.props['status']?.toString() ?? '';
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_props':
        setState(() {
          if (args.containsKey('name')) {
            _name = args['name']?.toString() ?? '';
          }
          if (args.containsKey('subtitle')) {
            _subtitle = args['subtitle']?.toString() ?? '';
          }
          if (args.containsKey('status')) {
            _status = args['status']?.toString() ?? '';
          }
        });
        return _statePayload();
      case 'get_state':
        return _statePayload();
      case 'emit':
        final event = (args['event'] ?? 'click').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        _emit(event, payload);
        return null;
      default:
        throw UnsupportedError('Unknown persona method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      'name': _name,
      'subtitle': _subtitle,
      'status': _status,
      'initials': (widget.props['initials'] ?? _initialsFromName(_name)).toString(),
    };
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  Widget? _slotWidget(String key) {
    final raw = widget.props[key];
    if (raw is Map) {
      return widget.buildChild(coerceObjectMap(raw));
    }
    return null;
  }

  Widget? _firstRawChild() {
    for (final raw in widget.rawChildren) {
      if (raw is Map) {
        return widget.buildChild(coerceObjectMap(raw));
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final name = _name;
    final subtitle = _subtitle;
    final status = _status;
    final initials = (widget.props['initials'] ?? _initialsFromName(name)).toString();
    final dense = widget.props['dense'] == true;
    final avatarColor =
        coerceColor(widget.props['avatar_color']) ?? const Color(0xff334155);
    final layout = (widget.props['layout'] ?? 'tile').toString().toLowerCase();
    final showAvatar =
        widget.props['show_avatar'] == null || widget.props['show_avatar'] == true;

    final leading = _slotWidget('leading') ?? _slotWidget('avatar');
    final titleWidget = _slotWidget('title_widget');
    final subtitleWidget = _slotWidget('subtitle_widget');
    final trailing = _slotWidget('trailing');
    final content = _slotWidget('content') ?? _firstRawChild();

    final defaultAvatar = CircleAvatar(
      backgroundColor: avatarColor,
      child: Text(
        initials.isEmpty ? '?' : initials,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );

    final defaultTitle = Text(name.isEmpty ? 'Persona' : name);
    final defaultSubtitle = subtitle.isEmpty
        ? (status.isEmpty ? null : Text(status))
        : Text(status.isEmpty ? subtitle : '$subtitle • $status');

    Widget built;
    if (layout == 'custom' && content != null) {
      built = content;
    } else if (layout == 'row') {
      built = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showAvatar) (leading ?? defaultAvatar),
          if (showAvatar) SizedBox(width: dense ? 8 : 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                titleWidget ?? defaultTitle,
                if (subtitleWidget != null)
                  subtitleWidget
                else if (defaultSubtitle != null)
                  defaultSubtitle,
              ],
            ),
          ),
          if (trailing != null) ...[SizedBox(width: dense ? 6 : 8), trailing],
        ],
      );
    } else {
      built = ListTile(
        dense: dense,
        contentPadding: dense ? const EdgeInsets.symmetric(horizontal: 8) : null,
        leading: showAvatar ? (leading ?? defaultAvatar) : leading,
        title: titleWidget ?? defaultTitle,
        subtitle: subtitleWidget ?? defaultSubtitle,
        trailing: trailing,
      );
    }

    if (widget.controlId.isEmpty) return built;
    return InkWell(
      onTap: () {
        _emit('click', {
          'name': name,
          'subtitle': subtitle,
          'status': status,
        });
      },
      child: built,
    );
  }
}

String _initialsFromName(String name) {
  final parts = name
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList(growable: false);
  if (parts.isEmpty) return '';
  if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
  return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'.toUpperCase();
}
