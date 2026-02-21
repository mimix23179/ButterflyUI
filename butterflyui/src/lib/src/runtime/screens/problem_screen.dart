import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/webview/webview_api.dart';
import 'runtime_splash_frame.dart';
import 'traceback_logger.dart';
import '../../core/candy/theme_extension.dart';

class ConduitProblemScreen extends StatelessWidget {
  final String? title;
  final String? message;
  final String severity;
  final String? traceback;
  final List<Map<String, Object?>>? files;
  final List<String>? relatedFiles;
  final List? relatedModules;
  final String? sessionId;
  final Map<String, Object?>? uiSnapshot;
  final List<Map<String, Object?>>? actions;
  final String? variant;
  final List<String>? errorClasses;
  final ConduitSendRuntimeEvent sendEvent;
  final String controlId;

  const ConduitProblemScreen({
    super.key,
    this.title,
    this.message,
    required this.severity,
    this.traceback,
    this.files,
    this.relatedFiles,
    this.relatedModules,
    this.sessionId,
    this.uiSnapshot,
    this.actions,
    this.variant,
    this.errorClasses,
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
    final theme = Theme.of(context);
    final themeTokens = theme.extension<ConduitThemeTokens>();
    final titleText = title ?? 'Runtime problem';
    final messageText = message ?? 'An unexpected error occurred.';
    final accent = _severityColor(severity, theme, themeTokens);
    final showTraceback =
        (kDebugMode || kProfileMode) &&
        traceback != null &&
        traceback!.isNotEmpty;
    TracebackLogger.logOnce(title: titleText, traceback: traceback);
    final primaryFile = files != null && files!.isNotEmpty
        ? files!.first
        : null;
    final snippet = primaryFile?['snippet']?.toString();
    final codeStyle = TextStyle(
      color: themeTokens?.mutedText ?? const Color(0xFFD6DBE2),
      fontFamily: themeTokens?.monoFamily ?? 'Cascadia Code',
      fontSize: 12,
      height: 1.4,
    );

    return RuntimeSplashFrame(
      accent: accent,
      secondary: accent.withOpacity(0.4),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 460),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, (1 - value) * 18),
                  child: child,
                ),
              );
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: (themeTokens?.surface ?? const Color(0xFF121722))
                      .withOpacity(0.92),
                  borderRadius: BorderRadius.circular(
                    themeTokens?.radiusLg ?? 18,
                  ),
                  border: Border.all(
                    color: themeTokens?.border ?? const Color(0xFF2A3342),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withOpacity(0.22),
                      blurRadius: 28,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Made with Conduit',
                      style: TextStyle(
                        color: (themeTokens?.mutedText ?? Colors.white)
                            .withOpacity(0.7),
                        fontSize: 12,
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      titleText,
                      style: TextStyle(
                        color: themeTokens?.text ?? Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        fontFamily: themeTokens?.monoFamily ?? 'Cascadia Code',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _pill(accent, severity.toUpperCase()),
                        if (variant != null && variant!.isNotEmpty)
                          _pill(const Color(0xFF2F3B4B), variant!),
                        if (errorClasses != null && errorClasses!.isNotEmpty)
                          _pill(const Color(0xFF1E262F), errorClasses!.first),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _sectionTitle(
                      'Error',
                      themeTokens?.mutedText ?? Colors.white70,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      messageText,
                      style: TextStyle(
                        color: (themeTokens?.text ?? Colors.white70)
                            .withOpacity(0.8),
                      ),
                    ),
                    if (sessionId != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Session: $sessionId',
                        style: TextStyle(
                          color: (themeTokens?.mutedText ?? Colors.white38)
                              .withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    _sectionTitle(
                      'Snippet',
                      themeTokens?.mutedText ?? Colors.white70,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            (themeTokens?.surfaceAlt ?? const Color(0xFF0E131B))
                                .withOpacity(0.9),
                        borderRadius: BorderRadius.circular(
                          themeTokens?.radiusMd ?? 12,
                        ),
                        border: Border.all(
                          color: themeTokens?.border ?? const Color(0xFF2A3342),
                        ),
                      ),
                      child: SelectableText(
                        snippet?.trim().isNotEmpty == true
                            ? snippet!
                            : 'Snippet unavailable.',
                        style: codeStyle,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _sectionTitle(
                      'Traceback',
                      themeTokens?.mutedText ?? Colors.white70,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            (themeTokens?.surfaceAlt ?? const Color(0xFF0E131B))
                                .withOpacity(0.9),
                        borderRadius: BorderRadius.circular(
                          themeTokens?.radiusMd ?? 12,
                        ),
                        border: Border.all(
                          color: themeTokens?.border ?? const Color(0xFF2A3342),
                        ),
                      ),
                      child: SelectableText(
                        showTraceback
                            ? (traceback ?? 'Traceback unavailable.')
                            : 'Traceback hidden in release mode.',
                        style: codeStyle,
                      ),
                    ),
                    if (files != null && files!.isNotEmpty) ...[
                      const SizedBox(height: 18),
                      _sectionTitle(
                        'Files',
                        themeTokens?.mutedText ?? Colors.white70,
                      ),
                      const SizedBox(height: 8),
                      ...files!.map((file) {
                        final path = file['path']?.toString() ?? '';
                        final line = file['line']?.toString() ?? '';
                        return Text(
                          line.isNotEmpty ? '$path:$line' : path,
                          style: TextStyle(
                            color: (themeTokens?.mutedText ?? Colors.white54)
                                .withOpacity(0.8),
                            fontSize: 12,
                          ),
                        );
                      }),
                    ],
                    if (relatedFiles != null && relatedFiles!.isNotEmpty) ...[
                      const SizedBox(height: 18),
                      _sectionTitle(
                        'Workspace Files',
                        themeTokens?.mutedText ?? Colors.white70,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: relatedFiles!
                            .map((file) => _pill(const Color(0xFF1B2230), file))
                            .toList(),
                      ),
                    ],
                    if (actions != null && actions!.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: actions!
                            .map(
                              (action) => OutlinedButton(
                                onPressed: () => _emitAction(action),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor:
                                      themeTokens?.text ?? Colors.white,
                                  side: BorderSide(
                                    color: accent.withOpacity(0.6),
                                  ),
                                ),
                                child: Text(
                                  action['label']?.toString() ?? 'Action',
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Color _severityColor(
  String severity,
  ThemeData theme,
  ConduitThemeTokens? tokens,
) {
  switch (severity.toLowerCase()) {
    case 'warning':
      return tokens?.warning ?? theme.colorScheme.tertiary;
    case 'info':
      return tokens?.info ?? theme.colorScheme.primaryContainer;
    default:
      return tokens?.error ?? theme.colorScheme.error;
  }
}

Widget _pill(Color color, String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: color.withOpacity(0.2),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: color.withOpacity(0.6)),
    ),
    child: Text(
      text.toUpperCase(),
      style: TextStyle(
        color: color.withOpacity(0.95),
        fontSize: 11,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

Widget _sectionTitle(String text, Color color) {
  return Text(
    text,
    style: TextStyle(
      color: color,
      fontSize: 13,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.0,
    ),
  );
}

