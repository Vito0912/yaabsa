import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/library_items/request/quick_match_library_item_options.dart';
import 'package:yaabsa/components/app/item/match/quick_match_options_dialog.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/l10n.dart';

Future<void> quickMatchSingleItem({
  required BuildContext context,
  required WidgetRef ref,
  required LibraryItem item,
}) async {
  final l10n = context.l10n;
  final metadata = item.media?.bookMedia?.metadata;
  final defaultProvider = _resolveLibraryDefaultProvider(ref: ref, libraryId: item.libraryId);

  final options = await showQuickMatchOptionsDialog(
    context: context,
    mediaType: 'book',
    previewItems: <LibraryItem>[item],
    title: l10n.headingQuickMatchBook,
    confirmLabel: l10n.actionRunQuickMatch,
    initialProvider: defaultProvider,
  );

  if (!context.mounted || options == null) {
    return;
  }

  final api = ref.read(absApiProvider);
  if (api == null) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.errorConnectionUnavailable)));
    }
    return;
  }

  final request = QuickMatchLibraryItemOptions(
    provider: options.provider,
    overrideCover: options.overrideCover,
    overrideDetails: options.overrideDetails,
    title: metadata?.title,
    author: metadata?.authors?.map((author) => author.name).join(', '),
    isbn: metadata?.isbn,
    asin: metadata?.asin,
  );

  try {
    final response = await api.getLibraryItemApi().quickMatchLibraryItem(item.id, request: request);

    if (!context.mounted) {
      return;
    }

    ref.invalidate(libraryItemProvider(item.id));

    final message = response.updated
        ? l10n.statusQuickMatchUpdated
        : (response.message?.trim().isNotEmpty ?? false)
        ? response.message!.trim()
        : l10n.statusQuickMatchNoChanges;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  } catch (error) {
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.errorQuickMatchFailed(error.toString()))));
  }
}

String? _resolveLibraryDefaultProvider({required WidgetRef ref, required String? libraryId}) {
  final selectedLibrary = ref.read(selectedLibraryProvider);
  if (libraryId != null && selectedLibrary?.id == libraryId && selectedLibrary?.provider.trim().isNotEmpty == true) {
    return selectedLibrary?.provider;
  }

  if (libraryId != null) {
    final userLibraries = ref.read(userLibrariesProvider).value;
    if (userLibraries != null) {
      for (final library in userLibraries) {
        if (library.id != libraryId || library.provider.trim().isEmpty) {
          continue;
        }
        return library.provider;
      }
    }
  }

  if (selectedLibrary?.provider.trim().isNotEmpty == true) {
    return selectedLibrary?.provider;
  }

  return null;
}
