library candy_layout;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/align_control.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/card.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/column.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/container.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/row.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/stack.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/wrap.dart';

import 'candy_submodule_context.dart';

// Entry point — returns null for non-layout modules so the host can chain.
Widget? buildCandyLayoutModule(String module, CandySubmoduleContext ctx) {
  return switch (module) {
    'row' => _buildRow(ctx),
    'column' => _buildColumn(ctx),
    'stack' => _buildStack(ctx),
    'wrap' => _buildWrap(ctx),
    'container' || 'surface' => _buildContainer(ctx),
    'align' => _buildAlign(ctx),
    'center' => _buildCenter(ctx),
    'spacer' => _buildSpacer(ctx),
    'aspect_ratio' => _buildAspectRatio(ctx),
    'overflow_box' => _buildOverflowBox(ctx),
    'fitted_box' => _buildFittedBox(ctx),
    'card' => _buildCard(ctx),
    _ => null,
  };
}

// ─── row ──────────────────────────────────────────────────────────────────────
// Horizontal layout. spacing, main_axis, cross_axis, main_axis_size.
Widget _buildRow(CandySubmoduleContext ctx) {
  final m = ctx.merged;
  final spacing = coerceDouble(m['spacing']) ?? 0;
  final mainAxis = candyParseMainAxis(m['main_axis'] ?? m['alignment']);
  final crossAxis = candyParseCrossAxis(m['cross_axis']);
  final axisSize = candyParseMainAxisSize(m['main_axis_size']);
  final children = candyBuildAllChildren(ctx.rawChildren, ctx.buildChild);

  if (spacing > 0) {
    final spaced = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      spaced.add(children[i]);
      if (i < children.length - 1) spaced.add(SizedBox(width: spacing));
    }
    return Row(
      mainAxisAlignment: mainAxis,
      crossAxisAlignment: crossAxis,
      mainAxisSize: axisSize,
      children: spaced,
    );
  }

  return buildRowControl(m, ctx.rawChildren, ctx.tokens, ctx.buildChild);
}

// ─── column ───────────────────────────────────────────────────────────────────
// Vertical layout. spacing, main_axis, cross_axis, main_axis_size.
Widget _buildColumn(CandySubmoduleContext ctx) {
  final m = ctx.merged;
  final spacing = coerceDouble(m['spacing']) ?? 0;
  final mainAxis = candyParseMainAxis(m['main_axis'] ?? m['alignment']);
  final crossAxis = candyParseCrossAxis(m['cross_axis']);
  final axisSize = candyParseMainAxisSize(m['main_axis_size']);
  final children = candyBuildAllChildren(ctx.rawChildren, ctx.buildChild);

  if (spacing > 0) {
    final spaced = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      spaced.add(children[i]);
      if (i < children.length - 1) spaced.add(SizedBox(height: spacing));
    }
    return Column(
      mainAxisAlignment: mainAxis,
      crossAxisAlignment: crossAxis,
      mainAxisSize: axisSize,
      children: spaced,
    );
  }

  return buildColumnControl(m, ctx.rawChildren, ctx.tokens, ctx.buildChild);
}

// ─── stack ────────────────────────────────────────────────────────────────────
// Overlay layout. alignment, fit.
Widget _buildStack(CandySubmoduleContext ctx) {
  final m = ctx.merged;
  return Stack(
    alignment: candyParseAlignment(m['alignment']) ?? Alignment.topLeft,
    fit: candyParseStackFit(m['fit']),
    clipBehavior: candyParseClip(m['clip_behavior']) ?? Clip.hardEdge,
    children: candyBuildAllChildren(ctx.rawChildren, ctx.buildChild),
  );
}

// ─── wrap ─────────────────────────────────────────────────────────────────────
// Flow layout. spacing, run_spacing, alignment, run_alignment, cross_axis.
Widget _buildWrap(CandySubmoduleContext ctx) {
  final m = ctx.merged;
  return Wrap(
    spacing: coerceDouble(m['spacing']) ?? 0,
    runSpacing: coerceDouble(m['run_spacing']) ?? 0,
    alignment: candyParseWrapAlignment(m['alignment']),
    runAlignment: candyParseWrapAlignment(m['run_alignment']),
    crossAxisAlignment: candyParseWrapCrossAxis(m['cross_axis']),
    children: candyBuildAllChildren(ctx.rawChildren, ctx.buildChild),
  );
}

// ─── container / surface ──────────────────────────────────────────────────────
// Single-child box: padding, margin, bgcolor, radius, width, height, alignment.
// surface adds elevation and border via decoration.
Widget _buildContainer(CandySubmoduleContext ctx) {
  final m = ctx.merged;
  final padding = candyCoercePadding(m['padding']);
  final margin = candyCoercePadding(m['margin']);
  final bgcolor = coerceColor(m['bgcolor'] ?? m['background']);
  final radius = coerceDouble(m['radius']) ?? ctx.style.radius;
  final borderColor = coerceColor(m['border_color']);
  final borderWidth = coerceDouble(m['border_width']) ?? 1.0;
  final gradient = coerceGradient(m['gradient']);
  final shadows = coerceBoxShadow(m['shadow']);
  final elevation = coerceDouble(m['elevation']);
  final width = coerceDouble(m['width']);
  final height = coerceDouble(m['height']);
  final alignment = candyParseAlignment(m['alignment']);

  BoxDecoration? decoration;
  final hasBorder = borderColor != null;
  final hasGradient = gradient != null;
  final hasShadow = shadows != null && shadows.isNotEmpty;
  final hasElevation = elevation != null && elevation > 0;
  final hasRadius = radius > 0;

  if (bgcolor != null || hasBorder || hasGradient || hasShadow ||
      hasElevation || hasRadius) {
    decoration = BoxDecoration(
      color: hasGradient ? null : bgcolor,
      gradient: gradient,
      borderRadius: hasRadius ? BorderRadius.circular(radius) : null,
      border: hasBorder
          ? Border.all(color: borderColor!, width: borderWidth)
          : null,
      boxShadow: hasShadow
          ? shadows
          : hasElevation
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: elevation! * 2,
                    offset: Offset(0, elevation * 0.6),
                  ),
                ]
              : null,
    );
  }

  return Container(
    width: width,
    height: height,
    margin: margin,
    padding: padding,
    alignment: alignment,
    decoration: decoration,
    child: candyFirstChildOrEmpty(ctx.rawChildren, ctx.buildChild),
  );
}

// ─── align ────────────────────────────────────────────────────────────────────
// Aligns child within available space. alignment, width_factor, height_factor.
Widget _buildAlign(CandySubmoduleContext ctx) {
  return buildAlignControl(
    '${ctx.controlId}::align',
    ctx.merged,
    ctx.rawChildren,
    ctx.buildChild,
    ctx.registerInvokeHandler,
    ctx.unregisterInvokeHandler,
    ctx.sendEvent,
  );
}

// ─── center ───────────────────────────────────────────────────────────────────
// Shortcut to center. width_factor, height_factor.
Widget _buildCenter(CandySubmoduleContext ctx) {
  return Align(
    alignment: Alignment.center,
    widthFactor: coerceDouble(ctx.merged['width_factor']),
    heightFactor: coerceDouble(ctx.merged['height_factor']),
    child: candyFirstChildOrEmpty(ctx.rawChildren, ctx.buildChild),
  );
}

// ─── spacer ───────────────────────────────────────────────────────────────────
// Fixed or flexible gap. width, height, flex.
// flex > 0 → Expanded; otherwise SizedBox.
Widget _buildSpacer(CandySubmoduleContext ctx) {
  final flex = coerceOptionalInt(ctx.merged['flex']);
  final box = SizedBox(
    width: coerceDouble(ctx.merged['width']),
    height: coerceDouble(ctx.merged['height']),
  );
  if (flex != null && flex > 0) return Expanded(flex: flex, child: box);
  return box;
}

// ─── aspect_ratio ─────────────────────────────────────────────────────────────
// Enforces a width/height ratio. ratio | value (default 1.6).
Widget _buildAspectRatio(CandySubmoduleContext ctx) {
  return AspectRatio(
    aspectRatio:
        coerceDouble(ctx.merged['value'] ?? ctx.merged['ratio']) ?? 1.6,
    child: candyFirstChildOrEmpty(ctx.rawChildren, ctx.buildChild),
  );
}

// ─── overflow_box ─────────────────────────────────────────────────────────────
// Allows child to exceed parent constraints — pop/expand effects.
Widget _buildOverflowBox(CandySubmoduleContext ctx) {
  final m = ctx.merged;
  return OverflowBox(
    alignment: candyParseAlignment(m['alignment']) ?? Alignment.center,
    minWidth: coerceDouble(m['min_width']),
    maxWidth: coerceDouble(m['max_width']),
    minHeight: coerceDouble(m['min_height']),
    maxHeight: coerceDouble(m['max_height']),
    child: candyFirstChildOrEmpty(ctx.rawChildren, ctx.buildChild),
  );
}

// ─── fitted_box ───────────────────────────────────────────────────────────────
// Scales child to fit constraints. fit (default contain), alignment, clip.
Widget _buildFittedBox(CandySubmoduleContext ctx) {
  final m = ctx.merged;
  return FittedBox(
    fit: candyParseBoxFit(m['fit']) ?? BoxFit.contain,
    alignment: candyParseAlignment(m['alignment']) ?? Alignment.center,
    clipBehavior: candyParseClip(m['clip_behavior']) ?? Clip.none,
    child: candyFirstChildOrEmpty(ctx.rawChildren, ctx.buildChild),
  );
}

// ─── card ─────────────────────────────────────────────────────────────────────
// Elevated surface. elevation, radius, padding, margin, bgcolor.
Widget _buildCard(CandySubmoduleContext ctx) {
  return buildCardControl(
    ctx.merged,
    ctx.rawChildren,
    ctx.tokens,
    ctx.buildChild,
  );
}
