import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaabsa/api/search/search_provider_option.dart';
import 'package:yaabsa/provider/core/user_providers.dart';

part 'upload_providers.g.dart';

@Riverpod(keepAlive: true)
Future<List<SearchProviderOption>> uploadMetadataProviders(Ref ref, String mediaType) async {
  final api = ref.watch(absApiProvider);
  if (api == null) {
    return <SearchProviderOption>[];
  }

  final response = await api.getUploadApi().getSearchProviders();
  final providerLists = response?.providers;
  if (providerLists == null) {
    return <SearchProviderOption>[];
  }

  final rawOptions = mediaType == 'podcast' ? providerLists.podcasts : providerLists.books;
  final seen = <String>{};
  return rawOptions.where((option) => seen.add(option.value)).toList();
}
