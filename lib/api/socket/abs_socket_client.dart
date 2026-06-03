import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:yaabsa/api/json/value_parsers.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/list/collection.dart';
import 'package:yaabsa/api/list/playlist.dart';
import 'package:yaabsa/api/socket/events/user_item_progress_updated_event.dart';
import 'package:yaabsa/api/tasks/abs_task.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/network/request_headers.dart';

typedef UserItemProgressUpdatedHandler = void Function(UserItemProgressUpdatedEvent event);
typedef ItemEventHandler = void Function(LibraryItem item);
typedef ItemRemovedHandler = void Function({required String itemId, String? libraryId, LibraryItem? item});
typedef ItemsEventHandler = void Function(List<LibraryItem> items);
typedef BatchQuickMatchCompleteHandler =
    void Function({required bool success, required int updates, required int unmatched});
typedef TaskEventHandler = void Function(AbsTask task);
typedef CollectionEventHandler = void Function(Collection collection);
typedef PlaylistEventHandler = void Function(Playlist playlist);
typedef MetadataEmbedQueueUpdateHandler = void Function({required String libraryItemId, required bool queued});
typedef TrackStateHandler = void Function({required String libraryItemId, required String ino});
typedef TrackProgressHandler =
    void Function({required String libraryItemId, required String ino, required double progress});
typedef TaskProgressHandler = void Function({required String libraryItemId, required double progress});
typedef ServerLogHandler = void Function(Map<String, dynamic> logEntry);

class LibraryItemRemovalEvent {
  const LibraryItemRemovalEvent({required this.itemId, this.libraryId, this.item});

  final String itemId;
  final String? libraryId;
  final LibraryItem? item;
}

class ABSSocketClient {
  ABSSocketClient({
    required UserItemProgressUpdatedHandler onUserItemProgressUpdated,
    required ItemEventHandler onItemAdded,
    required ItemEventHandler onItemUpdated,
    required ItemRemovedHandler onItemRemoved,
    required ItemsEventHandler onItemsAdded,
    required ItemsEventHandler onItemsUpdated,
    required BatchQuickMatchCompleteHandler onBatchQuickMatchComplete,
    required TaskEventHandler onTaskStarted,
    required TaskEventHandler onTaskFinished,
    required TaskEventHandler onTaskUpdated,
    required MetadataEmbedQueueUpdateHandler onMetadataEmbedQueueUpdate,
    required TrackStateHandler onTrackStarted,
    required TrackProgressHandler onTrackProgress,
    required TrackStateHandler onTrackFinished,
    required TaskProgressHandler onTaskProgress,
    CollectionEventHandler? onCollectionAdded,
    CollectionEventHandler? onCollectionUpdated,
    CollectionEventHandler? onCollectionRemoved,
    PlaylistEventHandler? onPlaylistAdded,
    PlaylistEventHandler? onPlaylistUpdated,
    PlaylistEventHandler? onPlaylistRemoved,
  }) : _onUserItemProgressUpdated = onUserItemProgressUpdated,
       _onItemAdded = onItemAdded,
       _onItemUpdated = onItemUpdated,
       _onItemRemoved = onItemRemoved,
       _onItemsAdded = onItemsAdded,
       _onItemsUpdated = onItemsUpdated,
       _onBatchQuickMatchComplete = onBatchQuickMatchComplete,
       _onTaskStarted = onTaskStarted,
       _onTaskFinished = onTaskFinished,
       _onTaskUpdated = onTaskUpdated,
       _onMetadataEmbedQueueUpdate = onMetadataEmbedQueueUpdate,
       _onTrackStarted = onTrackStarted,
       _onTrackProgress = onTrackProgress,
       _onTrackFinished = onTrackFinished,
       _onTaskProgress = onTaskProgress,
       _onCollectionAdded = onCollectionAdded,
       _onCollectionUpdated = onCollectionUpdated,
       _onCollectionRemoved = onCollectionRemoved,
       _onPlaylistAdded = onPlaylistAdded,
       _onPlaylistUpdated = onPlaylistUpdated,
       _onPlaylistRemoved = onPlaylistRemoved;

  final UserItemProgressUpdatedHandler _onUserItemProgressUpdated;
  final ItemEventHandler _onItemAdded;
  final ItemEventHandler _onItemUpdated;
  final ItemRemovedHandler _onItemRemoved;
  final ItemsEventHandler _onItemsAdded;
  final ItemsEventHandler _onItemsUpdated;
  final BatchQuickMatchCompleteHandler _onBatchQuickMatchComplete;
  final TaskEventHandler _onTaskStarted;
  final TaskEventHandler _onTaskFinished;
  final TaskEventHandler _onTaskUpdated;
  final MetadataEmbedQueueUpdateHandler _onMetadataEmbedQueueUpdate;
  final TrackStateHandler _onTrackStarted;
  final TrackProgressHandler _onTrackProgress;
  final TrackStateHandler _onTrackFinished;
  final TaskProgressHandler _onTaskProgress;
  final CollectionEventHandler? _onCollectionAdded;
  final CollectionEventHandler? _onCollectionUpdated;
  final CollectionEventHandler? _onCollectionRemoved;
  final PlaylistEventHandler? _onPlaylistAdded;
  final PlaylistEventHandler? _onPlaylistUpdated;
  final PlaylistEventHandler? _onPlaylistRemoved;
  final Map<String, ServerLogHandler> _serverLogHandlers = <String, ServerLogHandler>{};

  int _nextServerLogHandlerId = 0;
  int _serverLogListenerLevel = 2;

  io.Socket? _socket;
  String? _serverUrl;
  String? _apiToken;
  String? _headersSignature;

  bool get isConnected => _socket?.connected ?? false;

  String addServerLogListener(ServerLogHandler handler) {
    final listenerId = 'log_listener_${_nextServerLogHandlerId++}';
    _serverLogHandlers[listenerId] = handler;
    _applyServerLogListenerState();
    return listenerId;
  }

  void removeServerLogListener(String listenerId) {
    _serverLogHandlers.remove(listenerId);
    _applyServerLogListenerState();
  }

  void setServerLogListenerLevel(int level) {
    _serverLogListenerLevel = level;
    _applyServerLogListenerState();
  }

  void connect({required String serverUrl, required String apiToken, Map<String, String>? headers}) {
    final normalizedServerUrl = _normalizeServerUrl(serverUrl);
    final normalizedHeaders = buildRequestHeaders(serverHeaders: headers);
    final nextHeadersSignature = _headersSignatureFor(normalizedHeaders);
    _apiToken = apiToken;

    final shouldRecreateSocket =
        _socket == null || _serverUrl != normalizedServerUrl || _headersSignature != nextHeadersSignature;
    if (shouldRecreateSocket) {
      _disposeSocket();
      _serverUrl = normalizedServerUrl;
      _headersSignature = nextHeadersSignature;

      final options = io.OptionBuilder().setTransports(["websocket"]).disableAutoConnect().disableReconnection();
      if (normalizedHeaders.isNotEmpty) {
        options.setExtraHeaders(Map<String, dynamic>.from(normalizedHeaders));
      }

      _socket = io.io(normalizedServerUrl, options.build());
      _registerSocketListeners(_socket!);
    }

    final socket = _socket;
    if (socket == null) {
      return;
    }

    if (socket.connected) {
      _authenticateSocket();
      return;
    }

    socket.connect();
  }

  void disconnect() {
    _apiToken = null;
    _disposeSocket();
    _serverUrl = null;
    _headersSignature = null;
  }

  void dispose() {
    _apiToken = null;
    _disposeSocket();
    _serverUrl = null;
    _headersSignature = null;
  }

  void _registerSocketListeners(io.Socket socket) {
    socket.on("connect", (_) {
      logger('Socket connected with id ${socket.id}', tag: 'ABSSocketClient', level: InfoLevel.debug);
      _authenticateSocket();
    });

    socket.on("disconnect", (dynamic reason) {
      final message = reason == null ? 'Socket disconnected' : 'Socket disconnected: $reason';
      logger(message, tag: 'ABSSocketClient', level: InfoLevel.debug);
    });

    socket.on("connect_error", (dynamic error) {
      logger('Socket connection error: $error', tag: 'ABSSocketClient', level: InfoLevel.warning);
    });

    socket.on("init", (dynamic payload) {
      logger('Socket authenticated successfully', tag: 'ABSSocketClient', level: InfoLevel.debug);
      _applyServerLogListenerState();
    });

    socket.on("invalid_token", (dynamic payload) {
      logger(
        'Socket auth failed (invalid token): ${_stringifyPayload(payload)}',
        tag: 'ABSSocketClient',
        level: InfoLevel.warning,
      );
    });

    socket.on("user_item_progress_updated", (dynamic payload) {
      final payloadJson = _payloadToJson(payload);
      if (payloadJson == null) {
        logger(
          'Received malformed user_item_progress_updated payload: ${_stringifyPayload(payload)}',
          tag: 'ABSSocketClient',
          level: InfoLevel.warning,
        );
        return;
      }

      try {
        final event = UserItemProgressUpdatedEvent.fromJson(payloadJson);
        _onUserItemProgressUpdated(event);
        logger(
          'Processed user_item_progress_updated event for id ${event.id}',
          tag: 'ABSSocketClient',
          level: InfoLevel.debug,
        );
      } catch (e, s) {
        logger(
          'Failed to parse user_item_progress_updated payload: $e\n$s',
          tag: 'ABSSocketClient',
          level: InfoLevel.error,
        );
      }
    });

    socket.on("item_added", (dynamic payload) {
      final addedItem = _libraryItemFromPayload(payload, eventName: 'item_added');
      if (addedItem == null) {
        return;
      }

      _onItemAdded(addedItem);
      logger('Processed item_added event for id ${addedItem.id}', tag: 'ABSSocketClient', level: InfoLevel.debug);
    });

    socket.on("item_updated", (dynamic payload) {
      final updatedItem = _libraryItemFromPayload(payload, eventName: 'item_updated');
      if (updatedItem == null) {
        return;
      }

      _onItemUpdated(updatedItem);
      logger('Processed item_updated event for id ${updatedItem.id}', tag: 'ABSSocketClient', level: InfoLevel.debug);
    });

    socket.on("item_removed", (dynamic payload) {
      final removedItem = _libraryItemRemovalFromPayload(payload, eventName: 'item_removed');
      if (removedItem == null) {
        return;
      }

      _onItemRemoved(itemId: removedItem.itemId, libraryId: removedItem.libraryId, item: removedItem.item);
      logger(
        'Processed item_removed event for id ${removedItem.itemId}',
        tag: 'ABSSocketClient',
        level: InfoLevel.debug,
      );
    });

    socket.on("items_added", (dynamic payload) {
      final addedItems = _libraryItemsFromPayload(payload, eventName: 'items_added');
      if (addedItems.isEmpty) {
        return;
      }

      _onItemsAdded(addedItems);
      logger(
        'Processed items_added event for ${addedItems.length} items',
        tag: 'ABSSocketClient',
        level: InfoLevel.debug,
      );
    });

    socket.on("items_updated", (dynamic payload) {
      final updatedItems = _libraryItemsFromPayload(payload, eventName: 'items_updated');
      if (updatedItems.isEmpty) {
        return;
      }

      _onItemsUpdated(updatedItems);
      logger(
        'Processed items_updated event for ${updatedItems.length} items',
        tag: 'ABSSocketClient',
        level: InfoLevel.debug,
      );
    });

    socket.on("batch_quickmatch_complete", (dynamic payload) {
      final payloadJson = _payloadToJson(payload);
      if (payloadJson == null) {
        logger(
          'Received malformed batch_quickmatch_complete payload: ${_stringifyPayload(payload)}',
          tag: 'ABSSocketClient',
          level: InfoLevel.warning,
        );
        return;
      }

      try {
        final success = jsonBoolRequiredFromDynamic(payloadJson['success']);
        final updates = jsonIntRequiredFromDynamic(payloadJson['updates']);
        final unmatched = jsonIntRequiredFromDynamic(payloadJson['unmatched']);
        _onBatchQuickMatchComplete(success: success, updates: updates, unmatched: unmatched);
        logger(
          'Processed batch_quickmatch_complete event (success=$success, updates=$updates, unmatched=$unmatched)',
          tag: 'ABSSocketClient',
          level: InfoLevel.debug,
        );
      } catch (e, s) {
        logger(
          'Failed to parse batch_quickmatch_complete payload: $e\n$s',
          tag: 'ABSSocketClient',
          level: InfoLevel.error,
        );
      }
    });

    socket.on("task_started", (dynamic payload) {
      final task = _taskFromPayload(payload, eventName: 'task_started');
      if (task == null) {
        return;
      }

      _onTaskStarted(task);
      logger(
        'Processed task_started event for action ${task.action} (${task.id})',
        tag: 'ABSSocketClient',
        level: InfoLevel.debug,
      );
    });

    socket.on("task_finished", (dynamic payload) {
      final task = _taskFromPayload(payload, eventName: 'task_finished');
      if (task == null) {
        return;
      }

      _onTaskFinished(task);
      logger(
        'Processed task_finished event for action ${task.action} (${task.id})',
        tag: 'ABSSocketClient',
        level: InfoLevel.debug,
      );
    });

    socket.on("task_updated", (dynamic payload) {
      final task = _taskFromPayload(payload, eventName: 'task_updated');
      if (task == null) {
        return;
      }

      _onTaskUpdated(task);
      logger(
        'Processed task_updated event for action ${task.action} (${task.id})',
        tag: 'ABSSocketClient',
        level: InfoLevel.debug,
      );
    });

    socket.on("metadata_embed_queue_update", (dynamic payload) {
      final payloadJson = _payloadToJson(payload);
      if (payloadJson == null) {
        logger(
          'Received malformed metadata_embed_queue_update payload: ${_stringifyPayload(payload)}',
          tag: 'ABSSocketClient',
          level: InfoLevel.warning,
        );
        return;
      }

      final libraryItemId = jsonStringFromDynamic(payloadJson['libraryItemId']);
      if (libraryItemId == null || libraryItemId.isEmpty) {
        logger(
          'metadata_embed_queue_update payload missing libraryItemId: ${_stringifyPayload(payload)}',
          tag: 'ABSSocketClient',
          level: InfoLevel.warning,
        );
        return;
      }

      final queued = jsonBoolRequiredFromDynamic(payloadJson['queued']);
      _onMetadataEmbedQueueUpdate(libraryItemId: libraryItemId, queued: queued);
    });

    socket.on("track_started", (dynamic payload) {
      final payloadJson = _payloadToJson(payload);
      if (payloadJson == null) {
        return;
      }

      final libraryItemId = jsonStringFromDynamic(payloadJson['libraryItemId']);
      final ino = jsonStringFromDynamic(payloadJson['ino']);
      if (libraryItemId == null || libraryItemId.isEmpty || ino == null || ino.isEmpty) {
        return;
      }

      _onTrackStarted(libraryItemId: libraryItemId, ino: ino);
    });

    socket.on("track_progress", (dynamic payload) {
      final payloadJson = _payloadToJson(payload);
      if (payloadJson == null) {
        return;
      }

      final libraryItemId = jsonStringFromDynamic(payloadJson['libraryItemId']);
      final ino = jsonStringFromDynamic(payloadJson['ino']);
      final progress = jsonDoubleRequiredFromDynamic(payloadJson['progress']);

      if (libraryItemId == null || libraryItemId.isEmpty || ino == null || ino.isEmpty) {
        return;
      }

      _onTrackProgress(libraryItemId: libraryItemId, ino: ino, progress: progress);
    });

    socket.on("track_finished", (dynamic payload) {
      final payloadJson = _payloadToJson(payload);
      if (payloadJson == null) {
        return;
      }

      final libraryItemId = jsonStringFromDynamic(payloadJson['libraryItemId']);
      final ino = jsonStringFromDynamic(payloadJson['ino']);
      if (libraryItemId == null || libraryItemId.isEmpty || ino == null || ino.isEmpty) {
        return;
      }

      _onTrackFinished(libraryItemId: libraryItemId, ino: ino);
    });

    socket.on("task_progress", (dynamic payload) {
      final payloadJson = _payloadToJson(payload);
      if (payloadJson == null) {
        return;
      }

      final libraryItemId = jsonStringFromDynamic(payloadJson['libraryItemId']);
      if (libraryItemId == null || libraryItemId.isEmpty) {
        return;
      }

      final progress = jsonDoubleRequiredFromDynamic(payloadJson['progress']);
      _onTaskProgress(libraryItemId: libraryItemId, progress: progress);
    });

    socket.on("collection_added", (dynamic payload) {
      final collection = _collectionFromPayload(payload, eventName: 'collection_added');
      if (collection != null) {
        _onCollectionAdded?.call(collection);
        logger(
          'Processed collection_added event for id ${collection.id}',
          tag: 'ABSSocketClient',
          level: InfoLevel.debug,
        );
      }
    });

    socket.on("collection_updated", (dynamic payload) {
      final collection = _collectionFromPayload(payload, eventName: 'collection_updated');
      if (collection != null) {
        _onCollectionUpdated?.call(collection);
        logger(
          'Processed collection_updated event for id ${collection.id}',
          tag: 'ABSSocketClient',
          level: InfoLevel.debug,
        );
      }
    });

    socket.on("collection_removed", (dynamic payload) {
      final collection = _collectionFromPayload(payload, eventName: 'collection_removed');
      if (collection != null) {
        _onCollectionRemoved?.call(collection);
        logger(
          'Processed collection_removed event for id ${collection.id}',
          tag: 'ABSSocketClient',
          level: InfoLevel.debug,
        );
      }
    });

    socket.on("playlist_added", (dynamic payload) {
      final playlist = _playlistFromPayload(payload, eventName: 'playlist_added');
      if (playlist != null) {
        _onPlaylistAdded?.call(playlist);
        logger('Processed playlist_added event for id ${playlist.id}', tag: 'ABSSocketClient', level: InfoLevel.debug);
      }
    });

    socket.on("playlist_updated", (dynamic payload) {
      final playlist = _playlistFromPayload(payload, eventName: 'playlist_updated');
      if (playlist != null) {
        _onPlaylistUpdated?.call(playlist);
        logger(
          'Processed playlist_updated event for id ${playlist.id}',
          tag: 'ABSSocketClient',
          level: InfoLevel.debug,
        );
      }
    });

    socket.on("playlist_removed", (dynamic payload) {
      final playlist = _playlistFromPayload(payload, eventName: 'playlist_removed');
      if (playlist != null) {
        _onPlaylistRemoved?.call(playlist);
        logger(
          'Processed playlist_removed event for id ${playlist.id}',
          tag: 'ABSSocketClient',
          level: InfoLevel.debug,
        );
      }
    });

    socket.on("log", (dynamic payload) {
      final payloadJson = _payloadToJson(payload);
      if (payloadJson == null) {
        logger(
          'Received malformed log payload: ${_stringifyPayload(payload)}',
          tag: 'ABSSocketClient',
          level: InfoLevel.warning,
        );
        return;
      }

      final handlers = _serverLogHandlers.values.toList(growable: false);
      for (final handler in handlers) {
        try {
          handler(payloadJson);
        } catch (e, s) {
          logger('Server log handler failed: $e\n$s', tag: 'ABSSocketClient', level: InfoLevel.warning);
        }
      }
    });
  }

  void _authenticateSocket() {
    final socket = _socket;
    final apiToken = _apiToken;
    if (socket == null || apiToken == null || apiToken.isEmpty) {
      return;
    }

    socket.emit("auth", apiToken);
  }

  Map<String, dynamic>? _payloadToJson(dynamic payload) {
    if (payload is Map<String, dynamic>) {
      return payload;
    }

    if (payload is Map) {
      return payload.map((key, value) => MapEntry(key.toString(), value));
    }

    if (payload is List && payload.isNotEmpty) {
      return _payloadToJson(payload.first);
    }

    return null;
  }

  List<Map<String, dynamic>> _payloadToJsonList(dynamic payload) {
    if (payload is List) {
      final entries = <Map<String, dynamic>>[];
      for (final entry in payload) {
        final parsedEntry = _payloadToJson(entry);
        if (parsedEntry != null) {
          entries.add(parsedEntry);
        }
      }
      return entries;
    }

    final singleEntry = _payloadToJson(payload);
    if (singleEntry != null) {
      return <Map<String, dynamic>>[singleEntry];
    }

    return const <Map<String, dynamic>>[];
  }

  LibraryItem? _libraryItemFromPayload(dynamic payload, {required String eventName}) {
    final payloadJson = _payloadToJson(payload);
    if (payloadJson == null) {
      logger(
        'Received malformed $eventName payload: ${_stringifyPayload(payload)}',
        tag: 'ABSSocketClient',
        level: InfoLevel.warning,
      );
      return null;
    }

    try {
      return LibraryItem.fromJson(payloadJson);
    } catch (e, s) {
      logger('Failed to parse $eventName payload: $e\n$s', tag: 'ABSSocketClient', level: InfoLevel.error);
      return null;
    }
  }

  List<LibraryItem> _libraryItemsFromPayload(dynamic payload, {required String eventName}) {
    final payloadJsonList = _payloadToJsonList(payload);
    if (payloadJsonList.isEmpty) {
      logger(
        'Received malformed $eventName payload: ${_stringifyPayload(payload)}',
        tag: 'ABSSocketClient',
        level: InfoLevel.warning,
      );
      return const <LibraryItem>[];
    }

    final items = <LibraryItem>[];
    for (final itemJson in payloadJsonList) {
      try {
        items.add(LibraryItem.fromJson(itemJson));
      } catch (e, s) {
        logger('Failed to parse $eventName entry payload: $e\n$s', tag: 'ABSSocketClient', level: InfoLevel.error);
      }
    }

    if (items.isEmpty) {
      logger(
        '$eventName payload did not contain parsable items: ${_stringifyPayload(payload)}',
        tag: 'ABSSocketClient',
        level: InfoLevel.warning,
      );
    }

    return items;
  }

  LibraryItemRemovalEvent? _libraryItemRemovalFromPayload(dynamic payload, {required String eventName}) {
    final payloadJson = _payloadToJson(payload);
    if (payloadJson == null) {
      logger(
        'Received malformed $eventName payload: ${_stringifyPayload(payload)}',
        tag: 'ABSSocketClient',
        level: InfoLevel.warning,
      );
      return null;
    }

    final nestedLibraryItemJson = _payloadToJson(payloadJson['libraryItem']);
    final itemId =
        jsonStringFromDynamic(payloadJson['id']) ??
        jsonStringFromDynamic(payloadJson['libraryItemId']) ??
        jsonStringFromDynamic(nestedLibraryItemJson?['id']);

    if (itemId == null || itemId.isEmpty) {
      logger(
        '$eventName payload missing item id: ${_stringifyPayload(payload)}',
        tag: 'ABSSocketClient',
        level: InfoLevel.warning,
      );
      return null;
    }

    final libraryId =
        jsonStringFromDynamic(payloadJson['libraryId']) ?? jsonStringFromDynamic(nestedLibraryItemJson?['libraryId']);

    LibraryItem? item;
    try {
      item = LibraryItem.fromJson(payloadJson);
    } catch (_) {
      if (nestedLibraryItemJson != null) {
        try {
          item = LibraryItem.fromJson(nestedLibraryItemJson);
        } catch (_) {}
      }
    }

    return LibraryItemRemovalEvent(itemId: itemId, libraryId: libraryId ?? item?.libraryId, item: item);
  }

  AbsTask? _taskFromPayload(dynamic payload, {required String eventName}) {
    final payloadJson = _payloadToJson(payload);
    if (payloadJson == null) {
      logger(
        'Received malformed $eventName payload: ${_stringifyPayload(payload)}',
        tag: 'ABSSocketClient',
        level: InfoLevel.warning,
      );
      return null;
    }

    try {
      return AbsTask.fromJson(payloadJson);
    } catch (e, s) {
      logger('Failed to parse $eventName payload: $e\n$s', tag: 'ABSSocketClient', level: InfoLevel.error);
      return null;
    }
  }

  Collection? _collectionFromPayload(dynamic payload, {required String eventName}) {
    final payloadJson = _payloadToJson(payload);
    if (payloadJson == null) {
      logger(
        'Received malformed $eventName payload: ${_stringifyPayload(payload)}',
        tag: 'ABSSocketClient',
        level: InfoLevel.warning,
      );
      return null;
    }

    try {
      return Collection.fromJson(payloadJson);
    } catch (e, s) {
      logger('Failed to parse $eventName payload: $e\n$s', tag: 'ABSSocketClient', level: InfoLevel.error);
      return null;
    }
  }

  Playlist? _playlistFromPayload(dynamic payload, {required String eventName}) {
    final payloadJson = _payloadToJson(payload);
    if (payloadJson == null) {
      logger(
        'Received malformed $eventName payload: ${_stringifyPayload(payload)}',
        tag: 'ABSSocketClient',
        level: InfoLevel.warning,
      );
      return null;
    }

    try {
      return Playlist.fromJson(payloadJson);
    } catch (e, s) {
      logger('Failed to parse $eventName payload: $e\n$s', tag: 'ABSSocketClient', level: InfoLevel.error);
      return null;
    }
  }

  String _normalizeServerUrl(String serverUrl) {
    if (serverUrl.endsWith('/')) {
      return serverUrl.substring(0, serverUrl.length - 1);
    }
    return serverUrl;
  }

  String _headersSignatureFor(Map<String, String> headers) {
    if (headers.isEmpty) {
      return '';
    }

    final keys = headers.keys.toList()..sort();
    final serialized = keys.map((key) => '$key=${headers[key]}').join('&');
    return serialized;
  }

  String _stringifyPayload(dynamic payload) {
    try {
      return payload.toString();
    } catch (_) {
      return '<unprintable>';
    }
  }

  void _applyServerLogListenerState() {
    final socket = _socket;
    if (socket == null || !socket.connected) {
      return;
    }

    if (_serverLogHandlers.isEmpty) {
      socket.emit('remove_log_listener');
      return;
    }

    socket.emit('set_log_listener', _serverLogListenerLevel);
  }

  void _disposeSocket() {
    final socket = _socket;
    if (socket == null) {
      return;
    }

    socket.dispose();
    socket.disconnect();
    _socket = null;
  }
}
