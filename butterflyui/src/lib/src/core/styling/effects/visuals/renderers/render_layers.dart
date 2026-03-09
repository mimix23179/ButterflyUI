import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart' as rive;
import 'package:visibility_detector/visibility_detector.dart';

import 'package:butterflyui_runtime/src/core/styling/effects/visuals/renderers/scene_painters.dart';
import 'package:butterflyui_runtime/src/core/styling/effects/visuals/scene/layer.dart';
import 'package:butterflyui_runtime/src/core/styling/effects/visuals/scene/preset_registry.dart';
import 'package:butterflyui_runtime/src/core/styling/effects/visuals/scene/scene.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';

Widget wrapWithEffectRenderLayers({
  required String controlId,
  required Map<String, Object?> props,
  required Widget child,
}) {
  final scene = resolveEffectSceneFromProps(props);
  if (scene.isEmpty) {
    return child;
  }
  return _EffectRenderLayerHost(
    controlId: controlId,
    props: props,
    scene: scene,
    child: child,
  );
}

Widget? buildEffectAnimatedLayer(
  Map<String, Object?>? config, {
  required Alignment fallbackAlignment,
  required BoxFit fallbackFit,
}) {
  if (config == null || config.isEmpty) return null;
  final widget = _buildEffectAnimatedAssetWidget(
    config,
    fallbackFit: fallbackFit,
    fallbackAlignment: fallbackAlignment,
  );
  if (widget == null) return null;

  final width =
      coerceDouble(config['width']) ??
      coerceDouble(config['size']) ??
      coerceDouble(config['diameter']);
  final height =
      coerceDouble(config['height']) ??
      coerceDouble(config['size']) ??
      coerceDouble(config['diameter']);
  final opacity = (coerceDouble(config['opacity']) ?? 1.0).clamp(0.0, 1.0);
  final alignment = _coerceAlignment(
    config['alignment'] ?? config['position'],
    fallbackAlignment,
  );
  final padding = coercePadding(config['padding']) ?? EdgeInsets.zero;

  Widget child = Opacity(opacity: opacity, child: widget);
  if (width != null || height != null) {
    child = SizedBox(width: width, height: height, child: child);
  }
  if (padding != EdgeInsets.zero) {
    child = Padding(padding: padding, child: child);
  }

  return Positioned.fill(
    child: Align(
      alignment: alignment,
      child: IgnorePointer(child: child),
    ),
  );
}

class _EffectRenderLayerHost extends StatefulWidget {
  const _EffectRenderLayerHost({
    required this.controlId,
    required this.props,
    required this.scene,
    required this.child,
  });

  final String controlId;
  final Map<String, Object?> props;
  final EffectScene scene;
  final Widget child;

  @override
  State<_EffectRenderLayerHost> createState() => _EffectRenderLayerHostState();
}

class _EffectRenderLayerHostState extends State<_EffectRenderLayerHost>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _visible = true;

  bool get _pauseWhenHidden =>
      widget.props['pause_when_hidden'] != false &&
      widget.props['pauseWhenHidden'] != false;

  double get _visibilityThreshold =>
      (coerceDouble(
                widget.props['visibility_threshold'] ??
                    widget.props['preview_visibility_threshold'],
              ) ??
              0.04)
          .clamp(0.0, 1.0);

  Duration get _duration {
    final durationMs =
        (coerceOptionalInt(
                  widget.props['scene_duration_ms'] ??
                      widget.props['duration_ms'] ??
                      widget.props['duration'],
                ) ??
                18000)
            .clamp(1, 600000);
    return Duration(milliseconds: durationMs);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);
    _syncPlayback(forceStart: true);
  }

  @override
  void didUpdateWidget(covariant _EffectRenderLayerHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.props != widget.props) {
      _controller.duration = _duration;
      _syncPlayback();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _syncPlayback({bool forceStart = false}) {
    final shouldAnimate =
        widget.props['animate'] != false && (!_pauseWhenHidden || _visible);
    if (!shouldAnimate) {
      _controller.stop();
      return;
    }
    if (forceStart || !_controller.isAnimating) {
      _controller.repeat();
    }
  }

  void _handleVisibilityChanged(VisibilityInfo info) {
    if (!_pauseWhenHidden) return;
    final nextVisible = info.visibleFraction > _visibilityThreshold;
    if (nextVisible == _visible) return;
    if (!mounted) return;
    setState(() {
      _visible = nextVisible;
    });
    _syncPlayback();
  }

  Widget? _buildSceneLayer(
    EffectLayer layer,
    double progress, {
    required bool enableTicker,
  }) {
    Widget? built;
    if (layer.usesShaderRenderer) {
      built = _buildEffectShaderLayer(layer, progress: progress);
    } else if (layer.usesAssetRenderer) {
      built = buildEffectAnimatedLayer(
        layer.config,
        fallbackAlignment: Alignment.center,
        fallbackFit: BoxFit.cover,
      );
    } else if (layer.usesPainterRenderer) {
      built = buildEffectScenePaintLayer(layer, progress: progress);
    }
    if (built == null) return null;
    if (layer.usesAssetRenderer) {
      return TickerMode(enabled: enableTicker, child: built);
    }
    return built;
  }

  Widget _buildLayeredStack() {
    final clipBehavior = coerceClipBehavior(
      widget.props['clip_scene'] == true
          ? (widget.props['clip_behavior'] ?? 'anti_alias')
          : widget.props['clip_behavior'],
    );
    final radius =
        coerceDouble(
          widget.props['scene_clip_radius'] ??
              widget.props['clip_radius'] ??
              widget.props['border_radius'] ??
              widget.props['radius'],
        ) ??
        0.0;
    final enableTicker = !_pauseWhenHidden || _visible;

    final stack = AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, sceneChild) {
        final progress = _controller.value;
        final backgroundLayers = widget.scene.backgroundLayers
            .map(
              (layer) =>
                  _buildSceneLayer(layer, progress, enableTicker: enableTicker),
            )
            .whereType<Widget>()
            .toList(growable: false);
        final overlayLayers = widget.scene.overlayLayers
            .map(
              (layer) =>
                  _buildSceneLayer(layer, progress, enableTicker: enableTicker),
            )
            .whereType<Widget>()
            .toList(growable: false);

        return Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            ...backgroundLayers,
            ...(sceneChild == null ? const <Widget>[] : <Widget>[sceneChild]),
            ...overlayLayers,
          ],
        );
      },
    );

    final shouldClip = clipBehavior != null && clipBehavior != Clip.none;
    if (!shouldClip) {
      return RepaintBoundary(child: stack);
    }
    if (radius > 0) {
      return RepaintBoundary(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          clipBehavior: clipBehavior,
          child: stack,
        ),
      );
    }
    return RepaintBoundary(
      child: ClipRect(clipBehavior: clipBehavior, child: stack),
    );
  }

  @override
  Widget build(BuildContext context) {
    final layered = _buildLayeredStack();
    if (!_pauseWhenHidden) {
      return layered;
    }
    return VisibilityDetector(
      key: ValueKey<String>('${widget.controlId}::effect_layers'),
      onVisibilityChanged: _handleVisibilityChanged,
      child: layered,
    );
  }
}

Uint8List? _coerceEffectLottieBytes(Object? value) {
  if (value == null) return null;
  if (value is Uint8List) return value;
  if (value is List<int>) return Uint8List.fromList(value);
  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    if (trimmed.startsWith('{') || trimmed.startsWith('[')) {
      return Uint8List.fromList(utf8.encode(trimmed));
    }
    try {
      return base64Decode(trimmed);
    } catch (_) {
      return null;
    }
  }
  return null;
}

String? _resolveEffectShaderAsset(EffectLayer layer) {
  final explicit = layer.config['shader_asset']?.toString().trim();
  if (explicit != null && explicit.isNotEmpty) {
    return explicit;
  }
  return switch (layer.kind) {
    EffectLayerKind.matrixRain => 'shaders/matrix_rain.frag',
    EffectLayerKind.nebula => 'shaders/galaxy.frag',
    EffectLayerKind.rain => 'shaders/rainstorm.frag',
    EffectLayerKind.liquidGlow => 'shaders/liquid_glow.frag',
    _ => null,
  };
}

Widget? _buildEffectShaderLayer(
  EffectLayer layer, {
  required double progress,
}) {
  final asset = _resolveEffectShaderAsset(layer);
  if (asset == null || asset.isEmpty) return null;
  return Positioned.fill(
    child: IgnorePointer(
      child: Opacity(
        opacity: layer.opacity,
        child: RepaintBoundary(
          child: _EffectShaderLayerHost(
            asset: asset,
            layer: layer,
            progress: progress,
          ),
        ),
      ),
    ),
  );
}

class _EffectShaderLayerHost extends StatefulWidget {
  const _EffectShaderLayerHost({
    required this.asset,
    required this.layer,
    required this.progress,
  });

  final String asset;
  final EffectLayer layer;
  final double progress;

  @override
  State<_EffectShaderLayerHost> createState() => _EffectShaderLayerHostState();
}

class _EffectShaderLayerHostState extends State<_EffectShaderLayerHost> {
  late Future<ui.FragmentProgram?> _programFuture;

  @override
  void initState() {
    super.initState();
    _programFuture = _loadProgram(widget.asset);
  }

  @override
  void didUpdateWidget(covariant _EffectShaderLayerHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.asset != widget.asset) {
      _programFuture = _loadProgram(widget.asset);
    }
  }

  Future<ui.FragmentProgram?> _loadProgram(String asset) async {
    try {
      return await ui.FragmentProgram.fromAsset(asset);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.FragmentProgram?>(
      future: _programFuture,
      builder: (context, snapshot) {
        final program = snapshot.data;
        if (program == null) {
          final painter = buildEffectScenePainter(
            widget.layer,
            progress: widget.progress,
          );
          if (painter == null) {
            return const SizedBox.expand();
          }
          return CustomPaint(painter: painter, child: const SizedBox.expand());
        }
        return CustomPaint(
          painter: _EffectShaderPainter(
            program: program,
            layer: widget.layer,
            progress: widget.progress,
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class _EffectShaderPainter extends CustomPainter {
  const _EffectShaderPainter({
    required this.program,
    required this.layer,
    required this.progress,
  });

  final ui.FragmentProgram program;
  final EffectLayer layer;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final shader = program.fragmentShader();
    final base = layer.color ?? const Color(0xFF4F46E5);
    final accent = layer.accentColor ?? const Color(0xFF22D3EE);
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, progress * layer.speed * 12.0);
    shader.setFloat(3, base.red / 255.0);
    shader.setFloat(4, base.green / 255.0);
    shader.setFloat(5, base.blue / 255.0);
    shader.setFloat(6, base.alpha / 255.0);
    shader.setFloat(7, accent.red / 255.0);
    shader.setFloat(8, accent.green / 255.0);
    shader.setFloat(9, accent.blue / 255.0);
    shader.setFloat(10, accent.alpha / 255.0);
    shader.setFloat(11, layer.intensity.clamp(0.0, 2.0));
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = shader
        ..blendMode = BlendMode.srcOver,
    );
  }

  @override
  bool shouldRepaint(covariant _EffectShaderPainter oldDelegate) {
    return oldDelegate.program != program ||
        oldDelegate.progress != progress ||
        oldDelegate.layer.signature != layer.signature;
  }
}

Widget? _buildEffectAnimatedAssetWidget(
  Map<String, Object?> config, {
  required BoxFit fallbackFit,
  required Alignment fallbackAlignment,
}) {
  final fit = _coerceBoxFit(config['fit'], fallbackFit);
  final alignment = _coerceAlignment(config['alignment'], fallbackAlignment);
  final animate = config['animate'] != false;
  final repeat = config['repeat'] != false;
  final reverse = config['reverse'] == true;

  final lottieAsset = config['lottie_asset']?.toString().trim();
  final lottieUrl = config['lottie_url']?.toString().trim();
  final lottieBytes = _coerceEffectLottieBytes(
    config['lottie_data'] ?? config['lottie_json'] ?? config['json'],
  );
  if (lottieBytes != null) {
    return Lottie.memory(
      lottieBytes,
      animate: animate,
      repeat: repeat,
      reverse: reverse,
      fit: fit,
      alignment: alignment,
      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
    );
  }
  if (lottieUrl != null && lottieUrl.isNotEmpty) {
    return Lottie.network(
      lottieUrl,
      animate: animate,
      repeat: repeat,
      reverse: reverse,
      fit: fit,
      alignment: alignment,
      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
    );
  }
  if (lottieAsset != null && lottieAsset.isNotEmpty) {
    return Lottie.asset(
      lottieAsset,
      animate: animate,
      repeat: repeat,
      reverse: reverse,
      fit: fit,
      alignment: alignment,
      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
    );
  }

  final riveAsset = config['rive_asset']?.toString().trim();
  final riveUrl = config['rive_url']?.toString().trim();
  final artboard = config['rive_artboard']?.toString().trim();
  final stateMachine = config['rive_state_machine']?.toString().trim();
  if ((riveAsset != null && riveAsset.isNotEmpty) ||
      (riveUrl != null && riveUrl.isNotEmpty)) {
    final loader = riveUrl != null && riveUrl.isNotEmpty
        ? rive.FileLoader.fromUrl(riveUrl, riveFactory: rive.Factory.flutter)
        : rive.FileLoader.fromAsset(
            riveAsset!,
            riveFactory: rive.Factory.flutter,
          );
    return Align(
      alignment: alignment,
      child: FittedBox(
        fit: fit,
        alignment: alignment,
        child: rive.RiveWidgetBuilder(
          fileLoader: loader,
          artboardSelector: artboard != null && artboard.isNotEmpty
              ? rive.ArtboardSelector.byName(artboard)
              : const rive.ArtboardDefault(),
          stateMachineSelector: stateMachine != null && stateMachine.isNotEmpty
              ? rive.StateMachineSelector.byName(stateMachine)
              : const rive.StateMachineDefault(),
          builder: (context, state) {
            return switch (state) {
              rive.RiveLoading() => const SizedBox.shrink(),
              rive.RiveFailed() => const SizedBox.shrink(),
              rive.RiveLoaded loaded => rive.RiveWidget(
                controller: loaded.controller,
              ),
            };
          },
        ),
      ),
    );
  }

  return null;
}

Alignment _coerceAlignment(Object? value, Alignment fallback) {
  final alignment = coerceAlignmentGeometry(value);
  return alignment is Alignment ? alignment : fallback;
}

BoxFit _coerceBoxFit(Object? value, BoxFit fallback) {
  final normalized = value
      ?.toString()
      .trim()
      .toLowerCase()
      .replaceAll('-', '_')
      .replaceAll(' ', '_');
  switch (normalized) {
    case 'contain':
      return BoxFit.contain;
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
    default:
      return fallback;
  }
}
