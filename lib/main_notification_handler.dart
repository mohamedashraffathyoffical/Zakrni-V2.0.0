import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'services/adhan_service.dart';

/// This class handles notification actions when the app is in the background or foreground
class MainNotificationHandler {
  // Singleton instance of AdhanService to ensure we're using the same instance
  static final AdhanService _adhanService = AdhanService();
  
  /// Get the AdhanService instance
  static AdhanService getAdhanService() {
    return _adhanService;
  }
  
  /// Handle notification actions
  static void handleNotificationAction(NotificationResponse response) {
    // Check if this is an adhan notification with stop action
    if (response.payload != null && 
        response.payload!.startsWith('adhan_notification') && 
        response.actionId == 'stop_adhan') {
      // Stop the adhan playback
      _adhanService.stopAdhan();
      print('Adhan stopped from notification action in background');
    }
  }
}
