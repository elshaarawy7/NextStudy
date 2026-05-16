part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

class AuthStarted extends AuthEvent {
  const AuthStarted();
}

class AuthModeChanged extends AuthEvent {
  const AuthModeChanged(this.isLogin);

  final bool isLogin;
}

class AuthSubmitted extends AuthEvent {
  const AuthSubmitted({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;
}

class AuthSignedOut extends AuthEvent {
  const AuthSignedOut();
}
