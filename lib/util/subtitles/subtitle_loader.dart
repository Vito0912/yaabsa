import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/subtitles/subtitle_parser.dart';

const int _maxMediaCacheEntries = 20;
const int _maxSourceCacheEntries = 40;

final LinkedHashMap<String, Future<LoadedSubtitleDocument?>> _mediaCache =
    LinkedHashMap<String, Future<LoadedSubtitleDocument?>>();
final LinkedHashMap<String, ParsedSubtitleDocument?> _sourceDocumentCache =
    LinkedHashMap<String, ParsedSubtitleDocument?>();

Future<LoadedSubtitleDocument?> loadSubtitleDocumentForItem({
  required WidgetRef ref,
  required String itemId,
  required String? episodeId,
  required String? userId,
}) {
  final mediaCacheKey = '$itemId::${episodeId ?? ''}::${userId ?? ''}';
  final existing = _mediaCache.remove(mediaCacheKey);
  if (existing != null) {
    _mediaCache[mediaCacheKey] = existing;
    return existing;
  }

  final future = _loadSubtitleDocumentInternal(ref: ref, itemId: itemId, episodeId: episodeId, userId: userId);
  _mediaCache[mediaCacheKey] = future;
  _trimFutureCache(_mediaCache, _maxMediaCacheEntries);
  return future;
}

Future<LoadedSubtitleDocument?> _loadSubtitleDocumentInternal({
  required WidgetRef ref,
  required String itemId,
  required String? episodeId,
  required String? userId,
}) async {
  final localSources = await _collectLocalSubtitleSources(
    ref: ref,
    itemId: itemId,
    episodeId: episodeId,
    userId: userId,
  );
  final loadedFromLocal = await _loadFirstParsableFromSources(ref: ref, itemId: itemId, sources: localSources);
  if (loadedFromLocal != null) {
    return loadedFromLocal;
  }

  final remoteSources = await _collectRemoteSubtitleSources(ref: ref, itemId: itemId);
  return _loadFirstParsableFromSources(ref: ref, itemId: itemId, sources: remoteSources);
}

Future<LoadedSubtitleDocument?> _loadFirstParsableFromSources({
  required WidgetRef ref,
  required String itemId,
  required List<SubtitleSourceCandidate> sources,
}) async {
  if (sources.isEmpty) {
    return null;
  }

  for (final source in sources) {
    final cachedDocument = _sourceDocumentCache.remove(source.cacheKey);
    if (cachedDocument != null) {
      _sourceDocumentCache[source.cacheKey] = cachedDocument;
      return LoadedSubtitleDocument(document: cachedDocument, source: source);
    }

    final content = await _readSource(ref: ref, itemId: itemId, source: source);
    if (content == null || content.trim().isEmpty) {
      continue;
    }

    final document = SubtitleParser.parse(rawContent: content, format: source.format);
    if (document == null || document.cues.isEmpty) {
      continue;
    }

    _sourceDocumentCache[source.cacheKey] = document;
    _trimValueCache(_sourceDocumentCache, _maxSourceCacheEntries);
    return LoadedSubtitleDocument(document: document, source: source);
  }

  return null;
}

Future<List<SubtitleSourceCandidate>> _collectLocalSubtitleSources({
  required WidgetRef ref,
  required String itemId,
  required String? episodeId,
  required String? userId,
}) async {
  final candidates = <SubtitleSourceCandidate>[];
  final dedupeKeys = <String>{};

  void addCandidate(SubtitleSourceCandidate candidate) {
    if (dedupeKeys.contains(candidate.cacheKey)) {
      return;
    }
    dedupeKeys.add(candidate.cacheKey);
    candidates.add(candidate);
  }

  if (userId == null || userId.isEmpty) {
    return candidates;
  }

  final localDownload = await ref.read(appDatabaseProvider).getStoredDownload(itemId, userId, episodeId: episodeId);
  if (localDownload == null) {
    return candidates;
  }

  for (final localPath in localDownload.auxiliaryFilePaths) {
    final format = _formatForPath(localPath);
    if (format == null) {
      continue;
    }

    addCandidate(
      SubtitleSourceCandidate.local(format: format, label: _filenameFromPath(localPath), localPathOrUri: localPath),
    );
  }

  candidates.sort((left, right) {
    final leftScore = _sourcePriority(left);
    final rightScore = _sourcePriority(right);
    if (leftScore != rightScore) {
      return leftScore.compareTo(rightScore);
    }

    return (left.label ?? '').compareTo(right.label ?? '');
  });

  return candidates;
}

Future<List<SubtitleSourceCandidate>> _collectRemoteSubtitleSources({
  required WidgetRef ref,
  required String itemId,
}) async {
  final candidates = <SubtitleSourceCandidate>[];
  final dedupeKeys = <String>{};

  void addCandidate(SubtitleSourceCandidate candidate) {
    if (dedupeKeys.contains(candidate.cacheKey)) {
      return;
    }
    dedupeKeys.add(candidate.cacheKey);
    candidates.add(candidate);
  }

  LibraryItem? libraryItem = ref.read(libraryItemProvider(itemId)).asData?.value;
  if (libraryItem == null) {
    try {
      libraryItem = await ref.read(libraryItemProvider(itemId).future);
    } catch (error, stackTrace) {
      logger(
        'Failed to load library item for subtitle discovery: $error\n$stackTrace',
        tag: 'SubtitleLoader',
        level: InfoLevel.warning,
      );
    }
  }

  if (libraryItem == null) {
    return candidates;
  }

  for (final libraryFile in libraryItem.libraryFiles ?? const []) {
    final format = _formatForExtension(libraryFile.metadata.ext);
    if (format == null) {
      continue;
    }

    addCandidate(
      SubtitleSourceCandidate.remote(format: format, label: libraryFile.metadata.filename, fileInode: libraryFile.ino),
    );
  }

  candidates.sort((left, right) {
    final leftScore = _sourcePriority(left);
    final rightScore = _sourcePriority(right);
    if (leftScore != rightScore) {
      return leftScore.compareTo(rightScore);
    }

    return (left.label ?? '').compareTo(right.label ?? '');
  });

  return candidates;
}

int _sourcePriority(SubtitleSourceCandidate source) {
  final formatWeight = source.format == SubtitleDocumentFormat.webvtt ? 0 : 1;
  final typeWeight = source.type == SubtitleSourceType.local ? 0 : 1;
  return (formatWeight * 10) + typeWeight;
}

Future<String?> _readSource({
  required WidgetRef ref,
  required String itemId,
  required SubtitleSourceCandidate source,
}) async {
  if (source.type == SubtitleSourceType.local) {
    return _readLocalSource(source.localPathOrUri);
  }

  return _readRemoteSource(ref: ref, itemId: itemId, source: source);
}

Future<String?> _readLocalSource(String? localPathOrUri) async {
  if (localPathOrUri == null) {
    return null;
  }

  final trimmed = localPathOrUri.trim();
  if (trimmed.isEmpty) {
    return null;
  }

  try {
    if (Platform.isWindows && RegExp(r'^[a-zA-Z]:[\\/]').hasMatch(trimmed)) {
      final file = File(trimmed);
      return file.existsSync() ? await file.readAsString() : null;
    }

    final parsedUri = Uri.tryParse(trimmed);
    if (parsedUri == null || parsedUri.scheme.isEmpty) {
      final file = File(trimmed);
      return file.existsSync() ? await file.readAsString() : null;
    }

    if (parsedUri.scheme == 'file') {
      final file = File.fromUri(parsedUri);
      return file.existsSync() ? await file.readAsString() : null;
    }

    logger(
      'Skipping unsupported local subtitle URI scheme: ${parsedUri.scheme}',
      tag: 'SubtitleLoader',
      level: InfoLevel.warning,
    );
    return null;
  } catch (error, stackTrace) {
    logger(
      'Failed to read local subtitle file "$trimmed": $error\n$stackTrace',
      tag: 'SubtitleLoader',
      level: InfoLevel.warning,
    );
    return null;
  }
}

Future<String?> _readRemoteSource({
  required WidgetRef ref,
  required String itemId,
  required SubtitleSourceCandidate source,
}) async {
  final inode = source.fileInode;
  if (inode == null || inode.trim().isEmpty) {
    return null;
  }

  final ABSApi? api = ref.read(absApiProvider);
  if (api == null) {
    return null;
  }

  try {
    final response = await api.dio.get<Object>(
      '/api/items/$itemId/file/$inode',
      options: Options(
        responseType: ResponseType.plain,
        extra: const <String, dynamic>{
          'secure': <Map<String, String>>[
            <String, String>{'type': 'http', 'scheme': 'bearer', 'name': 'BearerAuth'},
          ],
        },
      ),
    );

    final responseData = response.data;
    if (responseData is String) {
      return responseData;
    }
    if (responseData is List<int>) {
      return utf8.decode(responseData, allowMalformed: true);
    }

    return null;
  } catch (error, stackTrace) {
    logger(
      'Failed to download remote subtitle file ${source.label ?? inode}: $error\n$stackTrace',
      tag: 'SubtitleLoader',
      level: InfoLevel.warning,
    );
    return null;
  }
}

SubtitleDocumentFormat? _formatForPath(String pathOrUri) {
  final extension = _extractExtension(pathOrUri);
  return _formatForExtension(extension);
}

SubtitleDocumentFormat? _formatForExtension(String? rawExtension) {
  if (rawExtension == null) {
    return null;
  }

  final normalized = rawExtension.trim().toLowerCase();
  if (normalized.isEmpty) {
    return null;
  }

  final extension = normalized.startsWith('.') ? normalized.substring(1) : normalized;
  return switch (extension) {
    'vtt' => SubtitleDocumentFormat.webvtt,
    'srt' => SubtitleDocumentFormat.srt,
    _ => null,
  };
}

String _extractExtension(String value) {
  final normalized = value.trim();
  if (normalized.isEmpty) {
    return '';
  }

  final parsedUri = Uri.tryParse(normalized);
  final asPath = parsedUri == null || parsedUri.scheme.isEmpty ? normalized : parsedUri.path;
  final filename = asPath.split('/').last;
  final extensionIndex = filename.lastIndexOf('.');
  if (extensionIndex < 0 || extensionIndex == filename.length - 1) {
    return '';
  }

  return filename.substring(extensionIndex + 1);
}

String _filenameFromPath(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return value;
  }

  final parsedUri = Uri.tryParse(trimmed);
  final asPath = parsedUri == null || parsedUri.scheme.isEmpty ? trimmed : parsedUri.path;
  final filename = asPath.split('/').last;
  if (filename.isEmpty) {
    return trimmed;
  }

  return filename;
}

void _trimFutureCache<K, V>(LinkedHashMap<K, Future<V>> cache, int maxEntries) {
  while (cache.length > maxEntries) {
    final firstKey = cache.keys.first;
    cache.remove(firstKey);
  }
}

void _trimValueCache<K, V>(LinkedHashMap<K, V> cache, int maxEntries) {
  while (cache.length > maxEntries) {
    final firstKey = cache.keys.first;
    cache.remove(firstKey);
  }
}

class LoadedSubtitleDocument {
  const LoadedSubtitleDocument({required this.document, required this.source});

  final ParsedSubtitleDocument document;
  final SubtitleSourceCandidate source;
}

enum SubtitleSourceType { local, remote }

class SubtitleSourceCandidate {
  SubtitleSourceCandidate._({
    required this.type,
    required this.format,
    required this.cacheKey,
    this.label,
    this.localPathOrUri,
    this.fileInode,
  });

  SubtitleSourceCandidate.local({required SubtitleDocumentFormat format, String? label, required String localPathOrUri})
    : this._(
        type: SubtitleSourceType.local,
        format: format,
        label: label,
        localPathOrUri: localPathOrUri,
        cacheKey: 'local::${format.name}::$localPathOrUri',
      );

  SubtitleSourceCandidate.remote({required SubtitleDocumentFormat format, String? label, required String fileInode})
    : this._(
        type: SubtitleSourceType.remote,
        format: format,
        label: label,
        fileInode: fileInode,
        cacheKey: 'remote::${format.name}::$fileInode',
      );

  final SubtitleSourceType type;
  final SubtitleDocumentFormat format;
  final String cacheKey;
  final String? label;
  final String? localPathOrUri;
  final String? fileInode;
}
