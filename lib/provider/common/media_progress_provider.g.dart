// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_progress_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mediaProgressByKey)
final mediaProgressByKeyProvider = MediaProgressByKeyFamily._();

final class MediaProgressByKeyProvider extends $FunctionalProvider<MediaProgress?, MediaProgress?, MediaProgress?>
    with $Provider<MediaProgress?> {
  MediaProgressByKeyProvider._({required MediaProgressByKeyFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'mediaProgressByKeyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaProgressByKeyHash();

  @override
  String toString() {
    return r'mediaProgressByKeyProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<MediaProgress?> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  MediaProgress? create(Ref ref) {
    final argument = this.argument as String;
    return mediaProgressByKey(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MediaProgress? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<MediaProgress?>(value));
  }

  @override
  bool operator ==(Object other) {
    return other is MediaProgressByKeyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mediaProgressByKeyHash() => r'49253af012637960aebe3039e36d7542fa38034a';

final class MediaProgressByKeyFamily extends $Family with $FunctionalFamilyOverride<MediaProgress?, String> {
  MediaProgressByKeyFamily._()
    : super(
        retry: null,
        name: r'mediaProgressByKeyProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MediaProgressByKeyProvider call(String key) => MediaProgressByKeyProvider._(argument: key, from: this);

  @override
  String toString() => r'mediaProgressByKeyProvider';
}

@ProviderFor(mediaProgressForLibraryItem)
final mediaProgressForLibraryItemProvider = MediaProgressForLibraryItemFamily._();

final class MediaProgressForLibraryItemProvider
    extends $FunctionalProvider<List<MediaProgress>, List<MediaProgress>, List<MediaProgress>>
    with $Provider<List<MediaProgress>> {
  MediaProgressForLibraryItemProvider._({
    required MediaProgressForLibraryItemFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'mediaProgressForLibraryItemProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mediaProgressForLibraryItemHash();

  @override
  String toString() {
    return r'mediaProgressForLibraryItemProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<MediaProgress>> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  List<MediaProgress> create(Ref ref) {
    final argument = this.argument as String;
    return mediaProgressForLibraryItem(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<MediaProgress> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<List<MediaProgress>>(value));
  }

  @override
  bool operator ==(Object other) {
    return other is MediaProgressForLibraryItemProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mediaProgressForLibraryItemHash() => r'ae793ecc0ddbe2e0866ddc9dd8182b7e94b690fb';

final class MediaProgressForLibraryItemFamily extends $Family
    with $FunctionalFamilyOverride<List<MediaProgress>, String> {
  MediaProgressForLibraryItemFamily._()
    : super(
        retry: null,
        name: r'mediaProgressForLibraryItemProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MediaProgressForLibraryItemProvider call(String libraryItemId) =>
      MediaProgressForLibraryItemProvider._(argument: libraryItemId, from: this);

  @override
  String toString() => r'mediaProgressForLibraryItemProvider';
}

@ProviderFor(mediaProgressStore)
final mediaProgressStoreProvider = MediaProgressStoreProvider._();

final class MediaProgressStoreProvider
    extends $FunctionalProvider<MediaProgressStore, MediaProgressStore, MediaProgressStore>
    with $Provider<MediaProgressStore> {
  MediaProgressStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaProgressStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaProgressStoreHash();

  @$internal
  @override
  $ProviderElement<MediaProgressStore> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  MediaProgressStore create(Ref ref) {
    return mediaProgressStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MediaProgressStore value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<MediaProgressStore>(value));
  }
}

String _$mediaProgressStoreHash() => r'9dd3fadcaf63feacd7d44daf18775c6346957d89';

@ProviderFor(MediaProgressRevision)
final mediaProgressRevisionProvider = MediaProgressRevisionProvider._();

final class MediaProgressRevisionProvider extends $NotifierProvider<MediaProgressRevision, int> {
  MediaProgressRevisionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaProgressRevisionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaProgressRevisionHash();

  @$internal
  @override
  MediaProgressRevision create() => MediaProgressRevision();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<int>(value));
  }
}

String _$mediaProgressRevisionHash() => r'ca22422875f1bfb4c55be1c82e7aa14e8ab6ba5a';

abstract class _$MediaProgressRevision extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<int, int>, int, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(MediaProgressNotifier)
final mediaProgressProvider = MediaProgressNotifierProvider._();

final class MediaProgressNotifierProvider extends $AsyncNotifierProvider<MediaProgressNotifier, void> {
  MediaProgressNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaProgressProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaProgressNotifierHash();

  @$internal
  @override
  MediaProgressNotifier create() => MediaProgressNotifier();
}

String _$mediaProgressNotifierHash() => r'db401944cf4191ab9bd497389274ce425ea4dac4';

abstract class _$MediaProgressNotifier extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element as $ClassProviderElement<AnyNotifier<AsyncValue<void>, void>, AsyncValue<void>, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}
