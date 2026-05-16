import '../../domain/entities/lecture.dart';
import '../../domain/repositories/lecture_repository.dart';
import '../datasources/mock_lecture_data_source.dart';

class LectureRepositoryImpl implements LectureRepository {
  const LectureRepositoryImpl({required MockLectureDataSource dataSource})
    : _dataSource = dataSource;

  final MockLectureDataSource _dataSource;

  @override
  Future<List<Lecture>> getRecentLectures() => _dataSource.getRecentLectures();

  @override
  Future<Lecture> uploadLecture() => _dataSource.uploadLecture();
}
