import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/song_provider.dart';

class PracticePage extends ConsumerStatefulWidget {
  final String songId;

  const PracticePage({super.key, required this.songId});

  @override
  ConsumerState<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends ConsumerState<PracticePage> {
  bool _isPlaying = false;
  bool _isRecording = false;
  double _playbackSpeed = 1.0;
  int _transpose = 0;

  @override
  Widget build(BuildContext context) {
    final songAsync = ref.watch(songProvider(widget.songId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('练唱模式'),
      ),
      body: songAsync.when(
        data: (song) {
          if (song == null) {
            return const Center(child: Text('歌曲不存在'));
          }

          return Column(
            children: [
              // Song Info Card
              Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        song.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(song.artist),
                      const SizedBox(height: 16),
                      if (!song.isProcessed)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.warning, color: Colors.orange),
                              SizedBox(width: 8),
                              Text('此歌曲尚未处理'),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Lyrics Display Area
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      '歌词将在此显示\n\n配置 API Key 并处理歌曲后\n即可显示实时滚动歌词',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ),
                ),
              ),

              // Pitch Visualization Area
              Container(
                height: 120,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text('音高曲线将在此显示'),
                ),
              ),

              // Controls
              Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Playback controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.fast_rewind),
                            iconSize: 32,
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(
                              _isPlaying ? Icons.pause_circle : Icons.play_circle,
                              size: 64,
                            ),
                            onPressed: () {
                              setState(() => _isPlaying = !_isPlaying);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.fast_forward),
                            iconSize: 32,
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Speed control
                      Row(
                        children: [
                          const Text('速度: '),
                          Expanded(
                            child: Slider(
                              value: _playbackSpeed,
                              min: 0.5,
                              max: 2.0,
                              divisions: 15,
                              label: '${_playbackSpeed.toStringAsFixed(1)}x',
                              onChanged: (value) {
                                setState(() => _playbackSpeed = value);
                              },
                            ),
                          ),
                          Text('${_playbackSpeed.toStringAsFixed(1)}x'),
                        ],
                      ),

                      // Transpose control
                      Row(
                        children: [
                          const Text('升降调: '),
                          Expanded(
                            child: Slider(
                              value: _transpose.toDouble(),
                              min: -6,
                              max: 6,
                              divisions: 12,
                              label: _transpose > 0 ? '+$_transpose' : '$_transpose',
                              onChanged: (value) {
                                setState(() => _transpose = value.round());
                              },
                            ),
                          ),
                          SizedBox(
                            width: 40,
                            child: Text(
                              _transpose > 0 ? '+$_transpose' : '$_transpose',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Record button
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() => _isRecording = !_isRecording);
                        },
                        icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                        label: Text(_isRecording ? '停止录音' : '开始录音'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isRecording
                              ? Colors.red
                              : Theme.of(context).colorScheme.primary,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('加载失败: $error')),
      ),
    );
  }
}
