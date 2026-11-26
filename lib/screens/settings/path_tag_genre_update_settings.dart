import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/common/library_selection_list.dart';
import 'package:yaabsa/features/settings/registry/settings_routes.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/ui/components/buttons/action_icon_button.dart';
import 'package:yaabsa/ui/components/buttons/yaabsa_button.dart';
import 'package:yaabsa/ui/components/cards/surface_card.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:yaabsa/ui/components/settings/yaabsa_switch_tile.dart';
import 'package:yaabsa/util/admin_item_metadata_tools.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/util/path_tag_genre_tool.dart';

class PathTagGenreUpdateSettings extends ConsumerStatefulWidget {
  const PathTagGenreUpdateSettings({super.key});

  static const String routeName = SettingsRoutes.toolsPathTagGenreUpdate;

  @override
  ConsumerState<PathTagGenreUpdateSettings> createState() => _PathTagGenreUpdateSettingsState();
}

class _PathTagGenreUpdateSettingsState extends ConsumerState<PathTagGenreUpdateSettings> {
  final TextEditingController _ruleController = TextEditingController();
  final List<String> _rules = <String>['.*Fiction.*:Fiction'];

  String? _selectedLibraryId;
  MetadataSplitType _targetType = MetadataSplitType.tags;
  String? _ruleInputError;
  bool _dryRun = true;
  bool _isRunning = false;
  String? _errorMessage;
  PathTagGenreToolResult? _result;

  @override
  void dispose() {
    _ruleController.dispose();
    super.dispose();
  }

  String? _validateRule(String rawRule, AppLocalizations l10n) {
    final trimmed = rawRule.trim();
    final lastColonIndex = trimmed.lastIndexOf(':');
    if (lastColonIndex <= 0 || lastColonIndex >= trimmed.length - 1) {
      return l10n.errorInvalidPathRule;
    }

    final pattern = trimmed.substring(0, lastColonIndex);
    final value = trimmed.substring(lastColonIndex + 1).trim();
    if (value.isEmpty) {
      return l10n.errorInvalidPathRule;
    }

    try {
      RegExp(pattern);
    } on FormatException {
      return l10n.errorInvalidPathRule;
    }

    return null;
  }

  void _addRule() {
    final l10n = context.l10n;
    final trimmed = _ruleController.text.trim();
    final validationError = _validateRule(trimmed, l10n);
    if (validationError != null) {
      setState(() {
        _ruleInputError = validationError;
      });
      return;
    }

    setState(() {
      if (!_rules.contains(trimmed)) {
        _rules.add(trimmed);
      }
      _ruleController.clear();
      _ruleInputError = null;
      _errorMessage = null;
    });
  }

  Future<void> _runTool() async {
    if (_isRunning) {
      return;
    }

    final l10n = context.l10n;
    final libraryId = _selectedLibraryId;
    if (libraryId == null || libraryId.trim().isEmpty) {
      setState(() {
        _errorMessage = l10n.errorSelectAtLeastOneLibrary;
        _result = null;
      });
      return;
    }

    if (_rules.isEmpty) {
      setState(() {
        _errorMessage = l10n.errorAddAtLeastOneRule;
        _result = null;
      });
      return;
    }

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
      final result = await runPathTagGenreTool(
        api: api,
        libraryId: libraryId,
        ruleSets: List<String>.from(_rules),
        targetType: _targetType,
        dryRun: _dryRun,
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
        _errorMessage = l10n.errorOperationFailed(l10n.headingPathTagGenreUpdate, error.toString());
      });
    } finally {
      if (mounted) {
        setState(() {
          _isRunning = false;
        });
      }
    }
  }

  Widget _buildInfoCard(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return YaabsaSurfaceCard(
      color: colors.surfaceContainerLow,
      borderColor: colors.outlineVariant.withValues(alpha: 0.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: colors.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(context.l10n.descriptionPathTagGenreUpdate, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }

  Widget _buildOptionsCard(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return YaabsaSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.fieldType, style: theme.textTheme.titleSmall),
          const SizedBox(height: 10),
          SegmentedButton<MetadataSplitType>(
            segments: [
              ButtonSegment<MetadataSplitType>(
                value: MetadataSplitType.tags,
                icon: const Icon(Icons.label_outline_rounded),
                label: Text(l10n.fieldTags),
              ),
              ButtonSegment<MetadataSplitType>(
                value: MetadataSplitType.genres,
                icon: const Icon(Icons.category_outlined),
                label: Text(l10n.fieldGenres),
              ),
            ],
            selected: <MetadataSplitType>{_targetType},
            onSelectionChanged: _isRunning
                ? null
                : (selection) {
                    setState(() {
                      _targetType = selection.first;
                    });
                  },
          ),
          const SizedBox(height: 8),
          YaabsaSwitchTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: _dryRun,
            onChanged: _isRunning
                ? null
                : (value) {
                    setState(() {
                      _dryRun = value;
                    });
                  },
            title: Text(l10n.optionDryRun),
            subtitle: Text(l10n.optionDryRunDescription),
          ),
        ],
      ),
    );
  }

  Widget _buildRulesCard(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return YaabsaSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.headingPathRules, style: theme.textTheme.titleSmall),
          const SizedBox(height: 4),
          Text(l10n.hintPathRuleFormat, style: theme.textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant)),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: StyledTextField(
                  controller: _ruleController,
                  enabled: !_isRunning,
                  label: l10n.fieldPathRule,
                  hintText: '.*Fiction.*:Fiction',
                  errorText: _ruleInputError,
                  onChanged: (_) {
                    if (_ruleInputError == null) {
                      return;
                    }
                    setState(() {
                      _ruleInputError = null;
                    });
                  },
                  onSubmitted: (_) => _addRule(),
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: YaabsaButton(
                  label: Text(l10n.actionAddRule),
                  icon: const Icon(Icons.add_rounded),
                  variant: YaabsaButtonVariant.tonal,
                  onPressed: _isRunning ? null : _addRule,
                ),
              ),
            ],
          ),
          if (_rules.isNotEmpty) ...[
            const SizedBox(height: 12),
            YaabsaSurfaceCard(
              padding: EdgeInsets.zero,
              borderRadius: 12,
              color: colors.surfaceContainerLow,
              borderColor: colors.outlineVariant.withValues(alpha: 0.5),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _rules.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final rule = _rules[index];
                  return ListTile(
                    dense: true,
                    title: Text(rule, style: theme.textTheme.bodyMedium?.copyWith(fontFamily: 'monospace')),
                    trailing: YaabsaDeleteIconButton(
                      tooltip: l10n.actionRemove,
                      enabled: !_isRunning,
                      onPressed: () {
                        setState(() {
                          _rules.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
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

  Widget _buildResultCard(BuildContext context, PathTagGenreToolResult result) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final String summary;
    if (result.itemsMatched == 0) {
      summary = l10n.statusPathTagGenreNoMatches(result.itemsScanned);
    } else if (result.dryRun) {
      summary = l10n.statusPathTagGenreDryRunSummary(result.itemsScanned, result.itemsMatched);
    } else {
      summary = l10n.statusPathTagGenreAppliedSummary(result.itemsScanned, result.itemsMatched, result.itemsUpdated);
    }

    return YaabsaSurfaceCard(
      color: colors.surfaceContainerLow,
      borderColor: colors.outlineVariant.withValues(alpha: 0.6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(result.dryRun ? Icons.preview_outlined : Icons.check_circle_outline_rounded, color: colors.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(summary, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          if (result.logs.isNotEmpty) ...[
            const SizedBox(height: 12),
            YaabsaSurfaceCard(
              padding: const EdgeInsets.all(12),
              borderRadius: 12,
              color: colors.surface,
              borderColor: colors.outlineVariant.withValues(alpha: 0.45),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 280),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: result.logs.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 6),
                  itemBuilder: (context, index) {
                    return SelectableText(
                      result.logs[index],
                      style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
                    );
                  },
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final errorMessage = _errorMessage;
    final result = _result;

    return SettingsPageScaffold(
      title: l10n.headingPathTagGenreUpdate,
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: SettingsRoutes.tools,
      children: [
        _buildInfoCard(context),
        const SizedBox(height: 16),
        LibrarySelectionList.singleSelect(
          title: l10n.fieldLibrary,
          selectedLibraryId: _selectedLibraryId,
          onSelected: (libraryId) {
            setState(() {
              _selectedLibraryId = libraryId;
              _errorMessage = null;
            });
          },
          enabled: !_isRunning,
        ),
        const SizedBox(height: 16),
        _buildOptionsCard(context),
        const SizedBox(height: 16),
        _buildRulesCard(context),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: YaabsaButton(
            label: Text(_isRunning ? l10n.statusRunning : l10n.actionRun),
            icon: Icon(_dryRun ? Icons.preview_outlined : Icons.play_arrow_rounded),
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
