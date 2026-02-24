import 'package:logging/logging.dart';

import '../../studio_contract.dart';

class StudioCommandEntry {
  StudioCommandEntry({
    required this.commandId,
    required this.label,
    required this.kind,
    required this.payload,
    required this.before,
    required this.after,
    required this.timestampMs,
  });

  final String commandId;
  final String label;
  final String kind;
  final Map<String, Object?> payload;
  final Map<String, Object?> before;
  final Map<String, Object?> after;
  final int timestampMs;

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'command_id': commandId,
      'label': label,
      'kind': kind,
      'payload': payload,
      'before': before,
      'after': after,
      'timestamp_ms': timestampMs,
    };
  }
}

class StudioCommandService {
  StudioCommandService({int historyLimit = 240})
    : _historyLimit = historyLimit.clamp(40, 1000);

  final Logger _logger = Logger('StudioCommandService');
  final List<StudioCommandEntry> _undo = <StudioCommandEntry>[];
  final List<StudioCommandEntry> _redo = <StudioCommandEntry>[];
  final List<Map<String, Object?>> _history = <Map<String, Object?>>[];
  final int _historyLimit;

  int _sequence = 1;
  int _transactionDepth = 0;
  String? _activeTransactionLabel;

  int get undoDepth => _undo.length;
  int get redoDepth => _redo.length;

  List<Map<String, Object?>> get history =>
      List<Map<String, Object?>>.unmodifiable(_history);

  void beginTransaction(String label) {
    _transactionDepth += 1;
    _activeTransactionLabel ??= label;
    _appendHistory(
      kind: 'transaction',
      label: 'begin:$label',
      payload: <String, Object?>{'depth': _transactionDepth},
    );
  }

  void endTransaction() {
    if (_transactionDepth <= 0) return;
    final label = _activeTransactionLabel ?? 'transaction';
    _transactionDepth -= 1;
    if (_transactionDepth == 0) {
      _activeTransactionLabel = null;
    }
    _appendHistory(
      kind: 'transaction',
      label: 'end:$label',
      payload: <String, Object?>{'depth': _transactionDepth},
    );
  }

  StudioCommandEntry push({
    required String label,
    required String kind,
    required Map<String, Object?> payload,
    required Map<String, Object?> before,
    required Map<String, Object?> after,
  }) {
    final commandId = 'cmd_${_sequence.toString().padLeft(6, '0')}';
    _sequence += 1;
    final entry = StudioCommandEntry(
      commandId: commandId,
      label: _activeTransactionLabel == null
          ? label
          : '${_activeTransactionLabel!}::$label',
      kind: kind,
      payload: payload,
      before: deepCopyStudioMap(before),
      after: deepCopyStudioMap(after),
      timestampMs: DateTime.now().millisecondsSinceEpoch,
    );
    _undo.add(entry);
    _redo.clear();
    _trimStacks();
    _appendHistory(
      kind: kind,
      label: entry.label,
      payload: <String, Object?>{'command_id': commandId, ...payload},
    );
    _logger.fine('push ${entry.commandId} ${entry.label}');
    return entry;
  }

  StudioCommandEntry? undo() {
    if (_undo.isEmpty) return null;
    final entry = _undo.removeLast();
    _redo.add(entry);
    _trimStacks();
    _appendHistory(
      kind: 'change',
      label: 'undo:${entry.label}',
      payload: <String, Object?>{'command_id': entry.commandId},
    );
    _logger.fine('undo ${entry.commandId}');
    return entry;
  }

  StudioCommandEntry? redo() {
    if (_redo.isEmpty) return null;
    final entry = _redo.removeLast();
    _undo.add(entry);
    _trimStacks();
    _appendHistory(
      kind: 'change',
      label: 'redo:${entry.label}',
      payload: <String, Object?>{'command_id': entry.commandId},
    );
    _logger.fine('redo ${entry.commandId}');
    return entry;
  }

  void clear() {
    _undo.clear();
    _redo.clear();
    _history.clear();
    _appendHistory(
      kind: 'change',
      label: 'history_cleared',
      payload: const <String, Object?>{},
    );
  }

  void appendAudit({
    required String kind,
    required String label,
    required Map<String, Object?> payload,
  }) {
    _appendHistory(kind: kind, label: label, payload: payload);
  }

  void _appendHistory({
    required String kind,
    required String label,
    required Map<String, Object?> payload,
  }) {
    _history.add(<String, Object?>{
      'timestamp_ms': DateTime.now().millisecondsSinceEpoch,
      'kind': kind,
      'label': label,
      'payload': payload,
      'undo_depth': undoDepth,
      'redo_depth': redoDepth,
    });
    while (_history.length > _historyLimit) {
      _history.removeAt(0);
    }
  }

  void _trimStacks() {
    while (_undo.length > _historyLimit) {
      _undo.removeAt(0);
    }
    while (_redo.length > _historyLimit) {
      _redo.removeAt(0);
    }
  }
}
