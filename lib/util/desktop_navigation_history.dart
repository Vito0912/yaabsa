import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class DesktopNavigationHistory {
  final List<RouteMatchList> _entries = [];
  final List<_DesktopNavigationObserver> _observers = [];
  GoRouter? _router;
  int _index = -1;
  int? _restoringIndex;
  int _revision = 0;
  bool _busy = false;

  bool get hasOverlay => _observers.any((observer) => observer.hasOverlay);
  bool get canDismissOverlay => _observers.any((observer) => observer.canDismissOverlay);

  Future<void> dismissOverlay() async {
    final router = _router;
    if (router == null || _busy || !canDismissOverlay) return;
    _busy = true;
    try {
      await router.routerDelegate.popRoute();
    } finally {
      _busy = false;
    }
  }

  NavigatorObserver createObserver() {
    final observer = _DesktopNavigationObserver();
    _observers.add(observer);
    return observer;
  }

  void attach(GoRouter router) {
    _router = router;
    router.routerDelegate.addListener(_recordNavigation);
    _recordNavigation();
  }

  void detach() {
    _router?.routerDelegate.removeListener(_recordNavigation);
    _router = null;
    clear();
  }

  void clear() {
    _revision++;
    _entries.clear();
    _index = -1;
    _restoringIndex = null;
  }

  Future<void> back() async {
    final router = _router;
    if (router == null || _busy || router.routerDelegate.currentConfiguration.isEmpty) return;
    _busy = true;
    final revision = _revision;
    try {
      final handled = await router.routerDelegate.popRoute();
      if (!handled && revision == _revision && _index > 0) {
        await _restore(_index - 1);
      }
    } finally {
      _busy = false;
    }
  }

  Future<void> forward() async {
    if (_router == null || _busy || _index < 0 || _index + 1 >= _entries.length) return;
    if (_observers.any((observer) => observer.blocksHistoryNavigation)) return;
    _busy = true;
    try {
      await _restore(_index + 1);
    } finally {
      _busy = false;
    }
  }

  Future<void> _restore(int index) async {
    final router = _router!;
    final context = router.routerDelegate.navigatorKey.currentContext;
    if (context == null) return;
    final revision = _revision;
    final target = _renewCompletedRoutes(_entries[index]);
    _restoringIndex = index;
    try {
      final configuration = await router.routeInformationParser.parseRouteInformationWithDependencies(
        RouteInformation(
          uri: target.uri,
          state: RouteInformationState.restore(base: target),
        ),
        context,
      );
      if (revision != _revision || _router != router) return;
      await router.routerDelegate.setNewRoutePath(configuration);
      if (revision != _revision || _router != router) return;
      router.restore(router.routerDelegate.currentConfiguration);
    } finally {
      _restoringIndex = null;
    }
  }

  void _recordNavigation() {
    final current = _router!.routerDelegate.currentConfiguration;
    if (current.isEmpty || current.isError) return;
    final location = current.last is ImperativeRouteMatch
        ? (current.last as ImperativeRouteMatch).matches.uri
        : current.uri;
    if (location.path == '/boot' || location.path == '/add-user') {
      clear();
      return;
    }

    final restoringIndex = _restoringIndex;
    if (restoringIndex != null && _sameConfiguration(current, _entries[restoringIndex])) {
      _index = restoringIndex;
      _entries[_index] = current;
      return;
    }
    if (_index >= 0) {
      final previous = _entries[_index];
      if (_sameConfiguration(current, previous)) {
        _entries[_index] = current;
        return;
      }
      _revision++;
      _restoringIndex = null;
      if (_sameConfiguration(current, previous.remove(previous.last))) {
        for (var index = _index - 1; index >= 0; index--) {
          if (_sameConfiguration(current, _entries[index])) {
            _index = index;
            _entries[_index] = current;
            return;
          }
        }
        _entries.insert(_index, current);
        _trimHistory();
        return;
      }
    }

    _entries.removeRange(_index + 1, _entries.length);
    _entries.add(current);
    _index = _entries.length - 1;
    _trimHistory();
  }

  void _trimHistory() {
    if (_entries.length > 100) {
      if (_index > 0) {
        _entries.removeAt(0);
        _index--;
      } else {
        _entries.removeLast();
      }
    }
  }

  bool _sameConfiguration(RouteMatchList first, RouteMatchList second) {
    return first.uri == second.uri && first.extra == second.extra && _sameMatches(first.matches, second.matches);
  }

  bool _sameMatches(List<RouteMatchBase> first, List<RouteMatchBase> second) {
    if (first.length != second.length) return false;
    for (var index = 0; index < first.length; index++) {
      final a = first[index];
      final b = second[index];
      if (a.runtimeType != b.runtimeType || a.route != b.route || a.pageKey != b.pageKey) return false;
      if (a is ShellRouteMatch && b is ShellRouteMatch) {
        if (!_sameMatches(a.matches, b.matches)) return false;
      } else if (a is ImperativeRouteMatch && b is ImperativeRouteMatch) {
        if (!_sameConfiguration(a.matches, b.matches)) return false;
      } else if (a != b) {
        return false;
      }
    }
    return true;
  }

  RouteMatchList _renewCompletedRoutes(RouteMatchList configuration) {
    return RouteMatchList(
      matches: configuration.matches.map(_renewMatch).toList(growable: false),
      uri: configuration.uri,
      pathParameters: configuration.pathParameters,
      extra: configuration.extra,
      error: configuration.error,
    );
  }

  RouteMatchBase _renewMatch(RouteMatchBase match) {
    if (match is ShellRouteMatch) {
      return ShellRouteMatch(
        route: match.route,
        matchedLocation: match.matchedLocation,
        pageKey: match.pageKey,
        navigatorKey: match.navigatorKey,
        matches: match.matches.map(_renewMatch).toList(growable: false),
      );
    }
    if (match is ImperativeRouteMatch) {
      return ImperativeRouteMatch(
        pageKey: match.pageKey,
        matches: _renewCompletedRoutes(match.matches),
        completer: match.completer.isCompleted ? Completer<Object?>() : match.completer,
      );
    }
    return match;
  }
}

class _DesktopNavigationObserver extends NavigatorObserver {
  Route<dynamic>? _topRoute;

  bool get _isActive {
    var currentNavigator = navigator;
    if (currentNavigator == null || _topRoute?.isCurrent != true) return false;
    while (currentNavigator != null) {
      final parentRoute = ModalRoute.of(currentNavigator.context);
      if (parentRoute != null && !parentRoute.isCurrent) return false;
      currentNavigator = currentNavigator.context.findAncestorStateOfType<NavigatorState>();
    }
    return true;
  }

  bool get hasOverlay {
    final route = _topRoute;
    return _isActive && route != null && route.isCurrent && (route is PopupRoute || route.willHandlePopInternally);
  }

  bool get canDismissOverlay {
    final route = _topRoute;
    return hasOverlay && (route is! PopupRoute || route.barrierDismissible);
  }

  bool get blocksHistoryNavigation {
    final route = _topRoute;
    if (!_isActive || route == null) return false;
    return route.settings is! Page ||
        route.willHandlePopInternally ||
        route.popDisposition == RoutePopDisposition.doNotPop;
  }

  @override
  void didChangeTop(Route<dynamic> topRoute, Route<dynamic>? previousTopRoute) {
    _topRoute = topRoute;
  }
}
