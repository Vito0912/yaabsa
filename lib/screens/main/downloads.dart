import 'package:yaabsa/components/app/downloads/download_list_tile.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/models/internal_download.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Downloads extends ConsumerStatefulWidget {
  const Downloads({super.key});

  @override
  ConsumerState<Downloads> createState() => _DownloadsState();
}

class _DownloadsState extends ConsumerState<Downloads> {
  final Set<String> _selectedDownloadKeys = <String>{};
  bool _selectionMode = false;
  bool _isDeleting = false;

  String? _downloadKeyFor(InternalDownload download) {
    final itemId = download.item?.id ?? download.episode?.libraryItemId;
    if (itemId == null) {
      return null;
    }
    final episodeId = download.episode?.id ?? '';
    return '$itemId::$episodeId';
  }

  bool _isSelected(InternalDownload download) {
    final key = _downloadKeyFor(download);
    if (key == null) {
      return false;
    }
    return _selectedDownloadKeys.contains(key);
  }

  void _setSelectionMode(bool enabled) {
    if (_selectionMode == enabled) {
      return;
    }

    setState(() {
      _selectionMode = enabled;
      if (!enabled) {
        _selectedDownloadKeys.clear();
      }
    });
  }

  void _toggleSelection(InternalDownload download) {
    final key = _downloadKeyFor(download);
    if (key == null) {
      return;
    }

    setState(() {
      _selectionMode = true;
      if (_selectedDownloadKeys.contains(key)) {
        _selectedDownloadKeys.remove(key);
      } else {
        _selectedDownloadKeys.add(key);
      }

      if (_selectedDownloadKeys.isEmpty) {
        _selectionMode = false;
      }
    });
  }

  Future<bool> _confirmDelete(int count) async {
    final label = count == 1 ? 'this download' : 'these $count downloads';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete download'),
        content: Text('Delete $label from local storage and remove it from Downloads?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Delete')),
        ],
      ),
    );

    return confirmed ?? false;
  }

  Future<void> _deleteDownloads({required String userId, required List<InternalDownload> downloads}) async {
    if (_isDeleting || downloads.isEmpty) {
      return;
    }

    final confirmed = await _confirmDelete(downloads.length);
    if (!confirmed) {
      return;
    }

    setState(() {
      _isDeleting = true;
    });

    var deletedItems = 0;
    var deletedFiles = 0;
    var failedFiles = 0;
    var failedItems = 0;

    for (final download in downloads) {
      try {
        final result = await downloadHandler.deleteDownloadedItem(download, userId: userId);
        deletedItems++;
        deletedFiles += result.deletedFiles;
        failedFiles += result.failedFiles;
      } catch (_) {
        failedItems++;
      }
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _isDeleting = false;
      _selectionMode = false;
      _selectedDownloadKeys.clear();
    });

    final message = StringBuffer()..write('Deleted $deletedItems item(s), removed $deletedFiles file(s).');
    if (failedFiles > 0) {
      message.write(' $failedFiles file(s) could not be removed.');
    }
    if (failedItems > 0) {
      message.write(' $failedItems item(s) failed to delete.');
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message.toString())));
  }

  @override
  Widget build(BuildContext context) {
    final appDatabase = ref.watch(appDatabaseProvider);
    final currentUser = ref.watch(currentUserProvider);

    return currentUser.when(
      data: (user) {
        if (user == null) {
          return const Center(child: Text('No active user.'));
        }

        return StreamBuilder<List<InternalDownload>>(
          stream: appDatabase.watchStoredDownloadsByUser(user.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final downloads = snapshot.data ?? const <InternalDownload>[];
            if (downloads.isEmpty) {
              return const Center(child: Text('No downloads available.'));
            }

            final validKeys = downloads.map(_downloadKeyFor).whereType<String>().toSet();
            if (_selectedDownloadKeys.any((key) => !validKeys.contains(key))) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  _selectedDownloadKeys.removeWhere((key) => !validKeys.contains(key));
                  if (_selectedDownloadKeys.isEmpty) {
                    _selectionMode = false;
                  }
                });
              });
            }

            final selectedDownloads = downloads.where(_isSelected).toList(growable: false);

            return Column(
              children: [
                if (_isDeleting) const LinearProgressIndicator(minHeight: 2),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectionMode
                              ? '${_selectedDownloadKeys.length} selected'
                              : '${downloads.length} downloaded item(s)',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                      if (!_selectionMode)
                        TextButton.icon(
                          onPressed: _isDeleting ? null : () => _setSelectionMode(true),
                          icon: const Icon(Icons.checklist_rtl),
                          label: const Text('Select'),
                        ),
                      if (_selectionMode)
                        TextButton(
                          onPressed: _isDeleting ? null : () => _setSelectionMode(false),
                          child: const Text('Cancel'),
                        ),
                      if (_selectionMode) const SizedBox(width: 8),
                      if (_selectionMode)
                        FilledButton.icon(
                          onPressed: _isDeleting || selectedDownloads.isEmpty
                              ? null
                              : () => _deleteDownloads(userId: user.id, downloads: selectedDownloads),
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Delete'),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: downloads.length,
                    itemBuilder: (context, index) {
                      final download = downloads[index];
                      final targetItemId = download.item?.id ?? download.episode?.libraryItemId;

                      return DownloadListTile(
                        download: download,
                        selectionMode: _selectionMode,
                        isDeleting: _isDeleting,
                        isSelected: _isSelected(download),
                        onToggleSelection: () => _toggleSelection(download),
                        onDelete: () => _deleteDownloads(userId: user.id, downloads: [download]),
                        onOpen: targetItemId == null ? null : () => context.push('/item/$targetItemId'),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }
}
