// IO implementation: reads env var on non-web platforms.
import 'dart:io' as io;

String? runtimeWsUrl() {
  final env = io.Platform.environment['CONDUIT_WS_URL'];
  if (env != null && env.isNotEmpty) return env;
  return null;
}

String? runtimeSessionToken() {
  final env = io.Platform.environment['CONDUIT_SESSION_TOKEN'];
  if (env != null && env.isNotEmpty) return env;
  return null;
}

String? runtimeFrameRate() {
  final env = io.Platform.environment['CONDUIT_FRAME_RATE'];
  if (env != null && env.isNotEmpty) return env;
  return null;
}
