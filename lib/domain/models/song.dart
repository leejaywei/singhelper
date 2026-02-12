class Song {
  final String id;
  final String title;
  final String artist;
  final String originalFilePath;
  final String? vocalFilePath;
  final String? instrumentalFilePath;
  final bool isProcessed;
  final DateTime createdAt;
  final DateTime? processedAt;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.originalFilePath,
    this.vocalFilePath,
    this.instrumentalFilePath,
    this.isProcessed = false,
    required this.createdAt,
    this.processedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'original_file_path': originalFilePath,
      'vocal_file_path': vocalFilePath,
      'instrumental_file_path': instrumentalFilePath,
      'is_processed': isProcessed ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'processed_at': processedAt?.toIso8601String(),
    };
  }

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      id: map['id'],
      title: map['title'],
      artist: map['artist'],
      originalFilePath: map['original_file_path'],
      vocalFilePath: map['vocal_file_path'],
      instrumentalFilePath: map['instrumental_file_path'],
      isProcessed: map['is_processed'] == 1,
      createdAt: DateTime.parse(map['created_at']),
      processedAt: map['processed_at'] != null
          ? DateTime.parse(map['processed_at'])
          : null,
    );
  }

  Song copyWith({
    String? title,
    String? artist,
    String? vocalFilePath,
    String? instrumentalFilePath,
    bool? isProcessed,
    DateTime? processedAt,
  }) {
    return Song(
      id: id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      originalFilePath: originalFilePath,
      vocalFilePath: vocalFilePath ?? this.vocalFilePath,
      instrumentalFilePath: instrumentalFilePath ?? this.instrumentalFilePath,
      isProcessed: isProcessed ?? this.isProcessed,
      createdAt: createdAt,
      processedAt: processedAt ?? this.processedAt,
    );
  }
}
