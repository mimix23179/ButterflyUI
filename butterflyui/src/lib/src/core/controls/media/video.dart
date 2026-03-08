import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart' as media_video;

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildVideoControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent, {
  List<dynamic> rawChildren = const <dynamic>[],
  Widget Function(Map<String, Object?> child)? buildChild,
}) {
  return _VideoControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _VideoControl extends StatefulWidget {
  const _VideoControl({
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
  final Widget Function(Map<String, Object?> child)? buildChild;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_VideoControl> createState() => _VideoControlState();
}

class _VideoControlState extends State<_VideoControl> {
  Player? _player;
  media_video.VideoController? _videoController;
  final List<StreamSubscription<dynamic>> _subscriptions =
      <StreamSubscription<dynamic>>[];

  bool _playing = false;
  bool _loading = false;
  bool _muted = false;
  double _positionSeconds = 0.0;
  double _durationSeconds = 0.0;
  double _volume = 1.0;
  String? _openedSource;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    _syncFromProps(forceReopen: true);
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _VideoControl oldWidget) {
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
      _syncFromProps(
        forceReopen:
            _resolvedVideoSource(oldWidget.props) !=
            _resolvedVideoSource(widget.props),
      );
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _player?.dispose();
    super.dispose();
  }

  void _initializePlayer() {
    if (_isWidgetTestBinding()) {
      _player = null;
      _videoController = null;
      return;
    }
    try {
      MediaKit.ensureInitialized();
      final player = Player();
      _player = player;
      _videoController = media_video.VideoController(player);
      _bindPlayerStreams(player);
    } catch (_) {
      _player = null;
      _videoController = null;
    }
  }

  void _bindPlayerStreams(Player player) {
    _subscriptions.add(
      player.stream.playing.listen((playing) {
        if (!mounted) return;
        setState(() {
          _playing = playing;
        });
      }),
    );
    _subscriptions.add(
      player.stream.position.listen((position) {
        if (!mounted) return;
        setState(() {
          _positionSeconds = _normalizeVideoSeconds(
            position.inMilliseconds / 1000,
          );
        });
      }),
    );
    _subscriptions.add(
      player.stream.duration.listen((duration) {
        if (!mounted) return;
        setState(() {
          _durationSeconds = _normalizeVideoSeconds(
            duration.inMilliseconds / 1000,
          );
        });
      }),
    );
    _subscriptions.add(
      player.stream.volume.listen((volume) {
        if (!mounted) return;
        setState(() {
          _volume = _playerVideoVolumeToFramework(volume);
        });
      }),
    );
    _subscriptions.add(
      player.stream.completed.listen((completed) {
        if (!completed || !mounted) return;
        setState(() {
          _playing = false;
        });
        _emit('ended', _statePayload());
      }),
    );
  }

  Future<void> _syncFromProps({required bool forceReopen}) async {
    final player = _player;
    final source = _resolvedVideoSource(widget.props);
    final requestedMuted = _readVideoBool(widget.props['muted']);
    final requestedVolume = _resolveVideoFrameworkVolume(
      widget.props['volume'],
    );
    final requestedPosition = _normalizeVideoSeconds(
      coerceDouble(widget.props['position']) ?? 0.0,
    );

    if (mounted) {
      setState(() {
        _muted = requestedMuted;
        _volume = requestedVolume;
        if (_openedSource == null || _openedSource!.isEmpty) {
          _positionSeconds = requestedPosition;
        }
      });
    }

    await _applyPlaybackConfig();

    if (source.isEmpty) {
      if (_openedSource != null && _openedSource!.isNotEmpty) {
        await player?.stop();
      }
      if (!mounted) return;
      setState(() {
        _openedSource = null;
        _loading = false;
        _errorMessage = null;
        _playing = false;
      });
      return;
    }

    if (player == null) {
      if (!mounted) return;
      setState(() {
        _openedSource = source;
        _loading = false;
        _playing = false;
        _errorMessage = 'Video playback backend unavailable on this runtime.';
        _durationSeconds = _normalizeVideoSeconds(
          coerceDouble(widget.props['duration']) ?? _durationSeconds,
        );
      });
      return;
    }

    if (forceReopen || source != _openedSource) {
      await _openSource(
        source,
        autoplay: _readVideoBool(widget.props['autoplay']),
        initialPositionSeconds: requestedPosition,
      );
      return;
    }

    if (requestedPosition > 0 &&
        (_positionSeconds - requestedPosition).abs() > 0.5) {
      await _seekTo(requestedPosition, emitEvent: false);
    }
  }

  Future<void> _applyPlaybackConfig() async {
    final player = _player;
    if (player == null) {
      return;
    }
    await player.setPlaylistMode(
      _readVideoBool(widget.props['loop'])
          ? PlaylistMode.loop
          : PlaylistMode.none,
    );
    await player.setVolume(
      _frameworkVideoVolumeToPlayer(_muted ? 0.0 : _volume),
    );
  }

  Future<void> _openSource(
    String source, {
    required bool autoplay,
    required double initialPositionSeconds,
  }) async {
    final player = _player;
    if (player == null) {
      if (!mounted) return;
      setState(() {
        _openedSource = source;
        _loading = false;
        _playing = false;
        _errorMessage = 'Video playback backend unavailable on this runtime.';
      });
      _emit('error', _statePayload());
      return;
    }
    if (!mounted) return;
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      await player.open(Media(source), play: autoplay);
      await _applyPlaybackConfig();
      if (initialPositionSeconds > 0) {
        await player.seek(
          Duration(milliseconds: (initialPositionSeconds * 1000).round()),
        );
      }
      if (!mounted) return;
      setState(() {
        _openedSource = source;
        _loading = false;
        _playing = autoplay;
      });
      _emit('loaded', _statePayload());
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _openedSource = source;
        _loading = false;
        _playing = false;
        _errorMessage = error.toString();
      });
      _emit('error', _statePayload());
    }
  }

  Future<void> _seekTo(double seconds, {required bool emitEvent}) async {
    final normalized = _normalizeVideoSeconds(seconds);
    try {
      await _player?.seek(Duration(milliseconds: (normalized * 1000).round()));
    } catch (_) {}
    if (!mounted) return;
    setState(() {
      _positionSeconds = normalized;
    });
    if (emitEvent) {
      _emit('seek', _statePayload());
    }
  }

  Future<void> _setVolume(double volume, {required bool emitEvent}) async {
    final normalized = volume.clamp(0.0, 1.0).toDouble();
    try {
      await _player?.setVolume(
        _frameworkVideoVolumeToPlayer(_muted ? 0.0 : normalized),
      );
    } catch (_) {}
    if (!mounted) return;
    setState(() {
      _volume = normalized;
      if (normalized > 0) {
        _muted = false;
      }
    });
    if (emitEvent) {
      _emit('volume', _statePayload());
    }
  }

  Future<void> _toggleMuted(bool value, {required bool emitEvent}) async {
    try {
      await _player?.setVolume(
        _frameworkVideoVolumeToPlayer(value ? 0.0 : _volume),
      );
    } catch (_) {}
    if (!mounted) return;
    setState(() {
      _muted = value;
    });
    if (emitEvent) {
      _emit('mute', _statePayload());
    }
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'play':
        if ((_openedSource == null || _openedSource!.isEmpty) &&
            _resolvedVideoSource(widget.props).isNotEmpty) {
          await _openSource(
            _resolvedVideoSource(widget.props),
            autoplay: true,
            initialPositionSeconds: _positionSeconds,
          );
        } else if (_player != null) {
          await _player!.play();
        } else {
          if (mounted) {
            setState(() {
              _playing = true;
              if (_resolvedVideoSource(widget.props).isNotEmpty) {
                _errorMessage =
                    'Video playback backend unavailable on this runtime.';
              }
            });
          }
        }
        if (mounted) {
          setState(() => _playing = true);
        }
        _emit('play', _statePayload());
        return _statePayload();
      case 'pause':
        await _player?.pause();
        if (mounted) {
          setState(() => _playing = false);
        }
        _emit('pause', _statePayload());
        return _statePayload();
      case 'set_position':
        await _seekTo(
          coerceDouble(args['seconds'] ?? args['position']) ?? _positionSeconds,
          emitEvent: true,
        );
        return _statePayload();
      case 'set_volume':
        await _setVolume(
          _resolveVideoFrameworkVolume(args['volume'] ?? _volume),
          emitEvent: true,
        );
        return _statePayload();
      case 'set_muted':
        await _toggleMuted(
          _readVideoBool(args['muted'] ?? args['value']),
          emitEvent: true,
        );
        return _statePayload();
      case 'get_state':
        return _statePayload();
      case 'emit':
        final event = (args['event'] ?? 'progress').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        _emit(event, payload);
        return true;
      default:
        throw UnsupportedError('Unknown video method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      'src': _resolvedVideoSource(widget.props),
      'playing': _playing,
      'loading': _loading,
      'muted': _muted,
      'position': _positionSeconds,
      'duration': _durationSeconds > 0
          ? _durationSeconds
          : _normalizeVideoSeconds(
              coerceDouble(widget.props['duration']) ?? 0.0,
            ),
      'volume': _volume,
      if (_errorMessage != null && _errorMessage!.isNotEmpty)
        'error': _errorMessage,
    };
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showControls = widget.props['controls'] != false;
    final fit = _resolveVideoFit(widget.props['fit']);
    final aspectRatio =
        coerceDouble(widget.props['aspect_ratio']) ?? _deriveAspectRatio();
    final radius = BorderRadius.circular(
      coerceDouble(widget.props['radius']) ?? 14.0,
    );
    final border = theme.colorScheme.outline.withValues(alpha: 0.32);
    final overlayChild = _buildOverlayChild();
    final poster = _buildPoster();
    final footer = _buildFooter(context);

    Widget body;
    if (_openedSource != null &&
        _openedSource!.isNotEmpty &&
        _errorMessage == null &&
        _videoController != null) {
      body = media_video.Video(
        controller: _videoController!,
        fit: fit,
        fill: Colors.black,
        controls: showControls
            ? media_video.AdaptiveVideoControls
            : media_video.NoVideoControls,
        aspectRatio: aspectRatio,
      );
    } else {
      body = Stack(
        fit: StackFit.expand,
        children: [
          if (poster case final posterWidget?) posterWidget,
          if (poster == null)
            DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF101725), Color(0xFF04070C)],
                ),
              ),
            ),
          Center(
            child: Icon(
              Icons.ondemand_video_rounded,
              size: 72,
              color: Colors.white.withValues(alpha: 0.84),
            ),
          ),
        ],
      );
    }

    body = ClipRRect(
      borderRadius: radius,
      child: ColoredBox(
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: [
            body,
            if (_loading)
              const Center(child: CircularProgressIndicator(strokeWidth: 2.4)),
            if (!showControls)
              Positioned(left: 16, right: 16, bottom: 16, child: footer)
            else
              Positioned(
                left: 16,
                right: 16,
                top: 16,
                child: _buildHeader(context),
              ),
            if (overlayChild case final overlayWidget?) overlayWidget,
          ],
        ),
      ),
    );

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: radius,
          border: Border.all(color: border),
        ),
        child: body,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.38),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          _videoTitle(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final theme = Theme.of(context);
    final progressMax = _durationSeconds > 0
        ? _durationSeconds
        : (_positionSeconds > 0 ? _positionSeconds : 1.0);
    final positionValue = _positionSeconds.clamp(0.0, progressMax).toDouble();
    final effectiveVolume = _muted ? 0.0 : _volume;
    final stateMessage = _errorMessage != null && _errorMessage!.isNotEmpty
        ? _errorMessage
        : ((_openedSource == null || _openedSource!.isEmpty)
              ? 'Set `src` to load a video.'
              : null);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.48),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (_playing) {
                      _handleInvoke('pause', const <String, Object?>{});
                    } else {
                      _handleInvoke('play', const <String, Object?>{});
                    }
                  },
                  iconSize: 28,
                  splashRadius: 24,
                  color: Colors.white,
                  icon: Icon(
                    _playing
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    _videoTitle(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _toggleMuted(!_muted, emitEvent: true),
                  splashRadius: 20,
                  color: Colors.white,
                  icon: Icon(
                    _muted || effectiveVolume <= 0
                        ? Icons.volume_off_rounded
                        : Icons.volume_up_rounded,
                  ),
                ),
              ],
            ),
            if (stateMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  stateMessage,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: _errorMessage != null
                        ? theme.colorScheme.errorContainer
                        : Colors.white.withValues(alpha: 0.72),
                  ),
                ),
              ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.white,
                inactiveTrackColor: Colors.white.withValues(alpha: 0.26),
                thumbColor: Colors.white,
                overlayColor: Colors.white.withValues(alpha: 0.14),
              ),
              child: Slider(
                min: 0.0,
                max: progressMax,
                value: positionValue,
                onChanged: (_openedSource == null || _openedSource!.isEmpty)
                    ? null
                    : (next) {
                        setState(() {
                          _positionSeconds = next;
                        });
                      },
                onChangeEnd: (_openedSource == null || _openedSource!.isEmpty)
                    ? null
                    : (next) => _seekTo(next, emitEvent: true),
              ),
            ),
            Row(
              children: [
                Text(
                  _formatVideoSeconds(_positionSeconds),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 120,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.white.withValues(alpha: 0.9),
                      inactiveTrackColor: Colors.white.withValues(alpha: 0.18),
                      thumbColor: Colors.white,
                      trackHeight: 2.5,
                    ),
                    child: Slider(
                      min: 0.0,
                      max: 1.0,
                      value: effectiveVolume.clamp(0.0, 1.0).toDouble(),
                      onChanged: (next) {
                        setState(() {
                          _volume = next;
                          if (next > 0) {
                            _muted = false;
                          }
                        });
                      },
                      onChangeEnd: (next) => _setVolume(next, emitEvent: true),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatVideoSeconds(_durationSeconds),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.72),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget? _buildPoster() {
    final posterSrc = widget.props['poster']?.toString().trim();
    if (posterSrc == null || posterSrc.isEmpty) {
      return null;
    }
    final provider = resolveImageProvider(posterSrc);
    if (provider == null) {
      return null;
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(image: provider, fit: BoxFit.cover),
      ),
    );
  }

  Widget? _buildOverlayChild() {
    final builder = widget.buildChild;
    if (builder == null) {
      return null;
    }
    for (final raw in widget.rawChildren) {
      if (raw is Map) {
        return Positioned.fill(child: builder(coerceObjectMap(raw)));
      }
    }
    final propChild = widget.props['child'];
    if (propChild is Map) {
      return Positioned.fill(child: builder(coerceObjectMap(propChild)));
    }
    return null;
  }

  double _deriveAspectRatio() {
    final player = _player;
    if (player == null) {
      return 16 / 9;
    }
    final width = player.state.width?.toDouble();
    final height = player.state.height?.toDouble();
    if (width != null && height != null && width > 0 && height > 0) {
      return width / height;
    }
    return 16 / 9;
  }

  String _videoTitle() {
    final title = widget.props['title']?.toString().trim();
    if (title != null && title.isNotEmpty) {
      return title;
    }
    final source = _resolvedVideoSource(widget.props);
    if (source.isEmpty) {
      return 'Video';
    }
    final segments = source.replaceAll('\\', '/').split('/');
    return segments.isEmpty ? 'Video' : segments.last;
  }
}

bool _readVideoBool(Object? value) {
  if (value is bool) {
    return value;
  }
  final normalized = value?.toString().trim().toLowerCase();
  return normalized == 'true' ||
      normalized == '1' ||
      normalized == 'yes' ||
      normalized == 'on';
}

String _resolvedVideoSource(Map<String, Object?> props) {
  final raw = props['src'] ?? props['source'] ?? props['url'];
  return raw?.toString().trim() ?? '';
}

double _normalizeVideoSeconds(double value) {
  if (!value.isFinite || value < 0) {
    return 0.0;
  }
  return value;
}

double _resolveVideoFrameworkVolume(Object? value) {
  final raw = coerceDouble(value);
  if (raw == null) {
    return 1.0;
  }
  if (raw > 1.0) {
    return (raw / 100.0).clamp(0.0, 1.0).toDouble();
  }
  return raw.clamp(0.0, 1.0).toDouble();
}

double _frameworkVideoVolumeToPlayer(double value) {
  return (value.clamp(0.0, 1.0) * 100.0).toDouble();
}

double _playerVideoVolumeToFramework(double value) {
  if (!value.isFinite) {
    return 1.0;
  }
  return (value / 100.0).clamp(0.0, 1.0).toDouble();
}

BoxFit _resolveVideoFit(Object? value) {
  switch (value?.toString().trim().toLowerCase()) {
    case 'cover':
      return BoxFit.cover;
    case 'fill':
      return BoxFit.fill;
    case 'fit_width':
    case 'fitwidth':
      return BoxFit.fitWidth;
    case 'fit_height':
    case 'fitheight':
      return BoxFit.fitHeight;
    case 'scale_down':
    case 'scaledown':
      return BoxFit.scaleDown;
    case 'none':
      return BoxFit.none;
    case 'contain':
    default:
      return BoxFit.contain;
  }
}

String _formatVideoSeconds(double seconds) {
  final total = seconds.isFinite ? seconds.round().clamp(0, 86400) : 0;
  final hours = total ~/ 3600;
  final minutes = (total % 3600) ~/ 60;
  final secs = total % 60;
  final minutesLabel = minutes.toString().padLeft(2, '0');
  final secondsLabel = secs.toString().padLeft(2, '0');
  if (hours > 0) {
    return '$hours:$minutesLabel:$secondsLabel';
  }
  return '$minutesLabel:$secondsLabel';
}

bool _isWidgetTestBinding() {
  final binding = WidgetsBinding.instance;
  return binding.runtimeType.toString().contains('Test');
}
