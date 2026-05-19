class ProcessedPdfText {
  const ProcessedPdfText({
    required this.cleanedText,
    required this.previewText,
    required this.chunks,
    required this.analysisPrompt,
  });

  final String cleanedText;
  final String previewText;
  final List<String> chunks;
  final String analysisPrompt;
}

class PdfTextProcessor {
  const PdfTextProcessor._();

  static final RegExp _whitespacePattern = RegExp(r'\s+');
  static final RegExp _pageNumberPattern = RegExp(
    r'^(page\s*\d+|\d+\s*/\s*\d+|\d+)$',
    caseSensitive: false,
  );
  static final RegExp _decorativePattern = RegExp(r'^[\W_]{3,}$');
  static final List<RegExp> _irrelevantPatterns = [
    RegExp(
      r'\b(dr|prof|professor|lecturer|instructor)\b',
      caseSensitive: false,
    ),
    RegExp(
      r'\b(university|academy|faculty|department|college)\b',
      caseSensitive: false,
    ),
    RegExp(
      r'\b(email|phone|mobile|office|website|www\.|http)\b',
      caseSensitive: false,
    ),
    RegExp(r'\b(course code|semester|academic year)\b', caseSensitive: false),
    RegExp(
      r'(قسم|كلية|جامعة|أكاديمية|محاضر|دكتور|أ\.د|هاتف|بريد)',
      caseSensitive: false,
    ),
  ];

  static ProcessedPdfText prepare({
    required String rawText,
    required String lectureTitle,
  }) {
    final normalizedLines = rawText
        .replaceAll('\r', '\n')
        .split('\n')
        .map(_normalizeLine)
        .where((line) => line.isNotEmpty)
        .toList();

    final repeatedShortLines = <String, int>{};
    for (final line in normalizedLines) {
      if (line.length <= 90) {
        repeatedShortLines[line] = (repeatedShortLines[line] ?? 0) + 1;
      }
    }

    final filteredLines = normalizedLines.where((line) {
      if (_isIrrelevantLine(line)) {
        return false;
      }
      final isRepeatedTemplate =
          (repeatedShortLines[line] ?? 0) > 1 && line.length <= 90;
      return !isRepeatedTemplate;
    }).toList();

    final candidateSentences = _splitIntoSentences(filteredLines.join(' '));
    final educationalSentences = <String>[];
    final seenSentences = <String>{};

    for (final sentence in candidateSentences) {
      final cleanedSentence = _normalizeSentence(sentence);
      if (cleanedSentence.isEmpty || _isIrrelevantSentence(cleanedSentence)) {
        continue;
      }
      final key = cleanedSentence.toLowerCase();
      if (seenSentences.add(key)) {
        educationalSentences.add(cleanedSentence);
      }
    }

    final fallbackText = filteredLines.join(' ').trim();
    final cleanedText = educationalSentences.isEmpty
        ? fallbackText
        : educationalSentences.join('. ');
    final finalText = cleanedText.isEmpty
        ? 'Lecture content could not be cleaned into educational text.'
        : cleanedText;

    return ProcessedPdfText(
      cleanedText: finalText,
      previewText: _buildPreview(finalText),
      chunks: _chunkText(
        educationalSentences.isEmpty ? [finalText] : educationalSentences,
      ),
      analysisPrompt: _buildAnalysisPrompt(
        lectureTitle: lectureTitle,
        cleanedText: finalText,
      ),
    );
  }

  static String _normalizeLine(String line) {
    return line.replaceAll(_whitespacePattern, ' ').trim();
  }

  static bool _isIrrelevantLine(String line) {
    if (line.isEmpty ||
        _pageNumberPattern.hasMatch(line) ||
        _decorativePattern.hasMatch(line)) {
      return true;
    }

    final lowered = line.toLowerCase();
    if (lowered.startsWith('page ') ||
        lowered.startsWith('copyright') ||
        lowered.startsWith('all rights reserved')) {
      return true;
    }

    for (final pattern in _irrelevantPatterns) {
      if (pattern.hasMatch(line)) {
        return true;
      }
    }

    final shortTokenCount = line.split(' ').length <= 3;
    final mostlyNumbers = RegExp(r'^[\d\s\-/.:]+$').hasMatch(line);
    return shortTokenCount && mostlyNumbers;
  }

  static List<String> _splitIntoSentences(String text) {
    return text
        .split(RegExp(r'(?<=[.!?؟:;])\s+'))
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList();
  }

  static String _normalizeSentence(String sentence) {
    var value = sentence.replaceAll(_whitespacePattern, ' ').trim();
    value = value.replaceAll(RegExp(r'^[\-\u2022•\s]+'), '');
    value = value.replaceAll(RegExp(r'[\-\u2022•\s]+$'), '');
    return value;
  }

  static bool _isIrrelevantSentence(String sentence) {
    if (sentence.length < 25) {
      return true;
    }

    final lowered = sentence.toLowerCase();
    if (lowered.contains('copyright') ||
        lowered.contains('table of contents') ||
        lowered.contains('contents')) {
      return true;
    }

    for (final pattern in _irrelevantPatterns) {
      if (pattern.hasMatch(sentence)) {
        return true;
      }
    }

    final alphaChars = sentence.replaceAll(
      RegExp(r'[^A-Za-z\u0600-\u06FF]'),
      '',
    );
    if (alphaChars.length < 12) {
      return true;
    }

    return false;
  }

  static List<String> _chunkText(List<String> sentences) {
    const maxChunkLength = 700;
    final chunks = <String>[];
    final buffer = StringBuffer();

    for (final sentence in sentences) {
      final part = sentence.endsWith('.') || sentence.endsWith('؟')
          ? sentence
          : '$sentence.';

      if (buffer.isNotEmpty &&
          buffer.length + part.length + 1 > maxChunkLength) {
        chunks.add(buffer.toString().trim());
        buffer.clear();
      }

      if (part.length > maxChunkLength) {
        chunks.add(part);
        continue;
      }

      if (buffer.isNotEmpty) {
        buffer.write(' ');
      }
      buffer.write(part);
    }

    if (buffer.isNotEmpty) {
      chunks.add(buffer.toString().trim());
    }

    return chunks.isEmpty ? sentences.take(1).toList() : chunks;
  }

  static String _buildPreview(String text) {
    if (text.length <= 120) {
      return text;
    }
    return '${text.substring(0, 117)}...';
  }

  static String _buildAnalysisPrompt({
    required String lectureTitle,
    required String cleanedText,
  }) {
    return '''
You are an educational assistant.
Analyze the lecture content and create a simple Arabic step-by-step explanation for students.
Ignore lecturer names, institution names, headers, metadata, and repeated text.
Only explain the actual educational concepts from the lecture.

Lecture title: $lectureTitle
Lecture content:
$cleanedText
''';
  }
}
