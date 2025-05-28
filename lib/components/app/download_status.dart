import 'package:background_downloader/background_downloader.dart';
import 'package:buchshelfly/util/globals.dart';
import 'package:flutter/material.dart';

// This is just a placeholder that needs to be fixed, because it kinda sucks.
class DownloadStatus extends StatelessWidget {
  const DownloadStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TaskRecord>>(
      stream: downloadHandler.taskQueueStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return IconButton(
            icon: const Icon(Icons.error, color: Colors.red),
            onPressed: () => _showErrorDialog(context, snapshot.error),
          );
        }

        final tasks = snapshot.data ?? [];
        final remainingTasks = tasks.where((t) => t.status != TaskStatus.complete).length;
        final totalProgress = _calculateOverallProgress(tasks);

        return SizedBox();
      },
    );
  }

  double _calculateOverallProgress(List<TaskRecord> tasks) {
    if (tasks.isEmpty) return 0;

    final incompleteTasks = tasks.where((t) => t.status != TaskStatus.complete);
    if (incompleteTasks.isEmpty) return 1.0;

    final totalProgress = incompleteTasks.map((t) => t.progress).reduce((a, b) => a + b);
    return totalProgress / (incompleteTasks.length * 100);
  }

  void _showErrorDialog(BuildContext context, Object? error) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Download Error'),
            content: Text('Error: $error'),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
          ),
    );
  }
}
