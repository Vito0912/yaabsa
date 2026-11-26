import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_search_state.g.dart';

@Riverpod(keepAlive: true)
class SettingsSearchQuery extends _$SettingsSearchQuery {
  @override
  String build() => '';

  void setQuery(String query) {
    state = query;
  }

  void clear() {
    state = '';
  }
}

@Riverpod(keepAlive: true)
class SettingsLeftPaneScrollOffset extends _$SettingsLeftPaneScrollOffset {
  @override
  double build() => 0.0;

  void setOffset(double value) {
    state = value;
  }
}
