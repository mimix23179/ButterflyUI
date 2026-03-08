import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:highlight/highlight.dart' as highlight;
import 'package:markdown/markdown.dart' as md;

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

import 'html_view.dart';

Widget buildMarkdownViewControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _MarkdownViewControl(
    controlId: controlId,
    initialProps: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _MarkdownViewControl extends StatefulWidget {
  const _MarkdownViewControl({
    required this.controlId,
    required this.initialProps,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> initialProps;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_MarkdownViewControl> createState() => _MarkdownViewControlState();
}

class _MarkdownViewControlState extends State<_MarkdownViewControl> {
  late String _value =
      (widget.initialProps['value'] ?? widget.initialProps['text'] ?? '')
          .toString();

  @override
  void initState() {
    super.initState();
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void didUpdateWidget(covariant _MarkdownViewControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
    if (oldWidget.initialProps != widget.initialProps) {
      _value =
          (widget.initialProps['value'] ?? widget.initialProps['text'] ?? '')
              .toString();
    }
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    super.dispose();
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'get_value':
        return _value;
      case 'set_value':
        setState(() {
          _value = (args['value'] ?? '').toString();
        });
        return null;
      case 'emit':
        final event = (args['event'] ?? '').toString().trim();
        if (event.isEmpty) return null;
        final payload = args['payload'];
        widget.sendEvent(
          widget.controlId,
          event,
          payload is Map ? coerceObjectMap(payload) : <String, Object?>{},
        );
        return null;
      default:
        throw UnsupportedError('Unknown markdown method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final props = widget.initialProps;
    final value = _value;
    if (value.isEmpty) {
      return const SizedBox.shrink();
    }
    final allowHtml = props['allow_html'] == true;
    final normalizedValue = _normalizeMarkdownSource(
      value,
      allowHtml: allowHtml,
    );

    final renderMode = (props['render_mode'] ?? props['mode'] ?? 'markdown')
        .toString()
        .trim()
        .toLowerCase();
    if (renderMode == 'html') {
      final htmlProps = <String, Object?>{
        ...props,
        'html': md.markdownToHtml(
          normalizedValue,
          extensionSet: md.ExtensionSet.gitHubFlavored,
          encodeHtml: !allowHtml,
        ),
      };
      final nestedId = widget.controlId.isEmpty
          ? 'markdown_view::html'
          : '${widget.controlId}::html';
      return buildHtmlViewControl(
        nestedId,
        htmlProps,
        widget.registerInvokeHandler,
        widget.unregisterInvokeHandler,
        widget.sendEvent,
      );
    }

    final selectable = props['selectable'] == true;
    final scrollable = props['scrollable'] == null
        ? true
        : (props['scrollable'] == true);
    final useFlutterMarkdown = props['use_flutter_markdown'] == null
        ? true
        : (props['use_flutter_markdown'] == true);
    final padding = coercePadding(props['content_padding'] ?? props['padding']);
    final inlineSyntaxes = <md.InlineSyntax>[
      _WrappedDelimiterSyntax(pattern: r'\+\+', startCharacter: 43, tag: 'u'),
      _WrappedDelimiterSyntax(pattern: r'==', startCharacter: 61, tag: 'mark'),
      _WrappedDelimiterSyntax(
        pattern: r'\^\^',
        startCharacter: 94,
        tag: 'small',
      ),
    ];

    if (!useFlutterMarkdown) {
      Widget fallback = selectable
          ? SelectableText(normalizedValue)
          : Text(normalizedValue, softWrap: true);
      if (padding != null) {
        fallback = Padding(padding: padding, child: fallback);
      }
      if (!scrollable) {
        return fallback;
      }
      return SingleChildScrollView(child: fallback);
    }

    final theme = Theme.of(context);
    final markdownStyle = MarkdownStyleSheet.fromTheme(theme).copyWith(
      p: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
      a: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.primary,
        decoration: TextDecoration.underline,
      ),
      code: theme.textTheme.bodySmall?.copyWith(
        fontFamily: 'Consolas',
        color: theme.colorScheme.primaryContainer,
        backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.36,
        ),
      ),
      codeblockPadding: const EdgeInsets.all(14),
      codeblockDecoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.62,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.24),
        ),
      ),
      blockquotePadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      blockquoteDecoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.52),
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: theme.colorScheme.primary.withValues(alpha: 0.72),
            width: 3,
          ),
        ),
      ),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.34),
            width: 1,
          ),
        ),
      ),
      tableBorder: TableBorder.all(
        color: theme.colorScheme.outline.withValues(alpha: 0.24),
        width: 1,
      ),
    );
    final syntaxHighlighter = _ButterflyMarkdownSyntaxHighlighter(theme);
    final builders = <String, MarkdownElementBuilder>{
      'u': _InlineTextStyleBuilder(
        merge: (style) => style.copyWith(decoration: TextDecoration.underline),
      ),
      'ins': _InlineTextStyleBuilder(
        merge: (style) => style.copyWith(decoration: TextDecoration.underline),
      ),
      'mark': _InlineTextStyleBuilder(
        merge: (style) => style.copyWith(
          backgroundColor: theme.colorScheme.tertiaryContainer.withValues(
            alpha: 0.82,
          ),
          color: theme.colorScheme.onTertiaryContainer,
        ),
      ),
      'small': _InlineTextStyleBuilder(
        merge: (style) =>
            style.copyWith(fontSize: ((style.fontSize ?? 14) * 0.88)),
      ),
    };

    final markdownWidget = scrollable
        ? Markdown(
            data: normalizedValue,
            selectable: selectable,
            shrinkWrap: props['shrink_wrap'] == true,
            padding: padding ?? EdgeInsets.zero,
            imageDirectory: props['image_directory']?.toString(),
            softLineBreak: props['soft_line_break'] == true,
            syntaxHighlighter: syntaxHighlighter,
            extensionSet: md.ExtensionSet.gitHubFlavored,
            inlineSyntaxes: inlineSyntaxes,
            styleSheet: markdownStyle,
            builders: builders,
            onTapLink: (text, href, title) {
              widget.sendEvent(widget.controlId, 'link_tap', <String, Object?>{
                'text': text,
                'href': href,
                'title': title,
              });
            },
          )
        : MarkdownBody(
            data: normalizedValue,
            selectable: selectable,
            imageDirectory: props['image_directory']?.toString(),
            softLineBreak: props['soft_line_break'] == true,
            syntaxHighlighter: syntaxHighlighter,
            extensionSet: md.ExtensionSet.gitHubFlavored,
            inlineSyntaxes: inlineSyntaxes,
            styleSheet: markdownStyle,
            builders: builders,
            onTapLink: (text, href, title) {
              widget.sendEvent(widget.controlId, 'link_tap', <String, Object?>{
                'text': text,
                'href': href,
                'title': title,
              });
            },
          );

    if (scrollable) {
      return markdownWidget;
    }
    if (padding == null) {
      return markdownWidget;
    }
    return Padding(padding: padding, child: markdownWidget);
  }
}

String _normalizeMarkdownSource(String source, {required bool allowHtml}) {
  var normalized = source.replaceAll('\r\n', '\n');
  if (!allowHtml) {
    return normalized;
  }
  normalized = _replaceInlineTag(normalized, tag: 'u', open: '++', close: '++');
  normalized = _replaceInlineTag(
    normalized,
    tag: 'ins',
    open: '++',
    close: '++',
  );
  normalized = _replaceInlineTag(
    normalized,
    tag: 'mark',
    open: '==',
    close: '==',
  );
  normalized = _replaceInlineTag(
    normalized,
    tag: 'small',
    open: '^^',
    close: '^^',
  );
  normalized = _replaceInlineTag(normalized, tag: 'b', open: '**', close: '**');
  normalized = _replaceInlineTag(
    normalized,
    tag: 'strong',
    open: '**',
    close: '**',
  );
  normalized = _replaceInlineTag(normalized, tag: 'i', open: '*', close: '*');
  normalized = _replaceInlineTag(normalized, tag: 'em', open: '*', close: '*');
  normalized = _replaceInlineTag(normalized, tag: 's', open: '~~', close: '~~');
  normalized = _replaceInlineTag(
    normalized,
    tag: 'strike',
    open: '~~',
    close: '~~',
  );
  normalized = _replaceInlineTag(
    normalized,
    tag: 'del',
    open: '~~',
    close: '~~',
  );
  normalized = normalized.replaceAllMapped(
    RegExp(r'<\s*br\s*/?\s*>', caseSensitive: false),
    (_) => '  \n',
  );
  normalized = normalized.replaceAllMapped(
    RegExp(r'<\s*hr\s*/?\s*>', caseSensitive: false),
    (_) => '\n\n---\n\n',
  );
  return normalized;
}

String _replaceInlineTag(
  String source, {
  required String tag,
  required String open,
  required String close,
}) {
  final pattern = RegExp(
    '<\\s*$tag\\b[^>]*>([\\s\\S]*?)<\\s*/\\s*$tag\\s*>',
    caseSensitive: false,
  );
  return source.replaceAllMapped(pattern, (match) {
    final content = match.group(1)?.trim() ?? '';
    return '$open$content$close';
  });
}

class _InlineTextStyleBuilder extends MarkdownElementBuilder {
  _InlineTextStyleBuilder({required this.merge});

  final TextStyle Function(TextStyle style) merge;

  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    final baseStyle =
        preferredStyle ?? parentStyle ?? DefaultTextStyle.of(context).style;
    return Text(element.textContent, style: merge(baseStyle));
  }
}

class _WrappedDelimiterSyntax extends md.DelimiterSyntax {
  _WrappedDelimiterSyntax({
    required String pattern,
    required int startCharacter,
    required String tag,
  }) : super(
         pattern,
         requiresDelimiterRun: true,
         allowIntraWord: true,
         startCharacter: startCharacter,
         tags: <md.DelimiterTag>[md.DelimiterTag(tag, 2)],
       );
}

class _ButterflyMarkdownSyntaxHighlighter extends SyntaxHighlighter {
  _ButterflyMarkdownSyntaxHighlighter(this.theme);

  final ThemeData theme;

  @override
  TextSpan format(String source) {
    final baseStyle = theme.textTheme.bodySmall?.copyWith(
      fontFamily: 'Consolas',
      color: theme.colorScheme.onSurface,
      height: 1.45,
    );
    highlight.Result parsed;
    try {
      parsed = highlight.highlight.parse(source, autoDetection: true);
    } catch (_) {
      return TextSpan(style: baseStyle, text: source);
    }
    final children = _buildSpans(parsed.nodes, baseStyle);
    return TextSpan(style: baseStyle, children: children);
  }

  List<TextSpan> _buildSpans(
    List<highlight.Node>? nodes,
    TextStyle? baseStyle,
  ) {
    if (nodes == null || nodes.isEmpty) {
      return const <TextSpan>[];
    }
    return nodes.map((node) => _buildSpan(node, baseStyle)).toList();
  }

  TextSpan _buildSpan(highlight.Node node, TextStyle? baseStyle) {
    final style = _styleForClass(node.className, baseStyle);
    if (node.value != null) {
      return TextSpan(text: node.value, style: style);
    }
    return TextSpan(
      style: style,
      children: _buildSpans(node.children, style ?? baseStyle),
    );
  }

  TextStyle? _styleForClass(String? className, TextStyle? baseStyle) {
    if (baseStyle == null || className == null || className.isEmpty) {
      return baseStyle;
    }
    final colorScheme = theme.colorScheme;
    switch (className) {
      case 'keyword':
      case 'selector-tag':
      case 'literal':
        return baseStyle.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w700,
        );
      case 'string':
      case 'regexp':
      case 'attr':
      case 'attribute':
        return baseStyle.copyWith(color: const Color(0xFF98C379));
      case 'number':
      case 'symbol':
      case 'bullet':
        return baseStyle.copyWith(color: const Color(0xFFD19A66));
      case 'comment':
      case 'quote':
        return baseStyle.copyWith(
          color: colorScheme.onSurface.withValues(alpha: 0.58),
          fontStyle: FontStyle.italic,
        );
      case 'title':
      case 'section':
      case 'type':
      case 'built_in':
        return baseStyle.copyWith(
          color: const Color(0xFF61AFEF),
          fontWeight: FontWeight.w600,
        );
      case 'subst':
      case 'meta':
        return baseStyle.copyWith(color: const Color(0xFF56B6C2));
      default:
        return baseStyle;
    }
  }
}
