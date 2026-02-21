import 'dart:async';

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

Widget buildAnimationAssetControl(Map<String, Object?> props) {
  return _AnimationAsset(props: props);
}

class _AnimationAsset extends StatefulWidget {
  final Map<String, Object?> props;

  const _AnimationAsset({required this.props});

  @override
  State<_AnimationAsset> createState() => _AnimationAssetState();
}

class _AnimationAssetState extends State<_AnimationAsset>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  int _index = 0;
  late final AnimationController _pulseController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: _durationMs),
  );

  int get _durationMs =>
      (coerceOptionalInt(widget.props['duration_ms']) ?? 1400).clamp(80, 30 * 1000);

  bool get _loop => widget.props['loop'] == null ? true : (widget.props['loop'] == true);

  List<String> get _frames {
    final raw = widget.props['frames'];
    if (raw is! List) return const <String>[];
    return raw.map((item) => item?.toString() ?? '').where((v) => v.isNotEmpty).toList();
  }

  @override
  void initState() {
    super.initState();
    _configure();
  }

  @override
  void didUpdateWidget(covariant _AnimationAsset oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.props != widget.props) {
      _configure();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _configure() {
    _timer?.cancel();
    final autoplay = widget.props['autoplay'] == null
        ? true
        : (widget.props['autoplay'] == true);
    _pulseController.duration = Duration(milliseconds: _durationMs);
    if (autoplay) {
      if (_loop) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.forward(from: 0);
      }
    } else {
      _pulseController.stop();
    }

    final frames = _frames;
    if (frames.length <= 1 || !autoplay) return;
    final fps = (coerceOptionalInt(widget.props['fps']) ?? 8).clamp(1, 60);
    final frameDelay = Duration(milliseconds: (1000 / fps).round());
    _timer = Timer.periodic(frameDelay, (_) {
      if (!mounted) return;
      setState(() {
        _index = (_index + 1) % frames.length;
      });
      if (!_loop && _index == frames.length - 1) {
        _timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final kind = (widget.props['kind']?.toString() ??
            widget.props['engine']?.toString() ??
            'image')
        .toLowerCase();
    final src = widget.props['src']?.toString();
    final fit = _parseFit(widget.props['fit']) ?? BoxFit.contain;
    final alignment = _parseAlignment(widget.props['alignment']) ?? Alignment.center;
    final width = coerceDouble(widget.props['width']);
    final height = coerceDouble(widget.props['height']);
    final pulseScale = coerceDouble(widget.props['pulse_scale']) ?? 1.03;
    final label = widget.props['label']?.toString() ?? widget.props['title']?.toString();

    Widget body;
    final frames = _frames;
    if (frames.isNotEmpty) {
      final frame = frames[_index % frames.length];
      body = _imageFromSrc(frame, fit: fit, alignment: alignment);
    } else if (src != null && src.isNotEmpty) {
      body = _imageFromSrc(src, fit: fit, alignment: alignment);
    } else {
      body = _fallback(kind, label: label);
    }

    if (kind == 'rive' || kind == 'lottie' || kind == 'sprite' || kind == 'hero') {
      body = ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: pulseScale).animate(
          CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
        ),
        child: body,
      );
    }

    if (width != null || height != null) {
      body = SizedBox(width: width, height: height, child: body);
    }
    return body;
  }

  Widget _imageFromSrc(
    String src, {
    required BoxFit fit,
    required AlignmentGeometry alignment,
  }) {
    final provider = resolveImageProvider(src);
    if (provider == null) {
      return _fallback('image', label: src);
    }
    return Image(
      image: provider,
      fit: fit,
      alignment: alignment,
      filterQuality: FilterQuality.medium,
    );
  }

  Widget _fallback(String kind, {String? label}) {
    final text = label ?? kind.toUpperCase();
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0x1AFFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x33FFFFFF)),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }
}

BoxFit? _parseFit(Object? value) {
  switch (value?.toString().toLowerCase()) {
    case 'cover':
      return BoxFit.cover;
    case 'fill':
      return BoxFit.fill;
    case 'fit_width':
      return BoxFit.fitWidth;
    case 'fit_height':
      return BoxFit.fitHeight;
    case 'scale_down':
      return BoxFit.scaleDown;
    case 'none':
      return BoxFit.none;
    case 'contain':
      return BoxFit.contain;
    default:
      return null;
  }
}

Alignment? _parseAlignment(Object? value) {
  if (value == null) return null;
  if (value is List && value.length >= 2) {
    return Alignment(
      coerceDouble(value[0]) ?? 0.0,
      coerceDouble(value[1]) ?? 0.0,
    );
  }
  if (value is Map) {
    final map = coerceObjectMap(value);
    return Alignment(
      coerceDouble(map['x']) ?? 0.0,
      coerceDouble(map['y']) ?? 0.0,
    );
  }
  switch (value.toString().toLowerCase().replaceAll('-', '_')) {
    case 'top_left':
      return Alignment.topLeft;
    case 'top_center':
    case 'top':
      return Alignment.topCenter;
    case 'top_right':
      return Alignment.topRight;
    case 'center_left':
    case 'left':
      return Alignment.centerLeft;
    case 'center_right':
    case 'right':
      return Alignment.centerRight;
    case 'bottom_left':
      return Alignment.bottomLeft;
    case 'bottom_center':
    case 'bottom':
      return Alignment.bottomCenter;
    case 'bottom_right':
      return Alignment.bottomRight;
    case 'center':
    default:
      return Alignment.center;
  }
}
