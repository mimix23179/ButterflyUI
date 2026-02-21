import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../protocol/message.dart';
import '../runtime_client.dart';
import '../screens/bootup_screen.dart';
import '../screens/error_handler_screen.dart';
import '../renderer/app_renderer.dart';
import '../transport/websocket_transport.dart';
import '../../platform/runtime_env.dart';

enum RuntimePhase { booting, problem, ready }

class RuntimeHost extends StatefulWidget {
  final List<String> runtimeArgs;
  final ValueChanged<ThemeData?> onThemeChanged;

  const RuntimeHost({
    super.key,
    required this.runtimeArgs,
    required this.onThemeChanged,
  });

  @override
  State<RuntimeHost> createState() => _RuntimeHostState();
}

class _RuntimeHostState extends State<RuntimeHost> {
  RuntimePhase _phase = RuntimePhase.booting;
  String _status = 'Connecting...';
  String? _detail;
  Map<String, Object?>? _problem;
  RuntimeClient? _client;
  StreamSubscription<RuntimeMessage>? _subscription;
  bool _hasRoot = false;

  @override
  void initState() {
    super.initState();
    _boot();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _client?.disconnect();
    super.dispose();
  }

  Future<void> _boot() async {
    _subscription?.cancel();
    _client?.disconnect();
    _subscription = null;
    _client = null;

    setState(() {
      _phase = RuntimePhase.booting;
      _status = 'Connecting...';
      _detail = null;
      _problem = null;
      _hasRoot = false;
    });

    final wsArg = _extractArg(widget.runtimeArgs, '--ws=') ?? runtimeWsUrl();
    if (wsArg == null || wsArg.isEmpty) {
      setState(() {
        _phase = RuntimePhase.problem;
        _problem = {
          'title': 'Missing WebSocket URL',
          'message': 'Provide --ws=host:port to the runtime.',
          'severity': 'error',
        };
      });
      return;
    }
    final token =
        _extractArg(widget.runtimeArgs, '--token=') ?? runtimeSessionToken();

    final uri = _normalizeWsUri(wsArg);
    final transport = WebSocketRuntimeTransport(uri);
    final client = RuntimeClient(transport: transport);
    _client = client;
    if (mounted) {
      setState(() {});
    }

    try {
      await client.connectAndHello(token: token);
      if (!mounted) return;
      setState(() {
        _status = 'Connected';
        _detail = 'Waiting for runtime.ready';
      });
    } catch (exc) {
      if (!mounted) return;
      setState(() {
        _phase = RuntimePhase.problem;
        _problem = {
          'title': 'Connection failed',
          'message': exc.toString(),
          'severity': 'error',
        };
      });
      return;
    }

    _subscription = client.messages.listen(
      _handleMessage,
      onError: (_) {
        if (!mounted) return;
        setState(() {
          _phase = RuntimePhase.problem;
          _problem = {
            'title': 'Connection lost',
            'message': 'The runtime connection closed unexpectedly.',
            'severity': 'error',
          };
        });
      },
    );
  }

  void _handleMessage(RuntimeMessage message) {
    switch (message.type) {
      case 'runtime.ready':
        setState(() {
          _phase = RuntimePhase.ready;
          _status = 'Loading UI';
          _detail = 'Waiting for first render';
          _problem = null;
        });
        if (kDebugMode) {
          debugPrint('Conduit runtime.ready received; awaiting first render.');
        }
        return;
      case 'runtime.problem':
        setState(() {
          _phase = RuntimePhase.problem;
          _problem = message.payload;
        });
        return;
      case 'runtime.problem_clear':
        setState(() {
          _phase = RuntimePhase.booting;
          _problem = null;
        });
        return;
    }
  }

  String? _extractArg(List<String> args, String prefix) {
    for (final arg in args) {
      if (arg.startsWith(prefix)) {
        return arg.substring(prefix.length);
      }
    }
    return null;
  }

  Uri _normalizeWsUri(String raw) {
    final trimmed = raw.trim();
    if (trimmed.startsWith('ws://') || trimmed.startsWith('wss://')) {
      return Uri.parse(trimmed);
    }
    if (trimmed.contains('/')) {
      return Uri.parse('ws://$trimmed');
    }
    return Uri.parse('ws://$trimmed/ws');
  }

  @override
  Widget build(BuildContext context) {
    final client = _client;
    final overlay = _buildOverlay();
    if (client == null) {
      return overlay;
    }
    return Stack(
      children: [
        AppRenderer(
          key: ValueKey(client),
          client: client,
          onThemeChanged: widget.onThemeChanged,
          onRootChanged: _handleRootChanged,
        ),
        overlay,
      ],
    );
  }

  Widget _buildOverlay() {
    if (_phase == RuntimePhase.problem) {
      return ErrorHandlerScreen(payload: _problem, onRetry: _boot);
    }
    if (_phase == RuntimePhase.booting || !_hasRoot) {
      return BootupScreen(status: _status, detail: _detail);
    }
    return const SizedBox.shrink();
  }

  void _handleRootChanged(bool hasRoot) {
    if (!mounted || _hasRoot == hasRoot) return;
    setState(() {
      _hasRoot = hasRoot;
      if (hasRoot) {
        _detail = null;
      }
    });
  }
}
