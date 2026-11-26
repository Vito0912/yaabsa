import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/common/list_management_dialogs.dart';
import 'package:yaabsa/provider/common/library_filter_data_provider.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/common/series_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/ui/components/dialogs/dialog_actions.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/util/rename_series_tool.dart';

Future<String?> showRenameSeriesDialog(
  BuildContext context,
  WidgetRef ref, {
  required String libraryId,
  required String seriesId,
  required String currentName,
}) async {
  final api = ref.read(absApiProvider);
  final messenger = ScaffoldMessenger.of(context);
  final l10n = context.l10n;

  if (api == null) {
    messenger.showSnackBar(SnackBar(content: Text(l10n.errorConnectionUnavailable)));
    return null;
  }

  final result = await showDialog<_RenameSeriesDialogResult>(
    context: context,
    builder: (dialogContext) {
      return _RenameSeriesDialog(libraryId: libraryId, seriesId: seriesId, currentName: currentName);
    },
  );

  if (result == null) {
    return null;
  }

  if (result.booksUpdated > 0) {
    messenger.showSnackBar(SnackBar(content: Text(l10n.statusSeriesRenamed(result.booksUpdated))));
  }

  return result.newName;
}

class _RenameSeriesDialogResult {
  const _RenameSeriesDialogResult({required this.newName, required this.booksUpdated});

  final String newName;
  final int booksUpdated;
}

class _RenameSeriesDialog extends ConsumerStatefulWidget {
  const _RenameSeriesDialog({required this.libraryId, required this.seriesId, required this.currentName});

  final String libraryId;
  final String seriesId;
  final String currentName;

  @override
  ConsumerState<_RenameSeriesDialog> createState() => _RenameSeriesDialogState();
}

class _RenameSeriesDialogState extends ConsumerState<_RenameSeriesDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  bool _isSaving = false;
  String? _errorMessage;

  String get _trimmedName => _nameController.text.trim();

  bool get _canSave => _trimmedName.isNotEmpty && _trimmedName != widget.currentName.trim();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _nameController.selection = TextSelection(baseOffset: 0, extentOffset: widget.currentName.length);
    _nameController.addListener(_handleNameChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_handleNameChanged);
    _nameController.dispose();
    super.dispose();
  }

  void _handleNameChanged() {
    setState(() {});
  }

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) {
      return context.l10n.errorEnterSeriesName;
    }

    return null;
  }

  void _invalidateSeriesProviders() {
    ref.invalidate(seriesProvider(widget.libraryId));
    ref.invalidate(seriesByIdProvider(widget.seriesId));
    ref.invalidate(seriesBooksProvider(SeriesBooksArgs(libraryId: widget.libraryId, seriesId: widget.seriesId)));
    ref.invalidate(libraryItemsProvider);
    ref.invalidate(libraryFilterDataProvider(widget.libraryId));
  }

  Future<void> _submit() async {
    if (_isSaving) {
      return;
    }

    final formState = _formKey.currentState;
    if (formState == null || !formState.validate() || !_canSave) {
      return;
    }

    final api = ref.read(absApiProvider);
    final fallbackMessage = context.l10n.errorNamedEntityUpdateFailed(context.l10n.fieldSeries);
    final newName = _trimmedName;

    if (api == null) {
      setState(() {
        _errorMessage = context.l10n.errorConnectionUnavailable;
      });
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final result = await runRenameSeriesTool(
        api: api,
        libraryId: widget.libraryId,
        seriesId: widget.seriesId,
        newName: newName,
      );

      if (!mounted) {
        return;
      }

      _invalidateSeriesProviders();

      Navigator.of(context).pop(_RenameSeriesDialogResult(newName: newName, booksUpdated: result.booksUpdated));
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
        _errorMessage = listManagementErrorMessage(error, fallback: fallbackMessage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final errorMessage = _errorMessage;

    return AlertDialog(
      title: Text(context.l10n.actionRenameSeries),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StyledTextFormField(
                  controller: _nameController,
                  autofocus: true,
                  enabled: !_isSaving,
                  label: context.l10n.fieldNewSeriesName,
                  textInputAction: TextInputAction.done,
                  validator: _validateName,
                  onFieldSubmitted: (_) => _submit(),
                ),
                if (errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(errorMessage, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.error)),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        YaabsaDialogActions(
          cancelLabel: context.l10n.actionCancel,
          actionLabel: context.l10n.actionSave,
          actionIcon: Icons.check_rounded,
          isLoading: _isSaving,
          onCancel: _isSaving ? null : () => Navigator.of(context).pop(),
          onAction: _canSave && !_isSaving ? _submit : null,
        ),
      ],
    );
  }
}
