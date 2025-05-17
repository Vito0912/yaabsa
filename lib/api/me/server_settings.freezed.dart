// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ServerSettings {

@JsonKey(name: "id") String get id;@JsonKey(name: "scannerFindCovers") bool? get scannerFindCovers;@JsonKey(name: "scannerCoverProvider") String? get scannerCoverProvider;@JsonKey(name: "scannerParseSubtitle") bool? get scannerParseSubtitle;@JsonKey(name: "scannerPreferMatchedMetadata") bool? get scannerPreferMatchedMetadata;@JsonKey(name: "scannerDisableWatcher") bool? get scannerDisableWatcher;@JsonKey(name: "storeCoverWithItem") bool? get storeCoverWithItem;@JsonKey(name: "storeMetadataWithItem") bool? get storeMetadataWithItem;@JsonKey(name: "metadataFileFormat") String? get metadataFileFormat;@JsonKey(name: "rateLimitLoginRequests") int? get rateLimitLoginRequests;@JsonKey(name: "rateLimitLoginWindow") int? get rateLimitLoginWindow;@JsonKey(name: "backupSchedule") dynamic get backupSchedule;@JsonKey(name: "backupsToKeep") int? get backupsToKeep;@JsonKey(name: "maxBackupSize") int? get maxBackupSize;@JsonKey(name: "loggerDailyLogsToKeep") int? get loggerDailyLogsToKeep;@JsonKey(name: "loggerScannerLogsToKeep") int? get loggerScannerLogsToKeep;@JsonKey(name: "homeBookshelfView") int? get homeBookshelfView;@JsonKey(name: "bookshelfView") int? get bookshelfView;@JsonKey(name: "sortingIgnorePrefix") bool? get sortingIgnorePrefix;@JsonKey(name: "sortingPrefixes") List<String>? get sortingPrefixes;@JsonKey(name: "chromecastEnabled") bool? get chromecastEnabled;@JsonKey(name: "dateFormat") String? get dateFormat;@JsonKey(name: "language") String? get language;@JsonKey(name: "logLevel") int? get logLevel;@JsonKey(name: "version") String? get version;
/// Create a copy of ServerSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerSettingsCopyWith<ServerSettings> get copyWith => _$ServerSettingsCopyWithImpl<ServerSettings>(this as ServerSettings, _$identity);

  /// Serializes this ServerSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerSettings&&(identical(other.id, id) || other.id == id)&&(identical(other.scannerFindCovers, scannerFindCovers) || other.scannerFindCovers == scannerFindCovers)&&(identical(other.scannerCoverProvider, scannerCoverProvider) || other.scannerCoverProvider == scannerCoverProvider)&&(identical(other.scannerParseSubtitle, scannerParseSubtitle) || other.scannerParseSubtitle == scannerParseSubtitle)&&(identical(other.scannerPreferMatchedMetadata, scannerPreferMatchedMetadata) || other.scannerPreferMatchedMetadata == scannerPreferMatchedMetadata)&&(identical(other.scannerDisableWatcher, scannerDisableWatcher) || other.scannerDisableWatcher == scannerDisableWatcher)&&(identical(other.storeCoverWithItem, storeCoverWithItem) || other.storeCoverWithItem == storeCoverWithItem)&&(identical(other.storeMetadataWithItem, storeMetadataWithItem) || other.storeMetadataWithItem == storeMetadataWithItem)&&(identical(other.metadataFileFormat, metadataFileFormat) || other.metadataFileFormat == metadataFileFormat)&&(identical(other.rateLimitLoginRequests, rateLimitLoginRequests) || other.rateLimitLoginRequests == rateLimitLoginRequests)&&(identical(other.rateLimitLoginWindow, rateLimitLoginWindow) || other.rateLimitLoginWindow == rateLimitLoginWindow)&&const DeepCollectionEquality().equals(other.backupSchedule, backupSchedule)&&(identical(other.backupsToKeep, backupsToKeep) || other.backupsToKeep == backupsToKeep)&&(identical(other.maxBackupSize, maxBackupSize) || other.maxBackupSize == maxBackupSize)&&(identical(other.loggerDailyLogsToKeep, loggerDailyLogsToKeep) || other.loggerDailyLogsToKeep == loggerDailyLogsToKeep)&&(identical(other.loggerScannerLogsToKeep, loggerScannerLogsToKeep) || other.loggerScannerLogsToKeep == loggerScannerLogsToKeep)&&(identical(other.homeBookshelfView, homeBookshelfView) || other.homeBookshelfView == homeBookshelfView)&&(identical(other.bookshelfView, bookshelfView) || other.bookshelfView == bookshelfView)&&(identical(other.sortingIgnorePrefix, sortingIgnorePrefix) || other.sortingIgnorePrefix == sortingIgnorePrefix)&&const DeepCollectionEquality().equals(other.sortingPrefixes, sortingPrefixes)&&(identical(other.chromecastEnabled, chromecastEnabled) || other.chromecastEnabled == chromecastEnabled)&&(identical(other.dateFormat, dateFormat) || other.dateFormat == dateFormat)&&(identical(other.language, language) || other.language == language)&&(identical(other.logLevel, logLevel) || other.logLevel == logLevel)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,scannerFindCovers,scannerCoverProvider,scannerParseSubtitle,scannerPreferMatchedMetadata,scannerDisableWatcher,storeCoverWithItem,storeMetadataWithItem,metadataFileFormat,rateLimitLoginRequests,rateLimitLoginWindow,const DeepCollectionEquality().hash(backupSchedule),backupsToKeep,maxBackupSize,loggerDailyLogsToKeep,loggerScannerLogsToKeep,homeBookshelfView,bookshelfView,sortingIgnorePrefix,const DeepCollectionEquality().hash(sortingPrefixes),chromecastEnabled,dateFormat,language,logLevel,version]);

@override
String toString() {
  return 'ServerSettings(id: $id, scannerFindCovers: $scannerFindCovers, scannerCoverProvider: $scannerCoverProvider, scannerParseSubtitle: $scannerParseSubtitle, scannerPreferMatchedMetadata: $scannerPreferMatchedMetadata, scannerDisableWatcher: $scannerDisableWatcher, storeCoverWithItem: $storeCoverWithItem, storeMetadataWithItem: $storeMetadataWithItem, metadataFileFormat: $metadataFileFormat, rateLimitLoginRequests: $rateLimitLoginRequests, rateLimitLoginWindow: $rateLimitLoginWindow, backupSchedule: $backupSchedule, backupsToKeep: $backupsToKeep, maxBackupSize: $maxBackupSize, loggerDailyLogsToKeep: $loggerDailyLogsToKeep, loggerScannerLogsToKeep: $loggerScannerLogsToKeep, homeBookshelfView: $homeBookshelfView, bookshelfView: $bookshelfView, sortingIgnorePrefix: $sortingIgnorePrefix, sortingPrefixes: $sortingPrefixes, chromecastEnabled: $chromecastEnabled, dateFormat: $dateFormat, language: $language, logLevel: $logLevel, version: $version)';
}


}

/// @nodoc
abstract mixin class $ServerSettingsCopyWith<$Res>  {
  factory $ServerSettingsCopyWith(ServerSettings value, $Res Function(ServerSettings) _then) = _$ServerSettingsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "scannerFindCovers") bool? scannerFindCovers,@JsonKey(name: "scannerCoverProvider") String? scannerCoverProvider,@JsonKey(name: "scannerParseSubtitle") bool? scannerParseSubtitle,@JsonKey(name: "scannerPreferMatchedMetadata") bool? scannerPreferMatchedMetadata,@JsonKey(name: "scannerDisableWatcher") bool? scannerDisableWatcher,@JsonKey(name: "storeCoverWithItem") bool? storeCoverWithItem,@JsonKey(name: "storeMetadataWithItem") bool? storeMetadataWithItem,@JsonKey(name: "metadataFileFormat") String? metadataFileFormat,@JsonKey(name: "rateLimitLoginRequests") int? rateLimitLoginRequests,@JsonKey(name: "rateLimitLoginWindow") int? rateLimitLoginWindow,@JsonKey(name: "backupSchedule") dynamic backupSchedule,@JsonKey(name: "backupsToKeep") int? backupsToKeep,@JsonKey(name: "maxBackupSize") int? maxBackupSize,@JsonKey(name: "loggerDailyLogsToKeep") int? loggerDailyLogsToKeep,@JsonKey(name: "loggerScannerLogsToKeep") int? loggerScannerLogsToKeep,@JsonKey(name: "homeBookshelfView") int? homeBookshelfView,@JsonKey(name: "bookshelfView") int? bookshelfView,@JsonKey(name: "sortingIgnorePrefix") bool? sortingIgnorePrefix,@JsonKey(name: "sortingPrefixes") List<String>? sortingPrefixes,@JsonKey(name: "chromecastEnabled") bool? chromecastEnabled,@JsonKey(name: "dateFormat") String? dateFormat,@JsonKey(name: "language") String? language,@JsonKey(name: "logLevel") int? logLevel,@JsonKey(name: "version") String? version
});




}
/// @nodoc
class _$ServerSettingsCopyWithImpl<$Res>
    implements $ServerSettingsCopyWith<$Res> {
  _$ServerSettingsCopyWithImpl(this._self, this._then);

  final ServerSettings _self;
  final $Res Function(ServerSettings) _then;

/// Create a copy of ServerSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? scannerFindCovers = freezed,Object? scannerCoverProvider = freezed,Object? scannerParseSubtitle = freezed,Object? scannerPreferMatchedMetadata = freezed,Object? scannerDisableWatcher = freezed,Object? storeCoverWithItem = freezed,Object? storeMetadataWithItem = freezed,Object? metadataFileFormat = freezed,Object? rateLimitLoginRequests = freezed,Object? rateLimitLoginWindow = freezed,Object? backupSchedule = freezed,Object? backupsToKeep = freezed,Object? maxBackupSize = freezed,Object? loggerDailyLogsToKeep = freezed,Object? loggerScannerLogsToKeep = freezed,Object? homeBookshelfView = freezed,Object? bookshelfView = freezed,Object? sortingIgnorePrefix = freezed,Object? sortingPrefixes = freezed,Object? chromecastEnabled = freezed,Object? dateFormat = freezed,Object? language = freezed,Object? logLevel = freezed,Object? version = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,scannerFindCovers: freezed == scannerFindCovers ? _self.scannerFindCovers : scannerFindCovers // ignore: cast_nullable_to_non_nullable
as bool?,scannerCoverProvider: freezed == scannerCoverProvider ? _self.scannerCoverProvider : scannerCoverProvider // ignore: cast_nullable_to_non_nullable
as String?,scannerParseSubtitle: freezed == scannerParseSubtitle ? _self.scannerParseSubtitle : scannerParseSubtitle // ignore: cast_nullable_to_non_nullable
as bool?,scannerPreferMatchedMetadata: freezed == scannerPreferMatchedMetadata ? _self.scannerPreferMatchedMetadata : scannerPreferMatchedMetadata // ignore: cast_nullable_to_non_nullable
as bool?,scannerDisableWatcher: freezed == scannerDisableWatcher ? _self.scannerDisableWatcher : scannerDisableWatcher // ignore: cast_nullable_to_non_nullable
as bool?,storeCoverWithItem: freezed == storeCoverWithItem ? _self.storeCoverWithItem : storeCoverWithItem // ignore: cast_nullable_to_non_nullable
as bool?,storeMetadataWithItem: freezed == storeMetadataWithItem ? _self.storeMetadataWithItem : storeMetadataWithItem // ignore: cast_nullable_to_non_nullable
as bool?,metadataFileFormat: freezed == metadataFileFormat ? _self.metadataFileFormat : metadataFileFormat // ignore: cast_nullable_to_non_nullable
as String?,rateLimitLoginRequests: freezed == rateLimitLoginRequests ? _self.rateLimitLoginRequests : rateLimitLoginRequests // ignore: cast_nullable_to_non_nullable
as int?,rateLimitLoginWindow: freezed == rateLimitLoginWindow ? _self.rateLimitLoginWindow : rateLimitLoginWindow // ignore: cast_nullable_to_non_nullable
as int?,backupSchedule: freezed == backupSchedule ? _self.backupSchedule : backupSchedule // ignore: cast_nullable_to_non_nullable
as dynamic,backupsToKeep: freezed == backupsToKeep ? _self.backupsToKeep : backupsToKeep // ignore: cast_nullable_to_non_nullable
as int?,maxBackupSize: freezed == maxBackupSize ? _self.maxBackupSize : maxBackupSize // ignore: cast_nullable_to_non_nullable
as int?,loggerDailyLogsToKeep: freezed == loggerDailyLogsToKeep ? _self.loggerDailyLogsToKeep : loggerDailyLogsToKeep // ignore: cast_nullable_to_non_nullable
as int?,loggerScannerLogsToKeep: freezed == loggerScannerLogsToKeep ? _self.loggerScannerLogsToKeep : loggerScannerLogsToKeep // ignore: cast_nullable_to_non_nullable
as int?,homeBookshelfView: freezed == homeBookshelfView ? _self.homeBookshelfView : homeBookshelfView // ignore: cast_nullable_to_non_nullable
as int?,bookshelfView: freezed == bookshelfView ? _self.bookshelfView : bookshelfView // ignore: cast_nullable_to_non_nullable
as int?,sortingIgnorePrefix: freezed == sortingIgnorePrefix ? _self.sortingIgnorePrefix : sortingIgnorePrefix // ignore: cast_nullable_to_non_nullable
as bool?,sortingPrefixes: freezed == sortingPrefixes ? _self.sortingPrefixes : sortingPrefixes // ignore: cast_nullable_to_non_nullable
as List<String>?,chromecastEnabled: freezed == chromecastEnabled ? _self.chromecastEnabled : chromecastEnabled // ignore: cast_nullable_to_non_nullable
as bool?,dateFormat: freezed == dateFormat ? _self.dateFormat : dateFormat // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,logLevel: freezed == logLevel ? _self.logLevel : logLevel // ignore: cast_nullable_to_non_nullable
as int?,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ServerSettings implements ServerSettings {
  const _ServerSettings({@JsonKey(name: "id") required this.id, @JsonKey(name: "scannerFindCovers") this.scannerFindCovers, @JsonKey(name: "scannerCoverProvider") this.scannerCoverProvider, @JsonKey(name: "scannerParseSubtitle") this.scannerParseSubtitle, @JsonKey(name: "scannerPreferMatchedMetadata") this.scannerPreferMatchedMetadata, @JsonKey(name: "scannerDisableWatcher") this.scannerDisableWatcher, @JsonKey(name: "storeCoverWithItem") this.storeCoverWithItem, @JsonKey(name: "storeMetadataWithItem") this.storeMetadataWithItem, @JsonKey(name: "metadataFileFormat") this.metadataFileFormat, @JsonKey(name: "rateLimitLoginRequests") this.rateLimitLoginRequests, @JsonKey(name: "rateLimitLoginWindow") this.rateLimitLoginWindow, @JsonKey(name: "backupSchedule") this.backupSchedule, @JsonKey(name: "backupsToKeep") this.backupsToKeep, @JsonKey(name: "maxBackupSize") this.maxBackupSize, @JsonKey(name: "loggerDailyLogsToKeep") this.loggerDailyLogsToKeep, @JsonKey(name: "loggerScannerLogsToKeep") this.loggerScannerLogsToKeep, @JsonKey(name: "homeBookshelfView") this.homeBookshelfView, @JsonKey(name: "bookshelfView") this.bookshelfView, @JsonKey(name: "sortingIgnorePrefix") this.sortingIgnorePrefix, @JsonKey(name: "sortingPrefixes") final  List<String>? sortingPrefixes, @JsonKey(name: "chromecastEnabled") this.chromecastEnabled, @JsonKey(name: "dateFormat") this.dateFormat, @JsonKey(name: "language") this.language, @JsonKey(name: "logLevel") this.logLevel, @JsonKey(name: "version") this.version}): _sortingPrefixes = sortingPrefixes;
  factory _ServerSettings.fromJson(Map<String, dynamic> json) => _$ServerSettingsFromJson(json);

@override@JsonKey(name: "id") final  String id;
@override@JsonKey(name: "scannerFindCovers") final  bool? scannerFindCovers;
@override@JsonKey(name: "scannerCoverProvider") final  String? scannerCoverProvider;
@override@JsonKey(name: "scannerParseSubtitle") final  bool? scannerParseSubtitle;
@override@JsonKey(name: "scannerPreferMatchedMetadata") final  bool? scannerPreferMatchedMetadata;
@override@JsonKey(name: "scannerDisableWatcher") final  bool? scannerDisableWatcher;
@override@JsonKey(name: "storeCoverWithItem") final  bool? storeCoverWithItem;
@override@JsonKey(name: "storeMetadataWithItem") final  bool? storeMetadataWithItem;
@override@JsonKey(name: "metadataFileFormat") final  String? metadataFileFormat;
@override@JsonKey(name: "rateLimitLoginRequests") final  int? rateLimitLoginRequests;
@override@JsonKey(name: "rateLimitLoginWindow") final  int? rateLimitLoginWindow;
@override@JsonKey(name: "backupSchedule") final  dynamic backupSchedule;
@override@JsonKey(name: "backupsToKeep") final  int? backupsToKeep;
@override@JsonKey(name: "maxBackupSize") final  int? maxBackupSize;
@override@JsonKey(name: "loggerDailyLogsToKeep") final  int? loggerDailyLogsToKeep;
@override@JsonKey(name: "loggerScannerLogsToKeep") final  int? loggerScannerLogsToKeep;
@override@JsonKey(name: "homeBookshelfView") final  int? homeBookshelfView;
@override@JsonKey(name: "bookshelfView") final  int? bookshelfView;
@override@JsonKey(name: "sortingIgnorePrefix") final  bool? sortingIgnorePrefix;
 final  List<String>? _sortingPrefixes;
@override@JsonKey(name: "sortingPrefixes") List<String>? get sortingPrefixes {
  final value = _sortingPrefixes;
  if (value == null) return null;
  if (_sortingPrefixes is EqualUnmodifiableListView) return _sortingPrefixes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: "chromecastEnabled") final  bool? chromecastEnabled;
@override@JsonKey(name: "dateFormat") final  String? dateFormat;
@override@JsonKey(name: "language") final  String? language;
@override@JsonKey(name: "logLevel") final  int? logLevel;
@override@JsonKey(name: "version") final  String? version;

/// Create a copy of ServerSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerSettingsCopyWith<_ServerSettings> get copyWith => __$ServerSettingsCopyWithImpl<_ServerSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServerSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerSettings&&(identical(other.id, id) || other.id == id)&&(identical(other.scannerFindCovers, scannerFindCovers) || other.scannerFindCovers == scannerFindCovers)&&(identical(other.scannerCoverProvider, scannerCoverProvider) || other.scannerCoverProvider == scannerCoverProvider)&&(identical(other.scannerParseSubtitle, scannerParseSubtitle) || other.scannerParseSubtitle == scannerParseSubtitle)&&(identical(other.scannerPreferMatchedMetadata, scannerPreferMatchedMetadata) || other.scannerPreferMatchedMetadata == scannerPreferMatchedMetadata)&&(identical(other.scannerDisableWatcher, scannerDisableWatcher) || other.scannerDisableWatcher == scannerDisableWatcher)&&(identical(other.storeCoverWithItem, storeCoverWithItem) || other.storeCoverWithItem == storeCoverWithItem)&&(identical(other.storeMetadataWithItem, storeMetadataWithItem) || other.storeMetadataWithItem == storeMetadataWithItem)&&(identical(other.metadataFileFormat, metadataFileFormat) || other.metadataFileFormat == metadataFileFormat)&&(identical(other.rateLimitLoginRequests, rateLimitLoginRequests) || other.rateLimitLoginRequests == rateLimitLoginRequests)&&(identical(other.rateLimitLoginWindow, rateLimitLoginWindow) || other.rateLimitLoginWindow == rateLimitLoginWindow)&&const DeepCollectionEquality().equals(other.backupSchedule, backupSchedule)&&(identical(other.backupsToKeep, backupsToKeep) || other.backupsToKeep == backupsToKeep)&&(identical(other.maxBackupSize, maxBackupSize) || other.maxBackupSize == maxBackupSize)&&(identical(other.loggerDailyLogsToKeep, loggerDailyLogsToKeep) || other.loggerDailyLogsToKeep == loggerDailyLogsToKeep)&&(identical(other.loggerScannerLogsToKeep, loggerScannerLogsToKeep) || other.loggerScannerLogsToKeep == loggerScannerLogsToKeep)&&(identical(other.homeBookshelfView, homeBookshelfView) || other.homeBookshelfView == homeBookshelfView)&&(identical(other.bookshelfView, bookshelfView) || other.bookshelfView == bookshelfView)&&(identical(other.sortingIgnorePrefix, sortingIgnorePrefix) || other.sortingIgnorePrefix == sortingIgnorePrefix)&&const DeepCollectionEquality().equals(other._sortingPrefixes, _sortingPrefixes)&&(identical(other.chromecastEnabled, chromecastEnabled) || other.chromecastEnabled == chromecastEnabled)&&(identical(other.dateFormat, dateFormat) || other.dateFormat == dateFormat)&&(identical(other.language, language) || other.language == language)&&(identical(other.logLevel, logLevel) || other.logLevel == logLevel)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,scannerFindCovers,scannerCoverProvider,scannerParseSubtitle,scannerPreferMatchedMetadata,scannerDisableWatcher,storeCoverWithItem,storeMetadataWithItem,metadataFileFormat,rateLimitLoginRequests,rateLimitLoginWindow,const DeepCollectionEquality().hash(backupSchedule),backupsToKeep,maxBackupSize,loggerDailyLogsToKeep,loggerScannerLogsToKeep,homeBookshelfView,bookshelfView,sortingIgnorePrefix,const DeepCollectionEquality().hash(_sortingPrefixes),chromecastEnabled,dateFormat,language,logLevel,version]);

@override
String toString() {
  return 'ServerSettings(id: $id, scannerFindCovers: $scannerFindCovers, scannerCoverProvider: $scannerCoverProvider, scannerParseSubtitle: $scannerParseSubtitle, scannerPreferMatchedMetadata: $scannerPreferMatchedMetadata, scannerDisableWatcher: $scannerDisableWatcher, storeCoverWithItem: $storeCoverWithItem, storeMetadataWithItem: $storeMetadataWithItem, metadataFileFormat: $metadataFileFormat, rateLimitLoginRequests: $rateLimitLoginRequests, rateLimitLoginWindow: $rateLimitLoginWindow, backupSchedule: $backupSchedule, backupsToKeep: $backupsToKeep, maxBackupSize: $maxBackupSize, loggerDailyLogsToKeep: $loggerDailyLogsToKeep, loggerScannerLogsToKeep: $loggerScannerLogsToKeep, homeBookshelfView: $homeBookshelfView, bookshelfView: $bookshelfView, sortingIgnorePrefix: $sortingIgnorePrefix, sortingPrefixes: $sortingPrefixes, chromecastEnabled: $chromecastEnabled, dateFormat: $dateFormat, language: $language, logLevel: $logLevel, version: $version)';
}


}

/// @nodoc
abstract mixin class _$ServerSettingsCopyWith<$Res> implements $ServerSettingsCopyWith<$Res> {
  factory _$ServerSettingsCopyWith(_ServerSettings value, $Res Function(_ServerSettings) _then) = __$ServerSettingsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "scannerFindCovers") bool? scannerFindCovers,@JsonKey(name: "scannerCoverProvider") String? scannerCoverProvider,@JsonKey(name: "scannerParseSubtitle") bool? scannerParseSubtitle,@JsonKey(name: "scannerPreferMatchedMetadata") bool? scannerPreferMatchedMetadata,@JsonKey(name: "scannerDisableWatcher") bool? scannerDisableWatcher,@JsonKey(name: "storeCoverWithItem") bool? storeCoverWithItem,@JsonKey(name: "storeMetadataWithItem") bool? storeMetadataWithItem,@JsonKey(name: "metadataFileFormat") String? metadataFileFormat,@JsonKey(name: "rateLimitLoginRequests") int? rateLimitLoginRequests,@JsonKey(name: "rateLimitLoginWindow") int? rateLimitLoginWindow,@JsonKey(name: "backupSchedule") dynamic backupSchedule,@JsonKey(name: "backupsToKeep") int? backupsToKeep,@JsonKey(name: "maxBackupSize") int? maxBackupSize,@JsonKey(name: "loggerDailyLogsToKeep") int? loggerDailyLogsToKeep,@JsonKey(name: "loggerScannerLogsToKeep") int? loggerScannerLogsToKeep,@JsonKey(name: "homeBookshelfView") int? homeBookshelfView,@JsonKey(name: "bookshelfView") int? bookshelfView,@JsonKey(name: "sortingIgnorePrefix") bool? sortingIgnorePrefix,@JsonKey(name: "sortingPrefixes") List<String>? sortingPrefixes,@JsonKey(name: "chromecastEnabled") bool? chromecastEnabled,@JsonKey(name: "dateFormat") String? dateFormat,@JsonKey(name: "language") String? language,@JsonKey(name: "logLevel") int? logLevel,@JsonKey(name: "version") String? version
});




}
/// @nodoc
class __$ServerSettingsCopyWithImpl<$Res>
    implements _$ServerSettingsCopyWith<$Res> {
  __$ServerSettingsCopyWithImpl(this._self, this._then);

  final _ServerSettings _self;
  final $Res Function(_ServerSettings) _then;

/// Create a copy of ServerSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? scannerFindCovers = freezed,Object? scannerCoverProvider = freezed,Object? scannerParseSubtitle = freezed,Object? scannerPreferMatchedMetadata = freezed,Object? scannerDisableWatcher = freezed,Object? storeCoverWithItem = freezed,Object? storeMetadataWithItem = freezed,Object? metadataFileFormat = freezed,Object? rateLimitLoginRequests = freezed,Object? rateLimitLoginWindow = freezed,Object? backupSchedule = freezed,Object? backupsToKeep = freezed,Object? maxBackupSize = freezed,Object? loggerDailyLogsToKeep = freezed,Object? loggerScannerLogsToKeep = freezed,Object? homeBookshelfView = freezed,Object? bookshelfView = freezed,Object? sortingIgnorePrefix = freezed,Object? sortingPrefixes = freezed,Object? chromecastEnabled = freezed,Object? dateFormat = freezed,Object? language = freezed,Object? logLevel = freezed,Object? version = freezed,}) {
  return _then(_ServerSettings(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,scannerFindCovers: freezed == scannerFindCovers ? _self.scannerFindCovers : scannerFindCovers // ignore: cast_nullable_to_non_nullable
as bool?,scannerCoverProvider: freezed == scannerCoverProvider ? _self.scannerCoverProvider : scannerCoverProvider // ignore: cast_nullable_to_non_nullable
as String?,scannerParseSubtitle: freezed == scannerParseSubtitle ? _self.scannerParseSubtitle : scannerParseSubtitle // ignore: cast_nullable_to_non_nullable
as bool?,scannerPreferMatchedMetadata: freezed == scannerPreferMatchedMetadata ? _self.scannerPreferMatchedMetadata : scannerPreferMatchedMetadata // ignore: cast_nullable_to_non_nullable
as bool?,scannerDisableWatcher: freezed == scannerDisableWatcher ? _self.scannerDisableWatcher : scannerDisableWatcher // ignore: cast_nullable_to_non_nullable
as bool?,storeCoverWithItem: freezed == storeCoverWithItem ? _self.storeCoverWithItem : storeCoverWithItem // ignore: cast_nullable_to_non_nullable
as bool?,storeMetadataWithItem: freezed == storeMetadataWithItem ? _self.storeMetadataWithItem : storeMetadataWithItem // ignore: cast_nullable_to_non_nullable
as bool?,metadataFileFormat: freezed == metadataFileFormat ? _self.metadataFileFormat : metadataFileFormat // ignore: cast_nullable_to_non_nullable
as String?,rateLimitLoginRequests: freezed == rateLimitLoginRequests ? _self.rateLimitLoginRequests : rateLimitLoginRequests // ignore: cast_nullable_to_non_nullable
as int?,rateLimitLoginWindow: freezed == rateLimitLoginWindow ? _self.rateLimitLoginWindow : rateLimitLoginWindow // ignore: cast_nullable_to_non_nullable
as int?,backupSchedule: freezed == backupSchedule ? _self.backupSchedule : backupSchedule // ignore: cast_nullable_to_non_nullable
as dynamic,backupsToKeep: freezed == backupsToKeep ? _self.backupsToKeep : backupsToKeep // ignore: cast_nullable_to_non_nullable
as int?,maxBackupSize: freezed == maxBackupSize ? _self.maxBackupSize : maxBackupSize // ignore: cast_nullable_to_non_nullable
as int?,loggerDailyLogsToKeep: freezed == loggerDailyLogsToKeep ? _self.loggerDailyLogsToKeep : loggerDailyLogsToKeep // ignore: cast_nullable_to_non_nullable
as int?,loggerScannerLogsToKeep: freezed == loggerScannerLogsToKeep ? _self.loggerScannerLogsToKeep : loggerScannerLogsToKeep // ignore: cast_nullable_to_non_nullable
as int?,homeBookshelfView: freezed == homeBookshelfView ? _self.homeBookshelfView : homeBookshelfView // ignore: cast_nullable_to_non_nullable
as int?,bookshelfView: freezed == bookshelfView ? _self.bookshelfView : bookshelfView // ignore: cast_nullable_to_non_nullable
as int?,sortingIgnorePrefix: freezed == sortingIgnorePrefix ? _self.sortingIgnorePrefix : sortingIgnorePrefix // ignore: cast_nullable_to_non_nullable
as bool?,sortingPrefixes: freezed == sortingPrefixes ? _self._sortingPrefixes : sortingPrefixes // ignore: cast_nullable_to_non_nullable
as List<String>?,chromecastEnabled: freezed == chromecastEnabled ? _self.chromecastEnabled : chromecastEnabled // ignore: cast_nullable_to_non_nullable
as bool?,dateFormat: freezed == dateFormat ? _self.dateFormat : dateFormat // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,logLevel: freezed == logLevel ? _self.logLevel : logLevel // ignore: cast_nullable_to_non_nullable
as int?,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
