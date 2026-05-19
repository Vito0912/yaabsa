import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/api/library/author_details.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/components/app/library/author_detail_content.dart';
import 'package:yaabsa/components/common/author_card.dart';
import 'package:yaabsa/components/common/connection_issue_view.dart';
import 'package:yaabsa/provider/common/library_author_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';

import 'package:yaabsa/generated/l10n.dart';

class AuthorDetailView extends ConsumerWidget {
  const AuthorDetailView({super.key, required this.authorId});

  final String authorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.watch(absApiProvider);
    if (api == null) {
      return ConnectionIssueView.offline();
    }

    final authorDetailsAsync = ref.watch(libraryAuthorProvider(authorId));
    return authorDetailsAsync.when(
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: true,
      data: (author) => _AuthorDetailLoadedView(author: author, api: api),
      loading: () => Column(
        children: [
          _AuthorTopSection(
            authorId: authorId,
            title: authorId,
            subtitle: null,
            description: null,
            isLoadingDetails: true,
          ),
          const Expanded(child: Center(child: CircularProgressIndicator())),
        ],
      ),
      error: (error, stackTrace) => ConnectionIssueView.requestFailed(
        error: error,
        title: S.current.authorDetailErrorLoadingDetails,
        onRetry: () async {
          ref.invalidate(libraryAuthorProvider(authorId));
          await ref.read(libraryAuthorProvider(authorId).future);
        },
      ),
    );
  }
}

class _AuthorDetailLoadedView extends StatelessWidget {
  const _AuthorDetailLoadedView({required this.author, required this.api});

  final AuthorDetails author;
  final ABSApi api;

  @override
  Widget build(BuildContext context) {
    final numBooks = author.libraryItems.length;
    final subtitle = numBooks <= 0 ? null : S.current.authorDetailBookCount(numBooks);

    return Column(
      children: [
        _AuthorTopSection(
          authorId: author.id,
          title: author.name,
          subtitle: subtitle,
          description: author.description,
          isLoadingDetails: false,
        ),
        Expanded(
          child: AuthorDetailContent(author: author, api: api),
        ),
      ],
    );
  }
}

class _AuthorTopSection extends StatelessWidget {
  const _AuthorTopSection({
    required this.authorId,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.isLoadingDetails,
  });

  final String authorId;
  final String title;
  final String? subtitle;
  final String? description;
  final bool isLoadingDetails;

  @override
  Widget build(BuildContext context) {
    final imageSize = context.isDesktop
        ? 112.0
        : context.isTablet
        ? 98.0
        : 80.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                    return;
                  }

                  context.go('/?tab=authors&intent=${DateTime.now().microsecondsSinceEpoch}');
                },
                icon: const Icon(Icons.arrow_back_rounded),
                tooltip: S.current.screensMainAuthorDetailViewBack,
              ),
              const SizedBox(width: 6),
              AuthorImage(authorId: authorId, width: imageSize, height: imageSize, borderRadius: 14),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ],
                    if (description != null && description!.trim().isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        description!.trim(),
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: context.isMobile ? 4 : 6,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ] else if (isLoadingDetails) ...[
                      const SizedBox(height: 8),
                      const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.2)),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
