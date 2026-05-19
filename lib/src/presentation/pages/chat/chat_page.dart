import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/lecture.dart';
import '../../blocs/chat/chat_cubit.dart';
import '../../blocs/chat/chat_state.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.lecture});

  final Lecture lecture;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().reset();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('دردشة المحاضرة')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  if (state.messages.isEmpty) {
                    return Center(
                      child: Text(
                        'ابدأ بكتابة سؤالك عن المحاضرة.',
                        textDirection: TextDirection.rtl,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(color: AppTheme.muted),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: state.messages.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      return Align(
                        alignment: message.isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 320),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: message.isUser
                                ? AppTheme.primary
                                : Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: message.isUser
                                  ? AppTheme.primary
                                  : AppTheme.border,
                            ),
                            boxShadow: message.isUser
                                ? null
                                : AppTheme.softShadow(),
                          ),
                          child: Text(
                            message.text,
                            textDirection: TextDirection.rtl,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: message.isUser
                                      ? Colors.white
                                      : AppTheme.text,
                                ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 3,
                    textDirection: TextDirection.rtl,
                    decoration: const InputDecoration(
                      hintText: 'اكتب سؤالك عن هذه المحاضرة',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                BlocBuilder<ChatCubit, ChatState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state.status == ChatStatus.sending
                          ? null
                          : () {
                              final value = _controller.text.trim();
                              if (value.isEmpty) {
                                return;
                              }
                              context.read<ChatCubit>().sendMessage(
                                lecture: widget.lecture,
                                message: value,
                              );
                              _controller.clear();
                            },
                      child: Text(
                        state.status == ChatStatus.sending ? '...' : 'إرسال',
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
