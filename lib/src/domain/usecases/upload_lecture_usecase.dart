import '../entities/lecture.dart';
import '../repositories/lecture_repository.dart';

class UploadLectureUseCase {
  const UploadLectureUseCase(this._repository);

  final LectureRepository _repository;

  Future<Lecture> call() => _repository.uploadLecture();
}
