import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class _OutputEntry {
  final String text;
  final String level;
  final String? timestamp;

  const _OutputEntry({required this.text, required this.level, this.timestamp});
}

class _ButterflyUIOutputPanel extends StatefulWidget {
  final String controlId;
  final Map<String, List<_OutputEntry>> channels;
  final String activeChannel;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const _ButterflyUIOutputPanel({
    required this.controlId,
    required this.channels,
    required this.activeChannel,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<_ButterflyUIOutputPanel> createState() => _ButterflyUIOutputPanelState();
}

class _ButterflyUIOutputPanelState extends State<_ButterflyUIOutputPanel> {
  late Map<String, List<_OutputEntry>> _channels = {
    for (final entry in widget.channels.entries)
      entry.key: List<_OutputEntry>.from(entry.value),
  };
  late String _activeChannel = widget.activeChannel;

  @override
  void initState() {
    super.initState();
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    if (_channels.isEmpty) {
      _channels['output'] = <_OutputEntry>[];
      _activeChannel = 'output';
    }
  }

  @override
  void didUpdateWidget(covariant _ButterflyUIOutputPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'append':
        {
          final channel = (args['channel'] ?? _activeChannel).toString();
          final text = args['text']?.toString() ?? '';
          if (text.isEmpty) return null;
          final level = (args['level'] ?? 'info').toString();
          final timestamp = args['timestamp']?.toString();
          setState(() {
            _channels.putIfAbsent(channel, () => <_OutputEntry>[]).add(
                  _OutputEntry(text: text, level: level, timestamp: timestamp),
                );
          });
          return null;
        }
      case 'clear_channel':
        {
          final channel = (args['channel'] ?? _activeChannel).toString();
          setState(() {
            _channels[channel] = <_OutputEntry>[];
          });
          return null;
        }
      case 'set_channel':
        {
          final channel = args['channel']?.toString() ?? _activeChannel;
          if (!_channels.containsKey(channel)) {
            _channels[channel] = <_OutputEntry>[];
          }
          setState(() {
            _activeChannel = channel;
          });
          widget.sendEvent(widget.controlId, 'channel_changed', {'channel': channel});
          return null;
        }
      case 'get_channel':
        {
          final channel = (args['channel'] ?? _activeChannel).toString();
          final entries = _channels[channel] ?? const <_OutputEntry>[];
          return entries
              .map(
                (entry) => {
                  'text': entry.text,
                  'level': entry.level,
                  'timestamp': entry.timestamp,
                },
              )
              .toList(growable: false);
        }
      default:
        throw UnsupportedError('Unknown output_panel method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final channelNames = _channels.keys.toList(growable: false);
    final entries = _channels[_activeChannel] ?? const <_OutputEntry>[];

    return Column(
      children: [
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final channel = channelNames[index];
              final selected = channel == _activeChannel;
              return ChoiceChip(
                label: Text(channel),
                selected: selected,
                onSelected: (_) {
                  setState(() {
                    _activeChannel = channel;
                  });
                  widget.sendEvent(widget.controlId, 'channel_changed', {'channel': channel});
                },
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemCount: channelNames.length,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    '[${entry.level}] ${entry.timestamp ?? ''} ${entry.text}'.trim(),
                    style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 12),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

Map<String, List<_OutputEntry>> _coerceOutputChannels(Map<String, Object?> props) {
  final out = <String, List<_OutputEntry>>{};
  final raw = props['channels'];
  if (raw is Map) {
    for (final entry in raw.entries) {
      final name = entry.key.toString();
      final items = <_OutputEntry>[];
      final value = entry.value;
      if (value is List) {
        for (final item in value) {
          if (item is Map) {
            final map = coerceObjectMap(item);
            items.add(
              _OutputEntry(
                text: (map['text'] ?? '').toString(),
                level: (map['level'] ?? 'info').toString(),
                timestamp: map['timestamp']?.toString(),
              ),
            );
          } else {
            items.add(_OutputEntry(text: item?.toString() ?? '', level: 'info'));
          }
        }
      }
      out[name] = items;
    }
  }
  if (out.isEmpty) {
    out['output'] = const <_OutputEntry>[];
  }
  return out;
}

Widget buildOutputPanelControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final channels = _coerceOutputChannels(props);
  final activeChannel = props['active_channel']?.toString() ?? channels.keys.first;
  return _ButterflyUIOutputPanel(
    controlId: controlId,
    channels: channels,
    activeChannel: activeChannel,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}
