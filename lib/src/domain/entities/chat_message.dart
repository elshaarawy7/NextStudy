import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.createdAt,
  });

  final String id;
  final String text;
  final bool isUser;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, text, isUser, createdAt];
}
