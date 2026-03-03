import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class _ChipOption {
  const _ChipOption({
    required this.id,
    required this.label,
    required this.enabled,
    required this.color,
  });

  final String id;
  final String label;
  final bool enabled;
  final Color? color;
}

Widget buildChipControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ChipControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _ChipControl extends StatefulWidget {
  const _ChipControl({
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
  State<_ChipControl> createState() => _ChipControlState();
}

class _ChipControlState extends State<_ChipControl> {
  bool _selected = false;
  List<_ChipOption> _options = const <_ChipOption>[];
  final Set<String> _selectedValues = <String>{};

  bool get _isGroup => _options.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _ChipControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    if (!mapEquals(oldWidget.props, widget.props)) {
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

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_selected':
        setState(() => _selected = args['value'] == true);
        _emit('change', _singleStatePayload());
        return _singleStatePayload();
      case 'set_values':
        setState(() {
          _selectedValues
            ..clear()
            ..addAll(_coerceValueSet(args['values']));
        });
        _emit('change', _groupStatePayload());
        return _groupStatePayload();
      case 'get_values':
        return _groupStatePayload();
      case 'get_state':
        return _isGroup ? _groupStatePayload() : _singleStatePayload();
      case 'emit':
        final event = (args['event'] ?? 'change').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        _emit(event, payload);
        return null;
      default:
        throw UnsupportedError('Unknown chip method: $method');
    }
  }

  void _syncFromProps() {
    _selected = widget.props['selected'] == true;
    _options = _coerceOptions(widget.props['options'] ?? widget.props['items']);
    _selectedValues
      ..clear()
      ..addAll(_coerceSelected(widget.props));
  }

  Map<String, Object?> _singleStatePayload() {
    return <String, Object?>{
      'selected': _selected,
      'value': widget.props['value'],
      'label': widget.props['label']?.toString() ?? '',
    };
  }

  Map<String, Object?> _groupStatePayload() {
    final values = _selectedValues.toList(growable: false);
    return <String, Object?>{
      'values': values,
      'selected': values,
      'value': values.isEmpty ? null : values.first,
    };
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  bool _isMultiSelect() {
    if (widget.props['multi_select'] is bool) {
      return widget.props['multi_select'] == true;
    }
    if (widget.props['multiple'] is bool) {
      return widget.props['multiple'] == true;
    }
    return true;
  }

  Set<String> _coerceSelected(Map<String, Object?> props) {
    final out = <String>{};
    final values = props['values'] ?? props['selected'];
    if (values is List) {
      for (final value in values) {
        final text = value?.toString();
        if (text != null && text.isNotEmpty) out.add(text);
      }
    }
    final value = props['value']?.toString();
    if (value != null && value.isNotEmpty && out.isEmpty) {
      out.add(value);
    }
    if (!_isMultiSelect() && out.isNotEmpty) {
      return <String>{out.first};
    }
    return out;
  }

  Set<String> _coerceValueSet(Object? raw) {
    final out = <String>{};
    if (raw is List) {
      for (final item in raw) {
        final text = item?.toString();
        if (text != null && text.isNotEmpty) out.add(text);
      }
    }
    return out;
  }

  List<_ChipOption> _coerceOptions(Object? raw) {
    if (raw is! List) return const <_ChipOption>[];
    final out = <_ChipOption>[];
    for (var i = 0; i < raw.length; i += 1) {
      final item = raw[i];
      if (item is Map) {
        final map = coerceObjectMap(item);
        final id =
            (map['id'] ??
                    map['value'] ??
                    map['key'] ??
                    map['label'] ??
                    'chip_$i')
                .toString();
        final label = (map['label'] ?? map['title'] ?? map['text'] ?? id)
            .toString();
        out.add(
          _ChipOption(
            id: id,
            label: label,
            enabled: map['enabled'] == null ? true : (map['enabled'] == true),
            color: coerceColor(map['color'] ?? map['bgcolor']),
          ),
        );
      } else if (item != null) {
        final text = item.toString();
        if (text.isNotEmpty) {
          out.add(
            _ChipOption(id: text, label: text, enabled: true, color: null),
          );
        }
      }
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final enabled =
        widget.props['enabled'] == null || widget.props['enabled'] == true;
    final dense = widget.props['dense'] == true;
    final spacing =
        coerceDouble(widget.props['spacing']) ?? (dense ? 4.0 : 8.0);
    final runSpacing =
        coerceDouble(widget.props['run_spacing']) ?? (dense ? 4.0 : 8.0);

    if (_isGroup) {
      final multiSelect = _isMultiSelect();
      return Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        children: _options
            .map((option) {
              final selected = _selectedValues.contains(option.id);
              return FilterChip(
                label: Text(option.label),
                selected: selected,
                selectedColor: option.color?.withValues(alpha: 0.25),
                checkmarkColor: option.color,
                backgroundColor: option.color?.withValues(alpha: 0.12),
                onSelected: option.enabled && enabled
                    ? (next) {
                        setState(() {
                          if (multiSelect) {
                            if (next) {
                              _selectedValues.add(option.id);
                            } else {
                              _selectedValues.remove(option.id);
                            }
                          } else {
                            _selectedValues
                              ..clear()
                              ..add(option.id);
                          }
                        });
                        final state = _groupStatePayload();
                        _emit('change', {
                          ...state,
                          'id': option.id,
                          'label': option.label,
                        });
                        _emit('select', {
                          ...state,
                          'id': option.id,
                          'label': option.label,
                        });
                      }
                    : null,
              );
            })
            .toList(growable: false),
      );
    }

    final dismissible = widget.props['dismissible'] == true;
    final label =
        (widget.props['label'] ??
                widget.props['text'] ??
                widget.props['value'] ??
                'chip')
            .toString();
    return FilterChip(
      label: Text(label),
      selected: _selected,
      onSelected: enabled
          ? (next) {
              setState(() => _selected = next);
              final state = _singleStatePayload();
              _emit('change', state);
              _emit('select', state);
            }
          : null,
      onDeleted: dismissible
          ? () {
              _emit('dismiss', _singleStatePayload());
            }
          : null,
    );
  }
}
