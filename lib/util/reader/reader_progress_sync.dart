import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/json/value_parsers.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/provider/core/server_reachability_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/setting_key.dart';

typedef _ReaderCheckpoint = ({String location, double progress, int updatedAt});

class ReaderProgressSync {
  ReaderProgressSync(this._container) {
    _apiSubscription = _container.listen(absApiProvider, (_, next) {
      if (next != null) {
        unawaited(flush());
      }
    });
    _reachabilitySubscription = _container.listen(serverReachabilityProvider, (_, reachable) {
      if (reachable) {
        unawaited(flush());
      }
    });
    _retryTimer = Timer.periodic(const Duration(seconds: 30), (_) => unawaited(flush()));
    unawaited(flush());
  }

  final ProviderContainer _container;
  final Map<String, Map<String, _ReaderCheckpoint>> _pending = {};
  late final ProviderSubscription<ABSApi?> _apiSubscription;
  late final ProviderSubscription<bool> _reachabilitySubscription;
  late final Timer _retryTimer;
  Timer? _uploadTimer;
  Future<void> _storageQueue = Future.value();
  Future<void>? _upload;
  CancelToken? _uploadCancellation;
  bool _disposed = false;

  Future<void> _serialize(Future<void> Function() operation) {
    final result = _storageQueue.then((_) => operation());
    _storageQueue = result.catchError((Object error, StackTrace stack) {
      logger('Could not save ebook progress: $error\n$stack', tag: 'ReaderProgressSync', level: InfoLevel.warning);
    });
    return result;
  }

  Future<Map<String, _ReaderCheckpoint>> _load(String userId) async {
    final cached = _pending[userId];
    if (cached != null) {
      return cached;
    }

    final stored = await _container.read(appDatabaseProvider).getUserSetting(userId, SettingKeys.readerPendingProgress);
    final entries = <String, _ReaderCheckpoint>{};
    Object? decoded;
    try {
      decoded = stored == null ? null : jsonDecode(stored.value);
    } on FormatException catch (error) {
      logger('Could not read pending ebook progress: $error', tag: 'ReaderProgressSync', level: InfoLevel.warning);
    }

    if (decoded is Map) {
      for (final entry in decoded.entries) {
        final value = entry.value;
        if (entry.key is! String || value is! Map) {
          continue;
        }

        final location = jsonStringFromDynamic(value['location']);
        final progress = jsonDoubleFromDynamic(value['progress']);
        final updatedAt = jsonIntFromDynamic(value['updatedAt']);
        if (location == null || location.isEmpty || progress == null || !progress.isFinite || updatedAt == null) {
          continue;
        }

        entries[entry.key as String] = (location: location, progress: progress.clamp(0, 1), updatedAt: updatedAt);
      }
    }

    _pending[userId] = entries;
    return entries;
  }

  Future<void> _persist(String userId, Map<String, _ReaderCheckpoint> entries) {
    return _container
        .read(appDatabaseProvider)
        .setUserSetting(
          userId,
          SettingKeys.readerPendingProgress,
          jsonEncode({
            for (final entry in entries.entries)
              entry.key: {
                'location': entry.value.location,
                'progress': entry.value.progress,
                'updatedAt': entry.value.updatedAt,
              },
          }),
        );
  }

  Future<void> save({
    required String userId,
    required String itemId,
    required String location,
    required double progress,
  }) async {
    if (_disposed || userId.isEmpty || location.isEmpty || !progress.isFinite) {
      return;
    }

    final checkpoint = (
      location: location,
      progress: progress.clamp(0.0, 1.0),
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    await _serialize(() async {
      final entries = await _load(userId);
      entries[itemId] = checkpoint;
      await _persist(userId, entries);
      _applyLocal(userId, itemId, checkpoint);
    });

    if (!_disposed) {
      _uploadTimer ??= Timer(const Duration(seconds: 10), () {
        _uploadTimer = null;
        unawaited(flush());
      });
    }
  }

  void _applyLocal(String userId, String itemId, _ReaderCheckpoint checkpoint) {
    final progress = _container.read(mediaProgressProvider.notifier);
    if (progress.progressForKey(itemId)?.userId == userId) {
      progress.applyLocalEbookProgressUpdate(
        libraryItemId: itemId,
        ebookLocation: checkpoint.location,
        ebookProgress: checkpoint.progress,
      );
    }
  }

  Future<String?> pendingLocation(String userId, String itemId) async {
    String? location;
    await _serialize(() async {
      location = (await _load(userId))[itemId]?.location;
    });
    return location;
  }

  Future<void> flush() {
    if (_disposed) {
      return Future.value();
    }

    return _upload ??= _flush()
        .catchError((Object error, StackTrace stack) {
          if (error is DioException && CancelToken.isCancel(error)) {
            return;
          }

          logger(
            'Could not upload ebook progress: $error\n$stack',
            tag: 'ReaderProgressSync',
            level: InfoLevel.warning,
          );
        })
        .whenComplete(() {
          _upload = null;
          _uploadCancellation = null;
        });
  }

  Future<void> _flush() async {
    final api = _container.read(absApiProvider);
    final userId = api?.user?.id;
    if (api == null || userId == null) {
      return;
    }

    final cancellation = CancelToken();
    _uploadCancellation = cancellation;

    var snapshot = <String, _ReaderCheckpoint>{};
    await _serialize(() async {
      snapshot = Map.of(await _load(userId));
    });

    for (final entry in snapshot.entries) {
      if (_disposed ||
          !identical(_container.read(absApiProvider), api) ||
          !_container.read(serverReachabilityProvider)) {
        return;
      }

      await api.getMeApi().updateBookProgress(
        entry.key,
        epubCfi: entry.value.location,
        progress: entry.value.progress,
        cancelToken: cancellation,
      );

      await _serialize(() async {
        final entries = await _load(userId);
        if (entries[entry.key] == entry.value) {
          entries.remove(entry.key);
          await _persist(userId, entries);
        }
      });
    }
  }

  Future<void> dispose() async {
    _disposed = true;
    _retryTimer.cancel();
    _uploadTimer?.cancel();
    _apiSubscription.close();
    _reachabilitySubscription.close();
    _uploadCancellation?.cancel();
    await _upload;
    await _storageQueue;
  }
}
