import 'package:buchshelfly/components/common/library_item_widget.dart';
import 'package:buchshelfly/provider/common/library_provider.dart';
import 'package:buchshelfly/provider/core/user_providers.dart';
import 'package:buchshelfly/provider/library/personalized_library_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonalizedView extends ConsumerWidget {
  const PersonalizedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLibrary = ref.watch(selectedLibraryProvider);

    if (selectedLibrary == null) {
      return const Center(child: Text('No library selected. Please select a library via the switcher.'));
    }

    final personalizedLibraryAsyncValue = ref.watch(personalizedLibraryNotifierProvider(selectedLibrary.id));

    return personalizedLibraryAsyncValue.when(
      data: (personalizedLibrary) {
        if (personalizedLibrary == null) {
          return const Center(child: Text('No personalized items found.'));
        }
        final api = ref.watch(absApiProvider); // Keep api access for LibraryItemWidget for now
        return SingleChildScrollView(
          child: Column(
            children: [
              const Text('Continue Listening'),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      personalizedLibrary.continueListening?.entities.map((e) {
                        return Container(width: 200, child: LibraryItemWidget(e, api!));
                      }).toList() ??
                      [],
                ),
              ),
              const SizedBox(height: 8),
              const Text('Continue Series'),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      personalizedLibrary.continueSeries?.entities.map((e) {
                        return Container(width: 200, child: LibraryItemWidget(e, api!));
                      }).toList() ??
                      [],
                ),
              ),
              const SizedBox(height: 8),
              const Text('Series'),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      personalizedLibrary.recentSeries?.entities.map((e) {
                        return Container(width: 200, child: Text(e.name));
                      }).toList() ??
                      [],
                ),
              ),
              const SizedBox(height: 8),
              const Text('Discover'),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      personalizedLibrary.discover?.entities.map((e) {
                        return Container(width: 200, child: LibraryItemWidget(e, api!));
                      }).toList() ??
                      [],
                ),
              ),
              const SizedBox(height: 8),
              const Text('Listen again'),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      personalizedLibrary.listenAgain?.entities.map((e) {
                        return Container(width: 200, child: LibraryItemWidget(e, api!));
                      }).toList() ??
                      [],
                ),
              ),
              const SizedBox(height: 8),
              const Text('Authors'),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      personalizedLibrary.newestAuthors?.entities.map((e) {
                        return Container(width: 200, child: Text(e.name));
                      }).toList() ??
                      [],
                ),
              ),
              const SizedBox(height: 8),
              const Text('Episodes'),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      personalizedLibrary.newestEpisodes?.entities.map((e) {
                        return Container(width: 200, child: Text(e.title!));
                      }).toList() ??
                      [],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }
}
