import 'package:flutter/material.dart';

/// Widget for audio playback controls
class AudioControls extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback? onRewind;
  final VoidCallback? onFastForward;
  final VoidCallback? onStop;

  const AudioControls({
    super.key,
    required this.isPlaying,
    required this.onPlayPause,
    this.onRewind,
    this.onFastForward,
    this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (onRewind != null)
          IconButton(
            icon: const Icon(Icons.fast_rewind),
            iconSize: 32,
            onPressed: onRewind,
          ),
        const SizedBox(width: 16),
        IconButton(
          icon: Icon(
            isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
          ),
          iconSize: 64,
          color: Theme.of(context).colorScheme.primary,
          onPressed: onPlayPause,
        ),
        const SizedBox(width: 16),
        if (onFastForward != null)
          IconButton(
            icon: const Icon(Icons.fast_forward),
            iconSize: 32,
            onPressed: onFastForward,
          ),
        if (onStop != null) ...[
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.stop),
            iconSize: 32,
            onPressed: onStop,
          ),
        ],
      ],
    );
  }
}

/// Widget for audio progress bar
class AudioProgressBar extends StatelessWidget {
  final Duration current;
  final Duration total;
  final ValueChanged<Duration>? onChanged;

  const AudioProgressBar({
    super.key,
    required this.current,
    required this.total,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: current.inMilliseconds.toDouble(),
          min: 0,
          max: total.inMilliseconds.toDouble(),
          onChanged: onChanged != null
              ? (value) => onChanged!(Duration(milliseconds: value.round()))
              : null,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDuration(current)),
              Text(_formatDuration(total)),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
