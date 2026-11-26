import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/common/library_selection_list.dart';
import 'package:yaabsa/features/settings/registry/settings_routes.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/screens/settings/tools/match_audiobook_chapters_cards.dart';
import 'package:yaabsa/ui/components/buttons/yaabsa_button.dart';
import 'package:yaabsa/ui/components/cards/surface_card.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/util/match_audiobook_chapters_tool.dart';

class MatchAudiobookChaptersToolSettings extends ConsumerStatefulWidget {
  const MatchAudiobookChaptersToolSettings({super.key});

  static const String routeName = SettingsRoutes.toolsMatchAudiobookChapters;

  @override
  ConsumerState<MatchAudiobookChaptersToolSettings> createState() => _MatchAudiobookChaptersToolSettingsState();
}

class _MatchAudiobookChaptersToolSettingsState extends ConsumerState<MatchAudiobookChaptersToolSettings> {
  final TextEditingController _thresholdController = TextEditingController(text: '3');
  final ScrollController _logScrollController = ScrollController();
  final List<String> _logs = <String>[];

  String? _selectedLibraryId;
  String _provider = 'audible.com';
  String _region = 'US';
  bool _searchForAsin = true;
  bool _useTracksAsChapters = false;
  bool _disableRateProtection = false;

  String? _thresholdError;
  String? _errorMessage;
  bool _isRunning = false;
  bool _cancelRequested = false;
  int _processed = 0;
  int _total = 0;
  MatchAudiobookChaptersToolResult? _result;

  @override
  void dispose() {
    _cancelRequested = true;
    _thresholdController.dispose();
    _logScrollController.dispose();
    super.dispose();
  }

  int? _parseThreshold() {
    final parsed = int.tryParse(_thresholdController.text.trim());
    if (parsed == null || parsed < 0) {
      return null;
    }

    return parsed;
  }

  void _appendLog(String line) {
    if (!mounted) {
      return;
    }

    setState(() {
      _logs.add(line);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_logScrollController.hasClients) {
        return;
      }

      _logScrollController.jumpTo(_logScrollController.position.maxScrollExtent);
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
      });
      return;
    }

    final threshold = _parseThreshold();
    if (threshold == null) {
      setState(() {
        _thresholdError = l10n.errorInvalidChapterThreshold;
      });
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      setState(() {
        _errorMessage = l10n.errorNoActiveApiClient;
      });
      return;
    }

    setState(() {
      _isRunning = true;
      _cancelRequested = false;
      _thresholdError = null;
      _errorMessage = null;
      _processed = 0;
      _total = 0;
      _result = null;
      _logs.clear();
    });

    try {
      final result = await runMatchAudiobookChaptersTool(
        api: api,
        libraryId: libraryId,
        options: MatchAudiobookChaptersOptions(
          chapterThreshold: threshold,
          provider: _provider,
          region: _region,
          searchForAsin: _searchForAsin,
          useTracksAsChapters: _useTracksAsChapters,
          disableRateProtection: _disableRateProtection,
        ),
        onLog: _appendLog,
        onProgress: (processed, total) {
          if (!mounted) {
            return;
          }

          setState(() {
            _processed = processed;
            _total = total;
          });
        },
        isCancelled: () => _cancelRequested || !mounted,
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
        _errorMessage = l10n.errorOperationFailed(l10n.headingMatchAudiobookChapters, error.toString());
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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final errorMessage = _errorMessage;
    final showProgressCard = _isRunning || _result != null || _logs.isNotEmpty;

    return SettingsPageScaffold(
      title: l10n.headingMatchAudiobookChapters,
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: SettingsRoutes.tools,
      children: [
        LibrarySelectionList.singleSelect(
          title: l10n.fieldLibrary,
          mediaTypeFilter: 'book',
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
        MatchAudiobookChaptersOptionsCard(
          thresholdController: _thresholdController,
          thresholdError: _thresholdError,
          provider: _provider,
          region: _region,
          searchForAsin: _searchForAsin,
          useTracksAsChapters: _useTracksAsChapters,
          disableRateProtection: _disableRateProtection,
          isRunning: _isRunning,
          onThresholdChanged: (_) {
            if (_thresholdError == null) {
              return;
            }
            setState(() {
              _thresholdError = null;
            });
          },
          onProviderChanged: (value) {
            if (value == null) {
              return;
            }
            setState(() {
              _provider = value;
            });
          },
          onRegionChanged: (value) {
            if (value == null) {
              return;
            }
            setState(() {
              _region = value;
            });
          },
          onSearchForAsinChanged: (value) {
            setState(() {
              _searchForAsin = value;
            });
          },
          onUseTracksAsChaptersChanged: (value) {
            setState(() {
              _useTracksAsChapters = value;
            });
          },
          onDisableRateProtectionChanged: (value) {
            setState(() {
              _disableRateProtection = value;
            });
          },
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (_isRunning) ...[
              YaabsaButton(
                label: Text(_cancelRequested ? l10n.statusStoppingMatching : l10n.actionStopMatching),
                icon: const Icon(Icons.stop_rounded),
                variant: YaabsaButtonVariant.outlined,
                onPressed: _cancelRequested
                    ? null
                    : () {
                        setState(() {
                          _cancelRequested = true;
                        });
                      },
              ),
              const SizedBox(width: 12),
            ],
            YaabsaButton(
              label: Text(_isRunning ? l10n.statusRunning : l10n.actionRun),
              icon: const Icon(Icons.auto_fix_high_rounded),
              isLoading: _isRunning,
              onPressed: _isRunning ? null : () => unawaited(_runTool()),
            ),
          ],
        ),
        if (errorMessage != null && errorMessage.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildErrorCard(context, errorMessage),
        ],
        if (showProgressCard) ...[
          const SizedBox(height: 16),
          MatchAudiobookChaptersProgressCard(
            isRunning: _isRunning,
            processed: _processed,
            total: _total,
            result: _result,
            logs: _logs,
            logScrollController: _logScrollController,
          ),
        ],
      ],
    );
  }
}
