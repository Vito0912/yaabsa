import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library_items/playback_session.dart';
import 'package:yaabsa/components/common/list_management_dialogs.dart';
import 'package:yaabsa/components/sessions/listening_session_utils.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';
import 'package:yaabsa/ui/components/buttons/yaabsa_button.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:yaabsa/ui/components/settings/yaabsa_switch_tile.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/util/long_listening_sessions_tool.dart';

Future<bool> showLongListeningSessionsDialog(BuildContext context, WidgetRef ref) async {
  final api = ref.read(absApiProvider);
  final currentUser = ref.read(currentUserProvider).value;

  if (api == null || currentUser == null) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.errorConnectionUnavailable)));
    return false;
  }

  final deletedAny = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => const _LongListeningSessionsDialog(),
  );

  return deletedAny ?? false;
}

class _LongListeningSessionsDialog extends ConsumerStatefulWidget {
  const _LongListeningSessionsDialog();

  @override
  ConsumerState<_LongListeningSessionsDialog> createState() => _LongListeningSessionsDialogState();
}

class _LongListeningSessionsDialogState extends ConsumerState<_LongListeningSessionsDialog> {
  final TextEditingController _thresholdController = TextEditingController(text: '24');
  final Set<String> _selectedSessionIds = <String>{};

  bool _includeAllUsers = false;
  bool _isScanning = false;
  bool _isDeleting = false;
  int _deleteProgress = 0;
  int _deleteTotal = 0;
  double _lastThresholdHours = 24;
  String? _thresholdError;
  String? _scanError;
  LongListeningSessionsScanResult? _scanResult;

  @override
  void dispose() {
    _thresholdController.dispose();
    super.dispose();
  }

  double? _parseThresholdHours() {
    final normalized = _thresholdController.text.trim().replaceAll(',', '.');
    final parsed = double.tryParse(normalized);
    if (parsed == null || !parsed.isFinite || parsed < 0) {
      return null;
    }

    return parsed;
  }

  String _formatHours(double hours) {
    if ((hours - hours.roundToDouble()).abs() < 0.05) {
      return hours.round().toString();
    }

    return hours.toStringAsFixed(1);
  }

  Future<void> _scanSessions() async {
    if (_isScanning || _isDeleting) {
      return;
    }

    final thresholdHours = _parseThresholdHours();
    if (thresholdHours == null) {
      setState(() {
        _thresholdError = context.l10n.errorEnterValidThresholdHours;
      });
      return;
    }

    final api = ref.read(absApiProvider);
    final currentUser = ref.read(currentUserProvider).value;
    if (api == null || currentUser == null) {
      setState(() {
        _scanError = context.l10n.errorConnectionUnavailable;
      });
      return;
    }

    setState(() {
      _thresholdError = null;
      _scanError = null;
      _isScanning = true;
      _lastThresholdHours = thresholdHours;
    });

    try {
      final result = await findLongListeningSessions(
        api: api,
        currentUser: currentUser,
        thresholdHours: thresholdHours,
        includeAllUsers: _includeAllUsers,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _scanResult = result;
        _selectedSessionIds
          ..clear()
          ..addAll(result.sessions.map((session) => session.id));
        _isScanning = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isScanning = false;
        _scanError = listManagementErrorMessage(error, fallback: context.l10n.errorUnableToLoadContent);
      });
    }
  }

  List<PlaybackSession> _selectedSessions() {
    final sessions = _scanResult?.sessions ?? const <PlaybackSession>[];
    return sessions.where((session) => _selectedSessionIds.contains(session.id)).toList(growable: false);
  }

  double _selectedHours(List<PlaybackSession> selected) {
    var totalSeconds = 0.0;
    for (final session in selected) {
      totalSeconds += session.timeListening ?? 0;
    }

    return totalSeconds / 3600.0;
  }

  void _selectAll() {
    final sessions = _scanResult?.sessions ?? const <PlaybackSession>[];
    setState(() {
      _selectedSessionIds
        ..clear()
        ..addAll(sessions.map((session) => session.id));
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedSessionIds.clear();
    });
  }

  void _toggleSession(String sessionId, bool? checked) {
    setState(() {
      if (checked == true) {
        _selectedSessionIds.add(sessionId);
      } else {
        _selectedSessionIds.remove(sessionId);
      }
    });
  }

  Future<void> _deleteSelected() async {
    if (_isScanning || _isDeleting) {
      return;
    }

    final selected = _selectedSessions();
    if (selected.isEmpty) {
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      setState(() {
        _scanError = context.l10n.errorConnectionUnavailable;
      });
      return;
    }

    final selectedHoursText = _formatHours(_selectedHours(selected));
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (confirmContext) {
        return AlertDialog(
          title: Text(confirmContext.l10n.confirmDeleteLongSessionsTitle),
          content: Text(confirmContext.l10n.confirmDeleteLongSessionsMessage(selected.length, selectedHoursText)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(confirmContext).pop(false),
              child: Text(confirmContext.l10n.actionCancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(confirmContext).colorScheme.error,
                foregroundColor: Theme.of(confirmContext).colorScheme.onError,
              ),
              onPressed: () => Navigator.of(confirmContext).pop(true),
              child: Text(confirmContext.l10n.actionDelete),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    setState(() {
      _isDeleting = true;
      _scanError = null;
      _deleteProgress = 0;
      _deleteTotal = selected.length;
    });

    final result = await deleteLongListeningSessions(
      api: api,
      sessions: selected,
      onProgress: (processed, total) {
        if (!mounted) {
          return;
        }

        setState(() {
          _deleteProgress = processed;
          _deleteTotal = total;
        });
      },
    );

    if (!mounted) {
      return;
    }

    final hoursText = _formatHours(result.deletedHours);
    final summaryText = result.failedCount == 0
        ? context.l10n.statusLongSessionsDeletedSummary(result.deletedCount, hoursText)
        : context.l10n.statusLongSessionsDeletePartial(result.deletedCount, result.failedCount, hoursText);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(summaryText)));

    if (result.deletedCount > 0) {
      Navigator.of(context).pop(true);
      return;
    }

    setState(() {
      _isDeleting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider).value;
    final isAdmin = currentUser?.type == 'admin' || currentUser?.type == 'root';
    final colorScheme = Theme.of(context).colorScheme;
    final scanResult = _scanResult;
    final sessions = scanResult?.sessions ?? const <PlaybackSession>[];
    final selectedCount = _selectedSessionIds.length;
    final destructiveStyle = FilledButton.styleFrom(
      backgroundColor: colorScheme.error,
      foregroundColor: colorScheme.onError,
    );

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640, maxHeight: 680),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(context.l10n.headingLongListeningSessions, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: StyledTextField(
                      controller: _thresholdController,
                      enabled: !_isScanning && !_isDeleting,
                      label: context.l10n.fieldThresholdHours,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
                      errorText: _thresholdError,
                      onSubmitted: (_) => _scanSessions(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: YaabsaButton(
                      onPressed: (_isScanning || _isDeleting) ? null : _scanSessions,
                      isLoading: _isScanning,
                      icon: const Icon(Icons.search_rounded),
                      label: Text(_isScanning ? context.l10n.statusScanningSessions : context.l10n.actionScanSessions),
                    ),
                  ),
                ],
              ),
              if (isAdmin) ...[
                const SizedBox(height: 8),
                YaabsaSwitchTile.adaptive(
                  value: _includeAllUsers,
                  onChanged: (_isScanning || _isDeleting)
                      ? null
                      : (value) {
                          setState(() {
                            _includeAllUsers = value;
                          });
                        },
                  title: Text(context.l10n.optionAllUsers),
                  subtitle: Text(context.l10n.optionAllUsersDescription),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
              if (_isDeleting) ...[
                const SizedBox(height: 12),
                YaabsaLinearProgressIndicator(
                  value: _deleteTotal > 0 ? (_deleteProgress / _deleteTotal).clamp(0.0, 1.0) : null,
                ),
              ],
              if (_scanError != null) ...[
                const SizedBox(height: 12),
                Text(_scanError!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.error)),
              ],
              if (scanResult != null) ...[
                const SizedBox(height: 14),
                if (sessions.isEmpty)
                  Text(
                    context.l10n.statusNoLongSessionsFound(_formatHours(_lastThresholdHours)),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                  )
                else ...[
                  Text(
                    context.l10n.statusLongSessionsFoundSummary(
                      sessions.length,
                      _formatHours(scanResult.totalHours),
                      scanResult.usersScanned,
                    ),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        context.l10n.selectedCount(selectedCount),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: (_isDeleting || selectedCount == sessions.length) ? null : _selectAll,
                        child: Text(context.l10n.actionSelectAll),
                      ),
                      TextButton(
                        onPressed: (_isDeleting || selectedCount == 0) ? null : _clearSelection,
                        child: Text(context.l10n.actionClearSelection),
                      ),
                    ],
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: sessions.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final session = sessions[index];
                        final durationHours = (session.timeListening ?? 0) / 3600.0;
                        final sessionDate = listeningSessionDateTime(session);
                        final dateLabel = sessionDate == null ? '-' : formatDateTimeLabel(sessionDate);
                        final userLabel = _includeAllUsers
                            ? (session.userId == currentUser?.id ? currentUser?.username : session.userId)
                            : null;
                        final details = <String>[
                          '${durationHours.toStringAsFixed(1)} h',
                          dateLabel,
                          if (userLabel != null && userLabel.isNotEmpty) userLabel,
                        ];

                        return CheckboxListTile(
                          value: _selectedSessionIds.contains(session.id),
                          enabled: !_isDeleting,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(listeningSessionTitle(session), maxLines: 1, overflow: TextOverflow.ellipsis),
                          subtitle: Text(details.join(' · '), maxLines: 2, overflow: TextOverflow.ellipsis),
                          onChanged: (checked) => _toggleSession(session.id, checked),
                        );
                      },
                    ),
                  ),
                ],
              ],
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: 8,
                runSpacing: 8,
                children: [
                  YaabsaButton(
                    variant: YaabsaButtonVariant.text,
                    onPressed: _isDeleting ? null : () => Navigator.of(context).pop(false),
                    label: Text(context.l10n.actionClose),
                  ),
                  if (sessions.isNotEmpty)
                    YaabsaButton(
                      onPressed: (_isScanning || _isDeleting || selectedCount == 0) ? null : _deleteSelected,
                      style: destructiveStyle,
                      isLoading: _isDeleting,
                      icon: const Icon(Icons.delete_outline_rounded),
                      label: Text(context.l10n.actionDeleteSelected),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
