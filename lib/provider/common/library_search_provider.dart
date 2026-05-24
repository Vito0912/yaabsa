import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/library/search_library.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/logger.dart';

typedef LibrarySearchProviderArgs = ({String query, int? limit});

final librarySearchProvider = FutureProvider.autoDispose.family<SearchLibrary?, LibrarySearchProviderArgs>((
  ref,
  args,
) async {
  final api = ref.watch(absApiProvider);
  final selectedLibrary = ref.watch(selectedLibraryProvider);
  final trimmedQuery = args.query.trim();

  if (api == null || selectedLibrary == null || trimmedQuery.isEmpty) {
    return null;
  }

  try {
    final response = await api.getLibraryApi().getSearchLibrary(selectedLibrary.id, trimmedQuery, limit: args.limit);
    return response.data;
  } catch (error, stack) {
    logger('Error searching library: $error\n$stack', tag: 'LibrarySearchProvider', level: InfoLevel.warning);
    rethrow;
  }
});
