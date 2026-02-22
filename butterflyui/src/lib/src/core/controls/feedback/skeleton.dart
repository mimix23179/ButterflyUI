import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildSkeletonControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
) {
  return ButterflyUISkeleton(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
  );
}

Widget buildSkeletonLoaderControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
) {
  return _SkeletonLoader(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
  );
}

class _SkeletonLoader extends StatefulWidget {
  const _SkeletonLoader({
    required this.controlId,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;

  @override
  State<_SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<_SkeletonLoader> {
  late int _count;

  @override
  void initState() {
    super.initState();
    _count = (coerceOptionalInt(widget.props['count']) ?? 1).clamp(1, 24);
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _SkeletonLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'get_state':
        return {'count': _count};
      case 'set_count':
        setState(() {
          _count = (coerceOptionalInt(args['count']) ?? _count).clamp(1, 24);
        });
        return _count;
      default:
        throw UnsupportedError('Unknown skeleton_loader method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = coerceDouble(widget.props['spacing']) ?? 8;
    if (_count <= 1) {
      return ButterflyUISkeleton(
        controlId: widget.controlId,
        props: widget.props,
        registerInvokeHandler: widget.registerInvokeHandler,
        unregisterInvokeHandler: widget.unregisterInvokeHandler,
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(
        _count,
        (_) => Padding(
          padding: EdgeInsets.only(bottom: spacing),
          child: ButterflyUISkeleton(
            controlId: '',
            props: widget.props,
            registerInvokeHandler: widget.registerInvokeHandler,
            unregisterInvokeHandler: widget.unregisterInvokeHandler,
          ),
        ),
      ),
    );
  }
}

class ButterflyUISkeleton extends StatefulWidget {
  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;

  const ButterflyUISkeleton({
    super.key,
    required this.controlId,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
  });

  @override
  State<ButterflyUISkeleton> createState() => _ButterflyUISkeletonState();
}

class _ButterflyUISkeletonState extends State<ButterflyUISkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _playing = true;

  @override
  void initState() {
    super.initState();
    final durationMs = (coerceOptionalInt(widget.props['duration_ms']) ?? 1100)
        .clamp(300, 6000);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: durationMs),
    )..repeat();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant ButterflyUISkeleton oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextMs = (coerceOptionalInt(widget.props['duration_ms']) ?? 1100)
        .clamp(300, 6000);
    if (nextMs != _controller.duration?.inMilliseconds) {
      _controller.duration = Duration(milliseconds: nextMs);
      if (!_controller.isAnimating) {
        _controller.repeat();
      }
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    _controller.dispose();
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'get_state':
        return {
          'playing': _playing,
          'duration_ms': _controller.duration?.inMilliseconds,
        };
      case 'start':
        _controller.repeat();
        _playing = true;
        return null;
      case 'stop':
        _controller.stop();
        _playing = false;
        return null;
      default:
        throw UnsupportedError('Unknown skeleton method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final variant =
        (widget.props['variant']?.toString().toLowerCase() ?? 'rect').trim();
    final radius = coerceDouble(widget.props['radius']) ?? 10;
    final width = coerceDouble(widget.props['width']);
    final height = coerceDouble(widget.props['height']);
    final base =
        coerceColor(widget.props['color']) ??
        Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.55);
    final highlight =
        coerceColor(widget.props['highlight_color']) ??
        Theme.of(context).colorScheme.surface.withOpacity(0.65);

    double resolvedWidth = width ?? double.infinity;
    double resolvedHeight = height ?? 18;
    BorderRadius borderRadius = BorderRadius.circular(radius);

    if (variant == 'circle') {
      final size = width ?? height ?? 24;
      resolvedWidth = size;
      resolvedHeight = size;
      borderRadius = BorderRadius.circular(size);
    } else if (variant == 'text') {
      resolvedHeight = height ?? 14;
      resolvedWidth = width ?? 160;
      borderRadius = BorderRadius.circular(radius.clamp(2, 10));
    }

    final skeleton = SizedBox(
      width: resolvedWidth,
      height: resolvedHeight,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final t = _controller.value;
            final begin = Alignment(-1.2 + (2.4 * t), 0);
            final end = Alignment(-0.2 + (2.4 * t), 0);
            return DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: begin,
                  end: end,
                  colors: [base, highlight, base],
                  stops: const [0.1, 0.45, 0.9],
                ),
              ),
            );
          },
        ),
      ),
    );

    if (width == null && (variant == 'rect' || variant == 'line')) {
      return Align(alignment: Alignment.centerLeft, child: skeleton);
    }
    return skeleton;
  }
}
