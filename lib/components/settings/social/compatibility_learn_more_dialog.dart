import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CompatibilityFeatureDetail {
  const CompatibilityFeatureDetail({required this.key, required this.description});

  final String key;
  final String description;
}

class CompatibilityLearnMoreContent {
  const CompatibilityLearnMoreContent({
    required this.title,
    required this.summary,
    required this.notes,
    required this.features,
    this.repositoryUrl,
    this.repositoryLabel,
  });

  final String title;
  final List<String> summary;
  final List<String> notes;
  final List<CompatibilityFeatureDetail> features;
  final String? repositoryUrl;
  final String? repositoryLabel;

  factory CompatibilityLearnMoreContent.socialDefaults() {
    return const CompatibilityLearnMoreContent(
      title: 'Compatibility Layer',
      summary: [
        'yaabsa works with standard Audiobookshelf servers and will keep working with them. Some features need a modified server to work because they cannot function without changing the server.',
        'This is not a plugin system. Audiobookshelf does not have a plugin API for this right now, so you must change the image or package you are using. Any server that offers the same compatibility can use this feature.',
      ],
      notes: [
        'At the moment, this is mainly supported by the vito0912/audiobookshelf fork and is intended as an in-place replacement. It is non-breaking, and you can downgrade back to upstream Audiobookshelf at any time.',
      ],
      repositoryUrl: 'https://github.com/Vito0912/audiobookshelf',
      repositoryLabel: 'See vito0912/audiobookshelf fork',
      features: [
        CompatibilityFeatureDetail(
          key: 'vito0912/websocket',
          description:
              'Allows client-to-client payload delivery through the server websocket. Apps can build synced controls, synced playback state, synced progress, and similar collaborative features when both users are connected.',
        ),
      ],
    );
  }
}

class CompatibilityLearnMoreDialog extends StatelessWidget {
  const CompatibilityLearnMoreDialog({required this.content, super.key});

  final CompatibilityLearnMoreContent content;

  static Future<void> show(BuildContext context, {required CompatibilityLearnMoreContent content}) async {
    await showDialog<void>(
      context: context,
      builder: (context) => CompatibilityLearnMoreDialog(content: content),
    );
  }

  Future<void> _openRepository(BuildContext context) async {
    final url = content.repositoryUrl;
    if (url == null || url.trim().isEmpty) {
      return;
    }

    final uri = Uri.tryParse(url);
    if (uri == null) {
      return;
    }

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (launched || !context.mounted) {
      return;
    }

    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.showSnackBar(const SnackBar(content: Text('Could not open repository link.')));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: colorScheme.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      content.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _InfoSection(title: 'How compatibility works', lines: content.summary),
                      const SizedBox(height: 12),
                      _InfoSection(title: 'Current support', lines: content.notes),
                      if (content.repositoryUrl != null && content.repositoryUrl!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: OutlinedButton.icon(
                              onPressed: () => _openRepository(context),
                              icon: const Icon(Icons.open_in_new_rounded),
                              label: Text(content.repositoryLabel ?? 'Open repository'),
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      Text(
                        'Supported compatibility flags',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      ...content.features.map(
                        (feature) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: colorScheme.surface,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                    child: Text(
                                      feature.key,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(feature.description, style: Theme.of(context).textTheme.bodyMedium),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.title, required this.lines});

  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          ...lines.map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(color: colorScheme.primary, shape: BoxShape.circle),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(line, style: Theme.of(context).textTheme.bodyMedium)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
