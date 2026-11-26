import 'package:yaabsa/features/settings/model/settings_availability.dart';
import 'package:yaabsa/features/settings/model/settings_spec.dart';
import 'package:yaabsa/features/settings/registry/account_settings_spec.dart';
import 'package:yaabsa/features/settings/registry/player_settings_spec.dart';
import 'package:yaabsa/features/settings/registry/reader_settings_spec.dart';
import 'package:yaabsa/features/settings/registry/server_settings_spec.dart';
import 'package:yaabsa/features/settings/registry/system_settings_spec.dart';

class SettingsRootGroupSpec {
  const SettingsRootGroupSpec({
    required this.id,
    required this.title,
    required this.pageIds,
    this.availability = alwaysAvailable,
  });

  final String id;
  final SettingsTextBuilder title;
  final List<String> pageIds;
  final SettingsAvailabilityRule availability;
}

class SettingsRegistry {
  SettingsRegistry._(this.allPages, this.rootGroups)
    : _pagesById = {for (final page in allPages) page.id: page},
      _pagesByRoute = {
        for (final page in allPages)
          if (page.registerRoute) page.route: page,
      };

  static final SettingsRegistry instance = SettingsRegistry._buildDefault();

  final List<SettingsPageSpec> allPages;
  final List<SettingsRootGroupSpec> rootGroups;
  final Map<String, SettingsPageSpec> _pagesById;
  final Map<String, SettingsPageSpec> _pagesByRoute;

  static SettingsRegistry _buildDefault() {
    final pages = <SettingsPageSpec>[
      ...buildAccountSettingsPages(),
      ...buildServerSettingsPages(),
      ...buildPlayerSettingsPages(),
      ...buildReaderSettingsPages(),
      ...buildSystemSettingsPages(),
    ];

    final groups = <SettingsRootGroupSpec>[
      SettingsRootGroupSpec(
        id: 'account',
        title: (ctx) {
          final username = ctx.currentUser?.username ?? '';
          return ctx.l10n.settingsAccountScopedHeading(username);
        },
        availability: (ctx) {
          if (!ctx.isSignedIn) {
            return const SettingsAvailability.hidden();
          }
          return const SettingsAvailability.available();
        },
        pageIds: const <String>['account.library', 'account.downloads', 'account.car'],
      ),
      SettingsRootGroupSpec(
        id: 'server',
        title: (ctx) => ctx.l10n.fieldServer,
        availability: (ctx) {
          if (!ctx.isSignedIn) {
            return const SettingsAvailability.hidden();
          }
          return const SettingsAvailability.available();
        },
        pageIds: const <String>['server.connection', 'server.actions', 'server.tools', 'server.admin'],
      ),
      SettingsRootGroupSpec(
        id: 'playback_reader',
        title: (ctx) => ctx.l10n.settingsSectionPlaybackAndReader,
        pageIds: const <String>['player', 'reader'],
      ),
      SettingsRootGroupSpec(
        id: 'app_system',
        title: (ctx) => ctx.l10n.settingsSectionAppAndSystem,
        pageIds: const <String>[
          'system.appearance',
          'system.caching',
          'system.backup',
          'system.updates',
          'system.logs',
        ],
      ),
      SettingsRootGroupSpec(
        id: 'about_support',
        title: (ctx) => ctx.l10n.settingsAboutSupport,
        pageIds: const <String>['about', 'about.sponsor'],
      ),
    ];

    return SettingsRegistry._(pages, groups);
  }

  SettingsPageSpec? findPageById(String id) => _pagesById[id];

  SettingsPageSpec? findPageByRoute(String route) => _pagesByRoute[route];

  /// Resolves the effective visibility and enabled state of [page] including ancestor pages.
  SettingsAvailability resolvePageAvailability(SettingsPageSpec page, SettingsContext ctx) {
    if (page.requiresSignIn && !ctx.isSignedIn) {
      return const SettingsAvailability.hidden();
    }

    var current = page.availability(ctx);
    if (!current.isVisible) {
      return current;
    }

    final parentId = page.parentId;
    if (parentId != null) {
      final parent = findPageById(parentId);
      if (parent != null) {
        final parentAvailability = resolvePageAvailability(parent, ctx);
        current = combineAvailability(parentAvailability, current);
      }
    }

    return current;
  }

  /// Combines parent and child availability states.
  static SettingsAvailability combineAvailability(SettingsAvailability parent, SettingsAvailability child) {
    if (parent is SettingsHidden || child is SettingsHidden) {
      return const SettingsAvailability.hidden();
    }
    if (parent is SettingsDisabled) {
      return parent;
    }
    if (child is SettingsDisabled) {
      return child;
    }
    return const SettingsAvailability.available();
  }

  /// Returns the top-level ancestor page ID for [pageId].
  String rootPageIdFor(String pageId) {
    var current = findPageById(pageId);
    while (current?.parentId != null) {
      final parent = findPageById(current!.parentId!);
      if (parent == null) {
        break;
      }
      current = parent;
    }

    return current?.id ?? pageId;
  }

  /// Returns the first visible root page ID for the current [ctx].
  String defaultRootPageId(SettingsContext ctx) {
    for (final group in rootGroups) {
      if (!group.availability(ctx).isVisible) {
        continue;
      }

      for (final pageId in group.pageIds) {
        final page = findPageById(pageId);
        if (page == null || !page.registerRoute) {
          continue;
        }
        if (resolvePageAvailability(page, ctx).isVisible) {
          return page.id;
        }
      }
    }

    return 'player';
  }

  /// Builds a human-readable breadcrumb path for [pageId] (for example, `Settings › Player › Smart rewind`).
  String breadcrumbForPage(String pageId, SettingsContext ctx, {bool includeRoot = true}) {
    final chain = <String>[];
    var current = findPageById(pageId);

    while (current != null) {
      chain.add(current.title(ctx));
      current = current.parentId != null ? findPageById(current.parentId!) : null;
    }

    final ordered = chain.reversed.toList();
    if (includeRoot) {
      ordered.insert(0, ctx.l10n.navSettings);
    }

    return ordered.join(' › ');
  }
}
