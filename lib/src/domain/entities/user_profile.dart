import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.studyStreak,
  });

  final String id;
  final String name;
  final String email;
  final int studyStreak;

  @override
  List<Object?> get props => [id, name, email, studyStreak];
}
