import 'package:flutter/material.dart';
import 'package:yaabsa/api/admin/metadata_term_update_response.dart';
import 'package:yaabsa/components/common/list_management_dialogs.dart';

typedef MetadataTermRenameCallback = Future<MetadataTermUpdateResponse> Function(String currentTerm, String newTerm);
typedef MetadataTermDeleteCallback = Future<MetadataTermUpdateResponse> Function(String term);

class AdminMetadataTermManager extends StatefulWidget {
  const AdminMetadataTermManager({
    super.key,
    required this.entityLabel,
    required this.emptyMessage,
    required this.items,
    required this.onRefresh,
    required this.onRename,
    required this.onDelete,
    this.toolbarAction,
  });

  final String entityLabel;
  final String emptyMessage;
  final List<String> items;
  final Future<void> Function() onRefresh;
  final MetadataTermRenameCallback onRename;
  final MetadataTermDeleteCallback onDelete;
  final Widget? toolbarAction;

  @override
  State<AdminMetadataTermManager> createState() => _AdminMetadataTermManagerState();
}

class _AdminMetadataTermManagerState extends State<AdminMetadataTermManager> {
  String? _processingTerm;
  bool _isRefreshing = false;

  bool get _isBusy => _processingTerm != null || _isRefreshing;

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

  Future<String?> _showRenameDialog(String currentTerm) async {
    final controller = TextEditingController(text: currentTerm);
    var validationError = '';

    final updatedTerm = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            void submit() {
              final nextTerm = controller.text.trim();
              if (nextTerm.isEmpty) {
                setDialogState(() {
                  validationError = 'Name cannot be empty.';
                });
                return;
              }

              if (nextTerm == currentTerm) {
                setDialogState(() {
                  validationError = 'Enter a different name.';
                });
                return;
              }

              Navigator.of(dialogContext).pop(nextTerm);
            }

            return AlertDialog(
              title: Text('Rename ${widget.entityLabel}'),
              content: TextField(
                controller: controller,
                autofocus: true,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: 'Name',
                  errorText: validationError.isEmpty ? null : validationError,
                ),
                onSubmitted: (_) => submit(),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Cancel')),
                FilledButton(onPressed: submit, child: const Text('Save')),
              ],
            );
          },
        );
      },
    );

    controller.dispose();
    return updatedTerm;
  }

  Future<void> _renameTerm(String currentTerm) async {
    if (_isBusy) {
      return;
    }

    final newTerm = await _showRenameDialog(currentTerm);
    if (!mounted || newTerm == null) {
      return;
    }

    setState(() {
      _processingTerm = currentTerm;
    });

    try {
      final response = await widget.onRename(currentTerm, newTerm);
      if (!mounted) {
        return;
      }

      final merged = response.tagMerged ?? response.genreMerged ?? false;
      final updatedCount = response.numItemsUpdated;
      final mergeMessage = merged ? ' Existing ${widget.entityLabel} values were merged.' : '';

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Updated $updatedCount item(s).$mergeMessage')));
    } catch (error) {
      if (!mounted) {
        return;
      }

      final message = listManagementErrorMessage(error, fallback: 'Failed to rename ${widget.entityLabel}.');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() {
          _processingTerm = null;
        });
      }
    }
  }

  Future<void> _deleteTerm(String term) async {
    if (_isBusy) {
      return;
    }

    final confirmed = await showListManagementDeleteDialog(
      context: context,
      title: 'Delete ${widget.entityLabel}?',
      message: 'Remove "$term" from all items?',
    );

    if (!mounted || !confirmed) {
      return;
    }

    setState(() {
      _processingTerm = term;
    });

    try {
      final response = await widget.onDelete(term);
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Updated ${response.numItemsUpdated} item(s).')));
    } catch (error) {
      if (!mounted) {
        return;
      }

      final message = listManagementErrorMessage(error, fallback: 'Failed to delete ${widget.entityLabel}.');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() {
          _processingTerm = null;
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
              const Spacer(),
              IconButton(
                tooltip: 'Refresh ${widget.entityLabel}s',
                onPressed: _isBusy ? null : _handleRefresh,
                icon: const Icon(Icons.refresh_outlined),
              ),
              if (widget.toolbarAction != null) ...[const SizedBox(width: 8), widget.toolbarAction!],
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: widget.items.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                    children: [Text(widget.emptyMessage, style: Theme.of(context).textTheme.bodyMedium)],
                  )
                : ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: widget.items.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final term = widget.items[index];
                      final processingThisTerm = term == _processingTerm;

                      return ListTile(
                        title: Text(term),
                        trailing: SizedBox(
                          width: 112,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (processingThisTerm)
                                const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                              else ...[
                                IconButton(
                                  tooltip: 'Rename ${widget.entityLabel}',
                                  onPressed: _isBusy ? null : () => _renameTerm(term),
                                  icon: const Icon(Icons.edit_outlined),
                                ),
                                IconButton(
                                  tooltip: 'Delete ${widget.entityLabel}',
                                  onPressed: _isBusy ? null : () => _deleteTerm(term),
                                  icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
                                ),
                              ],
                            ],
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
