import 'dart:io';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

class BookServer {
  File? bookFile;
  String? bookUrl;
  Map<String, String>? headers;
  HttpServer? _server;
  Directory? _narrationDirectory;
  final String _exportToken = base64UrlEncode(List.generate(24, (_) => Random.secure().nextInt(256)));
  final Future<void> Function(String url, Map<String, String>? headers, HttpRequest request)? bookFetcher;
  final void Function(String message, bool isError)? onDiagnostic;

  BookServer({this.bookFile, this.bookUrl, this.headers, this.bookFetcher, this.onDiagnostic});

  String get narrationExportPath => '/narration/$_exportToken';

  Future<int> start() async {
    _server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    _server!.listen((HttpRequest request) async {
      final elapsed = Stopwatch()..start();
      final path = request.uri.path;

      onDiagnostic?.call('Local reader request: ${request.method} $path', false);

      try {
        if (path == '/' || path == '/index.html' || path == '/reader.html') {
          await _serveAsset(request, 'packages/foliate_reader/assets/reader.html', 'text/html; charset=utf-8');
        } else if (path == '/reader-app.js') {
          await _serveAsset(
            request,
            'packages/foliate_reader/assets/reader-app.js',
            'application/javascript; charset=utf-8',
          );
        } else if (path == '/reader-narration.js' ||
            path == '/reader-tts.js' ||
            path == '/reader-resize.js' ||
            path == '/reader-search.js') {
          await _serveAsset(request, 'packages/foliate_reader/assets$path', 'application/javascript; charset=utf-8');
        } else if (path == '/narration/$_exportToken' && request.method == 'POST') {
          await _storeNarration(request);
        } else if (path.startsWith('/foliate-js/')) {
          final relPath = path.substring(12);
          final assetPath = 'packages/foliate_reader/foliate-js/$relPath';

          await _serveAsset(request, assetPath, 'application/javascript; charset=utf-8');
        } else if (path.startsWith('/book/')) {
          await _serveBook(request);
        } else {
          request.response.statusCode = HttpStatus.notFound;
          await request.response.close();
        }
      } catch (e, s) {
        onDiagnostic?.call('Local reader request failed: $path\nCause: $e\nStack trace:\n$s', true);
        request.response.statusCode = HttpStatus.internalServerError;
        request.response.write(e.toString());
        await request.response.close();
      } finally {
        final status = request.response.statusCode;

        onDiagnostic?.call(
          'Local reader response: ${request.method} $path, status=$status, elapsed=${elapsed.elapsedMilliseconds}ms',
          status >= 400,
        );
      }
    });

    return _server!.port;
  }

  Future<void> stop() async {
    await _server?.close(force: true);

    _server = null;

    final directory = _narrationDirectory;

    _narrationDirectory = null;

    if (directory != null && await directory.exists()) {
      await directory.delete(recursive: true);
    }
  }

  Future<void> _storeNarration(HttpRequest request) async {
    _narrationDirectory ??= await Directory.systemTemp.createTemp('yaabsa-epub-export-');

    final extension = switch (request.headers.contentType?.mimeType) {
      'audio/mpeg' => 'mp3',
      'audio/mp4' || 'audio/x-m4a' => 'm4a',
      'audio/ogg' || 'application/ogg' => 'ogg',
      'audio/wav' || 'audio/x-wav' => 'wav',
      'audio/flac' => 'flac',
      'audio/aac' => 'aac',
      _ => 'audio',
    };
    final file = File('${_narrationDirectory!.path}/${DateTime.now().microsecondsSinceEpoch}.$extension');
    final sink = file.openWrite();

    try {
      await sink.addStream(request);
    } finally {
      await sink.close();
    }

    request.response.headers.contentType = ContentType.json;
    request.response.write(jsonEncode({'path': file.path}));
    await request.response.close();
  }

  Future<void> _serveAsset(HttpRequest request, String assetPath, String contentType) async {
    try {
      final data = await rootBundle.load(assetPath);

      final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      request.response.headers.add('Access-Control-Allow-Origin', '*');
      request.response.headers.contentType = ContentType.parse(contentType);

      if (assetPath == 'packages/foliate_reader/foliate-js/view.js') {
        request.response.write(
          utf8
              .decode(bytes)
              .replaceAll('.find(x => x.index = resolved.index)', '.find(x => x.index === resolved.index)'),
        );
      } else if (assetPath == 'packages/foliate_reader/foliate-js/paginator.js') {
        final source = utf8.decode(bytes).replaceAll('this.#observer.unobserve(this)', 'this.#observer.disconnect()');

        request.response.write(
          "import { ReaderResizeObserver as ResizeObserver } from '../reader-resize.js';\n$source",
        );
      } else {
        request.response.add(bytes);
      }

      await request.response.close();
    } catch (e, s) {
      onDiagnostic?.call('Reader asset failed: $assetPath\nCause: $e\nStack trace:\n$s', true);
      request.response.statusCode = HttpStatus.notFound;
      await request.response.close();
    }
  }

  Future<void> _serveBook(HttpRequest request) async {
    if (bookFile != null) {
      if (await bookFile!.exists()) {
        onDiagnostic?.call('Serving local eBook: bytes=${await bookFile!.length()}', false);

        final path = bookFile!.path.toLowerCase();
        String mime = 'application/octet-stream';

        if (path.endsWith('.epub')) {
          mime = 'application/epub+zip';
        } else if (path.endsWith('.mobi')) {
          mime = 'application/x-mobipocket-ebook';
        } else if (path.endsWith('.azw3') || path.endsWith('.kf8')) {
          mime = 'application/x-mobi8-ebook';
        } else if (path.endsWith('.fb2')) {
          mime = 'application/xml';
        } else if (path.endsWith('.cbz')) {
          mime = 'application/vnd.comicbook+zip';
        }

        request.response.headers.add('Access-Control-Allow-Origin', '*');
        request.response.headers.contentType = ContentType.parse(mime);
        await bookFile!.openRead().pipe(request.response);
      } else {
        onDiagnostic?.call('Local eBook file does not exist: ${bookFile!.path}', true);
        request.response.statusCode = HttpStatus.notFound;
        await request.response.close();
      }
    } else if (bookUrl != null) {
      if (bookFetcher != null) {
        onDiagnostic?.call('Fetching remote eBook using app HTTP client', false);

        try {
          await bookFetcher!(bookUrl!, headers, request);
        } catch (e, s) {
          onDiagnostic?.call('Remote eBook fetch failed\nCause: $e\nStack trace:\n$s', true);
          request.response.statusCode = HttpStatus.internalServerError;
          request.response.write(e.toString());
          await request.response.close();
        }
      } else {
        try {
          final client = HttpClient();

          final clientReq = await client.getUrl(Uri.parse(bookUrl!));

          if (headers != null) {
            headers!.forEach((key, value) {
              clientReq.headers.add(key, value);
            });
          }

          final clientRes = await clientReq.close();

          request.response.statusCode = clientRes.statusCode;
          clientRes.headers.forEach((key, values) {
            for (final value in values) {
              request.response.headers.add(key, value);
            }
          });
          request.response.headers.set('Access-Control-Allow-Origin', '*');
          await clientRes.pipe(request.response);
        } catch (e, s) {
          onDiagnostic?.call('Remote eBook fetch failed\nCause: $e\nStack trace:\n$s', true);
          request.response.statusCode = HttpStatus.internalServerError;
          request.response.write(e.toString());
          await request.response.close();
        }
      }
    } else {
      request.response.statusCode = HttpStatus.notFound;
      await request.response.close();
    }
  }
}
