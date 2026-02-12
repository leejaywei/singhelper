import 'package:flutter/material.dart';
import '../../domain/models/lyric.dart';

/// Widget for displaying scrolling lyrics with current line highlighted
class LyricsDisplay extends StatefulWidget {
  final List<LyricLine> lyrics;
  final double currentTime;
  final ScrollController? scrollController;

  const LyricsDisplay({
    super.key,
    required this.lyrics,
    required this.currentTime,
    this.scrollController,
  });

  @override
  State<LyricsDisplay> createState() => _LyricsDisplayState();
}

class _LyricsDisplayState extends State<LyricsDisplay> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(LyricsDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentTime != oldWidget.currentTime) {
      _scrollToCurrentLine();
    }
  }

  void _scrollToCurrentLine() {
    final currentIndex = _getCurrentLineIndex();
    if (currentIndex != -1 && _scrollController.hasClients) {
      // Scroll to current line with animation
      _scrollController.animateTo(
        currentIndex * 60.0, // Approximate height per line
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  int _getCurrentLineIndex() {
    for (int i = 0; i < widget.lyrics.length; i++) {
      final lyric = widget.lyrics[i];
      if (widget.currentTime >= lyric.startTime &&
          widget.currentTime <= lyric.endTime) {
        return i;
      }
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lyrics.isEmpty) {
      return const Center(
        child: Text('暂无歌词'),
      );
    }

    final currentIndex = _getCurrentLineIndex();

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      itemCount: widget.lyrics.length,
      itemBuilder: (context, index) {
        final lyric = widget.lyrics[index];
        final isCurrent = index == currentIndex;
        final isPast = widget.currentTime > lyric.endTime;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            lyric.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isCurrent ? 24 : 16,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              color: isCurrent
                  ? lyric.isHighNote
                      ? Colors.red
                      : Theme.of(context).colorScheme.primary
                  : isPast
                      ? Colors.grey
                      : Colors.white70,
              height: 1.5,
            ),
          ),
        );
      },
    );
  }
}
