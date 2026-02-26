import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ButterflyUIWindowApi {
  ButterflyUIWindowApi._();

  static final ButterflyUIWindowApi instance = ButterflyUIWindowApi._();
  static const MethodChannel _channel = MethodChannel('butterflyui/window');

  bool _customFrameInitialized = false;
  bool _customFrameEnabled = false;
  bool _dragInFlight = false;
  String? _lastAction;
  DateTime? _lastActionAt;
  DateTime? _lastDragAt;

  bool get _supportsBridge => !kIsWeb;

  Future<void> ensureCustomFrame(bool enabled) async {
    if (!_supportsBridge) return;
    if (_customFrameInitialized && _customFrameEnabled == enabled) return;
    try {
      await _channel.invokeMethod<void>('setCustomFrame', <String, Object?>{
        'enabled': enabled,
      });
      _customFrameInitialized = true;
      _customFrameEnabled = enabled;
    } on MissingPluginException {
      // Ignore when runner support is unavailable on the active target.
    } on PlatformException {
      // Keep runtime functional even if host channel fails.
    }
  }

  Future<void> performAction(String action) async {
    if (!_supportsBridge) return;
    final value = action.trim().toLowerCase();
    if (value.isEmpty) return;
    final now = DateTime.now();
    if (_lastAction == value &&
        _lastActionAt != null &&
        now.difference(_lastActionAt!).inMilliseconds < 140) {
      return;
    }
    _lastAction = value;
    _lastActionAt = now;
    try {
      await _channel.invokeMethod<void>('windowAction', <String, Object?>{
        'action': value,
      });
    } on MissingPluginException {
      // Ignore when runner support is unavailable on the active target.
    } on PlatformException {
      // Keep runtime functional even if host channel fails.
    }
  }

  Future<void> startDrag() async {
    if (!_supportsBridge) return;
    if (_dragInFlight) return;
    final now = DateTime.now();
    if (_lastDragAt != null &&
        now.difference(_lastDragAt!).inMilliseconds < 180) {
      return;
    }
    _dragInFlight = true;
    _lastDragAt = now;
    try {
      await _channel.invokeMethod<void>('startDrag');
    } on MissingPluginException {
      // Ignore when runner support is unavailable on the active target.
    } on PlatformException {
      // Keep runtime functional even if host channel fails.
    } finally {
      _dragInFlight = false;
    }
  }

  Future<bool> isMaximized() async {
    if (!_supportsBridge) return false;
    try {
      final result = await _channel.invokeMethod<bool>('isMaximized');
      return result == true;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }
}
