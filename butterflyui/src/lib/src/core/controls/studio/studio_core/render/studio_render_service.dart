import 'package:uuid/uuid.dart';

import '../../studio_contract.dart';

class StudioRenderService {
  final Uuid _uuid = const Uuid();

  final List<Map<String, Object?>> _queue = <Map<String, Object?>>[];
  final List<Map<String, Object?>> _running = <Map<String, Object?>>[];
  final List<Map<String, Object?>> _completed = <Map<String, Object?>>[];
  final List<Map<String, Object?>> _failed = <Map<String, Object?>>[];

  List<Map<String, Object?>> get queue =>
      List<Map<String, Object?>>.unmodifiable(_queue);

  List<Map<String, Object?>> get running =>
      List<Map<String, Object?>>.unmodifiable(_running);

  List<Map<String, Object?>> get completed =>
      List<Map<String, Object?>>.unmodifiable(_completed);

  List<Map<String, Object?>> get failed =>
      List<Map<String, Object?>>.unmodifiable(_failed);

  void loadFrom(Map<String, Object?> source) {
    _queue
      ..clear()
      ..addAll(studioCoerceMapList(source['queue']));
    _running
      ..clear()
      ..addAll(studioCoerceMapList(source['running']));
    _completed
      ..clear()
      ..addAll(studioCoerceMapList(source['completed']));
    _failed
      ..clear()
      ..addAll(studioCoerceMapList(source['failed']));
  }

  Map<String, Object?> enqueueExport({
    required String format,
    required Map<String, Object?> payload,
  }) {
    final entry = <String, Object?>{
      'job_id': _uuid.v4(),
      'format': format,
      'payload': payload,
      'status': 'queued',
      'progress': 0.0,
      'created_ms': DateTime.now().millisecondsSinceEpoch,
    };
    _queue.add(entry);
    return entry;
  }

  Map<String, Object?>? startNext() {
    if (_queue.isEmpty) return null;
    final entry = _queue.removeAt(0);
    entry['status'] = 'running';
    entry['started_ms'] = DateTime.now().millisecondsSinceEpoch;
    final rawProgress = entry['progress'];
    final parsedProgress = rawProgress is num
        ? rawProgress.toDouble()
        : double.tryParse(rawProgress?.toString() ?? '') ?? 0.0;
    entry['progress'] = parsedProgress.clamp(0.0, 1.0).toDouble();
    _running.add(entry);
    return entry;
  }

  bool updateProgress(String jobId, double progress, {String? stage}) {
    final normalizedProgress = progress.clamp(0.0, 1.0).toDouble();
    for (var i = 0; i < _running.length; i += 1) {
      final entry = _running[i];
      if ((entry['job_id'] ?? '') != jobId) continue;
      entry['progress'] = normalizedProgress;
      if (stage != null) {
        entry['stage'] = stage;
      }
      entry['updated_ms'] = DateTime.now().millisecondsSinceEpoch;
      return true;
    }
    return false;
  }

  void completeJob(
    String jobId, {
    Map<String, Object?> result = const <String, Object?>{},
  }) {
    for (var i = 0; i < _running.length; i += 1) {
      final entry = _running[i];
      if ((entry['job_id'] ?? '') != jobId) continue;
      entry['status'] = 'completed';
      entry['progress'] = 1.0;
      entry['completed_ms'] = DateTime.now().millisecondsSinceEpoch;
      entry['result'] = result;
      _completed.add(entry);
      _running.removeAt(i);
      return;
    }
    for (var i = 0; i < _queue.length; i += 1) {
      final entry = _queue[i];
      if ((entry['job_id'] ?? '') != jobId) continue;
      entry['status'] = 'completed';
      entry['completed_ms'] = DateTime.now().millisecondsSinceEpoch;
      entry['result'] = result;
      _completed.add(entry);
      _queue.removeAt(i);
      return;
    }
  }

  void failJob(String jobId, {String error = ''}) {
    for (var i = 0; i < _running.length; i += 1) {
      final entry = _running[i];
      if ((entry['job_id'] ?? '') != jobId) continue;
      entry['status'] = 'failed';
      entry['failed_ms'] = DateTime.now().millisecondsSinceEpoch;
      entry['error'] = error;
      _failed.add(entry);
      _running.removeAt(i);
      return;
    }
    for (var i = 0; i < _queue.length; i += 1) {
      final entry = _queue[i];
      if ((entry['job_id'] ?? '') != jobId) continue;
      entry['status'] = 'failed';
      entry['failed_ms'] = DateTime.now().millisecondsSinceEpoch;
      entry['error'] = error;
      _failed.add(entry);
      _queue.removeAt(i);
      return;
    }
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'queue': _queue,
      'running': _running,
      'completed': _completed,
      'failed': _failed,
    };
  }
}
