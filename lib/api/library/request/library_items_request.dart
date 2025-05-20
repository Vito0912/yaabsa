import 'package:freezed_annotation/freezed_annotation.dart';

part 'library_items_request.freezed.dart';
part 'library_items_request.g.dart';

@freezed
abstract class LibraryItemsRequest with _$LibraryItemsRequest {
  const factory LibraryItemsRequest({
    @JsonKey(name: "limit") required int limit,
    @JsonKey(name: "page") required int page,
    @JsonKey(name: "sort") String? sort,
    @JsonKey(name: "desc") int? desc,
    @JsonKey(name: "filter") String? filter,
    @JsonKey(name: "collapseseries") int? collapseseries,
    @JsonKey(name: "include") String? include,
  }) = _LibraryItemsRequest;

  factory LibraryItemsRequest.fromJson(Map<String, dynamic> json) => _$LibraryItemsRequestFromJson(json);
}
