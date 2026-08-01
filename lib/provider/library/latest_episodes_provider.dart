import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/provider/common/library_item_events.dart';
import 'package:yaabsa/provider/core/user_providers.dart';

part 'latest_episodes_provider.g.dart';

class LatestEpisodesState {
  const LatestEpisodesState({
    required this.episodes,
    required this.page,
    required this.hasNextPage,
    this.isLoadingNextPage = false,
  });

  final List<Episode> episodes;
  final int page;
  final bool hasNextPage;
  final bool isLoadingNextPage;

  LatestEpisodesState copyWith({List<Episode>? episodes, int? page, bool? hasNextPage, bool? isLoadingNextPage}) {
    return LatestEpisodesState(
      episodes: episodes ?? this.episodes,
      page: page ?? this.page,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingNextPage: isLoadingNextPage ?? this.isLoadingNextPage,
    );
  }
}

@riverpod
class LatestEpisodes extends _$LatestEpisodes {
  static const int _pageSize = 20;

  @override
  Future<LatestEpisodesState> build(String libraryId) async {
    ref.listen<LibraryItemMutation?>(libraryItemMutationProvider, (previous, next) {
      if (next != null && (next.libraryId == null || next.libraryId == libraryId)) {
        ref.invalidateSelf();
      }
    });

    return _fetchPage(page: 0);
  }

  Future<LatestEpisodesState> _fetchPage({required int page}) async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      throw StateError('No server connection available.');
    }

    final response = await api.getLibraryApi().getRecentEpisodes(
      libraryId,
      limit: _pageSize,
      page: page,
      extra: const <String, dynamic>{'doNotCache': true},
    );
    final episodes = response.data?.episodes ?? const <Episode>[];

    return LatestEpisodesState(
      episodes: List<Episode>.unmodifiable(episodes),
      page: page,
      hasNextPage: episodes.length >= _pageSize,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchPage(page: 0));
  }

  Future<void> loadNextPage() async {
    final current = state.asData?.value;
    if (current == null || current.isLoadingNextPage || !current.hasNextPage) {
      return;
    }

    state = AsyncValue.data(current.copyWith(isLoadingNextPage: true));

    try {
      final next = await _fetchPage(page: current.page + 1);
      final seen = current.episodes.map((episode) => episode.id).toSet();
      final combined = <Episode>[...current.episodes];
      for (final episode in next.episodes) {
        if (seen.add(episode.id)) {
          combined.add(episode);
        }
      }

      state = AsyncValue.data(
        LatestEpisodesState(
          episodes: List<Episode>.unmodifiable(combined),
          page: next.page,
          hasNextPage: next.hasNextPage,
        ),
      );
    } catch (_) {
      state = AsyncValue.data(current.copyWith(isLoadingNextPage: false));
    }
  }
}
