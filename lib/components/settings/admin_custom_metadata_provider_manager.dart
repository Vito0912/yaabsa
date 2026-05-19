import 'package:flutter/material.dart';
import 'package:yaabsa/api/admin/create_custom_metadata_provider_request.dart';
import 'package:yaabsa/api/admin/custom_metadata_provider.dart';
import 'package:yaabsa/components/common/list_management_dialogs.dart';

import 'package:yaabsa/generated/l10n.dart';

typedef CreateCustomMetadataProviderCallback =
    Future<CustomMetadataProvider?> Function(CreateCustomMetadataProviderRequest payload);
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

    final payload = await _showProviderDialog(title: 'Add Custom Metadata Provider', confirmLabel: 'Add');

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.componentsSettingsAdminCustomMetadataProviderManagerAddedProvider(name))),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      final message = listManagementErrorMessage(error, fallback: 'Failed to create provider.');
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
      title: 'Edit Custom Metadata Provider',
      confirmLabel: 'Save',
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.componentsSettingsAdminCustomMetadataProviderManagerUpdatedProvider(name))),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      final message = listManagementErrorMessage(error, fallback: 'Failed to update provider.');
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
      title: 'Delete provider?',
      message: 'Delete custom metadata provider "${provider.name}"?',
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.current.componentsSettingsAdminCustomMetadataProviderManagerDeletedProvider(provider.name)),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      final message = listManagementErrorMessage(error, fallback: 'Failed to delete provider.');
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
                tooltip: S.current.componentsSettingsAdminCustomMetadataProviderManagerRefreshProviders,
                onPressed: _isBusy ? null : _handleRefresh,
                icon: const Icon(Icons.refresh_outlined),
              ),
              FilledButton.icon(
                onPressed: _isBusy ? null : _showAddProviderDialog,
                icon: const Icon(Icons.add),
                label: Text(S.current.componentsSettingsAdminCustomMetadataProviderManagerAdd),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: widget.providers.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                    children: [
                      Text(
                        S.current.componentsSettingsAdminCustomMetadataProviderManagerNoCustomMetadataProvidersFound,
                      ),
                    ],
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
                                Text(
                                  S.current.componentsSettingsAdminCustomMetadataProviderManagerAuthHeaderConfigured,
                                ),
                            ],
                          ),
                          trailing: processingThisProvider
                              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
                              : SizedBox(
                                  width: 92,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        tooltip:
                                            S.current.componentsSettingsAdminCustomMetadataProviderManagerEditProvider,
                                        onPressed: _isBusy ? null : () => _editProvider(provider),
                                        icon: const Icon(Icons.edit_outlined),
                                      ),
                                      IconButton(
                                        tooltip: S
                                            .current
                                            .componentsSettingsAdminCustomMetadataProviderManagerDeleteProvider,
                                        onPressed: _isBusy ? null : () => _deleteProvider(provider),
                                        icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
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
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: S.current.componentsSettingsAdminCustomMetadataProviderManagerName,
                  errorText: _showValidation && !_isNameValid ? 'Name is required.' : null,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _urlController,
                decoration: InputDecoration(
                  labelText: S.current.componentsSettingsAdminCustomMetadataProviderManagerUrl,
                  hintText: S.current.componentsSettingsAdminCustomMetadataProviderManagerHttpsExampleComPath,
                  errorText: _showValidation && !_isUrlValid ? 'Enter a valid http or https URL.' : null,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _authController,
                decoration: InputDecoration(
                  labelText: S.current.componentsSettingsAdminCustomMetadataProviderManagerAuthHeaderValue,
                  hintText: S.current.componentsSettingsAdminCustomMetadataProviderManagerOptional,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(S.current.componentsSettingsAdminCustomMetadataProviderManagerCancel),
        ),
        FilledButton(onPressed: _isFormValid ? _submit : null, child: Text(widget.confirmLabel)),
      ],
    );
  }
}
