import '../entities/user_profile.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase {
  const SignInUseCase(this._repository);

  final AuthRepository _repository;

  Future<UserProfile> call({required String email, required String password}) {
    return _repository.signIn(email: email, password: password);
  }
}
