import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaabsa/api/tasks/abs_task.dart';
import 'package:yaabsa/api/tasks/abs_task_list_response.dart';

part 'server_tasks_provider.g.dart';

class ServerTasksState {
  const ServerTasksState({
    this.tasks = const <AbsTask>[],
    this.queuedEmbedLibraryItemIds = const <String>[],
    this.audioFilesEncoding = const <String, Map<String, String>>{},
    this.audioFilesFinished = const <String, Map<String, bool>>{},
    this.taskProgressByLibraryItem = const <String, String>{},
  });

  final List<AbsTask> tasks;
  final List<String> queuedEmbedLibraryItemIds;
  final Map<String, Map<String, String>> audioFilesEncoding;
  final Map<String, Map<String, bool>> audioFilesFinished;
  final Map<String, String> taskProgressByLibraryItem;

  ServerTasksState copyWith({
    List<AbsTask>? tasks,
    List<String>? queuedEmbedLibraryItemIds,
    Map<String, Map<String, String>>? audioFilesEncoding,
    Map<String, Map<String, bool>>? audioFilesFinished,
    Map<String, String>? taskProgressByLibraryItem,
  }) {
    return ServerTasksState(
      tasks: tasks ?? this.tasks,
      queuedEmbedLibraryItemIds: queuedEmbedLibraryItemIds ?? this.queuedEmbedLibraryItemIds,
      audioFilesEncoding: audioFilesEncoding ?? this.audioFilesEncoding,
      audioFilesFinished: audioFilesFinished ?? this.audioFilesFinished,
      taskProgressByLibraryItem: taskProgressByLibraryItem ?? this.taskProgressByLibraryItem,
    );
  }
}

@Riverpod(keepAlive: true)
class ServerTasks extends _$ServerTasks {
  @override
  ServerTasksState build() => const ServerTasksState();

  void reset() {
    state = const ServerTasksState();
  }

  void hydrateFromResponse(AbsTaskListResponse response) {
    final queuedIds =
        response.queuedTaskData?.embedMetadata
            .map((entry) => entry.libraryItemId?.trim() ?? '')
            .where((id) => id.isNotEmpty)
            .toSet()
            .toList(growable: false) ??
        const <String>[];

    state = state.copyWith(tasks: _sortTasks(response.tasks), queuedEmbedLibraryItemIds: queuedIds);
  }

  void addOrUpdateTask(AbsTask task) {
    final tasks = [...state.tasks];
    final existingTaskIndex = tasks.indexWhere((entry) => entry.id == task.id);

    if (existingTaskIndex >= 0) {
      tasks[existingTaskIndex] = task;
    } else {
      final libraryItemId = task.data?.libraryItemId;
      final libraryId = task.data?.libraryId;

      tasks.removeWhere((entry) {
        if (entry.action != task.action) {
          return false;
        }

        if (libraryItemId != null && libraryItemId.isNotEmpty) {
          return entry.data?.libraryItemId == libraryItemId;
        }

        if (libraryId != null && libraryId.isNotEmpty) {
          return entry.data?.libraryId == libraryId;
        }

        return false;
      });

      tasks.add(task);
    }

    state = state.copyWith(tasks: _sortTasks(tasks));
  }

  void setEmbedMetadataQueued({required String libraryItemId, required bool queued}) {
    final normalizedLibraryItemId = libraryItemId.trim();
    if (normalizedLibraryItemId.isEmpty) {
      return;
    }

    final nextQueuedIds = [...state.queuedEmbedLibraryItemIds];
    if (queued) {
      if (!nextQueuedIds.contains(normalizedLibraryItemId)) {
        nextQueuedIds.add(normalizedLibraryItemId);
      }
    } else {
      nextQueuedIds.removeWhere((id) => id == normalizedLibraryItemId);
    }

    state = state.copyWith(queuedEmbedLibraryItemIds: nextQueuedIds);
  }

  void updateTrackStarted({required String libraryItemId, required String ino}) {
    updateTrackProgress(libraryItemId: libraryItemId, ino: ino, progress: 0);
  }

  void updateTrackProgress({required String libraryItemId, required String ino, required double progress}) {
    final normalizedLibraryItemId = libraryItemId.trim();
    final normalizedIno = ino.trim();
    if (normalizedLibraryItemId.isEmpty || normalizedIno.isEmpty) {
      return;
    }

    final nextAudioFilesEncoding = Map<String, Map<String, String>>.from(state.audioFilesEncoding);
    final existingLibraryItemMap = nextAudioFilesEncoding[normalizedLibraryItemId];

    nextAudioFilesEncoding[normalizedLibraryItemId] = {
      ...?existingLibraryItemMap,
      normalizedIno: _toPercentageText(progress),
    };

    state = state.copyWith(audioFilesEncoding: nextAudioFilesEncoding);
  }

  void updateTrackFinished({required String libraryItemId, required String ino}) {
    final normalizedLibraryItemId = libraryItemId.trim();
    final normalizedIno = ino.trim();
    if (normalizedLibraryItemId.isEmpty || normalizedIno.isEmpty) {
      return;
    }

    final nextAudioFilesEncoding = Map<String, Map<String, String>>.from(state.audioFilesEncoding);
    final existingEncodingLibraryItemMap = nextAudioFilesEncoding[normalizedLibraryItemId];
    nextAudioFilesEncoding[normalizedLibraryItemId] = {...?existingEncodingLibraryItemMap, normalizedIno: '100%'};

    final nextAudioFilesFinished = Map<String, Map<String, bool>>.from(state.audioFilesFinished);
    final existingFinishedLibraryItemMap = nextAudioFilesFinished[normalizedLibraryItemId];
    nextAudioFilesFinished[normalizedLibraryItemId] = {...?existingFinishedLibraryItemMap, normalizedIno: true};

    state = state.copyWith(audioFilesEncoding: nextAudioFilesEncoding, audioFilesFinished: nextAudioFilesFinished);
  }

  void updateTaskProgress({required String libraryItemId, required double progress}) {
    final normalizedLibraryItemId = libraryItemId.trim();
    if (normalizedLibraryItemId.isEmpty) {
      return;
    }

    final nextTaskProgress = Map<String, String>.from(state.taskProgressByLibraryItem)
      ..[normalizedLibraryItemId] = _toPercentageText(progress);

    state = state.copyWith(taskProgressByLibraryItem: nextTaskProgress);
  }

  void clearCompletedTaskActivity() {
    final runningTasks = state.tasks.where((task) => !task.isFinished).toList(growable: false);

    final activeLibraryItemIds = runningTasks
        .map((task) => task.data?.libraryItemId?.trim())
        .whereType<String>()
        .where((libraryItemId) => libraryItemId.isNotEmpty)
        .toSet();

    final nextEncoding = _filterByLibraryItemIds(state.audioFilesEncoding, activeLibraryItemIds);
    final nextFinished = _filterByLibraryItemIds(state.audioFilesFinished, activeLibraryItemIds);
    final nextTaskProgress = _filterByLibraryItemIds(state.taskProgressByLibraryItem, activeLibraryItemIds);

    state = state.copyWith(
      tasks: _sortTasks(runningTasks),
      audioFilesEncoding: nextEncoding,
      audioFilesFinished: nextFinished,
      taskProgressByLibraryItem: nextTaskProgress,
    );
  }
}

List<AbsTask> _sortTasks(Iterable<AbsTask> tasks) {
  final sorted = tasks.toList(growable: false);
  sorted.sort((left, right) {
    final rightStartedAt = right.startedAt ?? 0;
    final leftStartedAt = left.startedAt ?? 0;
    return rightStartedAt.compareTo(leftStartedAt);
  });
  return sorted;
}

String _toPercentageText(double value) {
  if (!value.isFinite) {
    return '0%';
  }

  final normalized = value.clamp(0, 100).toDouble();
  return '${normalized.round()}%';
}

Map<String, T> _filterByLibraryItemIds<T>(Map<String, T> source, Set<String> allowedLibraryItemIds) {
  if (allowedLibraryItemIds.isEmpty) {
    return <String, T>{};
  }

  return Map<String, T>.fromEntries(source.entries.where((entry) => allowedLibraryItemIds.contains(entry.key)));
}
