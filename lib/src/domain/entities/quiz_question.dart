import 'package:equatable/equatable.dart';

class QuizQuestion extends Equatable {
  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  final String question;
  final List<String> options;
  final String correctAnswer;

  @override
  List<Object?> get props => [question, options, correctAnswer];
}
