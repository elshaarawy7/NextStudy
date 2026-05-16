import '../entities/user_profile.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  const SignUpUseCase(this._repository);

  final AuthRepository _repository;

  Future<UserProfile> call({
    required String name,
    required String email,
    required String password,
  }) {
    return _repository.signUp(name: name, email: email, password: password);
  }
}
