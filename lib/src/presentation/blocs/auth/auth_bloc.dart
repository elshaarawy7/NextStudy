import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/user_profile.dart';
import '../../../domain/usecases/sign_in_usecase.dart';
import '../../../domain/usecases/sign_out_usecase.dart';
import '../../../domain/usecases/sign_up_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
    required SignOutUseCase signOutUseCase,
  }) : _signInUseCase = signInUseCase,
       _signUpUseCase = signUpUseCase,
       _signOutUseCase = signOutUseCase,
       super(const AuthState()) {
    on<AuthStarted>(_onStarted);
    on<AuthModeChanged>(_onModeChanged);
    on<AuthSubmitted>(_onSubmitted);
    on<AuthSignedOut>(_onSignedOut);
  }

  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.unauthenticated));
  }

  void _onModeChanged(AuthModeChanged event, Emitter<AuthState> emit) {
    emit(
      state.copyWith(
        isLogin: event.isLogin,
        status: AuthStatus.unauthenticated,
        errorMessage: null,
      ),
    );
  }

  Future<void> _onSubmitted(
    AuthSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
      final user = state.isLogin
          ? await _signInUseCase(email: event.email, password: event.password)
          : await _signUpUseCase(
              name: event.name,
              email: event.email,
              password: event.password,
            );
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: error.toString(),
        ),
      );
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> _onSignedOut(
    AuthSignedOut event,
    Emitter<AuthState> emit,
  ) async {
    await _signOutUseCase();
    emit(
      state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
        errorMessage: null,
      ),
    );
  }
}
