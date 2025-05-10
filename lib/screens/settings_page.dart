import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import '../main.dart';
import '../theme/app_theme.dart';
import '../services/reset_counters_service.dart';
import '../services/prayer_notification_service.dart';
import '../services/adhan_service.dart';
import 'legal/privacy_policy_page.dart';

// Conditionally import package_info_plus
import 'package:package_info_plus/package_info_plus.dart'
    if (kIsWeb) 'package_info_plus_web_shim.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _appVersion = '2.0.0';
  String _buildNumber = '2';

  bool _showIndividualResetButtons = false;
  bool _showGlobalResetButton = true;
  bool _notificationsEnabled = true;
  bool _adhanEnabled = true;
  String _selectedAdhan = 'none';
  StreamSubscription<bool>? _notificationSettingsSubscription;

  final PrayerNotificationService _notificationService =
      PrayerNotificationService();
  final AdhanService _adhanService = AdhanService();

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadResetOptions();
    
    // Listen to notification settings changes from other screens
    _notificationSettingsSubscription = _notificationService.notificationSettingsStream.listen((enabled) {
      if (mounted && enabled != _notificationsEnabled) {
        setState(() {
          _notificationsEnabled = enabled;
        });
        print('Settings Page: Notification setting updated from stream: $enabled');
      }
    });
    
    print('Settings page initialized');
  }
  
  Future<void> _loadResetOptions() async {
    // Load reset options preferences
    final showIndividual = await ResetCountersService.getShowIndividualResetButtons();
    final showGlobal = await ResetCountersService.getShowGlobalResetButton();
    
    setState(() {
      _showIndividualResetButtons = showIndividual;
      _showGlobalResetButton = showGlobal;
    });
  }

  Future<void> _loadSettings() async {
    // Initialize services first
    await _notificationService.initialize();
    await _adhanService.initialize();
    
    // Then load settings
    setState(() {
      _notificationsEnabled = _notificationService.isNotificationsEnabled();
      _selectedAdhan = _adhanService.getSelectedAdhan();
      _adhanEnabled = _adhanService.isAdhanEnabled();
    });
    
    print('Settings loaded: notifications=$_notificationsEnabled, adhan=$_selectedAdhan, adhanEnabled=$_adhanEnabled');

    // Load package info for app version display
    if (!kIsWeb) {
      try {
        final packageInfo = await PackageInfo.fromPlatform();
        setState(() {
          _appVersion = packageInfo.version;
          _buildNumber = packageInfo.buildNumber;
        });
      } catch (e) {
        debugPrint('Error getting package info: $e');
      }
    }
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch $urlString'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _notificationSettingsSubscription?.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final appLanguage = Provider.of<AppLanguage>(context);
    final appLocalizations = AppLocalizations.of(context)!;
    final isArabic = appLanguage.appLocale.languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(title: Text(appLocalizations.settings)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification Settings
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic ? 'إعدادات الإشعارات' : 'Notification Settings',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    // Prayer Notifications Switch
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isArabic
                                    ? 'تفعيل إشعارات الصلاة'
                                    : 'Enable Prayer Notifications',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isArabic
                                    ? 'استلام إشعار قبل 5 دقائق من وقت الصلاة'
                                    : 'Notification 5 min before prayer',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _notificationsEnabled,
                          activeColor: AppTheme.primaryGradientStart,
                          onChanged: (value) async {
                            await _notificationService.setNotificationsEnabled(value);
                            setState(() {
                              _notificationsEnabled = value;
                            });
                            
                            print('Settings Page: Notification setting toggled to: $value');

                            // Show a snackbar to confirm the change
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    value
                                        ? (isArabic
                                            ? 'تم تفعيل الإشعارات'
                                            : 'Notifications enabled')
                                        : (isArabic
                                            ? 'تم تعطيل الإشعارات'
                                            : 'Notifications disabled'),
                                  ),
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    
                    // Only show test notification button if notifications are enabled
                    if (_notificationsEnabled) ...[  
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () async {
                          // Show a test notification
                          final success = await _notificationService.showTestNotification(context);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  success
                                      ? (isArabic
                                          ? 'تم إرسال إشعار تجريبي'
                                          : 'Test notification sent')
                                      : (isArabic
                                          ? 'فشل في إرسال الإشعار'
                                          : 'Failed to send notification'),
                                ),
                                backgroundColor: success ? Colors.green : Colors.red,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.notifications_active),
                        label: Text(isArabic ? 'تجربة الإشعار' : 'Test Notification'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppTheme.primaryGradientStart,
                          minimumSize: const Size(double.infinity, 45),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),

                    // Adhan Enable/Disable Switch
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isArabic ? 'تفعيل الأذان' : 'Enable Adhan',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isArabic
                                    ? 'تشغيل الأذان عند وقت الصلاة'
                                    : 'Play adhan at prayer time',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _adhanEnabled,
                          activeColor: AppTheme.primaryGradientStart,
                          onChanged: (value) async {
                            await _adhanService.setAdhanEnabled(value);
                            setState(() {
                              _adhanEnabled = value;
                            });

                            // Show a snackbar to confirm the change
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    value
                                        ? (isArabic
                                            ? 'تم تفعيل الأذان'
                                            : 'Adhan enabled')
                                        : (isArabic
                                            ? 'تم تعطيل الأذان'
                                            : 'Adhan disabled'),
                                  ),
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Adhan selection for prayer times
                    Text(
                      isArabic ? 'صوت الأذان عند وقت الصلاة' : 'Adhan at Prayer Time',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedAdhan,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        enabled: _adhanEnabled,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'none',
                          child: Text(isArabic ? 'بدون أذان' : 'No Adhan'),
                        ),
                        DropdownMenuItem(
                          value: 'sudais',
                          child: Text(isArabic ? 'أذان الشيخ السديس' : 'Sheikh Sudais Adhan'),
                        ),
                        DropdownMenuItem(
                          value: 'makkah',
                          child: Text(isArabic ? 'أذان مكة' : 'Makkah Adhan'),
                        ),
                        DropdownMenuItem(
                          value: 'madinah',
                          child: Text(isArabic ? 'أذان المدينة' : 'Madinah Adhan'),
                        ),
                      ],
                      onChanged: _adhanEnabled ? (value) async {
                        if (value != null) {
                          await _adhanService.saveAdhanPreference(value);
                          setState(() {
                            _selectedAdhan = value;
                          });
                          
                          // Show a snackbar to confirm the adhan change
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isArabic 
                                      ? 'تم تغيير صوت الأذان' 
                                      : 'Adhan sound changed',
                                ),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        }
                      } : null,
                    ),

                    const SizedBox(height: 16),

                    // Test Adhan Button (only if adhan is enabled)
                    if (_adhanEnabled) 
                      ElevatedButton.icon(
                        onPressed: () {
                          // Play the selected adhan
                          _adhanService.playAdhan();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isArabic
                                    ? 'جاري تشغيل الأذان...'
                                    : 'Playing adhan...',
                              ),
                              action: SnackBarAction(
                                label: isArabic ? 'إيقاف' : 'Stop',
                                onPressed: () {
                                  _adhanService.stopAdhan();
                                },
                              ),
                              duration: const Duration(seconds: 10),
                            ),
                          );
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: Text(isArabic ? 'تجربة الأذان' : 'Test Adhan'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppTheme.primaryGradientStart,
                          minimumSize: const Size(double.infinity, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Reset Options
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic ? 'خيارات إعادة الضبط' : 'Reset Options',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    // Toggle between individual and global reset
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isArabic
                              ? 'تفعيل خيار إعادة الضبط الفردي'
                              : 'Enable Individual Reset Option',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Switch(
                          value: _showIndividualResetButtons,
                          activeColor: AppTheme.primaryGradientStart,
                          onChanged: (value) async {
                            setState(() {
                              _showIndividualResetButtons = value;
                              _showGlobalResetButton = !value;
                            });
                            
                            // Save the preference
                            await ResetCountersService.setShowIndividualResetButtons(value);
                            await ResetCountersService.setShowGlobalResetButton(!value);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Individual Reset Button (only shown when enabled)
                    if (_showIndividualResetButtons)
                      ResetButton(
                        label: isArabic ? 'إعادة ضبط العدادات الفردية' : 'Reset Individual Counters',
                        onPressed: () async {
                          // Reset all counters
                          await ResetCountersService.resetAllCounters();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isArabic
                                      ? 'تم إعادة ضبط العدادات الفردية'
                                      : 'Individual counters have been reset',
                                ),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                      ),
                    
                    const SizedBox(height: 16),
                    
                    // Global Reset Button (Reinstall Settings)
                    if (_showGlobalResetButton)
                      ResetButton(
                        label: isArabic ? 'إعادة ضبط الإعدادات' : 'Reinstall Settings',
                        onPressed: () async {
                          await ResetCountersService.resetAllCounters();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isArabic
                                      ? 'تم إعادة ضبط جميع العدادات'
                                      : 'All counters have been reset',
                                ),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Language Settings
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic ? 'اللغة' : 'Language',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    // Language selection with radio buttons
                    Text(
                      isArabic ? 'اختر اللغة' : 'Select Language',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    
                    // Arabic option
                    RadioListTile<String>(
                      title: const Text('اللغة العربية (Arabic)'),
                      value: 'ar',
                      groupValue: isArabic ? 'ar' : 'en',
                      activeColor: AppTheme.primaryGradientStart,
                      onChanged: (value) {
                        if (value != null) {
                          appLanguage.changeLanguage(const Locale('ar'));
                        }
                      },
                    ),
                    
                    // English option
                    RadioListTile<String>(
                      title: const Text('English (الإنجليزية)'),
                      value: 'en',
                      groupValue: isArabic ? 'ar' : 'en',
                      activeColor: AppTheme.primaryGradientStart,
                      onChanged: (value) {
                        if (value != null) {
                          appLanguage.changeLanguage(const Locale('en'));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // About the App
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appLocalizations.aboutApp,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isArabic
                          ? 'ذكرني - تطبيق يساعد المسلمين على معرفة أوقات الصلاة في محافظات مصر المختلفة، ويوفر أذكار وأدعية يومية للمسلم.'
                          : 'Zakrni helps Muslims know prayer times in different governorates of Egypt, and provides daily dhikr and supplications.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      appLocalizations.developer,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text('Mohamed Ashraf Fathy AL-Adawi'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Social Media Links
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appLocalizations.socialMedia,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    SocialLinkButton(
                      icon: Icons.facebook,
                      label: 'Facebook',
                      onPressed:
                          () => _launchUrl(
                            'https://www.facebook.com/profile.php?id=100026964892101',
                          ),
                    ),
                    const SizedBox(height: 8),
                    SocialLinkButton(
                      icon: Icons.code,
                      label: 'GitHub',
                      onPressed:
                          () => _launchUrl(
                            'https://github.com/mohamedashraffathyoffical',
                          ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Privacy Policy & App Version
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Privacy Policy
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appLocalizations.privacyPolicy,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PrivacyPolicyPage(),
                                ),
                              );
                            },
                            child: Text(
                              isArabic ? 'عرض سياسة الخصوصية' : 'View Privacy Policy',
                              style: TextStyle(color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // App Version
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            isArabic ? 'إصدار التطبيق' : 'App Version',
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.end,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$_appVersion (${isArabic ? 'بناء' : 'Build'} $_buildNumber)',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class ResetButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const ResetButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppTheme.primaryGradientStart,
        minimumSize: const Size(double.infinity, 45),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label),
    );
  }
}

class SocialLinkButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const SocialLinkButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppTheme.primaryGradientStart,
        minimumSize: const Size(double.infinity, 45),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
