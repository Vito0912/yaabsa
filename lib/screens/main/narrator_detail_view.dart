import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/api/library/request/library_filter.dart';
import 'package:yaabsa/screens/main/library_view.dart';

class NarratorDetailView extends StatelessWidget {
  const NarratorDetailView({super.key, required this.narratorName});

  final String narratorName;

  @override
  Widget build(BuildContext context) {
    final narratorFilter = LibraryFilter.grouped(LibraryFilterGroup.narrators, narratorName).queryValue;

    return LibraryView(
      initialFilter: narratorFilter,
      toolbarTitle: narratorName,
      onToolbarBack: () {
        if (context.canPop()) {
          context.pop();
          return;
        }

        context.go('/?tab=narrators&intent=${DateTime.now().microsecondsSinceEpoch}');
      },
    );
  }
}
