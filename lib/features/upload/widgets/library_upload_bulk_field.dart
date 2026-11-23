import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';

class LibraryUploadBulkField extends StatelessWidget {
  static const double minimumInlineWidth = 340;

  const LibraryUploadBulkField({
    super.key,
    required this.label,
    required this.applyLabel,
    required this.controller,
    required this.onApply,
    this.enabled = true,
  });

  final String label;
  final String applyLabel;
  final TextEditingController controller;
  final VoidCallback? onApply;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final minimumWidth = minimumInlineWidthForTextScale(textScale);

    return LayoutBuilder(
      builder: (context, constraints) {
        final field = StyledTextField(label: label, controller: controller, enabled: enabled);
        final action = FilledButton.tonal(onPressed: enabled ? onApply : null, child: Text(applyLabel));

        if (!constraints.maxWidth.isFinite || constraints.maxWidth < minimumWidth) {
          return Column(
            key: const ValueKey<String>('uploadBulkFieldStacked'),
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              field,
              const SizedBox(height: 8),
              Align(alignment: Alignment.centerRight, child: action),
            ],
          );
        }

        return Row(
          key: const ValueKey<String>('uploadBulkFieldInline'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: field),
            const SizedBox(width: 8),
            action,
          ],
        );
      },
    );
  }

  static double minimumInlineWidthForTextScale(double textScale) => minimumInlineWidth * textScale;
}
