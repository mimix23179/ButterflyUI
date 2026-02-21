import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ConduitWindowApi {
  ConduitWindowApi._();

  static final ConduitWindowApi instance = ConduitWindowApi._();
  static const MethodChannel _channel = MethodChannel('conduit/window');

  bool _customFrameInitialized = false;
  bool _customFrameEnabled = false;

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
    try {
      await _channel.invokeMethod<void>('startDrag');
    } on MissingPluginException {
      // Ignore when runner support is unavailable on the active target.
    } on PlatformException {
      // Keep runtime functional even if host channel fails.
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
