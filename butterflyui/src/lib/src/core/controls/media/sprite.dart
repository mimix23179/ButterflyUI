import 'dart:async';

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/image_provider_resolver.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildSpriteControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _SpriteControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _SpriteControl extends StatefulWidget {
  const _SpriteControl({
    required this.controlId,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_SpriteControl> createState() => _SpriteControlState();
}

class _SpriteControlState extends State<_SpriteControl> {
  late bool _playing;
  late double _progress;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
    _syncTimer();
  }

  @override
  void didUpdateWidget(covariant _SpriteControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    if (oldWidget.props != widget.props) {
      _syncFromProps();
      _syncTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  void _syncFromProps() {
    _playing = widget.props['play'] == null
        ? (widget.props['autoplay'] == true)
        : (widget.props['play'] == true);
    _progress = (coerceDouble(widget.props['progress']) ?? 0.0)
        .clamp(0.0, 1.0)
        .toDouble();
  }

  void _syncTimer() {
    _timer?.cancel();
    final fps = (coerceDouble(widget.props['fps']) ?? 12.0).clamp(1.0, 240.0);
    final frames = (coerceOptionalInt(widget.props['frames']) ?? 1).clamp(
      1,
      4096,
    );
    if (!_playing || frames <= 1) {
      return;
    }
    _timer = Timer.periodic(Duration(milliseconds: (1000 / fps).round()), (_) {
      if (!mounted) return;
      final step = 1 / (frames - 1);
      final loop = widget.props['loop'] == true;
      setState(() {
        final next = _progress + step;
        if (next >= 1.0) {
          if (loop) {
            _progress = 0.0;
          } else {
            _progress = 1.0;
            _playing = false;
            _timer?.cancel();
          }
          if (widget.controlId.isNotEmpty) {
            widget.sendEvent(widget.controlId, 'complete', _statePayload());
          }
        } else {
          _progress = next;
        }
      });
    });
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_play':
        setState(() {
          _playing = args['play'] == true;
        });
        _syncTimer();
        return _statePayload();
      case 'set_progress':
        final next = coerceDouble(args['progress']);
        if (next != null) {
          setState(() => _progress = next.clamp(0.0, 1.0).toDouble());
        }
        return _statePayload();
      case 'get_state':
        return _statePayload();
      case 'emit':
        final event = (args['event'] ?? 'change').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        if (widget.controlId.isNotEmpty) {
          widget.sendEvent(widget.controlId, event, payload);
        }
        return null;
      default:
        throw UnsupportedError('Unknown sprite method: $method');
    }
  }

  Map<String, Object?> _statePayload() => <String, Object?>{
    'play': _playing,
    'progress': _progress,
    'src': widget.props['src']?.toString() ?? '',
  };

  @override
  Widget build(BuildContext context) {
    final src = widget.props['src']?.toString() ?? '';
    final provider = resolveImageProviderImpl(src);
    if (provider == null) {
      return const SizedBox.shrink();
    }

    final frameWidth = coerceDouble(widget.props['frame_width']) ?? 64.0;
    final frameHeight = coerceDouble(widget.props['frame_height']) ?? 64.0;
    final frames = (coerceOptionalInt(widget.props['frames']) ?? 1).clamp(
      1,
      4096,
    );
    final columns = (coerceOptionalInt(widget.props['columns']) ?? frames)
        .clamp(1, 4096);
    final rows =
        (coerceOptionalInt(widget.props['rows']) ??
                ((frames + columns - 1) ~/ columns))
            .clamp(1, 4096);
    final fit = _parseFit(widget.props['fit']) ?? BoxFit.contain;
    final currentFrame = ((_progress * (frames - 1)).round()).clamp(
      0,
      frames - 1,
    );
    final col = currentFrame % columns;
    final row = currentFrame ~/ columns;
    final sheetWidth = frameWidth * columns;
    final sheetHeight = frameHeight * rows;
    final radius = coerceDouble(widget.props['radius']) ?? 0.0;

    Widget sheet = SizedBox(
      width: sheetWidth,
      height: sheetHeight,
      child: Transform.translate(
        offset: Offset(-(col * frameWidth), -(row * frameHeight)),
        child: Image(
          image: provider,
          fit: BoxFit.fill,
          width: sheetWidth,
          height: sheetHeight,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),
      ),
    );

    Widget view = SizedBox(
      width: frameWidth,
      height: frameHeight,
      child: ClipRect(
        child: FittedBox(fit: fit, alignment: Alignment.topLeft, child: sheet),
      ),
    );

    if (radius > 0) {
      view = ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: view,
      );
    }

    return view;
  }
}

BoxFit? _parseFit(Object? value) {
  final s = value?.toString().toLowerCase();
  switch (s) {
    case 'cover':
      return BoxFit.cover;
    case 'fill':
      return BoxFit.fill;
    case 'fit_width':
    case 'fitwidth':
      return BoxFit.fitWidth;
    case 'fit_height':
    case 'fitheight':
      return BoxFit.fitHeight;
    case 'scale_down':
    case 'scaledown':
      return BoxFit.scaleDown;
    case 'none':
      return BoxFit.none;
    case 'contain':
    default:
      return BoxFit.contain;
  }
}
