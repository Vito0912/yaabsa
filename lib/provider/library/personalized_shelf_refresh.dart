import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/core/server_reachability_provider.dart';
import 'package:yaabsa/provider/library/personalized_library_provider.dart';
import 'package:yaabsa/util/interceptors/cache_interceptor.dart';
import 'package:yaabsa/util/logger.dart';

const Duration _personalizedShelfRefreshMinInterval = Duration(seconds: 30);
final Map<String, DateTime> _lastPersonalizedShelfRefreshByKey = <String, DateTime>{};
final Set<String> _personalizedShelfRefreshInFlight = <String>{};

Future<bool> refreshPersonalizedShelfForCompletedItem({
  required ProviderContainer container,
  required String itemId,
  String? preferredLibraryId,
  required String sourceTag,
  String reason = 'completed playback',
}) async {
  if (!container.read(serverReachabilityProvider)) {
    logger(
      'Skipping shelf refresh after $reason for $itemId because server is unreachable.',
      tag: sourceTag,
      level: InfoLevel.debug,
    );
    return false;
  }

  String? resolvedLibraryId = preferredLibraryId?.trim();
  if (resolvedLibraryId != null && resolvedLibraryId.isEmpty) {
    resolvedLibraryId = null;
  }

  resolvedLibraryId ??= container.read(selectedLibraryProvider)?.id;

  if (resolvedLibraryId == null || resolvedLibraryId.isEmpty) {
    try {
      final item = await container.read(libraryItemProvider(itemId).future);
      final itemLibraryId = item.libraryId?.trim();
      if (itemLibraryId != null && itemLibraryId.isNotEmpty) {
        resolvedLibraryId = itemLibraryId;
      }
    } catch (_) {}
  }

  if (resolvedLibraryId == null || resolvedLibraryId.isEmpty) {
    logger(
      'Skipping shelf refresh after $reason for $itemId: library id unavailable.',
      tag: sourceTag,
      level: InfoLevel.debug,
    );
    return false;
  }

  final refreshKey = '$resolvedLibraryId:$itemId';
  final now = DateTime.now();
  final lastRefreshAt = _lastPersonalizedShelfRefreshByKey[refreshKey];
  if (lastRefreshAt != null && now.difference(lastRefreshAt) < _personalizedShelfRefreshMinInterval) {
    logger(
      'Skipping shelf refresh after $reason for $itemId in library $resolvedLibraryId: throttled.',
      tag: sourceTag,
      level: InfoLevel.debug,
    );
    return false;
  }

  if (!_personalizedShelfRefreshInFlight.add(refreshKey)) {
    logger(
      'Skipping shelf refresh after $reason for $itemId in library $resolvedLibraryId: already in flight.',
      tag: sourceTag,
      level: InfoLevel.debug,
    );
    return false;
  }

  try {
    await invalidateCachedLibraryItemEntries(container: container, itemId: itemId, libraryId: resolvedLibraryId);
    await container
        .read(personalizedLibraryProvider(resolvedLibraryId).notifier)
        .refresh(resolvedLibraryId, bypassCache: true);
    _lastPersonalizedShelfRefreshByKey[refreshKey] = DateTime.now();
    logger(
      'Refreshed personalized shelf after $reason for $itemId in library $resolvedLibraryId.',
      tag: sourceTag,
      level: InfoLevel.debug,
    );
    return true;
  } catch (error, stackTrace) {
    logger(
      'Failed to refresh personalized shelf after $reason for $itemId: $error\n$stackTrace',
      tag: sourceTag,
      level: InfoLevel.warning,
    );
    return false;
  } finally {
    _personalizedShelfRefreshInFlight.remove(refreshKey);
  }
}
