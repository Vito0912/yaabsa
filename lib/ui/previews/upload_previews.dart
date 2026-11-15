import 'package:flutter/widget_previews.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/search/search_provider_option.dart';
import 'package:yaabsa/features/upload/library_upload_panel.dart';
import 'package:yaabsa/components/app/item/library_item_upload_button.dart';
import 'package:yaabsa/features/upload/widgets/library_upload_bulk_field.dart';
import 'package:yaabsa/features/upload/widgets/library_upload_advanced_options.dart';
import 'package:yaabsa/features/upload/widgets/library_upload_drop_zone.dart';
import 'package:yaabsa/features/upload/widgets/library_upload_item_card.dart';
import 'package:yaabsa/features/upload/widgets/item_upload_file_queue.dart';
import 'package:yaabsa/features/upload/widgets/library_upload_queue_actions.dart';
import 'package:yaabsa/features/upload/widgets/upload_path_conflict_dialog.dart';
import 'package:yaabsa/features/upload/library_upload_models.dart';
import 'package:yaabsa/provider/common/upload_providers.dart';
import 'package:yaabsa/provider/core/user_providers.dart';

import 'preview_fixtures.dart';
import 'preview_theme.dart';

@Preview(name: 'Upload controls / compact', size: Size(390, 280), wrapper: yaabsaPreviewLight)
@Preview(name: 'Upload controls / compact dark', size: Size(390, 280), wrapper: yaabsaPreviewDark)
@Preview(name: 'Upload controls / compact AMOLED', size: Size(390, 280), wrapper: yaabsaPreviewAmoled)
@Preview(name: 'Upload controls / wide', size: Size(800, 220), wrapper: yaabsaPreviewLight)
@Preview(name: 'Upload controls / wide dark', size: Size(800, 220), wrapper: yaabsaPreviewDark)
@Preview(name: 'Upload controls / wide AMOLED', size: Size(800, 220), wrapper: yaabsaPreviewAmoled)
Widget uploadQueueActionsPreview() => const UploadQueueActionsPreview();

@Preview(name: 'Upload metadata fields / compact', size: Size(390, 420), wrapper: yaabsaPreviewLight)
@Preview(name: 'Upload metadata fields / compact dark', size: Size(390, 420), wrapper: yaabsaPreviewDark)
@Preview(name: 'Upload metadata fields / compact AMOLED', size: Size(390, 420), wrapper: yaabsaPreviewAmoled)
@Preview(name: 'Upload metadata fields / wide', size: Size(800, 260), wrapper: yaabsaPreviewLight)
@Preview(name: 'Upload metadata fields / wide dark', size: Size(800, 260), wrapper: yaabsaPreviewDark)
@Preview(name: 'Upload metadata fields / wide AMOLED', size: Size(800, 260), wrapper: yaabsaPreviewAmoled)
Widget uploadBulkMetadataPreview() => const UploadBulkMetadataPreview();

@Preview(name: 'Upload item / compact / light', size: Size(480, 720), wrapper: yaabsaPreviewLight)
@Preview(name: 'Upload item / compact / dark', size: Size(480, 720), wrapper: yaabsaPreviewDark)
@Preview(name: 'Upload item / compact / AMOLED', size: Size(480, 720), wrapper: yaabsaPreviewAmoled)
Widget uploadItemCompactPreview() => const UploadItemCardPreview(compact: true);

@Preview(name: 'Upload item / responsive breakpoint / light', size: Size(504, 720), wrapper: yaabsaPreviewLight)
@Preview(name: 'Upload item / responsive breakpoint / dark', size: Size(504, 720), wrapper: yaabsaPreviewDark)
@Preview(name: 'Upload item / responsive breakpoint / AMOLED', size: Size(504, 720), wrapper: yaabsaPreviewAmoled)
Widget uploadItemBreakpointPreview() => const UploadItemCardPreview(compact: true, maxWidth: 472);

@Preview(name: 'Upload item / wide / light', size: Size(960, 620), wrapper: yaabsaPreviewLight)
@Preview(name: 'Upload item / wide / dark', size: Size(960, 620), wrapper: yaabsaPreviewDark)
@Preview(name: 'Upload item / wide / AMOLED', size: Size(960, 620), wrapper: yaabsaPreviewAmoled)
Widget uploadItemWidePreview() => const UploadItemCardPreview(compact: false);

@Preview(name: 'Upload advanced settings / compact / light', size: Size(640, 620), wrapper: yaabsaPreviewLight)
@Preview(name: 'Upload advanced settings / compact / dark', size: Size(640, 620), wrapper: yaabsaPreviewDark)
@Preview(name: 'Upload advanced settings / compact / AMOLED', size: Size(640, 620), wrapper: yaabsaPreviewAmoled)
Widget uploadAdvancedSettingsCompactPreview() => const UploadAdvancedOptionsPreview();

@Preview(name: 'Upload advanced settings / near breakpoint / light', size: Size(740, 620), wrapper: yaabsaPreviewLight)
@Preview(name: 'Upload advanced settings / near breakpoint / dark', size: Size(740, 620), wrapper: yaabsaPreviewDark)
@Preview(
  name: 'Upload advanced settings / near breakpoint / AMOLED',
  size: Size(740, 620),
  wrapper: yaabsaPreviewAmoled,
)
Widget uploadAdvancedSettingsStackedWidePreview() => const UploadAdvancedOptionsPreview();

@Preview(name: 'Upload advanced settings / wide / light', size: Size(1086, 520), wrapper: yaabsaPreviewLight)
@Preview(name: 'Upload advanced settings / wide / dark', size: Size(1086, 520), wrapper: yaabsaPreviewDark)
@Preview(name: 'Upload advanced settings / wide / AMOLED', size: Size(1086, 520), wrapper: yaabsaPreviewAmoled)
Widget uploadAdvancedSettingsWidePreview() => const UploadAdvancedOptionsPreview();

@Preview(name: 'Upload drop zone / light', size: Size(720, 260), wrapper: yaabsaPreviewLight)
@Preview(name: 'Upload drop zone / dark', size: Size(720, 260), wrapper: yaabsaPreviewDark)
@Preview(name: 'Upload drop zone / AMOLED', size: Size(720, 260), wrapper: yaabsaPreviewAmoled)
Widget uploadDropZonePreview() => const UploadDropZonePreview();

@Preview(name: 'Upload workspace / medium / light', size: Size(800, 800), wrapper: yaabsaPreviewLight)
@Preview(name: 'Upload workspace / medium / dark', size: Size(800, 800), wrapper: yaabsaPreviewDark)
@Preview(name: 'Upload workspace / medium / AMOLED', size: Size(800, 800), wrapper: yaabsaPreviewAmoled)
@Preview(name: 'Upload workspace / wide / light', size: Size(1086, 800), wrapper: yaabsaPreviewLight)
@Preview(name: 'Upload workspace / wide / dark', size: Size(1086, 800), wrapper: yaabsaPreviewDark)
@Preview(name: 'Upload workspace / wide / AMOLED', size: Size(1086, 800), wrapper: yaabsaPreviewAmoled)
Widget uploadWorkspacePreview() => const UploadWorkspacePreview();

@Preview(name: 'Add book files / phone', size: Size(390, 800), wrapper: yaabsaPreviewLight)
@Preview(name: 'Add book files / desktop', size: Size(900, 800), wrapper: yaabsaPreviewDark)
Widget itemUploadWorkspacePreview() => const UploadWorkspacePreview(addToBook: true);

@Preview(name: 'Add book files / queue', size: Size(390, 720), wrapper: yaabsaPreviewLight)
Widget itemUploadQueuePreview() {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: ItemUploadFileQueue(
      items: [previewUploadItemDraft().copyWith(clearPendingMetadata: true)],
      enabled: true,
      onRemoveFile: _ignoreQueuedFileRemoval,
    ),
  );
}

@Preview(name: 'Upload path conflicts / light', size: Size(640, 520), wrapper: yaabsaPreviewLight)
@Preview(name: 'Upload path conflicts / dark', size: Size(640, 520), wrapper: yaabsaPreviewDark)
@Preview(name: 'Upload path conflicts / AMOLED', size: Size(640, 520), wrapper: yaabsaPreviewAmoled)
Widget uploadPathConflictsPreview() => const UploadPathConflictDialog(
  conflicts: [
    'Mira Ellery/The Tidemark Stories/The Distant Shore already exists.',
    'Jonas Vale/Winter at Low Tide has an invalid destination path.',
    'Alexandria Montgomery Vale/The North Window could not be checked.',
  ],
);

class UploadPathConflictDialogLauncher extends StatelessWidget {
  const UploadPathConflictDialogLauncher({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FilledButton.icon(
        onPressed: () async {
          await showDialog<void>(context: context, builder: (context) => uploadPathConflictsPreview());
        },
        icon: const Icon(Icons.rule_folder_outlined),
        label: const Text('Review upload paths'),
      ),
    );
  }
}

class UploadWorkspacePreview extends StatelessWidget {
  const UploadWorkspacePreview({super.key, this.addToBook = false});

  final bool addToBook;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        absApiProvider.overrideWithValue(null),
        currentUserProvider.overrideWith((ref) => Stream.value(previewAdminUser())),
        uploadMetadataProvidersProvider('book')
            .overrideWith((ref) async => const [SearchProviderOption(value: 'Audible.com', text: 'Audible.com')]),
      ],
      child: addToBook
          ? LibraryItemUploadDialog(library: previewUploadLibrary(), destination: previewItemUploadDestination())
          : LibraryUploadPanel(
              selectedLibrary: previewUploadLibrary(),
              onClose: _ignoreUploadAction,
              advancedOptionsInitiallyExpanded: true,
            ),
    );
  }
}

class UploadQueueActionsPreview extends StatelessWidget {
  const UploadQueueActionsPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ready to upload', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            const LibraryUploadQueueActions(
              isUploading: false,
              hasQueuedItems: true,
              onClear: _ignoreUploadAction,
              onStart: _ignoreUploadAction,
            ),
            const SizedBox(height: 20),
            Text('Upload in progress', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            const LibraryUploadQueueActions(
              isUploading: true,
              hasQueuedItems: true,
              onClear: _ignoreUploadAction,
              onCancel: _ignoreUploadAction,
              onStart: _ignoreUploadAction,
            ),
          ],
        ),
      ),
    );
  }
}

class UploadBulkMetadataPreview extends StatefulWidget {
  const UploadBulkMetadataPreview({super.key});

  @override
  State<UploadBulkMetadataPreview> createState() => _UploadBulkMetadataPreviewState();
}

class _UploadBulkMetadataPreviewState extends State<UploadBulkMetadataPreview> {
  final _authorController = TextEditingController(text: 'Alexandria Montgomery Vale');
  final _seriesController = TextEditingController(text: 'The Tidemark Stories');

  @override
  void dispose() {
    _authorController.dispose();
    _seriesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Bulk update queue metadata', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        LibraryUploadBulkField(
          label: 'Author for all items',
          applyLabel: 'Apply author',
          controller: _authorController,
          onApply: _ignoreUploadAction,
        ),
        const SizedBox(height: 10),
        LibraryUploadBulkField(
          label: 'Series for all items',
          applyLabel: 'Apply series',
          controller: _seriesController,
          onApply: _ignoreUploadAction,
        ),
      ],
    );
  }
}

class UploadItemCardPreview extends StatelessWidget {
  const UploadItemCardPreview({super.key, required this.compact, this.maxWidth});

  final bool compact;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final maximumWidth = maxWidth ?? (compact ? 448.0 : 928.0);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maximumWidth),
          child: LibraryUploadItemCard(
            item: previewUploadItemDraft(),
            enabled: true,
            canFetchMetadata: true,
            onChanged: _ignoreUploadItemChange,
            onRemove: _ignoreUploadAction,
            onFetchMetadata: _ignoreUploadAction,
            onAcceptPendingMetadata: _ignoreUploadAction,
            onRejectPendingMetadata: _ignoreUploadAction,
            authorSuggestions: const ['Mira Ellery', 'Jonas Vale'],
            seriesSuggestions: const ['The Tidemark Stories'],
          ),
        ),
      ),
    );
  }
}

class UploadAdvancedOptionsPreview extends StatefulWidget {
  const UploadAdvancedOptionsPreview({super.key});

  @override
  State<UploadAdvancedOptionsPreview> createState() => _UploadAdvancedOptionsPreviewState();
}

class _UploadAdvancedOptionsPreviewState extends State<UploadAdvancedOptionsPreview> {
  final _authorController = TextEditingController(text: 'Alexandria Montgomery Vale');
  final _seriesController = TextEditingController(text: 'The Tidemark Stories');
  bool _autoFetchMetadata = true;
  bool _autoAcceptMetadata = true;
  bool _autocompleteSeriesAndAuthors = true;

  @override
  void dispose() {
    _authorController.dispose();
    _seriesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: LibraryUploadAdvancedOptions(
        initiallyExpanded: true,
        autoFetchMetadata: _autoFetchMetadata,
        autoAcceptMetadata: _autoAcceptMetadata,
        autocompleteSeriesAndAuthors: _autocompleteSeriesAndAuthors,
        enabled: true,
        canEditAutocomplete: true,
        isAdminUser: true,
        isLoadingAutocompleteSuggestions: false,
        canApplyBulk: false,
        bulkAuthorController: _authorController,
        bulkSeriesController: _seriesController,
        onAutoFetchMetadataChanged: (value) => setState(() => _autoFetchMetadata = value),
        onAutoAcceptMetadataChanged: (value) => setState(() => _autoAcceptMetadata = value),
        onAutocompleteChanged: (value) => setState(() => _autocompleteSeriesAndAuthors = value),
        onApplyAuthor: _ignoreUploadAction,
        onApplySeries: _ignoreUploadAction,
      ),
    );
  }
}

class UploadDropZonePreview extends StatelessWidget {
  const UploadDropZonePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: LibraryUploadDropZone(
        supportsDragDrop: true,
        isDropHovering: false,
        enabled: true,
        onChooseFiles: _ignoreUploadAction,
        onChooseFolder: _ignoreUploadAction,
      ),
    );
  }
}

void _ignoreUploadAction() {}

void _ignoreUploadItemChange(UploadItemDraft _) {}

void _ignoreQueuedFileRemoval(int itemId, UploadPickedFile file) {}
