import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildAccordionControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return ButterflyUIAccordion(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class ButterflyUIAccordion extends StatefulWidget {
  final String controlId;
  final Map<String, Object?> props;
  final List<dynamic> rawChildren;
  final Widget Function(Map<String, Object?> child) buildChild;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUIAccordion({
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
  State<ButterflyUIAccordion> createState() => _ButterflyUIAccordionState();
}

class _ButterflyUIAccordionState extends State<ButterflyUIAccordion> {
  List<Map<String, Object?>> _sections = const <Map<String, Object?>>[];
  Set<int> _expanded = <int>{0};

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant ButterflyUIAccordion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    if (oldWidget.props != widget.props || oldWidget.rawChildren != widget.rawChildren) {
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
      case 'set_expanded':
        final resolved = _coerceExpanded(args['expanded'] ?? args['index']);
        setState(() => _expanded = resolved);
        _emit('change', _statePayload());
        return _statePayload();
      case 'get_state':
        return _statePayload();
      case 'emit':
        final event = (args['event'] ?? 'change').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        _emit(event, payload);
        return null;
      default:
        throw UnsupportedError('Unknown accordion method: $method');
    }
  }

  void _syncFromProps() {
    final sections = _coerceSections(widget.props['sections']);
    final labels = _coerceLabels(widget.props['labels']);
    final nextSections = sections.isNotEmpty
        ? sections
        : _sectionsFromChildrenAndLabels(widget.rawChildren, labels);
    final expanded = _coerceExpanded(widget.props['expanded'] ?? widget.props['index']);

    setState(() {
      _sections = nextSections;
      _expanded = expanded.isEmpty && nextSections.isNotEmpty ? <int>{0} : expanded;
    });
  }

  List<String> _coerceLabels(Object? raw) {
    if (raw is! List) return const <String>[];
    return raw.map((item) => item?.toString() ?? '').where((s) => s.isNotEmpty).toList();
  }

  List<Map<String, Object?>> _coerceSections(Object? raw) {
    if (raw is! List) return const <Map<String, Object?>>[];
    final out = <Map<String, Object?>>[];
    for (final value in raw) {
      if (value is Map) out.add(coerceObjectMap(value));
    }
    return out;
  }

  List<Map<String, Object?>> _sectionsFromChildrenAndLabels(List<dynamic> rawChildren, List<String> labels) {
    final out = <Map<String, Object?>>[];
    var index = 0;
    for (final child in rawChildren) {
      if (child is! Map) continue;
      out.add(<String, Object?>{
        'id': index.toString(),
        'label': (index < labels.length ? labels[index] : 'Section ${index + 1}'),
        'content': coerceObjectMap(child),
      });
      index += 1;
    }
    return out;
  }

  Set<int> _coerceExpanded(Object? raw) {
    final out = <int>{};
    if (raw is int) {
      out.add(raw);
      return out;
    }
    if (raw is List) {
      for (final value in raw) {
        final parsed = coerceOptionalInt(value);
        if (parsed != null) out.add(parsed);
      }
      return out;
    }
    final parsed = coerceOptionalInt(raw);
    if (parsed != null) {
      out.add(parsed);
    }
    return out;
  }

  Map<String, Object?> _statePayload() {
    final list = _expanded.toList()..sort();
    return <String, Object?>{
      'expanded': list,
      'index': list,
    };
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  @override
  Widget build(BuildContext context) {
    final dense = widget.props['dense'] == true;
    final multiple = widget.props['multiple'] == true;
    final allowEmpty = widget.props['allow_empty'] == true;
    final spacing = coerceDouble(widget.props['spacing']) ?? 0.0;

    return ExpansionPanelList(
      expansionCallback: (panelIndex, isExpanded) {
        setState(() {
          if (multiple) {
            if (isExpanded) {
              if (allowEmpty || _expanded.length > 1) {
                _expanded.remove(panelIndex);
              }
            } else {
              _expanded.add(panelIndex);
            }
          } else {
            if (isExpanded) {
              if (allowEmpty) {
                _expanded.clear();
              }
            } else {
              _expanded = <int>{panelIndex};
            }
          }
        });
        _emit('change', {
          ..._statePayload(),
          'toggled_index': panelIndex,
          'expanded': !isExpanded,
        });
      },
      dividerColor: widget.props['show_dividers'] == false
          ? Colors.transparent
          : null,
      children: [
        for (var i = 0; i < _sections.length; i += 1)
          ExpansionPanel(
            canTapOnHeader: true,
            isExpanded: _expanded.contains(i),
            headerBuilder: (context, isExpanded) {
              final section = _sections[i];
              final label = (section['label'] ?? section['title'] ?? 'Section ${i + 1}').toString();
              return ListTile(
                dense: dense,
                title: Text(label),
              );
            },
            body: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, dense ? 8 : 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (spacing > 0) SizedBox(height: spacing),
                  _buildSectionBody(_sections[i]),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSectionBody(Map<String, Object?> section) {
    final content = section['content'] ?? section['child'];
    if (content is Map) {
      return widget.buildChild(coerceObjectMap(content));
    }

    final body = section['body'];
    if (body is List) {
      final widgets = <Widget>[];
      for (final item in body) {
        if (item is Map) {
          widgets.add(widget.buildChild(coerceObjectMap(item)));
        }
      }
      if (widgets.isNotEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widgets,
        );
      }
    }

    final text = section['text']?.toString() ?? section['value']?.toString();
    if (text != null && text.isNotEmpty) {
      return Text(text);
    }

    return const SizedBox.shrink();
  }
}
