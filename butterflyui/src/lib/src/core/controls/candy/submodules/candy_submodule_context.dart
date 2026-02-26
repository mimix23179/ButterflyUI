library candy_submodule_context;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/candy/theme.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

// ─── Resolved style ───────────────────────────────────────────────────────────

class CandyStyle {
  const CandyStyle({
    required this.background,
    required this.foreground,
    required this.outlineColor,
    required this.outlineWidth,
    required this.radius,
  });
  final Color? background;
  final Color? foreground;
  final Color outlineColor;
  final double outlineWidth;
  final double radius;
}

// ─── Submodule context bag ─────────────────────────────────────────────────────

class CandySubmoduleContext {
  const CandySubmoduleContext({
    required this.context,
    required this.controlId,
    required this.merged,
    required this.rawChildren,
    required this.tokens,
    required this.style,
    required this.buildChild,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });
  final BuildContext context;
  final String controlId;
  final Map<String, Object?> merged;
  final List<dynamic> rawChildren;
  final CandyTokens tokens;
  final CandyStyle style;
  final Widget Function(Map<String, Object?> child) buildChild;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;
}

// ─── String normalisation ──────────────────────────────────────────────────────

String candyNorm(String value) =>
    value.trim().toLowerCase().replaceAll('-', '_').replaceAll(' ', '_');

// ─── Child helpers ─────────────────────────────────────────────────────────────

Widget candyFirstChildOrEmpty(
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
) {
  for (final raw in rawChildren) {
    if (raw is Map) return buildChild(coerceObjectMap(raw));
  }
  return const SizedBox.shrink();
}

List<Widget> candyBuildAllChildren(
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
) {
  final out = <Widget>[];
  for (final raw in rawChildren) {
    if (raw is Map) out.add(buildChild(coerceObjectMap(raw)));
  }
  return out;
}

// ─── Padding ───────────────────────────────────────────────────────────────────

EdgeInsets? candyCoercePadding(Object? value) {
  if (value == null) return null;
  if (value is num) return EdgeInsets.all(value.toDouble());
  if (value is List) {
    if (value.length == 1) return EdgeInsets.all(coerceDouble(value[0]) ?? 0);
    if (value.length == 2) {
      return EdgeInsets.symmetric(
        vertical: coerceDouble(value[0]) ?? 0,
        horizontal: coerceDouble(value[1]) ?? 0,
      );
    }
    if (value.length == 4) {
      // top, right, bottom, left  (CSS order)
      return EdgeInsets.fromLTRB(
        coerceDouble(value[3]) ?? 0,
        coerceDouble(value[0]) ?? 0,
        coerceDouble(value[1]) ?? 0,
        coerceDouble(value[2]) ?? 0,
      );
    }
  }
  if (value is Map) {
    final m = coerceObjectMap(value);
    return EdgeInsets.fromLTRB(
      coerceDouble(m['left']) ?? 0,
      coerceDouble(m['top']) ?? 0,
      coerceDouble(m['right']) ?? 0,
      coerceDouble(m['bottom']) ?? 0,
    );
  }
  return null;
}

// ─── Border ────────────────────────────────────────────────────────────────────

Border? candyCoerceBorder(Map<String, Object?> props) {
  final color = coerceColor(props['border_color'] ?? props['color']);
  if (color == null) return null;
  final width = coerceDouble(props['border_width'] ?? props['width']) ?? 1.0;
  final side = candyNorm((props['side'] ?? 'all').toString());
  final s = BorderSide(color: color, width: width);
  return switch (side) {
    'top' => Border(top: s),
    'bottom' => Border(bottom: s),
    'left' => Border(left: s),
    'right' => Border(right: s),
    'horizontal' => Border(top: s, bottom: s),
    'vertical' => Border(left: s, right: s),
    _ => Border.all(color: color, width: width),
  };
}

// ─── Alignment ─────────────────────────────────────────────────────────────────

Alignment? candyParseAlignment(Object? value) {
  if (value == null) return null;
  if (value is List && value.length >= 2) {
    return Alignment(coerceDouble(value[0]) ?? 0, coerceDouble(value[1]) ?? 0);
  }
  if (value is Map) {
    final m = coerceObjectMap(value);
    return Alignment(coerceDouble(m['x']) ?? 0, coerceDouble(m['y']) ?? 0);
  }
  return switch (candyNorm(value.toString())) {
    'center' => Alignment.center,
    'top' || 'top_center' => Alignment.topCenter,
    'bottom' || 'bottom_center' => Alignment.bottomCenter,
    'left' || 'center_left' || 'start' => Alignment.centerLeft,
    'right' || 'center_right' || 'end' => Alignment.centerRight,
    'top_left' || 'top_start' => Alignment.topLeft,
    'top_right' || 'top_end' => Alignment.topRight,
    'bottom_left' || 'bottom_start' => Alignment.bottomLeft,
    'bottom_right' || 'bottom_end' => Alignment.bottomRight,
    _ => null,
  };
}

MainAxisAlignment candyParseMainAxis(Object? value) {
  return switch (candyNorm(value?.toString() ?? '')) {
    'start' => MainAxisAlignment.start,
    'end' => MainAxisAlignment.end,
    'center' => MainAxisAlignment.center,
    'space_between' => MainAxisAlignment.spaceBetween,
    'space_around' => MainAxisAlignment.spaceAround,
    'space_evenly' => MainAxisAlignment.spaceEvenly,
    _ => MainAxisAlignment.start,
  };
}

CrossAxisAlignment candyParseCrossAxis(Object? value) {
  return switch (candyNorm(value?.toString() ?? '')) {
    'start' => CrossAxisAlignment.start,
    'end' => CrossAxisAlignment.end,
    'center' => CrossAxisAlignment.center,
    'stretch' => CrossAxisAlignment.stretch,
    'baseline' => CrossAxisAlignment.baseline,
    _ => CrossAxisAlignment.center,
  };
}

MainAxisSize candyParseMainAxisSize(Object? value) {
  return switch (candyNorm(value?.toString() ?? '')) {
    'min' => MainAxisSize.min,
    _ => MainAxisSize.max,
  };
}

WrapAlignment candyParseWrapAlignment(Object? value) {
  return switch (candyNorm(value?.toString() ?? '')) {
    'start' => WrapAlignment.start,
    'end' => WrapAlignment.end,
    'center' => WrapAlignment.center,
    'space_between' => WrapAlignment.spaceBetween,
    'space_around' => WrapAlignment.spaceAround,
    'space_evenly' => WrapAlignment.spaceEvenly,
    _ => WrapAlignment.start,
  };
}

WrapCrossAlignment candyParseWrapCrossAxis(Object? value) {
  return switch (candyNorm(value?.toString() ?? '')) {
    'end' => WrapCrossAlignment.end,
    'center' => WrapCrossAlignment.center,
    _ => WrapCrossAlignment.start,
  };
}

StackFit candyParseStackFit(Object? value) {
  return switch (candyNorm(value?.toString() ?? '')) {
    'expand' => StackFit.expand,
    'passthrough' => StackFit.passthrough,
    _ => StackFit.loose,
  };
}

// ─── Clip / BoxFit ─────────────────────────────────────────────────────────────

Clip? candyParseClip(Object? value) {
  return switch (candyNorm(value?.toString() ?? '')) {
    'none' => Clip.none,
    'hardedge' || 'hard_edge' => Clip.hardEdge,
    'antialias' || 'anti_alias' => Clip.antiAlias,
    'antialiaswithsavelayer' || 'anti_alias_with_save_layer' =>
      Clip.antiAliasWithSaveLayer,
    _ => null,
  };
}

BoxFit? candyParseBoxFit(Object? value) {
  return switch (candyNorm(value?.toString() ?? '')) {
    'fill' => BoxFit.fill,
    'contain' => BoxFit.contain,
    'cover' => BoxFit.cover,
    'fit_width' || 'fitwidth' => BoxFit.fitWidth,
    'fit_height' || 'fitheight' => BoxFit.fitHeight,
    'none' => BoxFit.none,
    'scale_down' || 'scaledown' => BoxFit.scaleDown,
    _ => null,
  };
}

// ─── Animation curve ───────────────────────────────────────────────────────────

Curve candyParseCurve(Object? value,
    {Curve fallback = Curves.easeOutCubic}) {
  return switch (candyNorm(value?.toString() ?? '')) {
    'linear' => Curves.linear,
    'ease' => Curves.ease,
    'ease_in' || 'easein' => Curves.easeIn,
    'ease_out' || 'easeout' => Curves.easeOut,
    'ease_in_out' || 'easeinout' => Curves.easeInOut,
    'fast_out_slow_in' || 'fastoutslowin' => Curves.fastOutSlowIn,
    'ease_out_cubic' || 'easeoutcubic' => Curves.easeOutCubic,
    'ease_in_cubic' || 'easeincubic' => Curves.easeInCubic,
    'ease_in_out_cubic' || 'easeinoutcubic' => Curves.easeInOutCubic,
    'ease_out_quart' || 'easeoutquart' => Curves.easeOutQuart,
    'ease_in_quart' || 'easeinquart' => Curves.easeInQuart,
    'ease_in_out_quart' || 'easeinoutquart' => Curves.easeInOutQuart,
    'ease_out_expo' || 'easeoutexpo' => Curves.easeOutExpo,
    'ease_in_expo' || 'easeinexpo' => Curves.easeInExpo,
    'ease_out_back' || 'easeoutback' => Curves.easeOutBack,
    'ease_in_back' || 'easeinback' => Curves.easeInBack,
    'ease_in_out_back' || 'easeinoutback' => Curves.easeInOutBack,
    'bounce_out' || 'bounceout' => Curves.bounceOut,
    'bounce_in' || 'bouncein' => Curves.bounceIn,
    'bounce_in_out' || 'bounceinout' => Curves.bounceInOut,
    'elastic_out' || 'elasticout' => Curves.elasticOut,
    'elastic_in' || 'elasticin' => Curves.elasticIn,
    'elastic_in_out' || 'elasticinout' => Curves.elasticInOut,
    'decelerate' => Curves.decelerate,
    'fast_linear_to_slow_ease_in' => Curves.fastLinearToSlowEaseIn,
    _ => fallback,
  };
}

// ─── Text helpers ──────────────────────────────────────────────────────────────

TextAlign? candyParseTextAlign(Object? value) {
  return switch (candyNorm(value?.toString() ?? '')) {
    'left' || 'start' => TextAlign.start,
    'right' || 'end' => TextAlign.end,
    'center' => TextAlign.center,
    'justify' => TextAlign.justify,
    _ => null,
  };
}

TextOverflow? candyParseTextOverflow(Object? value) {
  return switch (candyNorm(value?.toString() ?? '')) {
    'clip' => TextOverflow.clip,
    'fade' => TextOverflow.fade,
    'visible' => TextOverflow.visible,
    'ellipsis' => TextOverflow.ellipsis,
    _ => null,
  };
}

FontWeight? candyParseWeight(Object? value) {
  if (value == null) return null;
  if (value is int) {
    return switch (value) {
      100 => FontWeight.w100,
      200 => FontWeight.w200,
      300 => FontWeight.w300,
      400 => FontWeight.w400,
      500 => FontWeight.w500,
      600 => FontWeight.w600,
      700 => FontWeight.w700,
      800 => FontWeight.w800,
      900 => FontWeight.w900,
      _ => null,
    };
  }
  final s = candyNorm(value.toString());
  if (s == 'normal') return FontWeight.w400;
  if (s == 'bold') return FontWeight.w700;
  if (s.startsWith('w')) return candyParseWeight(int.tryParse(s.substring(1)));
  return candyParseWeight(int.tryParse(s));
}

// ─── Icon lookup ───────────────────────────────────────────────────────────────

IconData? candyParseIcon(Object? value) {
  return switch (candyNorm(value?.toString() ?? '')) {
    'add' || 'plus' => Icons.add,
    'remove' || 'minus' => Icons.remove,
    'close' || 'x' => Icons.close,
    'check' || 'done' => Icons.check,
    'warning' => Icons.warning_amber_rounded,
    'error' => Icons.error_outline,
    'info' => Icons.info_outline,
    'search' => Icons.search,
    'menu' => Icons.menu,
    'settings' => Icons.settings,
    'home' => Icons.home_outlined,
    'arrow_back' || 'back' => Icons.arrow_back,
    'arrow_forward' || 'forward' => Icons.arrow_forward,
    'star' => Icons.star_outline,
    'favorite' || 'heart' => Icons.favorite_outline,
    'bookmark' => Icons.bookmark_outline,
    'share' => Icons.share_outlined,
    'edit' || 'pencil' => Icons.edit_outlined,
    'delete' || 'trash' => Icons.delete_outline,
    'copy' => Icons.copy_outlined,
    'paste' => Icons.paste_outlined,
    'upload' => Icons.upload_outlined,
    'download' => Icons.download_outlined,
    'refresh' || 'reload' => Icons.refresh,
    'play' => Icons.play_arrow_outlined,
    'pause' => Icons.pause_outlined,
    'stop' => Icons.stop_outlined,
    'expand_more' || 'chevron_down' => Icons.expand_more,
    'expand_less' || 'chevron_up' => Icons.expand_less,
    'chevron_right' => Icons.chevron_right,
    'chevron_left' => Icons.chevron_left,
    'visibility' || 'eye' => Icons.visibility_outlined,
    'visibility_off' || 'eye_off' => Icons.visibility_off_outlined,
    'lock' => Icons.lock_outline,
    'unlock' => Icons.lock_open_outlined,
    'notifications' || 'bell' => Icons.notifications_outlined,
    'person' || 'user' || 'account' => Icons.person_outline,
    'auto_awesome' || 'magic' || 'sparkle' => Icons.auto_awesome,
    'help' || 'question' => Icons.help_outline,
    'link' => Icons.link,
    'filter' => Icons.filter_list,
    'sort' => Icons.sort,
    'grid' => Icons.grid_view_outlined,
    'list' => Icons.list_outlined,
    'code' => Icons.code,
    'terminal' => Icons.terminal,
    'folder' => Icons.folder_outlined,
    'file' => Icons.insert_drive_file_outlined,
    'image' || 'photo' => Icons.image_outlined,
    'video' => Icons.videocam_outlined,
    'audio' || 'music' => Icons.music_note_outlined,
    'chart' || 'bar_chart' => Icons.bar_chart_outlined,
    'timeline' => Icons.timeline,
    _ => null,
  };
}
