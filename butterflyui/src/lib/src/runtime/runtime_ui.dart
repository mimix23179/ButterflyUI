import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'host/runtime_host.dart';

class ConduitRuntimeView extends StatefulWidget {
  final List<String> runtimeArgs;
  final ValueChanged<ThemeData?> onThemeChanged;

  const ConduitRuntimeView({
    super.key,
    required this.runtimeArgs,
    required this.onThemeChanged,
  });

  @override
  State<ConduitRuntimeView> createState() => _ConduitRuntimeViewState();
}

class _ConduitRuntimeViewState extends State<ConduitRuntimeView>
    with SingleTickerProviderStateMixin {
  static const bool _enableFpsTicker = bool.fromEnvironment(
    'CONDUIT_FPS_TICKER',
    defaultValue: false,
  );

  Ticker? _ticker;
  int _frameCount = 0;
  DateTime _lastFpsUpdate = DateTime.now();

  @override
  void initState() {
    super.initState();

    if (_enableFpsTicker) {
      _ticker = createTicker((elapsed) {
        _frameCount++;
        final now = DateTime.now();
        final timeDiff = now.difference(_lastFpsUpdate);

        if (timeDiff.inMilliseconds >= 1000) {
          _frameCount = 0;
          _lastFpsUpdate = now;
        }
      });
      _ticker?.start();
    }
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RuntimeHost(
      runtimeArgs: widget.runtimeArgs,
      onThemeChanged: widget.onThemeChanged,
    );
  }
}
