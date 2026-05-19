import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:uuid/uuid.dart';

import '../models/analysis_bundle_model.dart';
import '../models/lecture_model.dart';

class MockLectureDataSource {
  final Uuid _uuid = const Uuid();
  final List<LectureModel> _lectures = [
    LectureModel(
      id: 'seed-1',
      title: 'Cellular Respiration',
      course: 'Biology 101',
      fileName: 'biology_lecture.pdf',
      previewText:
          'ATP production, glycolysis, Krebs cycle, and electron transport chain.',
      extractedText:
          'Cellular respiration is the process cells use to convert glucose into ATP. Glycolysis happens in the cytoplasm. The Krebs cycle continues energy extraction. The electron transport chain produces most ATP.',
      uploadedAt: DateTime.now().subtract(const Duration(hours: 10)),
      pageCount: 12,
      analysis: AnalysisBundleModel.fromText(
        'Cellular respiration is the process cells use to convert glucose into ATP. Glycolysis happens in the cytoplasm. The Krebs cycle continues energy extraction. The electron transport chain produces most ATP.',
        'Cellular Respiration',
      ),
    ),
  ];

  Future<List<LectureModel>> getRecentLectures() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return List<LectureModel>.from(_lectures.reversed);
  }

  Future<LectureModel> uploadLecture() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      throw Exception('No PDF selected.');
    }

    final file = result.files.single;
    final bytes = file.bytes;
    if (bytes == null) {
      throw Exception('Unable to read the selected PDF file.');
    }

    final pdfData = _extractPdfData(bytes);
    final title = file.name.replaceAll('.pdf', '').replaceAll('_', ' ');
    final lecture = LectureModel(
      id: _uuid.v4(),
      title: _toTitleCase(title),
      course: 'Uploaded lecture',
      fileName: file.name,
      previewText: _previewOf(pdfData.text),
      extractedText: pdfData.text,
      uploadedAt: DateTime.now(),
      pageCount: pdfData.pageCount,
      filePath: file.path,
    );

    _lectures.add(lecture);
    return lecture;
  }

  ({String text, int pageCount}) _extractPdfData(Uint8List bytes) {
    final document = PdfDocument(inputBytes: bytes);
    final pageCount = document.pages.count;
    final extractor = PdfTextExtractor(document);
    final buffer = StringBuffer(extractor.extractText());
    document.dispose();

    final raw = buffer.toString().replaceAll(RegExp(r'\s+'), ' ').trim();
    if (raw.isEmpty) {
      return (
        text:
            'This PDF was uploaded successfully, but no extractable text was found. Use OCR-ready lecture notes for richer AI support.',
        pageCount: pageCount,
      );
    }
    return (text: raw, pageCount: pageCount);
  }

  String _previewOf(String text) {
    if (text.length <= 120) {
      return text;
    }
    return '${text.substring(0, 117)}...';
  }

  String _toTitleCase(String value) {
    return value
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map(
          (part) =>
              '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}
