import 'package:yaabsa/api/library/library_settings.dart';
import 'package:yaabsa/api/search/search_provider_option.dart';
import 'package:yaabsa/components/settings/libraries/library_folder_list_editor.dart';
import 'package:yaabsa/components/settings/libraries/library_metadata_precedence_editor.dart';
import 'package:yaabsa/ui/components/inputs/expressive_dropdown.dart';
import 'package:yaabsa/util/l10n.dart';

const List<String> defaultLibraryMetadataPrecedenceIds = <String>[
  'folderStructure',
  'audioMetatags',
  'nfoFile',
  'txtFiles',
  'opfFile',
  'absMetadata',
];

const List<YaabsaDropdownOption<String>> _bookProviderFallback = <YaabsaDropdownOption<String>>[
  YaabsaDropdownOption<String>(value: 'google', label: 'Google Books'),
  YaabsaDropdownOption<String>(value: 'openlibrary', label: 'Open Library'),
  YaabsaDropdownOption<String>(value: 'itunes', label: 'iTunes'),
  YaabsaDropdownOption<String>(value: 'audible', label: 'Audible'),
  YaabsaDropdownOption<String>(value: 'fantlab', label: 'FantLab'),
];

const List<YaabsaDropdownOption<String>> _podcastProviderFallback = <YaabsaDropdownOption<String>>[
  YaabsaDropdownOption<String>(value: 'itunes', label: 'iTunes'),
];

const List<YaabsaDropdownOption<String>> libraryIconOptions = <YaabsaDropdownOption<String>>[
  YaabsaDropdownOption<String>(value: 'database', label: 'database'),
  YaabsaDropdownOption<String>(value: 'audiobookshelf', label: 'audiobookshelf'),
  YaabsaDropdownOption<String>(value: 'books-1', label: 'books-1'),
  YaabsaDropdownOption<String>(value: 'books-2', label: 'books-2'),
  YaabsaDropdownOption<String>(value: 'book-1', label: 'book-1'),
  YaabsaDropdownOption<String>(value: 'microphone-1', label: 'microphone-1'),
  YaabsaDropdownOption<String>(value: 'microphone-3', label: 'microphone-3'),
  YaabsaDropdownOption<String>(value: 'radio', label: 'radio'),
  YaabsaDropdownOption<String>(value: 'podcast', label: 'podcast'),
  YaabsaDropdownOption<String>(value: 'rss', label: 'rss'),
  YaabsaDropdownOption<String>(value: 'headphones', label: 'headphones'),
  YaabsaDropdownOption<String>(value: 'music', label: 'music'),
  YaabsaDropdownOption<String>(value: 'file-picture', label: 'file-picture'),
  YaabsaDropdownOption<String>(value: 'rocket', label: 'rocket'),
  YaabsaDropdownOption<String>(value: 'power', label: 'power'),
  YaabsaDropdownOption<String>(value: 'star', label: 'star'),
  YaabsaDropdownOption<String>(value: 'heart', label: 'heart'),
];

String defaultProviderForLibraryMediaType(String mediaType) {
  return mediaType == 'podcast' ? 'itunes' : 'google';
}

List<YaabsaDropdownOption<String>> buildLibraryMediaTypeOptions(AppLocalizations l10n) {
  return <YaabsaDropdownOption<String>>[
    YaabsaDropdownOption<String>(value: 'book', label: l10n.mediaTypeAudiobooks),
    YaabsaDropdownOption<String>(value: 'podcast', label: l10n.mediaTypePodcasts),
  ];
}

List<YaabsaDropdownOption<String>> buildPodcastRegionOptions(AppLocalizations l10n) {
  return <YaabsaDropdownOption<String>>[
    YaabsaDropdownOption<String>(value: 'us', label: l10n.countryUnitedStates),
    YaabsaDropdownOption<String>(value: 'gb', label: l10n.countryUnitedKingdom),
    YaabsaDropdownOption<String>(value: 'de', label: l10n.countryGermany),
    YaabsaDropdownOption<String>(value: 'fr', label: l10n.countryFrance),
    YaabsaDropdownOption<String>(value: 'es', label: l10n.countrySpain),
    YaabsaDropdownOption<String>(value: 'it', label: l10n.countryItaly),
    YaabsaDropdownOption<String>(value: 'jp', label: l10n.countryJapan),
    YaabsaDropdownOption<String>(value: 'au', label: l10n.countryAustralia),
    YaabsaDropdownOption<String>(value: 'ca', label: l10n.countryCanada),
  ];
}

List<YaabsaDropdownOption<String>> buildLibraryProviderOptions({
  required List<SearchProviderOption> rawOptions,
  required String mediaType,
  required String selectedProvider,
}) {
  final options = rawOptions
      .where((option) => option.value.trim().isNotEmpty)
      .map(
        (option) => YaabsaDropdownOption<String>(
          value: option.value.trim(),
          label: option.text.trim().isEmpty ? option.value.trim() : option.text.trim(),
        ),
      )
      .toList(growable: false);

  final deduplicated = <String, YaabsaDropdownOption<String>>{for (final option in options) option.value: option};

  final fallback = mediaType == 'podcast' ? _podcastProviderFallback : _bookProviderFallback;
  for (final option in fallback) {
    deduplicated.putIfAbsent(option.value, () => option);
  }

  if (!deduplicated.containsKey(selectedProvider)) {
    deduplicated[selectedProvider] = YaabsaDropdownOption<String>(value: selectedProvider, label: selectedProvider);
  }

  return deduplicated.values.toList(growable: false);
}

List<YaabsaDropdownOption<String>> resolveLibraryIconOptions(String selectedIconName) {
  final options = <String, YaabsaDropdownOption<String>>{for (final option in libraryIconOptions) option.value: option};

  if (!options.containsKey(selectedIconName)) {
    options[selectedIconName] = YaabsaDropdownOption<String>(value: selectedIconName, label: selectedIconName);
  }

  return options.values.toList(growable: false);
}

double? safeLibraryMarkAsFinishedPercent(LibrarySettings settings) {
  try {
    return settings.markAsFinishedPercentComplete;
  } on TypeError {
    return null;
  }
}

String formatLibraryNumericInputValue(num value) {
  final asDouble = value.toDouble();
  if (asDouble == asDouble.truncateToDouble()) {
    return asDouble.toStringAsFixed(0);
  }

  return asDouble.toString();
}

List<LibraryMetadataSourceEntry> buildLibraryMetadataSources(List<String>? precedence) {
  final normalizedPrecedence = (precedence ?? defaultLibraryMetadataPrecedenceIds)
      .where(defaultLibraryMetadataPrecedenceIds.contains)
      .toList(growable: false);

  final displayPrecedence = normalizedPrecedence.reversed.toList(growable: false);

  final entries = <LibraryMetadataSourceEntry>[];
  final includedIds = <String>{};

  for (final sourceId in displayPrecedence) {
    includedIds.add(sourceId);
    entries.add(LibraryMetadataSourceEntry(id: sourceId, label: sourceId, enabled: true));
  }

  for (final sourceId in defaultLibraryMetadataPrecedenceIds) {
    if (includedIds.contains(sourceId)) {
      continue;
    }

    entries.add(LibraryMetadataSourceEntry(id: sourceId, label: sourceId, enabled: false));
  }

  return entries;
}

List<LibraryMetadataSourceEntry> localizeLibraryMetadataSources(
  List<LibraryMetadataSourceEntry> sources,
  AppLocalizations l10n,
) {
  return sources
      .map((source) => source.copyWith(label: _metadataSourceLabel(source.id, l10n) ?? source.label))
      .toList(growable: false);
}

String? _metadataSourceLabel(String sourceId, AppLocalizations l10n) {
  return switch (sourceId) {
    'folderStructure' => l10n.metadataSourceFolderStructure,
    'audioMetatags' => l10n.metadataSourceAudioAndEbookMetadata,
    'nfoFile' => l10n.metadataSourceNfoFile,
    'txtFiles' => l10n.metadataSourceDescriptionFiles,
    'opfFile' => l10n.metadataSourceOpfFile,
    'absMetadata' => l10n.metadataSourceAudiobookshelfFile,
    _ => null,
  };
}

String normalizeLibraryPathForComparison(String rawPath) {
  var normalized = rawPath.trim().replaceAll('\\', '/').replaceAll(RegExp(r'/+'), '/');
  final isWindowsRoot = RegExp(r'^[a-zA-Z]:/$').hasMatch(normalized);
  if (normalized.length > 1 && normalized.endsWith('/') && !isWindowsRoot) {
    normalized = normalized.substring(0, normalized.length - 1);
  }
  return normalized.toLowerCase();
}

bool isNestedLibraryPathPair(String firstPath, String secondPath) {
  return firstPath.startsWith('$secondPath/') || secondPath.startsWith('$firstPath/');
}

String? validateLibraryFolderCandidate({
  required String candidatePath,
  required List<LibraryFolderEditorEntry> existingFolders,
  required AppLocalizations l10n,
}) {
  final normalizedCandidate = normalizeLibraryPathForComparison(candidatePath);

  for (final folder in existingFolders) {
    final normalizedExisting = normalizeLibraryPathForComparison(folder.path);
    if (normalizedCandidate == normalizedExisting) {
      return l10n.errorLibraryFolderPathAlreadyExists;
    }

    if (isNestedLibraryPathPair(normalizedCandidate, normalizedExisting)) {
      return l10n.errorNestedFolderPathsNotAllowed;
    }
  }

  return null;
}

String? validateLibraryName(String rawValue, AppLocalizations l10n) {
  final name = rawValue.trim();
  if (name.isEmpty) {
    return l10n.errorLibraryNameRequired;
  }

  return null;
}

String? validateLibraryFolders(List<LibraryFolderEditorEntry> folders, AppLocalizations l10n) {
  if (folders.isEmpty) {
    return l10n.errorAddAtLeastOneFolderPath;
  }

  final normalizedByPath = <String, String>{};

  for (final folder in folders) {
    final trimmedPath = folder.path.trim();
    if (trimmedPath.isEmpty) {
      return l10n.errorFolderPathsCannotBeEmpty;
    }

    final normalized = normalizeLibraryPathForComparison(trimmedPath);
    if (normalizedByPath.containsKey(normalized)) {
      return l10n.errorDuplicateFolderPathsNotAllowed;
    }

    normalizedByPath[normalized] = trimmedPath;
  }

  final normalizedEntries = normalizedByPath.entries.toList(growable: false);
  for (var index = 0; index < normalizedEntries.length; index++) {
    for (var nestedIndex = index + 1; nestedIndex < normalizedEntries.length; nestedIndex++) {
      if (isNestedLibraryPathPair(normalizedEntries[index].key, normalizedEntries[nestedIndex].key)) {
        return l10n.errorNestedFolderPathsNotAllowed;
      }
    }
  }

  return null;
}

String? validateLibrarySchedule({
  required bool scheduleEnabled,
  required String cronExpression,
  required AppLocalizations l10n,
}) {
  if (!scheduleEnabled) {
    return null;
  }

  if (cronExpression.trim().isEmpty) {
    return l10n.errorCronRequiredWhenLibrarySchedulingEnabled;
  }

  return null;
}

String? validateLibraryMarkAsFinished({
  required String mediaType,
  required String markAsFinishedMode,
  required String rawValue,
  required AppLocalizations l10n,
}) {
  if (mediaType != 'book') {
    return null;
  }

  final trimmedValue = rawValue.trim();
  if (markAsFinishedMode == 'percentComplete') {
    final percentValue = double.tryParse(trimmedValue);
    if (percentValue == null || percentValue < 0 || percentValue > 100) {
      return l10n.errorPercentBetweenZeroAndHundred(0, 100);
    }
    return null;
  }

  final value = int.tryParse(trimmedValue);
  if (value == null || value <= 0) {
    return l10n.errorPositiveWholeNumberRequired;
  }

  return null;
}
