// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_source_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(queueSourceRepository)
final queueSourceRepositoryProvider = QueueSourceRepositoryProvider._();

final class QueueSourceRepositoryProvider
    extends $FunctionalProvider<QueueSourceRepository, QueueSourceRepository, QueueSourceRepository>
    with $Provider<QueueSourceRepository> {
  QueueSourceRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'queueSourceRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$queueSourceRepositoryHash();

  @$internal
  @override
  $ProviderElement<QueueSourceRepository> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  QueueSourceRepository create(Ref ref) {
    return queueSourceRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QueueSourceRepository value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<QueueSourceRepository>(value));
  }
}

String _$queueSourceRepositoryHash() => r'170f6aac0c16f91f572330f5fdd1faac3331fef5';
