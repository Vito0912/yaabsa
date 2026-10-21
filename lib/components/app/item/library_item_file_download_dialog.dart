import 'dart:io';
import 'dart:typed_data';

import 'package:background_downloader/background_downloader.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/components/common/list_management_dialogs.dart';
import 'package:yaabsa/util/item_formatters.dart';
import 'package:yaabsa/util/logger.dart';

Future<Uri?> showLibraryItemFileDownloadDialog({
  required BuildContext context,
  required ABSApi api,
  required String itemId,
  required String fileIno,
  required String filename,
}) {
  return showDialog<Uri>(
    context: context,
    barrierDismissible: false,
    builder: (context) => _FileDownloadDialog(api: api, itemId: itemId, fileIno: fileIno, filename: filename),
  );
}

class _FileDownloadDialog extends StatefulWidget {
  const _FileDownloadDialog({required this.api, required this.itemId, required this.fileIno, required this.filename});

  final ABSApi api;
  final String itemId;
  final String fileIno;
  final String filename;

  @override
  State<_FileDownloadDialog> createState() => _FileDownloadDialogState();
}

class _FileDownloadDialogState extends State<_FileDownloadDialog> {
  final _cancelToken = CancelToken();
  final _progressClock = Stopwatch()..start();
  var _received = 0;
  var _total = 0;
  var _saving = false;
  var _copying = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _download());
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    _progressClock.stop();
    super.dispose();
  }

  Future<void> _download() async {
    Directory? temporary;
    try {
      if (!mounted) {
        return;
      }
      final cache = await getTemporaryDirectory();
      temporary = await cache.createTemp('yaabsa_file_');
      final file = File(p.join(temporary.path, 'payload'));
      await widget.api.dio.download(
        '/api/items/${Uri.encodeComponent(widget.itemId)}/file/${Uri.encodeComponent(widget.fileIno)}/download',
        file.path,
        cancelToken: _cancelToken,
        options: Options(
          extra: const {
            'doNotCache': true,
            'secure': [
              {'type': 'http', 'scheme': 'bearer', 'name': 'BearerAuth'},
            ],
          },
        ),
        onReceiveProgress: (received, total) {
          if (!mounted || (_progressClock.elapsedMilliseconds < 100 && received != total)) {
            return;
          }
          _progressClock.reset();
          setState(() {
            _received = received;
            _total = total;
          });
        },
      );
      if (!mounted) {
        return;
      }

      setState(() {
        _saving = true;
      });
      final safeName = widget.filename.replaceAll(RegExp(r'[<>:"/\\|?*\x00-\x1F]'), '_');
      final destination = await FilePicker.saveFile(
        dialogTitle: 'Save file',
        fileName: safeName.isEmpty ? 'download' : safeName,
        bytes: Uint8List(0),
      );
      if (destination == null) {
        if (mounted) {
          Navigator.of(context).pop();
        }
        return;
      }

      if (mounted) {
        setState(() {
          _copying = true;
        });
      }
      final downloader = FileDownloader();
      Uri? saved;
      if (destination.scheme == 'file') {
        final activated = await downloader.uri.activate(destination) ?? destination;
        await file.copy(File.fromUri(activated).path);
        saved = destination;
      } else {
        saved = await downloader.uri.copyFile(file.uri, destination);
      }
      if (saved == null) {
        throw StateError('Could not save the downloaded file.');
      }
      if (mounted) {
        Navigator.of(context).pop(saved);
      }
    } catch (error) {
      if (mounted && !_cancelToken.isCancelled) {
        setState(() {
          _saving = false;
          _error = listManagementErrorMessage(error, fallback: 'Could not download or save the file.');
        });
      }
    } finally {
      try {
        if (temporary != null && await temporary.exists()) {
          await temporary.delete(recursive: true);
        }
      } on FileSystemException catch (error) {
        logger(
          'Could not clean up a temporary file download: ${error.message}',
          tag: 'FileDownload',
          level: InfoLevel.warning,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_saving,
      child: AlertDialog(
        title: const Text('Download file'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(widget.filename, maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 12),
              if (_error != null)
                Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error))
              else if (_saving)
                Text(_copying ? 'Saving file...' : 'Choose where to save the file')
              else ...[
                LinearProgressIndicator(value: _total > 0 ? (_received / _total).clamp(0, 1) : null),
                const SizedBox(height: 8),
                Text(_total > 0 ? '${formatBytes(_received)} of ${formatBytes(_total)}' : formatBytes(_received)),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saving
                ? null
                : () {
                    _cancelToken.cancel();
                    Navigator.of(context).pop();
                  },
            child: Text(_error == null ? 'Cancel' : 'Close'),
          ),
        ],
      ),
    );
  }
}
