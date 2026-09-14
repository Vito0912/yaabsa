import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/home_navigation_preferences.dart';
import 'package:yaabsa/util/personalized_shelf_preferences.dart';
import 'package:yaabsa/util/pinned_shelf_preferences.dart';
import 'package:yaabsa/util/setting_key.dart';

part 'pinned_shelf_provider.g.dart';

class PinnedShelfUndo {
  const PinnedShelfUndo({
    required this.userId,
    required this.mediaType,
    required this.libraryId,
    required this.itemId,
    required this.episodeId,
    required this.wasPinned,
  });

  final String userId;
  final HomeLibraryMediaType mediaType;
  final String libraryId;
  final String itemId;
  final String? episodeId;
  final bool wasPinned;
}

@Riverpod(keepAlive: true)
class PinnedShelfController extends _$PinnedShelfController {
  @override
  Map<String, List<PinnedShelfEntry>> build() {
    final userId = ref.watch(currentUserProvider).value?.id;
    if (userId == null) {
      return const <String, List<PinnedShelfEntry>>{};
    }

    final rawValue = ref
        .read(settingsManagerProvider.notifier)
        .getUserSetting<String>(userId, SettingKeys.pinnedShelfEntries, defaultValue: '{}');
    return PinnedShelfPreferencesCodec.decode(rawValue);
  }

  bool isPinned({required String libraryId, required String itemId, String? episodeId}) {
    final key = pinnedShelfEntryKey(itemId, episodeId);
    return state[libraryId]?.any((entry) => entry.key == key) ?? false;
  }

  Future<void> pin({
    required String libraryId,
    required HomeLibraryMediaType mediaType,
    required String itemId,
    String? episodeId,
  }) async {
    _validatePin(mediaType: mediaType, episodeId: episodeId);
    if (isPinned(libraryId: libraryId, itemId: itemId, episodeId: episodeId)) {
      return;
    }

    final isFirstPinForLibrary = !state.containsKey(libraryId);
    final currentEntries = state[libraryId] ?? const <PinnedShelfEntry>[];
    final nextEntries = List<PinnedShelfEntry>.unmodifiable([
      PinnedShelfEntry(itemId: itemId, episodeId: episodeId, pinnedAt: DateTime.now()),
      ...currentEntries,
    ]);
    final nextState = Map<String, List<PinnedShelfEntry>>.unmodifiable({...state, libraryId: nextEntries});

    await _persist(nextState);
    if (isFirstPinForLibrary) {
      await _ensurePinnedShelfVisible(mediaType);
    }
  }

  Future<void> unpin({required String libraryId, required String itemId, String? episodeId}) async {
    final key = pinnedShelfEntryKey(itemId, episodeId);
    final currentEntries = state[libraryId];
    if (currentEntries == null || !currentEntries.any((entry) => entry.key == key)) {
      return;
    }

    final nextEntries = List<PinnedShelfEntry>.unmodifiable(currentEntries.where((entry) => entry.key != key));
    await _persist(Map<String, List<PinnedShelfEntry>>.unmodifiable({...state, libraryId: nextEntries}));
  }

  Future<void> clearLibraries(Iterable<String> libraryIds) async {
    final idsToClear = libraryIds.toSet();
    if (idsToClear.isEmpty || !state.keys.any(idsToClear.contains)) {
      return;
    }

    final nextState = Map<String, List<PinnedShelfEntry>>.from(state)
      ..removeWhere((libraryId, _) => idsToClear.contains(libraryId));
    await _persist(Map<String, List<PinnedShelfEntry>>.unmodifiable(nextState));
  }

  Future<PinnedShelfUndo> toggle({
    required String libraryId,
    required HomeLibraryMediaType mediaType,
    required String itemId,
    String? episodeId,
  }) async {
    _validatePin(mediaType: mediaType, episodeId: episodeId);
    final userId = ref.read(currentUserProvider).value?.id;
    if (userId == null) {
      throw StateError('A signed-in user is required to update shelf pins.');
    }

    final key = pinnedShelfEntryKey(itemId, episodeId);
    final currentEntries = state[libraryId] ?? const <PinnedShelfEntry>[];
    final previousIndex = currentEntries.indexWhere((entry) => entry.key == key);
    final undo = PinnedShelfUndo(
      userId: userId,
      mediaType: mediaType,
      libraryId: libraryId,
      itemId: itemId,
      episodeId: episodeId,
      wasPinned: previousIndex >= 0,
    );

    if (previousIndex >= 0) {
      await unpin(libraryId: libraryId, itemId: itemId, episodeId: episodeId);
      return undo;
    }

    await pin(libraryId: libraryId, mediaType: mediaType, itemId: itemId, episodeId: episodeId);
    return undo;
  }

  Future<void> undo(PinnedShelfUndo undo) async {
    final userId = ref.read(currentUserProvider).value?.id;
    if (userId == null || userId != undo.userId) {
      throw StateError('The active user changed before the pin action could be undone.');
    }

    if (undo.wasPinned) {
      await pin(libraryId: undo.libraryId, mediaType: undo.mediaType, itemId: undo.itemId, episodeId: undo.episodeId);
      return;
    }

    await unpin(libraryId: undo.libraryId, itemId: undo.itemId, episodeId: undo.episodeId);
  }

  Future<void> _persist(Map<String, List<PinnedShelfEntry>> nextState) async {
    final userId = ref.read(currentUserProvider).value?.id;
    if (userId == null) {
      throw StateError('A signed-in user is required to update shelf pins.');
    }

    final previousState = state;
    state = nextState;
    try {
      await ref
          .read(settingsManagerProvider.notifier)
          .setUserSetting<String>(
            userId,
            SettingKeys.pinnedShelfEntries,
            PinnedShelfPreferencesCodec.encode(nextState),
          );
    } catch (_) {
      if (identical(state, nextState)) {
        state = previousState;
      }
      rethrow;
    }
  }

  Future<void> _ensurePinnedShelfVisible(HomeLibraryMediaType mediaType) async {
    final userId = ref.read(currentUserProvider).value?.id;
    if (userId == null) {
      return;
    }

    final settingKey = PersonalizedShelfPreferencesCodec.settingKeyFor(mediaType);
    final defaultValue = PersonalizedShelfPreferencesCodec.defaultEncodedFor(mediaType);
    final settingsManager = ref.read(settingsManagerProvider.notifier);
    final rawValue = settingsManager.getUserSetting<String>(userId, settingKey, defaultValue: defaultValue);
    final preferences = PersonalizedShelfPreferencesCodec.decode(rawValue, mediaType);
    if (!preferences.hiddenSectionIds.contains(PersonalizedShelfSection.pinned.id)) {
      return;
    }

    final visiblePreferences = preferences.withVisibility(PersonalizedShelfSection.pinned.id, true);
    await settingsManager.setUserSetting<String>(
      userId,
      settingKey,
      PersonalizedShelfPreferencesCodec.encode(visiblePreferences),
    );
  }

  void _validatePin({required HomeLibraryMediaType mediaType, required String? episodeId}) {
    if (mediaType == HomeLibraryMediaType.book && episodeId != null) {
      throw ArgumentError('Book library pins cannot contain an episodeId.');
    }
  }
}

@riverpod
bool pinnedShelfContains(Ref ref, {required String libraryId, required String itemId, String? episodeId}) {
  final entries = ref.watch(pinnedShelfControllerProvider)[libraryId] ?? const <PinnedShelfEntry>[];
  final key = pinnedShelfEntryKey(itemId, episodeId);
  return entries.any((entry) => entry.key == key);
}

@riverpod
Future<List<LibraryItem>> pinnedShelfItems(Ref ref, String libraryId) async {
  final pins = ref.watch(pinnedShelfControllerProvider)[libraryId] ?? const <PinnedShelfEntry>[];
  if (pins.isEmpty) {
    return const <LibraryItem>[];
  }

  final itemIds = pins.map((pin) => pin.itemId).toSet();
  final resolvedEntries = await Future.wait(
    itemIds.map((itemId) async {
      try {
        final item = await ref.watch(libraryItemProvider(itemId).future);
        return MapEntry<String, LibraryItem?>(itemId, item);
      } catch (_) {
        return MapEntry<String, LibraryItem?>(itemId, null);
      }
    }),
  );
  final itemsById = Map<String, LibraryItem?>.fromEntries(resolvedEntries);
  final api = ref.read(absApiProvider);
  for (final itemId in itemIds) {
    final item = itemsById[itemId];
    final podcastMedia = item?.media?.podcastMedia;
    if (item == null || podcastMedia == null || api == null) {
      continue;
    }

    try {
      final fullItem = (await api.getLibraryItemApi().getLibraryItem(itemId: itemId)).data;
      if (fullItem != null) {
        itemsById[itemId] = fullItem;
      }
    } catch (_) {
      // Retain the cached/offline representation when a full refresh fails.
    }
  }
  final result = <LibraryItem>[];

  for (final pin in pins) {
    final item = itemsById[pin.itemId];
    if (item == null || (item.libraryId != null && item.libraryId != libraryId)) {
      continue;
    }

    final episodeId = pin.episodeId;
    if (episodeId == null) {
      result.add(item.mediaType == 'podcast' ? item.copyWith(recentEpisode: null) : item);
      continue;
    }

    final media = item.media;
    final podcastMedia = media?.podcastMedia;
    if (media == null || podcastMedia == null) {
      continue;
    }

    final episodes = podcastMedia.episodes ?? const <Episode>[];
    final episode = episodes.where((candidate) => candidate.id == episodeId).firstOrNull;
    if (episode == null) {
      continue;
    }

    result.add(item.copyWith(recentEpisode: episode));
  }

  return List<LibraryItem>.unmodifiable(result);
}
