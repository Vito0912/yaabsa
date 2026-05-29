import 'package:flutter/material.dart';
import 'package:yaabsa/components/common/inputs/styled_form_fields.dart';

class LibraryItemEditorSectionCard extends StatelessWidget {
  const LibraryItemEditorSectionCard({super.key, required this.title, required this.child, this.subtitle});

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(color: colorScheme.surfaceContainer, borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}

class LibraryItemEditorTextField extends StatelessWidget {
  const LibraryItemEditorTextField({
    super.key,
    required this.label,
    this.controller,
    this.hintText,
    this.maxLines = 1,
    this.keyboardType,
    this.onChanged,
  });

  final String label;
  final TextEditingController? controller;
  final String? hintText;
  final int maxLines;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return StyledTextField(
      label: label,
      controller: controller,
      hintText: hintText,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: onChanged,
    );
  }
}

class LibraryItemEditorPodcastTypeField extends StatelessWidget {
  const LibraryItemEditorPodcastTypeField({super.key, required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  static const _allowedValues = <String>{'episodic', 'serial'};

  @override
  Widget build(BuildContext context) {
    final selectedValue = _allowedValues.contains(value.trim().toLowerCase()) ? value.trim().toLowerCase() : 'episodic';

    return YaabsaDropdownField<String>(
      label: 'Podcast type',
      value: selectedValue,
      items: const [
        DropdownMenuItem<String>(value: 'episodic', child: Text('Episodic')),
        DropdownMenuItem<String>(value: 'serial', child: Text('Serial')),
      ],
      onChanged: (nextValue) {
        if (nextValue == null) {
          return;
        }
        onChanged(nextValue);
      },
    );
  }
}
