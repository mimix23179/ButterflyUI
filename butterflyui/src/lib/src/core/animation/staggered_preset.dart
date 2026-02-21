import 'package:flutter/material.dart';

class StaggeredList extends StatefulWidget {
  final List<Widget> children;
  final Duration perChildDelay;
  final Duration childDuration;

  const StaggeredList({super.key, required this.children, this.perChildDelay = const Duration(milliseconds: 70), this.childDuration = const Duration(milliseconds: 220)});

  @override
  State<StaggeredList> createState() => _StaggeredListState();
}

class _StaggeredListState extends State<StaggeredList> {
  late final List<bool> _visible;

  @override
  void initState() {
    super.initState();
    _visible = List<bool>.filled(widget.children.length, false);
    _run();
  }

  void _run() async {
    for (var i = 0; i < widget.children.length; i++) {
      await Future.delayed(widget.perChildDelay);
      if (!mounted) return;
      setState(() => _visible[i] = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.children.length, (i) {
        return AnimatedOpacity(
          duration: widget.childDuration,
          opacity: _visible[i] ? 1.0 : 0.0,
          child: widget.children[i],
        );
      }),
    );
  }
}
