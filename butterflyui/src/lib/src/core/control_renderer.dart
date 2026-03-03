import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'animation/animation_spec.dart';
import 'candy/theme.dart';
import 'butterflyui_event_box.dart';
import 'control_registry.dart';
import 'control_utils.dart';
import 'motion/motion_pack.dart';
import 'modifiers/modifier_chain.dart';
import 'controls/buttons/button.dart';
import 'controls/buttons/elevated_button.dart';
import 'controls/buttons/icon_button.dart';
import 'controls/buttons/filled_button.dart';
import 'controls/buttons/outlined_button.dart';
import 'controls/buttons/text_button.dart';
import 'controls/common/option_types.dart';
import 'controls/common/icon_value.dart';
import 'controls/customization/animated_gradient.dart';
import 'controls/customization/avatar_stack.dart';
import 'controls/customization/badge.dart';
import 'controls/customization/blend_mode_picker.dart';
import 'controls/customization/blob_field.dart';
import 'controls/customization/border.dart';
import 'controls/customization/border_side.dart';
import 'controls/customization/button_style.dart';
import 'controls/gallery/gallery.dart';
import 'controls/candy/candy.dart';
import 'controls/customization/crop_box.dart';
import 'controls/customization/histogram_overlay.dart';
import 'controls/customization/histogram_view.dart';
import 'controls/customization/color_tools.dart';
import 'controls/skins/skins.dart';
import 'controls/display/chart.dart';
import 'controls/display/artifact_card.dart';
import 'controls/display/bubble.dart';
import 'controls/display/display.dart';
import 'controls/display/avatar.dart';
import 'controls/display/canvas_control.dart';
import 'controls/display/glyph_button.dart';
import 'controls/display/line_plot.dart';
import 'controls/display/outline.dart';
import 'controls/display/pie_plot.dart';
import 'controls/display/error_state.dart';
import 'controls/display/html_view.dart';
import 'controls/display/icon.dart';
import 'controls/display/markdown_view.dart';
import 'controls/effects/animated_background.dart';
import 'controls/effects/animation.dart';
import 'controls/effects/effects.dart';
import 'controls/effects/fold_layer.dart';
import 'controls/effects/flow_field.dart';
import 'controls/effects/liquid_morph.dart';
import 'controls/effects/morphing_border.dart';
import 'controls/effects/motion.dart';
import 'controls/effects/parallax.dart';
import 'controls/effects/particles.dart';
import 'controls/effects/pixelate.dart';
import 'controls/effects/ripple_burst.dart';
import 'controls/effects/particle_field.dart';
import 'controls/effects/noise_fx.dart';
import 'controls/effects/scanline_overlay.dart';
import 'controls/effects/shadow.dart';
import 'controls/effects/shimmer_shadow.dart';
import 'controls/effects/stagger.dart';
import 'controls/effects/transition.dart';
import 'controls/effects/visual_fx.dart';
import 'controls/effects/vignette.dart';
import 'controls/feedback/progress_bar.dart';
import 'controls/feedback/progress_ring.dart';
import 'controls/feedback/timeline.dart';
import 'controls/feedback/toast.dart';
import 'controls/feedback/tooltip.dart';
import 'controls/inputs/checkbox.dart';
import 'controls/inputs/chip.dart';
import 'controls/inputs/async_action_button.dart';
import 'controls/inputs/combobox.dart';
import 'controls/inputs/date_picker.dart';
import 'controls/inputs/file_picker.dart';
import 'controls/inputs/emoji_picker.dart';
import 'controls/inputs/form.dart';
import 'controls/inputs/field_group.dart';
import 'controls/inputs/icon_picker.dart';
import 'controls/inputs/keybind_recorder.dart';
import 'controls/inputs/option.dart';
import 'controls/inputs/radio.dart';
import 'controls/inputs/select.dart';
import 'controls/inputs/slider.dart';
import 'controls/inputs/switch.dart';
import 'controls/inputs/text_field.dart';
import 'controls/inputs/time_select.dart';
import 'controls/interaction/key_listener.dart';
import 'controls/interaction/drag_handle.dart';
import 'controls/interaction/drop_zone.dart';
import 'controls/interaction/gesture_area.dart';
import 'controls/interaction/hover_region.dart';
import 'controls/interaction/pressable.dart';
import 'controls/layout/card.dart';
import 'controls/layout/accordion.dart';
import 'controls/layout/align_control.dart';
import 'controls/layout/aspect_ratio.dart';
import 'controls/layout/clip.dart';
import 'controls/layout/column.dart';
import 'controls/layout/container.dart';
import 'controls/layout/decorated_box.dart';
import 'controls/layout/divider.dart';
import 'controls/layout/fitted_box.dart';
import 'controls/layout/page_view.dart';
import 'controls/layout/row.dart';
import 'controls/layout/safe_area.dart';
import 'controls/layout/scene_view.dart';
import 'controls/layout/scroll_view.dart';
import 'controls/layout/scrollable_column.dart';
import 'controls/layout/scrollable_row.dart';
import 'controls/layout/split_view.dart';
import 'controls/layout/stack.dart';
import 'controls/layout/flex_spacer.dart';
import 'controls/layout/frame.dart';
import 'controls/layout/grid.dart';
import 'controls/layout/vertical_divider.dart';
import 'controls/layout/window_frame.dart';
import 'controls/layout/window_drag_region.dart';
import 'controls/layout/window_controls.dart';
import 'controls/layout/wrap.dart';
import 'controls/lists/data_table.dart';
import 'controls/lists/data_grid.dart';
import 'controls/lists/data_source_view.dart';
import 'controls/lists/list_tile.dart';
import 'controls/lists/reorderable_list_view.dart';
import 'controls/lists/snap_grid.dart';
import 'controls/lists/sortable_header.dart';
import 'controls/lists/sticky_list.dart';
import 'controls/lists/table.dart';
import 'controls/lists/table_view.dart';
import 'controls/lists/virtual_grid.dart';
import 'controls/lists/virtual_list.dart';
import 'controls/media/audio.dart';
import 'controls/media/image.dart';
import 'controls/media/video.dart';
import 'controls/navigation/app_bar.dart';
import 'controls/navigation/action_bar.dart';
import 'controls/navigation/breadcrumb_bar.dart';
import 'controls/navigation/menu_bar.dart';
import 'controls/navigation/nav_ring.dart';
import 'controls/navigation/notice_bar.dart';
import 'controls/navigation/rail_nav.dart';
import 'controls/navigation/paginator.dart';
import 'controls/navigation/route.dart';
import 'controls/navigation/sidebar.dart';
import 'controls/navigation/status_bar.dart';
import 'controls/navigation/tabs.dart';
import 'controls/overlay/context_menu.dart';
import 'controls/overlay/alert_dialog.dart';
import 'controls/overlay/bottom_sheet.dart';
import 'controls/overlay/overlay.dart';
import 'controls/overlay/portal.dart';
import 'controls/overlay/popover.dart';
import 'controls/overlay/notification_center.dart';
import 'controls/overlay/preview_surface.dart';
import 'controls/overlay/snack_bar.dart';
import 'controls/overlay/slide_panel.dart';
import 'controls/overlay/splash.dart';
import 'controls/overlay/toast_host.dart';
import 'style/style_pack.dart';
import 'style/control_style_resolver.dart';
import 'style/style_packs.dart';
import 'controls/webview/webview.dart';
import 'webview/webview_api.dart';

Color _textToken(CandyTokens tokens) {
  return tokens.color('text') ?? const Color(0xff0f172a);
}

Color _surfaceToken(CandyTokens tokens) {
  return tokens.color('surface') ??
      tokens.color('background') ??
      const Color(0xffffffff);
}

Color _borderToken(CandyTokens tokens) {
  return tokens.color('border') ?? _textToken(tokens).withOpacity(0.2);
}

String _snakeCaseKey(String key) {
  if (key.isEmpty) return key;
  final buffer = StringBuffer();
  for (var i = 0; i < key.length; i += 1) {
    final char = key[i];
    final code = char.codeUnitAt(0);
    final isUpper = code >= 65 && code <= 90;
    if (isUpper) {
      if (i > 0 && key[i - 1] != '_') {
        buffer.write('_');
      }
      buffer.write(char.toLowerCase());
    } else if (char == '-' || char == ' ') {
      buffer.write('_');
    } else {
      buffer.write(char);
    }
  }
  return buffer.toString();
}

Object? _normalizeIncomingPropValue(Object? value) {
  if (value is Map) {
    return _normalizeIncomingProps(coerceObjectMap(value));
  }
  if (value is List) {
    return value.map(_normalizeIncomingPropValue).toList();
  }
  return value;
}

Map<String, Object?> _normalizeIncomingProps(Map<String, Object?> source) {
  final normalized = <String, Object?>{};
  source.forEach((key, value) {
    normalized[key] = _normalizeIncomingPropValue(value);
  });
  source.forEach((key, value) {
    final snake = _snakeCaseKey(key);
    if (snake != key && !normalized.containsKey(snake)) {
      normalized[snake] = _normalizeIncomingPropValue(value);
    }
  });

  const aliasMap = <String, String>{
    'bg_color': 'bgcolor',
    'background_color': 'bgcolor',
    'bordercolor': 'border_color',
    'borderwidth': 'border_width',
    'mainaxis': 'main_axis',
    'crossaxis': 'cross_axis',
    'mainaxissize': 'main_axis_size',
    'runspacing': 'run_spacing',
    'crossaxiscount': 'cross_axis_count',
    'mainaxisspacing': 'main_axis_spacing',
    'crossaxisspacing': 'cross_axis_spacing',
    'itemborderradius': 'item_border_radius',
    'showactions': 'show_actions',
    'showmeta': 'show_meta',
    'showselections': 'show_selections',
    'selectionmode': 'selection_mode',
    'enablereorder': 'enable_reorder',
    'enabledrag': 'enable_drag',
    'shrinkwrap': 'shrink_wrap',
    'usecontrolwidgets': 'use_control_widgets',
    'usecontrollayouts': 'use_control_layouts',
    'autoload': 'auto_load',
  };
  for (final entry in aliasMap.entries) {
    final from = entry.key;
    final to = entry.value;
    if (!normalized.containsKey(to) && normalized.containsKey(from)) {
      normalized[to] = normalized[from];
    }
  }
  return normalized;
}

class ControlRenderer {
  final CandyTokens tokens;
  final ButterflyUIControlRegistry registry;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;
  final ButterflyUISendRuntimeSystemEvent sendSystemEvent;
  final StylePack stylePack;
  final Map<String, Object?> styleTokens;

  ControlRenderer({
    required this.tokens,
    ButterflyUIControlRegistry? registry,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
    required this.sendSystemEvent,
    StylePack? stylePack,
    Map<String, Object?>? styleTokens,
  }) : registry = registry ?? ButterflyUIControlRegistry(),
       stylePack = stylePack ?? stylePackRegistry.defaultPack,
       styleTokens = styleTokens ?? const <String, Object?>{} {
    // Register candy controls into the registry
    registerCandyControls(this.registry);
    registerSkinsControls(this.registry);
  }

  Widget buildFromControl(
    Map<String, Object?> control, {
    Widget Function(BuildContext context, String nodeId, Widget child)?
    wrapWithControlBox,
    StylePack? inheritedPack,
  }) {
    final sourceType = control['type'];
    final type = (sourceType?.toString() ?? '').trim().toLowerCase();
    final controlId = control['id']?.toString() ?? '';
    final incomingProps = (control['props'] is Map)
        ? _normalizeIncomingProps(coerceObjectMap(control['props'] as Map))
        : <String, Object?>{};
    final baseProps = incomingProps;

    final basePack = inheritedPack ?? stylePack;
    final packName = baseProps['style_pack']?.toString();
    final resolvedPack = (packName == null || packName.isEmpty)
        ? basePack
        : stylePackRegistry.resolve(packName);
    final effectiveTokens = resolvedPack == stylePack
        ? tokens
        : resolvedPack.buildTokens(styleTokens);
    final resolvedStyle = ControlStyleResolver.resolve(
      controlType: type,
      props: baseProps,
      tokens: effectiveTokens,
      stylePack: resolvedPack,
    );
    final rawProps = _mergeResolvedStyleProps(
      controlType: type,
      props: baseProps,
      resolvedStyle: resolvedStyle,
    );

    Widget buildChild(Map<String, Object?> child) {
      return buildFromControl(
        child,
        wrapWithControlBox: wrapWithControlBox,
        inheritedPack: resolvedPack,
      );
    }

    final context = ButterflyUIControlContext(
      tokens: effectiveTokens,
      stylePack: resolvedPack,
      sendEvent: sendEvent,
      sendSystemEvent: sendSystemEvent,
      registerInvokeHandler: registerInvokeHandler,
      unregisterInvokeHandler: unregisterInvokeHandler,
      buildChild: buildChild,
    );

    final controlWithProps = <String, Object?>{
      ...control,
      'type': type,
      'props': rawProps,
    };

    Widget maybeWrap(Widget built) {
      if (wrapWithControlBox == null) return built;
      if (controlId.isEmpty) return built;
      return Builder(
        builder: (ctx) => wrapWithControlBox(ctx, controlId, built),
      );
    }

    Widget built;
    try {
      final registryBuilder = registry.builderFor(type);
      if (registryBuilder != null) {
        built = registryBuilder(context, controlWithProps);
      } else {
        final defaultBuilder =
            (ButterflyUIControlContext ctx, Map<String, Object?> node) {
              return _buildDefaultControl(ctx, node);
            };
        final override = resolvedPack.overrides[type];
        built = override == null
            ? defaultBuilder(context, controlWithProps)
            : override(context, controlWithProps, defaultBuilder);
      }

      built = _applyUniversalDecorators(
        built: built,
        controlType: type,
        controlId: controlId,
        props: rawProps,
        context: context,
        resolvedStyle: resolvedStyle,
      );
    } catch (error, stackTrace) {
      _reportRenderFailure(
        controlId: controlId,
        controlType: type,
        error: error,
        stackTrace: stackTrace,
      );
      built = _buildRenderFailureFallback(controlId, type, error);
    }
    return maybeWrap(built);
  }

  void _reportRenderFailure({
    required String controlId,
    required String controlType,
    required Object error,
    required StackTrace stackTrace,
  }) {
    try {
      sendSystemEvent('runtime.problem', {
        'source': 'flutter_renderer',
        'severity': 'error',
        'kind': 'control.render',
        'control_id': controlId,
        'control_type': controlType,
        'message': error.toString(),
        'stack': stackTrace.toString(),
      });
    } catch (_) {
      // Keep rendering resilient even if reporting fails.
    }
  }

  Widget _buildRenderFailureFallback(
    String controlId,
    String controlType,
    Object error,
  ) {
    final label = controlId.isEmpty ? controlType : '$controlType ($controlId)';
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3F2),
        border: Border.all(color: const Color(0xFFD92D20), width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          'Render failure: $label\n$error',
          style: const TextStyle(
            color: Color(0xFFB42318),
            fontSize: 12,
            height: 1.3,
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultControl(
    ButterflyUIControlContext context,
    Map<String, Object?> control,
  ) {
    final type = (control['type']?.toString() ?? '').toLowerCase();
    final controlId = control['id']?.toString() ?? '';
    final props = <String, Object?>{
      'control_type': type,
      ...context.propsOf(control),
    };
    final children = context.childMapsOf(control);
    final rawChildren = _rawChildren(control);
    final defaultText = _textToken(context.tokens);
    final defaultSurface = _surfaceToken(context.tokens);
    final defaultBorder = _borderToken(context.tokens);

    Widget firstChildOrEmpty() {
      if (children.isEmpty) return const SizedBox.shrink();
      return context.buildChild(children.first);
    }

    Widget mapChildPropOrEmpty(String key) {
      final raw = props[key];
      if (raw is Map) return context.buildChild(coerceObjectMap(raw));
      return const SizedBox.shrink();
    }

    // Candy umbrella - check registry for candy builder
    final candyBuilder = registry.builderFor('candy');
    if (candyBuilder != null) {
      final candyResult = candyBuilder(
        ButterflyUIControlContext(
          tokens: tokens,
          stylePack: stylePack,
          sendEvent: sendEvent,
          sendSystemEvent: sendSystemEvent,
          registerInvokeHandler: registerInvokeHandler,
          unregisterInvokeHandler: unregisterInvokeHandler,
          buildChild: context.buildChild,
        ),
        {
          'id': controlId,
          'type': 'candy',
          'props': props,
          'children': rawChildren,
        },
      );
      return candyResult;
    }

    switch (type) {
      case 'page':
      case 'page_scene':
        {
          Widget pageBody;
          if (children.isEmpty) {
            pageBody = const SizedBox.shrink();
          } else if (children.length == 1) {
            pageBody = context.buildChild(children.first);
          } else {
            pageBody = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children.map(context.buildChild).toList(),
            );
          }
          final safeArea = props['safe_area'] == null
              ? true
              : (props['safe_area'] == true);
          Widget body = pageBody;
          if (safeArea) {
            body = SafeArea(child: body);
          }
          final bg = coerceColor(props['bgcolor'] ?? props['background']);
          if (bg != null) {
            body = ColoredBox(color: bg, child: body);
          }
          return body;
        }

      case 'route':
      case 'route_view':
      case 'route_host':
        return buildRouteControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'surface':
      case 'box':
      case 'container':
        return buildContainerControl(props, rawChildren, context.buildChild);

      case 'decorated_box':
        return buildDecoratedBoxControl(props, rawChildren, context.buildChild);

      case 'frame':
        return buildFrameControl(props, rawChildren, context.buildChild);

      case 'align':
        return buildAlignControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'center':
        return buildAlignControl(
          controlId,
          <String, Object?>{'alignment': 'center', ...props},
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'aspect_ratio':
        return buildAspectRatioControl(props, rawChildren, context.buildChild);

      case 'fitted_box':
        return buildFittedBoxControl(props, rawChildren, context.buildChild);

      case 'clip':
        return buildClipControl(props, rawChildren, context.buildChild);

      case 'candy':
        final candyControl = buildCandyControl(
          controlId,
          props,
          rawChildren,
          tokens,
          sendEvent,
          registerInvokeHandler,
          unregisterInvokeHandler,
          context.buildChild,
        );
        return candyControl ?? const SizedBox.shrink();

      case 'gallery':
        return buildGalleryControl(
          controlId,
          props,
          rawChildren,
          context.tokens,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'gallery_scope':
        return buildGalleryScopeControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
        );

      case 'skins':
        {
          final skinsTokens = SkinsTokens.fromCandyTokens(context.tokens);
          return buildSkinsControl(
                controlId,
                props,
                rawChildren,
                skinsTokens,
                context.sendEvent,
                context.registerInvokeHandler,
                context.unregisterInvokeHandler,
                context.buildChild,
              ) ??
              const SizedBox.shrink();
        }

      case 'row':
        return buildRowControl(
          props,
          rawChildren,
          context.tokens,
          context.buildChild,
        );

      case 'column':
        return buildColumnControl(
          props,
          rawChildren,
          context.tokens,
          context.buildChild,
        );

      case 'stack':
        return buildStackControl(props, rawChildren, context.buildChild);

      case 'page_view':
        return buildPageViewControl(
          controlId,
          props,
          children.map(context.buildChild).toList(),
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'wrap':
        return buildWrapControl(
          props,
          rawChildren,
          context.tokens,
          context.buildChild,
        );

      case 'split_view':
      case 'split_pane':
        return buildSplitViewControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'accordion':
        return buildAccordionControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'pane':
        return buildContainerControl(props, rawChildren, context.buildChild);

      case 'expanded':
        {
          final flex = coerceOptionalInt(props['flex']) ?? 1;
          final fitRaw = props['fit']?.toString().toLowerCase();
          final fit = fitRaw == 'loose' ? FlexFit.loose : FlexFit.tight;
          final child = firstChildOrEmpty();
          if (fit == FlexFit.loose) {
            return Flexible(flex: flex, fit: fit, child: child);
          }
          return Expanded(flex: flex, child: child);
        }

      case 'flex_spacer':
      case 'spacer':
        return buildFlexSpacerControl(props);

      case 'scroll_view':
        return buildScrollViewControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'scrollable_column':
        return buildScrollableColumnControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'scrollable_row':
        return buildScrollableRowControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'safe_area':
        return buildSafeAreaControl(props, rawChildren, context.buildChild);

      case 'scene_view':
        return buildSceneViewControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'elevated_button':
        return buildElevatedButtonControl(
          controlId,
          props,
          context.tokens,
          context.sendEvent,
        );

      case 'filled_button':
        return buildFilledButtonControl(
          controlId,
          props,
          context.tokens,
          context.sendEvent,
        );

      case 'outlined_button':
        return buildOutlinedButtonControl(
          controlId,
          props,
          context.tokens,
          context.sendEvent,
        );

      case 'text_button':
        return buildTextButtonControl(
          controlId,
          props,
          context.tokens,
          context.sendEvent,
        );

      case 'divider':
        return buildDividerControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          registerInvokeHandler: context.registerInvokeHandler,
          unregisterInvokeHandler: context.unregisterInvokeHandler,
          fallbackColor: defaultBorder,
        );

      case 'vertical_divider':
        return buildVerticalDividerControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          registerInvokeHandler: context.registerInvokeHandler,
          unregisterInvokeHandler: context.unregisterInvokeHandler,
          fallbackColor: defaultBorder,
        );

      case 'text':
        {
          final textValue = (props['text'] ?? props['value'] ?? '').toString();
          final size = coerceDouble(props['size'] ?? props['font_size']);
          final weight = _parseFontWeight(
            props['weight'] ?? props['font_weight'],
          );
          final color =
              coerceColor(
                props['color'] ?? props['text_color'] ?? props['foreground'],
              ) ??
              defaultText;
          final align = _parseTextAlign(props['align']);
          final maxLines = coerceOptionalInt(props['max_lines']);
          final overflow =
              _parseTextOverflow(props['overflow']) ??
              (maxLines != null ? TextOverflow.ellipsis : null);
          final style = TextStyle(
            color: color,
            fontSize: size,
            fontWeight: weight,
            fontFamily: props['font_family']?.toString(),
            fontStyle: props['italic'] == true ? FontStyle.italic : null,
            letterSpacing: coerceDouble(props['letter_spacing']),
            wordSpacing: coerceDouble(props['word_spacing']),
          );
          if (props['selectable'] == true) {
            return SelectableText(
              textValue,
              style: style,
              textAlign: align,
              maxLines: maxLines,
            );
          }
          return Text(
            textValue,
            style: style,
            textAlign: align,
            maxLines: maxLines,
            overflow: overflow,
          );
        }

      case 'markdown_view':
        return buildMarkdownViewControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'chart':
      case 'line_chart':
      case 'line_plot':
      case 'bar_chart':
      case 'bar_plot':
        if ((type == 'line_plot')) {
          return buildLinePlotControl(
            controlId,
            props,
            context.registerInvokeHandler,
            context.unregisterInvokeHandler,
            context.sendEvent,
          );
        }
        return buildChartControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'artifact_card':
        return buildArtifactCardControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'canvas':
        return buildCanvasControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'sparkline':
      case 'spark_plot':
        return buildSparklineControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'html_view':
        return buildHtmlViewControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'problem_screen':
        return buildErrorStateControl(controlId, props, context.sendEvent);

      case 'icon':
        {
          final iconValue = props['icon'] ?? props['value'] ?? props['name'];
          final size = coerceDouble(props['size']);
          final color = coerceColor(props['color']);
          final tooltip = props['tooltip']?.toString();
          final widget =
              buildIconValue(iconValue, size: size, color: color) ??
              const Icon(Icons.help_outline);
          if (tooltip == null || tooltip.isEmpty) return widget;
          return Tooltip(message: tooltip, child: widget);
        }

      case 'emoji_icon':
        return buildEmojiIconControl(controlId, props, context.sendEvent);

      case 'avatar':
        return buildAvatarControl(controlId, props, context.sendEvent);

      case 'glyph_button':
        return buildGlyphButtonControl(controlId, props, context.sendEvent);

      case 'bubble':
        return buildBubbleControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'display':
        return buildDisplayControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'outline':
      case 'outline_view':
        return buildOutlineControl(controlId, props, context.sendEvent);

      case 'pie_plot':
        return buildPiePlotControl(controlId, props, context.sendEvent);

      case 'image':
        return buildImageControl(props, rawChildren, context.buildChild);

      case 'audio':
        return buildAudioControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'chat_message':
      case 'message_bubble':
      case 'chat_bubble':
        return buildBubbleControl(
          controlId,
          <String, Object?>{'variant': 'message', ...props},
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'chat_thread':
      case 'chat':
        return buildBubbleControl(
          controlId,
          <String, Object?>{'variant': 'thread', ...props},
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'message_composer':
      case 'prompt_composer':
        return buildBubbleControl(
          controlId,
          <String, Object?>{'variant': 'composer', ...props},
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'button':
        return buildButtonControl(
          controlId,
          props,
          context.tokens,
          context.sendEvent,
        );

      case 'icon_button':
        return buildIconButtonControl(controlId, props, context.sendEvent);

      case 'async_action_button':
        return buildAsyncActionButtonControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'text_field':
        return ButterflyUITextField(
          controlId: controlId,
          value: props['value']?.toString() ?? '',
          placeholder: props['placeholder']?.toString(),
          label: props['label']?.toString(),
          helperText: props['helper_text']?.toString(),
          errorText: props['error_text']?.toString(),
          multiline: props['multiline'] == true,
          minLines: coerceOptionalInt(props['min_lines']),
          maxLines: coerceOptionalInt(props['max_lines']),
          password: props['password'] == true,
          enabled: props['enabled'] == null ? true : (props['enabled'] == true),
          readOnly: props['read_only'] == true,
          autofocus: props['autofocus'] == true,
          dense: props['dense'] == true,
          emitOnChange: props['emit_on_change'] == null
              ? true
              : (props['emit_on_change'] == true),
          debounceMs: coerceOptionalInt(props['debounce_ms']) ?? 250,
          sendEvent: context.sendEvent,
        );

      case 'text_area':
        return ButterflyUITextField(
          controlId: controlId,
          value: props['value']?.toString() ?? '',
          placeholder: props['placeholder']?.toString(),
          label: props['label']?.toString(),
          helperText: props['helper_text']?.toString(),
          errorText: props['error_text']?.toString(),
          multiline: true,
          minLines: coerceOptionalInt(props['min_lines']) ?? 3,
          maxLines: coerceOptionalInt(props['max_lines']),
          password: false,
          enabled: props['enabled'] == null ? true : (props['enabled'] == true),
          readOnly: props['read_only'] == true,
          autofocus: props['autofocus'] == true,
          dense: props['dense'] == true,
          emitOnChange: props['emit_on_change'] == null
              ? true
              : (props['emit_on_change'] == true),
          debounceMs: coerceOptionalInt(props['debounce_ms']) ?? 250,
          sendEvent: context.sendEvent,
        );

      case 'checkbox':
        return ButterflyUICheckbox(
          controlId: controlId,
          label: props['label']?.toString(),
          value: _coerceBoolOrNull(props['value'] ?? props['checked']),
          enabled: props['enabled'] == null ? true : (props['enabled'] == true),
          tristate: props['tristate'] == true,
          registerInvokeHandler: context.registerInvokeHandler,
          unregisterInvokeHandler: context.unregisterInvokeHandler,
          sendEvent: context.sendEvent,
        );

      case 'switch':
        return ButterflyUISwitch(
          controlId: controlId,
          label: props['label']?.toString(),
          value: _coerceBool(props['value'], fallback: false),
          enabled: props['enabled'] == null ? true : (props['enabled'] == true),
          inline: props['inline'] == true,
          mode: props['mode']?.toString() ?? '',
          offLabel: props['off_label']?.toString(),
          onLabel: props['on_label']?.toString(),
          segments: _coerceStringList(props['segments']),
          sendEvent: context.sendEvent,
        );

      case 'radio':
        return ButterflyUIRadioGroup(
          controlId: controlId,
          options: coerceOptionList(props['options'] ?? props['items']),
          index: coerceOptionalInt(props['index']) ?? 0,
          explicitValue: props['value'] ?? props['selected'],
          label: props['label']?.toString(),
          enabled: props['enabled'] == null ? true : (props['enabled'] == true),
          dense: props['dense'] == true,
          sendEvent: context.sendEvent,
        );

      case 'slider':
        return ButterflyUISlider(
          controlId: controlId,
          value: coerceDouble(props['value']) ?? 0.0,
          start: coerceDouble(props['start']),
          end: coerceDouble(props['end']),
          min: coerceDouble(props['min']) ?? 0.0,
          max: coerceDouble(props['max']) ?? 100.0,
          divisions: coerceOptionalInt(props['divisions']),
          label: props['label']?.toString(),
          labels: props['labels'] == true,
          enabled: props['enabled'] == null ? true : (props['enabled'] == true),
          registerInvokeHandler: context.registerInvokeHandler,
          unregisterInvokeHandler: context.unregisterInvokeHandler,
          sendEvent: context.sendEvent,
        );

      case 'select':
        return ButterflyUISelect(
          controlId: controlId,
          options: coerceOptionList(props['options'] ?? props['items']),
          index: coerceOptionalInt(props['index']) ?? 0,
          explicitValue: props['value'] ?? props['selected'],
          enabled: props['enabled'] == null ? true : (props['enabled'] == true),
          dense: props['dense'] == true,
          label: props['label']?.toString(),
          hint: props['hint']?.toString() ?? props['placeholder']?.toString(),
          sendEvent: context.sendEvent,
        );

      case 'option':
        return buildOptionControl(controlId, props, context.sendEvent);

      case 'combo_box':
      case 'dropdown':
        return buildComboboxControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'date_picker':
        return buildDatePickerControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'time_select':
        return buildTimeSelectControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'chip':
        return buildChipControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'file_picker':
      case 'directory_picker':
        return buildFilePickerControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'emoji_picker':
        return buildEmojiPickerControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'icon_picker':
        return buildIconPickerControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'keybind_recorder':
        return buildKeybindRecorderControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'form':
        return buildFormControl(props, rawChildren, context.buildChild);

      case 'form_field':
        return buildFormFieldControl(props, rawChildren, context.buildChild);

      case 'modal':
      case 'alert_dialog':
        return buildAlertDialogControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'overlay':
        return buildOverlayControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.sendEvent,
        );

      case 'bottom_sheet':
        return buildBottomSheetControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'splash':
        return buildSplashControl(
          controlId,
          props,
          firstChildOrEmpty(),
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'popover':
        {
          final transition = props['transition'] is Map
              ? coerceObjectMap(props['transition'] as Map)
              : const <String, Object?>{};
          Widget anchor = const SizedBox.shrink();
          Widget content = const SizedBox.shrink();
          if (children.isNotEmpty) {
            anchor = context.buildChild(children.first);
          } else if (props['anchor'] is Map) {
            anchor = context.buildChild(
              coerceObjectMap(props['anchor'] as Map),
            );
          }
          if (children.length > 1) {
            content = context.buildChild(children[1]);
          } else if (props['content'] is Map) {
            content = context.buildChild(
              coerceObjectMap(props['content'] as Map),
            );
          }
          return ButterflyUIPopover(
            controlId: controlId,
            anchor: anchor,
            content: content,
            open: props['open'] == true,
            position: props['position']?.toString() ?? 'bottom',
            offset: _parseOffset(props['offset']) ?? Offset.zero,
            dismissible: props['dismissible'] == null
                ? true
                : (props['dismissible'] == true),
            duration: Duration(
              milliseconds:
                  (coerceOptionalInt(
                            props['duration_ms'] ?? transition['duration_ms'],
                          ) ??
                          180)
                      .clamp(0, 2000),
            ),
            transitionType:
                (props['transition_type']?.toString() ??
                        transition['type']?.toString() ??
                        'fade')
                    .toLowerCase(),
            transitionCurve: _curveFromName(
              transition['curve']?.toString() ?? 'ease_out_cubic',
            ),
            scrimColor: coerceColor(props['scrim_color']),
            sendEvent: context.sendEvent,
          );
        }

      case 'portal':
        return buildPortalControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.sendEvent,
        );

      case 'context_menu':
        {
          final child = children.isNotEmpty
              ? context.buildChild(children.first)
              : mapChildPropOrEmpty('child');
          return buildContextMenuControl(
            controlId,
            props,
            child,
            context.sendEvent,
          );
        }

      case 'tooltip':
        {
          final message = (props['message'] ?? props['text'] ?? '').toString();
          if (message.isEmpty) return firstChildOrEmpty();
          return ButterflyUITooltipWidget(
            message: message,
            preferBelow: props['prefer_below'] == null
                ? true
                : (props['prefer_below'] == true),
            waitMs: coerceOptionalInt(props['wait_ms']) ?? 0,
            child: firstChildOrEmpty(),
          );
        }

      case 'toast':
        return ButterflyUIToastWidget(
          controlId: controlId,
          message: (props['message'] ?? props['text'] ?? '').toString(),
          label: props['label']?.toString(),
          open: props['open'] == true,
          durationMs: coerceOptionalInt(props['duration_ms']) ?? 2400,
          actionLabel: props['action_label']?.toString(),
          variant: props['variant']?.toString(),
          style: props['style']?.toString(),
          icon: parseIconDataLoose(props['icon']),
          animation: props['animation'] is Map
              ? coerceObjectMap(props['animation'] as Map)
              : null,
          instant: props['instant'] == true,
          priority: coerceOptionalInt(props['priority']) ?? 0,
          useFlushbar: props['use_flushbar'] == true,
          useFlutterToast: props['use_fluttertoast'] == true,
          toastPosition: props['toast_position']?.toString(),
          sendEvent: context.sendEvent,
        );

      case 'snackbar':
      case 'snack_bar':
        return buildSnackBarControl(controlId, props, context.sendEvent);

      case 'toast_host':
      case 'notification_host':
        return buildToastHostControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'notification_center':
        return buildNotificationCenterControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'preview_surface':
        return buildPreviewSurfaceControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.sendEvent,
        );

      case 'progress_bar':
        return buildProgressBarControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'progress_ring':
        return buildProgressRingControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'tabs':
        {
          final labels = _coerceStringList(props['labels']);
          final tabChildren = children.map(context.buildChild).toList();
          return ButterflyUITabsWidget(
            controlId: controlId,
            labels: labels,
            children: tabChildren,
            index: coerceOptionalInt(props['index']) ?? 0,
            scrollable: props['scrollable'] == true,
            closable: props['closable'] == true,
            showAdd: props['show_add'] == true,
            sendEvent: context.sendEvent,
          );
        }

      case 'menu_bar':
        return buildMenuBarControl(controlId, props, context.sendEvent);

      case 'action_bar':
      case 'context_action_bar':
        return buildActionBarControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'menu_item':
        return buildMenuItemControl(controlId, props, context.sendEvent);

      case 'breadcrumbs':
      case 'breadcrumb_bar':
      case 'crumb_trail':
        return buildBreadcrumbBarControl(controlId, props, context.sendEvent);

      case 'status_bar':
        return buildStatusBarControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'navigator':
        return ButterflyUISidebar(
          controlId: controlId,
          sections: _coerceSidebarSections(props),
          selectedId:
              props['selected_id']?.toString() ??
              props['selected']?.toString() ??
              props['value']?.toString(),
          showSearch: props['show_search'] == true,
          query: props['query']?.toString() ?? '',
          collapsible: props['collapsible'] == true,
          dense: props['dense'] == true,
          emitOnSearchChange: props['emit_on_search_change'] == null
              ? true
              : (props['emit_on_search_change'] == true),
          searchDebounceMs: coerceOptionalInt(props['search_debounce_ms']) ?? 180,
          events: _coerceStringList(props['events']).toSet(),
          registerInvokeHandler: context.registerInvokeHandler,
          unregisterInvokeHandler: context.unregisterInvokeHandler,
          sendEvent: context.sendEvent,
        );

      case 'nav_ring':
        return buildNavRingControl(controlId, props, context.sendEvent);

      case 'rail_nav':
        return buildRailNavControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'notice_bar':
        return buildNoticeBarControl(controlId, props, context.sendEvent);

      case 'pagination':
      case 'paginator':
      case 'page_nav':
      case 'page_stepper':
        return buildPaginatorControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'sidebar':
        return ButterflyUISidebar(
          controlId: controlId,
          sections: _coerceSidebarSections(props),
          selectedId:
              props['selected_id']?.toString() ??
              props['selected']?.toString() ??
              props['value']?.toString(),
          showSearch: props['show_search'] == true,
          query: props['query']?.toString() ?? '',
          collapsible: props['collapsible'] == true,
          dense: props['dense'] == true,
          emitOnSearchChange: props['emit_on_search_change'] == null
              ? true
              : (props['emit_on_search_change'] == true),
          searchDebounceMs:
              coerceOptionalInt(props['search_debounce_ms']) ?? 180,
          events: _coerceStringList(props['events']).toSet(),
          registerInvokeHandler: context.registerInvokeHandler,
          unregisterInvokeHandler: context.unregisterInvokeHandler,
          sendEvent: context.sendEvent,
        );

      case 'app_bar':
      case 'top_bar':
        {
          final hasLeadingProp = props['leading'] is Map;
          final hasActionsProp =
              props['actions'] is List && (props['actions'] as List).isNotEmpty;
          final hasSlotProps = hasLeadingProp || hasActionsProp;

          final leading = hasLeadingProp
              ? context.buildChild(coerceObjectMap(props['leading'] as Map))
              : (!hasSlotProps && children.isNotEmpty
                    ? context.buildChild(children.first)
                    : null);
          final actions = <Widget>[];
          if (props['actions'] is List) {
            for (final item in props['actions'] as List) {
              if (item is Map) {
                actions.add(context.buildChild(coerceObjectMap(item)));
              }
            }
          }
          if (!hasSlotProps) {
            for (var i = leading == null ? 0 : 1; i < children.length; i += 1) {
              actions.add(context.buildChild(children[i]));
            }
          }
          return ButterflyUIAppBar(
            controlId: controlId,
            title: props['title']?.toString(),
            subtitle: props['subtitle']?.toString(),
            centerTitle: props['center_title'] == true,
            height: coerceDouble(props['height']) ?? kToolbarHeight,
            bgcolor: coerceColor(props['bgcolor']),
            elevation: coerceDouble(props['elevation']) ?? 0.0,
            padding:
                coercePadding(props['padding']) ??
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            leading: leading,
            actions: actions,
            showSearch: props['show_search'] == true,
            searchValue: props['search_value']?.toString() ?? '',
            searchPlaceholder: props['search_placeholder']?.toString(),
            searchEnabled: props['search_enabled'] == null
                ? true
                : (props['search_enabled'] == true),
            emitOnSearchChange: props['emit_on_search_change'] == null
                ? true
                : (props['emit_on_search_change'] == true),
            searchDebounceMs:
                coerceOptionalInt(props['search_debounce_ms']) ?? 180,
            events: _coerceStringList(props['events']).toSet(),
            registerInvokeHandler: context.registerInvokeHandler,
            unregisterInvokeHandler: context.unregisterInvokeHandler,
            sendEvent: context.sendEvent,
          );
        }

      case 'drawer':
      case 'slide_panel':
      case 'side_panel':
      case 'side_drawer':
        {
          final child = children.isNotEmpty
              ? context.buildChild(children.first)
              : mapChildPropOrEmpty('child');
          return ButterflyUISlidePanel(
            controlId: controlId,
            child: child,
            open: props['open'] == true,
            side: _normalizePanelSide(props['side']?.toString()),
            size: coerceDouble(props['size']) ?? 280,
            scrimColor: coerceColor(props['scrim_color']),
            dismissible: props['dismissible'] == null
                ? true
                : (props['dismissible'] == true),
            sendEvent: context.sendEvent,
          );
        }

      case 'overlay_host':
        return buildOverlayControl(
          controlId,
          <String, Object?>{'open': true, ...props},
          rawChildren,
          context.buildChild,
          context.sendEvent,
        );

      case 'window_frame':
        return buildWindowFrameControl(
          controlId,
          props,
          context.tokens,
          rawChildren,
          context.buildChild,
          context.sendEvent,
        );

      case 'window_controls':
        return buildWindowControlsControl(controlId, props, context.sendEvent);

      case 'window_drag_region':
        return buildWindowDragRegionControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.sendEvent,
        );

      case 'list_tile':
      case 'item_tile':
        return buildListTileControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'reorderable_list_view':
        return buildReorderableListViewControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'timeline':
        return buildTimelineControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'virtual_list':
        return buildVirtualListControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'virtual_grid':
        return buildVirtualGridControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'snap_grid':
        return buildSnapGridControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.sendEvent,
        );

      case 'sticky_list':
        return buildStickyListControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.sendEvent,
        );

      case 'list_view':
        {
          final axis = _parseAxis(props['direction']) ?? Axis.vertical;
          final reverse = props['reverse'] == true;
          final shrinkWrap = props['shrink_wrap'] == true;
          final scrollable = props['scrollable'] == null
              ? true
              : (props['scrollable'] == true);
          final primary = axis == Axis.vertical
              ? (props['primary'] == true)
              : false;
          final ScrollPhysics? physics = scrollable
              ? null
              : const NeverScrollableScrollPhysics();
          final padding = coercePadding(
            props['content_padding'] ?? props['padding'],
          );
          final separator = props['separator'] == true;
          final itemWidgets = <Widget>[];
          if (children.isNotEmpty) {
            itemWidgets.addAll(children.map(context.buildChild));
          } else if (props['items'] is List) {
            final items = props['items'] as List;
            for (var i = 0; i < items.length; i += 1) {
              final item = items[i];
              if (item is Map) {
                final map = coerceObjectMap(item);
                final id = map['id']?.toString() ?? '$i';
                final title =
                    map['title']?.toString() ?? map['label']?.toString() ?? id;
                final subtitle = map['subtitle']?.toString();
                itemWidgets.add(
                  ListTile(
                    title: Text(title),
                    subtitle: subtitle == null ? null : Text(subtitle),
                    onTap: controlId.isEmpty
                        ? null
                        : () {
                            context.sendEvent(controlId, 'select', {
                              'id': id,
                              'index': i,
                              'item': map,
                            });
                          },
                  ),
                );
              } else {
                itemWidgets.add(
                  ListTile(
                    title: Text(item?.toString() ?? ''),
                    onTap: controlId.isEmpty
                        ? null
                        : () {
                            context.sendEvent(controlId, 'select', {
                              'index': i,
                              'value': item?.toString() ?? '',
                            });
                          },
                  ),
                );
              }
            }
          }
          if (separator && itemWidgets.length > 1) {
            return ListView.separated(
              scrollDirection: axis,
              reverse: reverse,
              shrinkWrap: shrinkWrap,
              primary: primary,
              physics: physics,
              padding: padding,
              itemCount: itemWidgets.length,
              itemBuilder: (_, index) => itemWidgets[index],
              separatorBuilder: (_, __) => const Divider(height: 1),
            );
          }
          return ListView(
            scrollDirection: axis,
            reverse: reverse,
            shrinkWrap: shrinkWrap,
            primary: primary,
            physics: physics,
            padding: padding,
            children: itemWidgets,
          );
        }

      case 'grid_view':
      case 'grid':
        {
          return buildGridControl(
            controlId,
            props,
            children,
            context.buildChild,
            context.sendEvent,
          );
        }

      case 'card':
        return buildCardControl(
          props,
          rawChildren,
          context.tokens,
          context.buildChild,
        );

      case 'field_group':
        return buildFieldGroupControl(props, rawChildren, context.buildChild);

      case 'table':
        return ButterflyUITableView(
          controlId: controlId,
          props: props,
          registerInvokeHandler: context.registerInvokeHandler,
          unregisterInvokeHandler: context.unregisterInvokeHandler,
          sendEvent: context.sendEvent,
          columns: _coerceTableColumns(props['columns']),
          rows: _coerceTableRows(props['rows']),
          dense: props['dense'] == true,
          striped: props['striped'] == true,
          showHeader: props['show_header'] == null
              ? true
              : (props['show_header'] == true),
        );

      case 'data_table':
        return buildDataTableControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'data_grid':
        return buildDataGridControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'table_view':
        return buildTableViewControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'sortable_header':
        return buildSortableHeaderControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'data_source_view':
        return buildDataSourceViewControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'drag_handle':
        return buildDragHandleControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.sendEvent,
        );

      case 'drop_zone':
        return buildDropZoneControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.sendEvent,
        );

      case 'sprite':
        return buildImageControl(props, rawChildren, context.buildChild);

      case 'key_listener':
        return ButterflyUIKeyListener(
          controlId: controlId,
          child: firstChildOrEmpty(),
          autofocus: props['autofocus'] == true,
          enabled: props['enabled'] == null ? true : (props['enabled'] == true),
          sendEvent: context.sendEvent,
        );

      case 'gesture_area':
        return buildGestureAreaControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.sendEvent,
        );

      case 'hover_region':
        return buildHoverRegionControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.sendEvent,
        );

      case 'pressable':
        return buildPressableControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.sendEvent,
        );

      case 'animated_background':
        return buildAnimatedBackgroundControl(
          props,
          rawChildren,
          context.buildChild,
        );

      case 'fold_layer':
        return buildFoldLayerControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'liquid_morph':
        return buildLiquidMorphControl(props, rawChildren, context.buildChild);

      case 'morphing_border':
        return buildMorphingBorderControl(
          props,
          rawChildren,
          context.buildChild,
        );

      case 'motion':
        return buildMotionControl(props, rawChildren, context.buildChild);

      case 'animation':
        return buildAnimationControl(props, rawChildren, context.buildChild);

      case 'transition':
        return buildTransitionControl(props, rawChildren, context.buildChild);

      case 'stagger':
        return buildStaggerControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'parallax':
        return buildParallaxControl(props, rawChildren, context.buildChild);

      case 'flow_field':
        return buildFlowFieldControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'animated_gradient':
        return buildAnimatedGradientControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'avatar_stack':
        return buildAvatarStackControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'badge':
        return buildBadgeControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'crop_box':
        return buildCropBoxControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'histogram_view':
        return buildHistogramViewControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'histogram_overlay':
        return buildHistogramOverlayControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'ownership_marker':
        return buildDisplayControl(
          controlId,
          <String, Object?>{'variant': 'ownership', ...props},
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'blend_mode_picker':
        return buildBlendModePickerControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'blob_field':
        return buildBlobFieldControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'border':
        return buildBorderControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
        );

      case 'border_side':
        return buildBorderSideControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
        );

      case 'button_style':
        return buildButtonStyleControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'color_picker':
        return buildColorPickerControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'color_tools':
        return buildColorToolsControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'container_style':
        return buildContainerStyleControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'gradient':
        return buildGradientControl(
          props,
          rawChildren,
          context.buildChild,
          controlId: controlId,
          registerInvokeHandler: context.registerInvokeHandler,
          unregisterInvokeHandler: context.unregisterInvokeHandler,
          sendEvent: context.sendEvent,
        );

      case 'gradient_editor':
        return buildGradientEditorControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'particle_field':
        return buildParticleFieldControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'particles':
        return buildParticlesControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'scanline_overlay':
        return buildScanlineOverlayControl(
          controlId,
          props,
          firstChildOrEmpty(),
          defaultText: defaultText,
          registerInvokeHandler: context.registerInvokeHandler,
          unregisterInvokeHandler: context.unregisterInvokeHandler,
        );

      case 'pixelate':
        return buildPixelateControl(controlId, props, firstChildOrEmpty());

      case 'vignette':
        return buildVignetteControl(
          controlId,
          props,
          firstChildOrEmpty(),
          defaultColor: defaultText.withOpacity(0.9),
          registerInvokeHandler: context.registerInvokeHandler,
          unregisterInvokeHandler: context.unregisterInvokeHandler,
        );

      case 'glow_effect':
        return buildGlowEffectControl(props, firstChildOrEmpty());

      case 'glass_blur':
        return buildGlassBlurControl(
          controlId,
          props,
          firstChildOrEmpty(),
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'chromatic_shift':
        return buildChromaticShiftControl(
          controlId,
          props,
          firstChildOrEmpty(),
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'neon_edge':
        return buildNeonEdgeControl(props, firstChildOrEmpty());

      case 'grain_overlay':
        return buildGrainOverlayControl(
          controlId,
          props,
          firstChildOrEmpty(),
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'noise_displacement':
        return buildNoiseDisplacementControl(
          controlId,
          props,
          firstChildOrEmpty(),
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'noise_field':
        return buildNoiseFieldControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'gradient_sweep':
        return buildGradientSweepControl(
          controlId,
          props,
          firstChildOrEmpty(),
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'shimmer':
        return buildShimmerControl(
          controlId,
          props,
          firstChildOrEmpty(),
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
        );

      case 'shimmer_shadow':
        return buildShimmerShadowControl(
          controlId,
          props,
          firstChildOrEmpty(),
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
        );

      case 'shadow_stack':
        return buildShadowStackControl(props, firstChildOrEmpty());

      case 'shadow':
        return buildShadowControl(props, firstChildOrEmpty());

      case 'effects':
        return buildEffectsControl(props, firstChildOrEmpty());

      case 'visual_fx':
        return buildVisualFxControl(
          controlId,
          props,
          firstChildOrEmpty(),
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'confetti_burst':
        return buildConfettiBurstControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'ripple_burst':
        return buildRippleBurstControl(
          controlId,
          props,
          firstChildOrEmpty(),
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'video':
        return buildVideoControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'webview':
      case 'webview_adapter':
      case 'native_preview_host':
        return buildWebViewControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      default:
        return _unknownControl(type, props, defaultSurface, defaultText);
    }
  }

  Map<String, Object?> _mergeResolvedStyleProps({
    required String controlType,
    required Map<String, Object?> props,
    required ResolvedControlStyle resolvedStyle,
  }) {
    final merged = <String, Object?>{...props};
    _mergeMissingEntries(merged, resolvedStyle.slot('surface'));
    _mergeMissingEntries(
      merged,
      _labelSlotDefaults(resolvedStyle.slot('label')),
    );
    _mergeMissingEntries(
      merged,
      _iconSlotDefaults(controlType, resolvedStyle.slot('icon')),
    );
    return merged;
  }

  void _mergeMissingEntries(
    Map<String, Object?> target,
    Map<String, Object?> source,
  ) {
    if (source.isEmpty) return;
    for (final entry in source.entries) {
      if (entry.value == null) continue;
      if (!target.containsKey(entry.key)) {
        target[entry.key] = entry.value;
      }
    }
  }

  Map<String, Object?> _labelSlotDefaults(Map<String, Object?> slot) {
    if (slot.isEmpty) return const <String, Object?>{};
    final out = <String, Object?>{};
    final textColor = slot['text_color'] ?? slot['foreground'] ?? slot['color'];
    if (textColor != null) {
      out['text_color'] = textColor;
      out['foreground'] = textColor;
    }
    final fontSize = slot['font_size'] ?? slot['size'];
    if (fontSize != null) out['font_size'] = fontSize;
    final fontWeight = slot['font_weight'] ?? slot['weight'];
    if (fontWeight != null) out['font_weight'] = fontWeight;
    if (slot['font_family'] != null) out['font_family'] = slot['font_family'];
    if (slot['italic'] != null) out['italic'] = slot['italic'];
    if (slot['letter_spacing'] != null) {
      out['letter_spacing'] = slot['letter_spacing'];
    }
    if (slot['word_spacing'] != null) {
      out['word_spacing'] = slot['word_spacing'];
    }
    if (slot['line_height'] != null) out['line_height'] = slot['line_height'];
    if (slot['max_lines'] != null) out['max_lines'] = slot['max_lines'];
    if (slot['overflow'] != null) out['overflow'] = slot['overflow'];
    final textAlign = slot['text_align'] ?? slot['align'];
    if (textAlign != null) out['align'] = textAlign;
    return out;
  }

  Map<String, Object?> _iconSlotDefaults(
    String controlType,
    Map<String, Object?> slot,
  ) {
    if (slot.isEmpty) return const <String, Object?>{};
    final out = <String, Object?>{};
    final isIconLike =
        controlType == 'icon' ||
        controlType == 'emoji_icon' ||
        controlType == 'glyph' ||
        controlType == 'glyph_button';

    final iconColor = slot['icon_color'] ?? slot['foreground'] ?? slot['color'];
    if (iconColor != null) {
      out['icon_color'] = iconColor;
      if (isIconLike) out['color'] = iconColor;
    }

    final iconSize = slot['icon_size'] ?? slot['size'] ?? slot['font_size'];
    if (iconSize != null) {
      out['icon_size'] = iconSize;
      if (isIconLike) out['size'] = iconSize;
    }
    if (slot['opacity'] != null) out['icon_opacity'] = slot['opacity'];
    return out;
  }

  Widget _applyUniversalDecorators({
    required Widget built,
    required String controlType,
    required String controlId,
    required Map<String, Object?> props,
    required ButterflyUIControlContext context,
    required ResolvedControlStyle resolvedStyle,
  }) {
    if (controlType == 'expanded' ||
        controlType == 'flex_spacer' ||
        controlType == 'spacer') {
      return built;
    }

    final surfaceStyle = resolvedStyle.slot('surface');

    final visible = (props['visible'] ?? surfaceStyle['visible']) == null
        ? true
        : ((props['visible'] ?? surfaceStyle['visible']) == true);
    if (!visible) return const SizedBox.shrink();

    final enabled = _isEnabled(props);

    final inheritedTextStyle = _coerceInheritedTextStyle(props, surfaceStyle);
    if (inheritedTextStyle != null) {
      built = DefaultTextStyle.merge(style: inheritedTextStyle, child: built);
    }
    final inheritedIconTheme = _coerceInheritedIconTheme(props, surfaceStyle);
    if (inheritedIconTheme != null) {
      built = IconTheme.merge(data: inheritedIconTheme, child: built);
    }

    final width = coerceDouble(props['width'] ?? surfaceStyle['width']);
    final height = coerceDouble(props['height'] ?? surfaceStyle['height']);
    if (width != null || height != null) {
      built = SizedBox(width: width, height: height, child: built);
    }

    final minWidth = coerceDouble(
      props['min_width'] ?? surfaceStyle['min_width'],
    );
    final minHeight = coerceDouble(
      props['min_height'] ?? surfaceStyle['min_height'],
    );
    final maxWidth = coerceDouble(
      props['max_width'] ?? surfaceStyle['max_width'],
    );
    final maxHeight = coerceDouble(
      props['max_height'] ?? surfaceStyle['max_height'],
    );
    if (minWidth != null ||
        minHeight != null ||
        maxWidth != null ||
        maxHeight != null) {
      built = ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: minWidth ?? 0,
          minHeight: minHeight ?? 0,
          maxWidth: maxWidth ?? double.infinity,
          maxHeight: maxHeight ?? double.infinity,
        ),
        child: built,
      );
    }

    final padding = coercePadding(props['padding'] ?? surfaceStyle['padding']);
    if (padding != null) {
      built = Padding(padding: padding, child: built);
    }

    final alignment = _parseAlignment(
      props['alignment'] ?? surfaceStyle['alignment'],
    );
    if (alignment != null) {
      built = Align(alignment: alignment, child: built);
    }

    final margin = coercePadding(props['margin'] ?? surfaceStyle['margin']);
    if (margin != null) {
      built = Padding(padding: margin, child: built);
    }

    final borderSpec = (props['border'] is Map)
        ? coerceObjectMap(props['border'] as Map)
        : (surfaceStyle['border'] is Map)
        ? coerceObjectMap(surfaceStyle['border'] as Map)
        : const <String, Object?>{};

    final bg = coerceColor(
      props['bgcolor'] ??
          props['background'] ??
          surfaceStyle['bgcolor'] ??
          surfaceStyle['background'] ??
          surfaceStyle['color'],
    );
    final borderColor = coerceColor(
      props['border_color'] ??
          borderSpec['color'] ??
          borderSpec['border_color'] ??
          surfaceStyle['border_color'],
    );
    final borderWidth = coerceDouble(
      props['border_width'] ??
          borderSpec['width'] ??
          borderSpec['border_width'] ??
          surfaceStyle['border_width'],
    );
    final borderRadius = _coerceBorderRadius(
      props['radius'] ??
          props['border_radius'] ??
          surfaceStyle['radius'] ??
          surfaceStyle['border_radius'],
    );
    final shape = _parseBoxShape(props['shape'] ?? surfaceStyle['shape']);
    final gradient = coerceGradient(
      props['gradient'] ?? surfaceStyle['gradient'],
    );
    final image = coerceDecorationImage(
      props['image'] ?? surfaceStyle['image'],
    );
    final boxShadow = coerceBoxShadow(
      props['shadow'] ?? surfaceStyle['shadow'],
    );
    final clipBehavior = _parseClipBehavior(
      props['clip_behavior'] ?? surfaceStyle['clip_behavior'] ?? props['clip'],
    );
    final backdropBlur = coerceDouble(
      props['backdrop_blur'] ??
          props['backdropBlur'] ??
          props['glass_blur'] ??
          surfaceStyle['backdrop_blur'] ??
          surfaceStyle['backdropBlur'] ??
          surfaceStyle['glass_blur'],
    );
    final backdropColor = coerceColor(
      props['backdrop_color'] ??
          props['backdropColor'] ??
          props['frost_color'] ??
          surfaceStyle['backdrop_color'] ??
          surfaceStyle['backdropColor'] ??
          surfaceStyle['frost_color'],
    );
    final blur = coerceDouble(props['blur'] ?? surfaceStyle['blur']);
    final elevation = coerceDouble(
      props['elevation'] ?? surfaceStyle['elevation'],
    );

    const nativeDecorationControls = <String>{
      'surface',
      'box',
      'container',
      'decorated_box',
    };
    final shouldApplyDecoration = !nativeDecorationControls.contains(
      controlType,
    );
    final hasDecoration =
        bg != null ||
        borderColor != null ||
        borderWidth != null ||
        borderRadius != null ||
        gradient != null ||
        image != null ||
        boxShadow != null ||
        shape == BoxShape.circle;
    if (shouldApplyDecoration && hasDecoration) {
      final border = (borderColor != null && (borderWidth ?? 0) > 0)
          ? Border.all(color: borderColor, width: borderWidth ?? 1.0)
          : null;
      built = DecoratedBox(
        decoration: BoxDecoration(
          color: bg,
          border: border,
          shape: shape,
          borderRadius: borderRadius,
          gradient: gradient,
          image: image,
          boxShadow: boxShadow,
        ),
        child: built,
      );
    }

    if (shouldApplyDecoration && (elevation ?? 0) > 0) {
      built = Material(
        type: MaterialType.transparency,
        elevation: elevation!,
        borderRadius: shape == BoxShape.circle ? null : borderRadius,
        clipBehavior: borderRadius == null ? Clip.none : Clip.antiAlias,
        child: built,
      );
    }

    if (shouldApplyDecoration && clipBehavior != Clip.none) {
      if (shape == BoxShape.circle) {
        built = ClipOval(clipBehavior: clipBehavior, child: built);
      } else if (borderRadius != null) {
        built = ClipRRect(
          borderRadius: borderRadius,
          clipBehavior: clipBehavior,
          child: built,
        );
      } else {
        built = ClipRect(clipBehavior: clipBehavior, child: built);
      }
    }

    if (shouldApplyDecoration &&
        ((backdropBlur ?? 0) > 0 || backdropColor != null)) {
      if (shape == BoxShape.circle) {
        built = ClipOval(child: built);
      } else if (borderRadius != null) {
        built = ClipRRect(
          borderRadius: borderRadius,
          clipBehavior: Clip.antiAlias,
          child: built,
        );
      } else {
        built = ClipRect(child: built);
      }
      if (backdropBlur != null && backdropBlur > 0) {
        built = BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: backdropBlur,
            sigmaY: backdropBlur,
          ),
          child: built,
        );
      }
      if (backdropColor != null) {
        built = DecoratedBox(
          decoration: BoxDecoration(
            color: backdropColor,
            shape: shape,
            borderRadius: shape == BoxShape.circle ? null : borderRadius,
          ),
          child: built,
        );
      }
    }

    if (shouldApplyDecoration && blur != null && blur > 0) {
      built = ImageFiltered(
        imageFilter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: built,
      );
    }

    final opacity = coerceDouble(props['opacity'] ?? surfaceStyle['opacity']);
    if (opacity != null && opacity >= 0 && opacity < 1) {
      built = Opacity(opacity: opacity.clamp(0.0, 1.0), child: built);
    }

    final tooltip = props['tooltip'] ?? surfaceStyle['tooltip'];
    if (tooltip != null && controlType != 'tooltip') {
      final message = tooltip is Map
          ? (coerceObjectMap(tooltip)['message']?.toString() ?? '')
          : tooltip.toString();
      if (message.isNotEmpty) {
        built = Tooltip(message: message, child: built);
      }
    }

    final cursor = _parseMouseCursor(props['cursor'] ?? surfaceStyle['cursor']);
    if (cursor != null) {
      built = MouseRegion(cursor: cursor, child: built);
    }

    final semanticLabel =
        (props['semantic_label'] ?? surfaceStyle['semantic_label'])?.toString();
    final role = (props['role'] ?? surfaceStyle['role'])?.toString();
    if (semanticLabel != null || role != null) {
      built = Semantics(
        label: semanticLabel,
        button: role == 'button',
        textField: role == 'textbox' || role == 'text_field',
        link: role == 'link',
        enabled: enabled,
        child: built,
      );
    }

    final modifierSource = props['modifiers'];
    final modifiers = modifierSource is List
        ? modifierSource.cast<Object?>()
        : resolvedStyle.defaultModifiers();
    final motionSpec = props['motion'] ?? resolvedStyle.defaultMotion();
    built = applyControlModifierChain(
      child: built,
      controlType: controlType,
      controlId: controlId,
      modifiers: modifiers,
      motion: motionSpec,
      tokens: context.tokens,
      motionPack: context.stylePack.motionPack,
      effectPresets: context.stylePack.effectPresets,
    );

    final events = _coerceStringList(props['events']);
    if (controlId.isNotEmpty && events.isNotEmpty) {
      built = ButterflyUIEventBox(
        controlId: controlId,
        controlType: controlType,
        props: props,
        events: events,
        enabled: enabled,
        sendEvent: context.sendEvent,
        registerInvokeHandler: context.registerInvokeHandler,
        unregisterInvokeHandler: context.unregisterInvokeHandler,
        child: built,
      );
    }

    final animation = props['animation'];
    if (animation is Map) {
      built = AnimationSpec.fromJson(coerceObjectMap(animation)).wrap(built);
    } else {
      final fallbackAnimation = _animationFromMotion(
        motionSpec,
        context.stylePack.motionPack,
      );
      if (fallbackAnimation != null) {
        built = AnimationSpec.fromJson(fallbackAnimation).wrap(built);
      }
    }

    if (!enabled) {
      built = IgnorePointer(ignoring: true, child: built);
    }

    return built;
  }

  Map<String, Object?>? _animationFromMotion(
    Object? motion,
    Map<String, Object?> motionPack,
  ) {
    if (motion == null) return null;
    final spec = ButterflyUIMotionPack.resolve(
      motion,
      pack: motionPack,
      fallbackName: 'normal',
    );
    final hasOffset =
        spec.beginOffset.dx != 0 ||
        spec.beginOffset.dy != 0 ||
        spec.endOffset.dx != 0 ||
        spec.endOffset.dy != 0;
    final hasScale = spec.beginScale != 1.0 || spec.endScale != 1.0;
    final preset = hasOffset ? 'slide_and_fade' : (hasScale ? 'scale' : 'fade');
    return <String, Object?>{
      'preset': preset,
      'duration_ms': spec.duration.inMilliseconds,
      'curve': 'ease_out',
      'offset': <double>[spec.beginOffset.dx, spec.beginOffset.dy],
    };
  }

  Widget _unknownControl(
    String type,
    Map<String, Object?> props,
    Color background,
    Color textColor,
  ) {
    if (props['message'] is String) {
      return Text(props['message'] as String);
    }
    return Container(
      color: background.withOpacity(0.4),
      padding: const EdgeInsets.all(8),
      child: Text('Unknown control: $type', style: TextStyle(color: textColor)),
    );
  }

  List<dynamic> _rawChildren(Map<String, Object?> control) {
    final raw = control['children'];
    if (raw is List) return raw;
    return const [];
  }

  bool _isEnabled(Map<String, Object?> props) {
    final enabled = props['enabled'] == null
        ? true
        : (props['enabled'] == true);
    if (props['disabled'] == true) return false;
    return enabled;
  }

  List<String> _coerceStringList(Object? value) {
    if (value is List) {
      return value
          .map((v) => v?.toString() ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
    }
    if (value == null) return const [];
    final single = value.toString();
    return single.isEmpty ? const [] : [single];
  }

  List<Map<String, Object?>> _coerceMapList(Object? value) {
    if (value is List) {
      return value.whereType<Map>().map((m) => coerceObjectMap(m)).toList();
    }
    return const [];
  }

  List<String> _coerceTableColumns(Object? value) {
    if (value is List) {
      final cols = <String>[];
      for (final item in value) {
        if (item is Map) {
          final map = coerceObjectMap(item);
          final label =
              map['label']?.toString() ??
              map['title']?.toString() ??
              map['id']?.toString();
          cols.add(label ?? '');
        } else {
          cols.add(item?.toString() ?? '');
        }
      }
      return cols;
    }
    return const [];
  }

  List<List<Object?>> _coerceTableRows(Object? value) {
    if (value is! List) return const [];
    final rows = <List<Object?>>[];
    for (final row in value) {
      if (row is List) {
        rows.add(row.cast<Object?>());
      } else if (row is Map) {
        final map = coerceObjectMap(row);
        if (map['cells'] is List) {
          rows.add((map['cells'] as List).cast<Object?>());
        } else {
          rows.add(map.values.toList());
        }
      } else {
        rows.add([row]);
      }
    }
    return rows;
  }

  List<Map<String, Object?>> _coerceSidebarSections(
    Map<String, Object?> props,
  ) {
    final sections = <Map<String, Object?>>[];
    final rawSections = props['sections'];
    if (rawSections is List) {
      for (final section in rawSections) {
        if (section is Map) {
          sections.add(coerceObjectMap(section));
        }
      }
      return sections;
    }
    final rawItems = props['items'];
    if (rawItems is List) {
      sections.add({
        'title': props['title']?.toString() ?? 'Menu',
        'items': rawItems,
      });
    }
    return sections;
  }

  TextStyle? _coerceInheritedTextStyle(
    Map<String, Object?> props,
    Map<String, Object?> surfaceStyle,
  ) {
    final color = coerceColor(
      props['text_color'] ??
          props['foreground'] ??
          surfaceStyle['text_color'] ??
          surfaceStyle['foreground'],
    );
    final size = coerceDouble(
      props['font_size'] ??
          props['size'] ??
          surfaceStyle['font_size'] ??
          surfaceStyle['size'],
    );
    final weight = _parseFontWeight(
      props['font_weight'] ??
          props['weight'] ??
          surfaceStyle['font_weight'] ??
          surfaceStyle['weight'],
    );
    final family = (props['font_family'] ?? surfaceStyle['font_family'])
        ?.toString();
    final italic = _coerceBoolOrNull(
      props.containsKey('italic') ? props['italic'] : surfaceStyle['italic'],
    );
    final letterSpacing = coerceDouble(
      props['letter_spacing'] ?? surfaceStyle['letter_spacing'],
    );
    final wordSpacing = coerceDouble(
      props['word_spacing'] ?? surfaceStyle['word_spacing'],
    );
    final lineHeight = coerceDouble(
      props['line_height'] ?? surfaceStyle['line_height'],
    );
    final hasStyle =
        color != null ||
        size != null ||
        weight != null ||
        family != null ||
        italic != null ||
        letterSpacing != null ||
        wordSpacing != null ||
        lineHeight != null;
    if (!hasStyle) return null;
    return TextStyle(
      color: color,
      fontSize: size,
      fontWeight: weight,
      fontFamily: family,
      fontStyle: italic == null
          ? null
          : (italic ? FontStyle.italic : FontStyle.normal),
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      height: lineHeight,
    );
  }

  IconThemeData? _coerceInheritedIconTheme(
    Map<String, Object?> props,
    Map<String, Object?> surfaceStyle,
  ) {
    final color = coerceColor(
      props['icon_color'] ??
          props['icon_foreground'] ??
          surfaceStyle['icon_color'] ??
          surfaceStyle['icon_foreground'],
    );
    final size = coerceDouble(props['icon_size'] ?? surfaceStyle['icon_size']);
    final opacity = coerceDouble(
      props['icon_opacity'] ?? surfaceStyle['icon_opacity'],
    );
    if (color == null && size == null && opacity == null) return null;
    return IconThemeData(color: color, size: size, opacity: opacity);
  }

  BorderRadius? _coerceBorderRadius(Object? value) {
    if (value == null) return null;
    if (value is num) {
      return BorderRadius.circular(value.toDouble());
    }
    final scalar = coerceDouble(value);
    if (scalar != null) {
      return BorderRadius.circular(scalar);
    }
    if (value is List) {
      final nums = value.map(coerceDouble).whereType<double>().toList();
      if (nums.isEmpty) return null;
      if (nums.length == 1) {
        return BorderRadius.circular(nums[0]);
      }
      if (nums.length == 2) {
        return BorderRadius.only(
          topLeft: Radius.circular(nums[0]),
          topRight: Radius.circular(nums[1]),
          bottomRight: Radius.circular(nums[0]),
          bottomLeft: Radius.circular(nums[1]),
        );
      }
      if (nums.length == 3) {
        return BorderRadius.only(
          topLeft: Radius.circular(nums[0]),
          topRight: Radius.circular(nums[1]),
          bottomRight: Radius.circular(nums[2]),
          bottomLeft: Radius.circular(nums[1]),
        );
      }
      return BorderRadius.only(
        topLeft: Radius.circular(nums[0]),
        topRight: Radius.circular(nums[1]),
        bottomRight: Radius.circular(nums[2]),
        bottomLeft: Radius.circular(nums[3]),
      );
    }
    if (value is Map) {
      final map = coerceObjectMap(value);
      final all = coerceDouble(map['all'] ?? map['radius']);
      if (all != null) {
        return BorderRadius.circular(all);
      }
      final tl = coerceDouble(map['top_left'] ?? map['tl']) ?? 0;
      final tr = coerceDouble(map['top_right'] ?? map['tr']) ?? 0;
      final br = coerceDouble(map['bottom_right'] ?? map['br']) ?? 0;
      final bl = coerceDouble(map['bottom_left'] ?? map['bl']) ?? 0;
      final hasAnyCorner =
          map.containsKey('top_left') ||
          map.containsKey('top_right') ||
          map.containsKey('bottom_right') ||
          map.containsKey('bottom_left') ||
          map.containsKey('tl') ||
          map.containsKey('tr') ||
          map.containsKey('br') ||
          map.containsKey('bl');
      if (!hasAnyCorner) return null;
      return BorderRadius.only(
        topLeft: Radius.circular(tl),
        topRight: Radius.circular(tr),
        bottomRight: Radius.circular(br),
        bottomLeft: Radius.circular(bl),
      );
    }
    return null;
  }

  BoxShape _parseBoxShape(Object? value) {
    if (value is Map) {
      final map = coerceObjectMap(value);
      return _parseBoxShape(map['type'] ?? map['shape']);
    }
    final normalized = value
        ?.toString()
        .toLowerCase()
        .replaceAll('-', '_')
        .replaceAll(' ', '_');
    if (normalized == 'circle' || normalized == 'oval') {
      return BoxShape.circle;
    }
    return BoxShape.rectangle;
  }

  Clip _parseClipBehavior(Object? value) {
    if (value is bool) {
      return value ? Clip.antiAlias : Clip.none;
    }
    if (value is num) {
      return value == 0 ? Clip.none : Clip.antiAlias;
    }
    final normalized = value
        ?.toString()
        .toLowerCase()
        .replaceAll('-', '_')
        .replaceAll(' ', '_');
    switch (normalized) {
      case null:
      case '':
      case 'none':
      case 'off':
      case 'false':
        return Clip.none;
      case 'hard':
      case 'hard_edge':
      case 'hardedge':
        return Clip.hardEdge;
      case 'anti_alias_with_save_layer':
      case 'anti_alias_save_layer':
      case 'antialiaswithsavelayer':
        return Clip.antiAliasWithSaveLayer;
      default:
        return Clip.antiAlias;
    }
  }

  TextAlign? _parseTextAlign(Object? value) {
    final s = value?.toString().toLowerCase();
    switch (s) {
      case 'left':
      case 'start':
        return TextAlign.start;
      case 'right':
      case 'end':
        return TextAlign.end;
      case 'center':
        return TextAlign.center;
      case 'justify':
        return TextAlign.justify;
    }
    return null;
  }

  TextOverflow? _parseTextOverflow(Object? value) {
    final s = value?.toString().toLowerCase();
    switch (s) {
      case 'clip':
        return TextOverflow.clip;
      case 'fade':
        return TextOverflow.fade;
      case 'visible':
        return TextOverflow.visible;
      case 'ellipsis':
        return TextOverflow.ellipsis;
    }
    return null;
  }

  FontWeight? _parseFontWeight(Object? value) {
    if (value == null) return null;
    if (value is int) return _fontWeightFromInt(value);
    final s = value.toString().toLowerCase();
    if (s == 'bold') return FontWeight.bold;
    if (s == 'normal') return FontWeight.normal;
    if (s.startsWith('w')) {
      final numVal = int.tryParse(s.substring(1));
      if (numVal != null) return _fontWeightFromInt(numVal);
    }
    final parsed = int.tryParse(s);
    if (parsed != null) return _fontWeightFromInt(parsed);
    return null;
  }

  FontWeight? _fontWeightFromInt(int value) {
    switch (value) {
      case 100:
        return FontWeight.w100;
      case 200:
        return FontWeight.w200;
      case 300:
        return FontWeight.w300;
      case 400:
        return FontWeight.w400;
      case 500:
        return FontWeight.w500;
      case 600:
        return FontWeight.w600;
      case 700:
        return FontWeight.w700;
      case 800:
        return FontWeight.w800;
      case 900:
        return FontWeight.w900;
      default:
        return null;
    }
  }

  Axis? _parseAxis(Object? value) {
    final s = value?.toString().toLowerCase();
    switch (s) {
      case 'horizontal':
      case 'row':
      case 'x':
        return Axis.horizontal;
      case 'vertical':
      case 'column':
      case 'y':
        return Axis.vertical;
    }
    return null;
  }

  Alignment? _parseAlignment(Object? value) {
    if (value == null) return null;
    if (value is List && value.length >= 2) {
      final x = coerceDouble(value[0]) ?? 0.0;
      final y = coerceDouble(value[1]) ?? 0.0;
      return Alignment(x, y);
    }
    if (value is Map) {
      final map = coerceObjectMap(value);
      final x = coerceDouble(map['x']);
      final y = coerceDouble(map['y']);
      if (x != null || y != null) {
        return Alignment(x ?? 0.0, y ?? 0.0);
      }
    }
    final s = value
        .toString()
        .toLowerCase()
        .replaceAll('-', '_')
        .replaceAll(' ', '_');
    switch (s) {
      case 'center':
        return Alignment.center;
      case 'top':
      case 'top_center':
        return Alignment.topCenter;
      case 'bottom':
      case 'bottom_center':
        return Alignment.bottomCenter;
      case 'left':
      case 'center_left':
      case 'start':
        return Alignment.centerLeft;
      case 'right':
      case 'center_right':
      case 'end':
        return Alignment.centerRight;
      case 'top_left':
        return Alignment.topLeft;
      case 'top_right':
        return Alignment.topRight;
      case 'bottom_left':
        return Alignment.bottomLeft;
      case 'bottom_right':
        return Alignment.bottomRight;
    }
    return null;
  }

  Offset? _parseOffset(Object? value) {
    if (value is List && value.length >= 2) {
      final x = coerceDouble(value[0]) ?? 0.0;
      final y = coerceDouble(value[1]) ?? 0.0;
      return Offset(x, y);
    }
    if (value is Map) {
      final map = coerceObjectMap(value);
      final x = coerceDouble(map['x']) ?? 0.0;
      final y = coerceDouble(map['y']) ?? 0.0;
      return Offset(x, y);
    }
    return null;
  }

  Rect? _coerceRect(Object? value) {
    if (value is List && value.length >= 4) {
      final x = coerceDouble(value[0]) ?? 0.0;
      final y = coerceDouble(value[1]) ?? 0.0;
      final w = coerceDouble(value[2]) ?? 0.0;
      final h = coerceDouble(value[3]) ?? 0.0;
      return Rect.fromLTWH(x, y, w, h);
    }
    if (value is Map) {
      final map = coerceObjectMap(value);
      final x = coerceDouble(map['x'] ?? map['left']) ?? 0.0;
      final y = coerceDouble(map['y'] ?? map['top']) ?? 0.0;
      final width = coerceDouble(map['width']) ?? 0.0;
      final height = coerceDouble(map['height']) ?? 0.0;
      return Rect.fromLTWH(x, y, width, height);
    }
    return null;
  }

  Curve _curveFromName(String? name) {
    final normalized = (name ?? '')
        .toLowerCase()
        .replaceAll('-', '_')
        .replaceAll(' ', '_');
    switch (normalized) {
      case 'linear':
        return Curves.linear;
      case 'easein':
      case 'ease_in':
        return Curves.easeIn;
      case 'easeout':
      case 'ease_out':
        return Curves.easeOut;
      case 'easeinout':
      case 'ease_in_out':
        return Curves.easeInOut;
      case 'fastoutslowin':
      case 'fast_out_slow_in':
        return Curves.fastOutSlowIn;
      case 'easeoutcubic':
      case 'ease_out_cubic':
      default:
        return Curves.easeOutCubic;
    }
  }

  MouseCursor? _parseMouseCursor(Object? value) {
    if (value == null) return null;
    final s = value.toString().toLowerCase().replaceAll('-', '_');
    switch (s) {
      case 'click':
      case 'pointer':
        return SystemMouseCursors.click;
      case 'text':
        return SystemMouseCursors.text;
      case 'move':
        return SystemMouseCursors.move;
      case 'forbidden':
      case 'no_drop':
        return SystemMouseCursors.forbidden;
      case 'resize_left_right':
      case 'resize_horizontal':
        return SystemMouseCursors.resizeLeftRight;
      case 'resize_up_down':
      case 'resize_vertical':
        return SystemMouseCursors.resizeUpDown;
      case 'resize_up_left_down_right':
        return SystemMouseCursors.resizeUpLeftDownRight;
      case 'resize_up_right_down_left':
        return SystemMouseCursors.resizeUpRightDownLeft;
      case 'grab':
        return SystemMouseCursors.grab;
      case 'grabbing':
        return SystemMouseCursors.grabbing;
      case 'basic':
      default:
        return SystemMouseCursors.basic;
    }
  }

  bool _coerceBool(Object? value, {required bool fallback}) {
    if (value == null) return fallback;
    if (value is bool) return value;
    if (value is num) return value != 0;
    final s = value.toString().toLowerCase();
    if (s == 'true' || s == '1' || s == 'yes' || s == 'on') return true;
    if (s == 'false' || s == '0' || s == 'no' || s == 'off') return false;
    return fallback;
  }

  bool? _coerceBoolOrNull(Object? value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is num) return value != 0;
    final s = value.toString().toLowerCase();
    if (s == 'true' || s == '1' || s == 'yes' || s == 'on') return true;
    if (s == 'false' || s == '0' || s == 'no' || s == 'off') return false;
    if (s == 'null' || s == 'none') return null;
    return null;
  }

  String _normalizePanelSide(String? value) {
    switch ((value ?? '').toLowerCase()) {
      case 'left':
      case 'right':
      case 'top':
      case 'bottom':
        return (value ?? '').toLowerCase();
      default:
        return 'left';
    }
  }
}
