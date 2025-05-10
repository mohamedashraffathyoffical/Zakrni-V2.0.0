import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../models/prayer_time.dart';
import '../services/prayer_api_service.dart';
import '../widgets/prayer_card.dart';
import '../widgets/governorate_dropdown.dart';
import '../theme/app_theme.dart';
import 'azkar/morning_azkar.dart';
import 'azkar/after_prayer_azkar.dart';
import 'azkar/sleep_azkar.dart';
import 'azkar/wake_up_azkar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PrayerApiService _apiService = PrayerApiService();
  String _selectedGovernorate = 'القاهرة'; // Default to Cairo in Arabic
  DailyPrayers? _prayerTimes;
  PrayerTime? _nextPrayer;
  String _timeRemaining = '';
  Timer? _timer;
  bool _isLoading = true;
  Locale? _previousLocale;
  
  @override
  void initState() {
    super.initState();
    _fetchPrayerTimes();
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  
  Future<void> _fetchPrayerTimes() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final prayerTimes = await _apiService.getPrayerTimes(_selectedGovernorate);
      
      setState(() {
        _prayerTimes = prayerTimes;
        _nextPrayer = prayerTimes.getNextPrayer();
        _isLoading = false;
      });
      
      // Start timer to update countdown
      _startCountdownTimer();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
  
  void _startCountdownTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_prayerTimes == null) return;
      
      final nextPrayer = _prayerTimes!.getNextPrayer();
      final now = DateTime.now();
      final difference = nextPrayer.time.difference(now);
      
      // Format the time remaining
      final hours = difference.inHours;
      final minutes = difference.inMinutes.remainder(60);
      final seconds = difference.inSeconds.remainder(60);
      
      if (mounted) {
        final appLanguage = Provider.of<AppLanguage>(context, listen: false);
        final isArabic = appLanguage.appLocale.languageCode == 'ar';
        
        setState(() {
          _nextPrayer = nextPrayer;
          
          // Format time differently based on language
          if (isArabic) {
            // Arabic format with Arabic numerals and seconds
            final arabicHours = _convertToArabicNumerals(hours.toString());
            final arabicMinutes = _convertToArabicNumerals(minutes.toString().padLeft(2, '0'));
            final arabicSeconds = _convertToArabicNumerals(seconds.toString().padLeft(2, '0'));
            _timeRemaining = '$arabicHours:$arabicMinutes:$arabicSeconds';
          } else {
            // English format with seconds
            _timeRemaining = '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
          }
        });
      }
    });
  }
  
  // Helper method to convert Western numerals to Arabic numerals
  String _convertToArabicNumerals(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    
    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(english[i], arabic[i]);
    }
    
    return input;
  }
  
  void _onGovernorateChanged(String governorate) {
    setState(() {
      _selectedGovernorate = governorate;
    });
    _fetchPrayerTimes();
  }
  
  void _navigateToAzkarPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    final appLanguage = Provider.of<AppLanguage>(context);
    final isArabic = appLanguage.appLocale.languageCode == 'ar';
    
    // Check if the locale has changed since the last build
    if (_previousLocale != null && _previousLocale != appLanguage.appLocale) {
      // If we're switching languages, we need to make sure the governorate stays the same
      // but is properly represented in the new language
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Refresh UI with current governorate in the new language
        _fetchPrayerTimes();
      });
    }
    
    // Update the previous locale for the next build
    _previousLocale = appLanguage.appLocale;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              final newLocale = isArabic ? const Locale('en') : const Locale('ar');
              appLanguage.changeLanguage(newLocale);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                appLocalizations.appTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text(appLocalizations.home),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(appLocalizations.settings),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(appLocalizations.logout),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('is_logged_in', false);
                
                if (!mounted) return;
                
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Governorate Dropdown
                GovernorateDropdown(
                  selectedGovernorate: _selectedGovernorate,
                  onChanged: _onGovernorateChanged,
                  governorates: _apiService.getAvailableGovernorates(),
                ),
                
                const SizedBox(height: 20),
                
                // Next Prayer Card
                if (_nextPrayer != null)
                  PrayerCard(
                    title: appLocalizations.nextPrayer,
                    prayerName: _getPrayerNameLocalized(_nextPrayer!.name, appLocalizations),
                    timeRemaining: _timeRemaining,
                    timeRemainingLabel: appLocalizations.timeRemaining,
                  ),
                
                const SizedBox(height: 20),
                
                // All Prayer Times List
                if (_prayerTimes != null)
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isArabic ? 'مواقيت الصلاة اليوم' : 'Today\'s Prayer Times',
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          _buildPrayerTimeRow(context, 'Fajr', _prayerTimes!.fajr, appLocalizations),
                          const Divider(),
                          _buildPrayerTimeRow(context, 'Sunrise', _prayerTimes!.sunrise, appLocalizations),
                          const Divider(),
                          _buildPrayerTimeRow(context, 'Dhuhr', _prayerTimes!.dhuhr, appLocalizations),
                          const Divider(),
                          _buildPrayerTimeRow(context, 'Asr', _prayerTimes!.asr, appLocalizations),
                          const Divider(),
                          _buildPrayerTimeRow(context, 'Maghrib', _prayerTimes!.maghrib, appLocalizations),
                          const Divider(),
                          _buildPrayerTimeRow(context, 'Isha', _prayerTimes!.isha, appLocalizations),
                        ],
                      ),
                    ),
                  ),
                
                const SizedBox(height: 30),
                
                // Azkar Buttons
                Text(
                  appLocalizations.azkar,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 16),
                
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: [
                    _buildAzkarButton(
                      context,
                      appLocalizations.morningAzkar,
                      Icons.wb_sunny,
                      () => _navigateToAzkarPage(const MorningAzkarPage()),
                    ),
                    _buildAzkarButton(
                      context,
                      appLocalizations.afterPrayerAzkar,
                      Icons.mosque,
                      () => _navigateToAzkarPage(const AfterPrayerAzkarPage()),
                    ),
                    _buildAzkarButton(
                      context,
                      appLocalizations.sleepAzkar,
                      Icons.nightlight_round,
                      () => _navigateToAzkarPage(const SleepAzkarPage()),
                    ),
                    _buildAzkarButton(
                      context,
                      appLocalizations.wakeUpAzkar,
                      Icons.alarm,
                      () => _navigateToAzkarPage(const WakeUpAzkarPage()),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }
  
  Widget _buildAzkarButton(
    BuildContext context, 
    String title, 
    IconData icon, 
    VoidCallback onPressed
  ) {
    return Container(
      decoration: AppTheme.secondaryGradientDecoration(),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.all(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPrayerTimeRow(BuildContext context, String prayerName, PrayerTime prayerTime, AppLocalizations localizations) {
    // Format time in 12-hour format with AM/PM
    final hour = prayerTime.time.hour;
    final minute = prayerTime.time.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final formattedTime = '$displayHour:${minute.toString().padLeft(2, '0')} $period';
    
    return Row(
      children: [
        Text(
          _getPrayerNameLocalized(prayerName, localizations),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const Spacer(),
        Text(
          formattedTime,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
  
  String _getPrayerNameLocalized(String prayerName, AppLocalizations localizations) {
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
}
