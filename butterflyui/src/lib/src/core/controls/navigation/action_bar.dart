import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/common/icon_value.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildActionBarControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return ButterflyUIActionBar(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class ButterflyUIActionBar extends StatefulWidget {
  final String controlId;
  final Map<String, Object?> props;
  final List<dynamic> rawChildren;
  final Widget Function(Map<String, Object?> child) buildChild;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUIActionBar({
    super.key,
    required this.controlId,
    required this.props,
    required this.rawChildren,
    required this.buildChild,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<ButterflyUIActionBar> createState() => _ButterflyUIActionBarState();
}

class _ButterflyUIActionBarState extends State<ButterflyUIActionBar> {
  List<Map<String, Object?>> _items = const <Map<String, Object?>>[];

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant ButterflyUIActionBar oldWidget) {
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

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_items':
        final next = _coerceItems(args['items']);
        setState(() => _items = next);
        return _statePayload();
      case 'get_state':
        return _statePayload();
      case 'emit':
        final event = (args['event'] ?? 'action').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        _emit(event, payload);
        return null;
      default:
        throw UnsupportedError('Unknown action_bar method: $method');
    }
  }

  void _syncFromProps() {
    final next = _coerceItems(widget.props['items']);
    setState(() => _items = next);
  }

  List<Map<String, Object?>> _coerceItems(Object? raw) {
    if (raw is! List) return const <Map<String, Object?>>[];
    final out = <Map<String, Object?>>[];
    for (final value in raw) {
      if (value is Map) {
        out.add(coerceObjectMap(value));
      }
    }
    return out;
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      'items': _items,
      'count': _items.length,
    };
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  @override
  Widget build(BuildContext context) {
    final dense = widget.props['dense'] == true;
    final enabled = widget.props['enabled'] == null
        ? true
        : (widget.props['enabled'] == true);
    final wrap = widget.props['wrap'] == true;
    final spacing = coerceDouble(widget.props['spacing']) ?? (dense ? 6 : 8);
    final runSpacing = coerceDouble(widget.props['run_spacing']) ?? spacing;
    final bgColor = coerceColor(widget.props['bgcolor'] ?? widget.props['background']);
    final padding = coercePadding(widget.props['padding']) ??
        EdgeInsets.symmetric(horizontal: dense ? 8 : 10, vertical: dense ? 6 : 8);

    final actionWidgets = <Widget>[];

    for (var i = 0; i < _items.length; i += 1) {
      final item = _items[i];
      final id = (item['id'] ?? item['action'] ?? i).toString();
      final label = (item['label'] ?? item['title'] ?? id).toString();
      final itemEnabled = enabled && (item['enabled'] == null || item['enabled'] == true);
      final icon = buildIconValue(item['icon'] ?? item['leading_icon'], size: dense ? 16 : 18);

      actionWidgets.add(
        FilledButton.tonalIcon(
          onPressed: itemEnabled
              ? () {
                  _emit('action', {
                    'id': id,
                    'label': label,
                    'index': i,
                    if (item['value'] != null) 'value': item['value'],
                    if (item['payload'] is Map)
                      'payload': coerceObjectMap(item['payload'] as Map),
                  });
                }
              : null,
          icon: icon ?? const Icon(Icons.play_arrow),
          label: Text(label),
          style: FilledButton.styleFrom(
            visualDensity: dense ? VisualDensity.compact : VisualDensity.standard,
          ),
        ),
      );
    }

    for (final child in widget.rawChildren) {
      if (child is Map) {
        actionWidgets.add(widget.buildChild(coerceObjectMap(child)));
      }
    }

    final content = wrap
        ? Wrap(
            spacing: spacing,
            runSpacing: runSpacing,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: actionWidgets,
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < actionWidgets.length; i += 1) ...[
                if (i > 0) SizedBox(width: spacing),
                actionWidgets[i],
              ],
            ],
          );

    return Container(
      color: bgColor,
      padding: padding,
      child: content,
    );
  }
}
