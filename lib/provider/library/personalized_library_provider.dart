import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaabsa/api/library/personalized_library.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/logger.dart';

part 'personalized_library_provider.g.dart';

@Riverpod(keepAlive: true)
class PersonalizedLibraryNotifier extends _$PersonalizedLibraryNotifier {
  Future<PersonalizedLibrary?> _fetchPersonalizedLibrary(String libraryId) async {
    final api = ref.watch(absApiProvider);
    if (api == null) {
      logger(
        'PersonalizedLibraryNotifier: ABSApi is null, returning null.',
        tag: 'PersonalizedLibraryNotifier',
        level: InfoLevel.warning,
      );
      return null;
    }
    try {
      final response = await api.getLibraryApi().getPersonalized(libraryId);
      return response.data;
    } catch (e, s) {
      logger('Error fetching personalized library: $e\n$s', tag: 'PersonalizedLibraryNotifier', level: InfoLevel.error);
      return null;
    }
  }

  @override
  Future<PersonalizedLibrary?> build(String libraryId) async {
    return _fetchPersonalizedLibrary(libraryId);
  }

  Future<void> refresh(String libraryId, {bool withLoading = false}) async {
    if (withLoading) state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchPersonalizedLibrary(libraryId));
  }
}
