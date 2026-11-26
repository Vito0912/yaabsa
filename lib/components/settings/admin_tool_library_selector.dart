import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/components/common/library_selection_list.dart';

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
    return LibrarySelectionList.multiSelect(
      libraries: libraries,
      selectedLibraryIds: selectedLibraryIds,
      onSelectionChanged: onSelectionChanged,
      enabled: enabled,
      maxHeight: maxHeight,
    );
  }
}
