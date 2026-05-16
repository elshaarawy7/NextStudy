import '../entities/analysis_bundle.dart';
import '../entities/chat_message.dart';
import '../entities/lecture.dart';

abstract class AiRepository {
  Future<AnalysisBundle> analyzeLecture(Lecture lecture);
  Future<ChatMessage> sendChatMessage({
    required Lecture lecture,
    required String message,
    required List<ChatMessage> history,
  });
}
