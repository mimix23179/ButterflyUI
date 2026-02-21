import 'package:flutter/material.dart';

import '../../core/webview/webview_api.dart';

class ConduitBootHost extends StatelessWidget {
  final String? message;
  final double? progress;
  final List<Map<String, Object?>>? actions;
  final ConduitSendRuntimeEvent sendEvent;
  final String controlId;

  const ConduitBootHost({
    super.key,
    this.message,
    this.progress,
    this.actions,
    required this.sendEvent,
    required this.controlId,
  });

  void _emitAction(Map<String, Object?> action) {
    final event = action['event']?.toString() ?? 'action';
    final payload = <String, Object?>{
      'action_id': action['id']?.toString(),
      'label': action['label']?.toString(),
    };
    final extra = action['payload'];
    if (extra is Map) {
      payload.addAll(extra.map((k, v) => MapEntry(k.toString(), v)));
    }
    sendEvent(controlId, event, payload);
  }

  @override
  Widget build(BuildContext context) {
    final status = message ?? 'Booting…';
    return Container(
      color: const Color(0xFF0F1216),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Made with Conduit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                status,
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              if (progress != null) ...[
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: progress!.clamp(0, 1),
                  backgroundColor: const Color(0xFF1C2430),
                  color: Colors.blueAccent,
                ),
              ],
              if (actions != null && actions!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: actions!
                      .map(
                        (action) => OutlinedButton(
                          onPressed: () => _emitAction(action),
                          child: Text(action['label']?.toString() ?? 'Action'),
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
