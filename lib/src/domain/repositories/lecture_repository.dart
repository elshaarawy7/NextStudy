import '../entities/lecture.dart';

abstract class LectureRepository {
  Future<List<Lecture>> getRecentLectures();
  Future<Lecture> uploadLecture();
}
