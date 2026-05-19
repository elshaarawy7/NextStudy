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
    return AnalysisBundleModel.fromProcessedText(
      text: text,
      title: title,
      prompt: '',
      chunks: [text],
    );
  }

  factory AnalysisBundleModel.fromProcessedText({
    required String text,
    required String title,
    required String prompt,
    required List<String> chunks,
  }) {
    final sentences = text
        .replaceAll('\n', ' ')
        .split(RegExp(r'(?<=[.!?؟:;])\s+'))
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList();
    final core = sentences.isEmpty
        ? ['المحاضرة تتناول مفاهيم دراسية مهمة تحتاج إلى مراجعة منظمة.']
        : sentences.take(10).toList();

    final keyPoints = core.take(5).toList();
    final steps = List.generate(
      4,
      (index) => 'الخطوة ${index + 1}: ${core[index % core.length]}',
    );
    final quizSeed = chunks.isEmpty ? core : chunks;
    final quiz = List.generate(
      4,
      (index) => QuizQuestion(
        question: 'ما الفكرة الأساسية في الجزء ${index + 1} من محاضرة $title؟',
        options: [
          core[index % core.length],
          'اسم المحاضر أو الجهة التعليمية',
          'معلومات إدارية لا ترتبط بالمحتوى',
          'تفصيل غير مذكور في المحاضرة',
        ],
        correctAnswer: core[index % core.length],
      ),
    );
    final flashcards = List.generate(
      5,
      (index) => Flashcard(
        question: 'اشرح المفهوم ${index + 1} من محاضرة $title.',
        answer: quizSeed[index % quizSeed.length],
      ),
    );
    final summaryLead = core.first;
    final promptHint = prompt.isEmpty
        ? ''
        : 'تم تجاهل البيانات غير التعليمية والنصوص المكررة. ';

    return AnalysisBundleModel(
      summary:
          '$promptHintتشرح هذه المحاضرة بعنوان $title الفكرة التالية: $summaryLead كما تربط بين المفاهيم الأساسية والنقاط التي يحتاجها الطالب في المراجعة.',
      keyPoints: keyPoints,
      steps: steps,
      quiz: quiz,
      flashcards: flashcards,
    );
  }
}
