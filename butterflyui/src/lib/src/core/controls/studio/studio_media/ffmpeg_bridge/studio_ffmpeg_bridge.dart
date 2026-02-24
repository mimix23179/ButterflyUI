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

  Map<String, Object?> toMap() {
    return <String, Object?>{'jobs': _jobs};
  }
}
