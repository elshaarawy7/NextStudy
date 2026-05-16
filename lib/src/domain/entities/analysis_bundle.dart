import 'package:equatable/equatable.dart';

import 'flashcard.dart';
import 'quiz_question.dart';

class AnalysisBundle extends Equatable {
  const AnalysisBundle({
    required this.summary,
    required this.keyPoints,
    required this.steps,
    required this.quiz,
    required this.flashcards,
  });

  final String summary;
  final List<String> keyPoints;
  final List<String> steps;
  final List<QuizQuestion> quiz;
  final List<Flashcard> flashcards;

  @override
  List<Object?> get props => [summary, keyPoints, steps, quiz, flashcards];
}
