// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'EcoTrack';

  @override
  String get welcome => 'Добро пожаловать в EcoTrack';

  @override
  String get signIn => 'Войти';

  @override
  String get signUp => 'Регистрация';

  @override
  String get email => 'Электронная почта';

  @override
  String get password => 'Пароль';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get calculateCarbonFootprint => 'Рассчитать углеродный след';

  @override
  String get yourCarbonFootprint => 'Ваш углеродный след';

  @override
  String get recyclingPoints => 'Пункты переработки';

  @override
  String get activeChallenges => 'Активные челленджи';

  @override
  String get statistics => 'Статистика';

  @override
  String get achievements => 'Достижения';

  @override
  String get settings => 'Настройки';

  @override
  String get logout => 'Выйти';
}
