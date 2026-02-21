import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class ButterflyUIAppBar extends StatefulWidget {
  final String controlId;
  final String? title;
  final String? subtitle;
  final bool centerTitle;
  final double height;
  final Color? bgcolor;
  final double elevation;
  final EdgeInsets padding;
  final Widget? leading;
  final List<Widget> actions;
  final bool showSearch;
  final String searchValue;
  final String? searchPlaceholder;
  final bool searchEnabled;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUIAppBar({
    super.key,
    required this.controlId,
    required this.title,
    required this.subtitle,
    required this.centerTitle,
    required this.height,
    required this.bgcolor,
    required this.elevation,
    required this.padding,
    required this.leading,
    required this.actions,
    required this.showSearch,
    required this.searchValue,
    required this.searchPlaceholder,
    required this.searchEnabled,
    required this.sendEvent,
  });

  @override
  State<ButterflyUIAppBar> createState() => _ButterflyUIAppBarState();
}

class _ButterflyUIAppBarState extends State<ButterflyUIAppBar> {
  late TextEditingController _controller;
  String _lastValue = '';

  @override
  void initState() {
    super.initState();
    _lastValue = widget.searchValue;
    _controller = TextEditingController(text: widget.searchValue);
  }

  @override
  void didUpdateWidget(covariant ButterflyUIAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchValue != _lastValue) {
      _lastValue = widget.searchValue;
      _controller.text = widget.searchValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titleWidget = (widget.title == null && widget.subtitle == null)
        ? const SizedBox.shrink()
        : Column(
            crossAxisAlignment: widget.centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.title != null)
                Text(widget.title!, style: const TextStyle(fontWeight: FontWeight.w600)),
              if (widget.subtitle != null) Text(widget.subtitle!, style: Theme.of(context).textTheme.bodySmall),
            ],
          );

    final searchField = widget.showSearch
        ? SizedBox(
            width: 220,
            child: TextField(
              controller: _controller,
              enabled: widget.searchEnabled,
              onChanged: (value) => widget.sendEvent(widget.controlId, 'search', {'query': value}),
              onSubmitted: (value) => widget.sendEvent(widget.controlId, 'search_submit', {'query': value}),
              decoration: InputDecoration(
                isDense: true,
                prefixIcon: const Icon(Icons.search),
                hintText: widget.searchPlaceholder ?? 'Search',
              ),
            ),
          )
        : const SizedBox.shrink();

    final row = Row(
      children: [
        if (widget.leading != null) widget.leading!,
        Expanded(
          child: Align(
            alignment: widget.centerTitle ? Alignment.center : Alignment.centerLeft,
            child: titleWidget,
          ),
        ),
        if (widget.showSearch) ...[
          const SizedBox(width: 12),
          searchField,
        ],
        if (widget.actions.isNotEmpty) ...widget.actions,
      ],
    );

    return Material(
      color: widget.bgcolor ?? Theme.of(context).colorScheme.surface,
      elevation: widget.elevation,
      child: SizedBox(
        height: widget.height,
        child: Padding(padding: widget.padding, child: row),
      ),
    );
  }
}

