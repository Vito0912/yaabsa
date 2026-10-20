class ReaderSpeechChunk {
  const ReaderSpeechChunk({required this.text, required this.firstSentence, required this.boundaries});

  final String text;
  final int firstSentence;
  final List<({int offset, int sentence})> boundaries;

  int sentenceAt(int offset) {
    return boundaries.lastWhere((boundary) => boundary.offset <= offset, orElse: () => boundaries.first).sentence;
  }

  static List<ReaderSpeechChunk> fromSentences(List<Map<String, String>> sentences, {int startIndex = 0}) {
    final chunks = <ReaderSpeechChunk>[];
    var text = StringBuffer();
    var boundaries = <({int offset, int sentence})>[];
    var paragraphBreak = false;

    void flush() {
      if (boundaries.isEmpty) {
        return;
      }

      chunks.add(
        ReaderSpeechChunk(text: text.toString(), firstSentence: boundaries.first.sentence, boundaries: boundaries),
      );
      text = StringBuffer();
      boundaries = [];
    }

    for (var index = startIndex; index < sentences.length; index++) {
      final sentence = sentences[index]['text']?.trim() ?? '';

      if (sentence.isEmpty) {
        continue;
      }

      if (text.length + sentence.length + (text.isEmpty ? 0 : 2) > 900) {
        flush();
      }

      for (var offset = 0; offset < sentence.length;) {
        var end = (offset + 900).clamp(0, sentence.length);

        if (end < sentence.length) {
          final space = sentence.lastIndexOf(' ', end);

          if (space > offset) {
            end = space;
          }

          if (end > offset && sentence.codeUnitAt(end - 1) >= 0xD800 && sentence.codeUnitAt(end - 1) <= 0xDBFF) {
            end--;
          }
        }

        if (text.isNotEmpty) {
          text.write(paragraphBreak ? '\n\n' : ' ');
        }

        boundaries.add((offset: text.length, sentence: index));
        text.write(sentence.substring(offset, end).trim());
        offset = end;

        if (offset < sentence.length) {
          flush();
        }
      }

      paragraphBreak = sentences[index]['breakAfter'] == 'true';
    }

    flush();

    return chunks;
  }
}
