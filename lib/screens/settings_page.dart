import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import '../theme/app_theme.dart';
import '../services/reset_counters_service.dart';
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

  bool _showIndividualResetButtons = true;
  bool _showGlobalResetButton = false;

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    _loadResetButtonPreferences();
  }

  Future<void> _initPackageInfo() async {
    try {
      if (!kIsWeb) {
        final info = await PackageInfo.fromPlatform();
        setState(() {
          _appVersion = info.version;
          _buildNumber = info.buildNumber;
        });
      }
    } catch (e) {
      // Fallback to default values if package_info_plus fails
      debugPrint('Error getting package info: $e');
    }
  }

  Future<void> _loadResetButtonPreferences() async {
    final showIndividualButtons =
        await ResetCountersService.getShowIndividualResetButtons();
    final showGlobalButton =
        await ResetCountersService.getShowGlobalResetButton();

    if (mounted) {
      setState(() {
        _showIndividualResetButtons = showIndividualButtons;
        _showGlobalResetButton = showGlobalButton;
      });
    }
  }

  Future<void> _saveResetButtonPreferences() async {
    await ResetCountersService.setShowIndividualResetButtons(
      _showIndividualResetButtons,
    );
    await ResetCountersService.setShowGlobalResetButton(_showGlobalResetButton);
  }

  Future<void> _launchUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      // Use externalApplication mode for social media links to ensure they open in their native apps if available
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch $url');
        // Show a snackbar when URL can't be launched
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could not open link: $url'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening link: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    final appLanguage = Provider.of<AppLanguage>(context);
    final isArabic = appLanguage.appLocale.languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(title: Text(appLocalizations.settings)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language Selection
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
                      appLocalizations.language,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      title: Text(appLocalizations.english),
                      leading: Radio<String>(
                        value: 'en',
                        groupValue: appLanguage.appLocale.languageCode,
                        onChanged: (value) {
                          if (value != null) {
                            appLanguage.changeLanguage(const Locale('en'));
                          }
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(appLocalizations.arabic),
                      leading: Radio<String>(
                        value: 'ar',
                        groupValue: appLanguage.appLocale.languageCode,
                        onChanged: (value) {
                          if (value != null) {
                            appLanguage.changeLanguage(const Locale('ar'));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Reset Options Section
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
                      appLocalizations.resetOptions,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      title: Text(
                        appLocalizations.enableIndividualResetButtons,
                      ),
                      value: _showIndividualResetButtons,
                      onChanged: (value) {
                        setState(() {
                          _showIndividualResetButtons = value;
                        });
                        _saveResetButtonPreferences();
                      },
                      secondary: Icon(
                        Icons.refresh,
                        color: Theme.of(context).primaryColor,
                      ),
                      activeColor: Theme.of(context).primaryColor,
                    ),
                    SwitchListTile(
                      title: Text(appLocalizations.enableGlobalResetButton),
                      value: _showGlobalResetButton,
                      onChanged: (value) {
                        setState(() {
                          _showGlobalResetButton = value;
                        });
                        _saveResetButtonPreferences();
                      },
                      secondary: Icon(
                        Icons.refresh_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                      activeColor: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // App Version
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
                      appLocalizations.appVersion,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '$_appVersion ($_buildNumber)',
                      style: Theme.of(context).textTheme.bodyLarge,
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
                          ? 'تطبيق مواقيت الصلاة يساعد المسلمين على معرفة أوقات الصلاة في مختلف محافظات مصر، كما يوفر الأذكار اليومية للمسلم.'
                          : 'Zakrni – ذكرني helps Muslims know prayer times in different governorates of Egypt, and provides daily dhikr and supplications.',
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

            // Privacy Policy
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
                      appLocalizations.privacyPolicy,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
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
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
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
