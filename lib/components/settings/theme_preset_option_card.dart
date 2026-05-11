import 'package:flutter/material.dart';

class ThemePresetOptionCard extends StatelessWidget {
  const ThemePresetOptionCard({
    super.key,
    required this.title,
    required this.description,
    required this.accentColor,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String description;
  final Color accentColor;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = selected ? colorScheme.primary : colorScheme.outlineVariant.withValues(alpha: 0.7);
    final cardBackground = selected
        ? colorScheme.primaryContainer.withValues(alpha: 0.34)
        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.35);

    final previewBackground = accentColor.withValues(alpha: 0.12);
    final previewChip = accentColor.withValues(alpha: 0.2);

    return Material(
      color: cardBackground,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: selected ? 1.5 : 1.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (selected)
                      Icon(Icons.check_circle, color: colorScheme.primary, size: 18)
                    else
                      Icon(Icons.circle_outlined, color: colorScheme.outline, size: 18),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 44,
                    color: previewBackground,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 16,
                            decoration: BoxDecoration(color: accentColor, borderRadius: BorderRadius.circular(999)),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: previewChip,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  width: 22,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: accentColor.withValues(alpha: 0.8),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant, height: 1.25),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
