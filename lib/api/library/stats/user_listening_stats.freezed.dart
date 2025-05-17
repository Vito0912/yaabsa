// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_listening_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserListeningStats {

@JsonKey(name: "totalTime") double? get totalTime;@JsonKey(name: "items") Map<String, ItemsListenedTo>? get items;@JsonKey(name: "days") Map<String, double>? get days;@JsonKey(name: "dayOfWeek") DaysOfWeek? get dayOfWeek;@JsonKey(name: "today") double? get today;@JsonKey(name: "recentSessions") List<PlaybackSession>? get recentSessions;
/// Create a copy of UserListeningStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserListeningStatsCopyWith<UserListeningStats> get copyWith => _$UserListeningStatsCopyWithImpl<UserListeningStats>(this as UserListeningStats, _$identity);

  /// Serializes this UserListeningStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserListeningStats&&(identical(other.totalTime, totalTime) || other.totalTime == totalTime)&&const DeepCollectionEquality().equals(other.items, items)&&const DeepCollectionEquality().equals(other.days, days)&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.today, today) || other.today == today)&&const DeepCollectionEquality().equals(other.recentSessions, recentSessions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalTime,const DeepCollectionEquality().hash(items),const DeepCollectionEquality().hash(days),dayOfWeek,today,const DeepCollectionEquality().hash(recentSessions));

@override
String toString() {
  return 'UserListeningStats(totalTime: $totalTime, items: $items, days: $days, dayOfWeek: $dayOfWeek, today: $today, recentSessions: $recentSessions)';
}


}

/// @nodoc
abstract mixin class $UserListeningStatsCopyWith<$Res>  {
  factory $UserListeningStatsCopyWith(UserListeningStats value, $Res Function(UserListeningStats) _then) = _$UserListeningStatsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "totalTime") double? totalTime,@JsonKey(name: "items") Map<String, ItemsListenedTo>? items,@JsonKey(name: "days") Map<String, double>? days,@JsonKey(name: "dayOfWeek") DaysOfWeek? dayOfWeek,@JsonKey(name: "today") double? today,@JsonKey(name: "recentSessions") List<PlaybackSession>? recentSessions
});


$DaysOfWeekCopyWith<$Res>? get dayOfWeek;

}
/// @nodoc
class _$UserListeningStatsCopyWithImpl<$Res>
    implements $UserListeningStatsCopyWith<$Res> {
  _$UserListeningStatsCopyWithImpl(this._self, this._then);

  final UserListeningStats _self;
  final $Res Function(UserListeningStats) _then;

/// Create a copy of UserListeningStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalTime = freezed,Object? items = freezed,Object? days = freezed,Object? dayOfWeek = freezed,Object? today = freezed,Object? recentSessions = freezed,}) {
  return _then(_self.copyWith(
totalTime: freezed == totalTime ? _self.totalTime : totalTime // ignore: cast_nullable_to_non_nullable
as double?,items: freezed == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as Map<String, ItemsListenedTo>?,days: freezed == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as Map<String, double>?,dayOfWeek: freezed == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as DaysOfWeek?,today: freezed == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as double?,recentSessions: freezed == recentSessions ? _self.recentSessions : recentSessions // ignore: cast_nullable_to_non_nullable
as List<PlaybackSession>?,
  ));
}
/// Create a copy of UserListeningStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DaysOfWeekCopyWith<$Res>? get dayOfWeek {
    if (_self.dayOfWeek == null) {
    return null;
  }

  return $DaysOfWeekCopyWith<$Res>(_self.dayOfWeek!, (value) {
    return _then(_self.copyWith(dayOfWeek: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _UserListeningStats implements UserListeningStats {
  const _UserListeningStats({@JsonKey(name: "totalTime") this.totalTime, @JsonKey(name: "items") final  Map<String, ItemsListenedTo>? items, @JsonKey(name: "days") final  Map<String, double>? days, @JsonKey(name: "dayOfWeek") this.dayOfWeek, @JsonKey(name: "today") this.today, @JsonKey(name: "recentSessions") final  List<PlaybackSession>? recentSessions}): _items = items,_days = days,_recentSessions = recentSessions;
  factory _UserListeningStats.fromJson(Map<String, dynamic> json) => _$UserListeningStatsFromJson(json);

@override@JsonKey(name: "totalTime") final  double? totalTime;
 final  Map<String, ItemsListenedTo>? _items;
@override@JsonKey(name: "items") Map<String, ItemsListenedTo>? get items {
  final value = _items;
  if (value == null) return null;
  if (_items is EqualUnmodifiableMapView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, double>? _days;
@override@JsonKey(name: "days") Map<String, double>? get days {
  final value = _days;
  if (value == null) return null;
  if (_days is EqualUnmodifiableMapView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey(name: "dayOfWeek") final  DaysOfWeek? dayOfWeek;
@override@JsonKey(name: "today") final  double? today;
 final  List<PlaybackSession>? _recentSessions;
@override@JsonKey(name: "recentSessions") List<PlaybackSession>? get recentSessions {
  final value = _recentSessions;
  if (value == null) return null;
  if (_recentSessions is EqualUnmodifiableListView) return _recentSessions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of UserListeningStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserListeningStatsCopyWith<_UserListeningStats> get copyWith => __$UserListeningStatsCopyWithImpl<_UserListeningStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserListeningStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserListeningStats&&(identical(other.totalTime, totalTime) || other.totalTime == totalTime)&&const DeepCollectionEquality().equals(other._items, _items)&&const DeepCollectionEquality().equals(other._days, _days)&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.today, today) || other.today == today)&&const DeepCollectionEquality().equals(other._recentSessions, _recentSessions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalTime,const DeepCollectionEquality().hash(_items),const DeepCollectionEquality().hash(_days),dayOfWeek,today,const DeepCollectionEquality().hash(_recentSessions));

@override
String toString() {
  return 'UserListeningStats(totalTime: $totalTime, items: $items, days: $days, dayOfWeek: $dayOfWeek, today: $today, recentSessions: $recentSessions)';
}


}

/// @nodoc
abstract mixin class _$UserListeningStatsCopyWith<$Res> implements $UserListeningStatsCopyWith<$Res> {
  factory _$UserListeningStatsCopyWith(_UserListeningStats value, $Res Function(_UserListeningStats) _then) = __$UserListeningStatsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "totalTime") double? totalTime,@JsonKey(name: "items") Map<String, ItemsListenedTo>? items,@JsonKey(name: "days") Map<String, double>? days,@JsonKey(name: "dayOfWeek") DaysOfWeek? dayOfWeek,@JsonKey(name: "today") double? today,@JsonKey(name: "recentSessions") List<PlaybackSession>? recentSessions
});


@override $DaysOfWeekCopyWith<$Res>? get dayOfWeek;

}
/// @nodoc
class __$UserListeningStatsCopyWithImpl<$Res>
    implements _$UserListeningStatsCopyWith<$Res> {
  __$UserListeningStatsCopyWithImpl(this._self, this._then);

  final _UserListeningStats _self;
  final $Res Function(_UserListeningStats) _then;

/// Create a copy of UserListeningStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalTime = freezed,Object? items = freezed,Object? days = freezed,Object? dayOfWeek = freezed,Object? today = freezed,Object? recentSessions = freezed,}) {
  return _then(_UserListeningStats(
totalTime: freezed == totalTime ? _self.totalTime : totalTime // ignore: cast_nullable_to_non_nullable
as double?,items: freezed == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as Map<String, ItemsListenedTo>?,days: freezed == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as Map<String, double>?,dayOfWeek: freezed == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as DaysOfWeek?,today: freezed == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as double?,recentSessions: freezed == recentSessions ? _self._recentSessions : recentSessions // ignore: cast_nullable_to_non_nullable
as List<PlaybackSession>?,
  ));
}

/// Create a copy of UserListeningStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DaysOfWeekCopyWith<$Res>? get dayOfWeek {
    if (_self.dayOfWeek == null) {
    return null;
  }

  return $DaysOfWeekCopyWith<$Res>(_self.dayOfWeek!, (value) {
    return _then(_self.copyWith(dayOfWeek: value));
  });
}
}

// dart format on
