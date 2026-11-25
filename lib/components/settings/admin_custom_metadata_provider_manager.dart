import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:yaabsa/ui/components/buttons/action_icon_button.dart';
import 'package:yaabsa/components/common/screen_refresh_indicator.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/admin/create_custom_metadata_provider_request.dart';
import 'package:yaabsa/api/admin/custom_metadata_provider.dart';
import 'package:yaabsa/components/common/list_management_dialogs.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/util/l10n.dart';

typedef CreateCustomMetadataProviderCallback = Future<CustomMetadataProvider?> Function(
  CreateCustomMetadataProviderRequest payload,
);
typedef DeleteCustomMetadataProviderCallback = Future<void> Function(CustomMetadataProvider provider);

class AdminCustomMetadataProviderManager extends StatefulWidget {
  const AdminCustomMetadataProviderManager({
    super.key,
    required this.providers,
    required this.onRefresh,
    required this.onCreateProvider,
    required this.onDeleteProvider,
  });

  final List<CustomMetadataProvider> providers;
  final Future<void> Function() onRefresh;
  final CreateCustomMetadataProviderCallback onCreateProvider;
  final DeleteCustomMetadataProviderCallback onDeleteProvider;

  @override
  State<AdminCustomMetadataProviderManager> createState() => _AdminCustomMetadataProviderManagerState();
}

class _AdminCustomMetadataProviderManagerState extends State<AdminCustomMetadataProviderManager> {
  String? _processingProviderId;
  bool _isRefreshing = false;
  bool _isCreating = false;

  bool get _isBusy => _processingProviderId != null || _isRefreshing || _isCreating;

  Future<void> _handleRefresh() async {
    if (_isBusy) {
      return;
    }

    setState(() {
      _isRefreshing = true;
    });

    try {
      await widget.onRefresh();
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  Future<void> _showAddProviderDialog() async {
    if (_isBusy) {
      return;
    }

    final payload = await _showProviderDialog(
      title: context.l10n.headingAddCustomMetadataProvider,
      confirmLabel: context.l10n.actionAdd,
    );

    if (!mounted || payload == null) {
      return;
    }

    setState(() {
      _isCreating = true;
    });

    try {
      final provider = await widget.onCreateProvider(payload);
      if (!mounted) {
        return;
      }

      final name = provider?.name ?? payload.name;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.statusCustomMetadataProviderAdded(name))));
    } catch (error) {
      if (!mounted) {
        return;
      }

      final message = listManagementErrorMessage(
        error,
        fallback: context.l10n.errorOperationFailed(
          context.l10n.operationCreateCustomMetadataProvider,
          error.toString(),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
  }

  Future<CreateCustomMetadataProviderRequest?> _showProviderDialog({
    required String title,
    required String confirmLabel,
    String? initialName,
    String? initialUrl,
    String? initialAuthHeaderValue,
  }) {
    return showDialog<CreateCustomMetadataProviderRequest>(
      context: context,
      builder: (dialogContext) => _CreateCustomMetadataProviderDialog(
        title: title,
        confirmLabel: confirmLabel,
        initialName: initialName,
        initialUrl: initialUrl,
        initialAuthHeaderValue: initialAuthHeaderValue,
      ),
    );
  }

  Future<void> _editProvider(CustomMetadataProvider provider) async {
    if (_isBusy) {
      return;
    }

    final payload = await _showProviderDialog(
      title: context.l10n.headingEditCustomMetadataProvider,
      confirmLabel: context.l10n.actionSave,
      initialName: provider.name,
      initialUrl: provider.url,
      initialAuthHeaderValue: provider.authHeaderValue,
    );

    if (!mounted || payload == null) {
      return;
    }

    setState(() {
      _processingProviderId = provider.id;
    });

    try {
      await widget.onDeleteProvider(provider);
      final recreatedProvider = await widget.onCreateProvider(payload);
      if (!mounted) {
        return;
      }

      final name = recreatedProvider?.name ?? payload.name;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.statusCustomMetadataProviderUpdated(name))));
    } catch (error) {
      if (!mounted) {
        return;
      }

      final message = listManagementErrorMessage(
        error,
        fallback: context.l10n.errorOperationFailed(
          context.l10n.operationUpdateCustomMetadataProvider,
          error.toString(),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() {
          _processingProviderId = null;
        });
      }
    }
  }

  Future<void> _deleteProvider(CustomMetadataProvider provider) async {
    if (_isBusy) {
      return;
    }

    final confirmed = await showListManagementDeleteDialog(
      context: context,
      title: context.l10n.titleDeleteCustomMetadataProvider,
      message: context.l10n.promptDeleteCustomMetadataProvider(provider.name),
    );

    if (!mounted || !confirmed) {
      return;
    }

    setState(() {
      _processingProviderId = provider.id;
    });

    try {
      await widget.onDeleteProvider(provider);
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.statusCustomMetadataProviderDeleted(provider.name))));
    } catch (error) {
      if (!mounted) {
        return;
      }

      final message = listManagementErrorMessage(
        error,
        fallback: context.l10n.errorOperationFailed(
          context.l10n.operationDeleteCustomMetadataProvider,
          error.toString(),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() {
          _processingProviderId = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
          child: Row(
            children: [
              Spacer(),
              const SizedBox(width: 12),
              IconButton(
                tooltip: context.l10n.actionRefresh,
                onPressed: _isBusy ? null : _handleRefresh,
                icon: const Icon(Icons.refresh_outlined),
              ),
              FilledButton.icon(
                onPressed: _isBusy ? null : _showAddProviderDialog,
                icon: const Icon(Icons.add),
                label: Text(context.l10n.actionAdd),
              ),
            ],
          ),
        ),
        Expanded(
          child: ScreenRefreshIndicator(
            onRefresh: _handleRefresh,
            child: widget.providers.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                    children: [Text(context.l10n.statusNoCustomMetadataProviders)],
                  )
                : ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: widget.providers.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final provider = widget.providers[index];
                      final processingThisProvider = _processingProviderId == provider.id;

                      return Card(
                        margin: EdgeInsets.zero,
                        child: ListTile(
                          title: Text(provider.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(provider.url),
                              if (provider.authHeaderValue != null && provider.authHeaderValue!.trim().isNotEmpty)
                                Text(context.l10n.statusAuthHeaderConfigured),
                            ],
                          ),
                          trailing: processingThisProvider
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: YaabsaCircularProgressIndicator(strokeWidth: 2),
                                )
                              : SizedBox(
                                  width: 92,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        tooltip: context.l10n.actionEdit,
                                        onPressed: _isBusy ? null : () => _editProvider(provider),
                                        icon: const Icon(Icons.edit_outlined),
                                      ),
                                      YaabsaDeleteIconButton(
                                        tooltip: context.l10n.actionDelete,
                                        onPressed: _isBusy ? null : () => _deleteProvider(provider),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}

class _CreateCustomMetadataProviderDialog extends StatefulWidget {
  const _CreateCustomMetadataProviderDialog({
    required this.title,
    required this.confirmLabel,
    this.initialName,
    this.initialUrl,
    this.initialAuthHeaderValue,
  });

  final String title;
  final String confirmLabel;
  final String? initialName;
  final String? initialUrl;
  final String? initialAuthHeaderValue;

  @override
  State<_CreateCustomMetadataProviderDialog> createState() => _CreateCustomMetadataProviderDialogState();
}

class _CreateCustomMetadataProviderDialogState extends State<_CreateCustomMetadataProviderDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _urlController;
  late final TextEditingController _authController;

  var _showValidation = false;

  bool get _isNameValid => _nameController.text.trim().isNotEmpty;

  bool get _isUrlValid {
    final rawUrl = _urlController.text.trim();
    if (rawUrl.isEmpty) {
      return false;
    }

    final parsed = Uri.tryParse(rawUrl);
    if (parsed == null || !parsed.hasScheme) {
      return false;
    }

    final scheme = parsed.scheme.toLowerCase();
    return scheme == 'http' || scheme == 'https';
  }

  bool get _isFormValid => _isNameValid && _isUrlValid;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _urlController = TextEditingController(text: widget.initialUrl ?? '');
    _authController = TextEditingController(text: widget.initialAuthHeaderValue ?? '');
    _nameController.addListener(_handleFieldChange);
    _urlController.addListener(_handleFieldChange);
    _authController.addListener(_handleFieldChange);
  }

  @override
  void dispose() {
    _nameController
      ..removeListener(_handleFieldChange)
      ..dispose();
    _urlController
      ..removeListener(_handleFieldChange)
      ..dispose();
    _authController
      ..removeListener(_handleFieldChange)
      ..dispose();
    super.dispose();
  }

  void _handleFieldChange() {
    setState(() {});
  }

  void _submit() {
    if (!_isFormValid) {
      setState(() {
        _showValidation = true;
      });
      return;
    }

    final authValue = _authController.text.trim();

    Navigator.of(context).pop(
      CreateCustomMetadataProviderRequest(
        name: _nameController.text.trim(),
        url: _urlController.text.trim(),
        mediaType: 'book',
        authHeaderValue: authValue.isEmpty ? null : authValue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StyledTextField(
                controller: _nameController,
                label: context.l10n.fieldName,
                errorText: _showValidation && !_isNameValid ? context.l10n.errorNameRequired : null,
              ),
              const SizedBox(height: 12),
              StyledTextField(
                controller: _urlController,
                label: context.l10n.fieldUrl,
                hintText: 'https://example.com/path',
                errorText: _showValidation && !_isUrlValid ? context.l10n.validationHttpUrlRequired : null,
              ),
              const SizedBox(height: 12),
              StyledTextField(
                controller: _authController,
                label: context.l10n.fieldAuthHeaderValue,
                hintText: context.l10n.inputOptional,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(context.l10n.actionCancel)),
        FilledButton(onPressed: _isFormValid ? _submit : null, child: Text(widget.confirmLabel)),
      ],
    );
  }
}
