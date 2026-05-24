import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SocialOwnUserIdCard extends StatelessWidget {
  const SocialOwnUserIdCard({required this.userId, super.key});

  final String userId;

  Future<void> _copyUserId(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: userId));
    if (!context.mounted) {
      return;
    }

    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.showSnackBar(const SnackBar(content: Text('User ID copied.')));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Card(
        elevation: 0,
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.badge_outlined, color: colorScheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your User ID', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 6),
                    SelectableText(userId, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Copy user ID',
                onPressed: () => _copyUserId(context),
                icon: const Icon(Icons.copy_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
