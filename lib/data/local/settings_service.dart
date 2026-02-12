import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/models/settings.dart';

class SettingsService {
  static final SettingsService instance = SettingsService._init();
  SharedPreferences? _prefs;

  SettingsService._init();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<AppSettings> getSettings() async {
    if (_prefs == null) await init();
    
    return AppSettings(
      replicateApiKey: _prefs!.getString(AppConstants.replicateApiKeyKey),
      groqApiKey: _prefs!.getString(AppConstants.groqApiKeyKey),
      apiProvider: _prefs!.getString(AppConstants.apiProviderKey) ?? 'replicate',
    );
  }

  Future<void> saveReplicateApiKey(String apiKey) async {
    if (_prefs == null) await init();
    await _prefs!.setString(AppConstants.replicateApiKeyKey, apiKey);
  }

  Future<void> saveGroqApiKey(String apiKey) async {
    if (_prefs == null) await init();
    await _prefs!.setString(AppConstants.groqApiKeyKey, apiKey);
  }

  Future<void> saveApiProvider(String provider) async {
    if (_prefs == null) await init();
    await _prefs!.setString(AppConstants.apiProviderKey, provider);
  }

  Future<void> clearApiKeys() async {
    if (_prefs == null) await init();
    await _prefs!.remove(AppConstants.replicateApiKeyKey);
    await _prefs!.remove(AppConstants.groqApiKeyKey);
  }
}
