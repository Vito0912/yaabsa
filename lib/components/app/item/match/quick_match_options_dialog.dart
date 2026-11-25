import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/library_items/request/quick_match_library_item_options.dart';
import 'package:yaabsa/api/search/search_provider_option.dart';
import 'package:yaabsa/components/app/item/match/manual_match/manual_match_provider_dropdown.dart';
import 'package:yaabsa/components/app/item/match/quick_match_preview_dialog.dart';
import 'package:yaabsa/provider/common/upload_providers.dart';
import 'package:yaabsa/ui/components/settings/settings_switch_presentation.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/util/l10n.dart';

Future<QuickMatchLibraryItemOptions?> showQuickMatchOptionsDialog({
  required BuildContext context,
  required String mediaType,
  List<LibraryItem> previewItems = const <LibraryItem>[],
  String? title,
  String? description,
  String? confirmLabel,
  String? initialProvider,
  bool initialOverrideCover = true,
  bool initialOverrideDetails = true,
}) {
  return showDialog<QuickMatchLibraryItemOptions>(
    context: context,
    builder: (context) {
      return QuickMatchOptionsDialog(
        mediaType: mediaType,
        previewItems: previewItems,
        title: title ?? context.l10n.actionQuickMatch,
        description: description,
        confirmLabel: confirmLabel ?? context.l10n.actionRunQuickMatch,
        initialProvider: initialProvider,
        initialOverrideCover: initialOverrideCover,
        initialOverrideDetails: initialOverrideDetails,
      );
    },
  );
}

class QuickMatchOptionsDialog extends ConsumerStatefulWidget {
  const QuickMatchOptionsDialog({
    super.key,
    required this.mediaType,
    required this.previewItems,
    required this.title,
    required this.confirmLabel,
    this.description,
    this.initialProvider,
    this.initialOverrideCover = true,
    this.initialOverrideDetails = true,
  });

  final String mediaType;
  final List<LibraryItem> previewItems;
  final String title;
  final String? description;
  final String confirmLabel;
  final String? initialProvider;
  final bool initialOverrideCover;
  final bool initialOverrideDetails;

  @override
  ConsumerState<QuickMatchOptionsDialog> createState() => _QuickMatchOptionsDialogState();
}

class _QuickMatchOptionsDialogState extends ConsumerState<QuickMatchOptionsDialog> {
  final Set<String> _selectedProviders = <String>{};
  late bool _overrideCover;
  late bool _overrideDetails;

  @override
  void initState() {
    super.initState();
    _overrideCover = widget.initialOverrideCover;
    _overrideDetails = widget.initialOverrideDetails;
    if (widget.initialProvider != null && widget.initialProvider!.trim().isNotEmpty) {
      _selectedProviders.add(widget.initialProvider!);
    }
  }

  void _syncProviderSelection(List<SearchProviderOption> providers) {
    if (providers.isEmpty) {
      if (_selectedProviders.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) {
            return;
          }
          setState(() {
            _selectedProviders.clear();
          });
        });
      }
      return;
    }

    final validValues = providers.map((p) => p.value).toSet();
    final effective = _selectedProviders.intersection(validValues);
    if (effective.length == _selectedProviders.length && _selectedProviders.isNotEmpty) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _selectedProviders.clear();
        _selectedProviders.addAll(effective);
        if (_selectedProviders.isEmpty) {
          final requestedInitial = widget.initialProvider?.trim();
          String? fallback;
          if (requestedInitial != null && requestedInitial.isNotEmpty) {
            fallback = _findMatchingProviderValue(providers, requestedInitial);
          }
          fallback ??= providers.first.value;
          _selectedProviders.add(fallback);
        }
      });
    });
  }

  String? _findMatchingProviderValue(List<SearchProviderOption> providers, String requestedValue) {
    final normalizedRequested = requestedValue.trim().toLowerCase();
    for (final provider in providers) {
      if (provider.value.trim().toLowerCase() == normalizedRequested) {
        return provider.value;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final providersAsync = ref.watch(uploadMetadataProvidersProvider(widget.mediaType));

    final providers = providersAsync.asData?.value ?? const <SearchProviderOption>[];
    _syncProviderSelection(providers);

    final canSubmit = _selectedProviders.length == 1;
    final canPreview = _selectedProviders.isNotEmpty && widget.previewItems.isNotEmpty;

    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 440,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.description != null && widget.description!.trim().isNotEmpty) ...[
              Text(widget.description!),
              const SizedBox(height: 12),
            ],
            providersAsync.when(
              loading: () => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    const SizedBox(width: 18, height: 18, child: YaabsaCircularProgressIndicator(strokeWidth: 2.2)),
                    const SizedBox(width: 10),
                    Text(context.l10n.statusLoadingMetadataProviders),
                  ],
                ),
              ),
              error: (error, _) => Text(
                context.l10n.errorLoadMetadataProvidersFailed,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              data: (loadedProviders) {
                if (loadedProviders.isEmpty) {
                  return Text(context.l10n.statusNoProvidersForMediaType);
                }

                return ManualMatchProviderDropdown(
                  providers: loadedProviders,
                  selectedProviderValues: _selectedProviders,
                  onSelectionChanged: (values) {
                    setState(() {
                      _selectedProviders.clear();
                      _selectedProviders.addAll(values);
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 8),
            SettingsSwitchPresentation(
              value: _overrideDetails,
              label: context.l10n.settingOverwriteCurrentMetadata,
              contentPadding: EdgeInsets.zero,
              description: context.l10n.settingOverwriteCurrentMetadataDescription,
              onChanged: (value) {
                setState(() {
                  _overrideDetails = value;
                });
              },
            ),
            SettingsSwitchPresentation(
              value: _overrideCover,
              label: context.l10n.settingOverwriteCoverImage,
              contentPadding: EdgeInsets.zero,
              description: context.l10n.settingOverwriteCoverImageDescription,
              onChanged: (value) {
                setState(() {
                  _overrideCover = value;
                });
              },
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.end,
              children: [
                TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(context.l10n.actionCancel)),
                OutlinedButton.icon(
                  onPressed: canPreview
                      ? () async {
                          final applied = await showQuickMatchPreviewDialog(
                            context: context,
                            items: widget.previewItems,
                            mediaType: widget.mediaType,
                            providerValues: _selectedProviders.toList(),
                            overrideCover: _overrideCover,
                            overrideDetails: _overrideDetails,
                          );

                          if (!context.mounted || !applied) {
                            return;
                          }

                          Navigator.of(context).pop();
                        }
                      : null,
                  icon: const Icon(Icons.preview_rounded),
                  label: Text(context.l10n.actionPreview),
                ),
                Tooltip(
                  message: _selectedProviders.length > 1 ? context.l10n.hintQuickMatchSingleProviderOnly : '',
                  child: FilledButton(
                    onPressed: canSubmit
                        ? () {
                            Navigator.of(context).pop(
                              QuickMatchLibraryItemOptions(
                                provider: _selectedProviders.first,
                                overrideCover: _overrideCover,
                                overrideDetails: _overrideDetails,
                              ),
                            );
                          }
                        : null,
                    child: Text(widget.confirmLabel),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
