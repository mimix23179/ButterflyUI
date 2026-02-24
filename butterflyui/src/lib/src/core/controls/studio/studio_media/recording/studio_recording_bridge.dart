import '../../studio_contract.dart';

class StudioRecordingBridge {
  bool supported = false;
  bool active = false;
  bool includeMic = true;
  bool includeSystemAudio = false;
  String outputPath = '';
  String format = 'mp4';

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
  }

  void start({
    String outputPath = '',
    bool includeMic = true,
    bool includeSystemAudio = false,
    String format = 'mp4',
  }) {
    active = true;
    this.outputPath = outputPath;
    this.includeMic = includeMic;
    this.includeSystemAudio = includeSystemAudio;
    final normalized = studioNorm(format);
    if (normalized.isNotEmpty) {
      this.format = normalized;
    }
  }

  void stop() {
    active = false;
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'supported': supported,
      'active': active,
      'include_mic': includeMic,
      'include_system_audio': includeSystemAudio,
      'output_path': outputPath,
      'format': format,
    };
  }
}
