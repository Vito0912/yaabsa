// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stored_downloads_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(downloadAvailability)
final downloadAvailabilityProvider = DownloadAvailabilityProvider._();

final class DownloadAvailabilityProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<ItemDownloadKey, DownloadAvailability>>,
          Map<ItemDownloadKey, DownloadAvailability>,
          Stream<Map<ItemDownloadKey, DownloadAvailability>>
        >
    with
        $FutureModifier<Map<ItemDownloadKey, DownloadAvailability>>,
        $StreamProvider<Map<ItemDownloadKey, DownloadAvailability>> {
  DownloadAvailabilityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'downloadAvailabilityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$downloadAvailabilityHash();

  @$internal
  @override
  $StreamProviderElement<Map<ItemDownloadKey, DownloadAvailability>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Map<ItemDownloadKey, DownloadAvailability>> create(Ref ref) {
    return downloadAvailability(ref);
  }
}

String _$downloadAvailabilityHash() => r'7fd4426ec30d2ea192f5fc53cab9179234980cf4';

@ProviderFor(storedDownloads)
final storedDownloadsProvider = StoredDownloadsProvider._();

final class StoredDownloadsProvider
    extends
        $FunctionalProvider<AsyncValue<List<InternalDownload>>, List<InternalDownload>, Stream<List<InternalDownload>>>
    with $FutureModifier<List<InternalDownload>>, $StreamProvider<List<InternalDownload>> {
  StoredDownloadsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storedDownloadsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storedDownloadsHash();

  @$internal
  @override
  $StreamProviderElement<List<InternalDownload>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<InternalDownload>> create(Ref ref) {
    return storedDownloads(ref);
  }
}

String _$storedDownloadsHash() => r'f435088a7802282558e907149be79bd73f9c8b09';

@ProviderFor(storedDownloadEntry)
final storedDownloadEntryProvider = StoredDownloadEntryFamily._();

final class StoredDownloadEntryProvider
    extends $FunctionalProvider<AsyncValue<InternalDownload?>, InternalDownload?, Stream<InternalDownload?>>
    with $FutureModifier<InternalDownload?>, $StreamProvider<InternalDownload?> {
  StoredDownloadEntryProvider._({
    required StoredDownloadEntryFamily super.from,
    required (String, {String? episodeId}) super.argument,
  }) : super(
         retry: null,
         name: r'storedDownloadEntryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$storedDownloadEntryHash();

  @override
  String toString() {
    return r'storedDownloadEntryProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<InternalDownload?> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<InternalDownload?> create(Ref ref) {
    final argument = this.argument as (String, {String? episodeId});
    return storedDownloadEntry(ref, argument.$1, episodeId: argument.episodeId);
  }

  @override
  bool operator ==(Object other) {
    return other is StoredDownloadEntryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$storedDownloadEntryHash() => r'86022b584e89ab2513817558c8c08f4ae7295c07';

final class StoredDownloadEntryFamily extends $Family
    with $FunctionalFamilyOverride<Stream<InternalDownload?>, (String, {String? episodeId})> {
  StoredDownloadEntryFamily._()
    : super(
        retry: null,
        name: r'storedDownloadEntryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  StoredDownloadEntryProvider call(String itemId, {String? episodeId}) =>
      StoredDownloadEntryProvider._(argument: (itemId, episodeId: episodeId), from: this);

  @override
  String toString() => r'storedDownloadEntryProvider';
}

@ProviderFor(storedDownloadForItem)
final storedDownloadForItemProvider = StoredDownloadForItemFamily._();

final class StoredDownloadForItemProvider
    extends $FunctionalProvider<InternalDownload?, InternalDownload?, InternalDownload?>
    with $Provider<InternalDownload?> {
  StoredDownloadForItemProvider._({
    required StoredDownloadForItemFamily super.from,
    required (String, {String? episodeId}) super.argument,
  }) : super(
         retry: null,
         name: r'storedDownloadForItemProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$storedDownloadForItemHash();

  @override
  String toString() {
    return r'storedDownloadForItemProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<InternalDownload?> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  InternalDownload? create(Ref ref) {
    final argument = this.argument as (String, {String? episodeId});
    return storedDownloadForItem(ref, argument.$1, episodeId: argument.episodeId);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InternalDownload? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<InternalDownload?>(value));
  }

  @override
  bool operator ==(Object other) {
    return other is StoredDownloadForItemProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$storedDownloadForItemHash() => r'a00040eca7e95480e6405e4da1acc1786cba1dda';

final class StoredDownloadForItemFamily extends $Family
    with $FunctionalFamilyOverride<InternalDownload?, (String, {String? episodeId})> {
  StoredDownloadForItemFamily._()
    : super(
        retry: null,
        name: r'storedDownloadForItemProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  StoredDownloadForItemProvider call(String itemId, {String? episodeId}) =>
      StoredDownloadForItemProvider._(argument: (itemId, episodeId: episodeId), from: this);

  @override
  String toString() => r'storedDownloadForItemProvider';
}

@ProviderFor(downloadFilesForItem)
final downloadFilesForItemProvider = DownloadFilesForItemFamily._();

final class DownloadFilesForItemProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DownloadFileEntry>>,
          List<DownloadFileEntry>,
          FutureOr<List<DownloadFileEntry>>
        >
    with $FutureModifier<List<DownloadFileEntry>>, $FutureProvider<List<DownloadFileEntry>> {
  DownloadFilesForItemProvider._({
    required DownloadFilesForItemFamily super.from,
    required (String, {String? episodeId}) super.argument,
  }) : super(
         retry: null,
         name: r'downloadFilesForItemProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$downloadFilesForItemHash();

  @override
  String toString() {
    return r'downloadFilesForItemProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<DownloadFileEntry>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<DownloadFileEntry>> create(Ref ref) {
    final argument = this.argument as (String, {String? episodeId});
    return downloadFilesForItem(ref, argument.$1, episodeId: argument.episodeId);
  }

  @override
  bool operator ==(Object other) {
    return other is DownloadFilesForItemProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$downloadFilesForItemHash() => r'9ece11994f863bbb23237c0203b98effe253ed7e';

final class DownloadFilesForItemFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<DownloadFileEntry>>, (String, {String? episodeId})> {
  DownloadFilesForItemFamily._()
    : super(
        retry: null,
        name: r'downloadFilesForItemProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DownloadFilesForItemProvider call(String itemId, {String? episodeId}) =>
      DownloadFilesForItemProvider._(argument: (itemId, episodeId: episodeId), from: this);

  @override
  String toString() => r'downloadFilesForItemProvider';
}

@ProviderFor(downloadFileStatuses)
final downloadFileStatusesProvider = DownloadFileStatusesProvider._();

final class DownloadFileStatusesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<DownloadFileKey, ItemDownloadStatus>>,
          Map<DownloadFileKey, ItemDownloadStatus>,
          Stream<Map<DownloadFileKey, ItemDownloadStatus>>
        >
    with
        $FutureModifier<Map<DownloadFileKey, ItemDownloadStatus>>,
        $StreamProvider<Map<DownloadFileKey, ItemDownloadStatus>> {
  DownloadFileStatusesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'downloadFileStatusesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$downloadFileStatusesHash();

  @$internal
  @override
  $StreamProviderElement<Map<DownloadFileKey, ItemDownloadStatus>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Map<DownloadFileKey, ItemDownloadStatus>> create(Ref ref) {
    return downloadFileStatuses(ref);
  }
}

String _$downloadFileStatusesHash() => r'f8616c82828978858aed7557ce04ffa2bf55589a';
