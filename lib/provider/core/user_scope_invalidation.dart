import 'package:yaabsa/provider/common/collection_provider.dart';
import 'package:yaabsa/provider/common/library_author_provider.dart';
import 'package:yaabsa/provider/common/library_filter_data_provider.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/common/playlist_provider.dart';
import 'package:yaabsa/provider/common/series_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/library/personalized_library_provider.dart';

void invalidateUserScopedProviders(dynamic ref) {
  ref.invalidate(absApiProvider);
  ref.invalidate(userLibrariesProvider);
  ref.invalidate(selectedLibraryIdProvider);
  ref.invalidate(selectedLibraryProvider);

  ref.invalidate(libraryFilterDataProvider);
  ref.invalidate(libraryItemsProvider);
  ref.invalidate(collectionsProvider);
  ref.invalidate(playlistsProvider);
  ref.invalidate(seriesProvider);
  ref.invalidate(seriesBooksProvider);
  ref.invalidate(libraryAuthorsProvider);
  ref.invalidate(personalizedLibraryProvider);
}
