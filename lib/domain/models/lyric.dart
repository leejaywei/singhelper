class LyricLine {
  final String id;
  final String songId;
  final int lineNumber;
  final String text;
  final double startTime;
  final double endTime;
  final double? referencePitch;
  final bool isHighNote;

  LyricLine({
    required this.id,
    required this.songId,
    required this.lineNumber,
    required this.text,
    required this.startTime,
    required this.endTime,
    this.referencePitch,
    this.isHighNote = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'song_id': songId,
      'line_number': lineNumber,
      'text': text,
      'start_time': startTime,
      'end_time': endTime,
      'reference_pitch': referencePitch,
      'is_high_note': isHighNote ? 1 : 0,
    };
  }

  factory LyricLine.fromMap(Map<String, dynamic> map) {
    return LyricLine(
      id: map['id'],
      songId: map['song_id'],
      lineNumber: map['line_number'],
      text: map['text'],
      startTime: map['start_time'],
      endTime: map['end_time'],
      referencePitch: map['reference_pitch'],
      isHighNote: map['is_high_note'] == 1,
    );
  }

  double get duration => endTime - startTime;
}
