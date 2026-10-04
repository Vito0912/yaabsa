// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_download_status_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(itemDownloadStatuses)
final itemDownloadStatusesProvider = ItemDownloadStatusesProvider._();

final class ItemDownloadStatusesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<ItemDownloadKey, ItemDownloadStatus>>,
          Map<ItemDownloadKey, ItemDownloadStatus>,
          Stream<Map<ItemDownloadKey, ItemDownloadStatus>>
        >
    with
        $FutureModifier<Map<ItemDownloadKey, ItemDownloadStatus>>,
        $StreamProvider<Map<ItemDownloadKey, ItemDownloadStatus>> {
  ItemDownloadStatusesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'itemDownloadStatusesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$itemDownloadStatusesHash();

  @$internal
  @override
  $StreamProviderElement<Map<ItemDownloadKey, ItemDownloadStatus>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Map<ItemDownloadKey, ItemDownloadStatus>> create(Ref ref) {
    return itemDownloadStatuses(ref);
  }
}

String _$itemDownloadStatusesHash() => r'2e334861c5a4d2861b0d3e3c062f0e7c572c6c9c';
