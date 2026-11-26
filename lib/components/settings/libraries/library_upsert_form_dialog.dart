import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/api/library/library_settings.dart';
import 'package:yaabsa/api/library/request/library_folder_payload.dart';
import 'package:yaabsa/api/search/search_provider_option.dart';
import 'package:yaabsa/components/app/item/editor/library_item_editor_shell.dart';
import 'package:yaabsa/components/common/filesystem_directory_picker_dialog.dart';
import 'package:yaabsa/components/settings/libraries/library_upsert_form_controller.dart';
import 'package:yaabsa/components/settings/libraries/library_upsert_general_section.dart';
import 'package:yaabsa/components/settings/libraries/library_upsert_scanner_schedule_sections.dart';
import 'package:yaabsa/components/settings/libraries/library_upsert_tools_section.dart';
import 'package:yaabsa/provider/common/upload_providers.dart';
import 'package:yaabsa/ui/components/dialogs/dialog_actions.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/l10n.dart';

class LibraryUpsertFormResult {
  const LibraryUpsertFormResult({
    required this.name,
    required this.mediaType,
    required this.provider,
    required this.icon,
    required this.folders,
    required this.settings,
  });

  final String name;
  final String mediaType;
  final String provider;
  final String icon;
  final List<LibraryFolderPayload> folders;
  final LibrarySettings settings;
}

Future<LibraryUpsertFormResult?> showLibraryUpsertFormDialog(BuildContext context, {Library? library}) {
  return showDialog<LibraryUpsertFormResult>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _LibraryUpsertFormDialog(library: library),
  );
}

class _LibraryUpsertFormDialog extends ConsumerStatefulWidget {
  const _LibraryUpsertFormDialog({this.library});

  final Library? library;

  @override
  ConsumerState<_LibraryUpsertFormDialog> createState() => _LibraryUpsertFormDialogState();
}

class _LibraryUpsertFormDialogState extends ConsumerState<_LibraryUpsertFormDialog> {
  late final LibraryUpsertFormController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LibraryUpsertFormController(library: widget.library);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ({String label, IconData icon}) _sectionDestination(LibraryUpsertSection section, AppLocalizations l10n) {
    return switch (section) {
      LibraryUpsertSection.settings => (label: l10n.headingLibrarySettings, icon: Icons.tune_rounded),
      LibraryUpsertSection.scanner => (label: l10n.settingsCategoryScanner, icon: Icons.document_scanner_outlined),
      LibraryUpsertSection.schedule => (label: l10n.settingsCategorySchedule, icon: Icons.schedule_rounded),
      LibraryUpsertSection.tools => (label: l10n.settingsCategoryTools, icon: Icons.build_outlined),
    };
  }

  Future<void> _browseForFolder() async {
    if (_controller.isBrowsingFolders) {
      return;
    }

    _controller.setBrowsingFolders(true);

    final initialPath = _controller.folders.isEmpty ? null : _controller.folders.last.path;
    final l10n = context.l10n;
    final selectedPath = await showFilesystemDirectoryPickerDialog(
      context,
      title: l10n.titleSelectLibraryFolder,
      initialPath: initialPath,
    );

    if (!mounted) {
      return;
    }

    if (selectedPath != null && selectedPath.trim().isNotEmpty) {
      _controller.addFolderPath(selectedPath, l10n);
    }

    if (!mounted) {
      return;
    }

    _controller.setBrowsingFolders(false);
  }

  void _submit() {
    final result = _controller.validateAndBuildResult(context.l10n);
    if (result == null) {
      return;
    }

    Navigator.of(context).pop(result);
  }

  Widget _buildSectionContent(
    LibraryUpsertSection section,
    AsyncValue<List<SearchProviderOption>> providerOptionsAsync,
  ) {
    switch (section) {
      case LibraryUpsertSection.settings:
        return LibraryUpsertGeneralSection(
          controller: _controller,
          providerOptionsAsync: providerOptionsAsync,
          onBrowseFolderPressed: _browseForFolder,
        );
      case LibraryUpsertSection.scanner:
        return LibraryUpsertScannerSection(controller: _controller);
      case LibraryUpsertSection.schedule:
        return LibraryUpsertScheduleSection(controller: _controller);
      case LibraryUpsertSection.tools:
        return LibraryUpsertToolsSection(library: widget.library);
    }
  }

  Widget _buildFooter(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final activeValidationError = _controller.activeValidationError;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (activeValidationError != null) ...[
            Text(
              activeValidationError,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.error),
            ),
            const SizedBox(height: 8),
          ],
          Align(
            alignment: Alignment.centerRight,
            child: YaabsaDialogActions(
              actionLabel: _controller.isCreate ? l10n.actionCreate : l10n.actionSave,
              actionIcon: _controller.isCreate ? Icons.add_rounded : Icons.save_rounded,
              cancelLabel: l10n.actionCancel,
              onAction: _submit,
              onCancel: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isMobile = context.isMobile;
    final isTablet = context.isTablet;
    final isDesktop = context.isDesktop;
    final colorScheme = Theme.of(context).colorScheme;

    final existingName = widget.library?.name.trim();
    final dialogTitle = existingName != null && existingName.isNotEmpty ? existingName : l10n.headingLibrarySettings;

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final providerOptionsAsync = ref.watch(uploadMetadataProvidersProvider(_controller.selectedMediaType));
        final sections = _controller.availableSections;
        final activeSection = _controller.activeSection;
        final selectedIndex = _controller.selectedSectionIndex;
        final destinations = [for (final section in sections) _sectionDestination(section, l10n)];

        return Dialog(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          insetPadding: isMobile ? EdgeInsets.zero : const EdgeInsets.all(24),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final h = constraints.maxHeight;
              final maxWidth = isDesktop
                  ? math.min(w * 0.88, 1120.0)
                  : isTablet
                  ? w * 0.94
                  : w;
              final maxHeight = isDesktop ? h * 0.9 : h;

              return ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: isMobile ? maxWidth : 0,
                  minHeight: isMobile ? maxHeight : 0,
                  maxWidth: maxWidth,
                  maxHeight: maxHeight,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(isMobile ? 0 : 24),
                  child: Material(
                    color: colorScheme.surface,
                    shape: isMobile
                        ? null
                        : RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                            side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.8)),
                          ),
                    child: LibraryItemEditorShell(
                      itemTitle: dialogTitle,
                      mobileDestinationsTitle: dialogTitle,
                      desktopTitle: dialogTitle,
                      destinations: destinations,
                      selectedIndex: selectedIndex,
                      onSelectDestination: (index) => _controller.selectSection(sections[index]),
                      showItemNavigation: false,
                      onPreviousItem: null,
                      onNextItem: null,
                      onClose: () => Navigator.of(context).pop(),
                      initialShowMobileDestinations: true,
                      expandMobileLayout: true,
                      footer: _buildFooter(context),
                      child: _buildSectionContent(activeSection, providerOptionsAsync),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
