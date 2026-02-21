import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Frame pacer for consistent 60 FPS performance
/// Automatically locks the application to 60 FPS when initialized
class FramePacer {
  static const int _defaultTargetFPS = 60;
  static const Duration _defaultTargetFrameDuration = Duration(
    microseconds: 16667,
  ); // ~60 FPS

  static const bool _logFps = bool.fromEnvironment(
    'CONDUIT_LOG_FPS',
    defaultValue: false,
  );

  static FramePacer? _instance;
  static FramePacer get instance => _instance ??= FramePacer._();

  FramePacer._() {
    _initialize();
  }

  Timer? _frameTimer;
  Timer? _performanceTimer;
  final Stopwatch _clock = Stopwatch();
  int _frameCount = 0;
  DateTime _lastPerformanceUpdate = DateTime.now();
  double _currentFPS = 0.0;

  int _targetFPS = _defaultTargetFPS;
  Duration _targetFrameDuration = _defaultTargetFrameDuration;

  bool _isInitialized = false;
  bool _isRunning = false;

  /// Initialize the frame pacer and lock to 60 FPS
  void _initialize() {
    if (_isInitialized) return;

    // Configure system for optimal performance
    _configureSystemSettings();

    // Add frame timing callback for monitoring
    WidgetsBinding.instance.addTimingsCallback(_onFrameTimings);

    // Start frame pacing ticker
    _startFramePacing();

    // Start performance monitoring
    _startPerformanceMonitoring();

    _isInitialized = true;
  }

  /// Update the target FPS.
  ///
  /// Note: Flutter will still align rendering to vsync; this controls how often
  /// we *request* a frame.
  void setTargetFps(int fps) {
    final next = fps.clamp(1, 240);
    if (next == _targetFPS) return;
    _targetFPS = next;
    _targetFrameDuration = Duration(
      microseconds: (1000000 / _targetFPS).round().clamp(1, 1000000),
    );
    if (_isRunning) {
      stop();
      _startFramePacing();
      _startPerformanceMonitoring();
    }
  }

  /// Configure system settings for optimal 60 FPS performance
  void _configureSystemSettings() {
    // Set preferred frame rate
    WidgetsBinding.instance.scheduleFrame();

    // Configure system UI for better performance
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
    );

    // Set preferred orientations
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  /// Start the frame pacing ticker
  void _startFramePacing() {
    if (_isRunning) return;

    if (!_clock.isRunning) {
      _clock
        ..reset()
        ..start();
    }
    _isRunning = true;
    _scheduleNextFrame();
  }

  void _scheduleNextFrame() {
    if (!_isRunning) return;

    final frameUs = _targetFrameDuration.inMicroseconds;
    final elapsedUs = _clock.elapsedMicroseconds;
    final nextFrameUs = ((elapsedUs ~/ frameUs) + 1) * frameUs;
    final delayUs = (nextFrameUs - elapsedUs).clamp(0, frameUs);

    _frameTimer?.cancel();
    _frameTimer = Timer(Duration(microseconds: delayUs), () {
      if (!_isRunning) return;
      WidgetsBinding.instance.scheduleFrame();
      _scheduleNextFrame();
    });
  }

  /// Start performance monitoring
  void _startPerformanceMonitoring() {
    _performanceTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updatePerformanceStats();
    });
  }

  /// Handle frame timing callbacks
  void _onFrameTimings(List<FrameTiming> timings) {
    _frameCount += timings.length;
    for (final timing in timings) {
      // If frame took too long, schedule next frame immediately
      if (!_isRunning) continue;
      if (timing.totalSpan.inMicroseconds >
          _targetFrameDuration.inMicroseconds) {
        WidgetsBinding.instance.scheduleFrame();
      }
    }
  }

  /// Update performance statistics
  void _updatePerformanceStats() {
    final now = DateTime.now();
    final timeSinceLastUpdate = now.difference(_lastPerformanceUpdate);

    if (timeSinceLastUpdate.inMilliseconds > 0) {
      _currentFPS = (_frameCount * 1000.0) / timeSinceLastUpdate.inMilliseconds;
    }

    if (_logFps) {
      print('Conduit FPS: ${_currentFPS.toStringAsFixed(1)} / $_targetFPS');
    }

    _frameCount = 0;
    _lastPerformanceUpdate = now;
  }

  /// Get current performance statistics
  FramePacerStats getStats() {
    return FramePacerStats(
      targetFPS: _targetFPS,
      currentFPS: _currentFPS,
      targetFrameDuration: _targetFrameDuration,
      isInitialized: _isInitialized,
      isRunning: _isRunning,
    );
  }

  /// Stop the frame pacer
  void stop() {
    _frameTimer?.cancel();
    _performanceTimer?.cancel();
    _clock.stop();
    _isRunning = false;
  }

  /// Dispose the frame pacer
  void dispose() {
    stop();
    _frameTimer?.cancel();
    _performanceTimer?.cancel();
    WidgetsBinding.instance.removeTimingsCallback(_onFrameTimings);
    _instance = null;
  }
}

/// Performance statistics from the frame pacer
class FramePacerStats {
  final int targetFPS;
  final double currentFPS;
  final Duration targetFrameDuration;
  final bool isInitialized;
  final bool isRunning;

  const FramePacerStats({
    required this.targetFPS,
    required this.currentFPS,
    required this.targetFrameDuration,
    required this.isInitialized,
    required this.isRunning,
  });

  @override
  String toString() {
    return 'FramePacerStats('
        'targetFPS: $targetFPS, '
        'currentFPS: ${currentFPS.toStringAsFixed(1)}, '
        'targetFrameDuration: ${targetFrameDuration.inMilliseconds}ms, '
        'isInitialized: $isInitialized, '
        'isRunning: $isRunning)';
  }
}

/// Global frame pacer instance - automatically initialized on import
final framePacer = FramePacer.instance;
