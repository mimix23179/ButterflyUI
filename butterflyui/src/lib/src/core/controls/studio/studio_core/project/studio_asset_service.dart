import 'package:crypto/crypto.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../../studio_contract.dart';

class StudioAssetService {
  final Uuid _uuid = const Uuid();
  final List<Map<String, Object?>> _assets = <Map<String, Object?>>[];

  List<Map<String, Object?>> get assets =>
      List<Map<String, Object?>>.unmodifiable(_assets);

  void loadFrom(Map<String, Object?> source) {
    _assets
      ..clear()
      ..addAll(studioCoerceMapList(source['assets'] ?? source['items']));
  }

  Map<String, Object?> importAsset({
    required String path,
    String mode = 'copy',
    Map<String, Object?> metadata = const <String, Object?>{},
  }) {
    final normalizedPath = path.trim();
    final existing = _assets.where(
      (asset) => (asset['path'] ?? '').toString() == normalizedPath,
    );
    if (existing.isNotEmpty) {
      return existing.first;
    }
    final mime = lookupMimeType(normalizedPath) ?? 'application/octet-stream';
    final fileName = p.basename(normalizedPath);
    final digest = sha1.convert('$mode::$normalizedPath'.codeUnits).toString();
    final record = <String, Object?>{
      'id': metadata['id']?.toString().trim().isNotEmpty == true
          ? metadata['id']
          : _uuid.v4(),
      'path': normalizedPath,
      'name': metadata['name'] ?? fileName,
      'ext': p.extension(fileName).toLowerCase(),
      'mime': metadata['mime'] ?? mime,
      'mode': studioNorm(mode).isEmpty ? 'copy' : studioNorm(mode),
      'digest': digest,
      'imported_ms': DateTime.now().millisecondsSinceEpoch,
      ...metadata,
    };
    _assets.add(record);
    return record;
  }

  bool removeAsset(String id) {
    final normalized = id.trim();
    final index = _assets.indexWhere(
      (asset) => (asset['id'] ?? '').toString() == normalized,
    );
    if (index < 0) return false;
    _assets.removeAt(index);
    return true;
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{'assets': _assets};
  }
}
