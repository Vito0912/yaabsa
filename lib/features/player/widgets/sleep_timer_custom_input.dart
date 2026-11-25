import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/buttons/yaabsa_button.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:yaabsa/util/l10n.dart';

class SleepTimerCustomInput extends StatelessWidget {
  const SleepTimerCustomInput({
    super.key,
    required this.controller,
    required this.chapterMode,
    required this.onChanged,
    required this.onSet,
  });

  final TextEditingController controller;
  final bool chapterMode;
  final ValueChanged<String> onChanged;
  final VoidCallback onSet;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge;
    final fontSize = textStyle?.fontSize ?? 16;
    final scaledFontSize = MediaQuery.textScalerOf(context).scale(fontSize);
    final floatingLabelReserve = math.max(0.0, scaledFontSize - fontSize) * 0.75;
    final contentPadding = EdgeInsets.fromLTRB(12, 12 + floatingLabelReserve, 12, 12);
    final decoration = yaabsaFieldDecoration(context, textStyle: textStyle, contentPadding: contentPadding);
    final fieldHeight = decoration.constraints?.minHeight ?? YaabsaFieldDimensions.standardHeight;

    return SizedBox(
      height: fieldHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: StyledTextField(
              controller: controller,
              style: textStyle,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.center,
              contentPadding: contentPadding,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: onChanged,
              onSubmitted: (_) => onSet(),
              label: chapterMode ? context.l10n.fieldChapterCount : context.l10n.fieldMinutes,
              hintText: chapterMode ? '1' : null,
            ),
          ),
          const SizedBox(width: 12),
          YaabsaButton(onPressed: onSet, icon: const Icon(Icons.bedtime), label: Text(context.l10n.actionSet)),
        ],
      ),
    );
  }
}
