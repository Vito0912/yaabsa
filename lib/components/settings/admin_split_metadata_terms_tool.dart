import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/components/settings/admin_tool_library_selector.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/admin_item_metadata_tools.dart';

import 'package:yaabsa/generated/l10n.dart';

class AdminSplitMetadataTermsTool extends ConsumerWidget {
  const AdminSplitMetadataTermsTool({super.key, required this.splitType, this.onCompleted});

  final MetadataSplitType splitType;
  final Future<void> Function()? onCompleted;

  String get _label => S.current.adminSplitMetadataTermsToolLabel(_splitTypeToken(splitType));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledButton.icon(
      onPressed: () => _openDialog(context, ref),
      icon: const Icon(Icons.call_split_outlined),
      label: Text(_label),
    );
  }

  Future<void> _openDialog(BuildContext context, WidgetRef ref) async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.current.componentsSettingsAdminSplitMetadataTermsToolNoActiveAPIClient)));
      return;
    }

    final result = await showDialog<SplitMetadataTermsToolResult>(
      context: context,
      builder: (dialogContext) => _SplitMetadataTermsDialog(api: api, splitType: splitType),
    );

    if (!context.mounted || result == null) {
      return;
    }

    final noun = splitType == MetadataSplitType.tags ? 'tag' : 'genre';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          S.current.adminSplitMetadataTermsToolResultSummary(
            result.termsSplit,
            noun,
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

String _splitTypeToken(MetadataSplitType splitType) {
  return splitType == MetadataSplitType.tags ? 'tags' : 'genres';
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

  String get _noun => widget.splitType == MetadataSplitType.tags ? 'tags' : 'genres';

  Future<void> _loadLibraries() async {
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
        _errorMessage = S.current.adminSplitMetadataTermsToolFailedToLoadLibraries(error);
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
    if (_isRunning || _isLoadingLibraries) {
      return;
    }

    if (_selectedLibraryIds.isEmpty) {
      setState(() {
        _errorMessage = S.current.adminSplitMetadataTermsToolSelectAtLeastOneLibrary;
      });
      return;
    }

    final delimiter = _delimiterController.text;
    if (delimiter.trim().isEmpty) {
      setState(() {
        _errorMessage = S.current.adminSplitMetadataTermsToolDelimiterCannotBeEmpty;
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
        _errorMessage = S.current.adminSplitMetadataTermsToolFailedToSplit(_noun, error);
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
    final busy = _isRunning || _isLoadingLibraries;

    return AlertDialog(
      title: Text(S.current.adminSplitMetadataTermsToolLabel(_splitTypeToken(widget.splitType))),
      content: SizedBox(
        width: 640,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.current.componentsSettingsAdminSplitMetadataTermsToolThisToolSplitsCombinedValuesUsing(_noun),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _delimiterController,
                enabled: !busy,
                decoration: InputDecoration(
                  labelText: S.current.componentsSettingsAdminSplitMetadataTermsToolDelimiter,
                  helperText: S.current.componentsSettingsAdminSplitMetadataTermsToolExampleSplitsFantasySciFiInto,
                ),
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
                  child: Center(child: CircularProgressIndicator()),
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
              if (_isRunning) ...[const SizedBox(height: 12), const LinearProgressIndicator(minHeight: 4)],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: busy ? null : () => Navigator.of(context).pop(),
          child: Text(S.current.componentsSettingsAdminSplitMetadataTermsToolCancel),
        ),
        FilledButton(
          onPressed: busy ? null : _runTool,
          child: Text(
            _isRunning ? S.current.adminSplitMetadataTermsToolRunning : S.current.adminSplitMetadataTermsToolRunTool,
          ),
        ),
      ],
    );
  }
}
