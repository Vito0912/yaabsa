import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/library/widgets/library_entity_list_card.dart';

class NarratorCard extends StatelessWidget {
  const NarratorCard({super.key, required this.name, this.subtitle, this.onTap});

  final String name;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LibraryEntityListCard(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.7)),
        ),
        child: Icon(Icons.record_voice_over_rounded, color: colorScheme.primary),
      ),
      title: name,
      subtitle: subtitle,
      onTap: onTap,
    );
  }
}
