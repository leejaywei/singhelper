import 'dart:math';
import '../../core/constants/app_constants.dart';
import '../../domain/models/lyric.dart';
import '../../domain/models/score.dart';
import '../pitch/yin_pitch_detector.dart';

class PitchData {
  final double time;
  final double? frequency;

  PitchData(this.time, this.frequency);
}

class ScoringEngine {
  /// Calculate complete practice score
  PracticeScore calculateScore({
    required String scoreId,
    required String songId,
    required List<LyricLine> lyrics,
    required List<PitchData> recordedPitches,
    String? recordingFilePath,
  }) {
    final lineScores = <LineScore>[];
    
    double totalPitchScore = 0.0;
    double totalRhythmScore = 0.0;
    double totalHighNoteScore = 0.0;
    double totalStabilityScore = 0.0;

    for (final lyric in lyrics) {
      final lineScore = _calculateLineScore(lyric, recordedPitches);
      lineScores.add(lineScore);
      
      totalPitchScore += lineScore.pitchAccuracy;
      totalRhythmScore += lineScore.rhythmAccuracy;
    }

    // Average scores per line
    final lineCount = lyrics.length;
    final avgPitchScore = lineCount > 0 ? totalPitchScore / lineCount : 0.0;
    final avgRhythmScore = lineCount > 0 ? totalRhythmScore / lineCount : 0.0;
    
    // Calculate high note score
    final highNoteScore = _calculateHighNoteScore(lyrics, recordedPitches);
    
    // Calculate stability score
    final stabilityScore = _calculateStabilityScore(recordedPitches);

    // Calculate total score with weights
    final totalScore = 
        avgPitchScore * AppConstants.pitchWeight +
        avgRhythmScore * AppConstants.rhythmWeight +
        highNoteScore * AppConstants.highNoteWeight +
        stabilityScore * AppConstants.stabilityWeight;

    return PracticeScore(
      id: scoreId,
      songId: songId,
      createdAt: DateTime.now(),
      totalScore: totalScore * 100,
      pitchScore: avgPitchScore * 100,
      rhythmScore: avgRhythmScore * 100,
      highNoteScore: highNoteScore * 100,
      stabilityScore: stabilityScore * 100,
      recordingFilePath: recordingFilePath,
      lineScores: lineScores,
    );
  }

  LineScore _calculateLineScore(
    LyricLine lyric,
    List<PitchData> recordedPitches,
  ) {
    // Get pitches for this line's time range
    final linePitches = recordedPitches
        .where((p) => p.time >= lyric.startTime && p.time <= lyric.endTime)
        .toList();

    // Calculate pitch accuracy
    final pitchAccuracy = _calculatePitchAccuracy(
      lyric.referencePitch,
      linePitches,
    );

    // Calculate rhythm accuracy (timing of voice onset)
    final rhythmAccuracy = _calculateRhythmAccuracy(
      lyric.startTime,
      linePitches,
    );

    final lineScore = (pitchAccuracy + rhythmAccuracy) / 2;

    return LineScore(
      id: '${lyric.id}_score',
      scoreId: '', // Will be set by caller
      lineNumber: lyric.lineNumber,
      score: lineScore * 100,
      pitchAccuracy: pitchAccuracy * 100,
      rhythmAccuracy: rhythmAccuracy * 100,
    );
  }

  double _calculatePitchAccuracy(
    double? referencePitch,
    List<PitchData> recordedPitches,
  ) {
    if (referencePitch == null || referencePitch == 0.0) {
      return 1.0; // No reference pitch, full credit
    }

    final validPitches = recordedPitches
        .where((p) => p.frequency != null && p.frequency! > 0)
        .toList();

    if (validPitches.isEmpty) {
      return 0.0; // No voice detected
    }

    // Calculate average cents deviation
    double totalCentsDev = 0.0;
    for (final pitch in validPitches) {
      final cents = YinPitchDetector.calculateCents(
        referencePitch,
        pitch.frequency!,
      ).abs();
      totalCentsDev += cents;
    }

    final avgCentsDev = totalCentsDev / validPitches.length;

    // Convert cents deviation to score (0-1)
    // Perfect: 0 cents = 1.0
    // 50 cents off = 0.5
    // 100+ cents off = 0.0
    final accuracy = max(0.0, 1.0 - (avgCentsDev / 100.0));
    return accuracy;
  }

  double _calculateRhythmAccuracy(
    double expectedStartTime,
    List<PitchData> linePitches,
  ) {
    if (linePitches.isEmpty) {
      return 0.0; // No voice detected
    }

    // Find first valid pitch (voice onset)
    final firstPitch = linePitches.firstWhere(
      (p) => p.frequency != null && p.frequency! > 0,
      orElse: () => linePitches.first,
    );

    // Calculate timing error in seconds
    final timingError = (firstPitch.time - expectedStartTime).abs();

    // Convert to score (0-1)
    // Perfect: 0s error = 1.0
    // 0.5s error = 0.5
    // 1s+ error = 0.0
    final accuracy = max(0.0, 1.0 - timingError);
    return accuracy;
  }

  double _calculateHighNoteScore(
    List<LyricLine> lyrics,
    List<PitchData> recordedPitches,
  ) {
    final highNotes = lyrics.where((l) => l.isHighNote).toList();
    
    if (highNotes.isEmpty) {
      return 1.0; // No high notes, full credit
    }

    double totalScore = 0.0;
    
    for (final highNote in highNotes) {
      final notePitches = recordedPitches
          .where((p) => p.time >= highNote.startTime && 
                       p.time <= highNote.endTime)
          .toList();

      final validPitches = notePitches
          .where((p) => p.frequency != null && 
                       p.frequency! >= AppConstants.highNoteThresholdHz)
          .toList();

      // Score based on percentage of time hitting high notes
      final ratio = notePitches.isEmpty 
          ? 0.0 
          : validPitches.length / notePitches.length;
      
      totalScore += ratio;
    }

    return totalScore / highNotes.length;
  }

  double _calculateStabilityScore(List<PitchData> recordedPitches) {
    final validPitches = recordedPitches
        .where((p) => p.frequency != null && p.frequency! > 0)
        .toList();

    if (validPitches.length < 2) {
      return 1.0; // Not enough data
    }

    // Calculate pitch variance (standard deviation)
    final frequencies = validPitches.map((p) => p.frequency!).toList();
    final mean = frequencies.reduce((a, b) => a + b) / frequencies.length;
    
    double variance = 0.0;
    for (final freq in frequencies) {
      variance += pow(freq - mean, 2);
    }
    variance /= frequencies.length;
    
    final stdDev = sqrt(variance);

    // Convert to score (0-1)
    // Low variance (stable) = high score
    // High variance (unstable) = low score
    // Normalize: 0-20 Hz stdDev maps to 1.0-0.0
    final stability = max(0.0, 1.0 - (stdDev / 20.0));
    return stability;
  }
}
