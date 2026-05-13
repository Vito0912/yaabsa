import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/search/search_provider_option.dart';

part 'search_providers.freezed.dart';
part 'search_providers.g.dart';

@freezed
abstract class SearchProviders with _$SearchProviders {
  const factory SearchProviders({
    @JsonKey(name: 'books') @Default(<SearchProviderOption>[]) List<SearchProviderOption> books,
    @JsonKey(name: 'booksCovers') @Default(<SearchProviderOption>[]) List<SearchProviderOption> booksCovers,
    @JsonKey(name: 'podcasts') @Default(<SearchProviderOption>[]) List<SearchProviderOption> podcasts,
  }) = _SearchProviders;

  factory SearchProviders.fromJson(Map<String, dynamic> json) => _$SearchProvidersFromJson(json);
}
