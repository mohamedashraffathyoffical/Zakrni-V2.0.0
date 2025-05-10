import 'package:shared_preferences/shared_preferences.dart';
import 'notification_service.dart';

/// Service for managing the counter reset functionality
class ResetCountersService {
  static const String _prefsPrefix = 'dhikr_counter_';
  static const String _showIndividualResetButtonsKey = 'show_individual_reset_buttons';
  static const String _showGlobalResetButtonKey = 'show_global_reset_button';

  /// Reset all counters that start with the dhikr_counter_ prefix
  static Future<void> resetAllCounters() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Get all keys
    final keys = prefs.getKeys();
    
    // Filter only dhikr counter keys
    final dhikrKeys = keys.where((key) => key.startsWith(_prefsPrefix)).toList();
    
    // Reset all counters to 0
    for (final key in dhikrKeys) {
      await prefs.setInt(key, 0);
    }
    
    // Notify all listeners that counters have been reset
    NotificationService.notify('counters_reset');
  }

  /// Get the setting for showing individual reset buttons
  static Future<bool> getShowIndividualResetButtons() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_showIndividualResetButtonsKey) ?? true;
  }

  /// Get the setting for showing the global reset button
  static Future<bool> getShowGlobalResetButton() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_showGlobalResetButtonKey) ?? false;
  }

  /// Set the preference for showing individual reset buttons
  static Future<void> setShowIndividualResetButtons(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showIndividualResetButtonsKey, value);
  }

  /// Set the preference for showing the global reset button
  static Future<void> setShowGlobalResetButton(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showGlobalResetButtonKey, value);
  }
}
