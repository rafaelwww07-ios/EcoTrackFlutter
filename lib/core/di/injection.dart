import 'package:get_it/get_it.dart';

/// Global service locator instance
final getIt = GetIt.instance;

/// Initialize dependency injection
/// Note: For now using manual registration. 
/// To use injectable code generation, add @InjectableInit() and run build_runner
Future<void> configureDependencies() async {
  // Dependencies can be registered here manually
  // Example:
  // getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
}

