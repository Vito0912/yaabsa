import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/components/settings/admin_tool_library_selector.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/admin_item_metadata_tools.dart';

class AdminForceMetadataRefreshTool extends ConsumerWidget {
  const AdminForceMetadataRefreshTool({super.key, this.onCompleted});

  final Future<void> Function()? onCompleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: const Icon(Icons.refresh_outlined),
        title: const Text('Force metadata refresh'),
        subtitle: const Text('Temporarily tags selected library items and then removes the force tag again.'),
        trailing: OutlinedButton(onPressed: () => _openDialog(context, ref), child: const Text('Run')),
      ),
    );
  }

  Future<void> _openDialog(BuildContext context, WidgetRef ref) async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No active API client.')));
      return;
    }

    final result = await showDialog<ForceMetadataRefreshToolResult>(
      context: context,
      builder: (dialogContext) => _ForceMetadataRefreshDialog(api: api),
    );

    if (!context.mounted || result == null) {
      return;
    }

    final updated = result.itemsUpdated;
    final tagged = result.itemsTagged;
    final libraries = result.librariesProcessed;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Processed $libraries librar${libraries == 1 ? 'y' : 'ies'} and tagged $tagged item(s). Server reported $updated updated item(s).',
        ),
      ),
    );

    if (onCompleted != null) {
      await onCompleted!();
    }
  }
}

class _ForceMetadataRefreshDialog extends StatefulWidget {
  const _ForceMetadataRefreshDialog({required this.api});

  final ABSApi api;

  @override
  State<_ForceMetadataRefreshDialog> createState() => _ForceMetadataRefreshDialogState();
}

class _ForceMetadataRefreshDialogState extends State<_ForceMetadataRefreshDialog> {
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
        _errorMessage = 'Failed to load libraries: $error';
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
        _errorMessage = 'Select at least one library.';
      });
      return;
    }

    setState(() {
      _isRunning = true;
      _errorMessage = null;
    });

    try {
      final result = await runForceMetadataRefreshTool(
        api: widget.api,
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
        _errorMessage = 'Force metadata refresh failed: $error';
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
      title: const Text('Force Metadata Refresh'),
      content: SizedBox(
        width: 640,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'This tool appends the "force-metadata" tag to every item in the selected libraries, performs a batch update, then removes the tag via the remove endpoint.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
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
        TextButton(onPressed: busy ? null : () => Navigator.of(context).pop(), child: const Text('Cancel')),
        FilledButton(onPressed: busy ? null : _runTool, child: Text(_isRunning ? 'Running...' : 'Run Tool')),
      ],
    );
  }
}
