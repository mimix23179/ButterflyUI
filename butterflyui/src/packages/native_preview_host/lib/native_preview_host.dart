import 'package:flutter/services.dart';

class NativePreviewHostApi {
  static const MethodChannel _channel = MethodChannel('conduit/native_preview_host');

  static Future<void> createHost(String hostId) async {
    await _channel.invokeMethod('createHost', {'host_id': hostId});
  }

  static Future<void> destroyHost(String hostId) async {
    await _channel.invokeMethod('destroyHost', {'host_id': hostId});
  }

  static Future<void> setVisible(String hostId, bool visible) async {
    await _channel.invokeMethod('setVisible', {'host_id': hostId, 'visible': visible});
  }

  static Future<void> updateRect(
    String hostId, {
    required int x,
    required int y,
    required int width,
    required int height,
  }) async {
    await _channel.invokeMethod('updateRect', {
      'host_id': hostId,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
    });
  }

  static Future<bool> attachWindow(
    String hostId, {
    int? windowHandle,
    int? processId,
  }) async {
    final result = await _channel.invokeMethod('attachWindow', {
      'host_id': hostId,
      'window_handle': windowHandle,
      'process_id': processId,
    });
    return result == true;
  }

  static Future<void> detachWindow(String hostId) async {
    await _channel.invokeMethod('detachWindow', {'host_id': hostId});
  }
}
