import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/library_items/request/quick_match_library_item_options.dart';
import 'package:yaabsa/api/search/search_provider_option.dart';
import 'package:yaabsa/provider/common/upload_providers.dart';

import 'package:yaabsa/generated/l10n.dart';

Future<QuickMatchLibraryItemOptions?> showQuickMatchOptionsDialog({
  required BuildContext context,
  required String mediaType,
  String title = 'Quick match',
  String? description,
  String confirmLabel = 'Run quick match',
  String? initialProvider,
  bool initialOverrideCover = true,
  bool initialOverrideDetails = true,
}) {
  return showDialog<QuickMatchLibraryItemOptions>(
    context: context,
    builder: (context) {
      return QuickMatchOptionsDialog(
        mediaType: mediaType,
        title: title,
        description: description,
        confirmLabel: confirmLabel,
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
    required this.title,
    required this.confirmLabel,
    this.description,
    this.initialProvider,
    this.initialOverrideCover = true,
    this.initialOverrideDetails = true,
  });

  final String mediaType;
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
  String? _provider;
  late bool _overrideCover;
  late bool _overrideDetails;

  @override
  void initState() {
    super.initState();
    _provider = widget.initialProvider;
    _overrideCover = widget.initialOverrideCover;
    _overrideDetails = widget.initialOverrideDetails;
  }

  void _syncProviderSelection(List<SearchProviderOption> providers) {
    if (providers.isEmpty) {
      if (_provider != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) {
            return;
          }
          setState(() {
            _provider = null;
          });
        });
      }
      return;
    }

    final hasCurrentProvider = providers.any((provider) => provider.value == _provider);
    if (hasCurrentProvider) {
      return;
    }

    String? fallbackProvider;
    final requestedInitial = widget.initialProvider?.trim();
    if (requestedInitial != null && requestedInitial.isNotEmpty) {
      fallbackProvider = _findMatchingProviderValue(providers, requestedInitial);
    }
    fallbackProvider ??= providers.first.value;

    if (fallbackProvider == _provider) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _provider = fallbackProvider;
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

    final canSubmit = providers.isNotEmpty && _provider != null;

    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 440,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.description != null && widget.description!.trim().isNotEmpty) ...[
              Text(widget.description!),
              const SizedBox(height: 12),
            ],
            providersAsync.when(
              loading: () => Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2.2)),
                    SizedBox(width: 10),
                    Text(S.current.componentsAppItemMatchQuickMatchOptionsDialogLoadingProviders),
                  ],
                ),
              ),
              error: (error, _) => Text(
                S.current.componentsAppItemMatchQuickMatchOptionsDialogCouldNotLoadMetadataProviders(error),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              data: (loadedProviders) {
                if (loadedProviders.isEmpty) {
                  return Text(
                    S.current.componentsAppItemMatchQuickMatchOptionsDialogNoMetadataProvidersAreAvailableFor,
                  );
                }

                return DropdownButtonFormField<String>(
                  key: ValueKey<String?>(_provider),
                  initialValue: _provider,
                  decoration: InputDecoration(
                    labelText: S.current.componentsAppItemMatchQuickMatchOptionsDialogProvider,
                  ),
                  items: loadedProviders
                      .map((provider) => DropdownMenuItem<String>(value: provider.value, child: Text(provider.text)))
                      .toList(growable: false),
                  onChanged: (value) {
                    setState(() {
                      _provider = value;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              value: _overrideDetails,
              contentPadding: EdgeInsets.zero,
              title: Text(S.current.componentsAppItemMatchQuickMatchOptionsDialogOverwriteCurrentMetadata),
              subtitle: Text(
                S.current.componentsAppItemMatchQuickMatchOptionsDialogReplaceExistingTitleAuthorDescriptionAnd,
              ),
              onChanged: (value) {
                setState(() {
                  _overrideDetails = value;
                });
              },
            ),
            SwitchListTile(
              value: _overrideCover,
              contentPadding: EdgeInsets.zero,
              title: Text(S.current.componentsAppItemMatchQuickMatchOptionsDialogOverwriteCoverImage),
              subtitle: Text(S.current.componentsAppItemMatchQuickMatchOptionsDialogReplaceCurrentCoverArtworkWhenA),
              onChanged: (value) {
                setState(() {
                  _overrideCover = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(S.current.componentsAppItemMatchQuickMatchOptionsDialogCancel),
        ),
        FilledButton(
          onPressed: canSubmit
              ? () {
                  Navigator.of(context).pop(
                    QuickMatchLibraryItemOptions(
                      provider: _provider,
                      overrideCover: _overrideCover,
                      overrideDetails: _overrideDetails,
                    ),
                  );
                }
              : null,
          child: Text(widget.confirmLabel),
        ),
      ],
    );
  }
}
