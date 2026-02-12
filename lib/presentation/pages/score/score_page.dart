import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScorePage extends ConsumerWidget {
  final String scoreId;

  const ScorePage({super.key, required this.scoreId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Placeholder implementation
    return Scaffold(
      appBar: AppBar(
        title: const Text('练唱评分'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.star,
              size: 80,
              color: Colors.amber,
            ),
            const SizedBox(height: 24),
            const Text(
              '评分功能',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              '完成录音后将显示详细评分',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  Text(
                    '评分维度',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text('• 音准 (40%)'),
                  Text('• 节奏 (25%)'),
                  Text('• 高音达成 (20%)'),
                  Text('• 稳定性 (15%)'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
