import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/library/search_library.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/logger.dart';

typedef LibrarySearchProviderArgs = ({String query, int? limit, String? libraryId});

final librarySearchProvider = FutureProvider.autoDispose.family<SearchLibrary?, LibrarySearchProviderArgs>((
  ref,
  args,
) async {
  final api = ref.watch(absApiProvider);
  final libraryId = args.libraryId ?? ref.watch(selectedLibraryProvider)?.id;
  final trimmedQuery = args.query.trim();

  if (api == null || libraryId == null || trimmedQuery.isEmpty) {
    return null;
  }

  try {
    final response = await api.getLibraryApi().getSearchLibrary(libraryId, trimmedQuery, limit: args.limit);
    return response.data;
  } catch (error, stack) {
    logger('Error searching library: $error\n$stack', tag: 'LibrarySearchProvider', level: InfoLevel.warning);
    rethrow;
  }
});
