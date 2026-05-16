import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/mock_auth_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({required MockAuthDataSource dataSource})
    : _dataSource = dataSource;

  final MockAuthDataSource _dataSource;

  @override
  Future<UserProfile?> getCurrentUser() => _dataSource.getCurrentUser();

  @override
  Future<UserProfile> signIn({
    required String email,
    required String password,
  }) {
    return _dataSource.signIn(email: email, password: password);
  }

  @override
  Future<UserProfile> signUp({
    required String name,
    required String email,
    required String password,
  }) {
    return _dataSource.signUp(name: name, email: email, password: password);
  }

  @override
  Future<void> signOut() => _dataSource.signOut();
}
