import 'package:buchshelfly/api/routes/abs_api.dart';
import 'package:buchshelfly/components/player/common/control_button.dart';
import 'package:buchshelfly/components/player/common/jump_button.dart';
import 'package:buchshelfly/components/player/common/seek_bar.dart';
import 'package:buchshelfly/components/player/common/skip_button.dart';
import 'package:buchshelfly/components/player/common/sleep_timer_button.dart';
import 'package:buchshelfly/components/player/common/speed_slider.dart';
import 'package:buchshelfly/components/player/common/stop_button.dart';
import 'package:buchshelfly/components/player/common/volume_slider.dart';
import 'package:buchshelfly/models/internal_media.dart';
import 'package:buchshelfly/provider/core/user_providers.dart';
import 'package:buchshelfly/screens/player/chapter.dart';
import 'package:buchshelfly/util/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Player extends StatelessWidget {
  Player({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Player'), actions: [StopButton()]),
      body: Consumer(
        builder: (BuildContext context, ref, child) {
          final ABSApi? api = ref.watch(absApiProvider);
          return StreamBuilder<InternalMedia?>(
            stream: audioHandler.mediaItemStream.stream,
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.connectionState == ConnectionState.waiting || asyncSnapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              }

              final InternalMedia media = asyncSnapshot.data!;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 200,
                            height: 200,
                            margin: const EdgeInsets.only(bottom: 16.0),
                            child:
                                api != null
                                    ? FutureBuilder(
                                      future: Future.value(api.getLibraryItemApi().getLibraryItemCover(media.itemId)),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return ClipRRect(
                                            borderRadius: BorderRadius.circular(8.0),
                                            child: snapshot.data!,
                                          );
                                        }
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          child: const Icon(Icons.music_note, size: 50, color: Colors.grey),
                                        );
                                      },
                                    )
                                    : Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: const Icon(Icons.music_note, size: 50, color: Colors.grey),
                                    ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: [
                                Text(
                                  media.title,
                                  style: Theme.of(context).textTheme.headlineSmall,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  media.author ?? 'Unknown Author',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24.0),

                          const Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: VolumeSlider()),

                          const SizedBox(height: 16.0),

                          const Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: SpeedSlider()),

                          const SizedBox(height: 16.0),

                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SkipButton(previous: true),
                              SizedBox(width: 8.0),
                              JumpButton(rewind: true),
                              SizedBox(width: 8.0),
                              ControlButton(),
                              SizedBox(width: 8.0),
                              JumpButton(rewind: false),
                              SizedBox(width: 8.0),
                              SkipButton(previous: false),
                            ],
                          ),

                          const SizedBox(height: 16.0),

                          const Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: SeekBar()),

                          const Row(mainAxisAlignment: MainAxisAlignment.center, children: [SleepTimerButton()]),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 300, child: const ChapterView()),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
