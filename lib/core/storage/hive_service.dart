import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stark_vms_frontend/core/constants/app_constants.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

/// Hive local storage service for non-sensitive application settings & preferences.
class HiveService {
  static const String settingsBoxName = 'stark_vms_settings';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(settingsBoxName);
  }

  Box get _settingsBox => Hive.box(settingsBoxName);

  /// Reads a non-sensitive setting.
  T? getSetting<T>(String key, {T? defaultValue}) {
    return _settingsBox.get(key, defaultValue: defaultValue) as T?;
  }

  /// Saves a non-sensitive setting.
  Future<void> saveSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  /// Removes a setting.
  Future<void> removeSetting(String key) async {
    await _settingsBox.delete(key);
  }

  /// Clears non-sensitive preferences if requested.
  Future<void> clearSettings() async {
    await _settingsBox.clear();
  }

  /// Theme mode preference helper
  String? get themeMode => getSetting<String>(AppConstants.themeModeKey);
  Future<void> setThemeMode(String mode) =>
      saveSetting(AppConstants.themeModeKey, mode);
}
