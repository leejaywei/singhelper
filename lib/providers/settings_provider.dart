import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/settings.dart';
import '../data/local/settings_service.dart';

final settingsServiceProvider = Provider((ref) => SettingsService.instance);

final settingsProvider = FutureProvider<AppSettings>((ref) async {
  final service = ref.watch(settingsServiceProvider);
  return await service.getSettings();
});

class SettingsNotifier extends StateNotifier<AsyncValue<AppSettings>> {
  final SettingsService _service;

  SettingsNotifier(this._service) : super(const AsyncValue.loading()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    state = const AsyncValue.loading();
    try {
      final settings = await _service.getSettings();
      state = AsyncValue.data(settings);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> saveReplicateApiKey(String apiKey) async {
    await _service.saveReplicateApiKey(apiKey);
    await _loadSettings();
  }

  Future<void> saveGroqApiKey(String apiKey) async {
    await _service.saveGroqApiKey(apiKey);
    await _loadSettings();
  }

  Future<void> saveApiProvider(String provider) async {
    await _service.saveApiProvider(provider);
    await _loadSettings();
  }

  Future<void> clearApiKeys() async {
    await _service.clearApiKeys();
    await _loadSettings();
  }
}

final settingsNotifierProvider = 
    StateNotifierProvider<SettingsNotifier, AsyncValue<AppSettings>>((ref) {
  final service = ref.watch(settingsServiceProvider);
  return SettingsNotifier(service);
});
