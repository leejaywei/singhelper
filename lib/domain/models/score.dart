class PracticeScore {
  final String id;
  final String songId;
  final DateTime createdAt;
  final double totalScore;
  final double pitchScore;
  final double rhythmScore;
  final double highNoteScore;
  final double stabilityScore;
  final String? recordingFilePath;
  final List<LineScore> lineScores;

  PracticeScore({
    required this.id,
    required this.songId,
    required this.createdAt,
    required this.totalScore,
    required this.pitchScore,
    required this.rhythmScore,
    required this.highNoteScore,
    required this.stabilityScore,
    this.recordingFilePath,
    this.lineScores = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'song_id': songId,
      'created_at': createdAt.toIso8601String(),
      'total_score': totalScore,
      'pitch_score': pitchScore,
      'rhythm_score': rhythmScore,
      'high_note_score': highNoteScore,
      'stability_score': stabilityScore,
      'recording_file_path': recordingFilePath,
    };
  }

  factory PracticeScore.fromMap(Map<String, dynamic> map) {
    return PracticeScore(
      id: map['id'],
      songId: map['song_id'],
      createdAt: DateTime.parse(map['created_at']),
      totalScore: map['total_score'],
      pitchScore: map['pitch_score'],
      rhythmScore: map['rhythm_score'],
      highNoteScore: map['high_note_score'],
      stabilityScore: map['stability_score'],
      recordingFilePath: map['recording_file_path'],
    );
  }

  String get grade {
    if (totalScore >= 90) return 'S';
    if (totalScore >= 80) return 'A';
    if (totalScore >= 70) return 'B';
    if (totalScore >= 60) return 'C';
    return 'D';
  }

  String get feedback {
    final issues = <String>[];
    if (pitchScore < 70) issues.add('音准需要提高');
    if (rhythmScore < 70) issues.add('节奏感需要加强');
    if (highNoteScore < 70) issues.add('高音部分需要练习');
    if (stabilityScore < 70) issues.add('声音稳定性需要改善');
    
    if (issues.isEmpty) {
      return '表现优秀！继续保持！';
    } else {
      return '建议：${issues.join('，')}。';
    }
  }
}

class LineScore {
  final String id;
  final String scoreId;
  final int lineNumber;
  final double score;
  final double pitchAccuracy;
  final double rhythmAccuracy;

  LineScore({
    required this.id,
    required this.scoreId,
    required this.lineNumber,
    required this.score,
    required this.pitchAccuracy,
    required this.rhythmAccuracy,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'score_id': scoreId,
      'line_number': lineNumber,
      'score': score,
      'pitch_accuracy': pitchAccuracy,
      'rhythm_accuracy': rhythmAccuracy,
    };
  }

  factory LineScore.fromMap(Map<String, dynamic> map) {
    return LineScore(
      id: map['id'],
      scoreId: map['score_id'],
      lineNumber: map['line_number'],
      score: map['score'],
      pitchAccuracy: map['pitch_accuracy'],
      rhythmAccuracy: map['rhythm_accuracy'],
    );
  }
}
