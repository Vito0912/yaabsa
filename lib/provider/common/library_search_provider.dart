import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/library/search_library.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/logger.dart';

final librarySearchProvider = FutureProvider.autoDispose.family<SearchLibrary?, String>((ref, query) async {
  final api = ref.watch(absApiProvider);
  final selectedLibrary = ref.watch(selectedLibraryProvider);
  final trimmedQuery = query.trim();

  if (api == null || selectedLibrary == null || trimmedQuery.isEmpty) {
    return null;
  }

  try {
    final response = await api.getLibraryApi().getSearchLibrary(selectedLibrary.id, trimmedQuery);
    return response.data;
  } catch (error, stack) {
    logger('Error searching library: $error\n$stack', tag: 'LibrarySearchProvider', level: InfoLevel.warning);
    rethrow;
  }
});
