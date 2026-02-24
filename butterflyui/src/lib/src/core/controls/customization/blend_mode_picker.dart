import 'package:flutter/material.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';

import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class _BlendModePickerControl extends StatefulWidget {
  const _BlendModePickerControl({
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
  State<_BlendModePickerControl> createState() => _BlendModePickerControlState();
}

class _BlendModePickerControlState extends State<_BlendModePickerControl> {
  late List<String> _options;
  late String _value;

  @override
  void initState() {
    super.initState();
    _options = _coerceOptions(widget.props);
    _value = _coerceValue(widget.props, _options);
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant _BlendModePickerControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
    if (oldWidget.props != widget.props) {
      final options = _coerceOptions(widget.props);
      setState(() {
        _options = options;
        _value = _coerceValue(widget.props, options);
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
        return _value;
      case 'set_value':
        final next = args['value']?.toString();
        if (next == null || !_options.contains(next)) return null;
        setState(() {
          _value = next;
        });
        widget.sendEvent(widget.controlId, 'change', {'value': _value});
        return _value;
      case 'set_options':
        final raw = args['options'];
        final next = _coerceOptions({'options': raw});
        setState(() {
          _options = next;
          if (!_options.contains(_value)) {
            _value = _options.first;
          }
        });
        widget.sendEvent(widget.controlId, 'options_changed', {'options': _options});
        return _options;
      default:
        throw UnsupportedError('Unknown blend_mode_picker method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.props['enabled'] != false;
    final showPreview = widget.props['preview'] != false;
    final preview = _BlendModePreview(mode: _coerceBlendMode(_value), sample: widget.props['sample']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          initialValue: _options.contains(_value) ? _value : _options.first,
          decoration: InputDecoration(
            labelText: widget.props['label']?.toString() ?? 'Blend Mode',
            border: const OutlineInputBorder(),
            isDense: widget.props['dense'] == true,
          ),
          items: [
            for (final option in _options)
              DropdownMenuItem<String>(value: option, child: Text(option)),
          ],
          onChanged: !enabled
              ? null
              : (selected) {
                  if (selected == null) return;
                  setState(() {
                    _value = selected;
                  });
                  widget.sendEvent(widget.controlId, 'change', {'value': selected});
                },
        ),
        if (showPreview) ...[
          const SizedBox(height: 8),
          preview,
        ],
      ],
    );
  }
}

List<String> _coerceOptions(Map<String, Object?> props) {
  final optionsRaw = props['options'] ?? props['items'];
  final options = <String>[];
  if (optionsRaw is List) {
    for (final item in optionsRaw) {
      final mode = item?.toString().trim() ?? '';
      if (mode.isNotEmpty) {
        options.add(mode);
      }
    }
  }
  if (options.isEmpty) {
    options.addAll(const ['srcOver', 'multiply', 'screen', 'overlay', 'plus']);
  }
  return options;
}

String _coerceValue(Map<String, Object?> props, List<String> options) {
  final value = (props['value'] ?? options.first).toString();
  return options.contains(value) ? value : options.first;
}

BlendMode _coerceBlendMode(String value) {
  switch (value.toLowerCase()) {
    case 'multiply':
      return BlendMode.multiply;
    case 'screen':
      return BlendMode.screen;
    case 'overlay':
      return BlendMode.overlay;
    case 'softlight':
    case 'soft_light':
      return BlendMode.softLight;
    case 'plus':
      return BlendMode.plus;
    default:
      return BlendMode.srcOver;
  }
}

class _BlendModePreview extends StatelessWidget {
  const _BlendModePreview({required this.mode, required this.sample});

  final BlendMode mode;
  final Object? sample;

  @override
  Widget build(BuildContext context) {
    final sampleMap = sample is Map ? coerceObjectMap(sample as Map) : const <String, Object?>{};
    final base = coerceColor(sampleMap['base']) ?? Theme.of(context).colorScheme.primary;
    final overlay = coerceColor(sampleMap['overlay']) ?? Theme.of(context).colorScheme.tertiary;

    return SizedBox(
      height: 42,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: base),
            ColorFiltered(
              colorFilter: ColorFilter.mode(overlay, mode),
              child: Container(color: overlay),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildBlendModePickerControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _BlendModePickerControl(
    controlId: controlId,
    props: props,
    sendEvent: sendEvent,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
  );
}
