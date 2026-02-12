class AppConstants {
  // API Configuration
  static const String replicateApiUrl = 'https://api.replicate.com/v1';
  static const String groqApiUrl = 'https://api.groq.com/openai/v1';
  
  // Storage Keys
  static const String replicateApiKeyKey = 'replicate_api_key';
  static const String groqApiKeyKey = 'groq_api_key';
  static const String apiProviderKey = 'api_provider';
  
  // Audio Configuration
  static const int sampleRate = 44100;
  static const double minPitchHz = 80.0;
  static const double maxPitchHz = 1000.0;
  
  // Scoring Weights
  static const double pitchWeight = 0.40;
  static const double rhythmWeight = 0.25;
  static const double highNoteWeight = 0.20;
  static const double stabilityWeight = 0.15;
  
  // Pitch Detection
  static const double pitchThreshold = 0.1;
  static const int yinBufferSize = 2048;
  
  // Practice Settings
  static const double minPlaybackSpeed = 0.5;
  static const double maxPlaybackSpeed = 2.0;
  static const int minTranspose = -6;
  static const int maxTranspose = 6;
  
  // High Note Threshold (for marking high notes in red)
  static const double highNoteThresholdHz = 450.0; // Around A4
  
  // Database
  static const String databaseName = 'singhelper.db';
  static const int databaseVersion = 1;
}
