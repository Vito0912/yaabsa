import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/api/library/request/library_filter.dart';
import 'package:yaabsa/screens/main/library_view.dart';

class NarratorDetailView extends StatelessWidget {
  const NarratorDetailView({super.key, required this.narratorName});

  final String narratorName;

  @override
  Widget build(BuildContext context) {
    final narratorFilter = LibraryFilter.grouped(LibraryFilterGroup.narrators, narratorName).queryValue;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                    return;
                  }

                  context.go('/?tab=narrators&intent=${DateTime.now().microsecondsSinceEpoch}');
                },
                icon: const Icon(Icons.arrow_back_rounded),
                tooltip: 'Back',
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  narratorName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
        Expanded(child: LibraryView(initialFilter: narratorFilter)),
      ],
    );
  }
}
