import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/util/extensions.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:flutter/material.dart';

class ChapterView extends StatelessWidget {
  const ChapterView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: audioHandler.mediaItemStream,
      builder: (context, asyncSnapshot) {
        if (!asyncSnapshot.hasData || asyncSnapshot.data == null || asyncSnapshot.data!.chapters == null) {
          return const Center(child: Text('No chapter data available'));
        }
        final InternalMedia mediaItem = asyncSnapshot.data!;
        return StreamBuilder(
          stream: audioHandler.chapterStream,
          builder: (context, currentChapterSnapshot) {
            if (!currentChapterSnapshot.hasData || currentChapterSnapshot.data == null) {
              return const Center(child: Text('Loading chapters...'));
            }
            final currentChapter = currentChapterSnapshot.data!;
            final chapters = mediaItem.chapters!;
            final currentIndex = chapters.indexOf(currentChapter);

            final scrollController = ScrollController();

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (currentIndex >= 0 && scrollController.hasClients) {
                scrollController.animateTo(
                  currentIndex * 60.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            });

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: ListView.builder(
                controller: scrollController,
                itemCount: chapters.length,
                itemBuilder: (context, index) {
                  final chapter = chapters[index];
                  return ListTile(
                    title: Text(chapter.title),
                    subtitle: Text(
                      '${chapter.start.toDuration.toHhMmString()} - ${chapter.end.toDuration.toHhMmString()}',
                    ),
                    selected: chapter == currentChapter,
                    selectedTileColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                    onTap: () {
                      audioHandler.seek(chapter.start.toDuration);
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
