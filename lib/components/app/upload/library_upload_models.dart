import 'package:flutter/foundation.dart';

enum UploadFileKind { item, other, ignored }

enum UploadItemStatus { ready, checkingPaths, warning, uploading, success, failed, canceled }

@immutable
class UploadMetadataSuggestion {
  const UploadMetadataSuggestion({required this.title, required this.author, required this.series});

  final String title;
  final String author;
  final String series;
}

@immutable
class UploadPickedFile {
  const UploadPickedFile({
    required this.absolutePath,
    required this.relativePath,
    required this.fileName,
    required this.kind,
  });

  final String absolutePath;
  final String relativePath;
  final String fileName;
  final UploadFileKind kind;
}

@immutable
class UploadItemDraft {
  const UploadItemDraft({
    required this.id,
    required this.title,
    required this.author,
    required this.series,
    required this.itemFiles,
    required this.otherFiles,
    required this.ignoredFiles,
    required this.status,
    required this.progress,
    required this.uploadSpeedBytesPerSecond,
    required this.uploadedBytes,
    required this.totalBytes,
    required this.sourceDescription,
    this.pendingMetadata,
    this.message,
  });

  final int id;
  final String title;
  final String author;
  final String series;
  final List<UploadPickedFile> itemFiles;
  final List<UploadPickedFile> otherFiles;
  final List<UploadPickedFile> ignoredFiles;
  final UploadItemStatus status;
  final double progress;
  final double uploadSpeedBytesPerSecond;
  final int uploadedBytes;
  final int totalBytes;
  final String sourceDescription;
  final UploadMetadataSuggestion? pendingMetadata;
  final String? message;

  List<UploadPickedFile> get uploadFiles => <UploadPickedFile>[...itemFiles, ...otherFiles];

  UploadItemDraft copyWith({
    String? title,
    String? author,
    String? series,
    List<UploadPickedFile>? itemFiles,
    List<UploadPickedFile>? otherFiles,
    List<UploadPickedFile>? ignoredFiles,
    UploadItemStatus? status,
    double? progress,
    double? uploadSpeedBytesPerSecond,
    int? uploadedBytes,
    int? totalBytes,
    String? sourceDescription,
    UploadMetadataSuggestion? pendingMetadata,
    bool clearPendingMetadata = false,
    String? message,
    bool clearMessage = false,
  }) {
    return UploadItemDraft(
      id: id,
      title: title ?? this.title,
      author: author ?? this.author,
      series: series ?? this.series,
      itemFiles: itemFiles ?? this.itemFiles,
      otherFiles: otherFiles ?? this.otherFiles,
      ignoredFiles: ignoredFiles ?? this.ignoredFiles,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      uploadSpeedBytesPerSecond: uploadSpeedBytesPerSecond ?? this.uploadSpeedBytesPerSecond,
      uploadedBytes: uploadedBytes ?? this.uploadedBytes,
      totalBytes: totalBytes ?? this.totalBytes,
      sourceDescription: sourceDescription ?? this.sourceDescription,
      pendingMetadata: clearPendingMetadata ? null : (pendingMetadata ?? this.pendingMetadata),
      message: clearMessage ? null : (message ?? this.message),
    );
  }
}

extension UploadItemStatusLabel on UploadItemStatus {
  String get label {
    return switch (this) {
      UploadItemStatus.ready => 'Ready',
      UploadItemStatus.checkingPaths => 'Checking paths',
      UploadItemStatus.warning => 'Warning',
      UploadItemStatus.uploading => 'Uploading',
      UploadItemStatus.success => 'Uploaded',
      UploadItemStatus.failed => 'Failed',
      UploadItemStatus.canceled => 'Canceled',
    };
  }
}
