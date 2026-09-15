import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/database/app_database.dart';

StoredSyncsCompanion _sync({
  required double position,
  required double listened,
  required DateTime updatedAt,
  required String progress,
}) {
  return StoredSyncsCompanion(
    sessionId: const Value('session'),
    itemId: const Value('item'),
    userId: const Value('user'),
    episodeId: const Value<String?>(null),
    currentTime: Value(position),
    timeListened: Value(listened),
    duration: const Value(300),
    sessionLocal: const Value(false),
    lastUpdated: Value(updatedAt),
    mediaProgress: Value(progress),
  );
}

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.connect(DatabaseConnection(NativeDatabase.memory()));
  });

  tearDown(() async {
    await db.close();
  });

  test('unchanged replay snapshot is deleted after acknowledgement', () async {
    final t0 = DateTime.utc(2026, 9, 14, 8);
    await db.addOrUpdateSync(_sync(position: 30, listened: 12, updatedAt: t0, progress: 'old'));
    final snapshot = (await db.getSync('session'))!;

    expect(await db.acknowledgeReplayedSync(snapshot), isTrue);
    expect(await db.getSync('session'), isNull);
  });

  test('concurrent zero-time correction survives replay acknowledgement', () async {
    final t0 = DateTime.utc(2026, 9, 14, 8);
    final t1 = t0.add(const Duration(seconds: 1));
    await db.addOrUpdateSync(_sync(position: 30, listened: 12, updatedAt: t0, progress: 'old'));
    final snapshot = (await db.getSync('session'))!;

    await db.addOrUpdateSync(_sync(position: 90, listened: 0, updatedAt: t1, progress: 'new'));
    expect(await db.acknowledgeReplayedSync(snapshot), isTrue);

    final remaining = await db.getSync('session');
    expect(remaining, isNotNull);
    expect(remaining!.currentTime, 90);
    expect(remaining.timeListened, 0);
    expect(remaining.mediaProgress, 'new');
    expect(remaining.lastUpdated.millisecondsSinceEpoch, t1.millisecondsSinceEpoch);
  });

  test('concurrent new listening is retained without replaying old delta twice', () async {
    final t0 = DateTime.utc(2026, 9, 14, 8);
    final t1 = t0.add(const Duration(seconds: 1));
    await db.addOrUpdateSync(_sync(position: 30, listened: 12, updatedAt: t0, progress: 'old'));
    final snapshot = (await db.getSync('session'))!;

    await db.addOrUpdateSync(_sync(position: 95, listened: 5, updatedAt: t1, progress: 'new'));
    expect(await db.acknowledgeReplayedSync(snapshot), isTrue);

    final remaining = await db.getSync('session');
    expect(remaining, isNotNull);
    expect(remaining!.currentTime, 95);
    expect(remaining.timeListened, 5);
    expect(remaining.mediaProgress, 'new');
  });
}
