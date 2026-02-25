import '../../studio_contract.dart';

class StudioRecordingBridge {
  bool supported = false;
  bool active = false;
  bool includeMic = true;
  bool includeSystemAudio = false;
  String outputPath = '';
  String format = 'mp4';
  String activeSessionId = '';
  int? startedMs;
  int lastDurationMs = 0;
  int lastUpdatedMs = 0;
  final List<Map<String, Object?>> _sessions = <Map<String, Object?>>[];
  final List<Map<String, Object?>> _events = <Map<String, Object?>>[];

  List<Map<String, Object?>> get sessions =>
      List<Map<String, Object?>>.unmodifiable(_sessions);

  List<Map<String, Object?>> get events =>
      List<Map<String, Object?>>.unmodifiable(_events);

  int get currentDurationMs {
    if (!active || startedMs == null) return lastDurationMs;
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    return (nowMs - startedMs!).clamp(0, 86400000);
  }

  void loadFrom(Map<String, Object?> source) {
    supported = source['supported'] == true;
    active = source['active'] == true;
    includeMic = source['include_mic'] == null
        ? includeMic
        : source['include_mic'] == true;
    includeSystemAudio = source['include_system_audio'] == true;
    outputPath = (source['output_path'] ?? outputPath).toString();
    final nextFormat = studioNorm((source['format'] ?? format).toString());
    if (nextFormat.isNotEmpty) {
      format = nextFormat;
    }
    startedMs = source['started_ms'] is num
        ? (source['started_ms'] as num).toInt()
        : startedMs;
    lastDurationMs = source['last_duration_ms'] is num
        ? (source['last_duration_ms'] as num).toInt()
        : lastDurationMs;
    lastUpdatedMs = source['last_updated_ms'] is num
        ? (source['last_updated_ms'] as num).toInt()
        : lastUpdatedMs;
    activeSessionId = (source['active_session_id'] ?? activeSessionId)
        .toString();
    _sessions
      ..clear()
      ..addAll(studioCoerceMapList(source['sessions']));
    _events
      ..clear()
      ..addAll(studioCoerceMapList(source['events']));
  }

  Map<String, Object?> start({
    String outputPath = '',
    bool includeMic = true,
    bool includeSystemAudio = false,
    String format = 'mp4',
    String? sessionId,
  }) {
    active = true;
    this.outputPath = outputPath;
    this.includeMic = includeMic;
    this.includeSystemAudio = includeSystemAudio;
    startedMs = DateTime.now().millisecondsSinceEpoch;
    lastUpdatedMs = startedMs!;
    activeSessionId = (sessionId == null || sessionId.trim().isEmpty)
        ? 'record_${startedMs!}'
        : sessionId.trim();
    final normalized = studioNorm(format);
    if (normalized.isNotEmpty) {
      this.format = normalized;
    }
    final event = <String, Object?>{
      'event': 'start',
      'timestamp_ms': startedMs,
      'session_id': activeSessionId,
      'output_path': this.outputPath,
      'format': this.format,
      'include_mic': this.includeMic,
      'include_system_audio': this.includeSystemAudio,
    };
    _events.insert(0, event);
    if (_events.length > 64) {
      _events.removeRange(64, _events.length);
    }
    return event;
  }

  Map<String, Object?>? stop({String reason = ''}) {
    final endedMs = DateTime.now().millisecondsSinceEpoch;
    Map<String, Object?>? session;
    if (startedMs != null) {
      lastDurationMs = (endedMs - startedMs!).clamp(0, 86400000);
      session = <String, Object?>{
        'session_id': activeSessionId,
        'started_ms': startedMs,
        'ended_ms': endedMs,
        'duration_ms': lastDurationMs,
        'output_path': outputPath,
        'format': format,
        'include_mic': includeMic,
        'include_system_audio': includeSystemAudio,
        if (reason.trim().isNotEmpty) 'reason': reason.trim(),
      };
      _sessions.insert(0, session);
      if (_sessions.length > 32) {
        _sessions.removeRange(32, _sessions.length);
      }
    }
    _events.insert(0, <String, Object?>{
      'event': 'stop',
      'timestamp_ms': endedMs,
      'session_id': activeSessionId,
      'duration_ms': lastDurationMs,
      if (reason.trim().isNotEmpty) 'reason': reason.trim(),
    });
    if (_events.length > 64) {
      _events.removeRange(64, _events.length);
    }
    active = false;
    startedMs = null;
    lastUpdatedMs = endedMs;
    activeSessionId = '';
    return session;
  }

  void clearSessions() {
    _sessions.clear();
    _events.insert(0, <String, Object?>{
      'event': 'clear_sessions',
      'timestamp_ms': DateTime.now().millisecondsSinceEpoch,
    });
    if (_events.length > 64) {
      _events.removeRange(64, _events.length);
    }
    lastDurationMs = 0;
    activeSessionId = '';
    startedMs = null;
    active = false;
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'supported': supported,
      'active': active,
      'active_session_id': activeSessionId,
      'include_mic': includeMic,
      'include_system_audio': includeSystemAudio,
      'output_path': outputPath,
      'format': format,
      'started_ms': startedMs,
      'last_duration_ms': lastDurationMs,
      'current_duration_ms': currentDurationMs,
      'last_updated_ms': lastUpdatedMs,
      'sessions': _sessions,
      'events': _events,
    };
  }
}
