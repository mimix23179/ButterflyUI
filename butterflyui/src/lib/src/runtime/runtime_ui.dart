import 'package:flutter/material.dart';

import 'host/runtime_host.dart';

class ButterflyUIRuntimeView extends StatefulWidget {
  final List<String> runtimeArgs;
  final ValueChanged<ThemeData?> onThemeChanged;

  const ButterflyUIRuntimeView({
    super.key,
    required this.runtimeArgs,
    required this.onThemeChanged,
  });

  @override
  State<ButterflyUIRuntimeView> createState() => _ButterflyUIRuntimeViewState();
}

class _ButterflyUIRuntimeViewState extends State<ButterflyUIRuntimeView> {
  @override
  Widget build(BuildContext context) {
    return RuntimeHost(
      runtimeArgs: widget.runtimeArgs,
      onThemeChanged: widget.onThemeChanged,
    );
  }
}
