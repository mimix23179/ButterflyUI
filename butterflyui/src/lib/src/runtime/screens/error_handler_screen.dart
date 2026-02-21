import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'runtime_splash_frame.dart';
import 'traceback_logger.dart';
import '../../core/candy/theme_extension.dart';

class ErrorHandlerScreen extends StatelessWidget {
  final Map<String, Object?>? payload;
  final VoidCallback? onRetry;

  const ErrorHandlerScreen({super.key, required this.payload, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeTokens = theme.extension<ButterflyUIThemeTokens>();
    final title = payload?['title']?.toString() ?? 'Runtime problem';
    final message = payload?['message']?.toString() ?? 'Unknown error';
    final severity = payload?['severity']?.toString() ?? 'error';
    final errorClass =
        _firstString(payload?['error_class']) ??
        _firstString(payload?['error_classes']) ??
        'RuntimeError';
    final errorKind = _firstString(payload?['error_kind']);
    final errorText = payload?['error']?.toString();
    final traceback = payload?['traceback']?.toString();
    TracebackLogger.logOnce(title: title, traceback: traceback);
    final fileEntry = _firstFile(payload);
    final filePath =
        payload?['file']?.toString() ?? fileEntry?['path']?.toString();
    final line = _coerceInt(payload?['line']) ?? _coerceInt(fileEntry?['line']);
    final snippet =
        payload?['snippet']?.toString() ?? fileEntry?['snippet']?.toString();
    final showTraceback =
        (kDebugMode || kProfileMode) &&
        traceback != null &&
        traceback.isNotEmpty;

    final accent = _severityColor(severity, theme, themeTokens);
    final secondary = themeTokens?.secondary ?? accent.withOpacity(0.4);

    final card = _buildCard(
      title: title,
      severity: severity,
      errorClass: errorClass,
      errorKind: errorKind,
      errorText: errorText ?? message,
      filePath: filePath,
      line: line,
      snippet: snippet,
      traceback: traceback,
      showTraceback: showTraceback,
      accent: accent,
      themeTokens: themeTokens,
    );

    return RuntimeSplashFrame(
      accent: accent,
      secondary: secondary,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 420),
            curve: Curves.easeOutCubic,
            child: card,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, (1 - value) * 16),
                  child: child,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String severity,
    required String errorClass,
    required String? errorKind,
    required String errorText,
    required String? filePath,
    required int? line,
    required String? snippet,
    required String? traceback,
    required bool showTraceback,
    required Color accent,
    required ButterflyUIThemeTokens? themeTokens,
  }) {
    final codeStyle = TextStyle(
      color: themeTokens?.mutedText ?? const Color(0xFFD6DBE2),
      fontFamily: themeTokens?.monoFamily ?? 'Cascadia Code',
      fontSize: 12,
      height: 1.4,
    );

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: (themeTokens?.surface ?? const Color(0xFF121722)).withOpacity(
          0.92,
        ),
        borderRadius: BorderRadius.circular(themeTokens?.radiusLg ?? 18),
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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Made with ButterflyUI',
            style: TextStyle(
              color: (themeTokens?.mutedText ?? Colors.white).withOpacity(0.7),
              fontSize: 12,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
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
              _pill(accent, severityLabel(severity)),
              _pill(const Color(0xFF2F3B4B), errorClass),
              if (errorKind != null && errorKind.isNotEmpty)
                _pill(const Color(0xFF1E262F), errorKind),
            ],
          ),
          const SizedBox(height: 18),
          _sectionTitle('Error', themeTokens?.mutedText ?? Colors.white70),
          const SizedBox(height: 8),
          Text(
            errorText,
            style: TextStyle(
              color: (themeTokens?.text ?? Colors.white70).withOpacity(0.8),
            ),
          ),
          if (filePath != null && filePath.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              line == null ? filePath : '$filePath:$line',
              style: TextStyle(
                color: (themeTokens?.mutedText ?? Colors.white38).withOpacity(
                  0.7,
                ),
                fontSize: 12,
              ),
            ),
          ],
          const SizedBox(height: 18),
          _sectionTitle('Snippet', themeTokens?.mutedText ?? Colors.white70),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (themeTokens?.surfaceAlt ?? const Color(0xFF0E131B))
                  .withOpacity(0.9),
              borderRadius: BorderRadius.circular(themeTokens?.radiusMd ?? 12),
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
          _sectionTitle('Traceback', themeTokens?.mutedText ?? Colors.white70),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (themeTokens?.surfaceAlt ?? const Color(0xFF0E131B))
                  .withOpacity(0.9),
              borderRadius: BorderRadius.circular(themeTokens?.radiusMd ?? 12),
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
          if (onRetry != null) ...[
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: accent.withOpacity(0.9),
                foregroundColor: themeTokens?.background ?? Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    themeTokens?.radiusSm ?? 10,
                  ),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }

  String severityLabel(Object? raw) {
    final value = raw?.toString().trim().toLowerCase();
    if (value == null || value.isEmpty) return 'error';
    return value;
  }
}

Color _severityColor(
  String severity,
  ThemeData theme,
  ButterflyUIThemeTokens? tokens,
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

String? _firstString(Object? value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is List) {
    for (final item in value) {
      if (item == null) continue;
      final text = item.toString();
      if (text.isNotEmpty) return text;
    }
  }
  return value.toString();
}

Map<String, Object?>? _firstFile(Map<String, Object?>? payload) {
  if (payload == null) return null;
  final files = payload['files'];
  if (files is List) {
    for (final item in files) {
      if (item is Map) {
        return item.map((key, value) => MapEntry(key.toString(), value));
      }
    }
  }
  return null;
}

int? _coerceInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value == null) return null;
  return int.tryParse(value.toString());
}

