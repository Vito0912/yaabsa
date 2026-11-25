import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/ui/components/lists/multi_select_list_card.dart';
import 'package:yaabsa/util/l10n.dart';

class AdminToolLibrarySelector extends StatelessWidget {
  const AdminToolLibrarySelector({
    super.key,
    required this.libraries,
    required this.selectedLibraryIds,
    required this.onSelectionChanged,
    this.enabled = true,
    this.maxHeight = 240,
  });

  final List<Library> libraries;
  final Set<String> selectedLibraryIds;
  final ValueChanged<Set<String>> onSelectionChanged;
  final bool enabled;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final options = libraries
        .map((library) => YaabsaMultiSelectOption(id: library.id, label: library.name, subtitle: library.mediaType))
        .toList(growable: false);

    return YaabsaMultiSelectListCard(
      title: context.l10n.fieldTargetLibraries,
      options: options,
      selectedIds: selectedLibraryIds,
      onSelectionChanged: onSelectionChanged,
      enabled: enabled,
      maxHeight: maxHeight,
      emptyMessage: context.l10n.statusNoLibrariesFound,
    );
  }
}
