import 'package:uuid/uuid.dart';

import '../../studio_contract.dart';

class StudioFfmpegBridge {
  final Uuid _uuid = const Uuid();
  final List<Map<String, Object?>> _jobs = <Map<String, Object?>>[];

  List<Map<String, Object?>> get jobs =>
      List<Map<String, Object?>>.unmodifiable(_jobs);

  void loadFrom(Map<String, Object?> source) {
    _jobs
      ..clear()
      ..addAll(studioCoerceMapList(source['jobs']));
  }

  Map<String, Object?> enqueue({
    required String command,
    List<String> args = const <String>[],
    Map<String, Object?> payload = const <String, Object?>{},
  }) {
    final job = <String, Object?>{
      'job_id': _uuid.v4(),
      'command': command,
      'args': args,
      'payload': payload,
      'status': 'queued',
      'created_ms': DateTime.now().millisecondsSinceEpoch,
    };
    _jobs.add(job);
    return job;
  }

  Map<String, Object?>? startNext() {
    final index = _jobs.indexWhere(
      (job) => (job['status'] ?? 'queued') == 'queued',
    );
    if (index < 0) return null;
    _jobs[index]['status'] = 'running';
    _jobs[index]['started_ms'] = DateTime.now().millisecondsSinceEpoch;
    return _jobs[index];
  }

  bool updateStatus(String jobId, String status, {String? message}) {
    final index = _jobs.indexWhere((job) => (job['job_id'] ?? '') == jobId);
    if (index < 0) return false;
    _jobs[index]['status'] = studioNorm(status);
    if (message != null) {
      _jobs[index]['message'] = message;
    }
    _jobs[index]['updated_ms'] = DateTime.now().millisecondsSinceEpoch;
    return true;
  }

  bool complete(
    String jobId, {
    Map<String, Object?> result = const <String, Object?>{},
  }) {
    final updated = updateStatus(jobId, 'completed');
    if (!updated) return false;
    final index = _jobs.indexWhere((job) => (job['job_id'] ?? '') == jobId);
    if (index < 0) return false;
    _jobs[index]['completed_ms'] = DateTime.now().millisecondsSinceEpoch;
    _jobs[index]['result'] = result;
    return true;
  }

  bool fail(String jobId, {String error = ''}) {
    final updated = updateStatus(jobId, 'failed', message: error);
    if (!updated) return false;
    final index = _jobs.indexWhere((job) => (job['job_id'] ?? '') == jobId);
    if (index < 0) return false;
    _jobs[index]['failed_ms'] = DateTime.now().millisecondsSinceEpoch;
    _jobs[index]['error'] = error;
    return true;
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{'jobs': _jobs};
  }
}
