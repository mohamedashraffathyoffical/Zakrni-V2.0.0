import 'package:flutter/foundation.dart';

/// A simple notification service to handle events across the app
class NotificationService {
  static final Map<String, List<VoidCallback>> _listeners = {};

  /// Add a listener for a specific event
  static void addListener(String event, VoidCallback callback) {
    _listeners[event] ??= [];
    _listeners[event]!.add(callback);
  }

  /// Remove a listener for a specific event
  static void removeListener(String event, VoidCallback callback) {
    if (_listeners.containsKey(event)) {
      _listeners[event]!.remove(callback);
      if (_listeners[event]!.isEmpty) {
        _listeners.remove(event);
      }
    }
  }

  /// Notify all listeners of a specific event
  static void notify(String event) {
    if (_listeners.containsKey(event)) {
      // Create a copy of the list to avoid concurrent modification issues
      final listeners = List<VoidCallback>.from(_listeners[event]!);
      for (final callback in listeners) {
        callback();
      }
    }
  }
}
