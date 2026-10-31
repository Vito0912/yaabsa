import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/changelog/changelog_entry_text.dart';
import 'package:yaabsa/util/changelog.dart';

class ChangelogReleaseCard extends StatelessWidget {
  const ChangelogReleaseCard({super.key, required this.release, this.initiallyExpanded = false, this.onSponsor});

  final ChangelogRelease release;
  final bool initiallyExpanded;
  final VoidCallback? onSponsor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card.filled(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        key: PageStorageKey(release.version),
        initiallyExpanded: initiallyExpanded,
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        shape: const Border(),
        collapsedShape: const Border(),
        title: Text('Version ${release.version}', style: theme.textTheme.titleMedium),
        children: [
          for (final section in release.sections)
            if (section.entries.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(section.title, style: theme.textTheme.titleSmall?.copyWith(color: colors.primary)),
                    const SizedBox(height: 8),
                    for (final entry in section.entries)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('•  '),
                          Expanded(
                            child: SelectionArea(child: ChangelogEntryText(entry: entry)),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
          if (onSponsor != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: onSponsor,
                  icon: const Icon(Icons.favorite_outline),
                  label: const Text('Sponsors'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
