import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @confirmYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmYourPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @signupNow.
  ///
  /// In en, this message translates to:
  /// **'Sign up now'**
  String get signupNow;

  /// No description provided for @loginNow.
  ///
  /// In en, this message translates to:
  /// **'Login now'**
  String get loginNow;

  /// No description provided for @resetPasswordInstructions.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive password reset instructions'**
  String get resetPasswordInstructions;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get enterNewPassword;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @nextPrayer.
  ///
  /// In en, this message translates to:
  /// **'Next Prayer'**
  String get nextPrayer;

  /// No description provided for @timeRemaining.
  ///
  /// In en, this message translates to:
  /// **'Time Remaining'**
  String get timeRemaining;

  /// No description provided for @azkar.
  ///
  /// In en, this message translates to:
  /// **'Azkar'**
  String get azkar;

  /// No description provided for @morningAzkar.
  ///
  /// In en, this message translates to:
  /// **'Morning Azkar'**
  String get morningAzkar;

  /// No description provided for @afterPrayerAzkar.
  ///
  /// In en, this message translates to:
  /// **'After Prayer Azkar'**
  String get afterPrayerAzkar;

  /// No description provided for @sleepAzkar.
  ///
  /// In en, this message translates to:
  /// **'Sleep Azkar'**
  String get sleepAzkar;

  /// No description provided for @wakeUpAzkar.
  ///
  /// In en, this message translates to:
  /// **'Wake Up Azkar'**
  String get wakeUpAzkar;

  /// No description provided for @selectGovernorate.
  ///
  /// In en, this message translates to:
  /// **'Select Governorate'**
  String get selectGovernorate;

  /// No description provided for @fajr.
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get fajr;

  /// No description provided for @sunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get sunrise;

  /// No description provided for @dhuhr.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get dhuhr;

  /// No description provided for @asr.
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get asr;

  /// No description provided for @maghrib.
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get maghrib;

  /// No description provided for @isha.
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get isha;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get seconds;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get invalidEmail;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @cairo.
  ///
  /// In en, this message translates to:
  /// **'Cairo'**
  String get cairo;

  /// No description provided for @alexandria.
  ///
  /// In en, this message translates to:
  /// **'Alexandria'**
  String get alexandria;

  /// No description provided for @giza.
  ///
  /// In en, this message translates to:
  /// **'Giza'**
  String get giza;

  /// No description provided for @sharmElSheikh.
  ///
  /// In en, this message translates to:
  /// **'Sharm El Sheikh'**
  String get sharmElSheikh;

  /// No description provided for @luxor.
  ///
  /// In en, this message translates to:
  /// **'Luxor'**
  String get luxor;

  /// No description provided for @aswan.
  ///
  /// In en, this message translates to:
  /// **'Aswan'**
  String get aswan;

  /// No description provided for @portSaid.
  ///
  /// In en, this message translates to:
  /// **'Port Said'**
  String get portSaid;

  /// No description provided for @suez.
  ///
  /// In en, this message translates to:
  /// **'Suez'**
  String get suez;

  /// No description provided for @mansoura.
  ///
  /// In en, this message translates to:
  /// **'Mansoura'**
  String get mansoura;

  /// No description provided for @tanta.
  ///
  /// In en, this message translates to:
  /// **'Tanta'**
  String get tanta;

  /// No description provided for @sharqia.
  ///
  /// In en, this message translates to:
  /// **'Sharqia'**
  String get sharqia;

  /// No description provided for @ismailia.
  ///
  /// In en, this message translates to:
  /// **'Ismailia'**
  String get ismailia;

  /// No description provided for @hurghada.
  ///
  /// In en, this message translates to:
  /// **'Hurghada'**
  String get hurghada;

  /// No description provided for @damietta.
  ///
  /// In en, this message translates to:
  /// **'Damietta'**
  String get damietta;

  /// No description provided for @beniSuef.
  ///
  /// In en, this message translates to:
  /// **'Beni Suef'**
  String get beniSuef;

  /// No description provided for @minya.
  ///
  /// In en, this message translates to:
  /// **'Minya'**
  String get minya;

  /// No description provided for @sohag.
  ///
  /// In en, this message translates to:
  /// **'Sohag'**
  String get sohag;

  /// No description provided for @qena.
  ///
  /// In en, this message translates to:
  /// **'Qena'**
  String get qena;

  /// No description provided for @mersaMatruh.
  ///
  /// In en, this message translates to:
  /// **'Mersa Matruh'**
  String get mersaMatruh;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About the App'**
  String get aboutApp;

  /// No description provided for @developer.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// No description provided for @socialMedia.
  ///
  /// In en, this message translates to:
  /// **'Social Media'**
  String get socialMedia;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @resetOptions.
  ///
  /// In en, this message translates to:
  /// **'Reset Options'**
  String get resetOptions;

  /// No description provided for @enableIndividualResetButtons.
  ///
  /// In en, this message translates to:
  /// **'Enable individual reset buttons'**
  String get enableIndividualResetButtons;

  /// No description provided for @enableGlobalResetButton.
  ///
  /// In en, this message translates to:
  /// **'Enable global reset button'**
  String get enableGlobalResetButton;

  /// No description provided for @resetAll.
  ///
  /// In en, this message translates to:
  /// **'Reset All'**
  String get resetAll;

  /// No description provided for @resetAllConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset all counters?'**
  String get resetAllConfirmation;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @allCountersReset.
  ///
  /// In en, this message translates to:
  /// **'All counters have been reset'**
  String get allCountersReset;

  /// No description provided for @privacyPolicyIntro.
  ///
  /// In en, this message translates to:
  /// **'We respect your privacy and are committed to protecting your data. \"Zakrni – ذكرني\" is a 100% free application and does not require registration or any personal information from users.'**
  String get privacyPolicyIntro;

  /// No description provided for @dataCollection.
  ///
  /// In en, this message translates to:
  /// **'Data Collection'**
  String get dataCollection;

  /// No description provided for @dataUsage.
  ///
  /// In en, this message translates to:
  /// **'Data Usage'**
  String get dataUsage;

  /// No description provided for @dataSharing.
  ///
  /// In en, this message translates to:
  /// **'Data Sharing'**
  String get dataSharing;

  /// No description provided for @advertisements.
  ///
  /// In en, this message translates to:
  /// **'Advertisements'**
  String get advertisements;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @updates.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get updates;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @noPersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'We do not collect any personal information from users.'**
  String get noPersonalInfo;

  /// No description provided for @noLogin.
  ///
  /// In en, this message translates to:
  /// **'We do not require login or link the app to any personal accounts such as email or phone numbers.'**
  String get noLogin;

  /// No description provided for @noDataStorage.
  ///
  /// In en, this message translates to:
  /// **'We do not store or use any personal data.'**
  String get noDataStorage;

  /// No description provided for @apiUsage.
  ///
  /// In en, this message translates to:
  /// **'The app connects to the internet only to retrieve prayer times using an external API, without sending any personal or identifying information.'**
  String get apiUsage;

  /// No description provided for @noDataSharing.
  ///
  /// In en, this message translates to:
  /// **'We do not share any data with third parties, as we do not collect any user data.'**
  String get noDataSharing;

  /// No description provided for @noAds.
  ///
  /// In en, this message translates to:
  /// **'The app does not contain advertisements and does not use tracking tools.'**
  String get noAds;

  /// No description provided for @noDataProtection.
  ///
  /// In en, this message translates to:
  /// **'Since the app does not collect any user data, there is no need for data protection measures.'**
  String get noDataProtection;

  /// No description provided for @apiConnection.
  ///
  /// In en, this message translates to:
  /// **'The connection to the prayer times API is solely for displaying accurate prayer times and does not involve any transmission of user-identifiable data.'**
  String get apiConnection;

  /// No description provided for @policyUpdates.
  ///
  /// In en, this message translates to:
  /// **'This policy may be updated in the future if new features are added. Users will be informed within the app if necessary.'**
  String get policyUpdates;

  /// No description provided for @contactIntro.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions about this privacy policy, feel free to contact us at:'**
  String get contactIntro;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
