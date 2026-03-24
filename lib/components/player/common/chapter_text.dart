import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:flutter/material.dart';

class ChapterText extends StatelessWidget {
  const ChapterText({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<InternalMedia?>(
      stream: audioHandler.mediaItemStream,
      builder: (context, mediaSnapshot) {
        final mediaTitle = mediaSnapshot.data?.title;

        return StreamBuilder<InternalChapter?>(
          stream: audioHandler.chapterStream,
          builder:
              (
                BuildContext context,
                AsyncSnapshot<InternalChapter?> chapterSnapshot,
              ) {
                final title = chapterSnapshot.data?.title ?? mediaTitle;
                final text = (title == null || title.isEmpty) ? 'Now playing' : title;

                return Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
        );
      },
    );
  }
}
