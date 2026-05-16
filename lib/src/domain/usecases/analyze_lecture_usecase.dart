import '../entities/analysis_bundle.dart';
import '../entities/lecture.dart';
import '../repositories/ai_repository.dart';

class AnalyzeLectureUseCase {
  const AnalyzeLectureUseCase(this._repository);

  final AiRepository _repository;

  Future<AnalysisBundle> call(Lecture lecture) {
    return _repository.analyzeLecture(lecture);
  }
}
