import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_theme.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/common/icon_value.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildActionBarControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return ButterflyUIActionBar(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class ButterflyUIActionBar extends StatefulWidget {
  const ButterflyUIActionBar({
    super.key,
    required this.controlId,
    required this.props,
    required this.rawChildren,
    required this.buildChild,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final List<dynamic> rawChildren;
  final Widget Function(Map<String, Object?> child) buildChild;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<ButterflyUIActionBar> createState() => _ButterflyUIActionBarState();
}

class _ButterflyUIActionBarState extends State<ButterflyUIActionBar> {
  Map<String, Object?> _liveProps = const <String, Object?>{};
  List<Map<String, Object?>> _items = const <Map<String, Object?>>[];
  String? _activeId;

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant ButterflyUIActionBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    if (oldWidget.props != widget.props) {
      _syncFromProps();
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  void _syncFromProps([Map<String, Object?>? props]) {
    _liveProps = <String, Object?>{...(props ?? widget.props)};
    _items = _coerceItems(_liveProps['items']);
    _activeId =
        _liveProps['active_id']?.toString() ??
        _liveProps['selected_id']?.toString() ??
        _liveProps['selected']?.toString();
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_items':
        setState(() {
          _items = _coerceItems(args['items']);
        });
        return _statePayload();
      case 'set_selected':
        setState(() {
          _activeId =
              args['active_id']?.toString() ??
              args['selected_id']?.toString() ??
              args['selected']?.toString();
        });
        return _statePayload();
      case 'set_props':
        final rawProps = args['props'];
        if (rawProps is Map) {
          final props = coerceObjectMap(rawProps);
          setState(() {
            _syncFromProps(<String, Object?>{..._liveProps, ...props});
          });
        }
        return _statePayload();
      case 'get_state':
        return _statePayload();
      case 'emit':
      case 'trigger':
        {
          final fallback = method == 'trigger' ? 'action' : method;
          final event = (args['event'] ?? args['name'] ?? fallback).toString();
          final payload = args['payload'] is Map
              ? coerceObjectMap(args['payload'] as Map)
              : <String, Object?>{};
          _emit(event, payload);
          return true;
        }
      default:
        throw UnsupportedError('Unknown action_bar method: $method');
    }
  }

  List<Map<String, Object?>> _coerceItems(Object? raw) {
    if (raw is! List) return const <Map<String, Object?>>[];
    final out = <Map<String, Object?>>[];
    for (final value in raw) {
      if (value is Map) {
        out.add(coerceObjectMap(value));
      }
    }
    return out;
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      'items': _items,
      'count': _items.length,
      'active_id': _activeId,
    };
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  void _selectAction(Map<String, Object?> item, int index) {
    final id = (item['id'] ?? item['action'] ?? index).toString();
    final label = (item['label'] ?? item['text'] ?? item['title'] ?? id)
        .toString();
    setState(() {
      _activeId = id;
    });
    final payload = <String, Object?>{
      'id': id,
      'label': label,
      'index': index,
      'item': item,
      if (item['value'] != null) 'value': item['value'],
    };
    _emit('action', payload);
    _emit('change', payload);
  }

  ButtonStyle _buttonStyleForVariant({
    required BuildContext context,
    required Map<String, Object?> item,
    required String variant,
    required bool dense,
    required bool selected,
  }) {
    final baseRadius = BorderRadius.circular(dense ? 10 : 12);
    final basePadding = EdgeInsets.symmetric(
      horizontal: dense ? 10 : 12,
      vertical: dense ? 8 : 10,
    );
    final mergedProps = <String, Object?>{..._liveProps, ...item};
    final defaultFilledBackground = butterflyuiResolveSlotColor(
      context,
      mergedProps,
      slot: 'background',
      explicit:
          mergedProps['selected_bgcolor'] ??
          mergedProps['selected_background'],
      fallback: butterflyuiPrimary(context),
    );
    final defaultForeground = butterflyuiResolveSlotColor(
      context,
      mergedProps,
      slot: 'label',
      fallback: butterflyuiText(context),
    );
    final selectedForeground = butterflyuiResolveSlotColor(
      context,
      mergedProps,
      slot: 'label',
      explicit:
          mergedProps['selected_text_color'] ??
          mergedProps['selected_foreground'],
      fallback: butterflyuiPrimary(context),
    );
    final surface = butterflyuiResolveSurfaceChrome(
      context,
      mergedProps,
      fallbackBackground: switch (variant) {
        'filled' => selected ? defaultFilledBackground : butterflyuiPrimary(context),
        'text' => selected
            ? butterflyuiPrimary(context).withValues(alpha: 0.12)
            : Colors.transparent,
        _ => Colors.transparent,
      },
      fallbackBorder: butterflyuiBorder(context),
      fallbackRadius: dense ? 10 : 12,
      fallbackBorderWidth: variant == 'text' ? 0.0 : 1.0,
      fallbackPadding: basePadding,
    );
    final foreground = switch (variant) {
      'filled' => butterflyuiResolveSlotColor(
        context,
        mergedProps,
        slot: 'label',
        fallback: _resolveReadableForeground(
          surface.backgroundColor ?? defaultFilledBackground,
        ),
      ),
      _ => selected ? selectedForeground : defaultForeground,
    };
    final side = surface.borderWidth > 0
        ? BorderSide(color: surface.borderColor, width: surface.borderWidth)
        : null;
    final visualDensity = dense
        ? VisualDensity.compact
        : VisualDensity.standard;
    final shape = RoundedRectangleBorder(
      borderRadius: baseRadius,
      side: side ?? BorderSide.none,
    );

    switch (variant) {
      case 'filled':
        return FilledButton.styleFrom(
          visualDensity: visualDensity,
          shape: shape,
          padding: surface.contentPadding ?? basePadding,
          foregroundColor: foreground,
          backgroundColor:
              surface.backgroundColor ?? defaultFilledBackground,
        );
      case 'outlined':
        return OutlinedButton.styleFrom(
          visualDensity: visualDensity,
          shape: shape,
          padding: surface.contentPadding ?? basePadding,
          foregroundColor: foreground,
          side: side,
          backgroundColor: surface.backgroundColor,
        );
      default:
        return TextButton.styleFrom(
          visualDensity: visualDensity,
          shape: shape,
          padding: surface.contentPadding ?? basePadding,
          foregroundColor: foreground,
          backgroundColor: surface.backgroundColor,
        );
    }
  }

  Widget _buildActionButton(
    BuildContext context,
    Map<String, Object?> item,
    int index, {
    required bool dense,
    required bool enabled,
  }) {
    final id = (item['id'] ?? item['action'] ?? index).toString();
    final label = (item['label'] ?? item['text'] ?? item['title'] ?? id)
        .toString();
    final selected = _activeId != null && _activeId == id;
    final variant = (item['variant'] ?? (selected ? 'filled' : 'outlined'))
        .toString()
        .toLowerCase();
    final mergedProps = <String, Object?>{..._liveProps, ...item};
    final icon = buildIconValue(
      item['icon'] ?? item['leading_icon'],
      size: dense ? 16 : 18,
    );
    final trailing = item['badge']?.toString();
    final style = _buttonStyleForVariant(
      context: context,
      item: item,
      variant: variant,
      dense: dense,
      selected: selected,
    );
    final labelColor = butterflyuiResolveSlotColor(
      context,
      mergedProps,
      slot: 'label',
      fallback: selected ? butterflyuiPrimary(context) : butterflyuiText(context),
    );

    final labelWidget = Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: labelColor,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
      ),
    );

    Widget? trailingWidget;
    if (trailing != null && trailing.isNotEmpty) {
      final badgeColor = butterflyuiResolveSlotColor(
        context,
        mergedProps,
        slot: 'background',
        explicit: mergedProps['badge_bgcolor'],
        fallback: butterflyuiSurfaceAlt(context).withValues(alpha: 0.82),
      );
      trailingWidget = Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: badgeColor,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          trailing,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: labelColor,
          ),
        ),
      );
    }

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[icon, const SizedBox(width: 8)],
        Flexible(child: labelWidget),
        ...?(trailingWidget == null ? null : <Widget>[trailingWidget]),
      ],
    );

    final onPressed = enabled ? () => _selectAction(item, index) : null;
    final onLongPress = enabled
        ? () => _emit('action_long_press', {
            'id': id,
            'label': label,
            'index': index,
            'item': item,
          })
        : null;

    if (variant == 'filled') {
      return FilledButton(
        style: style,
        onPressed: onPressed,
        onLongPress: onLongPress,
        child: content,
      );
    }
    if (variant == 'text') {
      return TextButton(
        style: style,
        onPressed: onPressed,
        onLongPress: onLongPress,
        child: content,
      );
    }
    return OutlinedButton(
      style: style,
      onPressed: onPressed,
      onLongPress: onLongPress,
      child: content,
    );
  }

  MainAxisAlignment _mainAxisAlignment(String value) {
    switch (value) {
      case 'center':
        return MainAxisAlignment.center;
      case 'end':
      case 'right':
        return MainAxisAlignment.end;
      case 'space_between':
        return MainAxisAlignment.spaceBetween;
      case 'space_around':
        return MainAxisAlignment.spaceAround;
      case 'space_evenly':
        return MainAxisAlignment.spaceEvenly;
      default:
        return MainAxisAlignment.start;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dense = _liveProps['dense'] == true;
    final enabled = _liveProps['enabled'] == null
        ? true
        : (_liveProps['enabled'] == true);
    final wrap = _liveProps['wrap'] == true;
    final scrollable = _liveProps['scrollable'] == true;
    final spacing = coerceDouble(_liveProps['spacing']) ?? (dense ? 6 : 8);
    final runSpacing = coerceDouble(_liveProps['run_spacing']) ?? spacing;
    final surface = butterflyuiResolveSurfaceChrome(
      context,
      _liveProps,
      fallbackBackground: butterflyuiSurface(context).withValues(alpha: 0.78),
      fallbackBorder: butterflyuiBorder(context).withValues(alpha: 0.72),
      fallbackRadius: 14,
      fallbackPadding: EdgeInsets.symmetric(
        horizontal: dense ? 8 : 10,
        vertical: dense ? 6 : 8,
      ),
    );
    final titleColor = butterflyuiResolveSlotColor(
      context,
      _liveProps,
      slot: 'label',
      fallback: butterflyuiText(context),
    );
    final subtitleColor = butterflyuiResolveSlotColor(
      context,
      _liveProps,
      slot: 'content',
      fallback: butterflyuiMutedText(context),
      muted: true,
    );
    final alignment = _mainAxisAlignment(
      (_liveProps['alignment'] ?? _liveProps['main_axis'] ?? 'start')
          .toString()
          .toLowerCase()
          .replaceAll('-', '_'),
    );

    final title = _liveProps['title']?.toString();
    final subtitle = _liveProps['subtitle']?.toString();
    final maxVisible =
        coerceOptionalInt(_liveProps['max_visible']) ?? _items.length;
    final visibleItems = _items.take(maxVisible).toList(growable: false);

    final actionWidgets = <Widget>[
      for (var i = 0; i < visibleItems.length; i += 1)
        _buildActionButton(
          context,
          visibleItems[i],
          i,
          dense: dense,
          enabled: enabled && visibleItems[i]['enabled'] != false,
        ),
      for (final child in widget.rawChildren)
        if (child is Map) widget.buildChild(coerceObjectMap(child)),
    ];

    Widget actionRow;
    if (wrap) {
      actionRow = Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        alignment: switch (alignment) {
          MainAxisAlignment.center => WrapAlignment.center,
          MainAxisAlignment.end => WrapAlignment.end,
          MainAxisAlignment.spaceAround => WrapAlignment.spaceAround,
          MainAxisAlignment.spaceBetween => WrapAlignment.spaceBetween,
          MainAxisAlignment.spaceEvenly => WrapAlignment.spaceEvenly,
          _ => WrapAlignment.start,
        },
        crossAxisAlignment: WrapCrossAlignment.center,
        children: actionWidgets,
      );
    } else {
      final row = Row(
        mainAxisAlignment: alignment,
        mainAxisSize: MainAxisSize.max,
        children: [
          for (var i = 0; i < actionWidgets.length; i += 1) ...[
            if (i > 0) SizedBox(width: spacing),
            Flexible(fit: FlexFit.loose, child: actionWidgets[i]),
          ],
        ],
      );
      actionRow = scrollable
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: IntrinsicHeight(child: row),
            )
          : row;
    }

    final bar = Container(
      padding: surface.contentPadding,
      decoration: BoxDecoration(
        color: surface.backgroundColor,
        gradient: surface.gradient,
        border: Border.all(
          color: surface.borderColor,
          width: surface.borderWidth,
        ),
        borderRadius: BorderRadius.circular(surface.radius),
        boxShadow: surface.boxShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null && title.isNotEmpty)
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: titleColor,
              ),
            ),
          if (subtitle != null && subtitle.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: subtitleColor),
            ),
          ],
          if (title != null && title.isNotEmpty ||
              subtitle != null && subtitle.isNotEmpty)
            SizedBox(height: dense ? 6 : 8),
          actionRow,
        ],
      ),
    );

    return applyControlFrameLayout(
      props: _liveProps,
      child: bar,
      clipToRadius: true,
      defaultRadius: surface.radius,
    );
  }
}

Color _resolveReadableForeground(Color background) {
  return ThemeData.estimateBrightnessForColor(background) == Brightness.dark
      ? Colors.white
      : Colors.black;
}
