import '../entities/chat_message.dart';
import '../entities/lecture.dart';
import '../repositories/ai_repository.dart';

class SendChatMessageUseCase {
  const SendChatMessageUseCase(this._repository);

  final AiRepository _repository;

  Future<ChatMessage> call({
    required Lecture lecture,
    required String message,
    required List<ChatMessage> history,
  }) {
    return _repository.sendChatMessage(
      lecture: lecture,
      message: message,
      history: history,
    );
  }
}
