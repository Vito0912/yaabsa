import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaabsa/util/globals.dart' show downloadHandler;

part 'download_task_provider.g.dart';

@riverpod
Stream<bool> downloadInProgressForItem(Ref ref, String itemId, {String? episodeId}) {
  return downloadHandler
      .taskQueueStreamForItem(itemId, episodeId: episodeId)
      .map((tasks) => tasks.isNotEmpty)
      .distinct();
}
