import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/api/podcast/library_podcast_title.dart';
import 'package:yaabsa/api/podcast/podcast_search_result.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/components/app/podcast_add/podcast_add_result_tile.dart';
import 'package:yaabsa/components/app/podcast_add/podcast_create_dialog.dart';
import 'package:yaabsa/components/common/loading_snackbar.dart';
import 'package:yaabsa/components/common/textbox_button.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';

class PodcastAddView extends ConsumerStatefulWidget {
  const PodcastAddView({super.key});

  @override
  ConsumerState<PodcastAddView> createState() => _PodcastAddViewState();
}

class _PodcastAddViewState extends ConsumerState<PodcastAddView> {
  final TextEditingController _searchController = TextEditingController();

  List<PodcastSearchResult> _searchResults = const <PodcastSearchResult>[];
  List<LibraryPodcastTitle> _libraryPodcastTitles = const <LibraryPodcastTitle>[];

  bool _isSearching = false;
  bool _isResolvingFeed = false;
  bool _isLoadingLibraryTitles = false;

  String? _searchError;
  String? _titlesLibraryId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _isAdminType(String? userType) {
    final normalized = (userType ?? '').trim().toLowerCase();
    return normalized == 'admin' || normalized == 'root';
  }

  bool _looksLikeRssUrl(String value) {
    final parsed = Uri.tryParse(value);
    if (parsed == null || (parsed.scheme != 'http' && parsed.scheme != 'https')) {
      return false;
    }
    return parsed.host.trim().isNotEmpty;
  }

  String _searchRegionForLibrary(Library library) {
    final region = library.settings.podcastSearchRegion?.trim();
    if (region == null || region.isEmpty) {
      return 'us';
    }
    return region;
  }

  void _ensureLibraryTitlesLoaded({required ABSApi api, required Library library}) {
    if (_titlesLibraryId == library.id || _isLoadingLibraryTitles) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      unawaited(_loadLibraryPodcastTitles(api: api, libraryId: library.id));
    });
  }

  Future<void> _loadLibraryPodcastTitles({required ABSApi api, required String libraryId}) async {
    setState(() {
      _isLoadingLibraryTitles = true;
      _titlesLibraryId = libraryId;
    });

    try {
      final titles = await api.getPodcastApi().getLibraryPodcastTitles(libraryId: libraryId);
      if (!mounted) {
        return;
      }

      setState(() {
        _libraryPodcastTitles = titles;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _libraryPodcastTitles = const <LibraryPodcastTitle>[];
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLibraryTitles = false;
        });
      }
    }
  }

  LibraryPodcastTitle? _matchingPodcastForResult(PodcastSearchResult result) {
    final normalizedId = result.id?.trim().toLowerCase();
    if (normalizedId != null && normalizedId.isNotEmpty) {
      for (final title in _libraryPodcastTitles) {
        final existingId = title.itunesId?.trim().toLowerCase();
        if (existingId != null && existingId.isNotEmpty && existingId == normalizedId) {
          return title;
        }
      }
    }

    final normalizedTitle = result.title?.trim().toLowerCase();
    if (normalizedTitle != null && normalizedTitle.isNotEmpty) {
      for (final title in _libraryPodcastTitles) {
        final existingTitle = title.title.trim().toLowerCase();
        if (existingTitle.isNotEmpty && existingTitle == normalizedTitle) {
          return title;
        }
      }
    }

    return null;
  }

  Future<void> _handleSearch({required ABSApi api, required Library library}) async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      return;
    }

    if (_looksLikeRssUrl(query)) {
      await _startCreatePodcastFlow(api: api, library: library, rssFeed: query);
      return;
    }

    setState(() {
      _isSearching = true;
      _searchError = null;
    });

    try {
      final results = await api.getPodcastApi().searchPodcasts(term: query, country: _searchRegionForLibrary(library));
      if (!mounted) {
        return;
      }

      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _searchError = '$e';
        _searchResults = const <PodcastSearchResult>[];
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    }
  }

  Future<void> _onResultTap({
    required ABSApi api,
    required Library library,
    required PodcastSearchResult result,
    required LibraryPodcastTitle? existing,
  }) async {
    if (existing != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('This podcast is already in your library.')));
      return;
    }

    final feedUrl = result.feedUrl?.trim();
    if (feedUrl == null || feedUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This result has no RSS feed URL. Try pasting the feed URL directly.')),
      );
      return;
    }

    await _startCreatePodcastFlow(api: api, library: library, rssFeed: feedUrl, searchResult: result);
  }

  Future<void> _startCreatePodcastFlow({
    required ABSApi api,
    required Library library,
    required String rssFeed,
    PodcastSearchResult? searchResult,
  }) async {
    setState(() {
      _isResolvingFeed = true;
    });

    try {
      final feed = await api.getPodcastApi().getPodcastFeed(rssFeed: rssFeed);
      if (feed == null) {
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Could not read this RSS feed. Check the URL and try again.')));
        return;
      }

      if (!mounted) {
        return;
      }

      final createRequest = await showPodcastCreateDialog(
        context: context,
        library: library,
        feed: feed,
        searchResult: searchResult,
        rssFeedOverride: rssFeed,
      );

      if (!mounted || createRequest == null) {
        return;
      }

      await runWithLoadingSnackBar<void>(
        context: context,
        message: 'Creating podcast...',
        action: () => api.getPodcastApi().createPodcast(request: createRequest),
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added podcast to ${library.name}.')));

      await _loadLibraryPodcastTitles(api: api, libraryId: library.id);
      setState(() {
        _searchError = null;
      });
    } on DioException catch (e) {
      if (!mounted) {
        return;
      }

      if (e.response?.statusCode == 400) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('This podcast already exists in your library.')));
        return;
      }

      final message = _dioErrorMessage(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create podcast: $message')));
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create podcast: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isResolvingFeed = false;
        });
      }
    }
  }

  String _dioErrorMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map) {
      final message = data['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message.trim();
      }

      final errorText = data['error'];
      if (errorText is String && errorText.trim().isNotEmpty) {
        return errorText.trim();
      }
    }

    return error.message ?? error.toString();
  }

  @override
  Widget build(BuildContext context) {
    final api = ref.watch(absApiProvider);
    final currentUser = ref.watch(currentUserProvider).value;
    final selectedLibrary = ref.watch(selectedLibraryProvider);

    if (api == null || currentUser == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (selectedLibrary == null) {
      return const Center(child: Text('No library selected. Select a library to add podcasts.'));
    }

    if (selectedLibrary.mediaType != 'podcast') {
      return const Center(child: Text('Switch to a podcast library to use this tab.'));
    }

    if (!_isAdminType(currentUser.type)) {
      return const Center(child: Text('Adding podcasts requires an admin account.'));
    }

    _ensureLibraryTitlesLoaded(api: api, library: selectedLibrary);

    final isBusy = _isSearching || _isResolvingFeed;
    final hasFolders = (selectedLibrary.folders ?? const []).isNotEmpty;
    final useCompactSearchLayout = context.isMobile;
    final keyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;
    final showCompactTitle = !(useCompactSearchLayout && keyboardVisible);

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 980),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.isMobile ? 12 : 20,
            context.isMobile ? 0 : 12,
            context.isMobile ? 12 : 20,
            context.isMobile ? 0 : 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showCompactTitle) Text('Add Podcasts', style: Theme.of(context).textTheme.headlineSmall),
              SizedBox(height: showCompactTitle ? (context.isMobile ? 8 : 12) : 4),
              if (useCompactSearchLayout)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) {
                        if (!hasFolders || isBusy) {
                          return;
                        }
                        unawaited(_handleSearch(api: api, library: selectedLibrary));
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Search podcasts or paste RSS URL',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _searchController.text.trim().isEmpty
                            ? null
                            : IconButton(
                                tooltip: 'Clear',
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _searchResults = const <PodcastSearchResult>[];
                                    _searchError = null;
                                  });
                                },
                                icon: const Icon(Icons.close_rounded),
                              ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    if (!keyboardVisible) ...[
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: TextboxButton(
                          label: 'Search',
                          icon: Icons.search_rounded,
                          isLoading: isBusy,
                          onPressed: (!hasFolders || isBusy)
                              ? null
                              : () {
                                  unawaited(_handleSearch(api: api, library: selectedLibrary));
                                },
                        ),
                      ),
                    ],
                  ],
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (_) {
                          if (!hasFolders || isBusy) {
                            return;
                          }
                          unawaited(_handleSearch(api: api, library: selectedLibrary));
                        },
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Search podcasts or paste RSS URL',
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: _searchController.text.trim().isEmpty
                              ? null
                              : IconButton(
                                  tooltip: 'Clear',
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                      _searchResults = const <PodcastSearchResult>[];
                                      _searchError = null;
                                    });
                                  },
                                  icon: const Icon(Icons.close_rounded),
                                ),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 10),
                    TextboxButton(
                      label: 'Search',
                      icon: Icons.search_rounded,
                      isLoading: isBusy,
                      onPressed: (!hasFolders || isBusy)
                          ? null
                          : () {
                              unawaited(_handleSearch(api: api, library: selectedLibrary));
                            },
                    ),
                  ],
                ),
              if (!hasFolders) ...[
                const SizedBox(height: 12),
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'This library has no folders configured. Add at least one folder in server settings first.',
                    ),
                  ),
                ),
              ],
              if (_searchError != null) ...[
                const SizedBox(height: 12),
                Card(
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      'Search failed: $_searchError',
                      style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Expanded(
                child: _searchResults.isEmpty
                    ? _EmptyPodcastAddState(isBusy: isBusy)
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final result = _searchResults[index];
                          final existing = _matchingPodcastForResult(result);
                          return PodcastAddResultTile(
                            result: result,
                            isAlreadyInLibrary: existing != null,
                            onTap: (!hasFolders || isBusy || existing != null)
                                ? null
                                : () {
                                    unawaited(
                                      _onResultTap(
                                        api: api,
                                        library: selectedLibrary,
                                        result: result,
                                        existing: existing,
                                      ),
                                    );
                                  },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyPodcastAddState extends StatelessWidget {
  const _EmptyPodcastAddState({required this.isBusy});

  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    if (isBusy) {
      return const Center(child: CircularProgressIndicator());
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.podcasts_rounded, size: 32, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 10),
            const Text('No search results yet', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            const Text(
              'Search by podcast name, or paste an RSS feed URL to add a podcast directly.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
