import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/database/settings_manager.dart';

enum SettingScope { app, account, server }

class SettingDefinition<T> {
  const SettingDefinition({
    required this.key,
    required this.scope,
    required this.defaultValue,
    this.decode,
    this.encode,
  });

  final String key;
  final SettingScope scope;
  final T defaultValue;
  final T Function(String raw)? decode;
  final String Function(T value)? encode;

  /// Decodes [rawValue] using [decode] or [SettingsParser], falling back to [defaultValue].
  T decodeRaw(String? rawValue) {
    if (rawValue == null) {
      return defaultValue;
    }

    if (decode != null) {
      try {
        return decode!(rawValue);
      } catch (_) {
        return defaultValue;
      }
    }

    return SettingsParser.decodeValue<T>(rawValue, defaultValue);
  }

  /// Encodes [value] for string persistence in [SettingsManager].
  String encodeValue(T value) {
    if (encode != null) {
      return encode!(value);
    }

    return SettingsParser.encodeValue<T>(value);
  }
}

/// Reads the current typed setting value once without subscribing to updates.
T readSettingDefinition<T>(WidgetRef ref, SettingDefinition<T> definition, {String? userId}) {
  final cache = ref.read(settingsCacheProvider);

  if (definition.scope == SettingScope.account) {
    if (userId == null) {
      return definition.defaultValue;
    }

    final rawValue = cache.get<String>(userId, definition.key);
    return definition.decodeRaw(rawValue);
  }

  final rawValue = cache.get<String>(definition.key);
  return definition.decodeRaw(rawValue);
}

/// Watches the typed setting value from the cache-backed settings providers.
T watchSettingDefinition<T>(WidgetRef ref, SettingDefinition<T> definition, {String? userId}) {
  if (definition.scope == SettingScope.account) {
    if (userId == null) {
      return definition.defaultValue;
    }

    final rawValue = ref.watch(userSettingValueProvider(userId, definition.key));
    return definition.decodeRaw(rawValue);
  }

  final rawValue = ref.watch(globalSettingValueProvider(definition.key));
  return definition.decodeRaw(rawValue);
}

/// Persists [value] for [definition] to either user or global settings storage.
Future<void> writeSettingDefinition<T>(
  WidgetRef ref,
  SettingDefinition<T> definition,
  T value, {
  String? userId,
}) async {
  final manager = ref.read(settingsManagerProvider.notifier);

  if (definition.scope == SettingScope.account) {
    if (userId == null) {
      return;
    }

    if (definition.encode != null) {
      await manager.setUserSetting<String>(userId, definition.key, definition.encodeValue(value));
      return;
    }

    await manager.setUserSetting<T>(userId, definition.key, value);
    return;
  }

  if (definition.encode != null) {
    await manager.setGlobalSetting<String>(definition.key, definition.encodeValue(value));
    return;
  }

  await manager.setGlobalSetting<T>(definition.key, value);
}
