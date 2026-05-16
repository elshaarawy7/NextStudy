import 'package:uuid/uuid.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/entities/lecture.dart';
import '../models/analysis_bundle_model.dart';

class MockAiDataSource {
  final Uuid _uuid = const Uuid();

  Future<AnalysisBundleModel> analyzeLecture(Lecture lecture) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    return AnalysisBundleModel.fromText(lecture.extractedText, lecture.title);
  }

  Future<ChatMessage> sendChatMessage({
    required Lecture lecture,
    required String message,
    required List<ChatMessage> history,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final focusLine = lecture.extractedText
        .split('.')
        .map((line) => line.trim())
        .firstWhere(
          (line) => line.isNotEmpty,
          orElse: () => lecture.previewText,
        );

    return ChatMessage(
      id: _uuid.v4(),
      text:
          'From "${lecture.title}", the clearest answer is: $focusLine\n\nIn simple terms: ${message.toLowerCase()} connects back to that core idea, so review this concept first and then revisit the related examples in the lecture.',
      isUser: false,
      createdAt: DateTime.now(),
    );
  }
}
