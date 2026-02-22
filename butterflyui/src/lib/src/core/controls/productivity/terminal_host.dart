import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class _TerminalInstance {
  final String id;
  String title;
  String cwd;
  final List<String> terminalLines;

  _TerminalInstance({
    required this.id,
    required this.title,
    required this.cwd,
    required this.terminalLines,
  });
}

class ButterflyUITerminalHost extends StatefulWidget {
  final String controlId;
  final String workspacePath;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUITerminalHost({
    super.key,
    required this.controlId,
    required this.workspacePath,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<ButterflyUITerminalHost> createState() => _ButterflyUITerminalHostState();
}

class _ButterflyUITerminalHostState extends State<ButterflyUITerminalHost>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 2, vsync: this);
  final TextEditingController _commandController = TextEditingController();
  final ScrollController _terminalScroll = ScrollController();
  final ScrollController _outputScroll = ScrollController();

  final List<String> _outputLines = <String>[];
  final List<_TerminalInstance> _instances = <_TerminalInstance>[];
  String _activeInstanceId = 'terminal_1';

  _TerminalInstance get _activeInstance {
    return _instances.firstWhere(
      (instance) => instance.id == _activeInstanceId,
      orElse: () => _instances.first,
    );
  }

  @override
  void initState() {
    super.initState();
    _instances.add(
      _TerminalInstance(
        id: 'terminal_1',
        title: 'Terminal 1',
        cwd: widget.workspacePath,
        terminalLines: <String>['[${widget.workspacePath} >]'],
      ),
    );
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant ButterflyUITerminalHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    _tabController.dispose();
    _commandController.dispose();
    _terminalScroll.dispose();
    _outputScroll.dispose();
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'new_instance':
        {
          final id = args['id']?.toString() ?? 'terminal_${_instances.length + 1}';
          final title = args['title']?.toString() ?? 'Terminal ${_instances.length + 1}';
          final cwd = args['cwd']?.toString() ?? widget.workspacePath;
          setState(() {
            _instances.add(
              _TerminalInstance(
                id: id,
                title: title,
                cwd: cwd,
                terminalLines: <String>['[$cwd >]'],
              ),
            );
            _activeInstanceId = id;
          });
          widget.sendEvent(widget.controlId, 'instance_created', {'id': id, 'cwd': cwd});
          return id;
        }
      case 'close_instance':
        {
          if (_instances.length <= 1) return null;
          final id = args['id']?.toString() ?? _activeInstanceId;
          setState(() {
            _instances.removeWhere((instance) => instance.id == id);
            if (!_instances.any((instance) => instance.id == _activeInstanceId)) {
              _activeInstanceId = _instances.first.id;
            }
          });
          widget.sendEvent(widget.controlId, 'instance_closed', {'id': id});
          return null;
        }
      case 'set_active':
        {
          final id = args['id']?.toString() ?? _activeInstanceId;
          if (_instances.any((instance) => instance.id == id)) {
            setState(() {
              _activeInstanceId = id;
            });
            widget.sendEvent(widget.controlId, 'active_changed', {'id': id});
          }
          return null;
        }
      case 'run_command':
        {
          final command = args['command']?.toString() ?? '';
          if (command.trim().isEmpty) return null;
          await _runCommand(command, background: args['background'] == true);
          return null;
        }
      case 'append_output':
        {
          final text = args['text']?.toString() ?? '';
          if (text.isNotEmpty) {
            setState(() {
              _outputLines.add(text);
            });
          }
          return null;
        }
      case 'get_instances':
        return _instances
            .map((instance) => {
                  'id': instance.id,
                  'title': instance.title,
                  'cwd': instance.cwd,
                })
            .toList(growable: false);
      default:
        throw UnsupportedError('Unknown terminal_host method: $method');
    }
  }

  Future<void> _runCommand(String command, {required bool background}) async {
    final instance = _activeInstance;
    final prompt = '[${instance.cwd} >]';

    setState(() {
      instance.terminalLines.add('$prompt $command');
      if (background) {
        _outputLines.add('$prompt $command');
      }
    });

    try {
      final result = await Process.run(
        command,
        const <String>[],
        runInShell: true,
        workingDirectory: instance.cwd,
      );

      final stdoutText = (result.stdout ?? '').toString();
      final stderrText = (result.stderr ?? '').toString();
      final exitCode = result.exitCode;

      final lines = <String>[];
      if (stdoutText.trim().isNotEmpty) {
        lines.addAll(const LineSplitter().convert(stdoutText));
      }
      if (stderrText.trim().isNotEmpty) {
        lines.addAll(const LineSplitter().convert(stderrText));
      }
      lines.add('[exit $exitCode]');

      setState(() {
        instance.terminalLines.addAll(lines);
        if (background) {
          _outputLines.addAll(lines);
        }
      });

      widget.sendEvent(widget.controlId, 'command_finished', {
        'command': command,
        'exit_code': exitCode,
        'stdout': stdoutText,
        'stderr': stderrText,
        'instance_id': instance.id,
      });
    } catch (error) {
      final line = '[error] ${error.toString()}';
      setState(() {
        instance.terminalLines.add(line);
        if (background) {
          _outputLines.add(line);
        }
      });
      widget.sendEvent(widget.controlId, 'command_error', {
        'command': command,
        'error': error.toString(),
        'instance_id': instance.id,
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_terminalScroll.hasClients) {
        _terminalScroll.jumpTo(_terminalScroll.position.maxScrollExtent);
      }
      if (_outputScroll.hasClients) {
        _outputScroll.jumpTo(_outputScroll.position.maxScrollExtent);
      }
    });
  }

  Widget _buildInstanceRail() {
    return SizedBox(
      width: 170,
      child: Column(
        children: [
          ListTile(
            dense: true,
            title: const Text('Instances'),
            trailing: IconButton(
              icon: const Icon(Icons.add, size: 18),
              onPressed: () => _handleInvoke('new_instance', const <String, Object?>{}),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _instances.length,
              itemBuilder: (context, index) {
                final instance = _instances[index];
                final active = instance.id == _activeInstanceId;
                return ListTile(
                  dense: true,
                  selected: active,
                  title: Text(instance.title, overflow: TextOverflow.ellipsis),
                  onTap: () => _handleInvoke('set_active', {'id': instance.id}),
                  trailing: _instances.length <= 1
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close, size: 16),
                          onPressed: () => _handleInvoke('close_instance', {'id': instance.id}),
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutputTab() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        controller: _outputScroll,
        padding: const EdgeInsets.all(10),
        itemCount: _outputLines.length,
        itemBuilder: (context, index) => Text(
          _outputLines[index],
          style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildTerminalTab() {
    final instance = _activeInstance;
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              controller: _terminalScroll,
              padding: const EdgeInsets.all(10),
              itemCount: instance.terminalLines.length,
              itemBuilder: (context, index) => Text(
                instance.terminalLines[index],
                style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _commandController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: '[${instance.cwd} >]',
          ),
          onSubmitted: (value) async {
            final command = value.trim();
            if (command.isEmpty) return;
            _commandController.clear();
            await _runCommand(command, background: false);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Output'),
                  Tab(text: 'Terminal'),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOutputTab(),
                    _buildTerminalTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        _buildInstanceRail(),
      ],
    );
  }
}

Widget buildTerminalHostControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return ButterflyUITerminalHost(
    controlId: controlId,
    workspacePath: (props['workspace_path'] ?? Directory.current.path).toString(),
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}
