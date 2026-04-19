import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaabsa/api/library/filter_data/library_filter_data.dart';
import 'package:yaabsa/provider/core/user_providers.dart';

part 'library_filter_data_provider.g.dart';

@Riverpod(keepAlive: true)
Future<LibraryFilterData?> libraryFilterData(Ref ref, String libraryId) async {
  final api = ref.watch(absApiProvider);
  if (api == null) {
    throw Exception('User not authenticated or API not available.');
  }

  final response = await api.getLibraryApi().getLibraryFilterData(libraryId);
  return response.data?.filterData;
}
