import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/styling/effects/visuals/actors/actor_overlay.dart';
import 'package:butterflyui_runtime/src/core/styling/effects/visuals/renderers/render_layers.dart';
import 'package:butterflyui_runtime/src/core/styling/effects/visuals/scene/preset_registry.dart';
import 'package:butterflyui_runtime/src/core/controls/effects/animated_background.dart';
import 'package:butterflyui_runtime/src/core/controls/effects/liquid_morph.dart';
import 'package:butterflyui_runtime/src/core/controls/effects/parallax.dart';
import 'package:butterflyui_runtime/src/core/controls/effects/particle_field.dart';
import 'package:butterflyui_runtime/src/core/controls/effects/scanline_overlay.dart';
import 'package:butterflyui_runtime/src/core/controls/effects/shimmer_shadow.dart';
import 'package:butterflyui_runtime/src/core/controls/effects/vignette.dart';
import 'package:butterflyui_runtime/src/core/controls/effects/visual_fx.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget applyEffectEnhancementLayers({
  required Widget child,
  required Map<String, Object?> props,
  required bool isDark,
  required String controlId,
  required ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  required ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  required ButterflyUISendRuntimeEvent sendEvent,
}) {
  var childWidget = child;

  if (!resolveEffectSceneFromProps(props).isEmpty) {
    childWidget = wrapWithEffectRenderLayers(
      controlId: '$controlId::scene',
      props: props,
      child: childWidget,
    );
  }

  if (props['particles'] == true) {
    childWidget = Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        childWidget,
        IgnorePointer(
          child: buildParticleFieldControl(
            '$controlId::particles',
            props,
            registerInvokeHandler,
            unregisterInvokeHandler,
            sendEvent,
          ),
        ),
      ],
    );
  }

  if (props['scanline'] == true) {
    childWidget = buildScanlineOverlayControl(
      '$controlId::scanline',
      props,
      childWidget,
      defaultText: isDark ? Colors.white : Colors.black,
      registerInvokeHandler: registerInvokeHandler,
      unregisterInvokeHandler: unregisterInvokeHandler,
    );
  }

  if (props['shimmer'] == true) {
    childWidget = buildShimmerControl(
      '$controlId::effects',
      props,
      childWidget,
      registerInvokeHandler,
      unregisterInvokeHandler,
    );
  }

  if (props['vignette'] == true) {
    childWidget = buildVignetteControl(
      '$controlId::vignette',
      props,
      childWidget,
      defaultColor: const Color(0xFF020617),
      registerInvokeHandler: registerInvokeHandler,
      unregisterInvokeHandler: unregisterInvokeHandler,
    );
  }

  if (props['animated_background'] == true) {
    childWidget = Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        Positioned.fill(
          child: buildAnimatedBackgroundControl(
            props,
            const <dynamic>[],
            (_) => const SizedBox.shrink(),
          ),
        ),
        childWidget,
      ],
    );
  }

  if (props['liquid_morph'] == true) {
    final baseChild = childWidget;
    childWidget = buildLiquidMorphControl(props, const <dynamic>[
      <String, Object?>{'placeholder': true},
    ], (_) => baseChild);
  }

  if (props['parallax'] == true) {
    final baseChild = childWidget;
    childWidget = buildParallaxControl(props, const <dynamic>[
      <String, Object?>{'placeholder': true},
    ], (_) => baseChild);
  }

  if (props['glow'] == true) {
    childWidget = buildGlowEffectControl(props, childWidget);
  }

  final actorOverlay = buildEffectActorOverlay(
    props['actors'] ?? props['actor'],
    isDark,
  );
  if (actorOverlay != null) {
    childWidget = Stack(
      fit: StackFit.passthrough,
      children: <Widget>[childWidget, actorOverlay],
    );
  }

  return childWidget;
}
