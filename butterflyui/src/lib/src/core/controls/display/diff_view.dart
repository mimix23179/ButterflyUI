import 'package:diff_match_patch/diff_match_patch.dart';
import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

Widget buildDiffViewControl(Map<String, Object?> props) {
  final before = (props['before'] ?? props['left'] ?? '').toString();
  final after = (props['after'] ?? props['right'] ?? '').toString();
  final showLineNumbers = props['show_line_numbers'] == true;
  final wrap = props['wrap'] == null ? true : (props['wrap'] == true);
  final split = props['split'] == true || props['view_mode']?.toString() == 'split';
  final addedColor = coerceColor(props['added_color']) ?? const Color(0xffdcfce7);
  final removedColor = coerceColor(props['removed_color']) ?? const Color(0xfffee2e2);
  final unchangedColor = coerceColor(props['unchanged_color']) ?? Colors.transparent;

  final differ = DiffMatchPatch();
  final diffs = differ.diff(before, after);

  if (split) {
    return Row(
      children: [
        Expanded(
          child: _buildDiffPanel(
            diffs,
            showLeft: true,
            showLineNumbers: showLineNumbers,
            wrap: wrap,
            addedColor: addedColor,
            removedColor: removedColor,
            unchangedColor: unchangedColor,
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: _buildDiffPanel(
            diffs,
            showLeft: false,
            showLineNumbers: showLineNumbers,
            wrap: wrap,
            addedColor: addedColor,
            removedColor: removedColor,
            unchangedColor: unchangedColor,
          ),
        ),
      ],
    );
  }

  return _buildUnifiedDiff(
    diffs,
    showLineNumbers: showLineNumbers,
    wrap: wrap,
    addedColor: addedColor,
    removedColor: removedColor,
    unchangedColor: unchangedColor,
  );
}

Widget _buildUnifiedDiff(
  List<Diff> diffs, {
  required bool showLineNumbers,
  required bool wrap,
  required Color addedColor,
  required Color removedColor,
  required Color unchangedColor,
}) {
  final children = <Widget>[];
  var lineNumber = 1;
  for (final diff in diffs) {
    final lines = diff.text.split('\n');
    for (var i = 0; i < lines.length; i += 1) {
      final line = lines[i];
      if (line.isEmpty && i == lines.length - 1) continue;
      Color bg = unchangedColor;
      String marker = ' ';
      if (diff.operation == DIFF_INSERT) {
        bg = addedColor;
        marker = '+';
      } else if (diff.operation == DIFF_DELETE) {
        bg = removedColor;
        marker = '-';
      }
      children.add(
        Container(
          color: bg,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showLineNumbers)
                SizedBox(
                  width: 46,
                  child: Text(
                    '$lineNumber',
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              SizedBox(
                width: 16,
                child: Text(marker),
              ),
              Expanded(
                child: Text(line, softWrap: wrap),
              ),
            ],
          ),
        ),
      );
      lineNumber += 1;
    }
  }
  return ListView(children: children);
}

Widget _buildDiffPanel(
  List<Diff> diffs, {
  required bool showLeft,
  required bool showLineNumbers,
  required bool wrap,
  required Color addedColor,
  required Color removedColor,
  required Color unchangedColor,
}) {
  final children = <Widget>[];
  var lineNumber = 1;

  for (final diff in diffs) {
    if (showLeft && diff.operation == DIFF_INSERT) continue;
    if (!showLeft && diff.operation == DIFF_DELETE) continue;
    final lines = diff.text.split('\n');
    for (var i = 0; i < lines.length; i += 1) {
      final line = lines[i];
      if (line.isEmpty && i == lines.length - 1) continue;
      final bg = diff.operation == DIFF_INSERT
          ? addedColor
          : diff.operation == DIFF_DELETE
              ? removedColor
              : unchangedColor;
      children.add(
        Container(
          color: bg,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showLineNumbers)
                SizedBox(
                  width: 46,
                  child: Text(
                    '$lineNumber',
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              Expanded(child: Text(line, softWrap: wrap)),
            ],
          ),
        ),
      );
      lineNumber += 1;
    }
  }

  return ListView(children: children);
}
