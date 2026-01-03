part of 'auth_bloc.dart';

/// Authentication events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Login event
class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Register event
class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String displayName;

  const RegisterEvent({
    required this.email,
    required this.password,
    required this.displayName,
  });

  @override
  List<Object?> get props => [email, password, displayName];
}

/// Google Sign-In event
class GoogleSignInEvent extends AuthEvent {
  const GoogleSignInEvent();
}

/// Reset password event
class ResetPasswordEvent extends AuthEvent {
  final String email;

  const ResetPasswordEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

/// Logout event
class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

/// Demo mode event
class DemoModeEvent extends AuthEvent {
  const DemoModeEvent();
}

/// Check auth status event
class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}

