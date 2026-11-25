import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/search/search_provider_option.dart';
import 'package:yaabsa/components/app/item/match/manual_match/manual_match_provider_dropdown.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/util/l10n.dart';

class ManualMatchSearchCard extends StatelessWidget {
  const ManualMatchSearchCard({
    super.key,
    required this.titleController,
    required this.authorController,
    required this.searching,
    required this.providersAsync,
    required this.selectedProviderValues,
    required this.onProviderSelectionChanged,
    required this.onSearch,
  });

  final TextEditingController titleController;
  final TextEditingController authorController;
  final bool searching;
  final AsyncValue<List<SearchProviderOption>> providersAsync;
  final Set<String> selectedProviderValues;
  final ValueChanged<Set<String>> onProviderSelectionChanged;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final providerField = _buildProviderField(context);
            final titleField = StyledTextField(
              controller: titleController,
              label: context.l10n.fieldTitle,
              hintText: context.l10n.hintSearchTitle,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => onSearch(),
            );
            final authorField = StyledTextField(
              controller: authorController,
              label: context.l10n.fieldAuthor,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => onSearch(),
            );
            final searchButton = FilledButton.icon(
              onPressed: searching ? null : onSearch,
              icon: searching
                  ? const SizedBox(width: 16, height: 16, child: YaabsaCircularProgressIndicator(strokeWidth: 2.2))
                  : const Icon(Icons.search_rounded),
              label: Text(searching ? context.l10n.statusSearching : context.l10n.actionSearch),
            );

            if (constraints.maxWidth >= 980) {
              return Row(
                children: [
                  SizedBox(width: 220, child: providerField),
                  const SizedBox(width: 10),
                  Expanded(flex: 3, child: titleField),
                  const SizedBox(width: 10),
                  Expanded(flex: 2, child: authorField),
                  const SizedBox(width: 10),
                  searchButton,
                ],
              );
            }

            if (constraints.maxWidth >= 700) {
              return Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 220, child: providerField),
                      const SizedBox(width: 10),
                      Expanded(child: titleField),
                      const SizedBox(width: 10),
                      searchButton,
                    ],
                  ),
                  const SizedBox(height: 10),
                  authorField,
                ],
              );
            }

            return Column(
              children: [
                providerField,
                const SizedBox(height: 10),
                titleField,
                const SizedBox(height: 10),
                authorField,
                const SizedBox(height: 10),
                Align(alignment: Alignment.centerRight, child: searchButton),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProviderField(BuildContext context) {
    return providersAsync.when(
      loading: () => InputDecorator(
        decoration: yaabsaFieldDecoration(context, label: context.l10n.fieldMetadataProviders),
        child: Row(
          children: [
            const SizedBox(width: 14, height: 14, child: YaabsaCircularProgressIndicator(strokeWidth: 2.0)),
            const SizedBox(width: 8),
            Text(context.l10n.statusLoading),
          ],
        ),
      ),
      error: (_, _) => InputDecorator(
        decoration: yaabsaFieldDecoration(context, label: context.l10n.fieldMetadataProviders),
        child: Text(context.l10n.errorLoadMetadataProvidersFailed, style: Theme.of(context).textTheme.bodySmall),
      ),
      data: (providers) {
        if (providers.isEmpty) {
          return InputDecorator(
            decoration: yaabsaFieldDecoration(context, label: context.l10n.fieldMetadataProviders),
            child: Text(context.l10n.statusNoMetadataProvidersAvailable),
          );
        }

        return ManualMatchProviderDropdown(
          providers: providers,
          selectedProviderValues: selectedProviderValues,
          onSelectionChanged: onProviderSelectionChanged,
          enabled: !searching,
        );
      },
    );
  }
}
