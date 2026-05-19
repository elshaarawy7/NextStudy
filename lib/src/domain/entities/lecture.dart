import 'package:equatable/equatable.dart';

import 'analysis_bundle.dart';

class Lecture extends Equatable {
  const Lecture({
    required this.id,
    required this.title,
    required this.course,
    required this.fileName,
    required this.previewText,
    required this.extractedText,
    required this.uploadedAt,
    required this.pageCount,
    this.filePath,
    this.analysis,
  });

  final String id;
  final String title;
  final String course;
  final String fileName;
  final String previewText;
  final String extractedText;
  final DateTime uploadedAt;
  final int pageCount;
  final String? filePath;
  final AnalysisBundle? analysis;

  Lecture copyWith({
    String? id,
    String? title,
    String? course,
    String? fileName,
    String? previewText,
    String? extractedText,
    DateTime? uploadedAt,
    int? pageCount,
    String? filePath,
    AnalysisBundle? analysis,
  }) {
    return Lecture(
      id: id ?? this.id,
      title: title ?? this.title,
      course: course ?? this.course,
      fileName: fileName ?? this.fileName,
      previewText: previewText ?? this.previewText,
      extractedText: extractedText ?? this.extractedText,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      pageCount: pageCount ?? this.pageCount,
      filePath: filePath ?? this.filePath,
      analysis: analysis ?? this.analysis,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    course,
    fileName,
    previewText,
    extractedText,
    uploadedAt,
    pageCount,
    filePath,
    analysis,
  ];
}
