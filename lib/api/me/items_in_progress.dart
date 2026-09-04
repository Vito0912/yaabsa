import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/library_items/library_item.dart';

part 'items_in_progress.freezed.dart';
part 'items_in_progress.g.dart';

@freezed
abstract class ItemsInProgress with _$ItemsInProgress {
  const factory ItemsInProgress({
    @JsonKey(name: 'libraryItems') @Default(<LibraryItem>[]) List<LibraryItem> libraryItems,
  }) = _ItemsInProgress;

  factory ItemsInProgress.fromJson(Map<String, dynamic> json) => _$ItemsInProgressFromJson(json);
}
