import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:crypto/crypto.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../../studio_contract.dart';

class StudioProjectService {
  final Uuid _uuid = const Uuid();

  String projectId = '';
  String name = 'Untitled Studio Project';
  String rootPath = '';
  bool dirty = false;
  bool autosave = true;
  int revision = 0;

  final List<Map<String, Object?>> documents = <Map<String, Object?>>[];
  final List<Map<String, Object?>> assets = <Map<String, Object?>>[];

  void loadFrom(Map<String, Object?> source) {
    projectId = (source['id'] ?? source['project_id'] ?? '').toString().trim();
    if (projectId.isEmpty) {
      projectId = _uuid.v4();
    }
    name = (source['name'] ?? source['title'] ?? name).toString();
    rootPath = (source['path'] ?? source['root_path'] ?? '').toString();
    dirty = source['dirty'] == true;
    autosave = source['autosave'] == null
        ? autosave
        : (source['autosave'] == true);
    revision = coerceOptionalInt(source['revision']) ?? revision;

    documents
      ..clear()
      ..addAll(studioCoerceMapList(source['documents']));
    assets
      ..clear()
      ..addAll(studioCoerceMapList(source['assets']));
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'id': projectId,
      'name': name,
      'path': rootPath,
      'dirty': dirty,
      'autosave': autosave,
      'revision': revision,
      'documents': documents,
      'assets': assets,
    };
  }

  void openProject({
    required String name,
    required String path,
    bool autosave = true,
  }) {
    projectId = _uuid.v4();
    this.name = name;
    rootPath = path;
    this.autosave = autosave;
    revision = 1;
    dirty = false;
    documents.clear();
    assets.clear();
  }

  void touch() {
    dirty = true;
    revision += 1;
  }

  void markSaved() {
    dirty = false;
  }

  Map<String, Object?> registerDocument({
    required String path,
    String? label,
    String language = 'json',
  }) {
    final normalizedPath = path.trim();
    final existing = documents.where((doc) => doc['path'] == normalizedPath);
    if (existing.isNotEmpty) {
      return existing.first;
    }
    final record = <String, Object?>{
      'id': _uuid.v4(),
      'path': normalizedPath,
      'label': label ?? p.basename(normalizedPath),
      'language': language,
    };
    documents.add(record);
    touch();
    return record;
  }

  Map<String, Object?> registerAsset({
    required String path,
    Map<String, Object?> metadata = const <String, Object?>{},
  }) {
    final normalizedPath = path.trim();
    final existing = assets.where((asset) => asset['path'] == normalizedPath);
    if (existing.isNotEmpty) {
      return existing.first;
    }

    final digest = sha1.convert(utf8.encode(normalizedPath)).toString();
    final mimeType =
        lookupMimeType(normalizedPath) ?? 'application/octet-stream';
    final fileName = p.basename(normalizedPath);
    final extension = p.extension(fileName).toLowerCase();
    final record = <String, Object?>{
      'id': _uuid.v4(),
      'path': normalizedPath,
      'name': fileName,
      'ext': extension,
      'mime': mimeType,
      'digest': digest,
      ...metadata,
    };
    assets.add(record);
    touch();
    return record;
  }

  Map<String, Object?> buildArchivePreview() {
    final archive = Archive();
    final bytes = utf8.encode(jsonEncode(toMap()));
    archive.addFile(ArchiveFile('project.json', bytes.length, bytes));
    return <String, Object?>{
      'entry_count': archive.length,
      'total_size': archive.files.fold<int>(0, (sum, file) => sum + file.size),
      'entries': archive.files
          .map(
            (file) => <String, Object?>{'name': file.name, 'size': file.size},
          )
          .toList(growable: false),
    };
  }
}
