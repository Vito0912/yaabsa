import 'package:flutter/widget_previews.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/screens/reader/widgets/reader_annotation_details_presentation.dart';

import 'preview_theme.dart';

@Preview(name: 'Reader annotation / light', size: Size(520, 340), wrapper: yaabsaPreviewLight)
@Preview(name: 'Reader annotation / dark', size: Size(520, 340), wrapper: yaabsaPreviewDark)
@Preview(name: 'Reader annotation / AMOLED', size: Size(520, 340), wrapper: yaabsaPreviewAmoled)
Widget readerAnnotationDetailsPreview() => const ReaderAnnotationDetailsPreview();

class ReaderAnnotationDetailsPreview extends StatelessWidget {
  const ReaderAnnotationDetailsPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return ReaderAnnotationDetailsPresentation(
      note: 'A short note attached to this highlighted passage in the book.',
      onEdit: _ignoreAnnotationAction,
      onDelete: _ignoreAnnotationAction,
      onClose: _ignoreAnnotationAction,
    );
  }
}

void _ignoreAnnotationAction() {}
