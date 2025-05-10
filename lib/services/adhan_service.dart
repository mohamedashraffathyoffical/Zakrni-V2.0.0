import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/prayer_time.dart';

class AdhanService {
  static final AdhanService _instance = AdhanService._internal();
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  // Available adhan options
  static const List<String> availableAdhans = [
    'none',
    'sudais',
    'makkah',
    'madinah',
  ];
  
  // Mapping of adhan option to file path
  static const Map<String, String> _adhanFiles = {
    'sudais': 'sound/Al-Sudais-call.mp3',
    'makkah': 'sound/Mecca-call.mp3',
    'madinah': 'sound/Madinah-call.mp3',
  };
  
  String _selectedAdhan = 'sudais'; // Default to Sudais adhan
  bool _adhanEnabled = true; // Default to enabled
  List<Timer> _scheduledAdhans = [];
  
  factory AdhanService() {
    return _instance;
  }
  
  AdhanService._internal();
  
  Future<void> initialize() async {
    await _loadAdhanPreference();
    await _loadAdhanEnabledPreference();
    print('AdhanService initialized: adhan=$_selectedAdhan, enabled=$_adhanEnabled');
  }
  
  Future<void> _loadAdhanPreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _selectedAdhan = prefs.getString('selected_adhan') ?? 'sudais'; // Default to Sudais adhan
      print('Loaded adhan preference: $_selectedAdhan');
    } catch (e) {
      print('Error loading adhan preference: $e');
      _selectedAdhan = 'sudais'; // Default to Sudais adhan
    }
  }
  
  Future<void> _loadAdhanEnabledPreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _adhanEnabled = prefs.getBool('adhan_enabled') ?? true; // Default to enabled
      print('Loaded adhan enabled preference: $_adhanEnabled');
    } catch (e) {
      print('Error loading adhan enabled preference: $e');
      _adhanEnabled = true; // Default to enabled
    }
  }
  
  Future<void> saveAdhanPreference(String adhan) async {
    if (!availableAdhans.contains(adhan)) {
      adhan = 'none';
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_adhan', adhan);
      _selectedAdhan = adhan;
      print('Saved adhan preference: $_selectedAdhan');
    } catch (e) {
      print('Error saving adhan preference: $e');
    }
  }
  
  String getSelectedAdhan() {
    return _selectedAdhan;
  }
  
  bool isAdhanEnabled() {
    return _adhanEnabled;
  }
  
  Future<void> setAdhanEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('adhan_enabled', enabled);
      _adhanEnabled = enabled;
      print('Saved adhan enabled preference: $_adhanEnabled');
    } catch (e) {
      print('Error saving adhan enabled preference: $e');
    }
  }
  
  Future<void> playAdhan() async {
    if (_selectedAdhan == 'none' || !_adhanEnabled) {
      print('Adhan is set to none or disabled, not playing');
      return;
    }
    
    final adhanFile = _adhanFiles[_selectedAdhan];
    if (adhanFile != null) {
      try {
        // Stop any currently playing audio first
        await _audioPlayer.stop();
        
        // Set volume to maximum
        await _audioPlayer.setVolume(1.0);
        
        // Show a notification for the adhan
        await _showAdhanNotification();
        
        print('Playing adhan: $adhanFile');
        await _audioPlayer.play(AssetSource(adhanFile));
        
        // Add debug information
        print('AudioPlayer state: ${_audioPlayer.state}');
      } catch (e) {
        print('Error playing adhan: $e');
      }
    } else {
      print('Adhan file not found for $_selectedAdhan');
    }
  }
  
  Future<void> stopAdhan() async {
    await _audioPlayer.stop();
    // Cancel the notification when adhan is stopped
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancel(1000); // Use a specific ID for adhan notification
    print('Adhan stopped and notification canceled');
  }
  
  // Show a notification with a stop button when adhan is playing
  Future<void> _showAdhanNotification() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    
    // Create Android notification details with action button
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'adhan_channel',
      'Adhan Notifications',
      channelDescription: 'Notifications for adhan at prayer times',
      importance: Importance.max,
      priority: Priority.high,
      playSound: false, // We're playing adhan separately
      ongoing: true, // Make it persistent until dismissed
      autoCancel: false,
      icon: 'notification_icon',
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'stop_adhan',
          'Stop Adhan',
          showsUserInterface: true,
          cancelNotification: true,
        ),
      ],
    );
    
    // Create iOS notification details
    const DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails(
      presentSound: false, // We're playing adhan separately
      categoryIdentifier: 'adhanCategory',
    );
    
    // Combine platform-specific notification details
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    
    // Show the notification
    await flutterLocalNotificationsPlugin.show(
      1000, // Use a specific ID for adhan notification
      'Adhan Time',
      'Prayer time has arrived. Tap Stop to end the adhan.',
      platformChannelSpecifics,
      payload: 'adhan_notification',
    );
    
    print('Adhan notification shown');
  }
  
  void cancelAllScheduledAdhans() {
    for (var timer in _scheduledAdhans) {
      timer.cancel();
    }
    _scheduledAdhans.clear();
  }
  
  Future<void> scheduleAdhan(PrayerTime prayer) async {
    if (_selectedAdhan == 'none') {
      return;
    }
    
    try {
      // Calculate exact prayer time
      DateTime prayerTime = prayer.time;
      
      // If prayer time is in the past, schedule for tomorrow
      if (prayerTime.isBefore(DateTime.now())) {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        prayerTime = DateTime(
          tomorrow.year, 
          tomorrow.month, 
          tomorrow.day, 
          prayerTime.hour, 
          prayerTime.minute
        );
      }
      
      // Calculate duration until prayer time
      final duration = prayerTime.difference(DateTime.now());
      
      // Schedule adhan to play at prayer time
      Timer? timerRef;
      timerRef = Timer(duration, () {
        playAdhan();
        _scheduledAdhans.remove(timerRef);
      });
      
      _scheduledAdhans.add(timerRef);
      print('Scheduled adhan for ${prayer.name} at ${prayerTime.toString()}');
    } catch (e) {
      print('Error scheduling adhan: $e');
    }
  }
  
  Future<void> scheduleAllAdhans(DailyPrayers prayers) async {
    if (_selectedAdhan == 'none' || !_adhanEnabled) {
      return;
    }
    
    try {
      // Cancel any existing scheduled adhans
      cancelAllScheduledAdhans();
      
      // Schedule adhans for each prayer
      final prayersList = prayers.toList();
      for (final prayer in prayersList) {
        // Skip sunrise as it's not a prayer time
        if (prayer.name != 'Sunrise') {
          await scheduleAdhan(prayer);
        }
      }
      print('All adhans scheduled');
    } catch (e) {
      print('Error scheduling all adhans: $e');
    }
  }
  
  // Get a user-friendly name for the adhan option
  String getAdhanDisplayName(String adhan, BuildContext context) {
    switch (adhan) {
      case 'none':
        return 'None';
      case 'sudais':
        return 'Sheikh Sudais';
      case 'makkah':
        return 'Makkah Adhan';
      case 'madinah':
        return 'Madinah Adhan';
      default:
        return adhan;
    }
  }
}
