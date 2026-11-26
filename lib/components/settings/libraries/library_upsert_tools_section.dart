import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/util/l10n.dart';

class LibraryUpsertToolsSection extends ConsumerStatefulWidget {
  const LibraryUpsertToolsSection({super.key, required this.library});

  final Library? library;

  @override
  ConsumerState<LibraryUpsertToolsSection> createState() => _LibraryUpsertToolsSectionState();
}

class _LibraryUpsertToolsSectionState extends ConsumerState<LibraryUpsertToolsSection> {
  bool _isRunningToolAction = false;

  void _showMessage(ScaffoldMessengerState? messenger, String message) {
    if (messenger == null) {
      return;
    }

    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _runRemoveMetadata(String extension) async {
    final sourceLibrary = widget.library;
    if (sourceLibrary == null || _isRunningToolAction) {
      return;
    }

    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.maybeOf(context);
    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage(messenger, l10n.errorNoActiveApiClient);
      return;
    }

    setState(() {
      _isRunningToolAction = true;
    });

    try {
      final response = await api.getLibraryApi().removeLibraryMetadata(sourceLibrary.id, extension: extension);
      final payload = response.data;

      if (payload == null || !payload.found) {
        _showMessage(messenger, l10n.statusNoLibraryMetadataFilesFound(extension));
        return;
      }

      if (payload.numRemoved <= 0) {
        _showMessage(messenger, l10n.statusNoLibraryMetadataFilesRemoved(extension));
        return;
      }

      _showMessage(messenger, l10n.statusLibraryMetadataFilesRemoved(payload.numRemoved, extension));
    } catch (error) {
      _showMessage(messenger, l10n.errorRemoveLibraryMetadataFilesFailed(extension, error.toString()));
    } finally {
      if (mounted) {
        setState(() {
          _isRunningToolAction = false;
        });
      }
    }
  }

  Future<void> _runMatchAllBooks() async {
    final sourceLibrary = widget.library;
    if (sourceLibrary == null || _isRunningToolAction) {
      return;
    }

    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.maybeOf(context);
    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage(messenger, l10n.errorNoActiveApiClient);
      return;
    }

    setState(() {
      _isRunningToolAction = true;
    });

    try {
      final success = await api.getLibraryApi().matchAllBooks(sourceLibrary.id);
      if (!success) {
        _showMessage(messenger, l10n.errorStartMatchAllMetadataFailed);
        return;
      }

      _showMessage(messenger, l10n.statusMatchAllMetadataStarted);
    } catch (error) {
      _showMessage(messenger, l10n.errorMatchAllMetadataFailed(error.toString()));
    } finally {
      if (mounted) {
        setState(() {
          _isRunningToolAction = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sourceLibrary = widget.library;

    if (sourceLibrary == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            l10n.messageCreateLibraryBeforeUsingTools,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ),
      );
    }

    final isBookLibrary = sourceLibrary.mediaType == 'book';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.headingLibraryMetadataFileCleanup, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 4),
          Text(
            l10n.messageRemoveGeneratedLibraryMetadataFiles,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: _isRunningToolAction ? null : () => _runRemoveMetadata('json'),
                icon: const Icon(Icons.cleaning_services_outlined),
                label: Text(l10n.actionRemoveMetadataFile('metadata.json')),
              ),
              OutlinedButton.icon(
                onPressed: _isRunningToolAction ? null : () => _runRemoveMetadata('abs'),
                icon: const Icon(Icons.cleaning_services_outlined),
                label: Text(l10n.actionRemoveMetadataFile('metadata.abs')),
              ),
            ],
          ),
          if (isBookLibrary) ...[
            const SizedBox(height: 14),
            Divider(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.35)),
            const SizedBox(height: 10),
            Text(l10n.actionMatchAllBooks, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            Text(
              l10n.messageRunMatchAllMetadataForLibrary,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.icon(
                onPressed: _isRunningToolAction ? null : _runMatchAllBooks,
                icon: _isRunningToolAction
                    ? const SizedBox(width: 14, height: 14, child: YaabsaCircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.auto_fix_high_rounded),
                label: Text(l10n.actionStartMatchAll),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
