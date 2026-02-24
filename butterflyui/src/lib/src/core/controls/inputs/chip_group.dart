import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class _ChipOption {
  final String id;
  final String label;
  final bool enabled;
  final Color? color;

  const _ChipOption({
    required this.id,
    required this.label,
    required this.enabled,
    required this.color,
  });
}

Widget buildChipGroupControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return ButterflyUIChipGroup(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class ButterflyUIChipGroup extends StatefulWidget {
  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUIChipGroup({
    super.key,
    required this.controlId,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<ButterflyUIChipGroup> createState() => _ButterflyUIChipGroupState();
}

class _ButterflyUIChipGroupState extends State<ButterflyUIChipGroup> {
  final Set<String> _selected = <String>{};
  late List<_ChipOption> _options = _coerceOptions(widget.props);

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant ButterflyUIChipGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.props != widget.props) {
      _syncFromProps();
    }
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
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
    final multiSelect = _isMultiSelect(widget.props);
    final selected = _coerceSelected(widget.props, multiSelect: multiSelect);
    _options = _coerceOptions(widget.props);
    setState(() {
      _selected
        ..clear()
        ..addAll(selected);
    });
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'get_state':
      case 'get_values':
        return _selected.toList(growable: false);
      case 'set_values':
        final next = <String>{};
        final values = args['values'];
        if (values is List) {
          for (final value in values) {
            final text = value?.toString();
            if (text != null && text.isNotEmpty) {
              next.add(text);
            }
          }
        }
        setState(() {
          _selected
            ..clear()
            ..addAll(next);
        });
        return _selected.toList(growable: false);
      case 'set_options':
        setState(() {
          _options = _coerceOptions({'options': args['options'] ?? args['items']});
        });
        return {'count': _options.length};
      default:
        throw UnsupportedError('Unknown chip_group method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = _options;
    final dense = widget.props['dense'] == true;
    final spacing =
        coerceDouble(widget.props['spacing']) ?? (dense ? 4.0 : 8.0);
    final runSpacing =
        coerceDouble(widget.props['run_spacing']) ?? (dense ? 4.0 : 8.0);
    final multiSelect = _isMultiSelect(widget.props);

    if (options.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: options
          .map((option) {
            final selected = _selected.contains(option.id);
            final chipColor = option.color;
            return FilterChip(
              label: Text(option.label),
              selected: selected,
              onSelected: option.enabled
                  ? (value) {
                      setState(() {
                        if (multiSelect) {
                          if (value) {
                            _selected.add(option.id);
                          } else {
                            _selected.remove(option.id);
                          }
                        } else {
                          _selected
                            ..clear()
                            ..add(option.id);
                        }
                      });
                      _emitChange(option.id, option.label, multiSelect);
                    }
                  : null,
              selectedColor: chipColor?.withValues(alpha: 0.25),
              checkmarkColor: chipColor,
              backgroundColor: chipColor?.withValues(alpha: 0.12),
            );
          })
          .toList(growable: false),
    );
  }

  void _emitChange(String id, String label, bool multiSelect) {
    if (widget.controlId.isEmpty) return;
    final values = _selected.toList(growable: false);
    widget.sendEvent(widget.controlId, 'change', {
      'id': id,
      'label': label,
      'value': multiSelect ? values : id,
      'values': values,
      'selected': values,
      'multi_select': multiSelect,
    });
    widget.sendEvent(widget.controlId, 'select', {
      'id': id,
      'label': label,
      'values': values,
    });
  }
}

bool _isMultiSelect(Map<String, Object?> props) {
  if (props['multi_select'] is bool) {
    return props['multi_select'] == true;
  }
  if (props['multiple'] is bool) {
    return props['multiple'] == true;
  }
  final controlType = props['control_type']?.toString().toLowerCase();
  return controlType == 'tag_filter_bar' || controlType == 'filter_chips_bar';
}

Set<String> _coerceSelected(
  Map<String, Object?> props, {
  required bool multiSelect,
}) {
  final out = <String>{};
  final values = props['values'] ?? props['selected'];
  if (values is List) {
    for (final value in values) {
      final text = value?.toString();
      if (text != null && text.isNotEmpty) out.add(text);
    }
  }
  if (!multiSelect && out.isNotEmpty) {
    return <String>{out.first};
  }
  final value = props['value'];
  final single = value?.toString();
  if (single != null && single.isNotEmpty && out.isEmpty) {
    out.add(single);
  }
  return out;
}

List<_ChipOption> _coerceOptions(Map<String, Object?> props) {
  final raw = props['options'] ?? props['items'] ?? props['filters'];
  if (raw is! List) return const [];

  final out = <_ChipOption>[];
  for (var i = 0; i < raw.length; i += 1) {
    final item = raw[i];
    if (item == null) continue;
    if (item is Map) {
      final map = coerceObjectMap(item);
      final id =
          (map['id'] ?? map['value'] ?? map['key'] ?? map['label'] ?? 'chip_$i')
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
      continue;
    }
    final text = item.toString();
    if (text.isEmpty) continue;
    out.add(_ChipOption(id: text, label: text, enabled: true, color: null));
  }
  return out;
}
