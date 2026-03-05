import 'package:flutter/material.dart';

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

  void _syncFromProps() {
    _items = _coerceItems(widget.props['items']);
    _activeId =
        widget.props['active_id']?.toString() ??
        widget.props['selected_id']?.toString() ??
        widget.props['selected']?.toString();
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
            if (props.containsKey('items')) {
              _items = _coerceItems(props['items']);
            }
            if (props.containsKey('active_id') ||
                props.containsKey('selected_id') ||
                props.containsKey('selected')) {
              _activeId =
                  props['active_id']?.toString() ??
                  props['selected_id']?.toString() ??
                  props['selected']?.toString();
            }
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
    required String variant,
    required bool dense,
    required bool selected,
  }) {
    final baseRadius = BorderRadius.circular(dense ? 10 : 12);
    final basePadding = EdgeInsets.symmetric(
      horizontal: dense ? 10 : 12,
      vertical: dense ? 8 : 10,
    );

    switch (variant) {
      case 'filled':
        return FilledButton.styleFrom(
          visualDensity: dense ? VisualDensity.compact : VisualDensity.standard,
          shape: RoundedRectangleBorder(borderRadius: baseRadius),
          padding: basePadding,
        );
      case 'outlined':
        return OutlinedButton.styleFrom(
          visualDensity: dense ? VisualDensity.compact : VisualDensity.standard,
          shape: RoundedRectangleBorder(borderRadius: baseRadius),
          padding: basePadding,
        );
      default:
        return TextButton.styleFrom(
          visualDensity: dense ? VisualDensity.compact : VisualDensity.standard,
          shape: RoundedRectangleBorder(borderRadius: baseRadius),
          padding: basePadding,
          backgroundColor: selected
              ? Theme.of(
                  context,
                ).colorScheme.primaryContainer.withValues(alpha: 0.45)
              : null,
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
    final icon = buildIconValue(
      item['icon'] ?? item['leading_icon'],
      size: dense ? 16 : 18,
    );
    final trailing = item['badge']?.toString();
    final style = _buttonStyleForVariant(
      context: context,
      variant: variant,
      dense: dense,
      selected: selected,
    );

    final labelWidget = Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
      ),
    );

    Widget? trailingWidget;
    if (trailing != null && trailing.isNotEmpty) {
      trailingWidget = Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(trailing, style: Theme.of(context).textTheme.labelSmall),
      );
    }

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[icon, const SizedBox(width: 8)],
        Flexible(child: labelWidget),
        if (trailingWidget != null) trailingWidget,
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
    final dense = widget.props['dense'] == true;
    final enabled = widget.props['enabled'] == null
        ? true
        : (widget.props['enabled'] == true);
    final wrap = widget.props['wrap'] == true;
    final scrollable = widget.props['scrollable'] == true;
    final spacing = coerceDouble(widget.props['spacing']) ?? (dense ? 6 : 8);
    final runSpacing = coerceDouble(widget.props['run_spacing']) ?? spacing;
    final bgColor =
        coerceColor(widget.props['bgcolor'] ?? widget.props['background']) ??
        Theme.of(context).colorScheme.surface.withValues(alpha: 0.75);
    final borderColor =
        coerceColor(widget.props['border_color']) ??
        Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.7);
    final radius = coerceDouble(widget.props['radius']) ?? 14;
    final padding =
        coercePadding(widget.props['padding']) ??
        EdgeInsets.symmetric(
          horizontal: dense ? 8 : 10,
          vertical: dense ? 6 : 8,
        );
    final alignment = _mainAxisAlignment(
      (widget.props['alignment'] ?? widget.props['main_axis'] ?? 'start')
          .toString()
          .toLowerCase()
          .replaceAll('-', '_'),
    );

    final title = widget.props['title']?.toString();
    final subtitle = widget.props['subtitle']?.toString();
    final maxVisible =
        coerceOptionalInt(widget.props['max_visible']) ?? _items.length;
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
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(radius),
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
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          if (subtitle != null && subtitle.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          ],
          if (title != null && title.isNotEmpty ||
              subtitle != null && subtitle.isNotEmpty)
            SizedBox(height: dense ? 6 : 8),
          actionRow,
        ],
      ),
    );

    return applyControlFrameLayout(
      props: widget.props,
      child: bar,
      clipToRadius: true,
      defaultRadius: radius,
    );
  }
}
