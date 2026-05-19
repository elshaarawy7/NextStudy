import 'package:uuid/uuid.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/entities/lecture.dart';
import '../models/analysis_bundle_model.dart';
import '../services/pdf_text_processor.dart';

class MockAiDataSource {
  final Uuid _uuid = const Uuid();

  Future<AnalysisBundleModel> analyzeLecture(Lecture lecture) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final processed = PdfTextProcessor.prepare(
      rawText: lecture.extractedText,
      lectureTitle: lecture.title,
    );
    return AnalysisBundleModel.fromProcessedText(
      text: processed.cleanedText,
      title: lecture.title,
      prompt: processed.analysisPrompt,
      chunks: processed.chunks,
    );
  }

  Future<ChatMessage> sendChatMessage({
    required Lecture lecture,
    required String message,
    required List<ChatMessage> history,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final processed = PdfTextProcessor.prepare(
      rawText: lecture.extractedText,
      lectureTitle: lecture.title,
    );
    final focusLine = processed.chunks
        .expand(
          (chunk) =>
              chunk.split(RegExp(r'(?<=[.!?؟])\s+')).map((line) => line.trim()),
        )
        .firstWhere(
          (line) => line.isNotEmpty,
          orElse: () => lecture.previewText,
        );

    return ChatMessage(
      id: _uuid.v4(),
      text:
          'من محاضرة "${lecture.title}"، الفكرة الأقرب لسؤالك هي: $focusLine\n\nبشكل مبسط: يرتبط سؤالك بمفهوم أساسي داخل المحاضرة، لذلك ابدأ بهذه الفكرة ثم راجع الأمثلة المرتبطة بها داخل الملف.',
      isUser: false,
      createdAt: DateTime.now(),
    );
  }
}
