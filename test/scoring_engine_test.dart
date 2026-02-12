import 'package:flutter_test/flutter_test.dart';
import 'package:singhelper/services/scoring/scoring_engine.dart';
import 'package:singhelper/domain/models/lyric.dart';

void main() {
  group('ScoringEngine', () {
    late ScoringEngine engine;

    setUp(() {
      engine = ScoringEngine();
    });

    test('should calculate score with perfect pitch', () {
      final lyrics = [
        LyricLine(
          id: '1',
          songId: 'test',
          lineNumber: 0,
          text: 'Test line',
          startTime: 0.0,
          endTime: 2.0,
          referencePitch: 440.0,
          isHighNote: false,
        ),
      ];

      final recordedPitches = List.generate(
        20,
        (i) => PitchData(i * 0.1, 440.0), // Perfect pitch
      );

      final score = engine.calculateScore(
        scoreId: 'score1',
        songId: 'test',
        lyrics: lyrics,
        recordedPitches: recordedPitches,
      );

      expect(score.totalScore, greaterThan(80)); // Should be high score
      expect(score.pitchScore, greaterThan(90));
    });

    test('should penalize off-pitch singing', () {
      final lyrics = [
        LyricLine(
          id: '1',
          songId: 'test',
          lineNumber: 0,
          text: 'Test line',
          startTime: 0.0,
          endTime: 2.0,
          referencePitch: 440.0,
          isHighNote: false,
        ),
      ];

      final recordedPitches = List.generate(
        20,
        (i) => PitchData(i * 0.1, 500.0), // Way off pitch
      );

      final score = engine.calculateScore(
        scoreId: 'score1',
        songId: 'test',
        lyrics: lyrics,
        recordedPitches: recordedPitches,
      );

      expect(score.pitchScore, lessThan(50)); // Should be low score
    });

    test('should detect high notes correctly', () {
      final lyrics = [
        LyricLine(
          id: '1',
          songId: 'test',
          lineNumber: 0,
          text: 'High note',
          startTime: 0.0,
          endTime: 2.0,
          referencePitch: 600.0,
          isHighNote: true,
        ),
      ];

      final recordedPitches = List.generate(
        20,
        (i) => PitchData(i * 0.1, 600.0), // Hitting high notes
      );

      final score = engine.calculateScore(
        scoreId: 'score1',
        songId: 'test',
        lyrics: lyrics,
        recordedPitches: recordedPitches,
      );

      expect(score.highNoteScore, greaterThan(80));
    });
  });
}
