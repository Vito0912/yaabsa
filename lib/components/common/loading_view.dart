import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/provider/core/user_providers.dart';

class LoadingView extends ConsumerWidget {
  const LoadingView({super.key, this.showDownloadsShortcut = true, this.alwaysShowDownloadsShortcut = false});

  final bool showDownloadsShortcut;
  final bool alwaysShowDownloadsShortcut;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final canDownload = currentUserAsync.value?.permissions.download ?? false;
    final shouldShowButton = (canDownload && showDownloadsShortcut) || alwaysShowDownloadsShortcut;

    return Stack(
      children: [
        const Center(child: CircularProgressIndicator()),

        if (shouldShowButton)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: OutlinedButton.icon(
                onPressed: () {
                  context.go('/?tab=downloads&intent=downloads');
                },
                icon: const Icon(Icons.download_rounded),
                label: const Text('Open Downloads'),
              ),
            ),
          ),
      ],
    );
  }
}
