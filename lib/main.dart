import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'l10n/app_localizations.dart';
import 'screens/auth/login_page.dart';
import 'screens/home_page.dart';
import 'screens/settings_page.dart';
import 'theme/app_theme.dart';
import 'services/prayer_notification_service.dart';
import 'main_notification_handler.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize notification settings for background actions
  await _initializeNotifications();

  // Get shared preferences
  final prefs = await SharedPreferences.getInstance();
  final String languageCode = prefs.getString('language_code') ?? 'en';

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppLanguage(languageCode),
      child: const MyApp(),
    ),
  );
}

class AppLanguage extends ChangeNotifier {
  Locale _appLocale;

  AppLanguage(String languageCode) : _appLocale = Locale(languageCode);

  Locale get appLocale => _appLocale;

  Future<void> changeLanguage(Locale locale) async {
    if (_appLocale == locale) return;

    _appLocale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    notifyListeners();
  }
}

// Initialize notifications and register notification action handler
Future<void> _initializeNotifications() async {
  // Initialize notification plugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  
  // Initialize Android settings
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  
  // Initialize iOS settings
  final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
      // Handle iOS notification when app is in foreground (iOS 9 and below)
      print('Received iOS notification: $id, $title, $body, $payload');
    },
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
  
  // Initialize the plugin with the notification action handler
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Handle notification actions
      print('Received notification response: ${response.payload}, actionId: ${response.actionId}');
      
      // Handle adhan stop action
      if (response.payload == 'adhan_notification' && response.actionId == 'stop_adhan') {
        // Import and use the adhan service to stop the adhan
        final adhanService = MainNotificationHandler.getAdhanService();
        adhanService.stopAdhan();
        print('Adhan stopped from notification action');
      }
    },
  );
  
  print('Notification service initialized in main.dart');
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final PrayerNotificationService _notificationService =
      PrayerNotificationService();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    try {
      await _notificationService.initialize();
      await _notificationService.requestPermissions();
      print('Notifications initialized in MyApp');
    } catch (e) {
      print('Error initializing notifications in MyApp: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLanguage = Provider.of<AppLanguage>(context);

    return MaterialApp(
      title: 'Prayer Times',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData().copyWith(
        textTheme: AppTheme.themeData().textTheme.apply(
          fontFamily:
              appLanguage.appLocale.languageCode == 'ar' ? 'Cairo' : null,
        ),
      ),
      locale: appLanguage.appLocale,
      supportedLocales: const [
        Locale('en'), // English
        Locale('ar'), // Arabic
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/',
      routes: {
        '/':
            (context) => FutureBuilder<SharedPreferences>(
              future: SharedPreferences.getInstance(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final isLoggedIn =
                      snapshot.data!.getBool('is_logged_in') ?? false;
                  return isLoggedIn ? const HomePage() : const LoginPage();
                }
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              },
            ),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}
