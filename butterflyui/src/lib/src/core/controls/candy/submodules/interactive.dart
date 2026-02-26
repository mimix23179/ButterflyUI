library candy_interactive;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/buttons/button.dart';
import 'package:butterflyui_runtime/src/core/controls/customization/badge.dart';

import 'candy_submodule_context.dart';

// Entry point — returns null for non-interactive modules.
Widget? buildCandyInteractiveModule(String module, CandySubmoduleContext ctx) {
  return switch (module) {
    'button' => _buildButton(ctx),
    'badge' => _buildBadge(ctx),
    'avatar' => _buildAvatar(ctx),
    'icon' => _buildIcon(ctx),
    'text' => _buildText(ctx),
    _ => null,
  };
}

// ─── button ───────────────────────────────────────────────────────────────────
// label/text, icon, loading, disabled, radius, padding, bgcolor, text_color.
// Interaction events (click, hover, focus) are owned by the host's
// _wrapWithInteraction layer; this builder handles paint only.
Widget _buildButton(CandySubmoduleContext ctx) {
  return buildButtonControl(
    ctx.controlId,
    ctx.merged,
    ctx.tokens,
    ctx.sendEvent,
  );
}

// ─── badge ────────────────────────────────────────────────────────────────────
// label/text/value, color, bgcolor, text_color, radius.
// Overlays its child or stands alone as a status indicator.
Widget _buildBadge(CandySubmoduleContext ctx) {
  return buildBadgeControl(
    '${ctx.controlId}::badge',
    ctx.merged,
    ctx.rawChildren,
    ctx.buildChild,
    ctx.registerInvokeHandler,
    ctx.unregisterInvokeHandler,
    ctx.sendEvent,
  );
}

// ─── avatar ───────────────────────────────────────────────────────────────────
// src (network image), label/text (initials fallback), size, color, bgcolor.
// Shapes: circle (default). Add shape='square' support via ClipRRect.
Widget _buildAvatar(CandySubmoduleContext ctx) {
  final m = ctx.merged;
  final size = coerceDouble(m['size']) ?? 36.0;
  final label = (m['label'] ?? m['text'] ?? '').toString();
  final src = m['src']?.toString();
  final hasImage = src != null && src.isNotEmpty;
  final image = hasImage ? NetworkImage(src) : null;
  final bg = coerceColor(m['bgcolor']) ?? ctx.style.background;
  final fg = coerceColor(m['color']) ?? ctx.style.foreground;
  final shape = candyNorm((m['shape'] ?? 'circle').toString());

  final initials = label.isNotEmpty ? label.substring(0, 1).toUpperCase() : '?';
  final textChild = Text(
    initials,
    style: TextStyle(
      color: fg,
      fontSize: size * 0.38,
      fontWeight: FontWeight.w600,
    ),
  );

  // Square avatar via ClipRRect instead of CircleAvatar.
  if (shape == 'square' || shape == 'rect' || shape == 'rectangle') {
    final radius = coerceDouble(m['radius']) ?? (size * 0.2);
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        width: size,
        height: size,
        color: bg,
        alignment: Alignment.center,
        child: image != null
            ? Image(image: image, width: size, height: size, fit: BoxFit.cover)
            : textChild,
      ),
    );
  }

  return CircleAvatar(
    radius: size / 2,
    backgroundColor: bg,
    foregroundColor: fg,
    backgroundImage: image,
    child: image == null ? textChild : null,
  );
}

// ─── icon ─────────────────────────────────────────────────────────────────────
// icon name → Material IconData, size, color.
// Falls back to Icons.help_outline for unmapped names.
Widget _buildIcon(CandySubmoduleContext ctx) {
  final m = ctx.merged;
  return Icon(
    candyParseIcon(m['icon']) ?? Icons.help_outline,
    size: coerceDouble(m['size']),
    color: coerceColor(m['color']) ?? ctx.style.foreground,
  );
}

// ─── text ─────────────────────────────────────────────────────────────────────
// text/value, color/text_color, font_size/size, font_weight/weight,
// align, max_lines, overflow, line_height, letter_spacing.
Widget _buildText(CandySubmoduleContext ctx) {
  final m = ctx.merged;
  return Text(
    (m['text'] ?? m['value'] ?? '').toString(),
    textAlign: candyParseTextAlign(m['align']) ?? TextAlign.start,
    maxLines: coerceOptionalInt(m['max_lines']),
    overflow: candyParseTextOverflow(m['overflow']),
    style: TextStyle(
      color: coerceColor(m['color'] ?? m['text_color']) ?? ctx.style.foreground,
      fontSize: coerceDouble(m['size'] ?? m['font_size']),
      fontWeight: candyParseWeight(m['weight'] ?? m['font_weight']),
      height: coerceDouble(m['line_height']),
      letterSpacing: coerceDouble(m['letter_spacing']),
      decoration: _parseTextDecoration(m['decoration']),
    ),
  );
}

TextDecoration? _parseTextDecoration(Object? value) {
  return switch (candyNorm(value?.toString() ?? '')) {
    'underline' => TextDecoration.underline,
    'overline' => TextDecoration.overline,
    'line_through' || 'strikethrough' => TextDecoration.lineThrough,
    'none' => TextDecoration.none,
    _ => null,
  };
}
