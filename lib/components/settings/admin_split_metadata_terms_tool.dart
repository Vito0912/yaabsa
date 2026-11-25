import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';

import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/components/settings/admin_tool_library_selector.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/admin_item_metadata_tools.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/util/l10n.dart';

class AdminSplitMetadataTermsTool extends ConsumerWidget {
  const AdminSplitMetadataTermsTool({super.key, required this.splitType, this.onCompleted});

  final MetadataSplitType splitType;
  final Future<void> Function()? onCompleted;

  String get _termType => splitType == MetadataSplitType.tags ? 'tag' : 'genre';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledButton.icon(
      onPressed: () => _openDialog(context, ref),
      icon: const Icon(Icons.call_split_outlined),
      label: Text(context.l10n.metadataSplitTerms(_termType)),
    );
  }

  Future<void> _openDialog(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final api = ref.read(absApiProvider);
    if (api == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.errorNoActiveApiClient)));
      return;
    }

    final result = await showDialog<SplitMetadataTermsToolResult>(
      context: context,
      builder: (dialogContext) => _SplitMetadataTermsDialog(api: api, splitType: splitType),
    );

    if (!context.mounted || result == null) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.statusMetadataTermsSplit(
            _termType,
            result.termsSplit,
            result.itemsChanged,
            result.itemsUpdated,
            result.librariesProcessed,
          ),
        ),
      ),
    );

    if (onCompleted != null) {
      await onCompleted!();
    }
  }
}

class _SplitMetadataTermsDialog extends StatefulWidget {
  const _SplitMetadataTermsDialog({required this.api, required this.splitType});

  final ABSApi api;
  final MetadataSplitType splitType;

  @override
  State<_SplitMetadataTermsDialog> createState() => _SplitMetadataTermsDialogState();
}

class _SplitMetadataTermsDialogState extends State<_SplitMetadataTermsDialog> {
  final TextEditingController _delimiterController = TextEditingController(text: ',');

  bool _isLoadingLibraries = true;
  bool _isRunning = false;
  String? _errorMessage;

  List<Library> _libraries = const <Library>[];
  Set<String> _selectedLibraryIds = <String>{};

  @override
  void initState() {
    super.initState();
    unawaited(_loadLibraries());
  }

  @override
  void dispose() {
    _delimiterController.dispose();
    super.dispose();
  }

  String get _termType => widget.splitType == MetadataSplitType.tags ? 'tag' : 'genre';

  Future<void> _loadLibraries() async {
    final l10n = context.l10n;
    setState(() {
      _isLoadingLibraries = true;
      _errorMessage = null;
    });

    try {
      final libraries = await fetchMetadataToolLibraries(widget.api);
      if (!mounted) {
        return;
      }

      setState(() {
        _libraries = libraries;
        _selectedLibraryIds = libraries.map((library) => library.id).toSet();
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = l10n.errorOperationFailed(l10n.operationLoadLibraries, error.toString());
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLibraries = false;
        });
      }
    }
  }

  Future<void> _runTool() async {
    final l10n = context.l10n;
    if (_isRunning || _isLoadingLibraries) {
      return;
    }

    if (_selectedLibraryIds.isEmpty) {
      setState(() {
        _errorMessage = l10n.errorSelectAtLeastOneLibrary;
      });
      return;
    }

    final delimiter = _delimiterController.text;
    if (delimiter.trim().isEmpty) {
      setState(() {
        _errorMessage = l10n.errorDelimiterRequired;
      });
      return;
    }

    setState(() {
      _isRunning = true;
      _errorMessage = null;
    });

    try {
      final result = await runSplitMetadataTermsTool(
        api: widget.api,
        splitType: widget.splitType,
        delimiter: delimiter,
        selectedLibraryIds: _selectedLibraryIds.toList(growable: false),
      );
      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(result);
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = l10n.errorOperationFailed(l10n.operationSplitMetadataTerms, error.toString());
      });
    } finally {
      if (mounted) {
        setState(() {
          _isRunning = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final busy = _isRunning || _isLoadingLibraries;

    return AlertDialog(
      title: Text(l10n.metadataSplitTerms(_termType)),
      content: SizedBox(
        width: 640,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.messageSplitMetadataTerms(_termType), style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 12),
              StyledTextField(
                controller: _delimiterController,
                enabled: !busy,
                label: l10n.fieldDelimiter,
                helperText: l10n.messageDelimiterExample(','),
              ),
              const SizedBox(height: 10),
              if (_errorMessage != null && _errorMessage!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(_errorMessage!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ),
              if (_isLoadingLibraries)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: YaabsaCircularProgressIndicator()),
                )
              else
                AdminToolLibrarySelector(
                  libraries: _libraries,
                  selectedLibraryIds: _selectedLibraryIds,
                  onSelectionChanged: (selection) {
                    setState(() {
                      _selectedLibraryIds = selection;
                    });
                  },
                  enabled: !busy,
                ),
              if (_isRunning) ...[const SizedBox(height: 12), const YaabsaLinearProgressIndicator(minHeight: 4)],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: busy ? null : () => Navigator.of(context).pop(), child: Text(l10n.actionCancel)),
        FilledButton(onPressed: busy ? null : _runTool, child: Text(_isRunning ? l10n.statusRunning : l10n.actionRun)),
      ],
    );
  }
}
