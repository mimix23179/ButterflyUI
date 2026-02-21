// Web implementation: read runtime config from query params.
String? runtimeWsUrl() {
  final params = Uri.base.queryParameters;
  return params['ws'] ??
      params['CONDUIT_WS_URL'] ??
      params['conduit_ws_url'];
}

String? runtimeSessionToken() {
  final params = Uri.base.queryParameters;
  return params['token'] ??
      params['CONDUIT_SESSION_TOKEN'] ??
      params['conduit_session_token'];
}

String? runtimeFrameRate() {
  final params = Uri.base.queryParameters;
  return params['fps'] ??
      params['frame_rate'] ??
      params['CONDUIT_FRAME_RATE'] ??
      params['conduit_frame_rate'];
}
