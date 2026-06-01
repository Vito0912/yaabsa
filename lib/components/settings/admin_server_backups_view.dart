import 'dart:async';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yaabsa/api/admin/admin_backup.dart';
import 'package:yaabsa/api/admin/update_backup_path_request.dart';
import 'package:yaabsa/api/me/server_settings.dart';
import 'package:yaabsa/components/common/list_management_dialogs.dart';
import 'package:yaabsa/components/settings/backups/admin_backup_settings_panel.dart';
import 'package:yaabsa/components/settings/backups/admin_backup_table.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';

class AdminServerBackupsView extends ConsumerStatefulWidget {
  const AdminServerBackupsView({super.key});

  @override
  ConsumerState<AdminServerBackupsView> createState() => _AdminServerBackupsViewState();
}

class _AdminServerBackupsViewState extends ConsumerState<AdminServerBackupsView> {
  static const String _serverSettingsId = 'server-settings';
  static const String _defaultCronExpression = '30 1 * * *';
  static const double _tableMinHeightForStaticLayout = 220;
  static const double _contentSectionSpacing = 8;

  final TextEditingController _backupPathController = TextEditingController();
  final TextEditingController _cronExpressionController = TextEditingController();
  final TextEditingController _backupsToKeepController = TextEditingController();
  final TextEditingController _maxBackupSizeController = TextEditingController();
  final GlobalKey _topContentKey = GlobalKey();

  String? _activeUserId;
  String? _errorMessage;
  String _backupLocation = '';

  bool _backupPathEnvSet = false;
  bool _showEditBackupPath = false;
  bool _enableAutomaticBackups = false;
  bool _isLoading = true;
  bool _isSavingBackupPath = false;
  bool _isUpdatingSettings = false;
  bool _isCreatingBackup = false;
  bool _isUploadingBackup = false;
  bool _isBackupConfigurationExpanded = false;
  bool _isTopContentMeasureQueued = false;

  String? _backupPathError;
  String? _cronExpressionError;
  String? _backupsToKeepError;
  String? _maxBackupSizeError;

  final Set<String> _busyBackupIds = <String>{};
  List<AdminBackup> _backups = const <AdminBackup>[];
  double _topContentHeight = 0;

  @override
  void dispose() {
    _backupPathController.dispose();
    _cronExpressionController.dispose();
    _backupsToKeepController.dispose();
    _maxBackupSizeController.dispose();
    super.dispose();
  }

  bool _isAdminType(String? userType) {
    final normalized = (userType ?? '').trim().toLowerCase();
    return normalized == 'admin' || normalized == 'root';
  }

  void _showMessage(String message) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      return;
    }

    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  String _resolveErrorMessage(Object error, {required String fallback}) {
    if (error is DioException) {
      final responseData = error.response?.data;
      if (responseData is String && responseData.trim().isNotEmpty) {
        return responseData.trim();
      }
      if (responseData is Map) {
        final message = responseData['message'];
        if (message is String && message.trim().isNotEmpty) {
          return message.trim();
        }
        final responseError = responseData['error'];
        if (responseError is String && responseError.trim().isNotEmpty) {
          return responseError.trim();
        }
      }
      if (error.message != null && error.message!.trim().isNotEmpty) {
        return error.message!.trim();
      }
    }

    return fallback;
  }

  List<AdminBackup> _sortedBackups(List<AdminBackup> backups) {
    final sorted = List<AdminBackup>.from(backups);
    sorted.sort((left, right) {
      final leftCreatedAt = left.createdAt ?? 0;
      final rightCreatedAt = right.createdAt ?? 0;
      final byCreatedAt = rightCreatedAt.compareTo(leftCreatedAt);
      if (byCreatedAt != 0) {
        return byCreatedAt;
      }

      return left.id.compareTo(right.id);
    });
    return sorted;
  }

  void _applyServerBackupSettings(ServerSettings settings) {
    final backupSchedule = settings.backupSchedule;
    final cronExpression = backupSchedule is String && backupSchedule.trim().isNotEmpty
        ? backupSchedule.trim()
        : _defaultCronExpression;

    _enableAutomaticBackups = backupSchedule is String && backupSchedule.trim().isNotEmpty;
    _cronExpressionController.text = cronExpression;
    _backupsToKeepController.text = (settings.backupsToKeep ?? 2).toString();
    _maxBackupSizeController.text = (settings.maxBackupSize ?? 1).toString();
  }

  Future<void> _loadBackupsData({bool showLoading = true}) async {
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

    if (showLoading) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final backupsFuture = api.getAdminApi().getBackups();
      final authFuture = api.getMeApi().checkLogin();

      final results = await Future.wait<dynamic>([backupsFuture, authFuture]);
      final backupsResponse = results[0];
      final authResponse = results[1];

      final responseData = backupsResponse.data;
      final authData = authResponse.data;
      final serverSettings = authData?.serverSettings;

      if (!mounted) {
        return;
      }

      final backups = _sortedBackups(responseData?.backups ?? const <AdminBackup>[]);
      final backupLocation = (responseData?.backupLocation ?? serverSettings?.backupPath ?? '').trim();

      setState(() {
        _backups = backups;
        _backupLocation = backupLocation;
        _backupPathEnvSet = responseData?.backupPathEnvSet ?? false;
        _errorMessage = null;
        _backupPathError = null;
        if (!_showEditBackupPath) {
          _backupPathController.text = backupLocation;
        }

        if (serverSettings != null) {
          _applyServerBackupSettings(serverSettings);
          _cronExpressionError = null;
          _backupsToKeepError = null;
          _maxBackupSizeError = null;
        }
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = _resolveErrorMessage(error, fallback: 'Failed to load backups.');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String? _validateBackupPath(String value) {
    if (value.trim().isEmpty) {
      return 'Backup path is required.';
    }
    return null;
  }

  String? _validateCronExpression(String value) {
    if (!_enableAutomaticBackups) {
      return null;
    }

    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'Cron expression is required when automatic backups are enabled.';
    }

    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length != 5) {
      return 'Cron expression must have 5 fields.';
    }

    return null;
  }

  String? _validateBackupsToKeep(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'Backups to keep is required.';
    }

    final parsed = int.tryParse(trimmed);
    if (parsed == null || parsed <= 0) {
      return 'Backups to keep must be greater than 0.';
    }

    if (parsed > 99) {
      return 'Backups to keep must be 99 or less.';
    }

    return null;
  }

  String? _validateMaxBackupSize(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'Maximum backup size is required.';
    }

    final parsed = int.tryParse(trimmed);
    if (parsed == null || parsed < 0) {
      return 'Maximum backup size must be 0 or greater.';
    }

    return null;
  }

  void _setBusyBackup(String backupId, bool isBusy) {
    setState(() {
      if (isBusy) {
        _busyBackupIds.add(backupId);
      } else {
        _busyBackupIds.remove(backupId);
      }
    });
  }

  void _queueTopContentMeasurement() {
    if (_isTopContentMeasureQueued) {
      return;
    }

    _isTopContentMeasureQueued = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isTopContentMeasureQueued = false;
      if (!mounted) {
        return;
      }

      final renderObject = _topContentKey.currentContext?.findRenderObject();
      if (renderObject is! RenderBox || !renderObject.hasSize) {
        return;
      }

      final nextHeight = renderObject.size.height;
      if ((nextHeight - _topContentHeight).abs() < 0.5) {
        return;
      }

      setState(() {
        _topContentHeight = nextHeight;
      });
    });
  }

  Future<void> _saveBackupPath() async {
    if (_isSavingBackupPath) {
      return;
    }

    final backupPathError = _validateBackupPath(_backupPathController.text);
    if (backupPathError != null) {
      setState(() {
        _backupPathError = backupPathError;
      });
      return;
    }

    final nextPath = _backupPathController.text.trim();
    if (nextPath == _backupLocation) {
      setState(() {
        _showEditBackupPath = false;
        _backupPathError = null;
      });
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage('No active API client.');
      return;
    }

    setState(() {
      _isSavingBackupPath = true;
      _backupPathError = null;
    });

    try {
      await api.getAdminApi().updateBackupPath(payload: UpdateBackupPathRequest(path: nextPath));

      if (!mounted) {
        return;
      }

      setState(() {
        _backupLocation = nextPath;
        _showEditBackupPath = false;
      });

      await _loadBackupsData(showLoading: false);
      _showMessage('Backup location updated.');
    } catch (error) {
      if (!mounted) {
        return;
      }

      final message = _resolveErrorMessage(error, fallback: 'Failed to update backup location.');
      _showMessage(message);
    } finally {
      if (mounted) {
        setState(() {
          _isSavingBackupPath = false;
        });
      }
    }
  }

  void _cancelBackupPathEdit() {
    setState(() {
      _showEditBackupPath = false;
      _backupPathController.text = _backupLocation;
      _backupPathError = null;
    });
  }

  Future<void> _saveBackupSettings() async {
    if (_isUpdatingSettings) {
      return;
    }

    final cronError = _validateCronExpression(_cronExpressionController.text);
    final backupsToKeepError = _validateBackupsToKeep(_backupsToKeepController.text);
    final maxBackupSizeError = _validateMaxBackupSize(_maxBackupSizeController.text);

    if (cronError != null || backupsToKeepError != null || maxBackupSizeError != null) {
      setState(() {
        _cronExpressionError = cronError;
        _backupsToKeepError = backupsToKeepError;
        _maxBackupSizeError = maxBackupSizeError;
      });
      return;
    }

    final backupsToKeep = int.parse(_backupsToKeepController.text.trim());
    final maxBackupSize = int.parse(_maxBackupSizeController.text.trim());
    final backupSchedule = _enableAutomaticBackups ? _cronExpressionController.text.trim() : false;

    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage('No active API client.');
      return;
    }

    setState(() {
      _isUpdatingSettings = true;
      _cronExpressionError = null;
      _backupsToKeepError = null;
      _maxBackupSizeError = null;
    });

    try {
      final response = await api.getAdminApi().updateServerSettings(
        settingsUpdate: ServerSettings(
          id: _serverSettingsId,
          backupSchedule: backupSchedule,
          backupsToKeep: backupsToKeep,
          maxBackupSize: maxBackupSize,
        ),
      );

      if (!mounted) {
        return;
      }

      final updatedSettings = response.data;
      if (updatedSettings != null) {
        setState(() {
          _applyServerBackupSettings(updatedSettings);
        });
      }

      _showMessage('Backup settings updated.');
    } catch (error) {
      if (!mounted) {
        return;
      }

      final message = _resolveErrorMessage(error, fallback: 'Failed to update backup settings.');
      _showMessage(message);
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingSettings = false;
        });
      }
    }
  }

  Future<void> _createBackup() async {
    if (_isCreatingBackup) {
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage('No active API client.');
      return;
    }

    setState(() {
      _isCreatingBackup = true;
    });

    try {
      final response = await api.getAdminApi().createBackup();

      if (!mounted) {
        return;
      }

      setState(() {
        _backups = _sortedBackups(response.data?.backups ?? const <AdminBackup>[]);
      });

      _showMessage('Backup created successfully.');
    } catch (error) {
      final message = listManagementErrorMessage(error, fallback: 'Failed to create backup.');
      _showMessage(message);
    } finally {
      if (mounted) {
        setState(() {
          _isCreatingBackup = false;
        });
      }
    }
  }

  Future<void> _uploadBackup() async {
    if (_isUploadingBackup) {
      return;
    }

    final pickedFile = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: const ['audiobookshelf'],
      dialogTitle: 'Select backup archive',
    );

    if (pickedFile == null) {
      return;
    }

    final filePath = pickedFile.path;
    if (filePath == null || filePath.trim().isEmpty) {
      _showMessage('Selected backup file is not available on disk.');
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage('No active API client.');
      return;
    }

    setState(() {
      _isUploadingBackup = true;
    });

    try {
      final formData = FormData.fromMap({'file': await MultipartFile.fromFile(filePath, filename: pickedFile.name)});
      final response = await api.getAdminApi().uploadBackup(formData: formData);

      if (!mounted) {
        return;
      }

      setState(() {
        _backups = _sortedBackups(response.data?.backups ?? const <AdminBackup>[]);
      });

      _showMessage('Backup uploaded successfully.');
    } catch (error) {
      final message = listManagementErrorMessage(error, fallback: 'Failed to upload backup.');
      _showMessage(message);
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingBackup = false;
        });
      }
    }
  }

  Uri _backupDownloadUri({required String backupId, required String baseUrl, String? token}) {
    final baseUri = Uri.parse(baseUrl);
    final basePath = baseUri.path.endsWith('/') ? baseUri.path.substring(0, baseUri.path.length - 1) : baseUri.path;

    return baseUri.replace(
      path: '$basePath/api/backups/${Uri.encodeComponent(backupId)}/download',
      queryParameters: (token ?? '').trim().isEmpty ? null : <String, String>{'token': token!.trim()},
    );
  }

  Future<void> _downloadBackup(AdminBackup backup) async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage('No active API client.');
      return;
    }

    _setBusyBackup(backup.id, true);
    try {
      final uri = _backupDownloadUri(backupId: backup.id, baseUrl: api.basePathOverride, token: api.token);

      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened) {
        _showMessage('Failed to open backup download URL.');
      }
    } catch (error) {
      _showMessage(_resolveErrorMessage(error, fallback: 'Failed to open backup download URL.'));
    } finally {
      _setBusyBackup(backup.id, false);
    }
  }

  Future<void> _restoreBackup(AdminBackup backup) async {
    if (!backup.canRestore) {
      _showMessage('This backup was created by an unsupported legacy server format.');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Restore backup?'),
          content: Text(
            'Restore backup from ${formatDateTimeLabel(backup.createdDateTime)}? '
            'This replaces the current server database and metadata cache.',
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Restore')),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage('No active API client.');
      return;
    }

    _setBusyBackup(backup.id, true);
    try {
      await api.getAdminApi().applyBackup(backupId: backup.id);
      _showMessage('Backup restore started. Reload the app after the server finishes applying it.');
    } catch (error) {
      final message = listManagementErrorMessage(error, fallback: 'Failed to restore backup.');
      _showMessage(message);
    } finally {
      _setBusyBackup(backup.id, false);
    }
  }

  Future<void> _deleteBackup(AdminBackup backup) async {
    final confirmed = await showListManagementDeleteDialog(
      context: context,
      title: 'Delete backup?',
      message: 'Delete backup from ${formatDateTimeLabel(backup.createdDateTime)}? This action cannot be undone.',
    );

    if (!confirmed) {
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage('No active API client.');
      return;
    }

    _setBusyBackup(backup.id, true);
    try {
      final response = await api.getAdminApi().deleteBackup(backup.id);

      if (!mounted) {
        return;
      }

      setState(() {
        _backups = _sortedBackups(response.data?.backups ?? const <AdminBackup>[]);
      });

      _showMessage('Backup deleted.');
    } catch (error) {
      final message = listManagementErrorMessage(error, fallback: 'Failed to delete backup.');
      _showMessage(message);
    } finally {
      _setBusyBackup(backup.id, false);
    }
  }

  Widget _buildToolbar({required bool compact}) {
    final canStartOperation = !_isLoading && !_isCreatingBackup && !_isUploadingBackup;

    if (compact) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton.filledTonal(
            tooltip: 'Refresh',
            onPressed: _isLoading ? null : () => unawaited(_loadBackupsData(showLoading: true)),
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 6),
          IconButton.filledTonal(
            tooltip: 'Upload backup',
            onPressed: canStartOperation ? _uploadBackup : null,
            icon: _isUploadingBackup
                ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.upload_file_rounded),
          ),
          const SizedBox(width: 6),
          IconButton.filled(
            tooltip: 'Create backup',
            onPressed: canStartOperation ? _createBackup : null,
            icon: _isCreatingBackup
                ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.archive_rounded),
          ),
        ],
      );
    }

    return Row(
      children: [
        OutlinedButton.icon(
          onPressed: _isLoading ? null : () => unawaited(_loadBackupsData(showLoading: true)),
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Refresh'),
        ),
        const SizedBox(width: 10),
        OutlinedButton.icon(
          onPressed: canStartOperation ? _uploadBackup : null,
          icon: _isUploadingBackup
              ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.upload_file_outlined),
          label: const Text('Upload Backup'),
        ),
        const Spacer(),
        FilledButton.icon(
          onPressed: canStartOperation ? _createBackup : null,
          icon: _isCreatingBackup
              ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.archive_rounded),
          label: const Text('Create Backup'),
        ),
      ],
    );
  }

  Widget _buildErrorCard() {
    final message = _errorMessage;
    if (message == null || message.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.45),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
        child: Row(
          children: [
            Icon(Icons.error_outline_rounded, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
            const SizedBox(width: 10),
            TextButton(onPressed: () => unawaited(_loadBackupsData(showLoading: true)), child: const Text('Retry')),
          ],
        ),
      ),
    );
  }

  Widget _buildTopContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AdminBackupSettingsPanel(
          backupLocation: _backupLocation,
          backupPathEnvSet: _backupPathEnvSet,
          showEditBackupPath: _showEditBackupPath,
          isSavingBackupPath: _isSavingBackupPath,
          isUpdatingSettings: _isUpdatingSettings,
          enableAutomaticBackups: _enableAutomaticBackups,
          backupPathController: _backupPathController,
          cronExpressionController: _cronExpressionController,
          backupsToKeepController: _backupsToKeepController,
          maxBackupSizeController: _maxBackupSizeController,
          backupPathError: _backupPathError,
          cronExpressionError: _cronExpressionError,
          backupsToKeepError: _backupsToKeepError,
          maxBackupSizeError: _maxBackupSizeError,
          onConfigurationExpandedChanged: (expanded) {
            setState(() {
              _isBackupConfigurationExpanded = expanded;
            });
            _queueTopContentMeasurement();
          },
          onTogglePathEditing: () {
            setState(() {
              _showEditBackupPath = true;
            });
          },
          onCancelPathEditing: _cancelBackupPathEdit,
          onSaveBackupPath: _saveBackupPath,
          onAutomaticBackupsChanged: (enabled) {
            setState(() {
              _enableAutomaticBackups = enabled;
              _cronExpressionError = _validateCronExpression(_cronExpressionController.text);
            });
          },
          onSaveBackupSettings: _saveBackupSettings,
          onBackupPathChanged: (_) {
            if (_backupPathError == null) {
              return;
            }
            setState(() {
              _backupPathError = _validateBackupPath(_backupPathController.text);
            });
          },
          onCronChanged: (_) {
            if (_cronExpressionError == null) {
              return;
            }
            setState(() {
              _cronExpressionError = _validateCronExpression(_cronExpressionController.text);
            });
          },
          onBackupsToKeepChanged: (_) {
            if (_backupsToKeepError == null) {
              return;
            }
            setState(() {
              _backupsToKeepError = _validateBackupsToKeep(_backupsToKeepController.text);
            });
          },
          onMaxBackupSizeChanged: (_) {
            if (_maxBackupSizeError == null) {
              return;
            }
            setState(() {
              _maxBackupSizeError = _validateMaxBackupSize(_maxBackupSizeController.text);
            });
          },
        ),
        const SizedBox(height: 10),
        if (_isLoading && _backups.isNotEmpty) ...[
          const SizedBox(height: 8),
          const LinearProgressIndicator(minHeight: 2),
        ],
        const SizedBox(height: 10),
        _buildErrorCard(),
        if (_errorMessage?.isNotEmpty == true) const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return currentUserAsync.when(
      data: (currentUser) {
        if (currentUser == null) {
          return const Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Text('No active user. Sign in to manage backups.'),
          );
        }

        if (!_isAdminType(currentUser.type)) {
          return const Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Text('This page requires an admin account.'),
          );
        }

        if (_activeUserId != currentUser.id) {
          _activeUserId = currentUser.id;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) {
              return;
            }
            unawaited(_loadBackupsData(showLoading: true));
          });
        }

        final compact = MediaQuery.sizeOf(context).width < 720;
        final horizontalPadding = compact ? 10.0 : 0.0;
        final table = RefreshIndicator(
          onRefresh: () => _loadBackupsData(showLoading: false),
          child: AdminBackupTable(
            backups: _backups,
            busyBackupIds: _busyBackupIds,
            onRestore: _restoreBackup,
            onDownload: _downloadBackup,
            onDelete: _deleteBackup,
            loading: _isLoading,
            topActions: _buildToolbar(compact: compact),
            physics: const ClampingScrollPhysics(),
          ),
        );

        return LayoutBuilder(
          builder: (context, constraints) {
            _queueTopContentMeasurement();

            final topContent = KeyedSubtree(key: _topContentKey, child: _buildTopContent());
            final viewportHeight = constraints.maxHeight;
            final usePageScroll =
                _isBackupConfigurationExpanded &&
                (_topContentHeight <= 0 ||
                    _topContentHeight + _contentSectionSpacing + _tableMinHeightForStaticLayout > viewportHeight);

            final body = usePageScroll
                ? CustomScrollView(
                    physics: const ClampingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(child: topContent),
                      const SliverToBoxAdapter(child: SizedBox(height: _contentSectionSpacing)),
                      SliverFillRemaining(hasScrollBody: true, child: table),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      topContent,
                      const SizedBox(height: _contentSectionSpacing),
                      Expanded(child: table),
                    ],
                  );

            return Padding(padding: EdgeInsets.fromLTRB(horizontalPadding, 8, horizontalPadding, 16), child: body);
          },
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        child: Text('Failed to load user data: $error', style: TextStyle(color: Theme.of(context).colorScheme.error)),
      ),
    );
  }
}
