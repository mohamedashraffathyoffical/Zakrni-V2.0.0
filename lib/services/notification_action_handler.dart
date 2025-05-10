import 'package:flutter/material.dart';
import 'adhan_service.dart';

/// A class to handle notification actions
class NotificationActionHandler {
  static final NotificationActionHandler _instance = NotificationActionHandler._internal();
  final AdhanService _adhanService = AdhanService();
  
  factory NotificationActionHandler() {
    return _instance;
  }
  
  NotificationActionHandler._internal();
  
  /// Handle notification action
  void handleNotificationAction(String? actionId, String? payload) {
    if (actionId == 'stop_adhan') {
      _adhanService.stopAdhan();
      debugPrint('Adhan stopped from notification action');
    }
  }
}
