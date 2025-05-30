import 'package:buchshelfly/database/app_database.dart';
import 'package:buchshelfly/models/internal_media.dart';
import 'package:buchshelfly/provider/core/user_providers.dart';
import 'package:buchshelfly/util/extensions.dart';
import 'package:buchshelfly/util/globals.dart';
import 'package:drift/drift.dart';

enum PlayerHistoryType { sync, syncOffline, play, pause, stop, seek }

class PlayerHistoryHandler {
  static addPlayerHistory(PlayerHistoryType type) async {
    if (audioHandler.currentMediaItem == null) {
      return;
    }
    final InternalMedia currentMedia = audioHandler.currentMediaItem!;

    final db = containerRef.read(appDatabaseProvider);
    await db.addPlayerHistory(
      PlayerHistoryCompanion(
        itemId: Value(currentMedia.itemId),
        userId: Value(containerRef.read(currentUserProvider).value!.id),
        episodeId: currentMedia.episodeId != null ? Value(currentMedia.episodeId) : const Value.absent(),
        currentTime: Value(audioHandler.position.inSecondsPrecise),
        type: Value(type.name),
      ),
    );
  }
}
