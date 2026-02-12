import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';

class ReplicateApiClient {
  final String apiKey;
  late final Dio _dio;

  ReplicateApiClient(this.apiKey) {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.replicateApiUrl,
      headers: {
        'Authorization': 'Token $apiKey',
        'Content-Type': 'application/json',
      },
    ));
  }

  /// Separate audio into vocals and instrumental using Demucs model
  Future<Map<String, dynamic>> separateAudio(String audioUrl) async {
    try {
      final response = await _dio.post(
        '/predictions',
        data: {
          'version': 'd60b1b8e41a067a5ede751f6f7574c9e2326c1d4', // Demucs model version
          'input': {
            'audio': audioUrl,
            'model': 'htdemucs',
            'output_format': 'mp3',
          },
        },
      );

      final predictionId = response.data['id'];
      
      // Poll for completion
      return await _pollPrediction(predictionId);
    } catch (e) {
      throw Exception('Failed to separate audio: $e');
    }
  }

  Future<Map<String, dynamic>> _pollPrediction(String predictionId) async {
    const maxAttempts = 120; // 10 minutes max
    var attempts = 0;

    while (attempts < maxAttempts) {
      await Future.delayed(const Duration(seconds: 5));
      
      final response = await _dio.get('/predictions/$predictionId');
      final status = response.data['status'];

      if (status == 'succeeded') {
        return response.data;
      } else if (status == 'failed' || status == 'canceled') {
        throw Exception('Prediction failed with status: $status');
      }

      attempts++;
    }

    throw Exception('Prediction timed out');
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
