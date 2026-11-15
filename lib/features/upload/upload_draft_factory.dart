import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaabsa/features/upload/library_upload_models.dart';
import 'package:yaabsa/util/file_formats.dart';

class UploadDraftFactory {
  UploadDraftFactory({required this.isBookLibrary, required this.libraryName});

  static const Set<String> _otherSupportedExtensions = {
    'jpg',
    'jpeg',
    'png',
    'webp',
    'bmp',
    'gif',
    'nfo',
    'opf',
    'cue',
    'txt',
    'json',
    'xml',
    'srt',
    'vtt',
  };

  final bool isBookLibrary;
  final String libraryName;

  UploadPickedFile classifyFile({required String absolutePath, required String relativePath}) {
    final fileName = p.basename(absolutePath);
    final extension = p.extension(fileName).toLowerCase().replaceFirst('.', '');
    final isItem = isBookLibrary
        ? FileFormats.audioExtensions.contains(extension) || FileFormats.ebookExtensions.contains(extension)
        : FileFormats.audioExtensions.contains(extension);
    final kind = isItem
        ? UploadFileKind.item
        : (_otherSupportedExtensions.contains(extension) ? UploadFileKind.other : UploadFileKind.ignored);

    return UploadPickedFile(absolutePath: absolutePath, relativePath: relativePath, fileName: fileName, kind: kind);
  }

  List<UploadItemDraft> buildDirectFileItems(List<UploadPickedFile> directFiles, {required int Function() nextId}) {
    final itemFiles = directFiles.where((file) => file.kind == UploadFileKind.item).toList(growable: false);
    final otherFiles = directFiles.where((file) => file.kind == UploadFileKind.other).toList(growable: false);
    final ignoredFiles = directFiles.where((file) => file.kind == UploadFileKind.ignored).toList(growable: false);

    if (itemFiles.isEmpty) {
      return otherFiles
          .where(_isPlainTextFile)
          .map(
            (file) => _buildItem(
              nextId: nextId,
              title: _titleFromFileName(file.fileName),
              author: '',
              series: '',
              itemFiles: const <UploadPickedFile>[],
              otherFiles: <UploadPickedFile>[file],
              ignoredFiles: ignoredFiles,
              sourceDescription: file.relativePath,
            ),
          )
          .toList(growable: false);
    }

    if (isBookLibrary && itemFiles.length > 1) {
      return itemFiles
          .map(
            (file) => _buildItem(
              nextId: nextId,
              title: _titleFromFileName(file.fileName),
              author: '',
              series: '',
              itemFiles: <UploadPickedFile>[file],
              otherFiles: const <UploadPickedFile>[],
              ignoredFiles: const <UploadPickedFile>[],
              sourceDescription: file.relativePath,
              message: (otherFiles.isNotEmpty || ignoredFiles.isNotEmpty)
                  ? 'Non-book sidecar files were ignored for multi-file book upload grouping.'
                  : null,
            ),
          )
          .toList(growable: false);
    }

    final title = itemFiles.length == 1 ? _titleFromFileName(itemFiles.first.fileName) : _cleanSegment(libraryName);

    return <UploadItemDraft>[
      _buildItem(
        nextId: nextId,
        title: title,
        author: '',
        series: '',
        itemFiles: itemFiles,
        otherFiles: otherFiles,
        ignoredFiles: ignoredFiles,
        sourceDescription: itemFiles.length == 1 ? itemFiles.first.relativePath : 'Direct file selection',
      ),
    ];
  }

  Future<UploadItemDraft?> buildFolderItem(
    String folderPath, {
    required Set<String> existingAbsolutePaths,
    required int Function() nextId,
  }) async {
    final rootDirectory = Directory(folderPath);
    if (!await rootDirectory.exists()) {
      return null;
    }

    final byDirectory = <String, List<UploadPickedFile>>{};
    final allFiles = <UploadPickedFile>[];

    await for (final entity in rootDirectory.list(recursive: true, followLinks: false)) {
      if (entity is! File) {
        continue;
      }

      final absolutePath = entity.path;
      if (existingAbsolutePaths.contains(absolutePath)) {
        continue;
      }

      final relativeToRoot = p.relative(absolutePath, from: folderPath);
      final displayRelativePath = p.join(p.basename(folderPath), relativeToRoot);
      final pickedFile = classifyFile(absolutePath: absolutePath, relativePath: displayRelativePath);
      allFiles.add(pickedFile);

      final directoryPath = p.dirname(absolutePath);
      byDirectory.putIfAbsent(directoryPath, () => <UploadPickedFile>[]).add(pickedFile);
    }

    if (allFiles.isEmpty) {
      return null;
    }

    final targetDirectoryPath = _findTargetDirectory(folderPath, byDirectory);
    if (targetDirectoryPath == null) {
      return null;
    }

    final scopedFiles = allFiles
        .where((file) {
          final fileDirectory = p.dirname(file.absolutePath);
          return fileDirectory == targetDirectoryPath || p.isWithin(targetDirectoryPath, fileDirectory);
        })
        .toList(growable: false);

    final itemFiles = scopedFiles.where((file) => file.kind == UploadFileKind.item).toList(growable: false);
    final otherFiles = scopedFiles.where((file) => file.kind == UploadFileKind.other).toList(growable: false);
    final ignoredFiles = scopedFiles.where((file) => file.kind == UploadFileKind.ignored).toList(growable: false);
    if (itemFiles.isEmpty) {
      return null;
    }

    final targetRelativeToParent = p.relative(targetDirectoryPath, from: p.dirname(folderPath));
    final segments = p
        .split(targetRelativeToParent)
        .where((segment) => segment.trim().isNotEmpty && segment.trim() != '.')
        .map(_cleanSegment)
        .toList(growable: false);
    final title = segments.isNotEmpty ? segments.last : _cleanSegment(p.basename(targetDirectoryPath));
    final author = segments.length >= 2 ? segments.first : '';
    final series = segments.length >= 3 ? segments[segments.length - 2] : '';

    return _buildItem(
      nextId: nextId,
      title: title,
      author: author,
      series: series,
      itemFiles: itemFiles,
      otherFiles: otherFiles,
      ignoredFiles: ignoredFiles,
      sourceDescription: targetRelativeToParent,
    );
  }

  String? _findTargetDirectory(String folderPath, Map<String, List<UploadPickedFile>> byDirectory) {
    final rootItemFiles = byDirectory[folderPath]?.where((file) => file.kind == UploadFileKind.item) ?? const [];
    if (rootItemFiles.isNotEmpty) {
      return folderPath;
    }

    final candidateDirectories =
        byDirectory.entries
            .where((entry) => entry.value.any((file) => file.kind == UploadFileKind.item))
            .map((entry) => entry.key)
            .toList(growable: false)
          ..sort();

    for (final candidate in candidateDirectories) {
      if (candidate != folderPath) {
        return candidate;
      }
    }

    return null;
  }

  UploadItemDraft _buildItem({
    required int Function() nextId,
    required String title,
    required String author,
    required String series,
    required List<UploadPickedFile> itemFiles,
    required List<UploadPickedFile> otherFiles,
    required List<UploadPickedFile> ignoredFiles,
    required String sourceDescription,
    String? message,
  }) {
    return UploadItemDraft(
      id: nextId(),
      title: title,
      author: author,
      series: series,
      itemFiles: itemFiles,
      otherFiles: otherFiles,
      ignoredFiles: ignoredFiles,
      status: UploadItemStatus.ready,
      progress: 0,
      uploadSpeedBytesPerSecond: 0,
      uploadedBytes: 0,
      totalBytes: 0,
      sourceDescription: sourceDescription,
      message: message,
    );
  }

  bool _isPlainTextFile(UploadPickedFile file) {
    return p.extension(file.fileName).toLowerCase() == '.txt';
  }

  String _cleanSegment(String value) {
    final cleaned = value.replaceAll(RegExp(r'[_\.]+'), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
    return cleaned.isEmpty ? value : cleaned;
  }

  String _titleFromFileName(String fileName) {
    return _cleanSegment(p.basenameWithoutExtension(fileName));
  }
}
