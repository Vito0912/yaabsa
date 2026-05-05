import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ListEntityMissingView extends StatelessWidget {
  const ListEntityMissingView({required this.icon, required this.title, required this.message, super.key});

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 38),
            const SizedBox(height: 12),
            Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 14),
            FilledButton.tonalIcon(
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  context.pop();
                }
              },
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
