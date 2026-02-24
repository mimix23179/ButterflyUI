import 'package:uuid/uuid.dart';

import '../../studio_contract.dart';

class StudioRenderService {
  final Uuid _uuid = const Uuid();

  final List<Map<String, Object?>> _queue = <Map<String, Object?>>[];
  final List<Map<String, Object?>> _completed = <Map<String, Object?>>[];
  final List<Map<String, Object?>> _failed = <Map<String, Object?>>[];

  List<Map<String, Object?>> get queue =>
      List<Map<String, Object?>>.unmodifiable(_queue);

  List<Map<String, Object?>> get completed =>
      List<Map<String, Object?>>.unmodifiable(_completed);

  List<Map<String, Object?>> get failed =>
      List<Map<String, Object?>>.unmodifiable(_failed);

  void loadFrom(Map<String, Object?> source) {
    _queue
      ..clear()
      ..addAll(studioCoerceMapList(source['queue']));
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
    return entry;
  }

  void completeJob(
    String jobId, {
    Map<String, Object?> result = const <String, Object?>{},
  }) {
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
      'completed': _completed,
      'failed': _failed,
    };
  }
}
