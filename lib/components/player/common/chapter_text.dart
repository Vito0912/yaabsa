import 'package:buchshelfly/models/internal_media.dart';
import 'package:buchshelfly/util/globals.dart';
import 'package:flutter/material.dart';

class ChapterText extends StatelessWidget {
  const ChapterText({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<InternalChapter?> chapterStream = audioHandler.chapterStream;

    return StreamBuilder<InternalChapter?>(
      stream: chapterStream,
      builder: (BuildContext context, AsyncSnapshot<InternalChapter?> snapshot) {
        final InternalChapter? chapter = snapshot.data;

        if (chapter == null) {
          return const SizedBox.shrink();
        }

        return Text(chapter.title, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold));
      },
    );
  }
}
