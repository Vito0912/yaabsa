import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/socket/events/user_item_progress_updated_event.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/network/request_headers.dart';

typedef UserItemProgressUpdatedHandler = void Function(UserItemProgressUpdatedEvent event);
typedef ItemUpdatedHandler = void Function(LibraryItem item);

class ABSSocketClient {
  ABSSocketClient({
    required UserItemProgressUpdatedHandler onUserItemProgressUpdated,
    required ItemUpdatedHandler onItemUpdated,
  }) : _onUserItemProgressUpdated = onUserItemProgressUpdated,
       _onItemUpdated = onItemUpdated;

  final UserItemProgressUpdatedHandler _onUserItemProgressUpdated;
  final ItemUpdatedHandler _onItemUpdated;

  io.Socket? _socket;
  String? _serverUrl;
  String? _apiToken;
  String? _headersSignature;

  bool get isConnected => _socket?.connected ?? false;

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
