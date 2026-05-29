// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_library_settings_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateLibrarySettingsRequest {

@JsonKey(name: 'coverAspectRatio') double? get coverAspectRatio;@JsonKey(name: 'disableWatcher') bool? get disableWatcher;@JsonKey(name: 'skipMatchingMediaWithAsin') bool? get skipMatchingMediaWithAsin;@JsonKey(name: 'skipMatchingMediaWithIsbn') bool? get skipMatchingMediaWithIsbn;@JsonKey(name: 'autoScanCronExpression') String? get autoScanCronExpression;@JsonKey(name: 'audiobooksOnly') bool? get audiobooksOnly;@JsonKey(name: 'epubsAllowScriptedContent') bool? get epubScriptedContent;@JsonKey(name: 'hideSingleBookSeries') bool? get hideSingleBookSeries;@JsonKey(name: 'onlyShowLaterBooksInContinueSeries') bool? get showLaterBooks;@JsonKey(name: 'podcastSearchRegion') String? get podcastSearchRegion;@JsonKey(name: 'markAsFinishedTimeRemaining', fromJson: jsonIntFromDynamic) int? get markAsFinishedTimeRemaining;@JsonKey(name: 'markAsFinishedPercentComplete', fromJson: jsonDoubleFromDynamic) double? get markAsFinishedPercentComplete;@JsonKey(name: 'metadataPrecedence') List<String>? get metadataPrecedence;
/// Create a copy of UpdateLibrarySettingsRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateLibrarySettingsRequestCopyWith<UpdateLibrarySettingsRequest> get copyWith => _$UpdateLibrarySettingsRequestCopyWithImpl<UpdateLibrarySettingsRequest>(this as UpdateLibrarySettingsRequest, _$identity);

  /// Serializes this UpdateLibrarySettingsRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateLibrarySettingsRequest&&(identical(other.coverAspectRatio, coverAspectRatio) || other.coverAspectRatio == coverAspectRatio)&&(identical(other.disableWatcher, disableWatcher) || other.disableWatcher == disableWatcher)&&(identical(other.skipMatchingMediaWithAsin, skipMatchingMediaWithAsin) || other.skipMatchingMediaWithAsin == skipMatchingMediaWithAsin)&&(identical(other.skipMatchingMediaWithIsbn, skipMatchingMediaWithIsbn) || other.skipMatchingMediaWithIsbn == skipMatchingMediaWithIsbn)&&(identical(other.autoScanCronExpression, autoScanCronExpression) || other.autoScanCronExpression == autoScanCronExpression)&&(identical(other.audiobooksOnly, audiobooksOnly) || other.audiobooksOnly == audiobooksOnly)&&(identical(other.epubScriptedContent, epubScriptedContent) || other.epubScriptedContent == epubScriptedContent)&&(identical(other.hideSingleBookSeries, hideSingleBookSeries) || other.hideSingleBookSeries == hideSingleBookSeries)&&(identical(other.showLaterBooks, showLaterBooks) || other.showLaterBooks == showLaterBooks)&&(identical(other.podcastSearchRegion, podcastSearchRegion) || other.podcastSearchRegion == podcastSearchRegion)&&(identical(other.markAsFinishedTimeRemaining, markAsFinishedTimeRemaining) || other.markAsFinishedTimeRemaining == markAsFinishedTimeRemaining)&&(identical(other.markAsFinishedPercentComplete, markAsFinishedPercentComplete) || other.markAsFinishedPercentComplete == markAsFinishedPercentComplete)&&const DeepCollectionEquality().equals(other.metadataPrecedence, metadataPrecedence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,coverAspectRatio,disableWatcher,skipMatchingMediaWithAsin,skipMatchingMediaWithIsbn,autoScanCronExpression,audiobooksOnly,epubScriptedContent,hideSingleBookSeries,showLaterBooks,podcastSearchRegion,markAsFinishedTimeRemaining,markAsFinishedPercentComplete,const DeepCollectionEquality().hash(metadataPrecedence));

@override
String toString() {
  return 'UpdateLibrarySettingsRequest(coverAspectRatio: $coverAspectRatio, disableWatcher: $disableWatcher, skipMatchingMediaWithAsin: $skipMatchingMediaWithAsin, skipMatchingMediaWithIsbn: $skipMatchingMediaWithIsbn, autoScanCronExpression: $autoScanCronExpression, audiobooksOnly: $audiobooksOnly, epubScriptedContent: $epubScriptedContent, hideSingleBookSeries: $hideSingleBookSeries, showLaterBooks: $showLaterBooks, podcastSearchRegion: $podcastSearchRegion, markAsFinishedTimeRemaining: $markAsFinishedTimeRemaining, markAsFinishedPercentComplete: $markAsFinishedPercentComplete, metadataPrecedence: $metadataPrecedence)';
}


}

/// @nodoc
abstract mixin class $UpdateLibrarySettingsRequestCopyWith<$Res>  {
  factory $UpdateLibrarySettingsRequestCopyWith(UpdateLibrarySettingsRequest value, $Res Function(UpdateLibrarySettingsRequest) _then) = _$UpdateLibrarySettingsRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'coverAspectRatio') double? coverAspectRatio,@JsonKey(name: 'disableWatcher') bool? disableWatcher,@JsonKey(name: 'skipMatchingMediaWithAsin') bool? skipMatchingMediaWithAsin,@JsonKey(name: 'skipMatchingMediaWithIsbn') bool? skipMatchingMediaWithIsbn,@JsonKey(name: 'autoScanCronExpression') String? autoScanCronExpression,@JsonKey(name: 'audiobooksOnly') bool? audiobooksOnly,@JsonKey(name: 'epubsAllowScriptedContent') bool? epubScriptedContent,@JsonKey(name: 'hideSingleBookSeries') bool? hideSingleBookSeries,@JsonKey(name: 'onlyShowLaterBooksInContinueSeries') bool? showLaterBooks,@JsonKey(name: 'podcastSearchRegion') String? podcastSearchRegion,@JsonKey(name: 'markAsFinishedTimeRemaining', fromJson: jsonIntFromDynamic) int? markAsFinishedTimeRemaining,@JsonKey(name: 'markAsFinishedPercentComplete', fromJson: jsonDoubleFromDynamic) double? markAsFinishedPercentComplete,@JsonKey(name: 'metadataPrecedence') List<String>? metadataPrecedence
});




}
/// @nodoc
class _$UpdateLibrarySettingsRequestCopyWithImpl<$Res>
    implements $UpdateLibrarySettingsRequestCopyWith<$Res> {
  _$UpdateLibrarySettingsRequestCopyWithImpl(this._self, this._then);

  final UpdateLibrarySettingsRequest _self;
  final $Res Function(UpdateLibrarySettingsRequest) _then;

/// Create a copy of UpdateLibrarySettingsRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? coverAspectRatio = freezed,Object? disableWatcher = freezed,Object? skipMatchingMediaWithAsin = freezed,Object? skipMatchingMediaWithIsbn = freezed,Object? autoScanCronExpression = freezed,Object? audiobooksOnly = freezed,Object? epubScriptedContent = freezed,Object? hideSingleBookSeries = freezed,Object? showLaterBooks = freezed,Object? podcastSearchRegion = freezed,Object? markAsFinishedTimeRemaining = freezed,Object? markAsFinishedPercentComplete = freezed,Object? metadataPrecedence = freezed,}) {
  return _then(_self.copyWith(
coverAspectRatio: freezed == coverAspectRatio ? _self.coverAspectRatio : coverAspectRatio // ignore: cast_nullable_to_non_nullable
as double?,disableWatcher: freezed == disableWatcher ? _self.disableWatcher : disableWatcher // ignore: cast_nullable_to_non_nullable
as bool?,skipMatchingMediaWithAsin: freezed == skipMatchingMediaWithAsin ? _self.skipMatchingMediaWithAsin : skipMatchingMediaWithAsin // ignore: cast_nullable_to_non_nullable
as bool?,skipMatchingMediaWithIsbn: freezed == skipMatchingMediaWithIsbn ? _self.skipMatchingMediaWithIsbn : skipMatchingMediaWithIsbn // ignore: cast_nullable_to_non_nullable
as bool?,autoScanCronExpression: freezed == autoScanCronExpression ? _self.autoScanCronExpression : autoScanCronExpression // ignore: cast_nullable_to_non_nullable
as String?,audiobooksOnly: freezed == audiobooksOnly ? _self.audiobooksOnly : audiobooksOnly // ignore: cast_nullable_to_non_nullable
as bool?,epubScriptedContent: freezed == epubScriptedContent ? _self.epubScriptedContent : epubScriptedContent // ignore: cast_nullable_to_non_nullable
as bool?,hideSingleBookSeries: freezed == hideSingleBookSeries ? _self.hideSingleBookSeries : hideSingleBookSeries // ignore: cast_nullable_to_non_nullable
as bool?,showLaterBooks: freezed == showLaterBooks ? _self.showLaterBooks : showLaterBooks // ignore: cast_nullable_to_non_nullable
as bool?,podcastSearchRegion: freezed == podcastSearchRegion ? _self.podcastSearchRegion : podcastSearchRegion // ignore: cast_nullable_to_non_nullable
as String?,markAsFinishedTimeRemaining: freezed == markAsFinishedTimeRemaining ? _self.markAsFinishedTimeRemaining : markAsFinishedTimeRemaining // ignore: cast_nullable_to_non_nullable
as int?,markAsFinishedPercentComplete: freezed == markAsFinishedPercentComplete ? _self.markAsFinishedPercentComplete : markAsFinishedPercentComplete // ignore: cast_nullable_to_non_nullable
as double?,metadataPrecedence: freezed == metadataPrecedence ? _self.metadataPrecedence : metadataPrecedence // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateLibrarySettingsRequest].
extension UpdateLibrarySettingsRequestPatterns on UpdateLibrarySettingsRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateLibrarySettingsRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateLibrarySettingsRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateLibrarySettingsRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateLibrarySettingsRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateLibrarySettingsRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateLibrarySettingsRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'coverAspectRatio')  double? coverAspectRatio, @JsonKey(name: 'disableWatcher')  bool? disableWatcher, @JsonKey(name: 'skipMatchingMediaWithAsin')  bool? skipMatchingMediaWithAsin, @JsonKey(name: 'skipMatchingMediaWithIsbn')  bool? skipMatchingMediaWithIsbn, @JsonKey(name: 'autoScanCronExpression')  String? autoScanCronExpression, @JsonKey(name: 'audiobooksOnly')  bool? audiobooksOnly, @JsonKey(name: 'epubsAllowScriptedContent')  bool? epubScriptedContent, @JsonKey(name: 'hideSingleBookSeries')  bool? hideSingleBookSeries, @JsonKey(name: 'onlyShowLaterBooksInContinueSeries')  bool? showLaterBooks, @JsonKey(name: 'podcastSearchRegion')  String? podcastSearchRegion, @JsonKey(name: 'markAsFinishedTimeRemaining', fromJson: jsonIntFromDynamic)  int? markAsFinishedTimeRemaining, @JsonKey(name: 'markAsFinishedPercentComplete', fromJson: jsonDoubleFromDynamic)  double? markAsFinishedPercentComplete, @JsonKey(name: 'metadataPrecedence')  List<String>? metadataPrecedence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateLibrarySettingsRequest() when $default != null:
return $default(_that.coverAspectRatio,_that.disableWatcher,_that.skipMatchingMediaWithAsin,_that.skipMatchingMediaWithIsbn,_that.autoScanCronExpression,_that.audiobooksOnly,_that.epubScriptedContent,_that.hideSingleBookSeries,_that.showLaterBooks,_that.podcastSearchRegion,_that.markAsFinishedTimeRemaining,_that.markAsFinishedPercentComplete,_that.metadataPrecedence);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'coverAspectRatio')  double? coverAspectRatio, @JsonKey(name: 'disableWatcher')  bool? disableWatcher, @JsonKey(name: 'skipMatchingMediaWithAsin')  bool? skipMatchingMediaWithAsin, @JsonKey(name: 'skipMatchingMediaWithIsbn')  bool? skipMatchingMediaWithIsbn, @JsonKey(name: 'autoScanCronExpression')  String? autoScanCronExpression, @JsonKey(name: 'audiobooksOnly')  bool? audiobooksOnly, @JsonKey(name: 'epubsAllowScriptedContent')  bool? epubScriptedContent, @JsonKey(name: 'hideSingleBookSeries')  bool? hideSingleBookSeries, @JsonKey(name: 'onlyShowLaterBooksInContinueSeries')  bool? showLaterBooks, @JsonKey(name: 'podcastSearchRegion')  String? podcastSearchRegion, @JsonKey(name: 'markAsFinishedTimeRemaining', fromJson: jsonIntFromDynamic)  int? markAsFinishedTimeRemaining, @JsonKey(name: 'markAsFinishedPercentComplete', fromJson: jsonDoubleFromDynamic)  double? markAsFinishedPercentComplete, @JsonKey(name: 'metadataPrecedence')  List<String>? metadataPrecedence)  $default,) {final _that = this;
switch (_that) {
case _UpdateLibrarySettingsRequest():
return $default(_that.coverAspectRatio,_that.disableWatcher,_that.skipMatchingMediaWithAsin,_that.skipMatchingMediaWithIsbn,_that.autoScanCronExpression,_that.audiobooksOnly,_that.epubScriptedContent,_that.hideSingleBookSeries,_that.showLaterBooks,_that.podcastSearchRegion,_that.markAsFinishedTimeRemaining,_that.markAsFinishedPercentComplete,_that.metadataPrecedence);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'coverAspectRatio')  double? coverAspectRatio, @JsonKey(name: 'disableWatcher')  bool? disableWatcher, @JsonKey(name: 'skipMatchingMediaWithAsin')  bool? skipMatchingMediaWithAsin, @JsonKey(name: 'skipMatchingMediaWithIsbn')  bool? skipMatchingMediaWithIsbn, @JsonKey(name: 'autoScanCronExpression')  String? autoScanCronExpression, @JsonKey(name: 'audiobooksOnly')  bool? audiobooksOnly, @JsonKey(name: 'epubsAllowScriptedContent')  bool? epubScriptedContent, @JsonKey(name: 'hideSingleBookSeries')  bool? hideSingleBookSeries, @JsonKey(name: 'onlyShowLaterBooksInContinueSeries')  bool? showLaterBooks, @JsonKey(name: 'podcastSearchRegion')  String? podcastSearchRegion, @JsonKey(name: 'markAsFinishedTimeRemaining', fromJson: jsonIntFromDynamic)  int? markAsFinishedTimeRemaining, @JsonKey(name: 'markAsFinishedPercentComplete', fromJson: jsonDoubleFromDynamic)  double? markAsFinishedPercentComplete, @JsonKey(name: 'metadataPrecedence')  List<String>? metadataPrecedence)?  $default,) {final _that = this;
switch (_that) {
case _UpdateLibrarySettingsRequest() when $default != null:
return $default(_that.coverAspectRatio,_that.disableWatcher,_that.skipMatchingMediaWithAsin,_that.skipMatchingMediaWithIsbn,_that.autoScanCronExpression,_that.audiobooksOnly,_that.epubScriptedContent,_that.hideSingleBookSeries,_that.showLaterBooks,_that.podcastSearchRegion,_that.markAsFinishedTimeRemaining,_that.markAsFinishedPercentComplete,_that.metadataPrecedence);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(includeIfNull: false)
class _UpdateLibrarySettingsRequest implements UpdateLibrarySettingsRequest {
  const _UpdateLibrarySettingsRequest({@JsonKey(name: 'coverAspectRatio') this.coverAspectRatio, @JsonKey(name: 'disableWatcher') this.disableWatcher, @JsonKey(name: 'skipMatchingMediaWithAsin') this.skipMatchingMediaWithAsin, @JsonKey(name: 'skipMatchingMediaWithIsbn') this.skipMatchingMediaWithIsbn, @JsonKey(name: 'autoScanCronExpression') this.autoScanCronExpression, @JsonKey(name: 'audiobooksOnly') this.audiobooksOnly, @JsonKey(name: 'epubsAllowScriptedContent') this.epubScriptedContent, @JsonKey(name: 'hideSingleBookSeries') this.hideSingleBookSeries, @JsonKey(name: 'onlyShowLaterBooksInContinueSeries') this.showLaterBooks, @JsonKey(name: 'podcastSearchRegion') this.podcastSearchRegion, @JsonKey(name: 'markAsFinishedTimeRemaining', fromJson: jsonIntFromDynamic) this.markAsFinishedTimeRemaining, @JsonKey(name: 'markAsFinishedPercentComplete', fromJson: jsonDoubleFromDynamic) this.markAsFinishedPercentComplete, @JsonKey(name: 'metadataPrecedence') final  List<String>? metadataPrecedence}): _metadataPrecedence = metadataPrecedence;
  factory _UpdateLibrarySettingsRequest.fromJson(Map<String, dynamic> json) => _$UpdateLibrarySettingsRequestFromJson(json);

@override@JsonKey(name: 'coverAspectRatio') final  double? coverAspectRatio;
@override@JsonKey(name: 'disableWatcher') final  bool? disableWatcher;
@override@JsonKey(name: 'skipMatchingMediaWithAsin') final  bool? skipMatchingMediaWithAsin;
@override@JsonKey(name: 'skipMatchingMediaWithIsbn') final  bool? skipMatchingMediaWithIsbn;
@override@JsonKey(name: 'autoScanCronExpression') final  String? autoScanCronExpression;
@override@JsonKey(name: 'audiobooksOnly') final  bool? audiobooksOnly;
@override@JsonKey(name: 'epubsAllowScriptedContent') final  bool? epubScriptedContent;
@override@JsonKey(name: 'hideSingleBookSeries') final  bool? hideSingleBookSeries;
@override@JsonKey(name: 'onlyShowLaterBooksInContinueSeries') final  bool? showLaterBooks;
@override@JsonKey(name: 'podcastSearchRegion') final  String? podcastSearchRegion;
@override@JsonKey(name: 'markAsFinishedTimeRemaining', fromJson: jsonIntFromDynamic) final  int? markAsFinishedTimeRemaining;
@override@JsonKey(name: 'markAsFinishedPercentComplete', fromJson: jsonDoubleFromDynamic) final  double? markAsFinishedPercentComplete;
 final  List<String>? _metadataPrecedence;
@override@JsonKey(name: 'metadataPrecedence') List<String>? get metadataPrecedence {
  final value = _metadataPrecedence;
  if (value == null) return null;
  if (_metadataPrecedence is EqualUnmodifiableListView) return _metadataPrecedence;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of UpdateLibrarySettingsRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateLibrarySettingsRequestCopyWith<_UpdateLibrarySettingsRequest> get copyWith => __$UpdateLibrarySettingsRequestCopyWithImpl<_UpdateLibrarySettingsRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateLibrarySettingsRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateLibrarySettingsRequest&&(identical(other.coverAspectRatio, coverAspectRatio) || other.coverAspectRatio == coverAspectRatio)&&(identical(other.disableWatcher, disableWatcher) || other.disableWatcher == disableWatcher)&&(identical(other.skipMatchingMediaWithAsin, skipMatchingMediaWithAsin) || other.skipMatchingMediaWithAsin == skipMatchingMediaWithAsin)&&(identical(other.skipMatchingMediaWithIsbn, skipMatchingMediaWithIsbn) || other.skipMatchingMediaWithIsbn == skipMatchingMediaWithIsbn)&&(identical(other.autoScanCronExpression, autoScanCronExpression) || other.autoScanCronExpression == autoScanCronExpression)&&(identical(other.audiobooksOnly, audiobooksOnly) || other.audiobooksOnly == audiobooksOnly)&&(identical(other.epubScriptedContent, epubScriptedContent) || other.epubScriptedContent == epubScriptedContent)&&(identical(other.hideSingleBookSeries, hideSingleBookSeries) || other.hideSingleBookSeries == hideSingleBookSeries)&&(identical(other.showLaterBooks, showLaterBooks) || other.showLaterBooks == showLaterBooks)&&(identical(other.podcastSearchRegion, podcastSearchRegion) || other.podcastSearchRegion == podcastSearchRegion)&&(identical(other.markAsFinishedTimeRemaining, markAsFinishedTimeRemaining) || other.markAsFinishedTimeRemaining == markAsFinishedTimeRemaining)&&(identical(other.markAsFinishedPercentComplete, markAsFinishedPercentComplete) || other.markAsFinishedPercentComplete == markAsFinishedPercentComplete)&&const DeepCollectionEquality().equals(other._metadataPrecedence, _metadataPrecedence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,coverAspectRatio,disableWatcher,skipMatchingMediaWithAsin,skipMatchingMediaWithIsbn,autoScanCronExpression,audiobooksOnly,epubScriptedContent,hideSingleBookSeries,showLaterBooks,podcastSearchRegion,markAsFinishedTimeRemaining,markAsFinishedPercentComplete,const DeepCollectionEquality().hash(_metadataPrecedence));

@override
String toString() {
  return 'UpdateLibrarySettingsRequest(coverAspectRatio: $coverAspectRatio, disableWatcher: $disableWatcher, skipMatchingMediaWithAsin: $skipMatchingMediaWithAsin, skipMatchingMediaWithIsbn: $skipMatchingMediaWithIsbn, autoScanCronExpression: $autoScanCronExpression, audiobooksOnly: $audiobooksOnly, epubScriptedContent: $epubScriptedContent, hideSingleBookSeries: $hideSingleBookSeries, showLaterBooks: $showLaterBooks, podcastSearchRegion: $podcastSearchRegion, markAsFinishedTimeRemaining: $markAsFinishedTimeRemaining, markAsFinishedPercentComplete: $markAsFinishedPercentComplete, metadataPrecedence: $metadataPrecedence)';
}


}

/// @nodoc
abstract mixin class _$UpdateLibrarySettingsRequestCopyWith<$Res> implements $UpdateLibrarySettingsRequestCopyWith<$Res> {
  factory _$UpdateLibrarySettingsRequestCopyWith(_UpdateLibrarySettingsRequest value, $Res Function(_UpdateLibrarySettingsRequest) _then) = __$UpdateLibrarySettingsRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'coverAspectRatio') double? coverAspectRatio,@JsonKey(name: 'disableWatcher') bool? disableWatcher,@JsonKey(name: 'skipMatchingMediaWithAsin') bool? skipMatchingMediaWithAsin,@JsonKey(name: 'skipMatchingMediaWithIsbn') bool? skipMatchingMediaWithIsbn,@JsonKey(name: 'autoScanCronExpression') String? autoScanCronExpression,@JsonKey(name: 'audiobooksOnly') bool? audiobooksOnly,@JsonKey(name: 'epubsAllowScriptedContent') bool? epubScriptedContent,@JsonKey(name: 'hideSingleBookSeries') bool? hideSingleBookSeries,@JsonKey(name: 'onlyShowLaterBooksInContinueSeries') bool? showLaterBooks,@JsonKey(name: 'podcastSearchRegion') String? podcastSearchRegion,@JsonKey(name: 'markAsFinishedTimeRemaining', fromJson: jsonIntFromDynamic) int? markAsFinishedTimeRemaining,@JsonKey(name: 'markAsFinishedPercentComplete', fromJson: jsonDoubleFromDynamic) double? markAsFinishedPercentComplete,@JsonKey(name: 'metadataPrecedence') List<String>? metadataPrecedence
});




}
/// @nodoc
class __$UpdateLibrarySettingsRequestCopyWithImpl<$Res>
    implements _$UpdateLibrarySettingsRequestCopyWith<$Res> {
  __$UpdateLibrarySettingsRequestCopyWithImpl(this._self, this._then);

  final _UpdateLibrarySettingsRequest _self;
  final $Res Function(_UpdateLibrarySettingsRequest) _then;

/// Create a copy of UpdateLibrarySettingsRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? coverAspectRatio = freezed,Object? disableWatcher = freezed,Object? skipMatchingMediaWithAsin = freezed,Object? skipMatchingMediaWithIsbn = freezed,Object? autoScanCronExpression = freezed,Object? audiobooksOnly = freezed,Object? epubScriptedContent = freezed,Object? hideSingleBookSeries = freezed,Object? showLaterBooks = freezed,Object? podcastSearchRegion = freezed,Object? markAsFinishedTimeRemaining = freezed,Object? markAsFinishedPercentComplete = freezed,Object? metadataPrecedence = freezed,}) {
  return _then(_UpdateLibrarySettingsRequest(
coverAspectRatio: freezed == coverAspectRatio ? _self.coverAspectRatio : coverAspectRatio // ignore: cast_nullable_to_non_nullable
as double?,disableWatcher: freezed == disableWatcher ? _self.disableWatcher : disableWatcher // ignore: cast_nullable_to_non_nullable
as bool?,skipMatchingMediaWithAsin: freezed == skipMatchingMediaWithAsin ? _self.skipMatchingMediaWithAsin : skipMatchingMediaWithAsin // ignore: cast_nullable_to_non_nullable
as bool?,skipMatchingMediaWithIsbn: freezed == skipMatchingMediaWithIsbn ? _self.skipMatchingMediaWithIsbn : skipMatchingMediaWithIsbn // ignore: cast_nullable_to_non_nullable
as bool?,autoScanCronExpression: freezed == autoScanCronExpression ? _self.autoScanCronExpression : autoScanCronExpression // ignore: cast_nullable_to_non_nullable
as String?,audiobooksOnly: freezed == audiobooksOnly ? _self.audiobooksOnly : audiobooksOnly // ignore: cast_nullable_to_non_nullable
as bool?,epubScriptedContent: freezed == epubScriptedContent ? _self.epubScriptedContent : epubScriptedContent // ignore: cast_nullable_to_non_nullable
as bool?,hideSingleBookSeries: freezed == hideSingleBookSeries ? _self.hideSingleBookSeries : hideSingleBookSeries // ignore: cast_nullable_to_non_nullable
as bool?,showLaterBooks: freezed == showLaterBooks ? _self.showLaterBooks : showLaterBooks // ignore: cast_nullable_to_non_nullable
as bool?,podcastSearchRegion: freezed == podcastSearchRegion ? _self.podcastSearchRegion : podcastSearchRegion // ignore: cast_nullable_to_non_nullable
as String?,markAsFinishedTimeRemaining: freezed == markAsFinishedTimeRemaining ? _self.markAsFinishedTimeRemaining : markAsFinishedTimeRemaining // ignore: cast_nullable_to_non_nullable
as int?,markAsFinishedPercentComplete: freezed == markAsFinishedPercentComplete ? _self.markAsFinishedPercentComplete : markAsFinishedPercentComplete // ignore: cast_nullable_to_non_nullable
as double?,metadataPrecedence: freezed == metadataPrecedence ? _self._metadataPrecedence : metadataPrecedence // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
