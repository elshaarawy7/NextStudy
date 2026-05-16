import '../../domain/entities/user_profile.dart';

class UserModel extends UserProfile {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.studyStreak,
  });
}
