import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'l10n/app_localizations.dart';

export 'core/theme/app_theme.dart' show AppColorPalette, AppThemeMode;
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/onboarding/presentation/pages/onboarding_page.dart';

/// Main app widget
class EcoTrackApp extends StatefulWidget {
  const EcoTrackApp({super.key});

  static _EcoTrackAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_EcoTrackAppState>();
  }

  @override
  State<EcoTrackApp> createState() => _EcoTrackAppState();
}

class _EcoTrackAppState extends State<EcoTrackApp> {
  bool _isOnboardingCompleted = false;
  bool _isLoading = true;
  bool _isAuthenticated = false;
  AppColorPalette _colorPalette = AppColorPalette.eco;
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadAppSettings();
  }

  Future<void> _loadAppSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Check authentication status synchronously
    bool isAuth = false;
    try {
      if (Firebase.apps.isNotEmpty) {
        final currentUser = FirebaseAuth.instance.currentUser;
        isAuth = currentUser != null;
      }
    } catch (e) {
      // Firebase not initialized or error, assume not authenticated
      isAuth = false;
    }
    
    setState(() {
      _isOnboardingCompleted =
          prefs.getBool(AppConstants.keyOnboardingCompleted) ?? false;
      _isAuthenticated = isAuth;
      final paletteIndex = prefs.getInt(AppConstants.keyColorPalette) ?? 0;
      final modeIndex = prefs.getInt(AppConstants.keyThemeMode) ?? 2;
      _colorPalette = AppColorPalette.values[paletteIndex];
      // Map AppThemeMode to Flutter's ThemeMode
      _themeMode = modeIndex == 0
          ? ThemeMode.light
          : modeIndex == 1
              ? ThemeMode.dark
              : ThemeMode.system;
      _isLoading = false;
    });
  }

  /// Reload theme settings from SharedPreferences
  Future<void> reloadThemeSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final paletteIndex = prefs.getInt(AppConstants.keyColorPalette) ?? 0;
      final modeIndex = prefs.getInt(AppConstants.keyThemeMode) ?? 2;
      _colorPalette = AppColorPalette.values[paletteIndex];
      _themeMode = modeIndex == 0
          ? ThemeMode.light
          : modeIndex == 1
              ? ThemeMode.dark
              : ThemeMode.system;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    // Determine initial route based on onboarding and auth status
    String initialRoute;
    if (!_isOnboardingCompleted) {
      initialRoute = '/onboarding';
    } else if (_isAuthenticated) {
      initialRoute = '/home';
    } else {
      initialRoute = '/auth';
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          // Navigate based on auth state changes
          if (state is AuthSuccess) {
            // User is authenticated, navigate to home
            final navigator = Navigator.of(context);
            if (navigator.canPop()) {
              navigator.popUntil((route) => route.isFirst);
            }
            if (ModalRoute.of(context)?.settings.name != '/home') {
              navigator.pushReplacementNamed('/home');
            }
          } else if (state is AuthInitial && _isAuthenticated) {
            // User logged out, navigate to auth
            final navigator = Navigator.of(context);
            if (navigator.canPop()) {
              navigator.popUntil((route) => route.isFirst);
            }
            if (ModalRoute.of(context)?.settings.name != '/auth') {
              navigator.pushReplacementNamed('/auth');
            }
          }
        },
        child: MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getLightTheme(_colorPalette),
          darkTheme: AppTheme.getDarkTheme(_colorPalette),
          themeMode: _themeMode,
          // Localization support
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          initialRoute: initialRoute,
          routes: {
            '/onboarding': (context) => const OnboardingPage(),
            '/auth': (context) => const LoginPage(),
            '/home': (context) => const HomePage(),
          },
        ),
      ),
    );
  }
}

