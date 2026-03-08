import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';

import 'src/runtime/runtime_ui.dart';
import 'src/runtime/frame_pacer.dart';
import 'src/core/notifications/notification_root.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Frame pacer automatically initializes and locks to 60 FPS
  // This happens immediately when the frame_pacer.dart is imported
  debugPrint('Frame pacer initialized: ${framePacer.getStats()}');

  try {
    MediaKit.ensureInitialized();
  } catch (_) {
    // Allow the runtime to start even if media_kit native deps are missing.
  }

  runApp(MainApp(runtimeArgs: args));
}

class MainApp extends StatefulWidget {
  final List<String> runtimeArgs;

  const MainApp({super.key, required this.runtimeArgs});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  ThemeData _theme = ThemeData(useMaterial3: true);

  void _applyTheme(ThemeData? theme) {
    setState(() {
      _theme = theme ?? ThemeData(useMaterial3: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _theme,
      home: NotificationRoot(
        child: ButterflyUIRuntimeView(
          runtimeArgs: widget.runtimeArgs,
          onThemeChanged: _applyTheme,
        ),
      ),
    );
  }
}
