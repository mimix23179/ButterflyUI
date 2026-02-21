import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';

import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class _ShortcutIntent extends Intent {
  final String id;
  const _ShortcutIntent(this.id);
}

class ButterflyUIShortcutMap extends StatefulWidget {
  final String controlId;
  final Widget child;
  final List<Map<String, Object?>> shortcuts;
  final bool enabled;
  final bool useGlobalHotkeys;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUIShortcutMap({
    super.key,
    required this.controlId,
    required this.child,
    required this.shortcuts,
    required this.enabled,
    required this.useGlobalHotkeys,
    required this.sendEvent,
  });

  @override
  State<ButterflyUIShortcutMap> createState() => _ButterflyUIShortcutMapState();
}

class _ButterflyUIShortcutMapState extends State<ButterflyUIShortcutMap> {
  final Map<String, HotKey> _registered = {};

  LogicalKeySet? _parseKeySet(String raw) {
    final tokens = raw.toLowerCase().replaceAll(' ', '').split('+');
    final keys = <LogicalKeyboardKey>[];
    for (final token in tokens) {
      switch (token) {
        case 'ctrl':
        case 'control':
          keys.add(LogicalKeyboardKey.control);
          break;
        case 'shift':
          keys.add(LogicalKeyboardKey.shift);
          break;
        case 'alt':
          keys.add(LogicalKeyboardKey.alt);
          break;
        case 'meta':
        case 'cmd':
        case 'command':
          keys.add(LogicalKeyboardKey.meta);
          break;
        default:
          final key = _keyFromToken(token);
          if (key != null) {
            keys.add(key);
          }
          break;
      }
    }
    if (keys.isEmpty) return null;
    return LogicalKeySet.fromSet(keys.toSet());
  }

  LogicalKeyboardKey? _keyFromToken(String token) {
    if (token.length == 1) {
      switch (token) {
        case 'a':
          return LogicalKeyboardKey.keyA;
        case 'b':
          return LogicalKeyboardKey.keyB;
        case 'c':
          return LogicalKeyboardKey.keyC;
        case 'd':
          return LogicalKeyboardKey.keyD;
        case 'e':
          return LogicalKeyboardKey.keyE;
        case 'f':
          return LogicalKeyboardKey.keyF;
        case 'g':
          return LogicalKeyboardKey.keyG;
        case 'h':
          return LogicalKeyboardKey.keyH;
        case 'i':
          return LogicalKeyboardKey.keyI;
        case 'j':
          return LogicalKeyboardKey.keyJ;
        case 'k':
          return LogicalKeyboardKey.keyK;
        case 'l':
          return LogicalKeyboardKey.keyL;
        case 'm':
          return LogicalKeyboardKey.keyM;
        case 'n':
          return LogicalKeyboardKey.keyN;
        case 'o':
          return LogicalKeyboardKey.keyO;
        case 'p':
          return LogicalKeyboardKey.keyP;
        case 'q':
          return LogicalKeyboardKey.keyQ;
        case 'r':
          return LogicalKeyboardKey.keyR;
        case 's':
          return LogicalKeyboardKey.keyS;
        case 't':
          return LogicalKeyboardKey.keyT;
        case 'u':
          return LogicalKeyboardKey.keyU;
        case 'v':
          return LogicalKeyboardKey.keyV;
        case 'w':
          return LogicalKeyboardKey.keyW;
        case 'x':
          return LogicalKeyboardKey.keyX;
        case 'y':
          return LogicalKeyboardKey.keyY;
        case 'z':
          return LogicalKeyboardKey.keyZ;
        case '0':
          return LogicalKeyboardKey.digit0;
        case '1':
          return LogicalKeyboardKey.digit1;
        case '2':
          return LogicalKeyboardKey.digit2;
        case '3':
          return LogicalKeyboardKey.digit3;
        case '4':
          return LogicalKeyboardKey.digit4;
        case '5':
          return LogicalKeyboardKey.digit5;
        case '6':
          return LogicalKeyboardKey.digit6;
        case '7':
          return LogicalKeyboardKey.digit7;
        case '8':
          return LogicalKeyboardKey.digit8;
        case '9':
          return LogicalKeyboardKey.digit9;
      }
    }
    switch (token) {
      case 'enter':
        return LogicalKeyboardKey.enter;
      case 'escape':
      case 'esc':
        return LogicalKeyboardKey.escape;
      case 'tab':
        return LogicalKeyboardKey.tab;
      case 'space':
        return LogicalKeyboardKey.space;
      case 'backspace':
        return LogicalKeyboardKey.backspace;
      case 'delete':
        return LogicalKeyboardKey.delete;
      case 'up':
        return LogicalKeyboardKey.arrowUp;
      case 'down':
        return LogicalKeyboardKey.arrowDown;
      case 'left':
        return LogicalKeyboardKey.arrowLeft;
      case 'right':
        return LogicalKeyboardKey.arrowRight;
      case 'home':
        return LogicalKeyboardKey.home;
      case 'end':
        return LogicalKeyboardKey.end;
      case 'pageup':
        return LogicalKeyboardKey.pageUp;
      case 'pagedown':
        return LogicalKeyboardKey.pageDown;
      case 'f1':
        return LogicalKeyboardKey.f1;
      case 'f2':
        return LogicalKeyboardKey.f2;
      case 'f3':
        return LogicalKeyboardKey.f3;
      case 'f4':
        return LogicalKeyboardKey.f4;
      case 'f5':
        return LogicalKeyboardKey.f5;
      case 'f6':
        return LogicalKeyboardKey.f6;
      case 'f7':
        return LogicalKeyboardKey.f7;
      case 'f8':
        return LogicalKeyboardKey.f8;
      case 'f9':
        return LogicalKeyboardKey.f9;
      case 'f10':
        return LogicalKeyboardKey.f10;
      case 'f11':
        return LogicalKeyboardKey.f11;
      case 'f12':
        return LogicalKeyboardKey.f12;
    }
    return null;
  }

  PhysicalKeyboardKey? _physicalKeyFromToken(String token) {
    if (token.length == 1) {
      switch (token) {
        case 'a':
          return PhysicalKeyboardKey.keyA;
        case 'b':
          return PhysicalKeyboardKey.keyB;
        case 'c':
          return PhysicalKeyboardKey.keyC;
        case 'd':
          return PhysicalKeyboardKey.keyD;
        case 'e':
          return PhysicalKeyboardKey.keyE;
        case 'f':
          return PhysicalKeyboardKey.keyF;
        case 'g':
          return PhysicalKeyboardKey.keyG;
        case 'h':
          return PhysicalKeyboardKey.keyH;
        case 'i':
          return PhysicalKeyboardKey.keyI;
        case 'j':
          return PhysicalKeyboardKey.keyJ;
        case 'k':
          return PhysicalKeyboardKey.keyK;
        case 'l':
          return PhysicalKeyboardKey.keyL;
        case 'm':
          return PhysicalKeyboardKey.keyM;
        case 'n':
          return PhysicalKeyboardKey.keyN;
        case 'o':
          return PhysicalKeyboardKey.keyO;
        case 'p':
          return PhysicalKeyboardKey.keyP;
        case 'q':
          return PhysicalKeyboardKey.keyQ;
        case 'r':
          return PhysicalKeyboardKey.keyR;
        case 's':
          return PhysicalKeyboardKey.keyS;
        case 't':
          return PhysicalKeyboardKey.keyT;
        case 'u':
          return PhysicalKeyboardKey.keyU;
        case 'v':
          return PhysicalKeyboardKey.keyV;
        case 'w':
          return PhysicalKeyboardKey.keyW;
        case 'x':
          return PhysicalKeyboardKey.keyX;
        case 'y':
          return PhysicalKeyboardKey.keyY;
        case 'z':
          return PhysicalKeyboardKey.keyZ;
        case '0':
          return PhysicalKeyboardKey.digit0;
        case '1':
          return PhysicalKeyboardKey.digit1;
        case '2':
          return PhysicalKeyboardKey.digit2;
        case '3':
          return PhysicalKeyboardKey.digit3;
        case '4':
          return PhysicalKeyboardKey.digit4;
        case '5':
          return PhysicalKeyboardKey.digit5;
        case '6':
          return PhysicalKeyboardKey.digit6;
        case '7':
          return PhysicalKeyboardKey.digit7;
        case '8':
          return PhysicalKeyboardKey.digit8;
        case '9':
          return PhysicalKeyboardKey.digit9;
      }
    }
    switch (token) {
      case 'enter':
        return PhysicalKeyboardKey.enter;
      case 'escape':
      case 'esc':
        return PhysicalKeyboardKey.escape;
      case 'tab':
        return PhysicalKeyboardKey.tab;
      case 'space':
        return PhysicalKeyboardKey.space;
      case 'backspace':
        return PhysicalKeyboardKey.backspace;
      case 'delete':
        return PhysicalKeyboardKey.delete;
      case 'up':
        return PhysicalKeyboardKey.arrowUp;
      case 'down':
        return PhysicalKeyboardKey.arrowDown;
      case 'left':
        return PhysicalKeyboardKey.arrowLeft;
      case 'right':
        return PhysicalKeyboardKey.arrowRight;
      case 'home':
        return PhysicalKeyboardKey.home;
      case 'end':
        return PhysicalKeyboardKey.end;
      case 'pageup':
        return PhysicalKeyboardKey.pageUp;
      case 'pagedown':
        return PhysicalKeyboardKey.pageDown;
      case 'f1':
        return PhysicalKeyboardKey.f1;
      case 'f2':
        return PhysicalKeyboardKey.f2;
      case 'f3':
        return PhysicalKeyboardKey.f3;
      case 'f4':
        return PhysicalKeyboardKey.f4;
      case 'f5':
        return PhysicalKeyboardKey.f5;
      case 'f6':
        return PhysicalKeyboardKey.f6;
      case 'f7':
        return PhysicalKeyboardKey.f7;
      case 'f8':
        return PhysicalKeyboardKey.f8;
      case 'f9':
        return PhysicalKeyboardKey.f9;
      case 'f10':
        return PhysicalKeyboardKey.f10;
      case 'f11':
        return PhysicalKeyboardKey.f11;
      case 'f12':
        return PhysicalKeyboardKey.f12;
    }
    return null;
  }

  HotKey? _parseHotKey(String raw) {
    final tokens = raw.toLowerCase().replaceAll(' ', '').split('+');
    final modifiers = <HotKeyModifier>[];
    PhysicalKeyboardKey? physicalKey;
    for (final token in tokens) {
      switch (token) {
        case 'ctrl':
        case 'control':
          modifiers.add(HotKeyModifier.control);
          break;
        case 'shift':
          modifiers.add(HotKeyModifier.shift);
          break;
        case 'alt':
          modifiers.add(HotKeyModifier.alt);
          break;
        case 'meta':
        case 'cmd':
        case 'command':
          modifiers.add(HotKeyModifier.meta);
          break;
        default:
          physicalKey = _physicalKeyFromToken(token);
          break;
      }
    }
    if (physicalKey == null) return null;
    return HotKey(key: physicalKey, modifiers: modifiers);
  }

  @override
  void initState() {
    super.initState();
    if (widget.useGlobalHotkeys) {
      _registerGlobalHotkeys();
    }
  }

  @override
  void didUpdateWidget(covariant ButterflyUIShortcutMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.useGlobalHotkeys != widget.useGlobalHotkeys ||
        oldWidget.shortcuts != widget.shortcuts) {
      _clearGlobalHotkeys();
      if (widget.useGlobalHotkeys) {
        _registerGlobalHotkeys();
      }
    }
  }

  @override
  void dispose() {
    _clearGlobalHotkeys();
    super.dispose();
  }

  Future<void> _registerGlobalHotkeys() async {
    for (final shortcut in widget.shortcuts) {
      final id = shortcut['id']?.toString() ?? shortcut['key']?.toString();
      final keyCombo = shortcut['key']?.toString();
      if (id == null || keyCombo == null) continue;
      final hotKey = _parseHotKey(keyCombo);
      if (hotKey == null) continue;
      await hotKeyManager.register(
        hotKey,
        keyDownHandler: (_) {
          if (!widget.enabled) return;
          widget.sendEvent(widget.controlId, 'shortcut', {'id': id});
        },
      );
      _registered[id] = hotKey;
    }
  }

  Future<void> _clearGlobalHotkeys() async {
    for (final hotKey in _registered.values) {
      await hotKeyManager.unregister(hotKey);
    }
    _registered.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    final shortcutMap = <ShortcutActivator, Intent>{};
    final actionMap = <Type, Action<Intent>>{};

    for (final shortcut in widget.shortcuts) {
      final id = shortcut['id']?.toString() ?? shortcut['key']?.toString();
      final keyCombo = shortcut['key']?.toString();
      if (id == null || keyCombo == null) continue;
      final keySet = _parseKeySet(keyCombo);
      if (keySet == null) continue;
      shortcutMap[keySet] = _ShortcutIntent(id);
    }

    actionMap[_ShortcutIntent] = CallbackAction<_ShortcutIntent>(
      onInvoke: (intent) {
        widget.sendEvent(widget.controlId, 'shortcut', {'id': intent.id});
        return null;
      },
    );

    return Shortcuts(
      shortcuts: shortcutMap,
      child: Actions(actions: actionMap, child: widget.child),
    );
  }
}

