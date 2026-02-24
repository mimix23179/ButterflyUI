import 'package:butterflyui_runtime/src/core/control_utils.dart';

class StudioPlaybackService {
  bool playing = false;
  double position = 0;
  double duration = 0;
  double speed = 1;
  String source = '';
  bool looping = false;

  void loadFrom(Map<String, Object?> sourceMap) {
    playing = sourceMap['playing'] == true;
    looping = sourceMap['looping'] == true;
    position = coerceDouble(sourceMap['position']) ?? position;
    duration = coerceDouble(sourceMap['duration']) ?? duration;
    speed = (coerceDouble(sourceMap['speed']) ?? speed).clamp(0.1, 4.0);
    source = (sourceMap['source'] ?? source).toString();
  }

  void seek(double value) {
    position = value.clamp(0, duration <= 0 ? value : duration).toDouble();
  }

  void play() => playing = true;

  void pause() => playing = false;

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'playing': playing,
      'looping': looping,
      'position': position,
      'duration': duration,
      'speed': speed,
      'source': source,
    };
  }
}
