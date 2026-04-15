import 'package:yaabsa/components/platform_builder.dart';
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibrarySwitcher extends ConsumerWidget {
  const LibrarySwitcher({super.key});

  Widget _chipButton(BuildContext context, String label, {required bool compact}) {
    final borderRadius = BorderRadius.circular(compact ? 12 : 14);
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: compact ? 10 : 12, vertical: compact ? 6 : 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: borderRadius,
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: compact ? 90 : 150),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          const SizedBox(width: 2),
          Icon(
            Icons.arrow_drop_down_rounded,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: compact ? 20 : 22,
          ),
        ],
      ),
    );
  }

  PopupMenuButton<String> _buildSelector(
    BuildContext context,
    WidgetRef ref,
    List<Library> libraries,
    String? selectedLibraryId, {
    required bool compact,
  }) {
    Library? selectedLibrary;
    for (final library in libraries) {
      if (library.id == selectedLibraryId) {
        selectedLibrary = library;
        break;
      }
    }
    final selectedName = selectedLibrary?.name ?? 'Library';

    return PopupMenuButton<String>(
      tooltip: 'Select library',
      onSelected: (String newLibraryId) async {
        await ref.read(selectedLibraryIdProvider.notifier).set(newLibraryId);
      },
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) {
        return libraries
            .map<PopupMenuEntry<String>>(
              (library) => PopupMenuItem<String>(
                value: library.id,
                child: Row(
                  children: [
                    Icon(
                      library.id == selectedLibraryId ? Icons.check_circle : Icons.radio_button_unchecked,
                      size: 18,
                      color: library.id == selectedLibraryId
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        library.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: library.id == selectedLibraryId ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList();
      },
      child: _chipButton(context, selectedName, compact: compact),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userLibrariesAsyncValue = ref.watch(userLibrariesProvider);
    final selectedLibraryId = ref.watch(selectedLibraryIdProvider);

    return userLibrariesAsyncValue.when(
      data: (libraries) {
        if (libraries.isEmpty) {
          return _chipButton(context, 'No library', compact: true);
        }
        return PlatformBuilder(
          mobileBuilder: (ctx) => _buildSelector(ctx, ref, libraries, selectedLibraryId.value, compact: true),
          tabletBuilder: (ctx) => _buildSelector(ctx, ref, libraries, selectedLibraryId.value, compact: false),
          desktopBuilder: (ctx) => _buildSelector(ctx, ref, libraries, selectedLibraryId.value, compact: false),
        );
      },
      loading: () => const SizedBox(width: 26, height: 26, child: CircularProgressIndicator(strokeWidth: 2)),
      error: (error, stack) => _chipButton(context, 'Library error', compact: true),
    );
  }
}
