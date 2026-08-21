import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'magic_config_provider.g.dart';

@Riverpod(keepAlive: true)
class MagicConfigImport extends _$MagicConfigImport {
  @override
  String? build() => null;

  void receive(String value) {
    state = value;
  }

  void clear() {
    state = null;
  }
}
