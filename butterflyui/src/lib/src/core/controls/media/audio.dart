import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildAudioControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _AudioControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _AudioControl extends StatefulWidget {
  const _AudioControl({
    required this.controlId,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_AudioControl> createState() => _AudioControlState();
}

class _AudioControlState extends State<_AudioControl> {
  Player? _player;
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
  void didUpdateWidget(covariant _AudioControl oldWidget) {
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
            _resolvedSource(oldWidget.props) != _resolvedSource(widget.props),
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
      return;
    }
    try {
      MediaKit.ensureInitialized();
      final player = Player();
      _player = player;
      _bindPlayerStreams(player);
    } catch (_) {
      _player = null;
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
          _positionSeconds = _normalizeSeconds(position.inMilliseconds / 1000);
        });
      }),
    );
    _subscriptions.add(
      player.stream.duration.listen((duration) {
        if (!mounted) return;
        setState(() {
          _durationSeconds = _normalizeSeconds(duration.inMilliseconds / 1000);
        });
      }),
    );
    _subscriptions.add(
      player.stream.volume.listen((volume) {
        if (!mounted) return;
        setState(() {
          _volume = _playerVolumeToFramework(volume);
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
    final source = _resolvedSource(widget.props);
    final requestedMuted = _readBool(widget.props['muted']);
    final requestedVolume = _resolveFrameworkVolume(widget.props['volume']);
    final requestedPosition = _normalizeSeconds(
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
        _durationSeconds = _normalizeSeconds(
          coerceDouble(widget.props['duration']) ?? 0.0,
        );
      });
      return;
    }

    if (player == null) {
      if (!mounted) return;
      setState(() {
        _openedSource = source;
        _loading = false;
        _playing = false;
        _errorMessage = 'Audio playback backend unavailable on this runtime.';
        _durationSeconds = _normalizeSeconds(
          coerceDouble(widget.props['duration']) ?? _durationSeconds,
        );
      });
      return;
    }

    if (forceReopen || source != _openedSource) {
      await _openSource(
        source,
        autoplay: _readBool(widget.props['autoplay']),
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
      _readBool(widget.props['loop']) ? PlaylistMode.loop : PlaylistMode.none,
    );
    await player.setVolume(_frameworkVolumeToPlayer(_muted ? 0.0 : _volume));
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
        _errorMessage = 'Audio playback backend unavailable on this runtime.';
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
    final normalized = _normalizeSeconds(seconds);
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
        _frameworkVolumeToPlayer(_muted ? 0.0 : normalized),
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
      await _player?.setVolume(_frameworkVolumeToPlayer(value ? 0.0 : _volume));
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
            _resolvedSource(widget.props).isNotEmpty) {
          await _openSource(
            _resolvedSource(widget.props),
            autoplay: true,
            initialPositionSeconds: _positionSeconds,
          );
        } else if (_player != null) {
          await _player!.play();
        } else {
          if (mounted) {
            setState(() {
              _playing = true;
              if (_resolvedSource(widget.props).isNotEmpty) {
                _errorMessage =
                    'Audio playback backend unavailable on this runtime.';
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
          _resolveFrameworkVolume(args['volume'] ?? _volume),
          emitEvent: true,
        );
        return _statePayload();
      case 'set_muted':
        await _toggleMuted(
          _readBool(args['muted'] ?? args['value']),
          emitEvent: true,
        );
        return _statePayload();
      case 'get_state':
        return _statePayload();
      case 'emit':
        final event = (args['event'] ?? 'state').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        _emit(event, payload);
        return null;
      default:
        throw UnsupportedError('Unknown audio method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      'src': _resolvedSource(widget.props),
      'playing': _playing,
      'loading': _loading,
      'muted': _muted,
      'position': _positionSeconds,
      'duration': _durationSeconds > 0
          ? _durationSeconds
          : _normalizeSeconds(coerceDouble(widget.props['duration']) ?? 0.0),
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
    final title = (widget.props['title'] ?? _defaultTitle()).toString();
    final artist = widget.props['artist']?.toString();
    final progressMax = _durationSeconds > 0
        ? _durationSeconds
        : (_positionSeconds > 0 ? _positionSeconds : 1.0);
    final positionValue = _positionSeconds.clamp(0.0, progressMax).toDouble();
    final effectiveVolume = _muted ? 0.0 : _volume;
    final borderRadius = BorderRadius.circular(
      coerceDouble(widget.props['radius']) ?? 16.0,
    );
    final surface = theme.colorScheme.surface.withValues(alpha: 0.78);
    final outline = theme.colorScheme.outline.withValues(alpha: 0.35);
    final mutedLabel = _errorMessage != null && _errorMessage!.isNotEmpty
        ? _errorMessage
        : ((_openedSource == null || _openedSource!.isEmpty)
              ? 'Set `src` to start playback.'
              : null);

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: borderRadius,
        border: Border.all(color: outline),
      ),
      padding: const EdgeInsets.all(14),
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
                iconSize: 34,
                icon: Icon(
                  _playing ? Icons.pause_circle_filled : Icons.play_circle_fill,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (artist != null && artist.isNotEmpty)
                      Text(
                        artist,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.72,
                          ),
                        ),
                      ),
                    if (mutedLabel != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          mutedLabel,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: _errorMessage != null
                                ? theme.colorScheme.error
                                : theme.colorScheme.onSurface.withValues(
                                    alpha: 0.58,
                                  ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (_loading)
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: theme.colorScheme.primary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Slider(
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
          Row(
            children: [
              Text(
                _formatSeconds(_positionSeconds),
                style: theme.textTheme.bodySmall,
              ),
              const Spacer(),
              Text(
                _formatSeconds(_durationSeconds),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.66),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              IconButton(
                onPressed: () => _toggleMuted(!_muted, emitEvent: true),
                icon: Icon(
                  _muted || effectiveVolume <= 0
                      ? Icons.volume_off_rounded
                      : Icons.volume_up_rounded,
                ),
              ),
              Expanded(
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
            ],
          ),
        ],
      ),
    );
  }

  String _defaultTitle() {
    final source = _resolvedSource(widget.props);
    if (source.isEmpty) {
      return 'Audio';
    }
    final segments = source.replaceAll('\\', '/').split('/');
    return segments.isEmpty ? 'Audio' : segments.last;
  }
}

bool _readBool(Object? value) {
  if (value is bool) {
    return value;
  }
  final normalized = value?.toString().trim().toLowerCase();
  return normalized == 'true' ||
      normalized == '1' ||
      normalized == 'yes' ||
      normalized == 'on';
}

String _resolvedSource(Map<String, Object?> props) {
  final raw = props['src'] ?? props['source'] ?? props['url'];
  return raw?.toString().trim() ?? '';
}

double _normalizeSeconds(double value) {
  if (!value.isFinite || value < 0) {
    return 0.0;
  }
  return value;
}

double _resolveFrameworkVolume(Object? value) {
  final raw = coerceDouble(value);
  if (raw == null) {
    return 1.0;
  }
  if (raw > 1.0) {
    return (raw / 100.0).clamp(0.0, 1.0).toDouble();
  }
  return raw.clamp(0.0, 1.0).toDouble();
}

double _frameworkVolumeToPlayer(double value) {
  return (value.clamp(0.0, 1.0) * 100.0).toDouble();
}

double _playerVolumeToFramework(double value) {
  if (!value.isFinite) {
    return 1.0;
  }
  return (value / 100.0).clamp(0.0, 1.0).toDouble();
}

String _formatSeconds(double seconds) {
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
