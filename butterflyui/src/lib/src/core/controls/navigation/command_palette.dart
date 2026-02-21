import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/common/icon_value.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildCommandPaletteControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return ButterflyUICommandPalette(
    controlId: controlId,
    props: props,
    sendEvent: sendEvent,
  );
}

Widget buildCommandItemControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final label = (props['label'] ?? props['title'] ?? props['text'] ?? 'Command')
      .toString();
  final subtitle = props['subtitle']?.toString();
  final shortcut =
      (props['shortcut'] ?? props['meta'] ?? props['trailing_text'])
          ?.toString();
  final icon = buildIconValue(props['icon'], size: 18);
  final enabled = props['enabled'] == null ? true : (props['enabled'] == true);

  return ListTile(
    dense: props['dense'] == true,
    enabled: enabled,
    leading: icon,
    title: Text(label),
    subtitle: subtitle == null ? null : Text(subtitle),
    trailing: shortcut == null ? null : Text(shortcut),
    onTap: enabled
        ? () {
            if (controlId.isEmpty) return;
            sendEvent(controlId, 'command', {
              'id': props['id']?.toString() ?? label,
              'label': label,
              if (props['value'] != null) 'value': props['value'],
              'item': props,
            });
          }
        : null,
  );
}

class _CommandData {
  final String id;
  final String label;
  final String? subtitle;
  final String? shortcut;
  final Object? icon;
  final bool enabled;
  final List<String> keywords;
  final Map<String, Object?> payload;

  const _CommandData({
    required this.id,
    required this.label,
    required this.subtitle,
    required this.shortcut,
    required this.icon,
    required this.enabled,
    required this.keywords,
    required this.payload,
  });
}

class ButterflyUICommandPalette extends StatefulWidget {
  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUICommandPalette({
    super.key,
    required this.controlId,
    required this.props,
    required this.sendEvent,
  });

  @override
  State<ButterflyUICommandPalette> createState() => _ButterflyUICommandPaletteState();
}

class _ButterflyUICommandPaletteState extends State<ButterflyUICommandPalette> {
  late final TextEditingController _controller;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _query =
        widget.props['query']?.toString() ??
        widget.props['value']?.toString() ??
        '';
    _controller = TextEditingController(text: _query);
  }

  @override
  void didUpdateWidget(covariant ButterflyUICommandPalette oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next =
        widget.props['query']?.toString() ??
        widget.props['value']?.toString() ??
        '';
    if (next != _query) {
      _query = next;
      _controller.value = TextEditingValue(
        text: next,
        selection: TextSelection.collapsed(offset: next.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final open = widget.props['open'] == null
        ? true
        : (widget.props['open'] == true);
    if (!open) {
      return const SizedBox.shrink();
    }

    final commands = _parseCommands(widget.props);
    final filtered = _filter(
      commands,
      _query,
      widget.props['show_all_on_empty'] == true,
    );
    final maxResults = (coerceOptionalInt(widget.props['max_results']) ?? 12)
        .clamp(1, 200);
    final results = filtered.take(maxResults).toList(growable: false);

    final maxWidth =
        coerceDouble(widget.props['max_width'] ?? widget.props['width']) ?? 640;
    final maxHeight = coerceDouble(widget.props['max_height']) ?? 420;
    final title = widget.props['title']?.toString();
    final subtitle = widget.props['subtitle']?.toString();
    final placeholder =
        (widget.props['placeholder'] ??
                widget.props['hint'] ??
                'Type a command...')
            .toString();

    final bg =
        coerceColor(widget.props['bgcolor'] ?? widget.props['background']) ??
        Theme.of(context).colorScheme.surface;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
        child: Material(
          color: bg,
          elevation: 10,
          borderRadius: BorderRadius.circular(
            coerceDouble(widget.props['radius']) ?? 14,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (title != null || subtitle != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null)
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      if (subtitle != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            subtitle,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: TextField(
                  controller: _controller,
                  autofocus: widget.props['autofocus'] == true,
                  enabled: widget.props['enabled'] == null
                      ? true
                      : (widget.props['enabled'] == true),
                  onChanged: (value) {
                    setState(() => _query = value);
                    if (widget.controlId.isNotEmpty) {
                      widget.sendEvent(widget.controlId, 'change', {
                        'query': value,
                      });
                    }
                  },
                  onSubmitted: (_) {
                    if (results.isNotEmpty) {
                      _select(results.first);
                    }
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: placeholder,
                    suffixIcon: widget.props['close_on_escape'] == true
                        ? IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              if (widget.controlId.isEmpty) return;
                              widget.sendEvent(widget.controlId, 'close', {});
                            },
                          )
                        : null,
                  ),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: results.isEmpty
                    ? _buildEmpty(context)
                    : ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final command = results[index];
                          final icon = buildIconValue(command.icon, size: 18);
                          return ListTile(
                            dense: widget.props['dense'] == true,
                            enabled: command.enabled,
                            leading: icon,
                            title: Text(command.label),
                            subtitle: command.subtitle == null
                                ? null
                                : Text(command.subtitle!),
                            trailing: command.shortcut == null
                                ? null
                                : Text(command.shortcut!),
                            onTap: command.enabled
                                ? () => _select(command)
                                : null,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    final empty = widget.props['empty_text']?.toString() ?? 'No commands found';
    return Center(
      child: Text(empty, style: Theme.of(context).textTheme.bodySmall),
    );
  }

  void _select(_CommandData command) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, 'command', {
      'id': command.id,
      'label': command.label,
      'query': _query,
      'item': command.payload,
    });
    if (widget.props['dismiss_on_select'] != false) {
      widget.sendEvent(widget.controlId, 'close', {'id': command.id});
    }
  }
}

List<_CommandData> _parseCommands(Map<String, Object?> props) {
  final raw = props['commands'] ?? props['items'];
  if (raw is! List) return const [];
  final out = <_CommandData>[];
  for (final item in raw) {
    if (item == null) continue;
    if (item is! Map) {
      final label = item.toString();
      out.add(
        _CommandData(
          id: label,
          label: label,
          subtitle: null,
          shortcut: null,
          icon: null,
          enabled: true,
          keywords: <String>[label.toLowerCase()],
          payload: {'id': label, 'label': label},
        ),
      );
      continue;
    }

    final map = coerceObjectMap(item);
    final label =
        (map['label'] ?? map['title'] ?? map['text'] ?? map['id'] ?? 'Command')
            .toString();
    final id = (map['id'] ?? map['value'] ?? label).toString();
    final keywords = <String>{label.toLowerCase()};
    final rawKeywords = map['keywords'];
    if (rawKeywords is List) {
      for (final keyword in rawKeywords) {
        final text = keyword?.toString().toLowerCase();
        if (text != null && text.isNotEmpty) {
          keywords.add(text);
        }
      }
    }
    final subtitle = map['subtitle']?.toString();
    if (subtitle != null && subtitle.isNotEmpty) {
      keywords.add(subtitle.toLowerCase());
    }

    out.add(
      _CommandData(
        id: id,
        label: label,
        subtitle: subtitle,
        shortcut: (map['shortcut'] ?? map['meta'])?.toString(),
        icon: map['icon'],
        enabled: map['enabled'] == null ? true : (map['enabled'] == true),
        keywords: keywords.toList(growable: false),
        payload: {...map, 'id': id, 'label': label},
      ),
    );
  }
  return out;
}

List<_CommandData> _filter(
  List<_CommandData> commands,
  String query,
  bool showAllOnEmpty,
) {
  final needle = query.trim().toLowerCase();
  if (needle.isEmpty && showAllOnEmpty) return commands;
  if (needle.isEmpty) return commands;

  final out = <_CommandData>[];
  for (final command in commands) {
    if (command.keywords.any((keyword) => keyword.contains(needle))) {
      out.add(command);
    }
  }
  return out;
}
