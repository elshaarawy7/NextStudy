import 'package:equatable/equatable.dart';

import '../../../domain/entities/chat_message.dart';

enum ChatStatus { idle, sending, failure }

class ChatState extends Equatable {
  const ChatState({
    this.status = ChatStatus.idle,
    this.messages = const [],
    this.errorMessage,
  });

  final ChatStatus status;
  final List<ChatMessage> messages;
  final String? errorMessage;

  ChatState copyWith({
    ChatStatus? status,
    List<ChatMessage>? messages,
    String? errorMessage,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, messages, errorMessage];
}
