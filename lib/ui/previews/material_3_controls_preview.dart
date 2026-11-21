import 'package:flutter/widget_previews.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/ui/components/inputs/expressive_dropdown.dart';
import 'package:yaabsa/ui/components/menus/yaabsa_context_menu_button.dart';
import 'package:yaabsa/ui/components/buttons/yaabsa_button.dart';

import 'preview_theme.dart';

@Preview(name: 'Material 3 Expressive controls / light', size: Size(640, 520), wrapper: yaabsaPreviewLight)
@Preview(name: 'Material 3 Expressive controls / dark', size: Size(640, 520), wrapper: yaabsaPreviewDark)
@Preview(name: 'Material 3 Expressive controls / AMOLED', size: Size(640, 520), wrapper: yaabsaPreviewAmoled)
Widget material3ExpressiveControlsPreview() => const Material3ExpressiveControlsPreview();

@Preview(name: 'Shared buttons / light', size: Size(390, 640), wrapper: yaabsaPreviewLight)
@Preview(name: 'Shared buttons / dark', size: Size(390, 640), wrapper: yaabsaPreviewDark)
@Preview(name: 'Shared buttons / AMOLED', size: Size(390, 640), wrapper: yaabsaPreviewAmoled)
Widget sharedButtonsPreview() {
  return ListView(
    padding: const EdgeInsets.all(16),
    children: [
      for (final variant in YaabsaButtonVariant.values)
        Wrap(
          spacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            YaabsaButton(
              label: Text(variant.name),
              icon: const Icon(Icons.add_rounded),
              variant: variant,
              onPressed: () {},
            ),
            YaabsaButton.small(label: const Text('Small'), variant: variant, onPressed: () {}),
            YaabsaButton.iconSmall(
              icon: const Icon(Icons.add_rounded),
              tooltip: 'Add',
              variant: variant,
              onPressed: () {},
            ),
          ],
        ),
      const YaabsaButton(label: Text('Disabled'), onPressed: null),
      YaabsaButton.small(label: const Text('Loading'), isLoading: true, onPressed: () {}),
      YaabsaButton.small(
        label: const Text('A long representative collection action'),
        icon: const Icon(Icons.add_rounded),
        onPressed: () {},
      ),
    ],
  );
}

class Material3ExpressiveControlsPreview extends StatefulWidget {
  const Material3ExpressiveControlsPreview({super.key});

  @override
  State<Material3ExpressiveControlsPreview> createState() => _Material3ExpressiveControlsPreviewState();
}

class _Material3ExpressiveControlsPreviewState extends State<Material3ExpressiveControlsPreview> {
  String _sort = 'Title';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Material 3 Expressive controls', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        Text('Loading and progress', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        Row(
          children: [
            const YaabsaLoadingIndicator(size: 48),
            const SizedBox(width: 20),
            const YaabsaCircularProgressIndicator(value: 0.64, size: 48),
            const SizedBox(width: 20),
            const SizedBox(width: 18, height: 18, child: YaabsaCircularProgressIndicator(strokeWidth: 2)),
            const SizedBox(width: 20),
            Expanded(child: YaabsaLinearProgressIndicator(value: 0.42, minHeight: 6)),
          ],
        ),
        const SizedBox(height: 20),
        Text('Dropdown', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        YaabsaDropdownField<String>(
          key: const ValueKey('m3e-controls.dropdown'),
          label: 'Sort by',
          value: _sort,
          items: const [
            DropdownMenuItem(value: 'Title', child: Text('Title')),
            DropdownMenuItem(value: 'Author', child: Text('Author')),
            DropdownMenuItem(value: 'Recently added', child: Text('Recently added')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() => _sort = value);
            }
          },
        ),
        const SizedBox(height: 20),
        Text('Context menu', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: YaabsaContextMenuButton<String>(
            key: const ValueKey('m3e-controls.context-menu'),
            tooltip: 'More actions',
            icon: const Icon(Icons.more_vert_rounded),
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
              PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ),
      ],
    );
  }
}
