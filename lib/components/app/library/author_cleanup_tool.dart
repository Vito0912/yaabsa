import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/api/library/library_author.dart';
import 'package:yaabsa/api/library/request/library_author_sort.dart';
import 'package:yaabsa/api/library/request/library_items_request.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/common/library_author_provider.dart';
import 'package:yaabsa/provider/common/library_filter_data_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/setting_key.dart';

const int _authorCleanupPageSize = 100;

class RemoveAuthorsWithoutBooksTool extends ConsumerStatefulWidget {
  const RemoveAuthorsWithoutBooksTool({super.key, required this.libraryId});

  final String libraryId;

  @override
  ConsumerState<RemoveAuthorsWithoutBooksTool> createState() => _RemoveAuthorsWithoutBooksToolState();
}

class _RemoveAuthorsWithoutBooksToolState extends ConsumerState<RemoveAuthorsWithoutBooksTool> {
  bool _isRunning = false;

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider).value;
    ref.watch(userSettingsWatcherProvider);

    final removeAuthorsWithoutBooksEnabled = currentUser == null
        ? false
        : ref
              .read(settingsManagerProvider.notifier)
              .getUserSetting<bool>(currentUser.id, SettingKeys.toolsRemoveAuthorsWithoutBooks, defaultValue: false);
    final canDeleteAuthors = currentUser?.permissions.delete ?? false;

    if (!removeAuthorsWithoutBooksEnabled || !canDeleteAuthors) {
      return const SizedBox.shrink();
    }

    return FilledButton.icon(
      onPressed: _isRunning ? null : _removeAuthorsWithoutBooks,
      icon: _isRunning
          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2.2))
          : const Icon(Icons.cleaning_services_outlined),
      label: Text(_isRunning ? 'Checking Authors...' : 'Remove Authors Without Books'),
    );
  }

  Future<void> _removeAuthorsWithoutBooks() async {
    if (_isRunning) {
      return;
    }

    setState(() {
      _isRunning = true;
    });

    final messenger = ScaffoldMessenger.of(context);
    final api = ref.read(absApiProvider);
    if (api == null) {
      messenger.showSnackBar(const SnackBar(content: Text('You are offline. Please reconnect and try again.')));
      if (mounted) {
        setState(() {
          _isRunning = false;
        });
      }
      return;
    }

    final progress = ValueNotifier<_AuthorCleanupProgress>(
      const _AuthorCleanupProgress(title: 'Scanning Authors', message: 'Preparing to load authors...'),
    );
    var progressDialogOpen = false;

    void openProgressDialog() {
      if (!mounted || progressDialogOpen) {
        return;
      }

      progressDialogOpen = true;
      unawaited(
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (_) => _AuthorCleanupProgressDialog(progress: progress),
        ).then((_) {
          progressDialogOpen = false;
        }),
      );
    }

    void closeProgressDialog() {
      if (!mounted || !progressDialogOpen) {
        return;
      }

      progressDialogOpen = false;
      Navigator.of(context, rootNavigator: true).pop();
    }

    try {
      openProgressDialog();
      final authorsWithoutBooks = await _loadAuthorsWithoutBooks(progress: progress);

      closeProgressDialog();
      if (!mounted) {
        return;
      }

      if (authorsWithoutBooks.isEmpty) {
        await _showNoAuthorsDialog();
        return;
      }

      final confirmed = await _showConfirmDeleteAuthorsDialog(authorsWithoutBooks);
      if (!confirmed || !mounted) {
        return;
      }

      openProgressDialog();
      final total = authorsWithoutBooks.length;
      var deletedCount = 0;
      final failedAuthors = <LibraryAuthor>[];

      for (var index = 0; index < total; index++) {
        final author = authorsWithoutBooks[index];
        progress.value = _AuthorCleanupProgress(
          title: 'Deleting Authors',
          message: 'Deleting ${author.name} (${index + 1}/$total)...',
          completed: index + 1,
          total: total,
        );

        final deleted = await api.getLibraryApi().deleteAuthor(author.id);
        if (deleted) {
          deletedCount++;
        } else {
          failedAuthors.add(author);
        }
      }

      closeProgressDialog();
      if (!mounted) {
        return;
      }

      ref.invalidate(libraryFilterDataProvider(widget.libraryId));
      await ref.read(libraryAuthorsProvider(widget.libraryId).notifier).refresh(withLoading: false);

      final failedCount = failedAuthors.length;
      final message = StringBuffer('Deleted $deletedCount author(s) without books.');
      if (failedCount > 0) {
        final preview = failedAuthors.take(4).map((author) => author.name).join(', ');
        final suffix = failedCount > 4 ? ', ...' : '';
        message.write(' $failedCount failed: $preview$suffix');
      }

      messenger.showSnackBar(SnackBar(content: Text(message.toString())));
    } catch (error) {
      closeProgressDialog();
      if (mounted) {
        messenger.showSnackBar(SnackBar(content: Text('Could not remove authors without books: $error')));
      }
    } finally {
      progress.dispose();
      if (mounted) {
        setState(() {
          _isRunning = false;
        });
      }
    }
  }

  Future<void> _showNoAuthorsDialog() {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('No Authors To Remove'),
        content: const Text('No authors with 0 books were found.'),
        actions: [TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Close'))],
      ),
    );
  }

  Future<List<LibraryAuthor>> _loadAuthorsWithoutBooks({
    required ValueNotifier<_AuthorCleanupProgress> progress,
  }) async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      throw Exception('User not authenticated or API not available.');
    }

    final resultById = <String, LibraryAuthor>{};
    var page = 0;
    var scannedAuthors = 0;

    while (true) {
      progress.value = _AuthorCleanupProgress(
        title: 'Scanning Authors',
        message: 'Loading page ${page + 1} (size $_authorCleanupPageSize)...',
      );

      final response = await api.getLibraryApi().getLibraryAuthors(
        widget.libraryId,
        LibraryItemsRequest(
          limit: _authorCleanupPageSize,
          page: page,
          sort: LibraryAuthorSortValue.numBooks.wireValue,
          desc: 0,
          include: defaultLibraryAuthorInclude,
        ),
      );

      final payload = response.data;
      if (payload == null || payload.results.isEmpty) {
        break;
      }

      final pageAuthors = payload.results;
      scannedAuthors += pageAuthors.length;

      for (final author in pageAuthors) {
        if (author.numBooks == 0) {
          resultById[author.id] = author;
        }
      }

      progress.value = _AuthorCleanupProgress(
        title: 'Scanning Authors',
        message: 'Checked $scannedAuthors author(s), found ${resultById.length} with 0 books.',
      );

      final reachedEndByCount = payload.total > 0 && scannedAuthors >= payload.total;
      final reachedEndByPage = pageAuthors.length < _authorCleanupPageSize;
      final reachedEndBySortBoundary = pageAuthors.last.numBooks > 0;
      if (reachedEndByCount || reachedEndByPage || reachedEndBySortBoundary) {
        break;
      }

      page++;
    }

    final results = resultById.values.toList(growable: false)
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return results;
  }

  Future<bool> _showConfirmDeleteAuthorsDialog(List<LibraryAuthor> authors) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Delete ${authors.length} Author${authors.length == 1 ? '' : 's'}?'),
          content: SizedBox(
            width: 460,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('These authors have 0 books and will be removed permanently:'),
                const SizedBox(height: 10),
                Container(
                  constraints: const BoxConstraints(maxHeight: 260),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Theme.of(dialogContext).colorScheme.outlineVariant),
                  ),
                  child: _AuthorDeletionPreviewList(authors: authors),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: const Text('Cancel')),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text('Delete ${authors.length}'),
            ),
          ],
        );
      },
    );

    return confirmed ?? false;
  }
}

class _AuthorCleanupProgress {
  const _AuthorCleanupProgress({required this.title, required this.message, this.completed, this.total});

  final String title;
  final String message;
  final int? completed;
  final int? total;
}

class _AuthorCleanupProgressDialog extends StatelessWidget {
  const _AuthorCleanupProgressDialog({required this.progress});

  final ValueListenable<_AuthorCleanupProgress> progress;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<_AuthorCleanupProgress>(
      valueListenable: progress,
      builder: (context, value, _) {
        final hasBoundedProgress = value.total != null && value.total! > 0;
        final progressValue = hasBoundedProgress && value.completed != null
            ? value.completed!.clamp(0, value.total!) / value.total!
            : null;

        return AlertDialog(
          title: Text(value.title),
          content: SizedBox(
            width: 340,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value.message),
                const SizedBox(height: 14),
                if (hasBoundedProgress)
                  LinearProgressIndicator(value: progressValue, minHeight: 6)
                else
                  const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.4)),
                if (hasBoundedProgress && value.completed != null) ...[
                  const SizedBox(height: 10),
                  Text('${value.completed}/${value.total}'),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AuthorDeletionPreviewList extends StatefulWidget {
  const _AuthorDeletionPreviewList({required this.authors});

  final List<LibraryAuthor> authors;

  @override
  State<_AuthorDeletionPreviewList> createState() => _AuthorDeletionPreviewListState();
}

class _AuthorDeletionPreviewListState extends State<_AuthorDeletionPreviewList> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: ListView.separated(
        controller: _scrollController,
        primary: false,
        itemCount: widget.authors.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (_, index) {
          final author = widget.authors[index];
          return ListTile(
            dense: true,
            title: Text(author.name, maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Text(_bookCountLabel(author.numBooks)),
          );
        },
      ),
    );
  }
}

String _bookCountLabel(int numBooks) => '$numBooks ${numBooks == 1 ? 'book' : 'books'}';
