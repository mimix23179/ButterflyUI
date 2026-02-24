import 'package:flutter/foundation.dart';

typedef ButterflyUIInvokeHandler =
    Future<Object?> Function(String method, Map<String, Object?> args);

typedef ButterflyUIRegisterInvokeHandler =
    void Function(String controlId, ButterflyUIInvokeHandler handler);

typedef ButterflyUIUnregisterInvokeHandler = void Function(String controlId);

typedef ButterflyUISendRuntimeEvent =
    void Function(String controlId, String event, Map<String, Object?> payload);

typedef ButterflyUISendRuntimeSystemEvent =
    void Function(String kind, Map<String, Object?> payload);

@immutable
class ButterflyUIWebViewProps {
  final String url;
  final List<String> preventLinks;
  final String html;
  final String? baseUrl;
  final Object? bgcolor;
  final String engine;
  final String fallbackEngine;
  final Map<String, String> requestHeaders;
  final String? userAgent;
  final bool javascriptEnabled;
  final bool domStorageEnabled;
  final bool thirdPartyCookiesEnabled;
  final bool cacheEnabled;
  final bool clearCacheOnStart;
  final bool incognito;
  final bool mediaPlaybackRequiresUserGesture;
  final bool allowsInlineMediaPlayback;
  final bool allowFileAccess;
  final bool allowUniversalAccessFromFileUrls;
  final bool allowPopups;
  final bool openExternalLinks;
  final int initTimeoutMs;

  const ButterflyUIWebViewProps({
    required this.url,
    required this.preventLinks,
    this.html = '',
    this.baseUrl,
    this.bgcolor,
    this.engine = 'inapp',
    this.fallbackEngine = '',
    this.requestHeaders = const <String, String>{},
    this.userAgent,
    this.javascriptEnabled = true,
    this.domStorageEnabled = true,
    this.thirdPartyCookiesEnabled = true,
    this.cacheEnabled = true,
    this.clearCacheOnStart = false,
    this.incognito = false,
    this.mediaPlaybackRequiresUserGesture = false,
    this.allowsInlineMediaPlayback = true,
    this.allowFileAccess = true,
    this.allowUniversalAccessFromFileUrls = false,
    this.allowPopups = false,
    this.openExternalLinks = false,
    this.initTimeoutMs = 15000,
  });

  static bool _readBool(Object? value, {required bool fallback}) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true' ||
          normalized == '1' ||
          normalized == 'yes' ||
          normalized == 'on') {
        return true;
      }
      if (normalized == 'false' ||
          normalized == '0' ||
          normalized == 'no' ||
          normalized == 'off') {
        return false;
      }
    }
    return fallback;
  }

  static int _readInt(
    Object? value, {
    required int fallback,
    int min = 0,
    int max = 120000,
  }) {
    int parsed;
    if (value is int) {
      parsed = value;
    } else if (value is double) {
      parsed = value.toInt();
    } else {
      parsed = int.tryParse(value?.toString() ?? '') ?? fallback;
    }
    if (parsed < min) return min;
    if (parsed > max) return max;
    return parsed;
  }

  factory ButterflyUIWebViewProps.fromJson(Map<String, Object?> props) {
    final url = props['url']?.toString() ?? '';
    final html = props['html']?.toString() ?? '';
    final baseUrl = props['base_url']?.toString();
    final useInApp = props['use_inapp'] == true;
    final engineRaw =
        props['engine']?.toString() ?? props['webview_engine']?.toString();
    final engine = (engineRaw == null || engineRaw.isEmpty)
        ? (useInApp
              ? 'inapp'
              : (kIsWeb || defaultTargetPlatform != TargetPlatform.windows
                    ? 'flutter'
                    : 'inapp'))
        : engineRaw.toLowerCase();
    final fallbackEngine =
        props['fallback_engine']?.toString().trim().toLowerCase() ?? '';

    final preventLinksRaw = props['prevent_links'];
    final preventLinks = <String>[];
    if (preventLinksRaw is List) {
      for (final v in preventLinksRaw) {
        final s = v?.toString();
        if (s != null && s.isNotEmpty) preventLinks.add(s);
      }
    }

    final headers = <String, String>{};
    final requestHeadersRaw = props['request_headers'] ?? props['headers'];
    if (requestHeadersRaw is Map) {
      for (final entry in requestHeadersRaw.entries) {
        final key = entry.key.toString().trim();
        if (key.isEmpty) continue;
        final value = entry.value?.toString() ?? '';
        headers[key] = value;
      }
    }

    final javascriptEnabled = _readBool(
      props['javascript_enabled'] ?? props['js_enabled'],
      fallback: true,
    );
    final domStorageEnabled = _readBool(
      props['dom_storage_enabled'],
      fallback: true,
    );
    final thirdPartyCookiesEnabled = _readBool(
      props['third_party_cookies_enabled'],
      fallback: true,
    );
    final cacheEnabled = _readBool(props['cache_enabled'], fallback: true);
    final clearCacheOnStart = _readBool(
      props['clear_cache_on_start'],
      fallback: false,
    );
    final incognito = _readBool(props['incognito'], fallback: false);
    final mediaPlaybackRequiresUserGesture = _readBool(
      props['media_playback_requires_user_gesture'],
      fallback: false,
    );
    final allowsInlineMediaPlayback = _readBool(
      props['allows_inline_media_playback'],
      fallback: true,
    );
    final allowFileAccess = _readBool(
      props['allow_file_access'],
      fallback: true,
    );
    final allowUniversalAccessFromFileUrls = _readBool(
      props['allow_universal_access_from_file_urls'],
      fallback: false,
    );
    final allowPopups = _readBool(props['allow_popups'], fallback: false);
    final openExternalLinks = _readBool(
      props['open_external_links'],
      fallback: false,
    );
    final initTimeoutMs = _readInt(
      props['init_timeout_ms'],
      fallback: 15000,
      min: 1000,
      max: 120000,
    );

    return ButterflyUIWebViewProps(
      url: url,
      preventLinks: preventLinks,
      html: html,
      baseUrl: baseUrl,
      bgcolor: props['bgcolor'],
      engine: engine,
      fallbackEngine: fallbackEngine,
      requestHeaders: headers,
      userAgent: props['user_agent']?.toString(),
      javascriptEnabled: javascriptEnabled,
      domStorageEnabled: domStorageEnabled,
      thirdPartyCookiesEnabled: thirdPartyCookiesEnabled,
      cacheEnabled: cacheEnabled,
      clearCacheOnStart: clearCacheOnStart,
      incognito: incognito,
      mediaPlaybackRequiresUserGesture: mediaPlaybackRequiresUserGesture,
      allowsInlineMediaPlayback: allowsInlineMediaPlayback,
      allowFileAccess: allowFileAccess,
      allowUniversalAccessFromFileUrls: allowUniversalAccessFromFileUrls,
      allowPopups: allowPopups,
      openExternalLinks: openExternalLinks,
      initTimeoutMs: initTimeoutMs,
    );
  }
}
