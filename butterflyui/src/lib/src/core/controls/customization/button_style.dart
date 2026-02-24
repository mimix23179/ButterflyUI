import 'package:flutter/material.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';

import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class _ButtonStylePreset {
  final String id;
  final String label;

  const _ButtonStylePreset({required this.id, required this.label});
}

class _ButtonStyleControl extends StatefulWidget {
  const _ButtonStyleControl({
    required this.controlId,
    required this.props,
    required this.sendEvent,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;

  @override
  State<_ButtonStyleControl> createState() => _ButtonStyleControlState();
}

class _ButtonStyleControlState extends State<_ButtonStyleControl> {
  late List<_ButtonStylePreset> _options;
  late String _current;

  @override
  void initState() {
    super.initState();
    _options = _coerceOptions(widget.props);
    _current = _coerceCurrent(widget.props, _options);
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant _ButtonStyleControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
    if (oldWidget.props != widget.props) {
      final options = _coerceOptions(widget.props);
      setState(() {
        _options = options;
        _current = _coerceCurrent(widget.props, options);
      });
    }
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'get_value':
        return _current;
      case 'set_value':
        final value = args['value']?.toString();
        if (value == null || !_options.any((item) => item.id == value)) return null;
        setState(() {
          _current = value;
        });
        widget.sendEvent(widget.controlId, 'change', {'value': value});
        return value;
      case 'set_options':
        final next = _coerceOptions({'options': args['options'] ?? args['items']});
        setState(() {
          _options = next;
          if (!_options.any((item) => item.id == _current)) {
            _current = _options.first.id;
          }
        });
        widget.sendEvent(widget.controlId, 'options_changed', {
          'options': [for (final option in _options) {'id': option.id, 'label': option.label}],
        });
        return _current;
      case 'set_state_style':
        final state = (args['state'] ?? '').toString();
        final style = args['style'] is Map
            ? coerceObjectMap(args['style'] as Map)
            : <String, Object?>{};
        widget.sendEvent(widget.controlId, 'state_style_change', {
          'state': state,
          'style': style,
        });
        return true;
      default:
        throw UnsupportedError('Unknown button_style method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final base = widget.props['base'] is Map
        ? coerceObjectMap(widget.props['base'] as Map)
        : const <String, Object?>{};
    final hover = widget.props['hover'] is Map
        ? coerceObjectMap(widget.props['hover'] as Map)
        : const <String, Object?>{};
    final pressed = widget.props['pressed'] is Map
        ? coerceObjectMap(widget.props['pressed'] as Map)
        : const <String, Object?>{};

    final previewBg = coerceColor(base['bgcolor'] ?? base['background']) ??
        Theme.of(context).colorScheme.primary;
    final previewFg = coerceColor(base['color'] ?? base['text_color']) ??
        Theme.of(context).colorScheme.onPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in _options)
              ChoiceChip(
                label: Text(option.label),
                selected: option.id == _current,
                onSelected: (_) {
                  setState(() {
                    _current = option.id;
                  });
                  widget.sendEvent(widget.controlId, 'change', {'value': option.id});
                },
              ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: previewBg,
                foregroundColor: previewFg,
              ),
              child: const Text('Preview'),
            ),
            const SizedBox(width: 8),
            if (hover.isNotEmpty)
              Text('hover', style: Theme.of(context).textTheme.labelSmall),
            if (hover.isNotEmpty) const SizedBox(width: 6),
            if (pressed.isNotEmpty)
              Text('pressed', style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ],
    );
  }
}

List<_ButtonStylePreset> _coerceOptions(Map<String, Object?> props) {
  final optionsRaw = props['options'] ?? props['items'];
  final options = <_ButtonStylePreset>[];
  if (optionsRaw is List) {
    for (var i = 0; i < optionsRaw.length; i += 1) {
      final item = optionsRaw[i];
      if (item is Map) {
        final id = (item['id'] ?? item['value'] ?? 'style_$i').toString();
        options.add(
          _ButtonStylePreset(
            id: id,
            label: (item['label'] ?? item['name'] ?? id).toString(),
          ),
        );
      } else {
        final text = item?.toString().trim() ?? '';
        if (text.isNotEmpty) {
          options.add(_ButtonStylePreset(id: text, label: text));
        }
      }
    }
  }
  if (options.isEmpty) {
    options.addAll(const [
      _ButtonStylePreset(id: 'solid', label: 'Solid'),
      _ButtonStylePreset(id: 'outline', label: 'Outline'),
      _ButtonStylePreset(id: 'ghost', label: 'Ghost'),
    ]);
  }
  return options;
}

String _coerceCurrent(Map<String, Object?> props, List<_ButtonStylePreset> options) {
  final current = (props['value'] ?? options.first.id).toString();
  return options.any((item) => item.id == current) ? current : options.first.id;
}

Widget buildButtonStyleControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ButtonStyleControl(
    controlId: controlId,
    props: props,
    sendEvent: sendEvent,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
  );
}
