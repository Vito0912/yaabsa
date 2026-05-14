import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/socket/events/user_item_progress_updated_event.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/network/request_headers.dart';

typedef UserItemProgressUpdatedHandler = void Function(UserItemProgressUpdatedEvent event);
typedef ItemUpdatedHandler = void Function(LibraryItem item);
typedef BatchQuickMatchCompleteHandler =
    void Function({required bool success, required int updates, required int unmatched});
typedef ServerLogHandler = void Function(Map<String, dynamic> logEntry);

class ABSSocketClient {
  ABSSocketClient({
    required UserItemProgressUpdatedHandler onUserItemProgressUpdated,
    required ItemUpdatedHandler onItemUpdated,
    required BatchQuickMatchCompleteHandler onBatchQuickMatchComplete,
  }) : _onUserItemProgressUpdated = onUserItemProgressUpdated,
       _onItemUpdated = onItemUpdated,
       _onBatchQuickMatchComplete = onBatchQuickMatchComplete;

  final UserItemProgressUpdatedHandler _onUserItemProgressUpdated;
  final ItemUpdatedHandler _onItemUpdated;
  final BatchQuickMatchCompleteHandler _onBatchQuickMatchComplete;
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

    socket.on("item_updated", (dynamic payload) {
      final payloadJson = _payloadToJson(payload);
      if (payloadJson == null) {
        logger(
          'Received malformed item_updated payload: ${_stringifyPayload(payload)}',
          tag: 'ABSSocketClient',
          level: InfoLevel.warning,
        );
        return;
      }

      try {
        final updatedItem = LibraryItem.fromJson(payloadJson);
        _onItemUpdated(updatedItem);
        logger('Processed item_updated event for id ${updatedItem.id}', tag: 'ABSSocketClient', level: InfoLevel.debug);
      } catch (e, s) {
        logger('Failed to parse item_updated payload: $e\n$s', tag: 'ABSSocketClient', level: InfoLevel.error);
      }
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
        final success = _boolFromDynamic(payloadJson['success']);
        final updates = _intFromDynamic(payloadJson['updates']);
        final unmatched = _intFromDynamic(payloadJson['unmatched']);
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

  int _intFromDynamic(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value.trim()) ?? 0;
    }
    return 0;
  }

  bool _boolFromDynamic(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == '1') {
        return true;
      }
      if (normalized == 'false' || normalized == '0') {
        return false;
      }
    }
    return false;
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
