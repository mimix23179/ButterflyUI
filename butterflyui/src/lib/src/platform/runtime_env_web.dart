// Web implementation: read runtime config from query params.
String? runtimeWsUrl() {
  final params = Uri.base.queryParameters;
  return params['ws'] ??
      params['BUTTERFLYUI_WS_URL'] ??
      params['butterflyui_ws_url'];
}

String? runtimeSessionToken() {
  final params = Uri.base.queryParameters;
  return params['token'] ??
      params['BUTTERFLYUI_SESSION_TOKEN'] ??
      params['butterflyui_session_token'];
}

String? runtimeFrameRate() {
  final params = Uri.base.queryParameters;
  return params['fps'] ??
      params['frame_rate'] ??
      params['BUTTERFLYUI_FRAME_RATE'] ??
      params['butterflyui_frame_rate'];
}
