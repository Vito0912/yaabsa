import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/common/library_selection_list.dart';
import 'package:yaabsa/features/settings/registry/settings_routes.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/ui/components/buttons/yaabsa_button.dart';
import 'package:yaabsa/ui/components/cards/surface_card.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/util/admin_item_metadata_tools.dart';
import 'package:yaabsa/util/l10n.dart';

class ForceMetadataRefreshToolSettings extends ConsumerStatefulWidget {
  const ForceMetadataRefreshToolSettings({super.key});

  static const String routeName = SettingsRoutes.toolsForceMetadataRefresh;

  @override
  ConsumerState<ForceMetadataRefreshToolSettings> createState() => _ForceMetadataRefreshToolSettingsState();
}

class _ForceMetadataRefreshToolSettingsState extends ConsumerState<ForceMetadataRefreshToolSettings> {
  Set<String> _selectedLibraryIds = <String>{};
  bool _isRunning = false;
  String? _errorMessage;
  ForceMetadataRefreshToolResult? _result;

  Future<void> _runTool() async {
    if (_isRunning) {
      return;
    }

    final l10n = context.l10n;
    final api = ref.read(absApiProvider);
    if (api == null) {
      setState(() {
        _errorMessage = l10n.errorNoActiveApiClient;
        _result = null;
      });
      return;
    }

    setState(() {
      _isRunning = true;
      _errorMessage = null;
      _result = null;
    });

    try {
      final result = await runForceMetadataRefreshTool(
        api: api,
        selectedLibraryIds: _selectedLibraryIds.toList(growable: false),
      );
      if (!mounted) {
        return;
      }

      setState(() {
        _result = result;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = l10n.errorOperationFailed(l10n.settingForceMetadataRefresh, error.toString());
      });
    } finally {
      if (mounted) {
        setState(() {
          _isRunning = false;
        });
      }
    }
  }

  Widget _buildErrorCard(BuildContext context, String message) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return YaabsaSurfaceCard(
      color: colors.errorContainer.withValues(alpha: 0.45),
      borderColor: colors.error.withValues(alpha: 0.45),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline_rounded, color: colors.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(message, style: theme.textTheme.bodyMedium?.copyWith(color: colors.onErrorContainer)),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, ForceMetadataRefreshToolResult result) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final summaryText = l10n.adminMetadataRefreshSummary(
      result.librariesProcessed,
      result.itemsTagged,
      result.itemsUpdated,
    );
    final hasNoUpdates = result.itemsTagged == 0 && result.itemsUpdated == 0;

    return YaabsaSurfaceCard(
      color: colors.primaryContainer.withValues(alpha: 0.35),
      borderColor: colors.primary.withValues(alpha: 0.35),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline_rounded, color: colors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(summaryText, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                if (hasNoUpdates) ...[
                  const SizedBox(height: 4),
                  Text(
                    l10n.statusNoMetadataRefreshUpdates,
                    style: theme.textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final result = _result;
    final errorMessage = _errorMessage;

    return SettingsPageScaffold(
      title: l10n.settingForceMetadataRefresh,
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: SettingsRoutes.tools,
      children: [
        LibrarySelectionList.multiSelect(
          selectedLibraryIds: _selectedLibraryIds,
          onSelectionChanged: (selection) {
            setState(() {
              _selectedLibraryIds = selection;
            });
          },
          allowEmptyAllHint: true,
          enabled: !_isRunning,
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: YaabsaButton(
            label: Text(_isRunning ? l10n.statusRunning : l10n.actionRun),
            icon: const Icon(Icons.refresh_rounded),
            isLoading: _isRunning,
            onPressed: _isRunning ? null : () => unawaited(_runTool()),
          ),
        ),
        if (_isRunning) ...[const SizedBox(height: 12), const YaabsaLinearProgressIndicator(minHeight: 4)],
        if (errorMessage != null && errorMessage.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildErrorCard(context, errorMessage),
        ],
        if (result != null) ...[const SizedBox(height: 16), _buildResultCard(context, result)],
      ],
    );
  }
}
