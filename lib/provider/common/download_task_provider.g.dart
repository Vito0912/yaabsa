// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_task_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(downloadInProgressForItem)
final downloadInProgressForItemProvider = DownloadInProgressForItemFamily._();

final class DownloadInProgressForItemProvider extends $FunctionalProvider<bool, bool, bool> with $Provider<bool> {
  DownloadInProgressForItemProvider._({
    required DownloadInProgressForItemFamily super.from,
    required (String, {String? episodeId}) super.argument,
  }) : super(
         retry: null,
         name: r'downloadInProgressForItemProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$downloadInProgressForItemHash();

  @override
  String toString() {
    return r'downloadInProgressForItemProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as (String, {String? episodeId});
    return downloadInProgressForItem(ref, argument.$1, episodeId: argument.episodeId);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<bool>(value));
  }

  @override
  bool operator ==(Object other) {
    return other is DownloadInProgressForItemProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$downloadInProgressForItemHash() => r'e5806bff0771241fb790a509e0dc048a3c1939d7';

final class DownloadInProgressForItemFamily extends $Family
    with $FunctionalFamilyOverride<bool, (String, {String? episodeId})> {
  DownloadInProgressForItemFamily._()
    : super(
        retry: null,
        name: r'downloadInProgressForItemProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DownloadInProgressForItemProvider call(String itemId, {String? episodeId}) =>
      DownloadInProgressForItemProvider._(argument: (itemId, episodeId: episodeId), from: this);

  @override
  String toString() => r'downloadInProgressForItemProvider';
}
