import 'package:flutter/widget_previews.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:yaabsa/ui/components/inputs/search_field.dart';

import 'preview_theme.dart';

@Preview(name: 'Inputs / light', size: Size(390, 844), wrapper: yaabsaPreviewLight)
@Preview(name: 'Inputs / dark', size: Size(390, 844), wrapper: yaabsaPreviewDark)
@Preview(name: 'Inputs / AMOLED', size: Size(390, 844), wrapper: yaabsaPreviewAmoled)
Widget inputStatesPreview() => const InputStatesPreview();

@Preview(name: 'Search and sort / light', size: Size(390, 320), wrapper: yaabsaPreviewLight)
@Preview(name: 'Search and sort / dark', size: Size(390, 320), wrapper: yaabsaPreviewDark)
@Preview(name: 'Search and sort / AMOLED', size: Size(390, 320), wrapper: yaabsaPreviewAmoled)
Widget searchAndSortPreview() => const SearchAndSortPreview();

class SearchAndSortPreview extends StatefulWidget {
  const SearchAndSortPreview({super.key});

  @override
  State<SearchAndSortPreview> createState() => _SearchAndSortPreviewState();
}

class _SearchAndSortPreviewState extends State<SearchAndSortPreview> {
  final _search = TextEditingController(text: 'The distant shore');
  String _sort = 'Title';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Search controls', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        YaabsaSearchField(controller: _search, hintText: 'Search your library'),
        const SizedBox(height: 12),
        YaabsaDropdownField<String>(
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
      ],
    );
  }
}

class InputStatesPreview extends StatefulWidget {
  const InputStatesPreview({super.key});

  @override
  State<InputStatesPreview> createState() => _InputStatesPreviewState();
}

class _InputStatesPreviewState extends State<InputStatesPreview> {
  final _search = TextEditingController(text: 'The distant shore');
  String _sort = 'Title';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const StyledTextField(label: 'Title', hintText: 'Book title'),
        const SizedBox(height: 16),
        YaabsaSearchField(controller: _search, hintText: 'Search the library'),
        const SizedBox(height: 16),
        const StyledTextField(label: 'Password', obscureText: true, autocorrect: false, enableSuggestions: false),
        const SizedBox(height: 16),
        const StyledTextField(label: 'Number of files', keyboardType: TextInputType.number, isDense: true),
        const SizedBox(height: 16),
        const StyledTextField(label: 'Note', minLines: 2, maxLines: 4),
        const SizedBox(height: 16),
        const StyledTextField(label: 'Server address', errorText: 'Enter a valid address'),
        const SizedBox(height: 16),
        const StyledTextField(label: 'Unavailable', enabled: false),
        const SizedBox(height: 16),
        const StyledTextFormField(label: 'Read only', initialValue: 'A distant shore', readOnly: true),
        const SizedBox(height: 16),
        YaabsaDropdownField<String>(
          label: 'Sort by',
          value: _sort,
          items: const [
            DropdownMenuItem(value: 'Title', child: Text('Title')),
            DropdownMenuItem(value: 'Author', child: Text('Author')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() => _sort = value);
            }
          },
        ),
      ],
    );
  }
}
