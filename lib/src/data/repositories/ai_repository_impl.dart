import '../../domain/entities/analysis_bundle.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/lecture.dart';
import '../../domain/repositories/ai_repository.dart';
import '../datasources/mock_ai_data_source.dart';

class AiRepositoryImpl implements AiRepository {
  const AiRepositoryImpl({required MockAiDataSource dataSource})
    : _dataSource = dataSource;

  final MockAiDataSource _dataSource;

  @override
  Future<AnalysisBundle> analyzeLecture(Lecture lecture) {
    return _dataSource.analyzeLecture(lecture);
  }

  @override
  Future<ChatMessage> sendChatMessage({
    required Lecture lecture,
    required String message,
    required List<ChatMessage> history,
  }) {
    return _dataSource.sendChatMessage(
      lecture: lecture,
      message: message,
      history: history,
    );
  }
}
