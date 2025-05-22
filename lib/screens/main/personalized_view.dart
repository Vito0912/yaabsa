import 'package:buchshelfly/api/library/personalized_library.dart';
import 'package:buchshelfly/components/common/library_item_widget.dart';
import 'package:buchshelfly/provider/common/library_provider.dart';
import 'package:buchshelfly/provider/core/user_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonalizedView extends ConsumerWidget {
  const PersonalizedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.watch(absApiProvider);
    final selectedLibrary = ref.watch(selectedLibraryProvider);

    if (selectedLibrary == null) {
      return const Center(child: Text('No library selected. Please select a library via the switcher.'));
    }

    return FutureBuilder(
      future: api?.getLibraryApi().getPersonalized(selectedLibrary!.id),
      builder: (BuildContext context, AsyncSnapshot<Response<PersonalizedLibrary>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data?.data == null) {
          return const Center(child: Text('No personalized items found.'));
        }
        return Column(
          children:
              snapshot.data!.data!.continueListening!.entities.map((e) {
                return LibraryItemWidget(e, api!);
              }).toList(),
        );
      },
    );
  }
}
