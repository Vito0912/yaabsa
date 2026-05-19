import 'package:flutter/material.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/components/common/book_editor_sheet.dart';
import 'package:yaabsa/components/common/list_management_dialogs.dart';
import 'package:yaabsa/generated/l10n.dart';

typedef ManagedCreateListCallback =
    Future<void> Function({required String name, String? description, required List<String> bookIds});

typedef ManagedEditDetailsCallback = Future<void> Function({required String name, String? description});

typedef ManagedEditBooksCallback = Future<void> Function(List<String> bookIds);
typedef ManagedDeleteCallback = Future<void> Function();

Future<void> runManagedListMutation({
  required BuildContext context,
  required Future<void> Function() action,
  required String successMessage,
  required String errorFallback,
  bool popOnSuccess = false,
  VoidCallback? onSuccess,
}) async {
  final messenger = ScaffoldMessenger.of(context);

  try {
    await action();

    if (!context.mounted) {
      return;
    }

    if (popOnSuccess && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }

    onSuccess?.call();

    messenger.showSnackBar(SnackBar(content: Text(successMessage)));
  } catch (error) {
    if (!context.mounted) {
      return;
    }

    final message = listManagementErrorMessage(error, fallback: errorFallback);
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }
}

Future<void> createManagedListEntity({
  required BuildContext context,
  required String formTitle,
  required String booksTitle,
  required String createLabel,
  required bool selectionRequired,
  bool allowEmptyCreation = false,
  String emptyCreationLabel = 'Create empty',
  required ManagedCreateListCallback onCreate,
  required String successMessage,
  required String errorFallback,
}) async {
  final metadata = await showListManagementFormDialog(
    context: context,
    title: formTitle,
    confirmLabel: S.current.componentsCommonManagedListOperationsNext,
  );

  if (!context.mounted || metadata == null) {
    return;
  }

  final selectedBooks = await showBookEditorSheet(
    context: context,
    title: booksTitle,
    confirmLabel: createLabel,
    selectionRequired: selectionRequired,
    initialBooks: const <LibraryItem>[],
    skipLabel: allowEmptyCreation ? emptyCreationLabel : null,
  );

  if (!context.mounted || selectedBooks == null) {
    return;
  }

  await runManagedListMutation(
    context: context,
    action: () => onCreate(name: metadata.name, description: metadata.description, bookIds: selectedBooks),
    successMessage: successMessage,
    errorFallback: errorFallback,
  );
}

Future<void> editManagedListBooks({
  required BuildContext context,
  required String title,
  required String confirmLabel,
  required bool selectionRequired,
  required List<LibraryItem> initialBooks,
  required ManagedEditBooksCallback onSave,
  required String successMessage,
  required String errorFallback,
}) async {
  final selectedBooks = await showBookEditorSheet(
    context: context,
    title: title,
    confirmLabel: confirmLabel,
    selectionRequired: selectionRequired,
    initialBooks: initialBooks,
  );

  if (!context.mounted || selectedBooks == null) {
    return;
  }

  await runManagedListMutation(
    context: context,
    action: () => onSave(selectedBooks),
    successMessage: successMessage,
    errorFallback: errorFallback,
  );
}

Future<void> editManagedListDetails({
  required BuildContext context,
  required String title,
  required String initialName,
  String? initialDescription,
  required ManagedEditDetailsCallback onSave,
  required String successMessage,
  required String errorFallback,
}) async {
  final result = await showListManagementFormDialog(
    context: context,
    title: title,
    confirmLabel: S.current.componentsCommonManagedListOperationsSave,
    initialName: initialName,
    initialDescription: initialDescription,
  );

  if (!context.mounted || result == null) {
    return;
  }

  await runManagedListMutation(
    context: context,
    action: () => onSave(name: result.name, description: result.description),
    successMessage: successMessage,
    errorFallback: errorFallback,
  );
}

Future<void> deleteManagedListEntity({
  required BuildContext context,
  required String title,
  required String message,
  required ManagedDeleteCallback onDelete,
  required String successMessage,
  required String errorFallback,
  bool popOnSuccess = false,
}) async {
  final confirmed = await showListManagementDeleteDialog(context: context, title: title, message: message);

  if (!context.mounted || !confirmed) {
    return;
  }

  await runManagedListMutation(
    context: context,
    action: onDelete,
    successMessage: successMessage,
    errorFallback: errorFallback,
    popOnSuccess: popOnSuccess,
  );
}
