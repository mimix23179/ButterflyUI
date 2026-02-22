import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class ButterflyUITerminalProcessBridge extends StatefulWidget {
  final String controlId;
  final String? command;
  final List<String> args;
  final String cwd;
  final Map<String, String> env;
  final bool autoStart;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUITerminalProcessBridge({
    super.key,
    required this.controlId,
    required this.command,
    required this.args,
    required this.cwd,
    required this.env,
    required this.autoStart,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<ButterflyUITerminalProcessBridge> createState() =>
      _ButterflyUITerminalProcessBridgeState();
}

class _ButterflyUITerminalProcessBridgeState
    extends State<ButterflyUITerminalProcessBridge> {
  Process? _process;
  StreamSubscription<String>? _stdoutSub;
  StreamSubscription<String>? _stderrSub;

  @override
  void initState() {
    super.initState();
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    if (widget.autoStart) {
      unawaited(_startProcess(widget.command, widget.args));
    }
  }

  @override
  void didUpdateWidget(covariant ButterflyUITerminalProcessBridge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    unawaited(_stopProcess());
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'start':
        final command = args['command']?.toString() ?? widget.command;
        final rawArgs = args['args'];
        final commandArgs = rawArgs is List
            ? rawArgs.map((entry) => entry.toString()).toList(growable: false)
            : widget.args;
        await _startProcess(command, commandArgs);
        return null;
      case 'stop':
      case 'kill':
        await _stopProcess();
        return null;
      case 'restart':
        {
          final command = args['command']?.toString() ?? widget.command;
          final rawArgs = args['args'];
          final commandArgs = rawArgs is List
              ? rawArgs.map((entry) => entry.toString()).toList(growable: false)
              : widget.args;
          await _stopProcess();
          await _startProcess(command, commandArgs);
          return null;
        }
      case 'write_stdin':
        final input = args['input']?.toString() ?? '';
        if (_process != null && input.isNotEmpty) {
          _process!.stdin.write(input);
          if (args['newline'] != false) {
            _process!.stdin.write('\n');
          }
        }
        return null;
      case 'is_running':
        return _process != null;
      default:
        throw UnsupportedError('Unknown terminal_process_bridge method: $method');
    }
  }

  Future<void> _startProcess(String? command, List<String> args) async {
    if (command == null || command.trim().isEmpty) return;
    await _stopProcess();

    try {
      final process = await Process.start(
        command,
        args,
        workingDirectory: widget.cwd,
        environment: widget.env,
        runInShell: true,
      );
      _process = process;

      widget.sendEvent(widget.controlId, 'process_started', {
        'command': command,
        'args': args,
        'cwd': widget.cwd,
        'pid': process.pid,
      });

      _stdoutSub = process.stdout
          .transform(utf8.decoder)
          .listen((chunk) {
            widget.sendEvent(widget.controlId, 'stdout', {'data': chunk});
          });
      _stderrSub = process.stderr
          .transform(utf8.decoder)
          .listen((chunk) {
            widget.sendEvent(widget.controlId, 'stderr', {'data': chunk});
          });

      unawaited(
        process.exitCode.then((code) {
          widget.sendEvent(widget.controlId, 'process_exit', {'exit_code': code});
          _process = null;
        }),
      );
    } catch (error) {
      widget.sendEvent(widget.controlId, 'process_error', {
        'error': error.toString(),
        'command': command,
      });
    }
  }

  Future<void> _stopProcess() async {
    await _stdoutSub?.cancel();
    await _stderrSub?.cancel();
    _stdoutSub = null;
    _stderrSub = null;
    final process = _process;
    _process = null;
    if (process != null) {
      process.kill(ProcessSignal.sigterm);
      widget.sendEvent(widget.controlId, 'process_stopped', {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

Widget buildTerminalProcessBridgeControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final env = <String, String>{};
  final envRaw = props['env'];
  if (envRaw is Map) {
    for (final entry in envRaw.entries) {
      env[entry.key.toString()] = entry.value?.toString() ?? '';
    }
  }

  final argsRaw = props['args'];
  final args = argsRaw is List
      ? argsRaw.map((entry) => entry.toString()).toList(growable: false)
      : const <String>[];

  return ButterflyUITerminalProcessBridge(
    controlId: controlId,
    command: props['command']?.toString(),
    args: args,
    cwd: (props['cwd'] ?? Directory.current.path).toString(),
    env: env,
    autoStart: props['auto_start'] == true,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}
