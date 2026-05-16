part of 'auth_bloc.dart';

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.isLogin = true,
    this.errorMessage,
  });

  final AuthStatus status;
  final UserProfile? user;
  final bool isLogin;
  final String? errorMessage;

  AuthState copyWith({
    AuthStatus? status,
    UserProfile? user,
    bool? isLogin,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      isLogin: isLogin ?? this.isLogin,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, isLogin, errorMessage];
}

enum AuthStatus { initial, loading, unauthenticated, authenticated, failure }
