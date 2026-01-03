import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ru.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('ru'),
  ];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'EcoTrack'**
  String get appName;

  /// Welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome to EcoTrack'**
  String get welcome;

  /// Sign in button text
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Sign up button text
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Email label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Forgot password link
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Calculate button text
  ///
  /// In en, this message translates to:
  /// **'Calculate Carbon Footprint'**
  String get calculateCarbonFootprint;

  /// Carbon footprint title
  ///
  /// In en, this message translates to:
  /// **'Your Carbon Footprint'**
  String get yourCarbonFootprint;

  /// Recycling points title
  ///
  /// In en, this message translates to:
  /// **'Recycling Points'**
  String get recyclingPoints;

  /// Active challenges title
  ///
  /// In en, this message translates to:
  /// **'Active Challenges'**
  String get activeChallenges;

  /// Statistics title
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// Achievements title
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// Settings title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Logout button text
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Home tab label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Calculator tab label
  ///
  /// In en, this message translates to:
  /// **'Calculator'**
  String get calculator;

  /// Map tab label
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// Profile tab label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Filter label on map page
  ///
  /// In en, this message translates to:
  /// **'Filter by Type'**
  String get filterByType;

  /// Google sign in button text
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// Demo mode button text
  ///
  /// In en, this message translates to:
  /// **'Try Demo Mode'**
  String get tryDemoMode;

  /// Register link text
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// Divider text
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// Calculator page title
  ///
  /// In en, this message translates to:
  /// **'Carbon Footprint Calculator'**
  String get carbonFootprintCalculator;

  /// Calculate again button
  ///
  /// In en, this message translates to:
  /// **'Calculate Again'**
  String get calculateAgain;

  /// Calculator description
  ///
  /// In en, this message translates to:
  /// **'Track your environmental impact'**
  String get trackYourImpact;

  /// Color palette setting title
  ///
  /// In en, this message translates to:
  /// **'Color Palette'**
  String get colorPalette;

  /// Theme mode setting title
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeMode;

  /// Light theme mode
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Dark theme mode
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// Auto theme mode
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get auto;

  /// Transport category
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get transport;

  /// Energy category
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get energy;

  /// Diet category
  ///
  /// In en, this message translates to:
  /// **'Diet'**
  String get diet;

  /// Waste category
  ///
  /// In en, this message translates to:
  /// **'Waste'**
  String get waste;

  /// Create account page title
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// Full name field label
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Reset password page title
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// Send reset link button
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// Visit website button
  ///
  /// In en, this message translates to:
  /// **'Visit Website'**
  String get visitWebsite;

  /// Get directions button
  ///
  /// In en, this message translates to:
  /// **'Get Directions'**
  String get getDirections;

  /// Car input label
  ///
  /// In en, this message translates to:
  /// **'Car (km)'**
  String get car;

  /// Bus input label
  ///
  /// In en, this message translates to:
  /// **'Bus (km)'**
  String get bus;

  /// Train input label
  ///
  /// In en, this message translates to:
  /// **'Train (km)'**
  String get train;

  /// Plane input label
  ///
  /// In en, this message translates to:
  /// **'Plane (km)'**
  String get plane;

  /// Electricity input label
  ///
  /// In en, this message translates to:
  /// **'Electricity (kWh)'**
  String get electricity;

  /// Meat input label
  ///
  /// In en, this message translates to:
  /// **'Meat (kg)'**
  String get meat;

  /// Dairy input label
  ///
  /// In en, this message translates to:
  /// **'Dairy (kg)'**
  String get dairy;

  /// Skip button
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Sign in subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInToContinue;

  /// Email hint
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// Password hint
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// Points label
  ///
  /// In en, this message translates to:
  /// **'points'**
  String get points;

  /// Eco color palette
  ///
  /// In en, this message translates to:
  /// **'Eco'**
  String get eco;

  /// Minimalist color palette
  ///
  /// In en, this message translates to:
  /// **'Minimalist'**
  String get minimalist;

  /// Vibrant color palette
  ///
  /// In en, this message translates to:
  /// **'Vibrant'**
  String get vibrant;

  /// Challenge title: Use public transport
  ///
  /// In en, this message translates to:
  /// **'Use Public Transport'**
  String get challengeUsePublicTransport;

  /// Challenge description: Use public transport
  ///
  /// In en, this message translates to:
  /// **'Use public transport instead of car for 3 days'**
  String get challengeUsePublicTransportDesc;

  /// Challenge title: Reduce meat
  ///
  /// In en, this message translates to:
  /// **'Reduce Meat Consumption'**
  String get challengeReduceMeat;

  /// Challenge description: Reduce meat
  ///
  /// In en, this message translates to:
  /// **'Have 5 vegetarian meals this week'**
  String get challengeReduceMeatDesc;

  /// Challenge title: Recycle electronics
  ///
  /// In en, this message translates to:
  /// **'Recycle Electronics'**
  String get challengeRecycleElectronics;

  /// Challenge description: Recycle electronics
  ///
  /// In en, this message translates to:
  /// **'Visit a recycling point for electronics'**
  String get challengeRecycleElectronicsDesc;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
