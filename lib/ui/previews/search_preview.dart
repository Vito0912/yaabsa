import 'package:dio/dio.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library/search_library.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/common/library_search_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/main/search_view.dart';
import 'package:yaabsa/ui/previews/preview_fixtures.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

@Preview(name: 'Search results / phone', size: Size(390, 720), wrapper: yaabsaPreviewLight)
@Preview(name: 'Search results / desktop', size: Size(1100, 720), wrapper: yaabsaPreviewDark)
Widget searchResultsPreview() => const SearchResultsPreview();

@Preview(name: 'Search results / enlarged text', size: Size(390, 720), wrapper: yaabsaPreviewLight)
Widget searchResultsEnlargedPreview() => const SearchResultsPreview(textScaleFactor: 1.6);

class SearchResultsPreview extends StatefulWidget {
  const SearchResultsPreview({super.key, this.textScaleFactor = 1});

  final double textScaleFactor;

  @override
  State<SearchResultsPreview> createState() => _SearchResultsPreviewState();
}

class _SearchResultsPreviewState extends State<SearchResultsPreview> {
  final ABSApi _api = ABSApi(
    dio: Dio(BaseOptions(baseUrl: 'https://yaabsa-ui-lab.example.test')),
    interceptors: [],
  );
  late final SearchLibrary _results = SearchLibrary(
    book: previewSearchLibraryItems().map((item) => SearchLibraryResult(libraryItem: item)).toList(growable: false),
    tags: const [SearchResultItem(name: 'Deterministic preview', numItems: 1000)],
  );

  @override
  void dispose() {
    _api.dio.close(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        selectedLibraryProvider.overrideWith((ref) => previewUploadLibrary()),
        absApiProvider.overrideWith((ref) => _api),
        librarySearchProvider((query: 'Preview', limit: null, libraryId: null)).overrideWith((ref) async => _results),
      ],
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(
            double.tryParse(Uri.base.queryParameters['textScale'] ?? '') ?? widget.textScaleFactor,
          ),
        ),
        child: const SearchView(query: 'Preview', limit: null),
      ),
    );
  }
}
