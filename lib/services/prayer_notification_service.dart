import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/prayer_time.dart';
import '../l10n/app_localizations.dart';
import 'adhan_service.dart';

class PrayerNotificationService {
  static final PrayerNotificationService _instance = PrayerNotificationService._internal();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;
  
  // Sound options for pre-prayer notification (5 minutes before)
  static const List<String> availableSounds = [
    'default',
    'short_beep'
  ];
  
  String _notificationSound = 'default';
  bool _notificationsEnabled = true; // Default to enabled
  final AdhanService _adhanService = AdhanService();
  
  // Stream controller to notify listeners when notification settings change
  final StreamController<bool> _notificationSettingsController = StreamController<bool>.broadcast();
  Stream<bool> get notificationSettingsStream => _notificationSettingsController.stream;

  factory PrayerNotificationService() {
    return _instance;
  }

  PrayerNotificationService._internal();

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize timezone
      tz_data.initializeTimeZones();
      
      // Load saved notification sound preference
      await _loadNotificationSoundPreference();
      
      // Load saved notifications enabled preference
      await _loadNotificationsEnabledPreference();
      
      // Initialize adhan service
      await _adhanService.initialize();
      
      // Setup notification action for stopping adhan
      await _setupNotificationActions();
      
      // Initialize notification settings for Android only
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      notificationCategories: [
        DarwinNotificationCategory(
          'adhanCategory',
          actions: [
            DarwinNotificationAction.plain(
              'stop_adhan',
              'Stop Adhan',
              options: {
                DarwinNotificationActionOption.destructive,
                DarwinNotificationActionOption.foreground,
              },
            ),
          ],
        ),
      ],
    );
    
    // Combine platform-specific initialization settings
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

      try {
        // Initialize the plugin with the new callback format for v14+
        await _flutterLocalNotificationsPlugin.initialize(
          initializationSettings,
          onDidReceiveNotificationResponse: _onNotificationResponse,
        );
        print('Notification service initialized successfully');
      } catch (e) {
        print('Error initializing notification plugin: $e');
        // We'll still consider it initialized to avoid repeated attempts
      }

      _isInitialized = true;
    } catch (e) {
      print('Error initializing notification service: $e');
      _isInitialized = false;
    }
  }

  Future<bool> requestPermissions() async {
    try {
      if (Platform.isAndroid) {
        // For Android 13+ (SDK 33+), we need to request permission
        final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
            _flutterLocalNotificationsPlugin
                .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
        
        if (androidImplementation != null) {
          try {
            final bool? granted = await androidImplementation.requestPermission();
            return granted ?? false;
          } catch (e) {
            print('Error requesting Android notification permission: $e');
            // For older versions of Android, permissions are granted by default
            return true;
          }
        }
        return true;
      }
    } catch (e) {
      print('Error requesting notification permissions: $e');
    }
    return false;
  }

  Future<void> schedulePrayerNotification(PrayerTime prayer, BuildContext context) async {
    if (!_isInitialized) await initialize();
    
    try {
      // Get localizations
      final appLocalizations = AppLocalizations.of(context);
      final isArabic = Localizations.localeOf(context).languageCode == 'ar';
      
      // Calculate time 5 minutes before prayer
      final notificationTime = prayer.time.subtract(const Duration(minutes: 5));
      
      // If notification time is in the past, schedule for tomorrow
      DateTime scheduledTime = notificationTime;
      if (notificationTime.isBefore(DateTime.now())) {
        // Schedule for tomorrow at the same time
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        scheduledTime = DateTime(
          tomorrow.year, 
          tomorrow.month, 
          tomorrow.day, 
          notificationTime.hour, 
          notificationTime.minute
        );
      }
      
      // Create notification details with custom sound if available
      AndroidNotificationDetails androidPlatformChannelSpecifics;
      
      // Set custom sound if not using default
      if (_notificationSound != 'default') {
        androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'prayer_times_channel',
          'Prayer Times',
          channelDescription: 'Notifications for prayer times',  
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          sound: RawResourceAndroidNotificationSound(_notificationSound),
          actions: [
            const AndroidNotificationAction(
              'stop',
              'Stop',
              showsUserInterface: false,
            ),
          ],
        );
      } else {
        androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'prayer_times_channel',
          'Prayer Times',
          channelDescription: 'Notifications for prayer times',  
          importance: Importance.max,
          priority: Priority.high,
          actions: [
            const AndroidNotificationAction(
              'stop',
              'Stop',
              showsUserInterface: false,
            ),
          ],
        );
      }
      
      final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );
      
      // Get localized prayer name
      String prayerName = _getLocalizedPrayerName(prayer.name, appLocalizations);
      
      // Create notification title and body based on language
      String title = isArabic 
          ? 'الاستعداد للصلاة'
          : 'Prepare for prayer';
      
      String body = isArabic
          ? 'حان وقت الاستعداد لصلاة $prayerName. الصلاة عماد الدين.'
          : 'Time to prepare for $prayerName prayer. Prayer is the pillar of religion.';
      
      try {
        // Schedule notification
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          _getPrayerNotificationId(prayer.name),
          title,
          body,
          tz.TZDateTime.from(scheduledTime, tz.local),
          platformChannelSpecifics,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,  // Updated for v14+
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,  // Repeat daily
        );
        print('Scheduled notification for $prayerName');
      } catch (e) {
        print('Error scheduling notification: $e');
        // If we get a MissingPluginException, we'll just ignore it
        // This allows the app to continue working even if notifications aren't available
      }
    } catch (e) {
      print('Error preparing notification: $e');
    }
  }

  Future<void> scheduleAllPrayerNotifications(DailyPrayers prayers, BuildContext context) async {
    if (!_isInitialized) await initialize();
    
    try {
      // If notifications are disabled, just cancel any existing ones and return
      if (!_notificationsEnabled) {
        await cancelAllNotifications();
        return;
      }
      
      // Cancel any existing notifications first
      await cancelAllNotifications();
      
      // Schedule notifications for each prayer
      final prayersList = prayers.toList();
      for (final prayer in prayersList) {
        await schedulePrayerNotification(prayer, context);
      }
      print('All prayer notifications scheduled');
      
      // Schedule adhans for each prayer time
      await _adhanService.scheduleAllAdhans(prayers);
    } catch (e) {
      print('Error scheduling all notifications: $e');
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await _flutterLocalNotificationsPlugin.cancelAll();
      _adhanService.cancelAllScheduledAdhans();
      print('All notifications and adhans canceled');
    } catch (e) {
      print('Error canceling notifications: $e');
    }
  }

  Future<bool> showTestNotification(BuildContext context) async {
    if (!_isInitialized) await initialize();
    
    try {
      // Get language info
      final isArabic = Localizations.localeOf(context).languageCode == 'ar';
      
      // Configure Android notification details
      AndroidNotificationDetails androidPlatformChannelSpecifics;
      
      if (_notificationSound != 'default') {
        androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'prayer_times_test_channel',
          'Prayer Times Test',
          channelDescription: 'Test notifications for prayer times',  
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          icon: 'notification_icon',
          sound: RawResourceAndroidNotificationSound(_notificationSound),
        );
      } else {
        androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'prayer_times_test_channel',
          'Prayer Times Test',
          channelDescription: 'Test notifications for prayer times',  
          importance: Importance.max,
          priority: Priority.high,
          icon: 'notification_icon',
        );
      }
      
      final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );
      
      // Create test notification title and body based on language
      String title = isArabic 
          ? 'الاستعداد للصلاة'
          : 'Prepare for prayer';
      
      String body = isArabic
          ? 'هذا اختبار للإشعارات. الصلاة عماد الدين.'
          : 'This is a test notification. Prayer is the pillar of religion.';
      
      try {
        // Show immediate test notification
        await _flutterLocalNotificationsPlugin.show(
          0,
          title,
          body,
          platformChannelSpecifics,
          payload: 'test_notification',  // Add a payload for testing
        );
        print('Test notification sent');
        return true;
      } catch (e) {
        print('Error showing test notification: $e');
        // If we get a MissingPluginException, we'll just show a message to the user
        if (e.toString().contains('MissingPluginException')) {
          // Return false to indicate the test notification couldn't be sent
          return false;
        }
      }
    } catch (e) {
      print('Error preparing test notification: $e');
    }
    return false;
  }

  // Helper method to get localized prayer name
  String _getLocalizedPrayerName(String prayerName, AppLocalizations localizations) {
    switch (prayerName) {
      case 'Fajr':
        return localizations.fajr;
      case 'Sunrise':
        return localizations.sunrise;
      case 'Dhuhr':
        return localizations.dhuhr;
      case 'Asr':
        return localizations.asr;
      case 'Maghrib':
        return localizations.maghrib;
      case 'Isha':
        return localizations.isha;
      default:
        return prayerName;
    }
  }
  

  
  // Methods for notification sound preferences
  Future<void> _loadNotificationSoundPreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _notificationSound = prefs.getString('notification_sound') ?? 'default';
    } catch (e) {
      print('Error loading notification sound preference: $e');
      _notificationSound = 'default';
    }
  }
  
  Future<void> _loadNotificationsEnabledPreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true; // Default to enabled
      print('Loaded notifications enabled preference: $_notificationsEnabled');
    } catch (e) {
      print('Error loading notifications enabled preference: $e');
      _notificationsEnabled = true; // Default to enabled
    }
  }
  
  // Setup notification actions for stopping adhan
  Future<void> _setupNotificationActions() async {
    try {
      // For Android, create the notification channel with actions
      if (Platform.isAndroid) {
        final androidPlugin = _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
        
        if (androidPlugin != null) {
          // Request notification permission
          await androidPlugin.requestPermission();
          
          // Create notification channel for adhan
          await androidPlugin.createNotificationChannel(
            const AndroidNotificationChannel(
              'adhan_channel',
              'Adhan Notifications',
              description: 'Notifications for adhan at prayer times',
              importance: Importance.max,
              playSound: false, // We'll play adhan separately
            ),
          );
        }
      }
    } catch (e) {
      print('Error setting up notification actions: $e');
    }
  }
  
  // Handle notification responses (including action buttons)
  void _onNotificationResponse(NotificationResponse response) {
    // Handle notification actions
    if (response.payload != null && response.payload!.startsWith('adhan_notification')) {
      if (response.actionId == 'stop_adhan') {
        _adhanService.stopAdhan();
        print('Adhan stopped from notification action');
      }
    }
  }
  
  Future<void> saveNotificationSoundPreference(String sound) async {
    if (!availableSounds.contains(sound)) {
      sound = 'default';
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('notification_sound', sound);
      _notificationSound = sound;
    } catch (e) {
      print('Error saving notification sound preference: $e');
    }
  }
  
  Future<void> setNotificationsEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notifications_enabled', enabled);
      _notificationsEnabled = enabled;
      print('Saved notifications enabled preference: $_notificationsEnabled');
      
      // Notify all listeners about the change
      _notificationSettingsController.add(enabled);
    } catch (e) {
      print('Error saving notifications enabled preference: $e');
    }
  }
  
  bool isNotificationsEnabled() {
    return _notificationsEnabled;
  }
  
  String getNotificationSound() {
    return _notificationSound;
  }
  
  // Method to handle timezone changes
  Future<void> handleTimezoneChange(DailyPrayers prayers, BuildContext context) async {
    try {
      // Cancel existing notifications and reschedule with new timezone
      await cancelAllNotifications();
      await scheduleAllPrayerNotifications(prayers, context);
      print('Notifications rescheduled due to timezone change');
    } catch (e) {
      print('Error handling timezone change: $e');
    }
  }

  // Helper method to generate unique notification ID for each prayer
  int _getPrayerNotificationId(String prayerName) {
    switch (prayerName) {
      case 'Fajr':
        return 1;
      case 'Sunrise':
        return 2;
      case 'Dhuhr':
        return 3;
      case 'Asr':
        return 4;
      case 'Maghrib':
        return 5;
      case 'Isha':
        return 6;
      default:
        return 0;
    }
  }
}
