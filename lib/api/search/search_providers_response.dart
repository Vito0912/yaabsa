import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/search/search_providers.dart';

part 'search_providers_response.freezed.dart';
part 'search_providers_response.g.dart';

@freezed
abstract class SearchProvidersResponse with _$SearchProvidersResponse {
  const factory SearchProvidersResponse({@JsonKey(name: 'providers') required SearchProviders providers}) =
      _SearchProvidersResponse;

  factory SearchProvidersResponse.fromJson(Map<String, dynamic> json) => _$SearchProvidersResponseFromJson(json);
}
