import 'dart:math' as math;

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:flutter/material.dart';

import '../../studio_contract.dart';

class StudioTimelineSurface extends StatelessWidget {
  const StudioTimelineSurface({
    super.key,
    required this.surfaceProps,
    required this.selectedIds,
    required this.onSelectClip,
  });

  final Map<String, Object?> surfaceProps;
  final Set<String> selectedIds;
  final void Function(String id, {bool additive}) onSelectClip;

  @override
  Widget build(BuildContext context) {
    final tracks = _tracks();
    final pixelsPerSecond =
        (coerceDouble(surfaceProps['pixels_per_second']) ?? 96).clamp(16, 320);
    final durationSeconds =
        (coerceDouble(surfaceProps['duration_seconds']) ?? 90).clamp(10, 14400);
    final width = (durationSeconds * pixelsPerSecond).clamp(640, 12000);
    final playhead = (coerceDouble(surfaceProps['playhead_seconds']) ?? 0)
        .clamp(0, durationSeconds);

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: width.toDouble(),
          child: Column(
            children: [
              _TimelineRuler(
                width: width.toDouble(),
                pixelsPerSecond: pixelsPerSecond.toDouble(),
                durationSeconds: durationSeconds.toDouble(),
                playheadSeconds: playhead.toDouble(),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: tracks.length,
                  separatorBuilder: (_, index) => Divider(
                    height: 1,
                    color: Theme.of(
                      context,
                    ).dividerColor.withValues(alpha: 0.6),
                  ),
                  itemBuilder: (context, index) {
                    final track = tracks[index];
                    final clips = studioCoerceMapList(track['clips']);
                    return _TimelineTrackRow(
                      track: track,
                      clips: clips,
                      pixelsPerSecond: pixelsPerSecond.toDouble(),
                      selectedIds: selectedIds,
                      width: width.toDouble(),
                      onSelectClip: onSelectClip,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, Object?>> _tracks() {
    final tracks = studioCoerceMapList(surfaceProps['tracks']);
    if (tracks.isNotEmpty) return tracks;
    return <Map<String, Object?>>[
      {
        'id': 'video_1',
        'label': 'Video 1',
        'clips': [
          {'id': 'clip_intro', 'start': 0, 'duration': 9, 'label': 'Intro'},
          {
            'id': 'clip_scene_a',
            'start': 12,
            'duration': 18,
            'label': 'Scene A',
          },
        ],
      },
      {
        'id': 'audio_1',
        'label': 'Audio 1',
        'clips': [
          {
            'id': 'clip_music',
            'start': 0,
            'duration': 42,
            'label': 'Music Bed',
          },
        ],
      },
    ];
  }
}

class _TimelineRuler extends StatelessWidget {
  const _TimelineRuler({
    required this.width,
    required this.pixelsPerSecond,
    required this.durationSeconds,
    required this.playheadSeconds,
  });

  final double width;
  final double pixelsPerSecond;
  final double durationSeconds;
  final double playheadSeconds;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _RulerPainter(
                pixelsPerSecond: pixelsPerSecond,
                durationSeconds: durationSeconds,
                tickColor: Theme.of(context).dividerColor,
              ),
            ),
          ),
          Positioned(
            left: playheadSeconds * pixelsPerSecond,
            top: 0,
            bottom: 0,
            child: Container(
              width: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineTrackRow extends StatelessWidget {
  const _TimelineTrackRow({
    required this.track,
    required this.clips,
    required this.pixelsPerSecond,
    required this.selectedIds,
    required this.width,
    required this.onSelectClip,
  });

  final Map<String, Object?> track;
  final List<Map<String, Object?>> clips;
  final double pixelsPerSecond;
  final Set<String> selectedIds;
  final double width;
  final void Function(String id, {bool additive}) onSelectClip;

  @override
  Widget build(BuildContext context) {
    final label = (track['label'] ?? track['id'] ?? 'Track').toString();
    return SizedBox(
      height: 72,
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              width: width,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ColoredBox(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withValues(alpha: 0.22),
                    ),
                  ),
                  for (final clip in clips)
                    _TimelineClip(
                      clip: clip,
                      pixelsPerSecond: pixelsPerSecond,
                      selected: selectedIds.contains(
                        (clip['id'] ?? '').toString(),
                      ),
                      onTap: () => onSelectClip(
                        (clip['id'] ?? '').toString(),
                        additive: false,
                      ),
                      onLongPress: () => onSelectClip(
                        (clip['id'] ?? '').toString(),
                        additive: true,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineClip extends StatelessWidget {
  const _TimelineClip({
    required this.clip,
    required this.pixelsPerSecond,
    required this.selected,
    required this.onTap,
    required this.onLongPress,
  });

  final Map<String, Object?> clip;
  final double pixelsPerSecond;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final start = (coerceDouble(clip['start']) ?? 0).clamp(0, double.infinity);
    final duration = (coerceDouble(clip['duration']) ?? 1).clamp(
      0.2,
      double.infinity,
    );
    final left = start * pixelsPerSecond;
    final width = math.max(18, duration * pixelsPerSecond);

    return Positioned(
      left: left.toDouble(),
      top: 12,
      bottom: 12,
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          width: width.toDouble(),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: selected
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.78)
                : Theme.of(
                    context,
                  ).colorScheme.secondary.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: selected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).dividerColor,
            ),
          ),
          child: Text(
            (clip['label'] ?? clip['id'] ?? 'Clip').toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _RulerPainter extends CustomPainter {
  _RulerPainter({
    required this.pixelsPerSecond,
    required this.durationSeconds,
    required this.tickColor,
  });

  final double pixelsPerSecond;
  final double durationSeconds;
  final Color tickColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = tickColor
      ..strokeWidth = 1;
    const majorTick = 5;
    for (var sec = 0; sec <= durationSeconds; sec += 1) {
      final x = sec * pixelsPerSecond;
      final isMajor = sec % majorTick == 0;
      final tickHeight = isMajor ? size.height : size.height * 0.45;
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x, size.height - tickHeight),
        paint,
      );
      if (isMajor) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: '${sec}s',
            style: TextStyle(color: tickColor, fontSize: 10),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        textPainter.paint(canvas, Offset(x + 2, 2));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RulerPainter oldDelegate) {
    return oldDelegate.pixelsPerSecond != pixelsPerSecond ||
        oldDelegate.durationSeconds != durationSeconds ||
        oldDelegate.tickColor != tickColor;
  }
}
