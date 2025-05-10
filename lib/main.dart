import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart';
import 'screens/auth/login_page.dart';
import 'screens/home_page.dart';
import 'screens/settings_page.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appLanguage = Provider.of<AppLanguage>(context);
    
    return MaterialApp(
      title: 'Prayer Times',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData().copyWith(
        textTheme: AppTheme.themeData().textTheme.apply(
          fontFamily: appLanguage.appLocale.languageCode == 'ar' ? 'Cairo' : null,
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
        '/': (context) => FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final isLoggedIn = snapshot.data!.getBool('is_logged_in') ?? false;
              return isLoggedIn ? const HomePage() : const LoginPage();
            }
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
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
