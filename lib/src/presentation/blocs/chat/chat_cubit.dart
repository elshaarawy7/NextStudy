import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/chat_message.dart';
import '../../../domain/entities/lecture.dart';
import '../../../domain/usecases/send_chat_message_usecase.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({required SendChatMessageUseCase sendChatMessageUseCase})
    : _sendChatMessageUseCase = sendChatMessageUseCase,
      super(
        ChatState(
          messages: [
            ChatMessage(
              id: const Uuid().v4(),
              text:
                  'Ask anything about your lecture and I will explain it in simple study-friendly language.',
              isUser: false,
              createdAt: DateTime.now(),
            ),
          ],
        ),
      );

  final SendChatMessageUseCase _sendChatMessageUseCase;
  final Uuid _uuid = const Uuid();

  void reset() {
    emit(
      ChatState(
        messages: [
          ChatMessage(
            id: _uuid.v4(),
            text:
                'Ask anything about your lecture and I will explain it in simple study-friendly language.',
            isUser: false,
            createdAt: DateTime.now(),
          ),
        ],
      ),
    );
  }

  Future<void> sendMessage({
    required Lecture lecture,
    required String message,
  }) async {
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      text: message,
      isUser: true,
      createdAt: DateTime.now(),
    );

    final nextMessages = [...state.messages, userMessage];
    emit(state.copyWith(status: ChatStatus.sending, messages: nextMessages));

    try {
      final reply = await _sendChatMessageUseCase(
        lecture: lecture,
        message: message,
        history: nextMessages,
      );
      emit(
        state.copyWith(
          status: ChatStatus.idle,
          messages: [...nextMessages, reply],
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ChatStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
