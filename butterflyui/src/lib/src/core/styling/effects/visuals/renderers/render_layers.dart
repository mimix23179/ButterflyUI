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
  final alignment = _coerceAlignment(
    config['alignment'] ?? config['position'],
    fallbackAlignment,
  );
  final padding = coercePadding(config['padding']) ?? EdgeInsets.zero;

  Widget child = widget;
  if (width != null || height != null) {
    child = SizedBox(width: width, height: height, child: child);
  }
  if (padding != EdgeInsets.zero) {
    child = Padding(padding: padding, child: child);
  }

  return Align(
    alignment: alignment,
    child: IgnorePointer(child: child),
  );
}

class _EffectPlaneStyle {
  const _EffectPlaneStyle({
    required this.opacity,
    required this.mask,
  });

  final double opacity;
  final Object? mask;
}

class _EffectRegion {
  const _EffectRegion({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });

  final double left;
  final double top;
  final double width;
  final double height;

  bool get isValid => width > 0 && height > 0;
  Rect get rect => Rect.fromLTWH(left, top, width, height);
}

enum _EffectMaskKind { none, oval, rounded }

_EffectMaskKind _parseEffectMaskKind(Object? rawMask) {
  if (rawMask == null || rawMask == false) {
    return _EffectMaskKind.none;
  }
  final normalized = rawMask is Map
      ? normalizeEffectLayerToken(
          coerceObjectMap(rawMask)['type'] ??
              coerceObjectMap(rawMask)['shape'] ??
              coerceObjectMap(rawMask)['mask'],
        )
      : normalizeEffectLayerToken(rawMask);
  switch (normalized) {
    case 'oval':
    case 'circle':
    case 'radial':
      return _EffectMaskKind.oval;
    case 'rounded':
    case 'round':
    case 'capsule':
    case 'pill':
      return _EffectMaskKind.rounded;
    default:
      return _EffectMaskKind.none;
  }
}

double? _resolveMaskRadius(
  Object? rawMask, {
  required double fallback,
}) {
  if (rawMask is! Map) return fallback > 0 ? fallback : null;
  final map = coerceObjectMap(rawMask);
  final radius =
      coerceDouble(map['radius']) ?? coerceDouble(map['corner_radius']);
  if (radius != null && radius > 0) {
    return radius;
  }
  return fallback > 0 ? fallback : null;
}

Widget _applyEffectMask(
  Widget child,
  Object? rawMask, {
  required double fallbackRadius,
}) {
  switch (_parseEffectMaskKind(rawMask)) {
    case _EffectMaskKind.none:
      return child;
    case _EffectMaskKind.oval:
      return ClipOval(child: child);
    case _EffectMaskKind.rounded:
      return ClipRRect(
        borderRadius: BorderRadius.circular(
          _resolveMaskRadius(rawMask, fallback: fallbackRadius) ?? 18.0,
        ),
        child: child,
      );
  }
}

double _resolveEffectPlaneOpacity(
  Map<String, Object?> props,
  String plane,
) {
  final sceneOpacity = coerceDouble(props['scene_opacity']) ?? 1.0;
  final planeOpacity =
      coerceDouble(props['${plane}_scene_opacity']) ??
      coerceDouble(props['${plane}SceneOpacity']) ??
      1.0;
  return (sceneOpacity * planeOpacity).clamp(0.0, 1.0);
}

Object? _resolveEffectPlaneMask(
  Map<String, Object?> props,
  String plane,
) {
  return props['${plane}_scene_mask'] ??
      props['${plane}SceneMask'] ??
      props['scene_mask'] ??
      props['sceneMask'];
}

double _resolveAxisOffset(Object? value, double extent) {
  final resolved = coerceDouble(value);
  if (resolved == null) return 0.0;
  if (resolved >= 0.0 && resolved <= 1.0) {
    return resolved * extent;
  }
  return resolved;
}

double _resolveAxisExtent(Object? value, double extent) {
  final resolved = coerceDouble(value);
  if (resolved == null) return extent;
  if (resolved >= 0.0 && resolved <= 1.0) {
    return resolved * extent;
  }
  return resolved;
}

_EffectRegion? _resolveEffectRegion(Object? rawRegion, Size size) {
  if (rawRegion == null) return null;
  if (rawRegion is String) {
    switch (normalizeEffectLayerToken(rawRegion)) {
      case 'top_half':
        return _EffectRegion(
          left: 0,
          top: 0,
          width: size.width,
          height: size.height * 0.5,
        );
      case 'bottom_half':
        return _EffectRegion(
          left: 0,
          top: size.height * 0.5,
          width: size.width,
          height: size.height * 0.5,
        );
      case 'left_half':
        return _EffectRegion(
          left: 0,
          top: 0,
          width: size.width * 0.5,
          height: size.height,
        );
      case 'right_half':
        return _EffectRegion(
          left: size.width * 0.5,
          top: 0,
          width: size.width * 0.5,
          height: size.height,
        );
      case 'center':
        return _EffectRegion(
          left: size.width * 0.15,
          top: size.height * 0.15,
          width: size.width * 0.7,
          height: size.height * 0.7,
        );
      default:
        return null;
    }
  }
  if (rawRegion is! Map) return null;
  final map = coerceObjectMap(rawRegion);
  final left = _resolveAxisOffset(map['x'] ?? map['left'], size.width);
  final top = _resolveAxisOffset(map['y'] ?? map['top'], size.height);
  final width = _resolveAxisExtent(
    map['width'] ?? map['w'],
    (size.width - left).clamp(0.0, size.width),
  );
  final height = _resolveAxisExtent(
    map['height'] ?? map['h'],
    (size.height - top).clamp(0.0, size.height),
  );
  final region = _EffectRegion(
    left: left.clamp(0.0, size.width),
    top: top.clamp(0.0, size.height),
    width: width.clamp(0.0, size.width),
    height: height.clamp(0.0, size.height),
  );
  return region.isValid ? region : null;
}

Widget _wrapEffectLayerForStack({
  required Widget child,
  required EffectLayer layer,
  required _EffectPlaneStyle planeStyle,
  required double clipRadius,
}) {
  return Positioned.fill(
    child: LayoutBuilder(
      builder: (context, constraints) {
        final region = _resolveEffectRegion(
          layer.config['region'] ?? layer.config['bounds'],
          constraints.biggest,
        );
        final mask = layer.config['mask'] ?? planeStyle.mask;
        final opacity = (planeStyle.opacity * layer.opacity).clamp(0.0, 1.0);

        Widget composed;
        if (region != null) {
          composed = SizedBox(
            width: region.width,
            height: region.height,
            child: child,
          );
        } else {
          composed = SizedBox.expand(child: child);
        }
        composed = _applyEffectMask(
          composed,
          mask,
          fallbackRadius: clipRadius,
        );
        if (opacity < 1.0) {
          composed = Opacity(opacity: opacity, child: composed);
        }
        if (region == null) {
          return IgnorePointer(child: composed);
        }
        return IgnorePointer(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned.fromRect(rect: region.rect, child: composed),
            ],
          ),
        );
      },
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
    final radius =
        coerceDouble(
          widget.props['scene_clip_radius'] ??
              widget.props['clip_radius'] ??
              widget.props['border_radius'] ??
              widget.props['radius'],
        ) ??
        0.0;
    final clipScenes = widget.props['clip_scene'] != false;
    final clipBehavior = coerceClipBehavior(
      clipScenes
          ? (widget.props['clip_behavior'] ??
                (radius > 0 ? 'anti_alias' : null))
          : widget.props['clip_behavior'],
    );
    final enableTicker = !_pauseWhenHidden || _visible;
    final backgroundPlane = _EffectPlaneStyle(
      opacity: _resolveEffectPlaneOpacity(widget.props, 'background'),
      mask: _resolveEffectPlaneMask(widget.props, 'background'),
    );
    final foregroundPlane = _EffectPlaneStyle(
      opacity: _resolveEffectPlaneOpacity(widget.props, 'foreground'),
      mask: _resolveEffectPlaneMask(widget.props, 'foreground'),
    );
    final overlayPlane = _EffectPlaneStyle(
      opacity: _resolveEffectPlaneOpacity(widget.props, 'overlay'),
      mask: _resolveEffectPlaneMask(widget.props, 'overlay'),
    );

    final stack = AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, sceneChild) {
        final progress = _controller.value;
        final backgroundLayers = widget.scene.backgroundLayers
            .map(
              (layer) {
                final built = _buildSceneLayer(
                  layer,
                  progress,
                  enableTicker: enableTicker,
                );
                if (built == null) return null;
                return _wrapEffectLayerForStack(
                  child: built,
                  layer: layer,
                  planeStyle: backgroundPlane,
                  clipRadius: radius,
                );
              },
            )
            .whereType<Widget>()
            .toList(growable: false);
        final foregroundLayers = widget.scene.foregroundLayers
            .map(
              (layer) {
                final built = _buildSceneLayer(
                  layer,
                  progress,
                  enableTicker: enableTicker,
                );
                if (built == null) return null;
                return _wrapEffectLayerForStack(
                  child: built,
                  layer: layer,
                  planeStyle: foregroundPlane,
                  clipRadius: radius,
                );
              },
            )
            .whereType<Widget>()
            .toList(growable: false);
        final overlayLayers = widget.scene.overlayLayers
            .map(
              (layer) {
                final built = _buildSceneLayer(
                  layer,
                  progress,
                  enableTicker: enableTicker,
                );
                if (built == null) return null;
                return _wrapEffectLayerForStack(
                  child: built,
                  layer: layer,
                  planeStyle: overlayPlane,
                  clipRadius: radius,
                );
              },
            )
            .whereType<Widget>()
            .toList(growable: false);

        return Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            ...backgroundLayers,
            ...(sceneChild == null ? const <Widget>[] : <Widget>[sceneChild]),
            ...foregroundLayers,
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
  return IgnorePointer(
    child: RepaintBoundary(
      child: _EffectShaderLayerHost(
        asset: asset,
        layer: layer,
        progress: progress,
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
    final uniformValues = <double>[];
    final uniforms = layer.config['uniforms'];
    if (uniforms is Map) {
      final keys = uniforms.keys.map((key) => key.toString()).toList()..sort();
      for (final key in keys) {
        final value = uniforms[key];
        if (value is num) {
          uniformValues.add(value.toDouble());
        } else if (value is Iterable) {
          for (final entry in value) {
            if (entry is num) {
              uniformValues.add(entry.toDouble());
            }
          }
        }
      }
    }
    final values = <double>[
      size.width,
      size.height,
      progress * layer.speed * 12.0,
      base.r,
      base.g,
      base.b,
      base.a,
      accent.r,
      accent.g,
      accent.b,
      accent.a,
      layer.intensity.clamp(0.0, 2.0),
      ...uniformValues,
    ];
    for (var index = 0; index < values.length; index++) {
      shader.setFloat(index, values[index]);
    }
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

  final lottieAsset = config['lottie_asset']?.toString().trim();
  final lottieUrl = config['lottie_url']?.toString().trim();
  final lottieBytes = _coerceEffectLottieBytes(
    config['lottie_data'] ?? config['lottie_json'] ?? config['json'],
  );
  if (lottieBytes != null) {
    return _EffectLottieLayerHost(
      source: _EffectLottieSource.memory(lottieBytes),
      config: config,
      fit: fit,
      alignment: alignment,
    );
  }
  if (lottieUrl != null && lottieUrl.isNotEmpty) {
    return _EffectLottieLayerHost(
      source: _EffectLottieSource.network(lottieUrl),
      config: config,
      fit: fit,
      alignment: alignment,
    );
  }
  if (lottieAsset != null && lottieAsset.isNotEmpty) {
    return _EffectLottieLayerHost(
      source: _EffectLottieSource.asset(lottieAsset),
      config: config,
      fit: fit,
      alignment: alignment,
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

enum _EffectLottieSourceKind { asset, network, memory }

class _EffectLottieSource {
  const _EffectLottieSource._(this.kind, this.asset, this.url, this.bytes);

  const _EffectLottieSource.asset(String asset)
      : this._(_EffectLottieSourceKind.asset, asset, null, null);

  const _EffectLottieSource.network(String url)
      : this._(_EffectLottieSourceKind.network, null, url, null);

  const _EffectLottieSource.memory(Uint8List bytes)
      : this._(_EffectLottieSourceKind.memory, null, null, bytes);

  final _EffectLottieSourceKind kind;
  final String? asset;
  final String? url;
  final Uint8List? bytes;
}

class _EffectLottieLayerHost extends StatefulWidget {
  const _EffectLottieLayerHost({
    required this.source,
    required this.config,
    required this.fit,
    required this.alignment,
  });

  final _EffectLottieSource source;
  final Map<String, Object?> config;
  final BoxFit fit;
  final Alignment alignment;

  @override
  State<_EffectLottieLayerHost> createState() => _EffectLottieLayerHostState();
}

class _EffectLottieLayerHostState extends State<_EffectLottieLayerHost>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool get _animate => widget.config['animate'] != false;
  bool get _repeat => widget.config['repeat'] != false;
  bool get _reverse => widget.config['reverse'] == true;
  double get _speed =>
      (coerceDouble(widget.config['speed']) ?? 1.0).clamp(0.05, 12.0);
  double get _phase =>
      (coerceDouble(widget.config['phase']) ?? 0.0).clamp(0.0, 1.0);
  int? get _durationMs => coerceOptionalInt(widget.config['duration_ms']);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Duration _scaledDuration(Duration base) {
    final override = _durationMs;
    final effective = override != null
        ? Duration(milliseconds: override.clamp(1, 600000))
        : base;
    final micros = (effective.inMicroseconds / _speed).round().clamp(1, 600000000);
    return Duration(microseconds: micros);
  }

  void _handleLoaded(LottieComposition composition) {
    _controller.duration = _scaledDuration(composition.duration);
    _controller.value = _phase;
    if (!_animate) {
      return;
    }
    if (_repeat) {
      _controller.repeat(reverse: _reverse);
      return;
    }
    _controller.forward(from: _phase);
  }

  @override
  Widget build(BuildContext context) {
    return switch (widget.source.kind) {
      _EffectLottieSourceKind.asset => Lottie.asset(
        widget.source.asset!,
        controller: _controller,
        fit: widget.fit,
        alignment: widget.alignment,
        onLoaded: _handleLoaded,
        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
      ),
      _EffectLottieSourceKind.network => Lottie.network(
        widget.source.url!,
        controller: _controller,
        fit: widget.fit,
        alignment: widget.alignment,
        onLoaded: _handleLoaded,
        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
      ),
      _EffectLottieSourceKind.memory => Lottie.memory(
        widget.source.bytes!,
        controller: _controller,
        fit: widget.fit,
        alignment: widget.alignment,
        onLoaded: _handleLoaded,
        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
      ),
    };
  }
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
