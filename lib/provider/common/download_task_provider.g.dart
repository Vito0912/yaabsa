// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_task_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(downloadInProgressForItem)
final downloadInProgressForItemProvider = DownloadInProgressForItemFamily._();

final class DownloadInProgressForItemProvider extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
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
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    final argument = this.argument as (String, {String? episodeId});
    return downloadInProgressForItem(ref, argument.$1, episodeId: argument.episodeId);
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

String _$downloadInProgressForItemHash() => r'fd5eee9480d6cfc9edaec98c23e50a2a6c15eb8f';

final class DownloadInProgressForItemFamily extends $Family
    with $FunctionalFamilyOverride<Stream<bool>, (String, {String? episodeId})> {
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
