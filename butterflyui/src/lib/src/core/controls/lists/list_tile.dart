import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/controls/common/icon_value.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildListTileControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ListTileControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _ListTileControl extends StatefulWidget {
  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const _ListTileControl({
    required this.controlId,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<_ListTileControl> createState() => _ListTileControlState();
}

class _ListTileControlState extends State<_ListTileControl> {
  late bool _selected = widget.props['selected'] == true;
  late bool _enabled =
      widget.props['enabled'] == null ? true : (widget.props['enabled'] == true);

  @override
  void initState() {
    super.initState();
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant _ListTileControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
    if (oldWidget.props != widget.props) {
      _selected = widget.props['selected'] == true;
      _enabled = widget.props['enabled'] == null
          ? true
          : (widget.props['enabled'] == true);
    }
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_selected':
        setState(() {
          _selected = args['value'] == true;
        });
        return null;
      case 'set_enabled':
        setState(() {
          _enabled = args['value'] == true;
        });
        return null;
      case 'get_state':
        return {'selected': _selected, 'enabled': _enabled};
      default:
        throw UnsupportedError('Unknown list_tile method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final title =
        (widget.props['title'] ?? widget.props['label'] ?? widget.props['text'] ??
                'Item')
            .toString();
    final subtitle = widget.props['subtitle']?.toString();
    final meta = (widget.props['meta'] ?? widget.props['trailing_text'])
        ?.toString();

    final leading = buildIconValue(
      widget.props['leading_icon'] ??
          widget.props['icon'] ??
          widget.props['leading_text'],
      size: 18,
    );
    final trailing = buildIconValue(
      widget.props['trailing_icon'],
      size: 18,
      textStyle: ThemeData.fallback().textTheme.labelMedium,
    );

    return ListTile(
      dense: widget.props['dense'] == true,
      enabled: _enabled,
      selected: _selected,
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle),
      leading: leading,
      trailing: trailing ?? (meta == null ? null : Text(meta)),
      onTap: _enabled
          ? () {
              if (widget.controlId.isEmpty) return;
              widget.sendEvent(widget.controlId, 'select', {
                'id': widget.props['id']?.toString() ?? title,
                'title': title,
                if (widget.props['value'] != null) 'value': widget.props['value'],
                if (widget.props['meta'] != null) 'meta': widget.props['meta'],
              });
            }
          : null,
    );
  }
}
