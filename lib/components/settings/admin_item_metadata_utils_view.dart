import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/admin/create_custom_metadata_provider_request.dart';
import 'package:yaabsa/api/admin/custom_metadata_provider.dart';
import 'package:yaabsa/api/admin/metadata_term_update_response.dart';
import 'package:yaabsa/components/settings/admin_custom_metadata_provider_manager.dart';
import 'package:yaabsa/components/settings/admin_force_metadata_refresh_tool.dart';
import 'package:yaabsa/components/settings/admin_metadata_term_manager.dart';
import 'package:yaabsa/components/settings/admin_split_metadata_terms_tool.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/admin_item_metadata_tools.dart';
import 'package:yaabsa/util/setting_key.dart';

import 'package:yaabsa/generated/l10n.dart';

enum _MetadataTermType { tag, genre }

class AdminItemMetadataUtilsView extends ConsumerStatefulWidget {
  const AdminItemMetadataUtilsView({super.key});

  @override
  ConsumerState<AdminItemMetadataUtilsView> createState() => _AdminItemMetadataUtilsViewState();
}

class _AdminItemMetadataUtilsViewState extends ConsumerState<AdminItemMetadataUtilsView> {
  String? _activeUserId;
  bool _isLoading = true;
  String? _errorMessage;

  List<String> _tags = const <String>[];
  List<String> _genres = const <String>[];
  List<CustomMetadataProvider> _providers = const <CustomMetadataProvider>[];

  bool _isAdminType(String? userType) {
    final normalizedType = (userType ?? '').trim().toLowerCase();
    return normalizedType == 'admin' || normalizedType == 'root';
  }

  List<String> _sortedTerms(List<String> terms) {
    final sortedTerms = terms
        .map((term) => term.trim())
        .where((term) => term.isNotEmpty)
        .toSet()
        .toList(growable: false);

    sortedTerms.sort((first, second) => first.toLowerCase().compareTo(second.toLowerCase()));
    return sortedTerms;
  }

  List<CustomMetadataProvider> _sortedProviders(List<CustomMetadataProvider> providers) {
    final sortedProviders = List<CustomMetadataProvider>.from(providers);
    sortedProviders.sort((first, second) {
      final byName = first.name.toLowerCase().compareTo(second.name.toLowerCase());
      if (byName != 0) {
        return byName;
      }
      return first.id.compareTo(second.id);
    });
    return sortedProviders;
  }

  Future<void> _loadMetadataUtilsData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final api = ref.read(absApiProvider);
      if (api == null) {
        throw StateError('No active API client.');
      }

      final adminApi = api.getAdminApi();
      final tagsResponse = await adminApi.getTags();
      final genresResponse = await adminApi.getGenres();
      final providersResponse = await adminApi.getCustomMetadataProviders();

      if (!mounted) {
        return;
      }

      setState(() {
        _tags = _sortedTerms(tagsResponse.data?.tags ?? const <String>[]);
        _genres = _sortedTerms(genresResponse.data?.genres ?? const <String>[]);
        _providers = _sortedProviders(providersResponse.data?.providers ?? const <CustomMetadataProvider>[]);
        _errorMessage = null;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = 'Failed to load item metadata utilities: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshTags() async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      throw StateError('No active API client.');
    }

    final response = await api.getAdminApi().getTags();
    if (!mounted) {
      return;
    }

    setState(() {
      _tags = _sortedTerms(response.data?.tags ?? const <String>[]);
    });
  }

  Future<void> _refreshGenres() async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      throw StateError('No active API client.');
    }

    final response = await api.getAdminApi().getGenres();
    if (!mounted) {
      return;
    }

    setState(() {
      _genres = _sortedTerms(response.data?.genres ?? const <String>[]);
    });
  }

  Future<void> _refreshProviders() async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      throw StateError('No active API client.');
    }

    final response = await api.getAdminApi().getCustomMetadataProviders();
    if (!mounted) {
      return;
    }

    setState(() {
      _providers = _sortedProviders(response.data?.providers ?? const <CustomMetadataProvider>[]);
    });
  }

  Future<MetadataTermUpdateResponse> _renameTerm({
    required _MetadataTermType termType,
    required String currentTerm,
    required String newTerm,
  }) async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      throw StateError('No active API client.');
    }

    final adminApi = api.getAdminApi();
    final response = termType == _MetadataTermType.tag
        ? await adminApi.renameTag(tag: currentTerm, newTag: newTerm)
        : await adminApi.renameGenre(genre: currentTerm, newGenre: newTerm);

    if (termType == _MetadataTermType.tag) {
      await _refreshTags();
    } else {
      await _refreshGenres();
    }

    return response.data ?? const MetadataTermUpdateResponse();
  }

  Future<MetadataTermUpdateResponse> _deleteTerm({required _MetadataTermType termType, required String term}) async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      throw StateError('No active API client.');
    }

    final adminApi = api.getAdminApi();
    final response = termType == _MetadataTermType.tag
        ? await adminApi.deleteTag(tag: term)
        : await adminApi.deleteGenre(genre: term);

    if (termType == _MetadataTermType.tag) {
      await _refreshTags();
    } else {
      await _refreshGenres();
    }

    return response.data ?? const MetadataTermUpdateResponse();
  }

  Future<CustomMetadataProvider?> _createProvider(CreateCustomMetadataProviderRequest payload) async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      throw StateError('No active API client.');
    }

    final response = await api.getAdminApi().createCustomMetadataProvider(payload: payload);
    final createdProvider = response.data?.provider;
    await _refreshProviders();
    return createdProvider;
  }

  Future<void> _deleteProvider(CustomMetadataProvider provider) async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      throw StateError('No active API client.');
    }

    final deleted = await api.getAdminApi().deleteCustomMetadataProvider(provider.id);
    if (!deleted) {
      throw Exception('Delete request failed.');
    }

    await _refreshProviders();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return currentUserAsync.when(
      data: (currentUser) {
        if (currentUser == null) {
          return Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Text(S.current.componentsSettingsAdminItemMetadataUtilsViewNoActiveUserSignInTo),
          );
        }

        if (!_isAdminType(currentUser.type)) {
          return Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Text(S.current.componentsSettingsAdminItemMetadataUtilsViewThisPageRequiresAnAdminAccount),
          );
        }

        if (_activeUserId != currentUser.id) {
          _activeUserId = currentUser.id;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) {
              return;
            }
            unawaited(_loadMetadataUtilsData());
          });
        }

        ref.watch(userSettingsWatcherProvider);
        final forceMetadataRefreshEnabled = ref
            .read(settingsManagerProvider.notifier)
            .getUserSetting<bool>(currentUser.id, SettingKeys.toolsForceMetadataRefresh, defaultValue: false);
        final splitGenresTagsEnabled = ref
            .read(settingsManagerProvider.notifier)
            .getUserSetting<bool>(currentUser.id, SettingKeys.toolsSplitGenresTags, defaultValue: false);

        if (_isLoading && _tags.isEmpty && _genres.isEmpty && _providers.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_errorMessage != null && _errorMessage!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: _MetadataUtilsErrorCard(message: _errorMessage!, onRetry: _loadMetadataUtilsData),
                ),
              if (forceMetadataRefreshEnabled)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: AdminForceMetadataRefreshTool(onCompleted: _loadMetadataUtilsData),
                ),
              const SizedBox(height: 12),
              Expanded(
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const TabBar(
                        tabs: [
                          Tab(text: 'Manage Tags'),
                          Tab(text: 'Manage Genres'),
                          Tab(text: 'Custom Metadata Providers'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: TabBarView(
                          children: [
                            AdminMetadataTermManager(
                              entityLabel: 'tag',
                              emptyMessage: 'No tags found.',
                              items: _tags,
                              onRefresh: _refreshTags,
                              onRename: (currentTerm, newTerm) => _renameTerm(
                                termType: _MetadataTermType.tag,
                                currentTerm: currentTerm,
                                newTerm: newTerm,
                              ),
                              onDelete: (term) => _deleteTerm(termType: _MetadataTermType.tag, term: term),
                              toolbarAction: splitGenresTagsEnabled
                                  ? AdminSplitMetadataTermsTool(
                                      splitType: MetadataSplitType.tags,
                                      onCompleted: _refreshTags,
                                    )
                                  : null,
                            ),
                            AdminMetadataTermManager(
                              entityLabel: 'genre',
                              emptyMessage: 'No genres found.',
                              items: _genres,
                              onRefresh: _refreshGenres,
                              onRename: (currentTerm, newTerm) => _renameTerm(
                                termType: _MetadataTermType.genre,
                                currentTerm: currentTerm,
                                newTerm: newTerm,
                              ),
                              onDelete: (term) => _deleteTerm(termType: _MetadataTermType.genre, term: term),
                              toolbarAction: splitGenresTagsEnabled
                                  ? AdminSplitMetadataTermsTool(
                                      splitType: MetadataSplitType.genres,
                                      onCompleted: _refreshGenres,
                                    )
                                  : null,
                            ),
                            AdminCustomMetadataProviderManager(
                              providers: _providers,
                              onRefresh: _refreshProviders,
                              onCreateProvider: _createProvider,
                              onDeleteProvider: _deleteProvider,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        child: Text(
          S.current.componentsSettingsAdminItemMetadataUtilsViewFailedToLoadUserData(error),
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}

class _MetadataUtilsErrorCard extends StatelessWidget {
  const _MetadataUtilsErrorCard({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.45),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
            const SizedBox(width: 10),
            TextButton(
              onPressed: () => unawaited(onRetry()),
              child: Text(S.current.componentsSettingsAdminItemMetadataUtilsViewRetry),
            ),
          ],
        ),
      ),
    );
  }
}
