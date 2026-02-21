import 'dart:async';

import 'package:flutter/material.dart';

import '../animation/animation_spec.dart';
import 'notification.dart';
import 'toast_notification.dart';

class _HostItem {
  final NotificationPayload payload;
  _HostItem(this.payload);
}

class NotificationManager {
  NotificationManager._();

  static final NotificationManager instance = NotificationManager._();

  // Export a global overlay key that NotificationRoot will use.
  static final GlobalKey<OverlayState> overlayKey = GlobalKey<OverlayState>();

  final List<_HostItem> _items = [];
  final Map<String, Timer> _timers = {};

  OverlayEntry? _hostEntry;
  _NotificationHostState? _hostState;

  /// Maximum number of notifications to show stacked at once.
  int maxStack = 3;

  void _ensureHost() {
    final overlay = overlayKey.currentState;
    if (overlay == null) return;
    if (_hostEntry != null) return;
    _hostEntry = OverlayEntry(builder: (context) {
      return _NotificationHost(manager: this);
    });
    overlay.insert(_hostEntry!);
  }

  /// Show a toast notification.
  void showToast(NotificationPayload payload) {
    if (payload.message.trim().isEmpty) return;

    final overlay = overlayKey.currentState;
    if (overlay == null) {
      // Can't show immediately: schedule a short retry after next frame.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final after = overlayKey.currentState;
        if (after != null) showToast(payload);
      });
      return;
    }

    _ensureHost();

    // If too many active notifications, replace the oldest
    if (_items.length >= maxStack) {
      _removeOldest(reason: 'replace');
    }

    _items.add(_HostItem(payload));
    _hostState?._refreshItems(_items);

    final dur = payload.durationMs <= 0 ? 5000 : payload.durationMs;
    final t = Timer(Duration(milliseconds: dur), () {
      dismiss(payload.controlId, reason: 'timeout', emitClose: true);
    });
    _timers[payload.controlId] = t;
  }

  void _removeOldest({required String reason}) {
    if (_items.isEmpty) return;
    final oldest = _items.removeAt(0);
    _timers.remove(oldest.payload.controlId)?.cancel();
    _hostState?._refreshItems(_items);
    try {
      oldest.payload.sendEvent(oldest.payload.controlId, 'close', {'reason': reason});
    } catch (_) {}
  }

  void dismiss(String controlId, {required String reason, bool emitClose = true}) {
    // Ask host to play exit animation; it will call back to _finalizeRemoval when done.
    final idx = _items.indexWhere((i) => i.payload.controlId == controlId);
    if (idx == -1) return;
    _timers.remove(controlId)?.cancel();
    _hostState?._hideById(controlId, reason: reason, emitClose: emitClose);
  }

  void _finalizeRemoval(String controlId, {required String reason, required bool emitClose}) {
    final idx = _items.indexWhere((i) => i.payload.controlId == controlId);
    if (idx == -1) return;
    final removed = _items.removeAt(idx);
    _hostState?._refreshItems(_items);
    if (emitClose) {
      try {
        removed.payload.sendEvent(removed.payload.controlId, 'close', {'reason': reason});
      } catch (_) {}
    }
  }

  // Internal hooks for _NotificationHost to register itself
  void _registerHostState(_NotificationHostState state) {
    _hostState = state;
    // Push current items to host
    _hostState?._refreshItems(_items);
  }

  void _unregisterHostState(_NotificationHostState state) {
    if (_hostState == state) _hostState = null;
    // Keep internal items list; host will be re-created on next showToast
    if (_items.isEmpty) {
      _hostEntry?.remove();
      _hostEntry = null;
    }
  }
}

class _NotificationHost extends StatefulWidget {
  final NotificationManager manager;
  const _NotificationHost({required this.manager});

  @override
  _NotificationHostState createState() => _NotificationHostState();
}

class _NotificationHostState extends State<_NotificationHost> {
  List<_HostItem> _items = [];
  static const double _itemHeight = 76.0;
  static const double _topInset = 12.0;

  @override
  void initState() {
    super.initState();
    widget.manager._registerHostState(this);
  }

  @override
  void dispose() {
    widget.manager._unregisterHostState(this);
    super.dispose();
  }

  void _refreshItems(List<_HostItem> items) {
    setState(() {
      _items = List<_HostItem>.from(items);
    });
  }

  void _hideById(String id, {required String reason, required bool emitClose}) {
    final idx = _items.indexWhere((i) => i.payload.controlId == id);
    if (idx == -1) return;
    // Tell the item to play exit; when done it will notify manager._finalizeRemoval
    final itemKey = _itemKeys[id];
    itemKey?.currentState?.playExit(reason: reason, emitClose: emitClose);
  }

  final Map<String, GlobalKey<_NotificationItemState>> _itemKeys = {};

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: IgnorePointer(
        ignoring: false,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: _topInset, right: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(_items.length, (index) {
                final item = _items[index];
                final key = _itemKeys.putIfAbsent(item.payload.controlId, () => GlobalKey<_NotificationItemState>());
                return Padding(
                  key: ValueKey(item.payload.controlId),
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: _NotificationItem(
                    key: key,
                    payload: item.payload,
                    onAction: () {
                      item.payload.sendEvent(item.payload.controlId, 'action', {});
                      // Dismiss on action
                      playItemExit(item.payload.controlId, reason: 'action', emitClose: true);
                    },
                    onExited: (reason, emitClose) {
                      widget.manager._finalizeRemoval(item.payload.controlId, reason: reason, emitClose: emitClose);
                      // cleanup key
                      _itemKeys.remove(item.payload.controlId);
                    },
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  void playItemExit(String id, {required String reason, required bool emitClose}) {
    final key = _itemKeys[id];
    key?.currentState?.playExit(reason: reason, emitClose: emitClose);
  }
}

class _NotificationItem extends StatefulWidget {
  final NotificationPayload payload;
  final VoidCallback onAction;
  final void Function(String reason, bool emitClose) onExited;

  const _NotificationItem({super.key, required this.payload, required this.onAction, required this.onExited});

  @override
  _NotificationItemState createState() => _NotificationItemState();
}

class _NotificationItemState extends State<_NotificationItem> {
  bool _visible = true;
  String? _pendingExitReason;
  bool? _pendingEmitClose;

  void playExit({required String reason, required bool emitClose}) {
    if (!_visible) return; // already hiding
    _pendingExitReason = reason;
    _pendingEmitClose = emitClose;
    setState(() => _visible = false);
  }

  @override
  Widget build(BuildContext context) {
    final instant = widget.payload.instant ?? false;
    final animSpec = widget.payload.animation;
    final content = ToastNotificationWidget(
      data: widget.payload,
      onClose: () => playExit(reason: 'dismiss', emitClose: true),
      onAction: widget.onAction,
    );
    return SizedBox(
      width: 340,
      child: Material(
        color: Colors.transparent,
        child: AnimationSpec.fromJson(animSpec).wrap(
          content,
          visible: _visible,
          onExitCompleted: () {
            widget.onExited(_pendingExitReason ?? 'dismiss', _pendingEmitClose ?? true);
          },
        ),
      ),
    );
  }
}
