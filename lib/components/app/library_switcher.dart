import 'package:buchshelfly/provider/common/library_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibrarySwitcher extends ConsumerWidget {
  const LibrarySwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userLibrariesAsyncValue = ref.watch(userLibrariesProvider);
    final selectedLibraryId = ref.watch(selectedLibraryIdProvider);

    return userLibrariesAsyncValue.when(
      data: (libraries) {
        if (libraries == null || libraries.isEmpty) {
          return const Center(child: Text('Keine Bibliotheken verfügbar'));
        }
        return SizedBox(
          width: 300,
          child: DropdownButton<String>(
            value: selectedLibraryId.value,
            onChanged: (String? newLibraryId) async {
              await ref.read(selectedLibraryIdProvider.notifier).set(newLibraryId);
            },
            items:
                libraries.map<DropdownMenuItem<String>>((library) {
                  return DropdownMenuItem<String>(value: library.id, child: Text(library.name));
                }).toList(),
            hint: const Text('Bibliothek auswählen'),
            isExpanded: true,
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Fehler: $error')),
    );
  }
}
