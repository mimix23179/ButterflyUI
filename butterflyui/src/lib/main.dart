import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/runtime/runtime_ui.dart';
import 'src/runtime/frame_pacer.dart';
import 'src/core/notifications/notification_root.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Frame pacer automatically initializes and locks to 60 FPS
  // This happens immediately when the frame_pacer.dart is imported
  print('Frame pacer initialized: ${framePacer.getStats()}');

  try {
    MediaKit.ensureInitialized();
  } catch (_) {
    // Allow the runtime to start even if media_kit native deps are missing.
  }

  runApp(ProviderScope(child: MainApp(runtimeArgs: args)));
}

class MainApp extends StatefulWidget {
  final List<String> runtimeArgs;

  const MainApp({super.key, required this.runtimeArgs});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  ThemeData _theme = ThemeData(useMaterial3: true);
  late final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => NotificationRoot(
          child: ConduitRuntimeView(
            runtimeArgs: widget.runtimeArgs,
            onThemeChanged: _applyTheme,
          ),
        ),
      ),
    ],
  );

  void _applyTheme(ThemeData? theme) {
    setState(() {
      _theme = theme ?? ThemeData(useMaterial3: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(theme: _theme, routerConfig: _router);
  }
}
