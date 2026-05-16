import 'package:uuid/uuid.dart';

import '../models/user_model.dart';

class MockAuthDataSource {
  final Uuid _uuid = const Uuid();
  UserModel? _currentUser;

  Future<UserModel?> getCurrentUser() async => _currentUser;

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _currentUser = UserModel(
      id: _uuid.v4(),
      name: email.split('@').first,
      email: email,
      studyStreak: 7,
    );
    return _currentUser!;
  }

  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    _currentUser = UserModel(
      id: _uuid.v4(),
      name: name,
      email: email,
      studyStreak: 1,
    );
    return _currentUser!;
  }

  Future<void> signOut() async {
    _currentUser = null;
  }
}
