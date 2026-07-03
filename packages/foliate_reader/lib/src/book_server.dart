import 'dart:io';
import 'package:flutter/services.dart';

class BookServer {
  File? bookFile;
  String? bookUrl;
  Map<String, String>? headers;
  HttpServer? _server;
  final Future<void> Function(String url, Map<String, String>? headers, HttpRequest request)? bookFetcher;

  BookServer({this.bookFile, this.bookUrl, this.headers, this.bookFetcher});

  Future<int> start() async {
    _server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    _server!.listen((HttpRequest request) async {
      try {
        final path = request.uri.path;
        if (path == '/' || path == '/index.html' || path == '/reader.html') {
          await _serveAsset(request, 'packages/foliate_reader/assets/reader.html', 'text/html; charset=utf-8');
        } else if (path == '/reader-app.js') {
          await _serveAsset(
            request,
            'packages/foliate_reader/assets/reader-app.js',
            'application/javascript; charset=utf-8',
          );
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
      } catch (e) {
        request.response.statusCode = HttpStatus.internalServerError;
        request.response.write(e.toString());
        await request.response.close();
      }
    });
    return _server!.port;
  }

  Future<void> stop() async {
    await _server?.close(force: true);
    _server = null;
  }

  Future<void> _serveAsset(HttpRequest request, String assetPath, String contentType) async {
    try {
      final data = await rootBundle.load(assetPath);
      final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      request.response.headers.add('Access-Control-Allow-Origin', '*');
      request.response.headers.contentType = ContentType.parse(contentType);
      request.response.add(bytes);
      await request.response.close();
    } catch (e) {
      request.response.statusCode = HttpStatus.notFound;
      await request.response.close();
    }
  }

  Future<void> _serveBook(HttpRequest request) async {
    if (bookFile != null) {
      if (await bookFile!.exists()) {
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
        request.response.statusCode = HttpStatus.notFound;
        await request.response.close();
      }
    } else if (bookUrl != null) {
      if (bookFetcher != null) {
        try {
          await bookFetcher!(bookUrl!, headers, request);
        } catch (e) {
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
        } catch (e) {
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
