import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/filesystem/filesystem_directory.dart';
import 'package:yaabsa/provider/core/user_providers.dart';

Future<String?> showFilesystemDirectoryPickerDialog(
  BuildContext context, {
  String title = 'Browse server folders',
  String? initialPath,
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => _FilesystemDirectoryPickerDialog(title: title, initialPath: initialPath),
  );
}

class _FilesystemDirectoryPickerDialog extends ConsumerStatefulWidget {
  const _FilesystemDirectoryPickerDialog({required this.title, this.initialPath});

  final String title;
  final String? initialPath;

  @override
  ConsumerState<_FilesystemDirectoryPickerDialog> createState() => _FilesystemDirectoryPickerDialogState();
}

class _FilesystemDirectoryPickerDialogState extends ConsumerState<_FilesystemDirectoryPickerDialog> {
  bool _isLoading = true;
  String? _errorMessage;
  String? _currentPath;
  List<FilesystemDirectory> _directories = const <FilesystemDirectory>[];

  final List<String?> _history = <String?>[];

  @override
  void initState() {
    super.initState();
    final initial = widget.initialPath?.trim();
    _currentPath = (initial == null || initial.isEmpty) ? null : initial;
    _loadDirectories(path: _currentPath);
  }

  String? _parentPath(String? path) {
    if (path == null || path.trim().isEmpty) {
      return null;
    }

    final normalized = path.trim().replaceAll(RegExp(r'[\\/]+$'), '');
    final separatorIndex = normalized.lastIndexOf(RegExp(r'[\\/]'));
    if (separatorIndex <= 0) {
      return null;
    }

    return normalized.substring(0, separatorIndex);
  }

  Future<void> _loadDirectories({String? path, bool pushCurrentToHistory = false}) async {
    if (pushCurrentToHistory) {
      _history.add(_currentPath);
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = 'No active API client.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await api.getUploadApi().getFilesystemPaths(path: path, level: 0);
      final directories = List<FilesystemDirectory>.from(response.data?.directories ?? const <FilesystemDirectory>[])
        ..sort((left, right) => left.dirname.toLowerCase().compareTo(right.dirname.toLowerCase()));

      if (!mounted) {
        return;
      }

      setState(() {
        _currentPath = path;
        _directories = directories;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = 'Failed to load server folders: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _openDirectory(String path) async {
    await _loadDirectories(path: path, pushCurrentToHistory: true);
  }

  Future<void> _goUp() async {
    if (_history.isNotEmpty) {
      final previous = _history.removeLast();
      await _loadDirectories(path: previous);
      return;
    }

    final parentPath = _parentPath(_currentPath);
    await _loadDirectories(path: parentPath);
  }

  void _selectPath(String path) {
    Navigator.of(context).pop(path);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 700,
        height: 460,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: 'Up',
                  onPressed: _isLoading ? null : _goUp,
                  icon: const Icon(Icons.arrow_upward_rounded),
                ),
                Expanded(
                  child: Text(
                    _currentPath == null ? 'Root' : _currentPath!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  tooltip: 'Refresh',
                  onPressed: _isLoading ? null : () => _loadDirectories(path: _currentPath),
                  icon: const Icon(Icons.refresh_rounded),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(_errorMessage!, style: TextStyle(color: colorScheme.error)),
              ),
              const SizedBox(height: 8),
            ],
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _directories.isEmpty
                  ? Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'No directories available.',
                        style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _directories.length,
                      separatorBuilder: (_, _) =>
                          Divider(height: 1, color: colorScheme.outlineVariant.withValues(alpha: 0.25)),
                      itemBuilder: (context, index) {
                        final directory = _directories[index];
                        return ListTile(
                          leading: const Icon(Icons.folder_outlined),
                          title: Text(directory.dirname),
                          subtitle: Text(directory.path, maxLines: 1, overflow: TextOverflow.ellipsis),
                          onTap: () => _selectPath(directory.path),
                          trailing: IconButton(
                            tooltip: 'Open',
                            onPressed: () => _openDirectory(directory.path),
                            icon: const Icon(Icons.chevron_right_rounded),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        FilledButton.icon(
          onPressed: _currentPath == null ? null : () => Navigator.of(context).pop(_currentPath),
          icon: const Icon(Icons.check_rounded),
          label: const Text('Use current folder'),
        ),
      ],
    );
  }
}
