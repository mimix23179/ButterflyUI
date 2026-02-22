import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildSkinsFamilyControl(
  String controlType,
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  if (controlType != 'skins') {
    return const SizedBox.shrink();
  }
  return _ButterflyUISkins(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

Set<String> _configuredEvents(Map<String, Object?> props) {
  final raw = props['events'];
  final out = <String>{};
  if (raw is List) {
    for (final entry in raw) {
      final value = entry?.toString();
      if (value != null && value.isNotEmpty) {
        out.add(value);
      }
    }
  }
  return out;
}

void _emitEvent(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
  String event,
  Map<String, Object?> payload,
) {
  final events = _configuredEvents(props);
  if (events.isNotEmpty && !events.contains(event)) {
    return;
  }
  sendEvent(controlId, event, payload);
}

class _SkinsInvokeHost extends StatefulWidget {
  const _SkinsInvokeHost({
    required this.controlType,
    required this.controlId,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
    required this.child,
  });

  final String controlType;
  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;
  final Widget child;

  @override
  State<_SkinsInvokeHost> createState() => _SkinsInvokeHostState();
}

class _SkinsInvokeHostState extends State<_SkinsInvokeHost> {
  late Map<String, Object?> _runtimeProps = Map<String, Object?>.from(widget.props);

  @override
  void initState() {
    super.initState();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _SkinsInvokeHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runtimeProps = Map<String, Object?>.from(widget.props);
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

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'get_state':
        return <String, Object?>{
          'control_type': widget.controlType,
          'props': _runtimeProps,
        };
      case 'set_props':
        final incoming = args['props'];
        if (incoming is Map) {
          setState(() {
            _runtimeProps.addAll(coerceObjectMap(incoming));
          });
        }
        return _runtimeProps;
      case 'emit':
      case 'trigger':
        final event = (args['event'] ?? args['name'] ?? method).toString();
        final payload = args['payload'];
        _emitEvent(
          widget.controlId,
          _runtimeProps,
          widget.sendEvent,
          event,
          payload is Map ? coerceObjectMap(payload) : args,
        );
        return true;
      default:
        _emitEvent(widget.controlId, _runtimeProps, widget.sendEvent, method, args);
        return true;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _ButterflyUISkins extends StatefulWidget {
  const _ButterflyUISkins({
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
  State<_ButterflyUISkins> createState() => _ButterflyUISkinsState();
}

class _ButterflyUISkinsState extends State<_ButterflyUISkins> {
  late Map<String, Object?> _runtimeProps;
  late List<String> _skins;
  String? _selectedSkin;

  @override
  void initState() {
    super.initState();
    _runtimeProps = Map<String, Object?>.from(widget.props);
    _skins = _coerceSkins(_runtimeProps['skins'] ?? _runtimeProps['presets']);
    _selectedSkin = _resolveSelected(_runtimeProps, _skins);
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _ButterflyUISkins oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runtimeProps = Map<String, Object?>.from(widget.props);
    _skins = _coerceSkins(_runtimeProps['skins'] ?? _runtimeProps['presets']);
    _selectedSkin = _resolveSelected(_runtimeProps, _skins);
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

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'get_state':
        return {
          'skins': _skins,
          'selected_skin': _selectedSkin,
          'props': _runtimeProps,
        };
      case 'set_props':
        final incoming = args['props'];
        if (incoming is Map) {
          setState(() {
            _runtimeProps.addAll(coerceObjectMap(incoming));
            _skins = _coerceSkins(_runtimeProps['skins'] ?? _runtimeProps['presets']);
            _selectedSkin = _resolveSelected(_runtimeProps, _skins);
          });
        }
        return _runtimeProps;
      case 'emit':
      case 'trigger':
        final event = (args['event'] ?? args['name'] ?? method).toString();
        final payload = args['payload'];
        _emitEvent(
          widget.controlId,
          _runtimeProps,
          widget.sendEvent,
          event,
          payload is Map ? coerceObjectMap(payload) : args,
        );
        return true;
      case 'skins_apply':
      case 'apply':
        final skin = (args['skin'] ?? args['value'] ?? _selectedSkin)?.toString();
        if (skin != null && skin.isNotEmpty) {
          setState(() {
            _selectedSkin = skin;
            if (!_skins.contains(skin)) {
              _skins = <String>[..._skins, skin];
            }
          });
        }
        _emitEvent(widget.controlId, _runtimeProps, widget.sendEvent, 'skins_apply', {'skin': _selectedSkin});
        return _selectedSkin;
      case 'skins_clear':
      case 'clear':
        setState(() {
          _selectedSkin = null;
        });
        _emitEvent(widget.controlId, _runtimeProps, widget.sendEvent, 'skins_clear', {});
        return true;
      case 'create_skin':
        {
          final name = (args['name'] ?? args['skin'] ?? '').toString();
          if (name.isNotEmpty) {
            setState(() {
              if (!_skins.contains(name)) {
                _skins = <String>[..._skins, name];
              }
              _selectedSkin = name;
            });
          }
          _emitEvent(widget.controlId, _runtimeProps, widget.sendEvent, 'create_skin', {'name': name, 'payload': args['payload']});
          return name;
        }
      case 'edit_skin':
        {
          final name = (args['name'] ?? args['skin'] ?? _selectedSkin ?? '').toString();
          _emitEvent(widget.controlId, _runtimeProps, widget.sendEvent, 'edit_skin', {'name': name, 'payload': args['payload']});
          return name;
        }
      case 'delete_skin':
        {
          final name = (args['name'] ?? args['skin'] ?? _selectedSkin ?? '').toString();
          setState(() {
            _skins = _skins.where((entry) => entry != name).toList(growable: false);
            if (_selectedSkin == name) {
              _selectedSkin = _skins.isEmpty ? null : _skins.first;
            }
          });
          _emitEvent(widget.controlId, _runtimeProps, widget.sendEvent, 'delete_skin', {'name': name});
          return true;
        }
      default:
        throw UnsupportedError('Unknown skins method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final sections = <Widget>[];
    final selector = _sectionProps(_runtimeProps, 'skins_selector');
    if (selector != null) {
      sections.add(_SkinsSelector(controlId: widget.controlId, props: selector, sendEvent: widget.sendEvent));
    }
    final preset = _sectionProps(_runtimeProps, 'skins_preset');
    if (preset != null) {
      sections.add(_SkinsPreset(controlId: widget.controlId, props: preset, sendEvent: widget.sendEvent));
    }
    final editor = _sectionProps(_runtimeProps, 'skins_editor');
    if (editor != null) {
      sections.add(_SkinsEditor(controlId: widget.controlId, props: editor, sendEvent: widget.sendEvent));
    }
    final preview = _sectionProps(_runtimeProps, 'skins_preview');
    if (preview != null) {
      sections.add(_SkinsPreview(props: preview, rawChildren: widget.rawChildren, buildChild: widget.buildChild));
    }
    final tokenMapper = _sectionProps(_runtimeProps, 'skins_token_mapper');
    if (tokenMapper != null) {
      sections.add(_SkinsTokenMapper(props: tokenMapper));
    }

    final actionWidgets = <Widget>[];
    for (final key in const <String>['skins_apply', 'skins_clear', 'create_skin', 'edit_skin', 'delete_skin']) {
      final section = _sectionProps(_runtimeProps, key);
      if (section != null) {
        actionWidgets.add(_SkinsActionButton(controlType: key, controlId: widget.controlId, props: section, sendEvent: widget.sendEvent));
      }
    }
    if (actionWidgets.isNotEmpty) {
      sections.add(Wrap(spacing: 8, runSpacing: 8, children: actionWidgets));
    }

    if (sections.isEmpty) {
      if (_skins.isEmpty) {
        return const SizedBox.shrink();
      }
      final selected = _selectedSkin ?? _skins.first;
      return Row(
        children: [
          Expanded(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _skins.contains(selected) ? selected : _skins.first,
              items: _skins
                  .map((skin) => DropdownMenuItem<String>(value: skin, child: Text(skin)))
                  .toList(growable: false),
              onChanged: (next) {
                if (next == null) return;
                setState(() {
                  _selectedSkin = next;
                });
                _emitEvent(widget.controlId, _runtimeProps, widget.sendEvent, 'select', {'skin': next});
              },
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: () {
              _emitEvent(widget.controlId, _runtimeProps, widget.sendEvent, 'skins_apply', {'skin': _selectedSkin});
            },
            child: const Text('Apply'),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < sections.length; i++) ...[
          if (i > 0) const SizedBox(height: 8),
          sections[i],
        ],
      ],
    );
  }
}

Map<String, Object?>? _sectionProps(Map<String, Object?> props, String key) {
  final section = props[key];
  if (section is Map) {
    return <String, Object?>{...coerceObjectMap(section), 'events': props['events']};
  }
  if (section == true) {
    return <String, Object?>{'events': props['events']};
  }
  return null;
}

List<String> _coerceSkins(Object? value) {
  final out = <String>[];
  if (value is List) {
    for (final item in value) {
      final name = item is Map
          ? (item['name'] ?? item['id'] ?? '').toString()
          : (item?.toString() ?? '');
      if (name.isNotEmpty && !out.contains(name)) {
        out.add(name);
      }
    }
  }
  return out;
}

String? _resolveSelected(Map<String, Object?> props, List<String> skins) {
  final selected = (props['selected_skin'] ?? props['skin'] ?? props['value'])?.toString();
  if (selected != null && selected.isNotEmpty) {
    return selected;
  }
  if (skins.isNotEmpty) {
    return skins.first;
  }
  return null;
}

class _SkinsSelector extends StatelessWidget {
  const _SkinsSelector({required this.controlId, required this.props, required this.sendEvent});

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  Widget build(BuildContext context) {
    final options = _coerceSkins(props['skins'] ?? props['options'] ?? props['items']);
    if (options.isEmpty) {
      return const SizedBox.shrink();
    }
    final selected = _resolveSelected(props, options) ?? options.first;
    return DropdownButton<String>(
      value: options.contains(selected) ? selected : options.first,
      items: options
          .map((skin) => DropdownMenuItem<String>(value: skin, child: Text(skin)))
          .toList(growable: false),
      onChanged: (next) {
        if (next == null) return;
        _emitEvent(controlId, props, sendEvent, 'select', {'skin': next});
      },
    );
  }
}

class _SkinsPreset extends StatelessWidget {
  const _SkinsPreset({required this.controlId, required this.props, required this.sendEvent});

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  Widget build(BuildContext context) {
    final label = (props['label'] ?? props['name'] ?? 'Preset').toString();
    return OutlinedButton(
      onPressed: () => _emitEvent(controlId, props, sendEvent, 'select', {'skin': label}),
      child: Text(label),
    );
  }
}

class _SkinsEditor extends StatefulWidget {
  const _SkinsEditor({required this.controlId, required this.props, required this.sendEvent});

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_SkinsEditor> createState() => _SkinsEditorState();
}

class _SkinsEditorState extends State<_SkinsEditor> {
  late final TextEditingController _controller = TextEditingController(
    text: (widget.props['value'] ?? widget.props['text'] ?? '').toString(),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _controller,
          minLines: 4,
          maxLines: 12,
          decoration: const InputDecoration(
            hintText: 'Edit skin JSON/tokens…',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        FilledButton.tonal(
          onPressed: () {
            _emitEvent(widget.controlId, widget.props, widget.sendEvent, 'edit_skin', {
              'name': widget.props['name']?.toString(),
              'value': _controller.text,
            });
          },
          child: const Text('Save Skin'),
        ),
      ],
    );
  }
}

class _SkinsPreview extends StatelessWidget {
  const _SkinsPreview({required this.props, required this.rawChildren, required this.buildChild});

  final Map<String, Object?> props;
  final List<dynamic> rawChildren;
  final Widget Function(Map<String, Object?> child) buildChild;

  @override
  Widget build(BuildContext context) {
    Map<String, Object?>? firstChild;
    for (final raw in rawChildren) {
      if (raw is Map) {
        firstChild = coerceObjectMap(raw);
        break;
      }
    }
    final preview = firstChild == null
        ? Center(child: Text((props['label'] ?? 'Skin Preview').toString()))
        : buildChild(firstChild);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: preview,
    );
  }
}

class _SkinsTokenMapper extends StatelessWidget {
  const _SkinsTokenMapper({required this.props});

  final Map<String, Object?> props;

  @override
  Widget build(BuildContext context) {
    final mapping = props['mapping'];
    if (mapping is! Map) {
      return const SizedBox.shrink();
    }
    final entries = coerceObjectMap(mapping).entries.toList(growable: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final entry in entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('${entry.key}: ${entry.value}'),
          ),
      ],
    );
  }
}

class _SkinsActionButton extends StatelessWidget {
  const _SkinsActionButton({
    required this.controlType,
    required this.controlId,
    required this.props,
    required this.sendEvent,
  });

  final String controlType;
  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  Widget build(BuildContext context) {
    final label = (props['label'] ?? controlType.replaceAll('_', ' ')).toString();
    return FilledButton.tonal(
      onPressed: () {
        _emitEvent(controlId, props, sendEvent, controlType, {
          'name': props['name'],
          'skin': props['skin'] ?? props['value'],
          'payload': props['payload'],
        });
      },
      child: Text(label),
    );
  }
}
