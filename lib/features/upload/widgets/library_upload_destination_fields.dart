import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';

class LibraryUploadDestinationFields extends StatelessWidget {
  const LibraryUploadDestinationFields({
    super.key,
    required this.folderValue,
    required this.providerValue,
    required this.folderItems,
    required this.providerItems,
    required this.enabled,
    required this.onFolderChanged,
    required this.onProviderChanged,
  });

  final String? folderValue;
  final String? providerValue;
  final List<DropdownMenuItem<String>> folderItems;
  final List<DropdownMenuItem<String>> providerItems;
  final bool enabled;
  final ValueChanged<String?> onFolderChanged;
  final ValueChanged<String?> onProviderChanged;

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final minimumRowWidth = (200 * textScale * 2) + 10;

    return LayoutBuilder(
      builder: (context, constraints) {
        final folderField = YaabsaDropdownField<String>(
          label: 'Library folder',
          value: folderValue,
          onChanged: enabled ? onFolderChanged : null,
          items: folderItems,
        );
        final providerField = YaabsaDropdownField<String>(
          label: 'Metadata provider',
          value: providerValue,
          onChanged: enabled ? onProviderChanged : null,
          items: providerItems,
        );

        if (!constraints.maxWidth.isFinite || constraints.maxWidth < minimumRowWidth) {
          return Column(
            key: const ValueKey<String>('uploadDestinationFieldsStacked'),
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [folderField, const SizedBox(height: 8), providerField],
          );
        }

        return Row(
          key: const ValueKey<String>('uploadDestinationFieldsInline'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: folderField),
            const SizedBox(width: 10),
            Expanded(child: providerField),
          ],
        );
      },
    );
  }
}
