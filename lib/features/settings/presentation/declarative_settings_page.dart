import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/features/settings/presentation/settings_context_builder.dart';
import 'package:yaabsa/features/settings/presentation/settings_entry_renderer.dart';
import 'package:yaabsa/features/settings/registry/settings_registry.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/l10n.dart';

class DeclarativeSettingsPage extends ConsumerWidget {
  const DeclarativeSettingsPage({super.key, required this.pageId, this.focusEntryId, this.focusToken});

  final String pageId;
  final String? focusEntryId;
  final Object? focusToken;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registry = SettingsRegistry.instance;
    final page = registry.findPageById(pageId);
    if (page == null) {
      return SettingsPageScaffold(
        title: context.l10n.navSettings,
        embedded: true,
        showEmbeddedBackButton: true,
        children: const <Widget>[],
      );
    }

    if (page.isCustomPage) {
      return page.customPageBuilder!(context, focusEntryId: focusEntryId);
    }

    return SettingsContextScope(
      builder: (context, ref, settingsContext) {
        final pageAvailability = registry.resolvePageAvailability(page, settingsContext);
        final parentRoute = page.parentId != null ? registry.findPageById(page.parentId!)?.route : null;

        if (page.requiresSignIn && !settingsContext.isSignedIn) {
          return SettingsPageScaffold(
            title: page.title(settingsContext),
            embedded: true,
            showEmbeddedBackButton: true,
            embeddedBackFallbackRoute: parentRoute,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Text(settingsContext.l10n.promptSignInToManageSettings),
              ),
            ],
          );
        }

        if (!pageAvailability.isVisible) {
          return SettingsPageScaffold(
            title: page.title(settingsContext),
            embedded: true,
            showEmbeddedBackButton: true,
            embeddedBackFallbackRoute: parentRoute,
            children: const <Widget>[],
          );
        }

        final visibleSections = <Widget>[];
        for (final section in page.sections) {
          final sectionAvailability = SettingsRegistry.combineAvailability(
            pageAvailability,
            section.availability(settingsContext),
          );
          if (!sectionAvailability.isVisible) {
            continue;
          }

          final entryWidgets = <Widget>[];
          for (final entry in section.entries) {
            final entryAvailability = SettingsRegistry.combineAvailability(
              sectionAvailability,
              entry.availability(settingsContext),
            );
            if (!entryAvailability.isVisible) {
              continue;
            }

            entryWidgets.add(
              SettingsEntryRenderer(
                entry: entry,
                settingsContext: settingsContext,
                availability: entryAvailability,
                focused: focusEntryId != null && entry.id == focusEntryId,
                focusToken: focusToken,
              ),
            );
          }

          if (entryWidgets.isEmpty) {
            continue;
          }

          visibleSections.add(
            SettingsNavigationSection(
              title: section.title(settingsContext),
              showSectionTitle: section.showTitle,
              topPadding: visibleSections.isEmpty ? 0 : 28,
              settings: entryWidgets,
            ),
          );
        }

        return SettingsPageScaffold(
          title: page.title(settingsContext),
          embedded: true,
          showEmbeddedBackButton: true,
          embeddedBackFallbackRoute: parentRoute,
          children: visibleSections,
        );
      },
    );
  }
}
