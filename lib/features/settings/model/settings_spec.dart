import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/settings/model/setting_definition.dart';
import 'package:yaabsa/features/settings/model/settings_availability.dart';
import 'package:yaabsa/util/l10n.dart';

typedef SettingsTextBuilder = String Function(SettingsContext ctx);
typedef SettingsOptionalTextBuilder = String? Function(SettingsContext ctx);
typedef SettingsKeywordsBuilder = List<String> Function(AppLocalizations l10n);

enum SettingsChoicePresentationMode { auto, segmented, inlineRadio, dialog, searchableDialog }

class SettingsChoiceOption<T> {
  const SettingsChoiceOption({required this.value, required this.label, this.description, this.icon});

  final T value;
  final String label;
  final String? description;
  final IconData? icon;
}

class SettingsPageSpec {
  const SettingsPageSpec({
    required this.id,
    required this.route,
    required this.scope,
    required this.icon,
    required this.title,
    this.subtitle,
    this.parentId,
    this.availability = alwaysAvailable,
    this.sections = const <SettingsSectionSpec>[],
    this.customPageBuilder,
    this.searchableMetadata = const <SettingsSearchMetadata>[],
    this.requiresSignIn = false,
    this.registerRoute = true,
    this.onExternalTap,
  });

  final String id;
  final String route;
  final SettingScope scope;
  final IconData icon;
  final SettingsTextBuilder title;
  final SettingsOptionalTextBuilder? subtitle;
  final String? parentId;
  final SettingsAvailabilityRule availability;
  final List<SettingsSectionSpec> sections;
  final Widget Function(BuildContext context, {String? focusEntryId})? customPageBuilder;
  final List<SettingsSearchMetadata> searchableMetadata;
  final bool requiresSignIn;
  final bool registerRoute;
  final FutureOr<void> Function(BuildContext context)? onExternalTap;

  bool get isCustomPage => customPageBuilder != null;
}

class SettingsSearchMetadata {
  const SettingsSearchMetadata({
    required this.id,
    required this.title,
    this.description,
    this.keywords,
    this.scopeOverride,
    this.availability = alwaysAvailable,
  });

  final String id;
  final SettingsTextBuilder title;
  final SettingsOptionalTextBuilder? description;
  final SettingsKeywordsBuilder? keywords;
  final SettingScope? scopeOverride;
  final SettingsAvailabilityRule availability;
}

class SettingsSectionSpec {
  const SettingsSectionSpec({
    required this.id,
    required this.title,
    required this.entries,
    this.showTitle = true,
    this.availability = alwaysAvailable,
  });

  final String id;
  final SettingsTextBuilder title;
  final List<SettingsEntrySpec> entries;
  final bool showTitle;
  final SettingsAvailabilityRule availability;
}

sealed class SettingsEntrySpec {
  const SettingsEntrySpec({
    required this.id,
    required this.title,
    this.description,
    this.keywords,
    this.icon,
    this.tooltip,
    this.scopeOverride,
    this.availability = alwaysAvailable,
    this.searchable = true,
  });

  final String id;
  final SettingsTextBuilder title;
  final SettingsOptionalTextBuilder? description;
  final SettingsKeywordsBuilder? keywords;
  final IconData? icon;
  final SettingsOptionalTextBuilder? tooltip;
  final SettingScope? scopeOverride;
  final SettingsAvailabilityRule availability;
  final bool searchable;
}

final class SettingsNavEntry extends SettingsEntrySpec {
  const SettingsNavEntry({
    required super.id,
    required super.title,
    required this.targetRoute,
    this.targetPageId,
    super.description,
    super.keywords,
    required IconData icon,
    super.scopeOverride,
    super.availability,
    super.searchable,
    this.onTapOverride,
  }) : super(icon: icon);

  final String targetRoute;
  final String? targetPageId;
  final FutureOr<void> Function(BuildContext context, WidgetRef ref)? onTapOverride;
}

final class SettingsToggleEntry extends SettingsEntrySpec {
  const SettingsToggleEntry({
    required super.id,
    required super.title,
    required this.definition,
    super.description,
    super.keywords,
    super.icon,
    super.tooltip,
    super.scopeOverride,
    super.availability,
    super.searchable,
    this.onBeforeChanged,
    this.onChanged,
  });

  final SettingDefinition<bool> definition;
  final FutureOr<bool> Function(BuildContext context, bool nextValue)? onBeforeChanged;
  final FutureOr<void> Function(WidgetRef ref, bool nextValue)? onChanged;
}

final class SettingsChoiceEntry<T> extends SettingsEntrySpec {
  const SettingsChoiceEntry({
    required super.id,
    required super.title,
    required this.definition,
    required this.optionsBuilder,
    this.presentation = SettingsChoicePresentationMode.auto,
    super.description,
    super.keywords,
    super.icon,
    super.tooltip,
    super.scopeOverride,
    super.availability,
    super.searchable,
    this.valueResolver,
    this.onValueSelected,
    this.onChanged,
  });

  final SettingDefinition<T> definition;
  final List<SettingsChoiceOption<T>> Function(SettingsContext ctx) optionsBuilder;
  final SettingsChoicePresentationMode presentation;
  final T Function(SettingsContext ctx)? valueResolver;
  final FutureOr<void> Function(BuildContext context, WidgetRef ref, T nextValue)? onValueSelected;
  final FutureOr<void> Function(WidgetRef ref, T nextValue)? onChanged;

  /// Invokes [visitor] with the concrete value type [T].
  R accept<R>(R Function<V>(SettingsChoiceEntry<V> entry) visitor) {
    return visitor<T>(this);
  }
}

final class SettingsSliderEntry<T> extends SettingsEntrySpec {
  const SettingsSliderEntry({
    required super.id,
    required super.title,
    required this.definition,
    required this.values,
    required this.labelForValue,
    super.description,
    super.keywords,
    super.icon,
    super.tooltip,
    super.scopeOverride,
    super.availability,
    super.searchable,
    this.onChanged,
  });

  final SettingDefinition<T> definition;
  final List<T> values;
  final String Function(SettingsContext ctx, T value) labelForValue;
  final FutureOr<void> Function(WidgetRef ref, T nextValue)? onChanged;

  /// Invokes [visitor] with the concrete value type [T].
  R accept<R>(R Function<V>(SettingsSliderEntry<V> entry) visitor) {
    return visitor<T>(this);
  }
}

final class SettingsNumberEntry extends SettingsEntrySpec {
  const SettingsNumberEntry({
    required super.id,
    required super.title,
    required this.definition,
    required this.min,
    required this.max,
    this.unitLabel,
    this.fallbackBuilder,
    super.description,
    super.keywords,
    super.icon,
    super.tooltip,
    super.scopeOverride,
    super.availability,
    super.searchable,
  });

  final SettingDefinition<int> definition;
  final int min;
  final int max;
  final SettingsOptionalTextBuilder? unitLabel;
  final int Function(SettingsContext ctx)? fallbackBuilder;
}

final class SettingsTimeOfDayEntry extends SettingsEntrySpec {
  const SettingsTimeOfDayEntry({
    required super.id,
    required super.title,
    required this.definition,
    super.description,
    super.keywords,
    super.icon,
    super.tooltip,
    super.scopeOverride,
    super.availability,
    super.searchable,
  });

  final SettingDefinition<int> definition;
}

final class SettingsActionEntry extends SettingsEntrySpec {
  const SettingsActionEntry({
    required super.id,
    required super.title,
    required this.buttonLabel,
    required this.onPressed,
    this.buttonIcon,
    this.isDestructive = false,
    super.description,
    super.keywords,
    super.icon,
    super.tooltip,
    super.scopeOverride,
    super.availability,
    super.searchable,
  });

  final SettingsTextBuilder buttonLabel;
  final IconData? buttonIcon;
  final bool isDestructive;
  final FutureOr<void> Function(BuildContext context, WidgetRef ref) onPressed;
}

final class SettingsCustomEntry extends SettingsEntrySpec {
  const SettingsCustomEntry({
    required super.id,
    required super.title,
    required this.builder,
    super.description,
    super.keywords,
    super.icon,
    super.scopeOverride,
    super.availability,
    super.searchable,
  });

  final Widget Function(BuildContext context, WidgetRef ref, SettingsContext settingsContext) builder;
}
