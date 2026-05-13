import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_provider_option.freezed.dart';
part 'search_provider_option.g.dart';

@freezed
abstract class SearchProviderOption with _$SearchProviderOption {
  const factory SearchProviderOption({
    @JsonKey(name: 'value') required String value,
    @JsonKey(name: 'text') required String text,
  }) = _SearchProviderOption;

  factory SearchProviderOption.fromJson(Map<String, dynamic> json) => _$SearchProviderOptionFromJson(json);
}
