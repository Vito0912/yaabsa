import 'package:yaabsa/database/app_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Downloads extends ConsumerWidget {
  const Downloads({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appDatabase = ref.watch(appDatabaseProvider);
    return FutureBuilder(
      future: appDatabase.getAllStoredDownloads(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final downloads = snapshot.data ?? [];
        if (downloads.isEmpty) {
          return const Center(child: Text('No downloads available.'));
        }
        return ListView.builder(
          itemCount: downloads.length,
          itemBuilder: (context, index) {
            final download = downloads[index];
            return InkWell(
              onTap: () {
                context.push('/item/${download.item?.id ?? download.episode?.id}');
              },
              child: ListTile(
                title: Text(download.item?.title ?? 'Unknown Item'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Downloaded Tracks: ${download.tracks.length}'),
                    if (!(download.isComplete ?? true))
                      const Text(
                        'Warning: Download unfished or not complete. Not available for offline use!',
                        style: TextStyle(color: Colors.red),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
