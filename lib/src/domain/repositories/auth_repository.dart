import '../entities/user_profile.dart';

abstract class AuthRepository {
  Future<UserProfile?> getCurrentUser();
  Future<UserProfile> signIn({required String email, required String password});
  Future<UserProfile> signUp({
    required String name,
    required String email,
    required String password,
  });
  Future<void> signOut();
}
