import 'package:equatable/equatable.dart';

class Flashcard extends Equatable {
  const Flashcard({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  List<Object?> get props => [question, answer];
}
