import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'animation/animation_spec.dart';
import 'styling/theme.dart';
import 'butterflyui_event_box.dart';
import 'control_registry.dart';
import 'control_utils.dart';
import 'motion/motion_pack.dart';
import 'styling/effects/interaction/control_interaction_capabilities.dart';
import 'styling/effects/interaction/interaction_chain.dart';
import 'controls/buttons/button.dart';
import 'controls/buttons/elevated_button.dart';
import 'controls/buttons/icon_button.dart';
import 'controls/buttons/filled_button.dart';
import 'controls/buttons/outlined_button.dart';
import 'controls/buttons/text_button.dart';
import 'controls/common/color_value.dart';
import 'controls/common/option_types.dart';
import 'controls/common/icon_value.dart';
import 'styling/helpers/customization/animated_gradient.dart';
import 'styling/helpers/customization/avatar_stack.dart';
import 'styling/helpers/customization/badge.dart';
import 'styling/helpers/customization/blend_mode_picker.dart';
import 'styling/helpers/customization/blob_field.dart';
import 'styling/helpers/customization/border.dart';
import 'styling/helpers/customization/border_side.dart';
import 'styling/helpers/customization/button_style.dart';
import 'styling/helpers/customization/crop_box.dart';
import 'styling/helpers/customization/histogram_overlay.dart';
import 'styling/helpers/customization/histogram_view.dart';
import 'styling/helpers/customization/color_tools.dart';
import 'controls/display/chart.dart';
import 'controls/display/artifact_card.dart';
import 'controls/display/bar_chart.dart';
import 'controls/display/bar_plot.dart';
import 'controls/display/bubble.dart';
import 'controls/display/canvas.dart';
import 'controls/display/display.dart';
import 'controls/display/emoji_icon.dart';
import 'controls/display/avatar.dart';
import 'controls/display/glyph_button.dart';
import 'controls/display/line_chart.dart';
import 'controls/display/line_plot.dart';
import 'controls/display/outline.dart';
import 'controls/display/pie_plot.dart';
import 'controls/display/html_view.dart';
import 'controls/display/icon.dart';
import 'controls/display/color.dart';
import 'controls/display/markdown_view.dart';
import 'controls/display/spark_plot.dart';
import 'controls/display/sparkline.dart';
import 'controls/display/text.dart';
import 'styling/helpers/effects/animated_background.dart';
import 'styling/helpers/effects/animation.dart';
import 'styling/helpers/effects/effects.dart';
import 'styling/helpers/effects/fold_layer.dart';
import 'styling/helpers/effects/flow_field.dart';
import 'styling/helpers/effects/liquid_morph.dart';
import 'styling/helpers/effects/morphing_border.dart';
import 'styling/helpers/effects/motion.dart';
import 'styling/helpers/effects/parallax.dart';
import 'styling/helpers/effects/particles.dart';
import 'styling/helpers/effects/pixelate.dart';
import 'styling/helpers/effects/ripple_burst.dart';
import 'styling/helpers/effects/particle_field.dart';
import 'styling/helpers/effects/noise_fx.dart';
import 'styling/helpers/effects/scanline_overlay.dart';
import 'styling/helpers/effects/shadow.dart';
import 'styling/helpers/effects/shimmer_shadow.dart';
import 'styling/helpers/effects/stagger.dart';
import 'styling/helpers/effects/transition.dart';
import 'styling/helpers/effects/visual_fx.dart';
import 'styling/helpers/effects/vignette.dart';
import 'controls/feedback/progress_bar.dart';
import 'controls/feedback/progress_ring.dart';
import 'controls/feedback/timeline.dart';
import 'controls/feedback/toast.dart';
import 'controls/feedback/tooltip.dart';
import 'controls/inputs/checkbox.dart';
import 'controls/inputs/chip.dart';
import 'controls/inputs/async_action_button.dart';
import 'controls/inputs/combo_box.dart';
import 'controls/inputs/date_picker.dart';
import 'controls/inputs/dropdown.dart';
import 'controls/inputs/file_picker.dart';
import 'controls/inputs/emoji_picker.dart';
import 'controls/inputs/form.dart';
import 'controls/inputs/form_field.dart';
import 'controls/inputs/field_group.dart';
import 'controls/inputs/icon_picker.dart';
import 'controls/inputs/keybind_recorder.dart';
import 'controls/inputs/option.dart';
import 'controls/inputs/radio.dart';
import 'controls/inputs/select.dart';
import 'controls/inputs/slider.dart';
import 'controls/inputs/switch.dart';
import 'controls/inputs/text_area.dart';
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
import 'controls/layout/box.dart';
import 'controls/layout/center.dart';
import 'controls/layout/clip.dart';
import 'controls/layout/column.dart';
import 'controls/layout/container.dart';
import 'controls/layout/decorated_box.dart';
import 'controls/layout/divider.dart';
import 'controls/layout/expanded.dart';
import 'controls/layout/fitted_box.dart';
import 'controls/layout/grid_view.dart';
import 'controls/layout/pane.dart';
import 'controls/layout/page_view.dart';
import 'controls/layout/row.dart';
import 'controls/layout/safe_area.dart';
import 'controls/layout/scene_view.dart';
import 'controls/layout/scroll_view.dart';
import 'controls/layout/scrollable_column.dart';
import 'controls/layout/scrollable_row.dart';
import 'controls/layout/spacer.dart';
import 'controls/layout/split_pane.dart';
import 'controls/layout/split_view.dart';
import 'controls/layout/stack.dart';
import 'controls/layout/flex_spacer.dart';
import 'controls/layout/frame.dart';
import 'controls/layout/grid.dart';
import 'controls/layout/surface.dart';
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
import 'controls/media/sprite.dart';
import 'controls/media/video.dart';
import 'controls/navigation/app_bar.dart';
import 'controls/navigation/action_bar.dart';
import 'controls/navigation/breadcrumb_bar.dart';
import 'controls/navigation/drawer.dart';
import 'controls/navigation/menu_bar.dart';
import 'controls/navigation/notice_bar.dart';
import 'controls/navigation/navigation_ring.dart';
import 'controls/navigation/pagination.dart';
import 'controls/navigation/rail_navigation.dart';
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
import 'styling/style_pack.dart';
import 'styling/control_style_resolver.dart';
import 'styling/style_packs.dart';
import 'styling/stylesheet.dart';
import 'styling/utility_classes.dart';
import 'styling/effects/visuals/renderers/render_layers.dart';
import 'styling/effects/visuals/scene/layer.dart';
import 'controls/webview/webview.dart';
import 'webview/webview_api.dart';

Color _textToken(StylingTokens tokens) {
  final explicit = tokens.color('text');
  if (explicit != null) return explicit;
  final surface =
      tokens.color('surface') ??
      tokens.color('background') ??
      const Color(0xffffffff);
  return bestForegroundFor(surface, minContrast: 4.5);
}

Color _surfaceToken(StylingTokens tokens) {
  return tokens.color('surface') ??
      tokens.color('background') ??
      const Color(0xffffffff);
}

Color _borderToken(StylingTokens tokens) {
  return tokens.color('border') ?? _textToken(tokens).withValues(alpha: 0.2);
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
    'fg_color': 'foreground',
    'bordercolor': 'border_color',
    'textcolor': 'text_color',
    'iconcolor': 'icon_color',
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
    'opacity_level': 'opacity',
    'transparent': 'transparency',
    'translucent': 'transparency',
    'translucency': 'transparency',
    'class_name': 'classes',
    'classname': 'classes',
    'theme': 'style_pack',
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

Map<String, Object?> _extractLocalTokenOverrides(Map<String, Object?> props) {
  final out = <String, Object?>{};
  void mergeFrom(Object? raw) {
    if (raw is! Map) return;
    out.addAll(coerceObjectMap(raw));
  }

  mergeFrom(props['tokens']);
  mergeFrom(props['token_overrides']);
  mergeFrom(props['style_tokens']);
  final style = props['style'];
  if (style is Map) {
    final styleMap = coerceObjectMap(style);
    mergeFrom(styleMap['tokens']);
    mergeFrom(styleMap['token_overrides']);
    mergeFrom(styleMap['style_tokens']);
  }
  return out;
}

Map<String, Object?> _mergeStylesheetProps(
  Map<String, Object?> stylesheetProps,
  Map<String, Object?> explicitProps,
) {
  final merged = <String, Object?>{...stylesheetProps};
  explicitProps.forEach((key, value) {
    final existing = merged[key];
    if (existing is Map && value is Map) {
      merged[key] = StylingTokens.mergeMaps(
        coerceObjectMap(existing),
        coerceObjectMap(value),
      );
      return;
    }
    if (existing is List && value is List) {
      merged[key] = <Object?>[...existing, ...value];
      return;
    }
    merged[key] = value;
  });
  return merged;
}

class ControlRenderer {
  final StylingTokens tokens;
  final ButterflyUIControlRegistry registry;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;
  final ButterflyUISendRuntimeSystemEvent sendSystemEvent;
  final StylePack stylePack;
  final Map<String, Object?> styleTokens;
  final RuntimeStyleSheet stylesheet;
  final double viewportWidth;
  final double viewportHeight;

  ControlRenderer({
    required this.tokens,
    ButterflyUIControlRegistry? registry,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
    required this.sendSystemEvent,
    StylePack? stylePack,
    Map<String, Object?>? styleTokens,
    RuntimeStyleSheet? stylesheet,
    double viewportWidth = 1280,
    double viewportHeight = 800,
  }) : registry = registry ?? ButterflyUIControlRegistry(),
       stylePack = stylePack ?? stylePackRegistry.defaultPack,
       styleTokens = styleTokens ?? const <String, Object?>{},
       stylesheet = stylesheet ?? RuntimeStyleSheet.empty,
       viewportWidth = viewportWidth,
       viewportHeight = viewportHeight {}

  Widget buildFromControl(
    Map<String, Object?> control, {
    Widget Function(BuildContext context, String nodeId, Widget child)?
    wrapWithControlBox,
    StylePack? inheritedPack,
    Map<String, Object?>? inheritedTokenOverrides,
    bool inheritedImageBackdrop = false,
    int? inheritedSurfaceTintArgb,
  }) {
    final sourceType = control['type'];
    final type = (sourceType?.toString() ?? '').trim().toLowerCase();
    final controlId = control['id']?.toString() ?? '';
    final incomingProps = (control['props'] is Map)
        ? _normalizeIncomingProps(coerceObjectMap(control['props'] as Map))
        : <String, Object?>{};
    final stylesheetProps = stylesheet.resolveProps(
      controlType: type,
      props: incomingProps,
      viewportWidth: viewportWidth,
    );
    final baseProps = _mergeStylesheetProps(stylesheetProps, incomingProps);
    final normalizedProps = applyUtilityClassStyles(
      baseProps,
      viewportWidth: viewportWidth,
      viewportHeight: viewportHeight,
    );

    final basePack = inheritedPack ?? stylePack;
    final stylesheetTokenOverrides = stylesheet.resolveTokenOverrides(
      viewportWidth: viewportWidth,
    );
    final parentTokenOverrides = StylingTokens.mergeMaps(
      inheritedTokenOverrides ?? styleTokens,
      stylesheetTokenOverrides,
    );
    final packName = baseProps['style_pack']?.toString();
    final resolvedPack = (packName == null || packName.isEmpty)
        ? basePack
        : stylePackRegistry.resolve(packName);
    final localTokenOverrides = _extractLocalTokenOverrides(baseProps);
    final resolvedTokenOverrides = StylingTokens.mergeMaps(
      parentTokenOverrides,
      localTokenOverrides,
    );
    final effectiveTokens = resolvedPack.buildTokens(resolvedTokenOverrides);
    final resolvedStyle = ControlStyleResolver.resolve(
      controlType: type,
      props: normalizedProps,
      tokens: effectiveTokens,
      stylePack: resolvedPack,
    );
    final rawProps = _mergeResolvedStyleProps(
      controlType: type,
      props: normalizedProps,
      resolvedStyle: resolvedStyle,
    );
    final hasExplicitSurfaceFill =
        baseProps.containsKey('bgcolor') ||
        baseProps.containsKey('background') ||
        baseProps.containsKey('color') ||
        baseProps.containsKey('gradient') ||
        baseProps.containsKey('image');
    rawProps['__has_explicit_surface_fill'] = hasExplicitSurfaceFill;
    if (inheritedImageBackdrop) {
      rawProps['__image_backdrop_inherited'] = true;
    }
    final explicitSurfaceTint = coerceColor(
      baseProps['bgcolor'] ?? baseProps['background'] ?? baseProps['color'],
    );
    final effectiveSurfaceTintArgb =
        explicitSurfaceTint?.toARGB32() ?? inheritedSurfaceTintArgb;
    if (effectiveSurfaceTintArgb != null) {
      rawProps['__surface_tint_color'] = effectiveSurfaceTintArgb;
    }
    final imageBackdropActive =
        inheritedImageBackdrop ||
        coerceDecorationImage(rawProps['image']) != null;

    Widget buildChild(Map<String, Object?> child) {
      return buildFromControl(
        child,
        wrapWithControlBox: wrapWithControlBox,
        inheritedPack: resolvedPack,
        inheritedTokenOverrides: resolvedTokenOverrides,
        inheritedImageBackdrop: imageBackdropActive,
        inheritedSurfaceTintArgb: effectiveSurfaceTintArgb,
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

  Widget _buildProblemScreenControl(
    String controlId,
    Map<String, Object?> props,
    ButterflyUISendRuntimeEvent sendEvent,
  ) {
    final title = (props['title'] ?? 'Something went wrong').toString();
    final message = (props['message'] ?? props['text'] ?? 'Please try again.')
        .toString();
    final detail = props['detail']?.toString();
    final actionLabel = (props['action_label'] ?? 'Retry').toString();
    final icon =
        buildIconValue(props['icon'], size: 34) ??
        const Icon(Icons.error_outline, size: 34);

    return Builder(
      builder: (context) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconTheme(
                  data: IconThemeData(
                    color: Theme.of(context).colorScheme.error,
                  ),
                  child: icon,
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (detail != null && detail.trim().isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      detail,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                FilledButton.tonal(
                  onPressed: controlId.isEmpty
                      ? null
                      : () {
                          sendEvent(controlId, 'retry', {'label': actionLabel});
                          sendEvent(controlId, 'action', {
                            'label': actionLabel,
                          });
                        },
                  child: Text(actionLabel),
                ),
              ],
            ),
          ),
        );
      },
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

    switch (type) {
      case 'page':
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
        return buildSurfaceControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'box':
        return buildBoxControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'container':
        return buildContainerControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'decorated_box':
        return buildDecoratedBoxControl(props, rawChildren, context.buildChild);

      case 'frame':
        return buildFrameControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

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
        return buildCenterControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'aspect_ratio':
        return buildAspectRatioControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'fitted_box':
        return buildFittedBoxControl(props, rawChildren, context.buildChild);

      case 'clip':
        return buildClipControl(props, rawChildren, context.buildChild);

      case 'row':
        return buildRowControl(
          controlId,
          props,
          rawChildren,
          context.tokens,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'column':
        return buildColumnControl(
          controlId,
          props,
          rawChildren,
          context.tokens,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
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
          controlId,
          props,
          rawChildren,
          context.tokens,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'split_view':
        return buildSplitViewControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'split_pane':
        return buildSplitPaneControl(
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
        return buildPaneControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'expanded':
        return buildExpandedControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'flex_spacer':
        return buildFlexSpacerControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'spacer':
        return buildSpacerControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

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
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'filled_button':
        return buildFilledButtonControl(
          controlId,
          props,
          context.tokens,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'outlined_button':
        return buildOutlinedButtonControl(
          controlId,
          props,
          context.tokens,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'text_button':
        return buildTextButtonControl(
          controlId,
          props,
          context.tokens,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
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
        return buildTextControl(props, defaultText: defaultText);

      case 'markdown_view':
        return buildMarkdownViewControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'chart':
        return buildChartControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'line_chart':
        return buildLineChartControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'line_plot':
        return buildLinePlotControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'bar_chart':
        return buildBarChartControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'bar_plot':
        return buildBarPlotControl(
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
        return buildRuntimeCanvasControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'sparkline':
        return buildRuntimeSparklineControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'spark_plot':
        return buildSparkPlotControl(
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
        return _buildProblemScreenControl(controlId, props, context.sendEvent);

      case 'icon':
        {
          final iconValue = props['icon'] ?? props['value'] ?? props['name'];
          return buildIconControl(iconValue, props);
        }

      case 'color':
        return buildColorControl(controlId, props, context.sendEvent);

      case 'emoji_icon':
        return buildRuntimeEmojiIconControl(
          controlId,
          props,
          context.sendEvent,
        );

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

      case 'button':
        return buildButtonControl(
          controlId,
          props,
          context.tokens,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'icon_button':
        return buildIconButtonControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.tokens,
          context.sendEvent,
        );

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
          events: props['events'],
          props: props,
          registerInvokeHandler: context.registerInvokeHandler,
          unregisterInvokeHandler: context.unregisterInvokeHandler,
          sendEvent: context.sendEvent,
        );

      case 'text_area':
        return buildTextAreaControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'checkbox':
        return ButterflyUICheckbox(
          controlId: controlId,
          label: props['label']?.toString(),
          value: _coerceBoolOrNull(props['value'] ?? props['checked']),
          enabled: props['enabled'] == null ? true : (props['enabled'] == true),
          tristate: props['tristate'] == true,
          autofocus: props['autofocus'] == true,
          events: props['events'],
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
          autofocus: props['autofocus'] == true,
          events: props['events'],
          registerInvokeHandler: context.registerInvokeHandler,
          unregisterInvokeHandler: context.unregisterInvokeHandler,
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
          autofocus: props['autofocus'] == true,
          events: props['events'],
          registerInvokeHandler: context.registerInvokeHandler,
          unregisterInvokeHandler: context.unregisterInvokeHandler,
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
          autofocus: props['autofocus'] == true,
          helper: props['helper'],
          helperText: props['helper_text']?.toString(),
          buildChild: context.buildChild,
          events: props['events'],
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
          autofocus: props['autofocus'] == true,
          events: props['events'],
          registerInvokeHandler: context.registerInvokeHandler,
          unregisterInvokeHandler: context.unregisterInvokeHandler,
          sendEvent: context.sendEvent,
        );

      case 'option':
        return buildOptionControl(controlId, props, context.sendEvent);

      case 'combo_box':
        return buildComboboxControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'dropdown':
        return buildDropdownControl(
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
        return buildRuntimeFormFieldControl(
          props,
          rawChildren,
          context.buildChild,
        );

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
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
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
          return buildPopoverControl(
            controlId,
            props,
            anchor,
            content,
            context.registerInvokeHandler,
            context.unregisterInvokeHandler,
            context.sendEvent,
          );
        }

      case 'portal':
        return buildPortalControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
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
            context.registerInvokeHandler,
            context.unregisterInvokeHandler,
            context.sendEvent,
          );
        }

      case 'tooltip':
        {
          final message = (props['message'] ?? props['text'] ?? '').toString();
          if (message.isEmpty) return firstChildOrEmpty();
          return buildTooltipControl(
            controlId,
            props,
            firstChildOrEmpty(),
            context.registerInvokeHandler,
            context.unregisterInvokeHandler,
            context.sendEvent,
          );
        }

      case 'toast':
        return buildToastOverlayControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'snack_bar':
        return buildSnackBarControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'toast_host':
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
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
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
          return ButterflyUITabsWidget(
            controlId: controlId,
            props: props,
            rawChildren: children,
            buildChild: context.buildChild,
            registerInvokeHandler: context.registerInvokeHandler,
            unregisterInvokeHandler: context.unregisterInvokeHandler,
            sendEvent: context.sendEvent,
          );
        }

      case 'menu_bar':
        return buildMenuBarControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'action_bar':
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
        return buildMenuItemControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'breadcrumb_bar':
        return buildBreadcrumbBarControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'status_bar':
        return buildStatusBarControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'navigation_ring':
        return buildNavigationRingControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'rail_navigation':
        return buildRailNavigationControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'notice_bar':
        return buildNoticeBarControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'pagination':
        return buildPaginationControl(
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
          props: props,
        );

      case 'app_bar':
      case 'top_bar':
        return ButterflyUIAppBar(
          controlId: controlId,
          props: props,
          rawChildren: children,
          buildChild: context.buildChild,
          registerInvokeHandler: context.registerInvokeHandler,
          unregisterInvokeHandler: context.unregisterInvokeHandler,
          sendEvent: context.sendEvent,
        );

      case 'drawer':
        {
          return buildDrawerControl(
            controlId,
            props,
            rawChildren,
            context.buildChild,
            context.registerInvokeHandler,
            context.unregisterInvokeHandler,
            context.sendEvent,
          );
        }

      case 'slide_panel':
        {
          return buildSlidePanelControl(
            controlId,
            props,
            rawChildren,
            context.buildChild,
            context.registerInvokeHandler,
            context.unregisterInvokeHandler,
            context.sendEvent,
          );
        }

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
          registerInvokeHandler: context.registerInvokeHandler,
          unregisterInvokeHandler: context.unregisterInvokeHandler,
        );

      case 'sticky_list':
        return buildStickyListControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.sendEvent,
          registerInvokeHandler: context.registerInvokeHandler,
          unregisterInvokeHandler: context.unregisterInvokeHandler,
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
        return buildGridViewControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'grid':
        {
          return buildGridControl(
            controlId,
            props,
            children,
            context.buildChild,
            context.registerInvokeHandler,
            context.unregisterInvokeHandler,
            context.sendEvent,
          );
        }

      case 'card':
        return buildCardControl(
          controlId,
          props,
          rawChildren,
          context.tokens,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
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
        return buildSpriteControl(
          controlId,
          props,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

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
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'animated_background':
        return buildAnimatedBackgroundControl(
          props,
          rawChildren,
          context.buildChild,
          controlId: controlId,
          registerInvokeHandler: context.registerInvokeHandler,
          unregisterInvokeHandler: context.unregisterInvokeHandler,
          sendEvent: context.sendEvent,
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
        return buildLiquidMorphControl(
          props,
          rawChildren,
          context.buildChild,
          controlId: controlId,
          registerInvokeHandler: context.registerInvokeHandler,
          unregisterInvokeHandler: context.unregisterInvokeHandler,
          sendEvent: context.sendEvent,
        );

      case 'morphing_border':
        return buildMorphingBorderControl(
          props,
          rawChildren,
          context.buildChild,
          controlId: controlId,
          registerInvokeHandler: context.registerInvokeHandler,
          unregisterInvokeHandler: context.unregisterInvokeHandler,
          sendEvent: context.sendEvent,
        );

      case 'motion':
        return buildMotionControl(
          controlId,
          props,
          rawChildren,
          context.buildChild,
          context.registerInvokeHandler,
          context.unregisterInvokeHandler,
          context.sendEvent,
        );

      case 'animation':
        return buildAnimationControl(
          props,
          rawChildren,
          context.buildChild,
          controlId: controlId,
          registerInvokeHandler: context.registerInvokeHandler,
          unregisterInvokeHandler: context.unregisterInvokeHandler,
          sendEvent: context.sendEvent,
        );

      case 'transition':
        return buildTransitionControl(
          props,
          rawChildren,
          context.buildChild,
          controlId: controlId,
          registerInvokeHandler: context.registerInvokeHandler,
          unregisterInvokeHandler: context.unregisterInvokeHandler,
          sendEvent: context.sendEvent,
        );

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
        return buildParallaxControl(
          props,
          rawChildren,
          context.buildChild,
          controlId: controlId,
          registerInvokeHandler: context.registerInvokeHandler,
          unregisterInvokeHandler: context.unregisterInvokeHandler,
          sendEvent: context.sendEvent,
        );

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
        return buildPixelateControl(
          controlId,
          props,
          firstChildOrEmpty(),
          registerInvokeHandler: context.registerInvokeHandler,
          unregisterInvokeHandler: context.unregisterInvokeHandler,
          sendEvent: context.sendEvent,
        );

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
        return buildShadowControl(
          props,
          firstChildOrEmpty(),
          controlId: controlId,
          registerInvokeHandler: context.registerInvokeHandler,
          unregisterInvokeHandler: context.unregisterInvokeHandler,
          sendEvent: context.sendEvent,
        );

      case 'effects':
        return buildEffectsControl(
          props,
          firstChildOrEmpty(),
          controlId: controlId,
          registerInvokeHandler: context.registerInvokeHandler,
          unregisterInvokeHandler: context.unregisterInvokeHandler,
          sendEvent: context.sendEvent,
        );

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
          rawChildren: rawChildren,
          buildChild: context.buildChild,
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
    final capabilities = ControlInteractionCapabilities.forControl(controlType);
    bool supportsSlot(String name) =>
        capabilities.supportedSlots.contains(name);
    final merged = <String, Object?>{...props};
    if (supportsSlot('root')) {
      _mergeMissingEntries(merged, resolvedStyle.slot('root'));
    }
    if (supportsSlot('background')) {
      _mergeMissingEntries(merged, resolvedStyle.slot('background'));
    }
    if (supportsSlot('border')) {
      _mergeMissingEntries(
        merged,
        _borderSlotDefaults(resolvedStyle.slot('border')),
      );
    }
    if (supportsSlot('content')) {
      _mergeMissingEntries(merged, resolvedStyle.slot('content'));
    }
    if (supportsSlot('leading')) {
      _mergeMissingEntries(merged, resolvedStyle.slot('leading'));
    }
    if (supportsSlot('trailing')) {
      _mergeMissingEntries(merged, resolvedStyle.slot('trailing'));
    }
    if (supportsSlot('overlay')) {
      _mergeMissingEntries(merged, resolvedStyle.slot('overlay'));
    }
    _mergeMissingEntries(merged, resolvedStyle.slot('surface'));
    if (supportsSlot('label')) {
      _mergeMissingEntries(
        merged,
        _labelSlotDefaults(resolvedStyle.slot('label')),
      );
    }
    if (supportsSlot('icon')) {
      _mergeMissingEntries(
        merged,
        _iconSlotDefaults(controlType, resolvedStyle.slot('icon')),
      );
    }
    final slotStyles = <String, Object?>{};
    for (final slotName in capabilities.supportedSlots) {
      final slotStyle = resolvedStyle.slot(slotName);
      if (slotStyle.isEmpty) continue;
      slotStyles[slotName] = slotStyle;
    }
    if (slotStyles.isNotEmpty) {
      final existing = merged['__slot_styles'] is Map
          ? coerceObjectMap(merged['__slot_styles'] as Map)
          : <String, Object?>{};
      merged['__slot_styles'] = StylingTokens.mergeMaps(existing, slotStyles);
    }
    return merged;
  }

  Map<String, Object?> _borderSlotDefaults(Map<String, Object?> slot) {
    if (slot.isEmpty) return const <String, Object?>{};
    final out = <String, Object?>{};
    final color = slot['border_color'] ?? slot['color'] ?? slot['foreground'];
    final width = slot['border_width'] ?? slot['width'];
    final radius = slot['radius'] ?? slot['border_radius'];
    if (color != null) out['border_color'] = color;
    if (width != null) out['border_width'] = width;
    if (radius != null) out['radius'] = radius;
    return out;
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
    final capabilities = ControlInteractionCapabilities.forControl(controlType);

    final surfaceStyle = resolvedStyle.slot('surface');
    final inheritedSurfaceTint = coerceColor(props['__surface_tint_color']);
    final hasExplicitSurfaceFill = _coerceBool(
      props['__has_explicit_surface_fill'],
      fallback: false,
    );
    final suppressSurfaceFill = _shouldSuppressSurfaceFill(props, surfaceStyle);

    final visible = (props['visible'] ?? surfaceStyle['visible']) == null
        ? true
        : ((props['visible'] ?? surfaceStyle['visible']) == true);
    if (!visible) return const SizedBox.shrink();

    final enabled = _isEnabled(props);
    // Phase 1: base style/layout decorators.
    if (capabilities.supportsStyleDecorators) {
      final inheritedTextStyle = _coerceInheritedTextStyle(props, surfaceStyle);
      if (inheritedTextStyle != null) {
        built = DefaultTextStyle.merge(style: inheritedTextStyle, child: built);
      }
      final inheritedIconTheme = _coerceInheritedIconTheme(props, surfaceStyle);
      if (inheritedIconTheme != null) {
        built = IconTheme.merge(data: inheritedIconTheme, child: built);
      }
      built = _applyUniversalIconAdornments(
        built: built,
        controlType: controlType,
        props: props,
        surfaceStyle: surfaceStyle,
      );

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

      final padding = coercePadding(
        props['padding'] ?? surfaceStyle['padding'],
      );
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
        suppressSurfaceFill
            ? null
            : !hasExplicitSurfaceFill && inheritedSurfaceTint != null
            ? deriveInheritedSurfaceFill(inheritedSurfaceTint).toARGB32()
            : props['bgcolor'] ??
                  props['background'] ??
                  surfaceStyle['bgcolor'] ??
                  surfaceStyle['background'] ??
                  surfaceStyle['color'],
      );
      final borderColor = coerceColor(
        props['border_color'] ??
            borderSpec['color'] ??
            borderSpec['border_color'] ??
            surfaceStyle['border_color'] ??
            (!hasExplicitSurfaceFill && inheritedSurfaceTint != null
                ? deriveInheritedSurfaceBorder(inheritedSurfaceTint).toARGB32()
                : null),
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
        suppressSurfaceFill
            ? null
            : !hasExplicitSurfaceFill && inheritedSurfaceTint != null
            ? null
            : props['gradient'] ?? surfaceStyle['gradient'],
      );
      final image = coerceDecorationImage(
        props['image'] ?? surfaceStyle['image'],
      );
      final boxShadow = coerceBoxShadow(
        props['shadow'] ?? surfaceStyle['shadow'],
      );
      final clipBehavior = _parseClipBehavior(
        props['clip_behavior'] ??
            surfaceStyle['clip_behavior'] ??
            props['clip'],
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
        suppressSurfaceFill
            ? null
            : !hasExplicitSurfaceFill && inheritedSurfaceTint != null
            ? null
            : props['backdrop_color'] ??
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

      final explicitOpacity = coerceDouble(
        props['opacity'] ?? surfaceStyle['opacity'],
      );
      final transparency = coerceDouble(
        props['transparency'] ??
            props['alpha'] ??
            props['translucency'] ??
            surfaceStyle['transparency'] ??
            surfaceStyle['alpha'] ??
            surfaceStyle['translucency'],
      );
      double? opacity = explicitOpacity;
      if (transparency != null) {
        final normalizedTransparency = transparency > 1
            ? (transparency / 100.0).clamp(0.0, 1.0)
            : transparency.clamp(0.0, 1.0);
        final transparencyOpacity = 1.0 - normalizedTransparency;
        opacity = opacity == null
            ? transparencyOpacity
            : (opacity * transparencyOpacity).clamp(0.0, 1.0);
      }
      if (opacity != null && opacity >= 0 && opacity < 1) {
        built = Opacity(opacity: opacity.clamp(0.0, 1.0), child: built);
      }

      final overflow =
          props['overflow'] ?? surfaceStyle['overflow'] ?? props['clip_behavior'];
      final overflowClip = _parseOverflowClip(overflow);
      if (overflowClip != null) {
        built = ClipRect(clipBehavior: overflowClip, child: built);
      }

      final translate = _coerceOffset(
        props['translate'] ?? surfaceStyle['translate'],
      );
      final translateX = coerceDouble(
        props['translate_x'] ?? surfaceStyle['translate_x'],
      );
      final translateY = coerceDouble(
        props['translate_y'] ?? surfaceStyle['translate_y'],
      );
      final resolvedTranslate = Offset(
        translateX ?? translate?.dx ?? 0.0,
        translateY ?? translate?.dy ?? 0.0,
      );
      if (resolvedTranslate.dx != 0 || resolvedTranslate.dy != 0) {
        built = Transform.translate(offset: resolvedTranslate, child: built);
      }

      final scale = _coerceScaleValue(props['scale'] ?? surfaceStyle['scale']);
      if (scale != null && (scale.dx != 1.0 || scale.dy != 1.0)) {
        built = Transform.scale(
          scaleX: scale.dx,
          scaleY: scale.dy,
          alignment: Alignment.center,
          child: built,
        );
      }

      built = wrapWithEffectRenderLayers(
        controlId: controlId.isEmpty ? controlType : controlId,
        props: props,
        child: built,
      );
    }

    final surfaceLayers = _resolveControlLayers(
      suppressSurfaceFill ||
              (!hasExplicitSurfaceFill && inheritedSurfaceTint != null)
          ? null
          : props['surface_layers'] ??
                props['background_layers'] ??
                props['background_layer'] ??
                props['surface'] ??
                surfaceStyle['surface_layers'] ??
                surfaceStyle['background_layers'] ??
                surfaceStyle['background_layer'] ??
                surfaceStyle['surface'],
      context,
    );
    final foregroundLayers = _resolveControlLayers(
      props['foreground_layers'] ??
          props['overlay_layers'] ??
          props['overlay_layer'] ??
          surfaceStyle['foreground_layers'] ??
          surfaceStyle['overlay_layers'] ??
          surfaceStyle['overlay_layer'],
      context,
    );
    final hoverSurfaceLayers = _resolveControlLayers(
      suppressSurfaceFill ||
              (!hasExplicitSurfaceFill && inheritedSurfaceTint != null)
          ? null
          : props['hover_surface_layers'] ??
                props['hover_background_layers'] ??
                surfaceStyle['hover_surface_layers'] ??
                surfaceStyle['hover_background_layers'],
      context,
    );
    if (surfaceLayers.isNotEmpty ||
        foregroundLayers.isNotEmpty ||
        hoverSurfaceLayers.isNotEmpty) {
      final hoverOpacity =
          (coerceDouble(
                    props['hover_surface_opacity'] ??
                        props['hover_layer_opacity'] ??
                        surfaceStyle['hover_surface_opacity'] ??
                        surfaceStyle['hover_layer_opacity'],
                  ) ??
                  1.0)
              .clamp(0.0, 1.0);
      final layerDurationMs =
          coerceOptionalInt(
            props['layer_transition_ms'] ??
                props['hover_surface_duration_ms'] ??
                surfaceStyle['layer_transition_ms'] ??
                surfaceStyle['hover_surface_duration_ms'],
          ) ??
          180;
      final layerCurve = _curveFromName(
        (props['layer_transition_curve'] ??
                props['hover_surface_curve'] ??
                surfaceStyle['layer_transition_curve'] ??
                surfaceStyle['hover_surface_curve'])
            ?.toString(),
      );
      built = _LayeredSurfaceHost(
        backgroundLayers: surfaceLayers,
        foregroundLayers: foregroundLayers,
        hoverBackgroundLayers: hoverSurfaceLayers,
        hoverOpacity: hoverOpacity,
        hoverDuration: Duration(milliseconds: layerDurationMs.clamp(0, 2000)),
        hoverCurve: layerCurve,
        clipBehavior:
            _parseOverflowClip(
              props['overflow'] ??
                  surfaceStyle['overflow'] ??
                  props['clip_behavior'] ??
                  surfaceStyle['clip_behavior'],
            ) ??
            (_parseBoxShape(props['shape'] ?? surfaceStyle['shape']) ==
                        BoxShape.circle ||
                    _coerceBorderRadius(
                          props['radius'] ??
                              props['border_radius'] ??
                              surfaceStyle['radius'] ??
                              surfaceStyle['border_radius'],
                        ) !=
                        null
                ? Clip.antiAlias
                : Clip.none),
        borderRadius: _coerceBorderRadius(
          props['radius'] ??
              props['border_radius'] ??
              surfaceStyle['radius'] ??
              surfaceStyle['border_radius'],
        ),
        shape: _parseBoxShape(props['shape'] ?? surfaceStyle['shape']),
        backgroundOpacity:
            (coerceDouble(
                      props['background_layer_opacity'] ??
                          props['scene_opacity'] ??
                          surfaceStyle['background_layer_opacity'] ??
                          surfaceStyle['scene_opacity'],
                    ) ??
                    1.0)
                .clamp(0.0, 1.0),
        foregroundOpacity:
            (coerceDouble(
                      props['foreground_layer_opacity'] ??
                          surfaceStyle['foreground_layer_opacity'],
                    ) ??
                    1.0)
                .clamp(0.0, 1.0),
        scrimColor: coerceColor(
          props['scene_scrim'] ??
              props['scene_scrim_color'] ??
              surfaceStyle['scene_scrim'] ??
              surfaceStyle['scene_scrim_color'],
        ),
        scrimOpacity:
            (coerceDouble(
                      props['scene_scrim_opacity'] ??
                          surfaceStyle['scene_scrim_opacity'],
                    ) ??
                    0.0)
                .clamp(0.0, 1.0),
        child: built,
      );
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

    // Phase 2: explicit effects layer (before/after modifiers).
    final effectOrder = _resolveEffectOrder(props, surfaceStyle);
    final effects = capabilities.supportsEffectDecorators
        ? _resolveUniversalEffects(props, resolvedStyle)
        : const <Map<String, Object?>>[];
    if (effects.isNotEmpty && effectOrder == 'before_modifiers') {
      built = _applyEffectDecorators(
        built: built,
        effects: effects,
        props: props,
        surfaceStyle: surfaceStyle,
      );
    }

    // Phase 3: modifiers + interaction-driven motion.
    final modifiers = _resolveUniversalModifiers(props, resolvedStyle);
    final primaryMotionSpec = _resolvePrimaryMotionSpec(props, resolvedStyle);
    final enterMotionSpec = _resolveEnterMotionSpec(
      props,
      resolvedStyle,
      fallback: primaryMotionSpec,
    );
    if (modifiers.isNotEmpty &&
        (capabilities.supportsMotionDecorators ||
            capabilities.supportsInteractiveModifiers ||
            capabilities.supportsGlassModifiers ||
            capabilities.supportsTransitionModifiers)) {
      built = applyControlInteractionChain(
        child: built,
        controlType: controlType,
        controlId: controlId,
        modifiers: modifiers,
        motion: primaryMotionSpec ?? enterMotionSpec,
        tokens: context.tokens,
        motionPack: context.stylePack.motionPack,
        effectPresets: context.stylePack.effectPresets,
      );
    }

    // Phase 4: explicit effects layer (post-modifiers).
    if (effects.isNotEmpty && effectOrder != 'before_modifiers') {
      built = _applyEffectDecorators(
        built: built,
        effects: effects,
        props: props,
        surfaceStyle: surfaceStyle,
      );
    }

    // Phase 5: semantics and events.
    final semanticLabel =
        (props['semantic_label'] ??
                props['aria_label'] ??
                surfaceStyle['semantic_label'] ??
                surfaceStyle['aria_label'])
            ?.toString();
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

    // Phase 6: enter/exit animation.
    final animation = props['animation'];
    if (animation is Map) {
      built = AnimationSpec.fromJson(coerceObjectMap(animation)).wrap(built);
    } else if (capabilities.supportsMotionDecorators) {
      final fallbackAnimation = _animationFromMotion(
        enterMotionSpec ?? primaryMotionSpec,
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

  List<Widget> _resolveControlLayers(
    Object? raw,
    ButterflyUIControlContext context,
  ) {
    final out = <Widget>[];

    void addLayer(Object? value) {
      if (value == null) return;
      if (value is List) {
        for (final item in value) {
          addLayer(item);
        }
        return;
      }
      if (value is! Map) return;
      final map = coerceObjectMap(value);
      if (EffectLayer.fromValue(map) != null) {
        return;
      }
      if (map['type'] != null) {
        out.add(context.buildChild(map));
        return;
      }
      final nestedControl = map['control'] ?? map['node'];
      if (nestedControl != null) {
        addLayer(nestedControl);
      }
      final nestedLayers = map['layers'] ?? map['controls'] ?? map['children'];
      if (nestedLayers != null) {
        addLayer(nestedLayers);
      }
    }

    addLayer(raw);
    return out;
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

  List<Object?> _resolveUniversalModifiers(
    Map<String, Object?> props,
    ResolvedControlStyle resolvedStyle,
  ) {
    final out = <Object?>[];
    final modifierSource = props['modifiers'];
    if (modifierSource is List) {
      out.addAll(modifierSource.cast<Object?>());
    } else {
      out.addAll(resolvedStyle.defaultModifiers());
    }

    final hover = _coerceModifierList(
      props['on_hover_modifiers'] ?? props['on_hover'],
    );
    final pressed = _coerceModifierList(
      props['on_pressed_modifiers'] ?? props['on_pressed'],
    );
    final focused = _coerceModifierList(
      props['on_focus_modifiers'] ?? props['on_focus'],
    );
    if (hover.isNotEmpty || pressed.isNotEmpty || focused.isNotEmpty) {
      out.add(<String, Object?>{
        'type': 'state',
        if (hover.isNotEmpty) 'hover': hover,
        if (pressed.isNotEmpty) 'pressed': pressed,
        if (focused.isNotEmpty) 'focus': focused,
      });
    }
    return out;
  }

  List<Object?> _coerceModifierList(Object? value) {
    if (value == null) return const <Object?>[];
    if (value is List) return value.cast<Object?>();
    if (value is Map || value is String) return <Object?>[value];
    return const <Object?>[];
  }

  Object? _resolvePrimaryMotionSpec(
    Map<String, Object?> props,
    ResolvedControlStyle resolvedStyle,
  ) {
    return props['hover_motion'] ??
        props['press_motion'] ??
        props['motion'] ??
        resolvedStyle.defaultMotion();
  }

  Object? _resolveEnterMotionSpec(
    Map<String, Object?> props,
    ResolvedControlStyle resolvedStyle, {
    Object? fallback,
  }) {
    final enterMotion = props['enter_motion'];
    if (enterMotion != null) return enterMotion;
    final motion = props['motion'] ?? resolvedStyle.defaultMotion();
    if (motion is Map) {
      final map = coerceObjectMap(motion);
      final nested = map['enter'];
      if (nested != null) return nested;
    }
    return fallback;
  }

  String _resolveEffectOrder(
    Map<String, Object?> props,
    Map<String, Object?> surfaceStyle,
  ) {
    final orderRaw = props['effect_order'] ?? surfaceStyle['effect_order'];
    final normalized = orderRaw
        ?.toString()
        .toLowerCase()
        .replaceAll('-', '_')
        .replaceAll(' ', '_');
    if (normalized == 'before_modifiers' ||
        normalized == 'before_modifier' ||
        normalized == 'before_motion') {
      return 'before_modifiers';
    }
    return 'after_modifiers';
  }

  List<Map<String, Object?>> _resolveUniversalEffects(
    Map<String, Object?> props,
    ResolvedControlStyle resolvedStyle,
  ) {
    final out = <Map<String, Object?>>[];

    void addEffect(Object? raw) {
      if (raw == null) return;
      if (raw is String) {
        final type = raw.trim();
        if (type.isEmpty) return;
        out.add(<String, Object?>{'type': type});
        return;
      }
      if (raw is List) {
        for (final entry in raw) {
          addEffect(entry);
        }
        return;
      }
      if (raw is! Map) return;
      final map = coerceObjectMap(raw);
      if (map.containsKey('type')) {
        out.add(map);
        return;
      }
      final visualFlags = <String, bool>{
        'glow': _coerceBool(map['enable_glow'], fallback: false),
        'glass_blur': _coerceBool(map['enable_glass_blur'], fallback: false),
        'gradient_sweep': _coerceBool(
          map['enable_gradient_sweep'],
          fallback: false,
        ),
        'chromatic_shift': _coerceBool(
          map['enable_chromatic_shift'],
          fallback: false,
        ),
      };
      for (final entry in visualFlags.entries) {
        if (!entry.value) continue;
        final payload = map[entry.key];
        if (payload is Map) {
          final fx = coerceObjectMap(payload);
          fx.putIfAbsent('type', () => entry.key);
          out.add(fx);
        } else {
          out.add(<String, Object?>{'type': entry.key});
        }
      }

      for (final effectName in <String>[
        'blur',
        'opacity',
        'glow',
        'glow_effect',
        'glass_blur',
        'glass',
        'shadow',
        'vignette',
        'gradient_sweep',
        'scanline_overlay',
        'chromatic_shift',
      ]) {
        if (!map.containsKey(effectName)) continue;
        final payload = map[effectName];
        if (payload is Map) {
          final fx = coerceObjectMap(payload);
          fx.putIfAbsent('type', () => effectName);
          out.add(fx);
        } else if (payload is bool) {
          if (payload) out.add(<String, Object?>{'type': effectName});
        } else {
          out.add(<String, Object?>{'type': effectName, 'value': payload});
        }
      }
    }

    addEffect(resolvedStyle.value('effects'));
    addEffect(props['effects']);
    addEffect(props['effect']);
    if (props['visual_fx'] is Map) {
      addEffect(props['visual_fx']);
    }
    return out;
  }

  Widget _applyEffectDecorators({
    required Widget built,
    required List<Map<String, Object?>> effects,
    required Map<String, Object?> props,
    required Map<String, Object?> surfaceStyle,
  }) {
    final effectClip = _parseClipBehavior(
      props['effect_clip'] ?? props['effect_clip_behavior'],
    );
    final effectRadius = _coerceBorderRadius(
      props['radius'] ??
          props['border_radius'] ??
          surfaceStyle['radius'] ??
          surfaceStyle['border_radius'],
    );

    for (final effect in effects) {
      final type = _normalizeEffectType(effect['type']?.toString());
      if (type.isEmpty) continue;
      switch (type) {
        case 'opacity':
          final value = coerceDouble(effect['opacity'] ?? effect['value']);
          if (value != null && value >= 0 && value <= 1) {
            built = Opacity(opacity: value, child: built);
          }
          break;
        case 'blur':
        case 'gaussian_blur':
          final sigma =
              coerceDouble(
                effect['sigma'] ?? effect['blur'] ?? effect['value'],
              ) ??
              0.0;
          if (sigma > 0) {
            built = ImageFiltered(
              imageFilter: ui.ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
              child: built,
            );
          }
          break;
        case 'glass':
        case 'glass_blur':
          final sigma =
              coerceDouble(
                effect['sigma'] ?? effect['blur'] ?? effect['value'],
              ) ??
              0.0;
          final tint = coerceColor(effect['tint'] ?? effect['color']);
          if (effectClip != Clip.none) {
            if (effectRadius != null) {
              built = ClipRRect(
                borderRadius: effectRadius,
                clipBehavior: effectClip,
                child: built,
              );
            } else {
              built = ClipRect(clipBehavior: effectClip, child: built);
            }
          }
          if (sigma > 0) {
            built = BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
              child: built,
            );
          }
          if (tint != null) {
            built = DecoratedBox(
              decoration: BoxDecoration(
                color: tint,
                borderRadius: effectRadius,
              ),
              child: built,
            );
          }
          break;
        case 'glow':
        case 'glow_effect':
        case 'neon_edge':
          final color = coerceColor(effect['color']) ?? const Color(0xFF4F46E5);
          final blur = coerceDouble(effect['blur']) ?? 18.0;
          final spread = coerceDouble(effect['spread']) ?? 2.0;
          final opacity = coerceDouble(effect['opacity']) ?? 0.65;
          built = DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: effectRadius,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: color.withValues(alpha: opacity.clamp(0.0, 1.0)),
                  blurRadius: blur,
                  spreadRadius: spread,
                ),
              ],
            ),
            child: built,
          );
          break;
        case 'shadow':
        case 'shadow_stack':
        case 'shimmer_shadow':
          final shadows = coerceBoxShadow(
            effect['shadows'] ?? effect['shadow'] ?? effect,
          );
          if (shadows != null && shadows.isNotEmpty) {
            built = DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: effectRadius,
                boxShadow: shadows,
              ),
              child: built,
            );
          }
          break;
        case 'vignette':
          final color = coerceColor(effect['color']) ?? Colors.black;
          final intensity = (coerceDouble(effect['intensity']) ?? 0.35).clamp(
            0.0,
            1.0,
          );
          built = Stack(
            fit: StackFit.passthrough,
            children: <Widget>[
              built,
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: effectRadius,
                      gradient: RadialGradient(
                        radius: 1.05,
                        colors: <Color>[
                          color.withValues(alpha: 0.0),
                          color.withValues(alpha: intensity),
                        ],
                        stops: const <double>[0.55, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
          break;
        case 'gradient_sweep':
          final gradient = coerceGradient(effect['gradient']);
          final opacity = (coerceDouble(effect['opacity']) ?? 0.35).clamp(
            0.0,
            1.0,
          );
          if (gradient != null) {
            built = Stack(
              fit: StackFit.passthrough,
              children: <Widget>[
                built,
                Positioned.fill(
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: opacity,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: effectRadius,
                          gradient: gradient,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          break;
        default:
          break;
      }
    }
    return built;
  }

  String _normalizeEffectType(String? value) {
    if (value == null) return '';
    return value.trim().toLowerCase().replaceAll('-', '_').replaceAll(' ', '_');
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
    final textBackground = resolveColorValue(
      props['background'] ??
          props['bgcolor'] ??
          surfaceStyle['background'] ??
          surfaceStyle['bgcolor'],
    );
    final autoContrast = _coerceBool(
      props['auto_contrast'] ?? surfaceStyle['auto_contrast'],
      fallback: true,
    );
    final minContrast =
        coerceDouble(props['min_contrast'] ?? surfaceStyle['min_contrast']) ??
        4.5;
    final color = resolveColorValue(
      props['text_color'] ??
          props['foreground'] ??
          props['color'] ??
          surfaceStyle['text_color'] ??
          surfaceStyle['foreground'] ??
          surfaceStyle['color'],
      background: textBackground,
      autoContrast: autoContrast,
      minContrast: minContrast,
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
    final iconBackground = resolveColorValue(
      props['background'] ??
          props['bgcolor'] ??
          surfaceStyle['background'] ??
          surfaceStyle['bgcolor'],
    );
    final autoContrast = _coerceBool(
      props['auto_contrast'] ?? surfaceStyle['auto_contrast'],
      fallback: true,
    );
    final minContrast =
        coerceDouble(props['min_contrast'] ?? surfaceStyle['min_contrast']) ??
        4.5;
    final color = resolveColorValue(
      props['icon_color'] ??
          props['icon_foreground'] ??
          props['color'] ??
          surfaceStyle['icon_color'] ??
          surfaceStyle['icon_foreground'] ??
          surfaceStyle['color'],
      background: iconBackground,
      autoContrast: autoContrast,
      minContrast: minContrast,
    );
    final size = coerceDouble(props['icon_size'] ?? surfaceStyle['icon_size']);
    final opacity = coerceDouble(
      props['icon_opacity'] ?? surfaceStyle['icon_opacity'],
    );
    if (color == null && size == null && opacity == null) return null;
    return IconThemeData(color: color, size: size, opacity: opacity);
  }

  Widget _applyUniversalIconAdornments({
    required Widget built,
    required String controlType,
    required Map<String, Object?> props,
    required Map<String, Object?> surfaceStyle,
  }) {
    const nativeIconControls = <String>{
      'button',
      'elevated_button',
      'filled_button',
      'outlined_button',
      'text_button',
      'icon_button',
      'glyph_button',
      'icon',
      'emoji_icon',
      'app_bar',
      'menu_item',
      'list_tile',
      'item_tile',
      'bubble',
      'display',
      'notice_bar',
      'pagination',
      'toast',
      'snack_bar',
      'action_bar',
      'tabs',
    };
    if (nativeIconControls.contains(controlType)) {
      return built;
    }
    if (_coerceBool(
          props['decorate_icon'] ?? surfaceStyle['decorate_icon'],
          fallback: true,
        ) ==
        false) {
      return built;
    }

    final iconPosition = (props['icon_position'] ?? 'leading')
        .toString()
        .trim()
        .toLowerCase();
    final leadingValue = iconPosition == 'trailing'
        ? null
        : (props['leading_icon'] ?? props['icon']);
    final trailingValue = iconPosition == 'trailing'
        ? (props['trailing_icon'] ?? props['icon'])
        : props['trailing_icon'];
    if (leadingValue == null && trailingValue == null) {
      return built;
    }

    final background = resolveColorValue(
      props['background'] ??
          props['bgcolor'] ??
          surfaceStyle['background'] ??
          surfaceStyle['bgcolor'],
    );
    final autoContrast = _coerceBool(
      props['auto_contrast'] ?? surfaceStyle['auto_contrast'],
      fallback: true,
    );
    final minContrast =
        coerceDouble(props['min_contrast'] ?? surfaceStyle['min_contrast']) ??
        4.5;
    final iconColor = resolveColorValue(
      props['icon_color'] ??
          props['icon_foreground'] ??
          props['foreground'] ??
          props['color'] ??
          surfaceStyle['icon_color'] ??
          surfaceStyle['icon_foreground'] ??
          surfaceStyle['foreground'] ??
          surfaceStyle['color'],
      background: background,
      autoContrast: autoContrast,
      minContrast: minContrast,
    );
    final iconSize = coerceDouble(
      props['icon_size'] ??
          props['size'] ??
          surfaceStyle['icon_size'] ??
          surfaceStyle['size'],
    );
    final spacing =
        coerceDouble(props['icon_spacing'] ?? surfaceStyle['icon_spacing']) ??
        8.0;

    Widget? buildAdornmentIcon(Object? raw) {
      if (raw == null) return null;
      return buildIconValue(
        raw,
        colorValue: props['icon_color'] ?? props['color'] ?? iconColor,
        color: iconColor,
        background: background,
        size: iconSize,
        autoContrast: autoContrast,
        minContrast: minContrast,
        fallbackIcon: Icons.circle,
      );
    }

    final leading = buildAdornmentIcon(leadingValue);
    final trailing = buildAdornmentIcon(trailingValue);
    if (leading == null && trailing == null) {
      return built;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leading != null) ...[leading, SizedBox(width: spacing)],
        Flexible(fit: FlexFit.loose, child: built),
        if (trailing != null) ...[SizedBox(width: spacing), trailing],
      ],
    );
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

  Clip? _parseOverflowClip(Object? value) {
    final normalized = value
        ?.toString()
        .toLowerCase()
        .replaceAll('-', '_')
        .replaceAll(' ', '_');
    switch (normalized) {
      case null:
      case '':
      case 'visible':
      case 'unset':
        return null;
      case 'hidden':
      case 'clip':
        return Clip.hardEdge;
      default:
        return null;
    }
  }

  Offset? _coerceOffset(Object? value) {
    if (value is List && value.length >= 2) {
      return Offset(
        coerceDouble(value[0]) ?? 0.0,
        coerceDouble(value[1]) ?? 0.0,
      );
    }
    if (value is Map) {
      final map = coerceObjectMap(value);
      return Offset(
        coerceDouble(map['x'] ?? map['dx']) ?? 0.0,
        coerceDouble(map['y'] ?? map['dy']) ?? 0.0,
      );
    }
    return null;
  }

  Offset? _coerceScaleValue(Object? value) {
    if (value == null) return null;
    if (value is num) {
      final factor = value.toDouble();
      return Offset(factor, factor);
    }
    if (value is List && value.length >= 2) {
      return Offset(
        coerceDouble(value[0]) ?? 1.0,
        coerceDouble(value[1]) ?? 1.0,
      );
    }
    if (value is Map) {
      final map = coerceObjectMap(value);
      return Offset(
        coerceDouble(map['x'] ?? map['scale_x']) ?? 1.0,
        coerceDouble(map['y'] ?? map['scale_y']) ?? 1.0,
      );
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

  bool _shouldSuppressSurfaceFill(
    Map<String, Object?> props,
    Map<String, Object?> surfaceStyle,
  ) {
    final preserveSurface = _coerceBool(
      props['preserve_surface'] ??
          props['preserve_fill'] ??
          props['preserve_background'] ??
          surfaceStyle['preserve_surface'] ??
          surfaceStyle['preserve_fill'] ??
          surfaceStyle['preserve_background'],
      fallback: false,
    );
    if (preserveSurface) {
      return false;
    }
    if (_coerceBool(props['__image_backdrop_inherited'], fallback: false)) {
      return true;
    }
    return coerceDecorationImage(props['image'] ?? surfaceStyle['image']) !=
        null;
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
}

class _LayeredSurfaceHost extends StatefulWidget {
  const _LayeredSurfaceHost({
    required this.backgroundLayers,
    required this.foregroundLayers,
    required this.hoverBackgroundLayers,
    required this.hoverOpacity,
    required this.hoverDuration,
    required this.hoverCurve,
    required this.clipBehavior,
    required this.borderRadius,
    required this.shape,
    required this.backgroundOpacity,
    required this.foregroundOpacity,
    required this.scrimColor,
    required this.scrimOpacity,
    required this.child,
  });

  final List<Widget> backgroundLayers;
  final List<Widget> foregroundLayers;
  final List<Widget> hoverBackgroundLayers;
  final double hoverOpacity;
  final Duration hoverDuration;
  final Curve hoverCurve;
  final Clip clipBehavior;
  final BorderRadius? borderRadius;
  final BoxShape shape;
  final double backgroundOpacity;
  final double foregroundOpacity;
  final Color? scrimColor;
  final double scrimOpacity;
  final Widget child;

  @override
  State<_LayeredSurfaceHost> createState() => _LayeredSurfaceHostState();
}

class _LayeredSurfaceHostState extends State<_LayeredSurfaceHost> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final hasHoverLayer = widget.hoverBackgroundLayers.isNotEmpty;

    Widget layered = Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        for (final layer in widget.backgroundLayers)
          Positioned.fill(
            child: IgnorePointer(
              child: Opacity(
                opacity: widget.backgroundOpacity,
                child: layer,
              ),
            ),
          ),
        if (widget.scrimColor != null && widget.scrimOpacity > 0)
          Positioned.fill(
            child: IgnorePointer(
              child: ColoredBox(
                color: widget.scrimColor!.withValues(alpha: widget.scrimOpacity),
              ),
            ),
          ),
        if (hasHoverLayer)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedOpacity(
                opacity: _hovered ? widget.hoverOpacity : 0.0,
                duration: widget.hoverDuration,
                curve: widget.hoverCurve,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    for (final layer in widget.hoverBackgroundLayers) layer,
                  ],
                ),
              ),
            ),
          ),
        widget.child,
        for (final layer in widget.foregroundLayers)
          Positioned.fill(
            child: IgnorePointer(
              child: Opacity(
                opacity: widget.foregroundOpacity,
                child: layer,
              ),
            ),
          ),
      ],
    );

    if (widget.shape == BoxShape.circle) {
      layered = ClipOval(
        clipBehavior: widget.clipBehavior,
        child: layered,
      );
    } else if (widget.clipBehavior != Clip.none || widget.borderRadius != null) {
      layered = ClipRRect(
        clipBehavior: widget.clipBehavior,
        borderRadius: widget.borderRadius ?? BorderRadius.zero,
        child: layered,
      );
    }

    if (!hasHoverLayer) return layered;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: layered,
    );
  }
}
