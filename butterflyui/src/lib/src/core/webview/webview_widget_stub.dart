import 'package:flutter/material.dart';

import 'webview_api.dart';

class ButterflyUIWebViewWidget extends StatelessWidget {
  final String controlId;
  final ButterflyUIWebViewProps props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUIWebViewWidget({
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
