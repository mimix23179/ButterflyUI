import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class ButterflyUIFilePicker extends StatefulWidget {
  final String controlId;
  final String label;
  final bool enabled;
  final bool allowMultiple;
  final bool withData;
  final bool withPath;
  final bool pickDirectory;
  final bool saveFile;
  final bool showSelection;
  final String fileType;
  final List<String> extensions;
  final String? initialDirectory;
  final String? dialogTitle;
  final String? fileName;
  final bool lockParentWindow;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUIFilePicker({
    super.key,
    required this.controlId,
    required this.label,
    required this.enabled,
    required this.allowMultiple,
    required this.withData,
    required this.withPath,
    required this.pickDirectory,
    required this.saveFile,
    required this.showSelection,
    required this.fileType,
    required this.extensions,
    required this.initialDirectory,
    required this.dialogTitle,
    required this.fileName,
    required this.lockParentWindow,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<ButterflyUIFilePicker> createState() => _ButterflyUIFilePickerState();
}

class _ButterflyUIFilePickerState extends State<ButterflyUIFilePicker> {
  bool _busy = false;
  List<Map<String, Object?>> _selectedFiles = const <Map<String, Object?>>[];

  @override
  void initState() {
    super.initState();
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant ButterflyUIFilePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controlId != oldWidget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    super.dispose();
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'pick':
      case 'open':
      case 'pick_files':
        await _pick(modeOverride: 'files');
        return null;
      case 'pick_directory':
        await _pick(modeOverride: 'directory');
        return null;
      case 'save_file':
        await _pick(modeOverride: 'save');
        return null;
      case 'clear':
        if (mounted) {
          setState(() {
            _selectedFiles = const <Map<String, Object?>>[];
          });
        }
        widget.sendEvent(widget.controlId, 'change', {
          'files': const <Map<String, Object?>>[],
          'paths': const <String>[],
          'path': null,
          'count': 0,
          'mode': _mode(),
        });
        return null;
      case 'get_files':
        return _selectedFiles;
      default:
        throw UnsupportedError('Unknown file_picker method: $method');
    }
  }

  String _mode({String? override}) {
    if (override != null && override.isNotEmpty) return override;
    if (widget.saveFile) return 'save';
    if (widget.pickDirectory) return 'directory';
    return 'files';
  }

  String _basename(String path) {
    final normalized = path.replaceAll('\\', '/');
    final index = normalized.lastIndexOf('/');
    if (index < 0 || index >= normalized.length - 1) return normalized;
    return normalized.substring(index + 1);
  }

  FileType _resolveFileType() {
    final raw = widget.fileType.trim().toLowerCase();
    if (widget.extensions.isNotEmpty) return FileType.custom;
    switch (raw) {
      case 'any':
      case 'all':
        return FileType.any;
      case 'media':
        return FileType.media;
      case 'image':
      case 'images':
        return FileType.image;
      case 'video':
      case 'videos':
        return FileType.video;
      case 'audio':
        return FileType.audio;
      case 'custom':
        return FileType.custom;
      default:
        return FileType.any;
    }
  }

  Map<String, Object?> _filePayload(PlatformFile file) {
    final path = widget.withPath ? file.path : null;
    return <String, Object?>{
      'name': file.name,
      'path': path,
      'size': file.size,
      'extension': file.extension,
      'identifier': file.identifier,
      'has_bytes': file.bytes != null,
      'bytes_length': file.bytes?.length,
    };
  }

  Future<void> _pick({String? modeOverride}) async {
    if (_busy || !widget.enabled) return;
    setState(() => _busy = true);
    try {
      final mode = _mode(override: modeOverride);
      if (mode == 'directory') {
        final path = await FilePicker.platform.getDirectoryPath(
          dialogTitle: widget.dialogTitle,
          lockParentWindow: widget.lockParentWindow,
          initialDirectory: widget.initialDirectory,
        );
        if (path == null || path.isEmpty) {
          widget.sendEvent(widget.controlId, 'cancel', {'mode': mode});
          return;
        }
        final item = <String, Object?>{
          'name': _basename(path),
          'path': widget.withPath ? path : null,
          'size': 0,
          'extension': null,
          'identifier': null,
          'has_bytes': false,
          'bytes_length': null,
        };
        _selectedFiles = <Map<String, Object?>>[item];
        final normalizedPath = widget.withPath ? path : null;
        final paths = normalizedPath == null
            ? const <String>[]
            : <String>[normalizedPath];
        widget.sendEvent(widget.controlId, 'change', {
          'files': _selectedFiles,
          'paths': paths,
          'path': normalizedPath,
          'count': 1,
          'mode': mode,
        });
        widget.sendEvent(widget.controlId, 'pick', {
          'files': _selectedFiles,
          'paths': paths,
          'path': normalizedPath,
          'count': 1,
          'mode': mode,
        });
        return;
      }

      if (mode == 'save') {
        final type = _resolveFileType();
        final path = await FilePicker.platform.saveFile(
          dialogTitle: widget.dialogTitle,
          fileName: widget.fileName,
          initialDirectory: widget.initialDirectory,
          type: type,
          allowedExtensions: type == FileType.custom ? widget.extensions : null,
          lockParentWindow: widget.lockParentWindow,
        );
        if (path == null || path.isEmpty) {
          widget.sendEvent(widget.controlId, 'cancel', {'mode': mode});
          return;
        }
        final item = <String, Object?>{
          'name': _basename(path),
          'path': widget.withPath ? path : null,
          'size': 0,
          'extension': null,
          'identifier': null,
          'has_bytes': false,
          'bytes_length': null,
        };
        _selectedFiles = <Map<String, Object?>>[item];
        final normalizedPath = widget.withPath ? path : null;
        final paths = normalizedPath == null
            ? const <String>[]
            : <String>[normalizedPath];
        widget.sendEvent(widget.controlId, 'change', {
          'files': _selectedFiles,
          'paths': paths,
          'path': normalizedPath,
          'count': 1,
          'mode': mode,
        });
        widget.sendEvent(widget.controlId, 'pick', {
          'files': _selectedFiles,
          'paths': paths,
          'path': normalizedPath,
          'count': 1,
          'mode': mode,
        });
        return;
      }

      final type = _resolveFileType();
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: widget.dialogTitle,
        initialDirectory: widget.initialDirectory,
        type: type,
        allowedExtensions: type == FileType.custom ? widget.extensions : null,
        allowMultiple: widget.allowMultiple,
        withData: widget.withData,
        withReadStream: false,
        lockParentWindow: widget.lockParentWindow,
      );
      if (result == null || result.files.isEmpty) {
        widget.sendEvent(widget.controlId, 'cancel', {'mode': mode});
        return;
      }
      final files = result.files
          .map(_filePayload)
          .toList(growable: false)
          .cast<Map<String, Object?>>();
      final paths = files
          .map((entry) => entry['path']?.toString())
          .whereType<String>()
          .where((value) => value.isNotEmpty)
          .toList(growable: false);
      _selectedFiles = files;
      widget.sendEvent(widget.controlId, 'change', {
        'files': files,
        'paths': paths,
        'path': paths.isEmpty ? null : paths.first,
        'count': files.length,
        'mode': mode,
      });
      widget.sendEvent(widget.controlId, 'pick', {
        'files': files,
        'paths': paths,
        'path': paths.isEmpty ? null : paths.first,
        'count': files.length,
        'mode': mode,
      });
    } catch (error) {
      widget.sendEvent(widget.controlId, 'error', {
        'message': error.toString(),
        'mode': _mode(override: modeOverride),
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = _busy
        ? 'Opening...'
        : (_selectedFiles.isEmpty
              ? ''
              : (_selectedFiles.length == 1
                    ? (_selectedFiles.first['name']?.toString() ?? '')
                    : '${_selectedFiles.length} selected'));
    final effectiveLabel = widget.label.isEmpty ? 'Pick Files' : widget.label;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FilledButton.tonalIcon(
          onPressed: widget.enabled && !_busy ? () => _pick() : null,
          icon: const Icon(Icons.upload_file_rounded, size: 16),
          label: Text(effectiveLabel),
        ),
        if (widget.showSelection && status.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              status,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
      ],
    );
  }
}

Widget buildFilePickerControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final extensionsRaw = props['extensions'] ?? props['allowed_extensions'];
  final extensions = <String>[];
  if (extensionsRaw is List) {
    for (final item in extensionsRaw) {
      final value = item?.toString().trim() ?? '';
      if (value.isNotEmpty) extensions.add(value);
    }
  } else if (extensionsRaw is String && extensionsRaw.trim().isNotEmpty) {
    extensions.addAll(
      extensionsRaw
          .split(',')
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty),
    );
  }
  final fileType = (props['file_type'] ?? props['type'] ?? 'any').toString();
  final mode = (props['mode'] ?? '').toString().trim().toLowerCase();
  final pickDirectory =
      mode == 'directory' ||
      fileType.toLowerCase() == 'directory' ||
      fileType.toLowerCase() == 'folder' ||
      props['pick_directory'] == true ||
      props['directory'] == true;
  final saveFile = mode == 'save' || props['save_file'] == true;

  return ButterflyUIFilePicker(
    controlId: controlId,
    label: (props['label'] ?? props['text'] ?? 'Pick Files').toString(),
    enabled: props['enabled'] == null ? true : (props['enabled'] == true),
    allowMultiple: props['multiple'] == true || props['allow_multiple'] == true,
    withData: props['with_data'] == true,
    withPath: props['with_path'] == null ? true : (props['with_path'] == true),
    pickDirectory: pickDirectory,
    saveFile: saveFile,
    showSelection: props['show_selection'] == null
        ? true
        : (props['show_selection'] == true),
    fileType: fileType,
    extensions: extensions,
    initialDirectory: props['initial_directory']?.toString(),
    dialogTitle: props['dialog_title']?.toString(),
    fileName: props['file_name']?.toString(),
    lockParentWindow: props['lock_parent_window'] == true,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}
