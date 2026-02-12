import 'dart:io';
import 'package:uuid/uuid.dart';
import '../../data/api/replicate_api_client.dart';
import '../../data/api/groq_api_client.dart';
import '../../data/local/lyric_dao.dart';
import '../../domain/models/lyric.dart';
import '../../core/constants/app_constants.dart';

class AiProcessingService {
  final ReplicateApiClient? _replicateClient;
  final GroqApiClient? _groqClient;
  final LyricDao _lyricDao = LyricDao();

  AiProcessingService({
    String? replicateApiKey,
    String? groqApiKey,
  })  : _replicateClient = replicateApiKey != null 
            ? ReplicateApiClient(replicateApiKey) 
            : null,
        _groqClient = groqApiKey != null 
            ? GroqApiClient(groqApiKey) 
            : null;

  /// Separate audio into vocals and instrumental
  /// Returns paths to the separated files
  Future<Map<String, String>> separateAudio(
    String audioFilePath,
    String outputDir,
  ) async {
    if (_replicateClient == null) {
      throw Exception('Replicate API key not configured');
    }

    // Note: In a real implementation, you would need to upload the file
    // to a publicly accessible URL first, then pass that URL to Replicate
    // For now, this is a placeholder
    throw UnimplementedError(
      'Audio separation requires uploading the file to a public URL first. '
      'This would typically be done via cloud storage (S3, etc.)',
    );
  }

  /// Generate lyrics with timestamps from vocal audio
  Future<List<LyricLine>> generateLyrics(
    String songId,
    String vocalFilePath,
  ) async {
    if (_groqClient == null) {
      throw Exception('Groq API key not configured');
    }

    // Transcribe audio
    final segments = await _groqClient.transcribeAudio(vocalFilePath);

    // Convert to LyricLine objects
    final lyrics = <LyricLine>[];
    for (int i = 0; i < segments.length; i++) {
      final segment = segments[i];
      final lyric = LyricLine(
        id: const Uuid().v4(),
        songId: songId,
        lineNumber: i,
        text: segment['text'].toString().trim(),
        startTime: segment['start'] as double,
        endTime: segment['end'] as double,
        isHighNote: false, // Will be set during pitch analysis
      );
      lyrics.add(lyric);
    }

    // Save to database
    await _lyricDao.insertLyrics(lyrics);

    return lyrics;
  }

  /// Analyze pitch for each lyric line
  /// This is done locally, not via API
  Future<void> analyzePitch(
    List<LyricLine> lyrics,
    String vocalFilePath,
  ) async {
    // This would use audio analysis to extract pitch from the reference vocal
    // For now, we'll mark lines as high notes based on heuristics
    // In a real implementation, this would use FFT or similar analysis
    
    for (final lyric in lyrics) {
      // Simple heuristic: mark as high note if in certain time ranges
      // or if text contains certain patterns
      // This is a placeholder - real implementation would analyze audio
      final isHighNote = _detectHighNote(lyric.text);
      
      if (isHighNote) {
        final updatedLyric = LyricLine(
          id: lyric.id,
          songId: lyric.songId,
          lineNumber: lyric.lineNumber,
          text: lyric.text,
          startTime: lyric.startTime,
          endTime: lyric.endTime,
          referencePitch: AppConstants.highNoteThresholdHz,
          isHighNote: true,
        );
        await _lyricDao.updateLyric(updatedLyric);
      }
    }
  }

  bool _detectHighNote(String text) {
    // Simple heuristic for detecting potential high notes
    // In reality, this would be done through audio analysis
    final highNoteIndicators = ['高', '飞', '天', '远', '亮'];
    return highNoteIndicators.any((indicator) => text.contains(indicator));
  }

  Future<bool> testReplicateConnection() async {
    if (_replicateClient == null) return false;
    return await _replicateClient.testConnection();
  }

  Future<bool> testGroqConnection() async {
    if (_groqClient == null) return false;
    return await _groqClient.testConnection();
  }
}
