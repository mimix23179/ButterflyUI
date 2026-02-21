import 'package:flutter/material.dart';

import 'webview_api.dart';

class ConduitWebViewWidget extends StatelessWidget {
  final String controlId;
  final ConduitWebViewProps props;
  final ConduitRegisterInvokeHandler registerInvokeHandler;
  final ConduitUnregisterInvokeHandler unregisterInvokeHandler;
  final ConduitSendRuntimeEvent sendEvent;

  const ConduitWebViewWidget({
    super.key,
    required this.controlId,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 300,
      child: Center(child: Text('WebView is not supported on this platform.')),
    );
  }
}
