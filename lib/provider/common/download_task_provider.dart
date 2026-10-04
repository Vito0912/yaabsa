import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaabsa/provider/common/item_download_status_provider.dart';

part 'download_task_provider.g.dart';

@riverpod
bool downloadInProgressForItem(Ref ref, String itemId, {String? episodeId}) {
  return ref.watch(
    itemDownloadStatusesProvider.select((value) => value.value?.containsKey((itemId, episodeId)) ?? false),
  );
}
