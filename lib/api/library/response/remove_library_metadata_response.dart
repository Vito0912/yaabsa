import 'package:freezed_annotation/freezed_annotation.dart';

part 'remove_library_metadata_response.freezed.dart';
part 'remove_library_metadata_response.g.dart';

@freezed
abstract class RemoveLibraryMetadataResponse with _$RemoveLibraryMetadataResponse {
  const factory RemoveLibraryMetadataResponse({
    @JsonKey(name: 'found') required bool found,
    @JsonKey(name: 'numRemoved') @Default(0) int numRemoved,
    @JsonKey(name: 'error') String? error,
  }) = _RemoveLibraryMetadataResponse;

  factory RemoveLibraryMetadataResponse.fromJson(Map<String, dynamic> json) =>
      _$RemoveLibraryMetadataResponseFromJson(json);
}
