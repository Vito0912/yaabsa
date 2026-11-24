import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaabsa/api/library/search_library.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/logger.dart';

part 'library_search_provider.g.dart';

typedef LibrarySearchProviderArgs = ({String query, int? limit, String? libraryId});

@riverpod
Future<SearchLibrary?> librarySearch(Ref ref, LibrarySearchProviderArgs args) async {
  final api = ref.watch(absApiProvider);
  final libraryId = args.libraryId ?? ref.watch(selectedLibraryProvider)?.id;
  final trimmedQuery = args.query.trim();
  if (api == null || libraryId == null || trimmedQuery.isEmpty) {
    return null;
  }

  final cancelToken = CancelToken();
  ref.onDispose(() => cancelToken.cancel('Search no longer observed'));
  try {
    final response = await api.getLibraryApi().getSearchLibrary(
      libraryId,
      trimmedQuery,
      limit: args.limit,
      cancelToken: cancelToken,
    );
    return response.data;
  } catch (error, stack) {
    if (error is! DioException || !CancelToken.isCancel(error)) {
      logger('Error searching library: $error\n$stack', tag: 'LibrarySearchProvider', level: InfoLevel.warning);
    }
    rethrow;
  }
}
