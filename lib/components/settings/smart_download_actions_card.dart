import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/settings/settings_button.dart';
import 'package:yaabsa/provider/library/smart_download_provider.dart';
import 'package:yaabsa/util/l10n.dart';

class SmartDownloadActionsCard extends ConsumerStatefulWidget {
  const SmartDownloadActionsCard({super.key, required this.userId, required this.isBusy});

  final String userId;
  final bool isBusy;

  @override
  ConsumerState<SmartDownloadActionsCard> createState() => _SmartDownloadActionsCardState();
}

class _SmartDownloadActionsCardState extends ConsumerState<SmartDownloadActionsCard> {
  bool _isCleaning = false;

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _deleteListenedDownloads() async {
    if (_isCleaning) {
      return;
    }

    final localizations = context.l10n;

    setState(() {
      _isCleaning = true;
    });

    try {
      final manager = ref.read(smartDownloadManagerProvider.notifier);
      final deleted = await manager.deleteListenedManagedDownloads(userId: widget.userId);

      final message = deleted == 0
          ? localizations.statusNoListenedDownloadsToDelete
          : localizations.statusDeletedListenedDownloads(deleted);
      _showMessage(message);
    } catch (error) {
      _showMessage(localizations.errorDeleteListenedDownloadsFailed(error.toString()));
    } finally {
      if (mounted) {
        setState(() {
          _isCleaning = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 12, 8, 0),
      child: Column(
        children: [
          SettingButton(
            label: context.l10n.actionDeleteListenedDownloads,
            buttonText: context.l10n.actionDelete,
            buttonIcon: Icons.delete_sweep_outlined,
            isDestructive: true,
            isLoading: _isCleaning,
            onPressed: _isCleaning || widget.isBusy ? null : _deleteListenedDownloads,
          ),
        ],
      ),
    );
  }
}
