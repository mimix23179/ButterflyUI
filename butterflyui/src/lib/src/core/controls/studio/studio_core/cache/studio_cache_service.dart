import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;

import '../../studio_contract.dart';

class StudioCacheService {
  final Map<String, Map<String, Object?>> _thumbnailIndex =
      <String, Map<String, Object?>>{};
  final Map<String, Map<String, Object?>> _proxyIndex =
      <String, Map<String, Object?>>{};

  void loadFrom(Map<String, Object?> source) {
    _thumbnailIndex.clear();
    final thumbs = studioCoerceObjectMap(source['thumbnails']);
    for (final entry in thumbs.entries) {
      if (entry.value is Map) {
        _thumbnailIndex[entry.key] = studioCoerceObjectMap(entry.value);
      }
    }

    _proxyIndex.clear();
    final proxies = studioCoerceObjectMap(source['proxies']);
    for (final entry in proxies.entries) {
      if (entry.value is Map) {
        _proxyIndex[entry.key] = studioCoerceObjectMap(entry.value);
      }
    }
  }

  String buildCacheKey(String sourcePath, {String variant = 'default'}) {
    final digest = sha1
        .convert(utf8.encode('$variant::$sourcePath'))
        .toString();
    return '$variant:$digest';
  }

  Map<String, Object?> registerThumbnail({
    required String sourcePath,
    required String thumbnailPath,
    String variant = 'default',
  }) {
    final key = buildCacheKey(sourcePath, variant: variant);
    final entry = <String, Object?>{
      'source': sourcePath,
      'path': thumbnailPath,
      'variant': variant,
      'ext': p.extension(thumbnailPath).toLowerCase(),
      'updated_ms': DateTime.now().millisecondsSinceEpoch,
    };
    _thumbnailIndex[key] = entry;
    return entry;
  }

  Map<String, Object?> registerProxy({
    required String sourcePath,
    required String proxyPath,
    String profile = 'edit_low',
  }) {
    final key = buildCacheKey(sourcePath, variant: profile);
    final entry = <String, Object?>{
      'source': sourcePath,
      'path': proxyPath,
      'profile': profile,
      'ext': p.extension(proxyPath).toLowerCase(),
      'updated_ms': DateTime.now().millisecondsSinceEpoch,
    };
    _proxyIndex[key] = entry;
    return entry;
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'thumbnails': _thumbnailIndex,
      'proxies': _proxyIndex,
    };
  }
}
