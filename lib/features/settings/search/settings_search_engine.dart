import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/settings/model/setting_definition.dart';
import 'package:yaabsa/features/settings/model/settings_availability.dart';
import 'package:yaabsa/features/settings/model/settings_spec.dart';
import 'package:yaabsa/features/settings/registry/settings_registry.dart';

class SettingsSearchResult {
  const SettingsSearchResult({
    required this.entryId,
    required this.pageId,
    required this.route,
    required this.icon,
    required this.scope,
    required this.title,
    required this.description,
    required this.categoryPath,
    required this.availability,
    required this.score,
    this.registerRoute = true,
    this.onTapOverride,
  });

  final String entryId;
  final String pageId;
  final String route;
  final IconData icon;
  final SettingScope scope;
  final String title;
  final String? description;
  final String categoryPath;
  final SettingsAvailability availability;
  final int score;
  final bool registerRoute;
  final FutureOr<void> Function(BuildContext context, WidgetRef ref)? onTapOverride;
}

class SettingsSearchEngine {
  const SettingsSearchEngine._();

  static List<SettingsSearchResult> search({
    required SettingsRegistry registry,
    required SettingsContext ctx,
    required String rawQuery,
  }) {
    final tokens = rawQuery
        .trim()
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((token) => token.isNotEmpty)
        .toList(growable: false);

    if (tokens.isEmpty) {
      return const <SettingsSearchResult>[];
    }

    final results = <SettingsSearchResult>[];

    for (final page in registry.allPages) {
      final pageAvailability = registry.resolvePageAvailability(page, ctx);
      if (!pageAvailability.isVisible) {
        continue;
      }

      final breadcrumb = registry.breadcrumbForPage(page.id, ctx);

      for (final meta in page.searchableMetadata) {
        final itemAvailability = SettingsRegistry.combineAvailability(pageAvailability, meta.availability(ctx));
        if (!itemAvailability.isVisible) {
          continue;
        }

        final title = meta.title(ctx);
        final description = meta.description?.call(ctx);
        final keywords = meta.keywords?.call(ctx.l10n) ?? const <String>[];
        final score = _score(
          tokens: tokens,
          title: title,
          description: description,
          categoryPath: breadcrumb,
          keywords: keywords,
        );

        if (score > 0) {
          results.add(
            SettingsSearchResult(
              entryId: meta.id,
              pageId: page.id,
              route: page.route,
              icon: page.icon,
              scope: meta.scopeOverride ?? page.scope,
              title: title,
              description: description,
              categoryPath: breadcrumb,
              availability: itemAvailability,
              score: score,
              registerRoute: page.registerRoute,
              onTapOverride: page.onExternalTap != null ? (context, ref) => page.onExternalTap!(context) : null,
            ),
          );
        }
      }

      for (final section in page.sections) {
        final sectionAvailability = SettingsRegistry.combineAvailability(pageAvailability, section.availability(ctx));
        if (!sectionAvailability.isVisible) {
          continue;
        }

        for (final entry in section.entries) {
          if (!entry.searchable) {
            continue;
          }

          if (entry is SettingsNavEntry &&
              entry.targetPageId != null &&
              registry.findPageById(entry.targetPageId!) != null) {
            continue;
          }

          final entryAvailability = SettingsRegistry.combineAvailability(sectionAvailability, entry.availability(ctx));
          if (!entryAvailability.isVisible) {
            continue;
          }

          final title = entry.title(ctx);
          final description = entry.description?.call(ctx);
          final keywords = entry.keywords?.call(ctx.l10n) ?? const <String>[];
          final score = _score(
            tokens: tokens,
            title: title,
            description: description,
            categoryPath: breadcrumb,
            keywords: keywords,
          );

          if (score > 0) {
            results.add(
              SettingsSearchResult(
                entryId: entry.id,
                pageId: page.id,
                route: page.route,
                icon: entry.icon ?? page.icon,
                scope: entry.scopeOverride ?? page.scope,
                title: title,
                description: description,
                categoryPath: breadcrumb,
                availability: entryAvailability,
                score: score,
                registerRoute: page.registerRoute,
                onTapOverride: entry is SettingsNavEntry ? entry.onTapOverride : null,
              ),
            );
          }
        }
      }
    }

    results.sort((a, b) {
      final scoreDiff = b.score.compareTo(a.score);
      if (scoreDiff != 0) {
        return scoreDiff;
      }

      return a.title.toLowerCase().compareTo(b.title.toLowerCase());
    });

    return results;
  }

  static int _score({
    required List<String> tokens,
    required String title,
    required String? description,
    required String categoryPath,
    required List<String> keywords,
  }) {
    final lowerTitle = title.toLowerCase();
    final lowerDesc = (description ?? '').toLowerCase();
    final lowerCat = categoryPath.toLowerCase();
    final lowerKeywords = keywords.map((keyword) => keyword.toLowerCase()).toList(growable: false);

    var totalScore = 0;

    for (final token in tokens) {
      var tokenScore = 0;
      if (lowerTitle == token) {
        tokenScore = 100;
      } else if (lowerTitle.startsWith(token)) {
        tokenScore = 70;
      } else if (lowerTitle.contains(token)) {
        tokenScore = 50;
      } else if (lowerKeywords.any((keyword) => keyword.contains(token))) {
        tokenScore = 35;
      } else if (lowerCat.contains(token)) {
        tokenScore = 20;
      } else if (lowerDesc.contains(token)) {
        tokenScore = 10;
      }

      if (tokenScore == 0) {
        return 0;
      }

      totalScore += tokenScore;
    }

    return totalScore;
  }
}
