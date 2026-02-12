import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';

class GroqApiClient {
  final String apiKey;
  late final Dio _dio;

  GroqApiClient(this.apiKey) {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.groqApiUrl,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
    ));
  }

  /// Transcribe audio to text with timestamps using Whisper
  Future<List<Map<String, dynamic>>> transcribeAudio(String audioFilePath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(audioFilePath),
        'model': 'whisper-large-v3',
        'response_format': 'verbose_json',
        'timestamp_granularities': ['segment'],
      });

      final response = await _dio.post(
        '/audio/transcriptions',
        data: formData,
      );

      final segments = response.data['segments'] as List;
      return segments.map((seg) {
        return {
          'text': seg['text'] as String,
          'start': seg['start'] as double,
          'end': seg['end'] as double,
        };
      }).toList();
    } catch (e) {
      throw Exception('Failed to transcribe audio: $e');
    }
  }

  Future<bool> testConnection() async {
    try {
      await _dio.get('/models');
      return true;
    } catch (e) {
      return false;
    }
  }
}
