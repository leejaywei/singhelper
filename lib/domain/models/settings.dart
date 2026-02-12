class AppSettings {
  final String? replicateApiKey;
  final String? groqApiKey;
  final String apiProvider; // 'replicate' or 'groq' or 'custom'
  final String? customApiUrl;

  AppSettings({
    this.replicateApiKey,
    this.groqApiKey,
    this.apiProvider = 'replicate',
    this.customApiUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'replicate_api_key': replicateApiKey,
      'groq_api_key': groqApiKey,
      'api_provider': apiProvider,
      'custom_api_url': customApiUrl,
    };
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      replicateApiKey: map['replicate_api_key'],
      groqApiKey: map['groq_api_key'],
      apiProvider: map['api_provider'] ?? 'replicate',
      customApiUrl: map['custom_api_url'],
    );
  }

  AppSettings copyWith({
    String? replicateApiKey,
    String? groqApiKey,
    String? apiProvider,
    String? customApiUrl,
  }) {
    return AppSettings(
      replicateApiKey: replicateApiKey ?? this.replicateApiKey,
      groqApiKey: groqApiKey ?? this.groqApiKey,
      apiProvider: apiProvider ?? this.apiProvider,
      customApiUrl: customApiUrl ?? this.customApiUrl,
    );
  }

  bool get hasReplicateKey => replicateApiKey != null && replicateApiKey!.isNotEmpty;
  bool get hasGroqKey => groqApiKey != null && groqApiKey!.isNotEmpty;
}
