import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

class UploadFileEntry {
  const UploadFileEntry({required this.location, required this.relativePath});

  final String location;
  final String relativePath;
}

class UploadFileAccess {
  static const _channel = MethodChannel('de.vito0912.yaabsa/upload_saf');

  final Set<int> _openHandles = {};
  bool _isClosed = false;

  Future<void> close() async {
    _isClosed = true;
    final handles = _openHandles.toList(growable: false);
    _openHandles.clear();
    await Future.wait(handles.map((handle) => _channel.invokeMethod<void>('closeFile', {'handle': handle})));
  }

  static Stream<UploadFileEntry> listFolder(Uri folder) async* {
    if (folder.scheme != 'content') {
      final directory = Directory.fromUri(folder);
      if (!await directory.exists()) {
        return;
      }

      await for (final entity in directory.list(recursive: true, followLinks: false)) {
        if (entity is File) {
          final relativePath = p.relative(entity.path, from: directory.parent.path);
          yield UploadFileEntry(location: entity.path, relativePath: relativePath);
        }
      }
      return;
    }

    final root = await _channel.invokeMapMethod<String, dynamic>('inspectTree', {'uri': folder.toString()});
    if (root == null) {
      throw const FileSystemException('Could not inspect selected directory');
    }

    final pending = [(uri: root['uri'] as String, path: root['name'] as String)];
    final visited = <String>{};
    while (pending.isNotEmpty) {
      final directory = pending.removeLast();
      if (!visited.add(directory.uri)) {
        continue;
      }

      final children = await _channel.invokeListMethod<dynamic>('listDirectory', {'uri': directory.uri});
      if (children == null) {
        throw const FileSystemException('Could not list selected directory');
      }

      for (final child in children) {
        final entry = Map<String, dynamic>.from(child as Map);
        final relativePath = p.join(directory.path, entry['name'] as String);
        final uri = entry['uri'] as String;
        if (entry['isDirectory'] == true) {
          pending.add((uri: uri, path: relativePath));
        } else {
          yield UploadFileEntry(location: uri, relativePath: relativePath);
        }
      }
    }
  }

  Future<MultipartFile> multipartFile({
    required String location,
    required String filename,
    required CancelToken cancelToken,
  }) async {
    _checkCancellation(cancelToken);
    if (_isClosed) {
      throw StateError('Upload file access is closed');
    }

    if (Uri.tryParse(location)?.scheme != 'content') {
      return MultipartFile.fromFile(location, filename: filename);
    }

    final length = await _channel.invokeMethod<int>('fileLength', {'uri': location});
    _checkCancellation(cancelToken);
    if (length == null || length < 0) {
      throw FileSystemException('Could not determine upload file size', location);
    }

    return MultipartFile.fromStream(
      () => _readFile(location: location, length: length, cancelToken: cancelToken),
      length,
      filename: filename,
    );
  }

  static void _checkCancellation(CancelToken cancelToken) {
    final error = cancelToken.cancelError;
    if (error != null) {
      throw error;
    }
  }

  Stream<List<int>> _readFile({
    required String location,
    required int length,
    required CancelToken cancelToken,
  }) async* {
    _checkCancellation(cancelToken);
    if (_isClosed) {
      throw StateError('Upload file access is closed');
    }

    final handle = await _channel.invokeMethod<int>('openFile', {'uri': location});
    if (handle == null) {
      throw FileSystemException('Could not open upload file', location);
    }

    if (_isClosed) {
      await _channel.invokeMethod<void>('closeFile', {'handle': handle});
      throw StateError('Upload file access is closed');
    }
    _openHandles.add(handle);

    try {
      var bytesRead = 0;
      while (true) {
        _checkCancellation(cancelToken);
        final chunk = await _channel.invokeMethod<Uint8List>('readFile', {'handle': handle});
        _checkCancellation(cancelToken);
        if (chunk == null || chunk.isEmpty) {
          break;
        }

        bytesRead += chunk.length;
        if (bytesRead > length) {
          throw FileSystemException('Upload file size changed', location);
        }
        yield chunk;
      }

      if (bytesRead != length) {
        throw FileSystemException('Upload file size changed', location);
      }
    } finally {
      if (_openHandles.remove(handle)) {
        await _channel.invokeMethod<void>('closeFile', {'handle': handle});
      }
    }
  }
}
