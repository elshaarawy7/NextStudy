import '../../domain/entities/analysis_bundle.dart';
import '../../domain/entities/lecture.dart';

class LectureModel extends Lecture {
  const LectureModel({
    required super.id,
    required super.title,
    required super.course,
    required super.fileName,
    required super.previewText,
    required super.extractedText,
    required super.uploadedAt,
    super.filePath,
    super.analysis,
  });

  LectureModel copyWithAnalysis(AnalysisBundle analysis) {
    return LectureModel(
      id: id,
      title: title,
      course: course,
      fileName: fileName,
      previewText: previewText,
      extractedText: extractedText,
      uploadedAt: uploadedAt,
      filePath: filePath,
      analysis: analysis,
    );
  }
}
