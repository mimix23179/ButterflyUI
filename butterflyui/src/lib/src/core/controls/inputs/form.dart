import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildFormControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
) {
  final title = props['title']?.toString();
  final description = props['description']?.toString();
  final spacing = coerceDouble(props['spacing']) ?? 12;
  final padding =
      coercePadding(props['padding'] ?? props['content_padding']) ??
      const EdgeInsets.all(8);

  final children = <Widget>[];
  for (final raw in rawChildren) {
    if (raw is Map) {
      children.add(buildChild(coerceObjectMap(raw)));
    }
  }

  return Padding(
    padding: padding,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null && title.isNotEmpty)
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        if (description != null && description.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            child: Text(
              description,
              style: TextStyle(color: Colors.white.withOpacity(0.75)),
            ),
          ),
        ..._withSpacing(children, spacing),
      ],
    ),
  );
}

Widget buildAutoFormControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _AutoFormControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _AutoFormControl extends StatefulWidget {
  const _AutoFormControl({
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
  State<_AutoFormControl> createState() => _AutoFormControlState();
}

class _AutoFormControlState extends State<_AutoFormControl> {
  late Map<String, Object?> _values;

  @override
  void initState() {
    super.initState();
    _values = _coerceValues(widget.props['values']);
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant _AutoFormControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
    if (oldWidget.props['values'] != widget.props['values']) {
      _values = _coerceValues(widget.props['values']);
    }
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'get_values':
        return _values;
      case 'set_values':
        setState(() => _values = _coerceValues(args['values']));
        widget.sendEvent(widget.controlId, 'change', {'values': _values});
        return _values;
      case 'validate':
        return {'valid': true, 'errors': const <Object>[]};
      case 'submit':
        widget.sendEvent(widget.controlId, 'submit', {'values': _values});
        return {'submitted': true, 'values': _values};
      case 'emit':
        final event = (args['event'] ?? 'custom').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        widget.sendEvent(widget.controlId, event, payload);
        return true;
      default:
        throw UnsupportedError('Unknown auto_form method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final submitLabel = (widget.props['submit_label'] ?? 'Submit').toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildFormControl(widget.props, widget.rawChildren, widget.buildChild),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton(
            onPressed: () {
              widget.sendEvent(widget.controlId, 'submit', {'values': _values});
            },
            child: Text(submitLabel),
          ),
        ),
      ],
    );
  }
}

Map<String, Object?> _coerceValues(Object? value) {
  if (value is Map) return coerceObjectMap(value);
  return <String, Object?>{};
}

Widget buildFormFieldControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
) {
  final label = props['label']?.toString();
  final description = props['description']?.toString();
  final requiredField = props['required'] == true;
  final helperText = props['helper_text']?.toString();
  final errorText = props['error_text']?.toString();
  final spacing = coerceDouble(props['spacing']) ?? 6;

  Widget child = const SizedBox.shrink();
  if (rawChildren.isNotEmpty && rawChildren.first is Map) {
    child = buildChild(coerceObjectMap(rawChildren.first as Map));
  } else if (props['child'] is Map) {
    child = buildChild(coerceObjectMap(props['child'] as Map));
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (label != null && label.isNotEmpty)
        Text.rich(
          TextSpan(
            text: label,
            children: requiredField
                ? const [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ]
                : const [],
          ),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      if (description != null && description.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.72),
              fontSize: 12,
            ),
          ),
        ),
      SizedBox(height: spacing),
      child,
      if (helperText != null && helperText.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            helperText,
            style: TextStyle(
              color: Colors.white.withOpacity(0.65),
              fontSize: 12,
            ),
          ),
        ),
      if (errorText != null && errorText.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            errorText,
            style: const TextStyle(color: Colors.redAccent, fontSize: 12),
          ),
        ),
    ],
  );
}

Widget buildValidationSummaryControl(Map<String, Object?> props) {
  final errors = <String>[];
  final source = props['errors'] ?? props['messages'] ?? props['items'];
  if (source is List) {
    for (final item in source) {
      final text = item?.toString() ?? '';
      if (text.isNotEmpty) errors.add(text);
    }
  } else {
    final single = source?.toString() ?? '';
    if (single.isNotEmpty) errors.add(single);
  }
  if (errors.isEmpty) return const SizedBox.shrink();

  final title = (props['title'] ?? 'Please fix the following').toString();
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color(0xff7f1d1d).withOpacity(0.25),
      border: Border.all(color: const Color(0xffef4444).withOpacity(0.55)),
      borderRadius: BorderRadius.circular(coerceDouble(props['radius']) ?? 10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xfffecaca),
          ),
        ),
        const SizedBox(height: 6),
        ...errors.map(
          (error) => Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Text(
              '- $error',
              style: const TextStyle(color: Color(0xfffee2e2)),
            ),
          ),
        ),
      ],
    ),
  );
}

List<Widget> _withSpacing(List<Widget> children, double spacing) {
  if (children.isEmpty) return const [];
  if (spacing <= 0) return children;
  final out = <Widget>[];
  for (var i = 0; i < children.length; i += 1) {
    if (i > 0) out.add(SizedBox(height: spacing));
    out.add(children[i]);
  }
  return out;
}
