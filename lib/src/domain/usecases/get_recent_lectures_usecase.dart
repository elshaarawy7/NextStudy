import '../entities/lecture.dart';
import '../repositories/lecture_repository.dart';

class GetRecentLecturesUseCase {
  const GetRecentLecturesUseCase(this._repository);

  final LectureRepository _repository;

  Future<List<Lecture>> call() => _repository.getRecentLectures();
}
