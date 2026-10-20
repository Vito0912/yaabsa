part of 'reader.dart';

extension _ReaderFileHelpers on _ReaderState {
  Future<void> _loadStoredDownload() async {
    try {
      final user = ref.read(currentUserProvider).value;

      if (user != null) {
        final db = ref.read(appDatabaseProvider);

        final download = await db.getStoredDownload(widget.itemId, user.id);

        if (!mounted) {
          return;
        }

        _readerSetState(() {
          _storedDownload = download;
        });

        if (download != null) {
          final file = await _resolveEbookFile();

          _readerSetState(() {
            _localEbookFile = file;
          });
        }
      }
    } catch (e, s) {
      logger('Failed to load downloaded ebook: $e\n$s', tag: 'Reader', level: InfoLevel.error);
    } finally {
      _readerSetState(() {
        _loadingLocalFile = false;
      });
    }
  }

  String? _getLocalEbookPathOrUri() {
    final download = _storedDownload;

    if (download == null) {
      return null;
    }

    for (final path in download.auxiliaryFilePaths) {
      if (FileFormats.isEbook(path)) {
        return path;
      }
    }

    return null;
  }

  Future<File?> _resolveEbookFile() async {
    final localPathOrUri = _getLocalEbookPathOrUri();

    if (localPathOrUri == null) {
      return null;
    }

    final isSaf = _storedDownload?.saf ?? false;

    if (isSaf) {
      try {
        final tempDir = await getTemporaryDirectory();

        final ext = p.extension(localPathOrUri).isEmpty ? '.epub' : p.extension(localPathOrUri);
        final tempFile = File('${tempDir.path}/${widget.itemId}_temp_ebook$ext');

        if (await tempFile.exists()) {
          await tempFile.delete();
        }

        await downloadHandler.cancelTask(widget.itemId);
        await FileDownloader().uri.copyFile(Uri.parse(localPathOrUri), Uri.file(tempFile.path));

        _tempEbookFile = tempFile;

        return tempFile;
      } catch (e, s) {
        logger('Failed to copy SAF ebook to temp file: $e\n$s', tag: 'Reader', level: InfoLevel.error);
        return null;
      }
    } else {
      String cleanPath = localPathOrUri;

      if (cleanPath.startsWith('file://')) {
        cleanPath = Uri.parse(cleanPath).toFilePath(windows: Platform.isWindows);
      }

      final file = File(cleanPath);

      if (await file.exists()) {
        return file;
      }
    }

    return null;
  }
}
