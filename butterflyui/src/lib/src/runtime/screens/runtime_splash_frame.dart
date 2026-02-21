import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/candy/theme_extension.dart';

class RuntimeSplashFrame extends StatefulWidget {
  final Widget child;
  final Color accent;
  final Color secondary;

  const RuntimeSplashFrame({
    super.key,
    required this.child,
    required this.accent,
    required this.secondary,
  });

  @override
  State<RuntimeSplashFrame> createState() => _RuntimeSplashFrameState();
}

class _RuntimeSplashFrameState extends State<RuntimeSplashFrame>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 14),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<ConduitThemeTokens>();
    final baseBackground =
        tokens?.background ?? theme.colorScheme.background;
    final surface =
        tokens?.surface ?? theme.colorScheme.surface;
    return Scaffold(
      backgroundColor: baseBackground,
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    baseBackground,
                    widget.accent.withOpacity(0.12),
                    surface,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final t = _controller.value;
                final orbit = math.pi * 2 * t;
                return IgnorePointer(
                  child: Stack(
                    children: [
                      _Glow(
                        alignment: Alignment(
                          -0.7 + 0.2 * math.sin(orbit),
                          -0.5 + 0.2 * math.cos(orbit),
                        ),
                        color: widget.accent,
                        size: 420,
                        opacity: 0.32,
                      ),
                      _Glow(
                        alignment: Alignment(
                          0.7 + 0.2 * math.cos(orbit * 0.8),
                          0.6 + 0.2 * math.sin(orbit * 0.8),
                        ),
                        color: widget.secondary,
                        size: 480,
                        opacity: 0.24,
                      ),
                      _Glow(
                        alignment: Alignment(
                          0.0 + 0.15 * math.sin(orbit * 1.6),
                          -0.9 + 0.1 * math.cos(orbit * 1.4),
                        ),
                        color: tokens?.text ?? Colors.white,
                        size: 260,
                        opacity: 0.08,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0x14000000),
                      Color(0x00000000),
                      Color(0x14000000),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  final Alignment alignment;
  final Color color;
  final double size;
  final double opacity;

  const _Glow({
    required this.alignment,
    required this.color,
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: RepaintBoundary(
        child: Opacity(
          opacity: opacity,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  color.withOpacity(0.7),
                  color.withOpacity(0.0),
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

