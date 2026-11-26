import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/common/desktop_page_shortcuts.dart';
import 'package:yaabsa/features/settings/model/settings_availability.dart';
import 'package:yaabsa/features/settings/model/settings_spec.dart';
import 'package:yaabsa/features/settings/presentation/declarative_settings_page.dart';
import 'package:yaabsa/features/settings/presentation/settings_account_header.dart';
import 'package:yaabsa/features/settings/presentation/settings_context_builder.dart';
import 'package:yaabsa/features/settings/presentation/settings_pane_scope.dart';
import 'package:yaabsa/features/settings/presentation/settings_search_results_view.dart';
import 'package:yaabsa/features/settings/presentation/settings_shell_sections.dart';
import 'package:yaabsa/features/settings/registry/settings_registry.dart';
import 'package:yaabsa/features/settings/registry/settings_routes.dart';
import 'package:yaabsa/features/settings/search/settings_search_engine.dart';
import 'package:yaabsa/features/settings/search/settings_search_state.dart';
import 'package:yaabsa/ui/components/inputs/search_field.dart';
import 'package:yaabsa/util/l10n.dart';

class SettingsShell extends ConsumerStatefulWidget {
  const SettingsShell({super.key, this.initialPageId, this.focusEntryId, this.focusToken, this.detailChild});

  final String? initialPageId;
  final String? focusEntryId;
  final Object? focusToken;
  final Widget? detailChild;

  @override
  ConsumerState<SettingsShell> createState() => _SettingsShellState();
}

class _SettingsShellState extends ConsumerState<SettingsShell> {
  static const double _twoPaneBreakpoint = 900.0;

  late final TextEditingController _searchController;
  late final ScrollController _leftScrollController;
  final FocusNode _searchFocusNode = FocusNode(debugLabel: 'settings-search');

  String? _optimisticPageId;
  int _navigationSerial = 0;
  bool _isSwitchingDetail = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: ref.read(settingsSearchQueryProvider));
    _leftScrollController = ScrollController(initialScrollOffset: ref.read(settingsLeftPaneScrollOffsetProvider));
    _leftScrollController.addListener(_onLeftPaneScroll);
  }

  @override
  void didUpdateWidget(covariant SettingsShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialPageId != oldWidget.initialPageId ||
        (_optimisticPageId != null && widget.initialPageId == _optimisticPageId)) {
      _optimisticPageId = null;
      _isSwitchingDetail = false;
    }
  }

  @override
  void dispose() {
    _leftScrollController.removeListener(_onLeftPaneScroll);
    _leftScrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onLeftPaneScroll() {
    if (_leftScrollController.positions.length != 1) {
      return;
    }

    ref.read(settingsLeftPaneScrollOffsetProvider.notifier).setOffset(_leftScrollController.offset);
  }

  void _selectTwoPanePage(String targetPageId, String targetRoute) {
    if (targetPageId == widget.initialPageId) {
      _navigationSerial++;
      if (_optimisticPageId != null || _isSwitchingDetail) {
        setState(() {
          _optimisticPageId = null;
          _isSwitchingDetail = false;
        });
      }
      context.go(targetRoute);
      return;
    }

    final serial = ++_navigationSerial;
    setState(() {
      _optimisticPageId = targetPageId;
      _isSwitchingDetail = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || serial != _navigationSerial) {
        return;
      }

      context.go(targetRoute);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || serial != _navigationSerial || !_isSwitchingDetail) {
          return;
        }

        setState(() {
          _optimisticPageId = null;
          _isSwitchingDetail = false;
        });
      });
    });
  }

  void _focusSearchField() {
    _searchFocusNode.requestFocus();
    _searchController.selection = TextSelection(baseOffset: 0, extentOffset: _searchController.text.length);
  }

  bool _dismissSearchField() {
    if (!_searchFocusNode.hasFocus) {
      return false;
    }

    _searchController.clear();
    ref.read(settingsSearchQueryProvider.notifier).clear();
    _searchFocusNode.unfocus();
    return true;
  }

  Widget _buildSearchField(BuildContext context) {
    return YaabsaSearchField(
      controller: _searchController,
      focusNode: _searchFocusNode,
      hintText: context.l10n.settingsSearchHint,
      onChanged: (value) {
        ref.read(settingsSearchQueryProvider.notifier).setQuery(value);
      },
      onClear: () {
        _searchController.clear();
        ref.read(settingsSearchQueryProvider.notifier).clear();
      },
    );
  }

  void _openRootPage(BuildContext context, SettingsPageSpec page, {required bool isTwoPane}) {
    final externalTap = page.onExternalTap;
    if (externalTap != null) {
      unawaited(Future<void>.value(externalTap(context)));
      return;
    }

    if (!page.registerRoute) {
      context.push(page.route);
      return;
    }

    if (isTwoPane) {
      _selectTwoPanePage(page.id, page.route);
      return;
    }

    context.push(page.route);
  }

  void _openSearchResult(BuildContext context, SettingsSearchResult result, {required bool isTwoPane}) {
    final override = result.onTapOverride;
    if (override != null) {
      unawaited(Future<void>.value(override(context, ref)));
      return;
    }

    if (!result.registerRoute) {
      context.push(result.route);
      return;
    }

    final targetUri = Uri(
      path: result.route,
      queryParameters: <String, String>{
        'focus': result.entryId,
        if (isTwoPane) 't': DateTime.now().microsecondsSinceEpoch.toString(),
      },
    ).toString();

    if (isTwoPane) {
      _selectTwoPanePage(result.pageId, targetUri);
      return;
    }

    context.push(targetUri);
  }

  Widget _buildSinglePaneRoot(
    BuildContext context,
    SettingsRegistry registry,
    SettingsContext settingsContext,
    String query,
  ) {
    final trimmedQuery = query.trim();
    final isSearching = trimmedQuery.isNotEmpty;
    final results = isSearching
        ? SettingsSearchEngine.search(registry: registry, ctx: settingsContext, rawQuery: trimmedQuery)
        : const <SettingsSearchResult>[];

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Center(
            child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 700), child: _buildSearchField(context)),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: isSearching
                      ? SettingsSearchResultsView(
                          query: trimmedQuery,
                          results: results,
                          onResultSelected: (result) => _openSearchResult(context, result, isTwoPane: false),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SettingsAccountHeader(compact: false),
                            ...buildSinglePaneRootSections(
                              registry: registry,
                              settingsContext: settingsContext,
                              onOpenPage: (page) => _openRootPage(context, page, isTwoPane: false),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return DesktopPageShortcuts(onSearch: _focusSearchField, onDismiss: _dismissSearchField, child: content);
  }

  Widget _buildTwoPaneShell(
    BuildContext context,
    SettingsRegistry registry,
    SettingsContext settingsContext,
    String query, {
    required double leftPaneWidth,
  }) {
    final currentRoutePageId = widget.initialPageId ?? registry.defaultRootPageId(settingsContext);
    final activePageId = _optimisticPageId ?? currentRoutePageId;
    final activePage = registry.findPageById(activePageId);
    final activeRootPageId = registry.rootPageIdFor(activePageId);
    final isSubpage = activePage?.parentId != null;
    final parentPage = isSubpage ? registry.findPageById(activePage!.parentId!) : null;
    final breadcrumbText = isSubpage
        ? registry.breadcrumbForPage(activePage!.id, settingsContext, includeRoot: false)
        : null;

    final detailWidget =
        widget.detailChild ??
        DeclarativeSettingsPage(
          pageId: currentRoutePageId,
          focusEntryId: widget.focusEntryId,
          focusToken: widget.focusToken,
        );

    final trimmedQuery = query.trim();
    final isSearching = trimmedQuery.isNotEmpty;
    final results = isSearching
        ? SettingsSearchEngine.search(registry: registry, ctx: settingsContext, rawQuery: trimmedQuery)
        : const <SettingsSearchResult>[];

    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: leftPaneWidth,
          child: Material(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(padding: const EdgeInsets.fromLTRB(12, 12, 12, 8), child: _buildSearchField(context)),
                Expanded(
                  child: ListView(
                    controller: _leftScrollController,
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
                    children: [
                      const SettingsAccountHeader(compact: true),
                      const SizedBox(height: 8),
                      if (isSearching)
                        SettingsSearchResultsView(
                          compact: true,
                          query: trimmedQuery,
                          results: results,
                          onResultSelected: (result) => _openSearchResult(context, result, isTwoPane: true),
                        )
                      else
                        ...buildTwoPaneRootGroups(
                          registry: registry,
                          settingsContext: settingsContext,
                          activeRootPageId: activeRootPageId,
                          onOpenPage: (page) => _openRootPage(context, page, isTwoPane: true),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: SettingsPaneScope(
            isTwoPane: true,
            isSubpage: isSubpage,
            breadcrumbText: breadcrumbText,
            onNavigateBack: isSubpage
                ? () {
                    if (parentPage != null) {
                      _selectTwoPanePage(parentPage.id, parentPage.route);
                      return;
                    }

                    if (context.canPop()) {
                      context.pop();
                      return;
                    }

                    context.go(SettingsRoutes.root);
                  }
                : null,
            onOpenRoute: (route) {
              final targetPage = registry.findPageByRoute(route);
              if (targetPage == null || !targetPage.registerRoute) {
                context.push(route);
                return;
              }

              _selectTwoPanePage(targetPage.id, route);
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                detailWidget,
                if (_isSwitchingDetail)
                  Positioned.fill(
                    child: Material(color: Theme.of(context).scaffoldBackgroundColor, child: const SizedBox.expand()),
                  ),
              ],
            ),
          ),
        ),
      ],
    );

    return DesktopPageShortcuts(onSearch: _focusSearchField, onDismiss: _dismissSearchField, child: content);
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(settingsSearchQueryProvider);
    ref.listen<String>(settingsSearchQueryProvider, (previous, next) {
      if (_searchController.text != next) {
        _searchController.value = TextEditingValue(
          text: next,
          selection: TextSelection.collapsed(offset: next.length),
        );
      }
    });

    final registry = SettingsRegistry.instance;

    return SettingsContextScope(
      builder: (context, ref, settingsContext) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final isTwoPane = !settingsContext.isAaos && constraints.maxWidth >= _twoPaneBreakpoint;

            if (!isTwoPane) {
              if (widget.detailChild != null || widget.initialPageId != null) {
                final canPop = GoRouter.of(context).canPop();
                return SettingsPaneScope(
                  isTwoPane: false,
                  isSubpage: true,
                  onNavigateBack: canPop
                      ? () {
                          if (context.canPop()) {
                            context.pop();
                          }
                        }
                      : null,
                  child:
                      widget.detailChild ??
                      DeclarativeSettingsPage(
                        pageId: widget.initialPageId!,
                        focusEntryId: widget.focusEntryId,
                        focusToken: widget.focusToken,
                      ),
                );
              }

              return _buildSinglePaneRoot(context, registry, settingsContext, query);
            }

            final leftPaneWidth = (constraints.maxWidth * 0.28).clamp(320.0, 380.0).toDouble();
            return _buildTwoPaneShell(context, registry, settingsContext, query, leftPaneWidth: leftPaneWidth);
          },
        );
      },
    );
  }
}
