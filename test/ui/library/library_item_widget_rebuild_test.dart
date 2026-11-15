import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/components/common/library_item_widget.dart';
import 'package:yaabsa/provider/common/item_download_status_provider.dart';
import 'package:yaabsa/provider/common/stored_downloads_provider.dart';
import 'package:yaabsa/util/audio_handler/bg_audio_handler.dart';
import 'package:yaabsa/util/globals.dart' as globals;
import 'package:yaabsa/models/internal_media.dart';

void main() {
  testWidgets('playback state updates do not rebuild a library card title', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final audio = _LibraryGridTestAudioHandler();
    globals.audioHandler = audio;
    addTearDown(audio.dispose);

    const item = LibraryItem(id: 'item-1', ino: 'item-1', media: null, libraryFiles: null);
    final api = ABSApi(
      dio: Dio(BaseOptions(baseUrl: 'http://localhost')),
      interceptors: [],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          itemDownloadStatusesProvider.overrideWith((ref) => const Stream.empty()),
          downloadAvailabilityProvider.overrideWith((ref) => const Stream.empty()),
        ],
        child: MaterialApp(home: Scaffold(body: LibraryItemWidget(item, api, showProgress: false))),
      ),
    );
    await tester.pump();

    final titleBeforePlaybackUpdate = tester.widget<Text>(find.text('Untitled'));

    audio.playerStates.add(PlayerState(true, ProcessingState.ready));
    await tester.pump();

    final titleAfterPlaybackUpdate = tester.widget<Text>(find.text('Untitled'));
    expect(identical(titleAfterPlaybackUpdate, titleBeforePlaybackUpdate), isTrue);
    expect(tester.takeException(), isNull);
  });
}

class _LibraryGridTestAudioHandler implements BGAudioHandler {
  final StreamController<PlayerState> playerStates = StreamController<PlayerState>.broadcast();
  final StreamController<bool> queueTransitions = StreamController<bool>.broadcast();

  @override
  InternalMedia? get currentMediaItem => null;

  @override
  Stream<PlayerState> get playerControlStateStream => playerStates.stream;

  @override
  PlayerState get playerControlState => PlayerState(false, ProcessingState.idle);

  @override
  Stream<bool> get queueTransitionLoadingStream => queueTransitions.stream;

  @override
  bool get queueTransitionLoading => false;

  @override
  bool isQueueTransitionForItem(String itemId, {String? episodeId}) => false;

  @override
  Future<void> dispose() async {
    await playerStates.close();
    await queueTransitions.close();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
