import '../../domain/entities/analysis_bundle.dart';
import '../../domain/entities/flashcard.dart';
import '../../domain/entities/quiz_question.dart';

class AnalysisBundleModel extends AnalysisBundle {
  const AnalysisBundleModel({
    required super.summary,
    required super.keyPoints,
    required super.steps,
    required super.quiz,
    required super.flashcards,
  });

  factory AnalysisBundleModel.fromText(String text, String title) {
    final sentences = text
        .replaceAll('\n', ' ')
        .split('.')
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList();
    final core = sentences.isEmpty
        ? [
            'This lecture introduces important ideas that students should review carefully.',
          ]
        : sentences.take(8).toList();

    final keyPoints = core.take(5).map((sentence) => sentence).toList();
    final steps = List.generate(
      4,
      (index) => 'Step ${index + 1}: ${core[index % core.length]}',
    );
    final quiz = List.generate(
      5,
      (index) => QuizQuestion(
        question:
            'What is the best description of concept ${index + 1} in $title?',
        options: [
          'A quick memorization trick',
          core[index % core.length],
          'An unrelated lecture topic',
          'A social media definition',
        ],
        correctAnswer: core[index % core.length],
      ),
    );
    final flashcards = List.generate(
      5,
      (index) => Flashcard(
        question: 'Explain idea ${index + 1} from $title.',
        answer: core[index % core.length],
      ),
    );

    return AnalysisBundleModel(
      summary:
          'This lecture on $title explains ${core.first.toLowerCase()} It also connects the topic to practical revision points so students can review faster.',
      keyPoints: keyPoints,
      steps: steps,
      quiz: quiz,
      flashcards: flashcards,
    );
  }
}
