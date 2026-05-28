// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'year_in_review_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$YearInReviewNamedStat {

@JsonKey(name: 'name') String? get name;@JsonKey(name: 'time', fromJson: jsonIntFromDynamic) int? get time;
/// Create a copy of YearInReviewNamedStat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YearInReviewNamedStatCopyWith<YearInReviewNamedStat> get copyWith => _$YearInReviewNamedStatCopyWithImpl<YearInReviewNamedStat>(this as YearInReviewNamedStat, _$identity);

  /// Serializes this YearInReviewNamedStat to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YearInReviewNamedStat&&(identical(other.name, name) || other.name == name)&&(identical(other.time, time) || other.time == time));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,time);

@override
String toString() {
  return 'YearInReviewNamedStat(name: $name, time: $time)';
}


}

/// @nodoc
abstract mixin class $YearInReviewNamedStatCopyWith<$Res>  {
  factory $YearInReviewNamedStatCopyWith(YearInReviewNamedStat value, $Res Function(YearInReviewNamedStat) _then) = _$YearInReviewNamedStatCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'name') String? name,@JsonKey(name: 'time', fromJson: jsonIntFromDynamic) int? time
});




}
/// @nodoc
class _$YearInReviewNamedStatCopyWithImpl<$Res>
    implements $YearInReviewNamedStatCopyWith<$Res> {
  _$YearInReviewNamedStatCopyWithImpl(this._self, this._then);

  final YearInReviewNamedStat _self;
  final $Res Function(YearInReviewNamedStat) _then;

/// Create a copy of YearInReviewNamedStat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? time = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [YearInReviewNamedStat].
extension YearInReviewNamedStatPatterns on YearInReviewNamedStat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _YearInReviewNamedStat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _YearInReviewNamedStat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _YearInReviewNamedStat value)  $default,){
final _that = this;
switch (_that) {
case _YearInReviewNamedStat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _YearInReviewNamedStat value)?  $default,){
final _that = this;
switch (_that) {
case _YearInReviewNamedStat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'name')  String? name, @JsonKey(name: 'time', fromJson: jsonIntFromDynamic)  int? time)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _YearInReviewNamedStat() when $default != null:
return $default(_that.name,_that.time);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'name')  String? name, @JsonKey(name: 'time', fromJson: jsonIntFromDynamic)  int? time)  $default,) {final _that = this;
switch (_that) {
case _YearInReviewNamedStat():
return $default(_that.name,_that.time);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'name')  String? name, @JsonKey(name: 'time', fromJson: jsonIntFromDynamic)  int? time)?  $default,) {final _that = this;
switch (_that) {
case _YearInReviewNamedStat() when $default != null:
return $default(_that.name,_that.time);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _YearInReviewNamedStat implements YearInReviewNamedStat {
  const _YearInReviewNamedStat({@JsonKey(name: 'name') this.name, @JsonKey(name: 'time', fromJson: jsonIntFromDynamic) this.time});
  factory _YearInReviewNamedStat.fromJson(Map<String, dynamic> json) => _$YearInReviewNamedStatFromJson(json);

@override@JsonKey(name: 'name') final  String? name;
@override@JsonKey(name: 'time', fromJson: jsonIntFromDynamic) final  int? time;

/// Create a copy of YearInReviewNamedStat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YearInReviewNamedStatCopyWith<_YearInReviewNamedStat> get copyWith => __$YearInReviewNamedStatCopyWithImpl<_YearInReviewNamedStat>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$YearInReviewNamedStatToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _YearInReviewNamedStat&&(identical(other.name, name) || other.name == name)&&(identical(other.time, time) || other.time == time));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,time);

@override
String toString() {
  return 'YearInReviewNamedStat(name: $name, time: $time)';
}


}

/// @nodoc
abstract mixin class _$YearInReviewNamedStatCopyWith<$Res> implements $YearInReviewNamedStatCopyWith<$Res> {
  factory _$YearInReviewNamedStatCopyWith(_YearInReviewNamedStat value, $Res Function(_YearInReviewNamedStat) _then) = __$YearInReviewNamedStatCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'name') String? name,@JsonKey(name: 'time', fromJson: jsonIntFromDynamic) int? time
});




}
/// @nodoc
class __$YearInReviewNamedStatCopyWithImpl<$Res>
    implements _$YearInReviewNamedStatCopyWith<$Res> {
  __$YearInReviewNamedStatCopyWithImpl(this._self, this._then);

  final _YearInReviewNamedStat _self;
  final $Res Function(_YearInReviewNamedStat) _then;

/// Create a copy of YearInReviewNamedStat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? time = freezed,}) {
  return _then(_YearInReviewNamedStat(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$YearInReviewGenreStat {

@JsonKey(name: 'genre') String? get genre;@JsonKey(name: 'time', fromJson: jsonIntFromDynamic) int? get time;
/// Create a copy of YearInReviewGenreStat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YearInReviewGenreStatCopyWith<YearInReviewGenreStat> get copyWith => _$YearInReviewGenreStatCopyWithImpl<YearInReviewGenreStat>(this as YearInReviewGenreStat, _$identity);

  /// Serializes this YearInReviewGenreStat to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YearInReviewGenreStat&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.time, time) || other.time == time));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,genre,time);

@override
String toString() {
  return 'YearInReviewGenreStat(genre: $genre, time: $time)';
}


}

/// @nodoc
abstract mixin class $YearInReviewGenreStatCopyWith<$Res>  {
  factory $YearInReviewGenreStatCopyWith(YearInReviewGenreStat value, $Res Function(YearInReviewGenreStat) _then) = _$YearInReviewGenreStatCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'genre') String? genre,@JsonKey(name: 'time', fromJson: jsonIntFromDynamic) int? time
});




}
/// @nodoc
class _$YearInReviewGenreStatCopyWithImpl<$Res>
    implements $YearInReviewGenreStatCopyWith<$Res> {
  _$YearInReviewGenreStatCopyWithImpl(this._self, this._then);

  final YearInReviewGenreStat _self;
  final $Res Function(YearInReviewGenreStat) _then;

/// Create a copy of YearInReviewGenreStat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? genre = freezed,Object? time = freezed,}) {
  return _then(_self.copyWith(
genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [YearInReviewGenreStat].
extension YearInReviewGenreStatPatterns on YearInReviewGenreStat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _YearInReviewGenreStat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _YearInReviewGenreStat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _YearInReviewGenreStat value)  $default,){
final _that = this;
switch (_that) {
case _YearInReviewGenreStat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _YearInReviewGenreStat value)?  $default,){
final _that = this;
switch (_that) {
case _YearInReviewGenreStat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'genre')  String? genre, @JsonKey(name: 'time', fromJson: jsonIntFromDynamic)  int? time)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _YearInReviewGenreStat() when $default != null:
return $default(_that.genre,_that.time);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'genre')  String? genre, @JsonKey(name: 'time', fromJson: jsonIntFromDynamic)  int? time)  $default,) {final _that = this;
switch (_that) {
case _YearInReviewGenreStat():
return $default(_that.genre,_that.time);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'genre')  String? genre, @JsonKey(name: 'time', fromJson: jsonIntFromDynamic)  int? time)?  $default,) {final _that = this;
switch (_that) {
case _YearInReviewGenreStat() when $default != null:
return $default(_that.genre,_that.time);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _YearInReviewGenreStat implements YearInReviewGenreStat {
  const _YearInReviewGenreStat({@JsonKey(name: 'genre') this.genre, @JsonKey(name: 'time', fromJson: jsonIntFromDynamic) this.time});
  factory _YearInReviewGenreStat.fromJson(Map<String, dynamic> json) => _$YearInReviewGenreStatFromJson(json);

@override@JsonKey(name: 'genre') final  String? genre;
@override@JsonKey(name: 'time', fromJson: jsonIntFromDynamic) final  int? time;

/// Create a copy of YearInReviewGenreStat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YearInReviewGenreStatCopyWith<_YearInReviewGenreStat> get copyWith => __$YearInReviewGenreStatCopyWithImpl<_YearInReviewGenreStat>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$YearInReviewGenreStatToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _YearInReviewGenreStat&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.time, time) || other.time == time));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,genre,time);

@override
String toString() {
  return 'YearInReviewGenreStat(genre: $genre, time: $time)';
}


}

/// @nodoc
abstract mixin class _$YearInReviewGenreStatCopyWith<$Res> implements $YearInReviewGenreStatCopyWith<$Res> {
  factory _$YearInReviewGenreStatCopyWith(_YearInReviewGenreStat value, $Res Function(_YearInReviewGenreStat) _then) = __$YearInReviewGenreStatCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'genre') String? genre,@JsonKey(name: 'time', fromJson: jsonIntFromDynamic) int? time
});




}
/// @nodoc
class __$YearInReviewGenreStatCopyWithImpl<$Res>
    implements _$YearInReviewGenreStatCopyWith<$Res> {
  __$YearInReviewGenreStatCopyWithImpl(this._self, this._then);

  final _YearInReviewGenreStat _self;
  final $Res Function(_YearInReviewGenreStat) _then;

/// Create a copy of YearInReviewGenreStat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? genre = freezed,Object? time = freezed,}) {
  return _then(_YearInReviewGenreStat(
genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$YearInReviewMonthStat {

@JsonKey(name: 'month', fromJson: jsonIntFromDynamic) int? get month;@JsonKey(name: 'time', fromJson: jsonIntFromDynamic) int? get time;
/// Create a copy of YearInReviewMonthStat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YearInReviewMonthStatCopyWith<YearInReviewMonthStat> get copyWith => _$YearInReviewMonthStatCopyWithImpl<YearInReviewMonthStat>(this as YearInReviewMonthStat, _$identity);

  /// Serializes this YearInReviewMonthStat to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YearInReviewMonthStat&&(identical(other.month, month) || other.month == month)&&(identical(other.time, time) || other.time == time));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,month,time);

@override
String toString() {
  return 'YearInReviewMonthStat(month: $month, time: $time)';
}


}

/// @nodoc
abstract mixin class $YearInReviewMonthStatCopyWith<$Res>  {
  factory $YearInReviewMonthStatCopyWith(YearInReviewMonthStat value, $Res Function(YearInReviewMonthStat) _then) = _$YearInReviewMonthStatCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'month', fromJson: jsonIntFromDynamic) int? month,@JsonKey(name: 'time', fromJson: jsonIntFromDynamic) int? time
});




}
/// @nodoc
class _$YearInReviewMonthStatCopyWithImpl<$Res>
    implements $YearInReviewMonthStatCopyWith<$Res> {
  _$YearInReviewMonthStatCopyWithImpl(this._self, this._then);

  final YearInReviewMonthStat _self;
  final $Res Function(YearInReviewMonthStat) _then;

/// Create a copy of YearInReviewMonthStat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = freezed,Object? time = freezed,}) {
  return _then(_self.copyWith(
month: freezed == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [YearInReviewMonthStat].
extension YearInReviewMonthStatPatterns on YearInReviewMonthStat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _YearInReviewMonthStat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _YearInReviewMonthStat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _YearInReviewMonthStat value)  $default,){
final _that = this;
switch (_that) {
case _YearInReviewMonthStat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _YearInReviewMonthStat value)?  $default,){
final _that = this;
switch (_that) {
case _YearInReviewMonthStat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'month', fromJson: jsonIntFromDynamic)  int? month, @JsonKey(name: 'time', fromJson: jsonIntFromDynamic)  int? time)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _YearInReviewMonthStat() when $default != null:
return $default(_that.month,_that.time);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'month', fromJson: jsonIntFromDynamic)  int? month, @JsonKey(name: 'time', fromJson: jsonIntFromDynamic)  int? time)  $default,) {final _that = this;
switch (_that) {
case _YearInReviewMonthStat():
return $default(_that.month,_that.time);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'month', fromJson: jsonIntFromDynamic)  int? month, @JsonKey(name: 'time', fromJson: jsonIntFromDynamic)  int? time)?  $default,) {final _that = this;
switch (_that) {
case _YearInReviewMonthStat() when $default != null:
return $default(_that.month,_that.time);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _YearInReviewMonthStat implements YearInReviewMonthStat {
  const _YearInReviewMonthStat({@JsonKey(name: 'month', fromJson: jsonIntFromDynamic) this.month, @JsonKey(name: 'time', fromJson: jsonIntFromDynamic) this.time});
  factory _YearInReviewMonthStat.fromJson(Map<String, dynamic> json) => _$YearInReviewMonthStatFromJson(json);

@override@JsonKey(name: 'month', fromJson: jsonIntFromDynamic) final  int? month;
@override@JsonKey(name: 'time', fromJson: jsonIntFromDynamic) final  int? time;

/// Create a copy of YearInReviewMonthStat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YearInReviewMonthStatCopyWith<_YearInReviewMonthStat> get copyWith => __$YearInReviewMonthStatCopyWithImpl<_YearInReviewMonthStat>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$YearInReviewMonthStatToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _YearInReviewMonthStat&&(identical(other.month, month) || other.month == month)&&(identical(other.time, time) || other.time == time));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,month,time);

@override
String toString() {
  return 'YearInReviewMonthStat(month: $month, time: $time)';
}


}

/// @nodoc
abstract mixin class _$YearInReviewMonthStatCopyWith<$Res> implements $YearInReviewMonthStatCopyWith<$Res> {
  factory _$YearInReviewMonthStatCopyWith(_YearInReviewMonthStat value, $Res Function(_YearInReviewMonthStat) _then) = __$YearInReviewMonthStatCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'month', fromJson: jsonIntFromDynamic) int? month,@JsonKey(name: 'time', fromJson: jsonIntFromDynamic) int? time
});




}
/// @nodoc
class __$YearInReviewMonthStatCopyWithImpl<$Res>
    implements _$YearInReviewMonthStatCopyWith<$Res> {
  __$YearInReviewMonthStatCopyWithImpl(this._self, this._then);

  final _YearInReviewMonthStat _self;
  final $Res Function(_YearInReviewMonthStat) _then;

/// Create a copy of YearInReviewMonthStat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = freezed,Object? time = freezed,}) {
  return _then(_YearInReviewMonthStat(
month: freezed == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$YearInReviewBookStat {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'title') String? get title;@JsonKey(name: 'duration', fromJson: jsonIntFromDynamic) int? get duration;@JsonKey(name: 'finishedAt', fromJson: jsonIntFromDynamic) int? get finishedAt;
/// Create a copy of YearInReviewBookStat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YearInReviewBookStatCopyWith<YearInReviewBookStat> get copyWith => _$YearInReviewBookStatCopyWithImpl<YearInReviewBookStat>(this as YearInReviewBookStat, _$identity);

  /// Serializes this YearInReviewBookStat to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YearInReviewBookStat&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,duration,finishedAt);

@override
String toString() {
  return 'YearInReviewBookStat(id: $id, title: $title, duration: $duration, finishedAt: $finishedAt)';
}


}

/// @nodoc
abstract mixin class $YearInReviewBookStatCopyWith<$Res>  {
  factory $YearInReviewBookStatCopyWith(YearInReviewBookStat value, $Res Function(YearInReviewBookStat) _then) = _$YearInReviewBookStatCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'title') String? title,@JsonKey(name: 'duration', fromJson: jsonIntFromDynamic) int? duration,@JsonKey(name: 'finishedAt', fromJson: jsonIntFromDynamic) int? finishedAt
});




}
/// @nodoc
class _$YearInReviewBookStatCopyWithImpl<$Res>
    implements $YearInReviewBookStatCopyWith<$Res> {
  _$YearInReviewBookStatCopyWithImpl(this._self, this._then);

  final YearInReviewBookStat _self;
  final $Res Function(YearInReviewBookStat) _then;

/// Create a copy of YearInReviewBookStat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? title = freezed,Object? duration = freezed,Object? finishedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,finishedAt: freezed == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [YearInReviewBookStat].
extension YearInReviewBookStatPatterns on YearInReviewBookStat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _YearInReviewBookStat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _YearInReviewBookStat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _YearInReviewBookStat value)  $default,){
final _that = this;
switch (_that) {
case _YearInReviewBookStat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _YearInReviewBookStat value)?  $default,){
final _that = this;
switch (_that) {
case _YearInReviewBookStat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String? id, @JsonKey(name: 'title')  String? title, @JsonKey(name: 'duration', fromJson: jsonIntFromDynamic)  int? duration, @JsonKey(name: 'finishedAt', fromJson: jsonIntFromDynamic)  int? finishedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _YearInReviewBookStat() when $default != null:
return $default(_that.id,_that.title,_that.duration,_that.finishedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String? id, @JsonKey(name: 'title')  String? title, @JsonKey(name: 'duration', fromJson: jsonIntFromDynamic)  int? duration, @JsonKey(name: 'finishedAt', fromJson: jsonIntFromDynamic)  int? finishedAt)  $default,) {final _that = this;
switch (_that) {
case _YearInReviewBookStat():
return $default(_that.id,_that.title,_that.duration,_that.finishedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String? id, @JsonKey(name: 'title')  String? title, @JsonKey(name: 'duration', fromJson: jsonIntFromDynamic)  int? duration, @JsonKey(name: 'finishedAt', fromJson: jsonIntFromDynamic)  int? finishedAt)?  $default,) {final _that = this;
switch (_that) {
case _YearInReviewBookStat() when $default != null:
return $default(_that.id,_that.title,_that.duration,_that.finishedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _YearInReviewBookStat implements YearInReviewBookStat {
  const _YearInReviewBookStat({@JsonKey(name: 'id') this.id, @JsonKey(name: 'title') this.title, @JsonKey(name: 'duration', fromJson: jsonIntFromDynamic) this.duration, @JsonKey(name: 'finishedAt', fromJson: jsonIntFromDynamic) this.finishedAt});
  factory _YearInReviewBookStat.fromJson(Map<String, dynamic> json) => _$YearInReviewBookStatFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'title') final  String? title;
@override@JsonKey(name: 'duration', fromJson: jsonIntFromDynamic) final  int? duration;
@override@JsonKey(name: 'finishedAt', fromJson: jsonIntFromDynamic) final  int? finishedAt;

/// Create a copy of YearInReviewBookStat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YearInReviewBookStatCopyWith<_YearInReviewBookStat> get copyWith => __$YearInReviewBookStatCopyWithImpl<_YearInReviewBookStat>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$YearInReviewBookStatToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _YearInReviewBookStat&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,duration,finishedAt);

@override
String toString() {
  return 'YearInReviewBookStat(id: $id, title: $title, duration: $duration, finishedAt: $finishedAt)';
}


}

/// @nodoc
abstract mixin class _$YearInReviewBookStatCopyWith<$Res> implements $YearInReviewBookStatCopyWith<$Res> {
  factory _$YearInReviewBookStatCopyWith(_YearInReviewBookStat value, $Res Function(_YearInReviewBookStat) _then) = __$YearInReviewBookStatCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'title') String? title,@JsonKey(name: 'duration', fromJson: jsonIntFromDynamic) int? duration,@JsonKey(name: 'finishedAt', fromJson: jsonIntFromDynamic) int? finishedAt
});




}
/// @nodoc
class __$YearInReviewBookStatCopyWithImpl<$Res>
    implements _$YearInReviewBookStatCopyWith<$Res> {
  __$YearInReviewBookStatCopyWithImpl(this._self, this._then);

  final _YearInReviewBookStat _self;
  final $Res Function(_YearInReviewBookStat) _then;

/// Create a copy of YearInReviewBookStat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? title = freezed,Object? duration = freezed,Object? finishedAt = freezed,}) {
  return _then(_YearInReviewBookStat(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,finishedAt: freezed == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$YearInReviewStats {

@JsonKey(name: 'totalListeningSessions', fromJson: jsonIntFromDynamic) int? get totalListeningSessions;@JsonKey(name: 'totalListeningTime', fromJson: jsonIntFromDynamic) int? get totalListeningTime;@JsonKey(name: 'totalBookListeningTime', fromJson: jsonIntFromDynamic) int? get totalBookListeningTime;@JsonKey(name: 'totalPodcastListeningTime', fromJson: jsonIntFromDynamic) int? get totalPodcastListeningTime;@JsonKey(name: 'topAuthors') List<YearInReviewNamedStat> get topAuthors;@JsonKey(name: 'topGenres') List<YearInReviewGenreStat> get topGenres;@JsonKey(name: 'mostListenedNarrator') YearInReviewNamedStat? get mostListenedNarrator;@JsonKey(name: 'mostListenedMonth') YearInReviewMonthStat? get mostListenedMonth;@JsonKey(name: 'numBooksFinished', fromJson: jsonIntFromDynamic) int? get numBooksFinished;@JsonKey(name: 'numBooksListened', fromJson: jsonIntFromDynamic) int? get numBooksListened;@JsonKey(name: 'longestAudiobookFinished') YearInReviewBookStat? get longestAudiobookFinished;@JsonKey(name: 'booksWithCovers') List<String> get booksWithCovers;@JsonKey(name: 'finishedBooksWithCovers') List<String> get finishedBooksWithCovers;@JsonKey(name: 'numListeningSessions', fromJson: jsonIntFromDynamic) int? get numListeningSessions;@JsonKey(name: 'numBooksAdded', fromJson: jsonIntFromDynamic) int? get numBooksAdded;@JsonKey(name: 'numAuthorsAdded', fromJson: jsonIntFromDynamic) int? get numAuthorsAdded;@JsonKey(name: 'totalBooksAddedSize', fromJson: jsonIntFromDynamic) int? get totalBooksAddedSize;@JsonKey(name: 'totalBooksAddedDuration', fromJson: jsonIntFromDynamic) int? get totalBooksAddedDuration;@JsonKey(name: 'booksAddedWithCovers') List<String> get booksAddedWithCovers;@JsonKey(name: 'totalBooksSize', fromJson: jsonIntFromDynamic) int? get totalBooksSize;@JsonKey(name: 'totalBooksDuration', fromJson: jsonIntFromDynamic) int? get totalBooksDuration;@JsonKey(name: 'numBooks', fromJson: jsonIntFromDynamic) int? get numBooks;@JsonKey(name: 'topNarrators') List<YearInReviewNamedStat> get topNarrators;
/// Create a copy of YearInReviewStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YearInReviewStatsCopyWith<YearInReviewStats> get copyWith => _$YearInReviewStatsCopyWithImpl<YearInReviewStats>(this as YearInReviewStats, _$identity);

  /// Serializes this YearInReviewStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YearInReviewStats&&(identical(other.totalListeningSessions, totalListeningSessions) || other.totalListeningSessions == totalListeningSessions)&&(identical(other.totalListeningTime, totalListeningTime) || other.totalListeningTime == totalListeningTime)&&(identical(other.totalBookListeningTime, totalBookListeningTime) || other.totalBookListeningTime == totalBookListeningTime)&&(identical(other.totalPodcastListeningTime, totalPodcastListeningTime) || other.totalPodcastListeningTime == totalPodcastListeningTime)&&const DeepCollectionEquality().equals(other.topAuthors, topAuthors)&&const DeepCollectionEquality().equals(other.topGenres, topGenres)&&(identical(other.mostListenedNarrator, mostListenedNarrator) || other.mostListenedNarrator == mostListenedNarrator)&&(identical(other.mostListenedMonth, mostListenedMonth) || other.mostListenedMonth == mostListenedMonth)&&(identical(other.numBooksFinished, numBooksFinished) || other.numBooksFinished == numBooksFinished)&&(identical(other.numBooksListened, numBooksListened) || other.numBooksListened == numBooksListened)&&(identical(other.longestAudiobookFinished, longestAudiobookFinished) || other.longestAudiobookFinished == longestAudiobookFinished)&&const DeepCollectionEquality().equals(other.booksWithCovers, booksWithCovers)&&const DeepCollectionEquality().equals(other.finishedBooksWithCovers, finishedBooksWithCovers)&&(identical(other.numListeningSessions, numListeningSessions) || other.numListeningSessions == numListeningSessions)&&(identical(other.numBooksAdded, numBooksAdded) || other.numBooksAdded == numBooksAdded)&&(identical(other.numAuthorsAdded, numAuthorsAdded) || other.numAuthorsAdded == numAuthorsAdded)&&(identical(other.totalBooksAddedSize, totalBooksAddedSize) || other.totalBooksAddedSize == totalBooksAddedSize)&&(identical(other.totalBooksAddedDuration, totalBooksAddedDuration) || other.totalBooksAddedDuration == totalBooksAddedDuration)&&const DeepCollectionEquality().equals(other.booksAddedWithCovers, booksAddedWithCovers)&&(identical(other.totalBooksSize, totalBooksSize) || other.totalBooksSize == totalBooksSize)&&(identical(other.totalBooksDuration, totalBooksDuration) || other.totalBooksDuration == totalBooksDuration)&&(identical(other.numBooks, numBooks) || other.numBooks == numBooks)&&const DeepCollectionEquality().equals(other.topNarrators, topNarrators));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,totalListeningSessions,totalListeningTime,totalBookListeningTime,totalPodcastListeningTime,const DeepCollectionEquality().hash(topAuthors),const DeepCollectionEquality().hash(topGenres),mostListenedNarrator,mostListenedMonth,numBooksFinished,numBooksListened,longestAudiobookFinished,const DeepCollectionEquality().hash(booksWithCovers),const DeepCollectionEquality().hash(finishedBooksWithCovers),numListeningSessions,numBooksAdded,numAuthorsAdded,totalBooksAddedSize,totalBooksAddedDuration,const DeepCollectionEquality().hash(booksAddedWithCovers),totalBooksSize,totalBooksDuration,numBooks,const DeepCollectionEquality().hash(topNarrators)]);

@override
String toString() {
  return 'YearInReviewStats(totalListeningSessions: $totalListeningSessions, totalListeningTime: $totalListeningTime, totalBookListeningTime: $totalBookListeningTime, totalPodcastListeningTime: $totalPodcastListeningTime, topAuthors: $topAuthors, topGenres: $topGenres, mostListenedNarrator: $mostListenedNarrator, mostListenedMonth: $mostListenedMonth, numBooksFinished: $numBooksFinished, numBooksListened: $numBooksListened, longestAudiobookFinished: $longestAudiobookFinished, booksWithCovers: $booksWithCovers, finishedBooksWithCovers: $finishedBooksWithCovers, numListeningSessions: $numListeningSessions, numBooksAdded: $numBooksAdded, numAuthorsAdded: $numAuthorsAdded, totalBooksAddedSize: $totalBooksAddedSize, totalBooksAddedDuration: $totalBooksAddedDuration, booksAddedWithCovers: $booksAddedWithCovers, totalBooksSize: $totalBooksSize, totalBooksDuration: $totalBooksDuration, numBooks: $numBooks, topNarrators: $topNarrators)';
}


}

/// @nodoc
abstract mixin class $YearInReviewStatsCopyWith<$Res>  {
  factory $YearInReviewStatsCopyWith(YearInReviewStats value, $Res Function(YearInReviewStats) _then) = _$YearInReviewStatsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'totalListeningSessions', fromJson: jsonIntFromDynamic) int? totalListeningSessions,@JsonKey(name: 'totalListeningTime', fromJson: jsonIntFromDynamic) int? totalListeningTime,@JsonKey(name: 'totalBookListeningTime', fromJson: jsonIntFromDynamic) int? totalBookListeningTime,@JsonKey(name: 'totalPodcastListeningTime', fromJson: jsonIntFromDynamic) int? totalPodcastListeningTime,@JsonKey(name: 'topAuthors') List<YearInReviewNamedStat> topAuthors,@JsonKey(name: 'topGenres') List<YearInReviewGenreStat> topGenres,@JsonKey(name: 'mostListenedNarrator') YearInReviewNamedStat? mostListenedNarrator,@JsonKey(name: 'mostListenedMonth') YearInReviewMonthStat? mostListenedMonth,@JsonKey(name: 'numBooksFinished', fromJson: jsonIntFromDynamic) int? numBooksFinished,@JsonKey(name: 'numBooksListened', fromJson: jsonIntFromDynamic) int? numBooksListened,@JsonKey(name: 'longestAudiobookFinished') YearInReviewBookStat? longestAudiobookFinished,@JsonKey(name: 'booksWithCovers') List<String> booksWithCovers,@JsonKey(name: 'finishedBooksWithCovers') List<String> finishedBooksWithCovers,@JsonKey(name: 'numListeningSessions', fromJson: jsonIntFromDynamic) int? numListeningSessions,@JsonKey(name: 'numBooksAdded', fromJson: jsonIntFromDynamic) int? numBooksAdded,@JsonKey(name: 'numAuthorsAdded', fromJson: jsonIntFromDynamic) int? numAuthorsAdded,@JsonKey(name: 'totalBooksAddedSize', fromJson: jsonIntFromDynamic) int? totalBooksAddedSize,@JsonKey(name: 'totalBooksAddedDuration', fromJson: jsonIntFromDynamic) int? totalBooksAddedDuration,@JsonKey(name: 'booksAddedWithCovers') List<String> booksAddedWithCovers,@JsonKey(name: 'totalBooksSize', fromJson: jsonIntFromDynamic) int? totalBooksSize,@JsonKey(name: 'totalBooksDuration', fromJson: jsonIntFromDynamic) int? totalBooksDuration,@JsonKey(name: 'numBooks', fromJson: jsonIntFromDynamic) int? numBooks,@JsonKey(name: 'topNarrators') List<YearInReviewNamedStat> topNarrators
});


$YearInReviewNamedStatCopyWith<$Res>? get mostListenedNarrator;$YearInReviewMonthStatCopyWith<$Res>? get mostListenedMonth;$YearInReviewBookStatCopyWith<$Res>? get longestAudiobookFinished;

}
/// @nodoc
class _$YearInReviewStatsCopyWithImpl<$Res>
    implements $YearInReviewStatsCopyWith<$Res> {
  _$YearInReviewStatsCopyWithImpl(this._self, this._then);

  final YearInReviewStats _self;
  final $Res Function(YearInReviewStats) _then;

/// Create a copy of YearInReviewStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalListeningSessions = freezed,Object? totalListeningTime = freezed,Object? totalBookListeningTime = freezed,Object? totalPodcastListeningTime = freezed,Object? topAuthors = null,Object? topGenres = null,Object? mostListenedNarrator = freezed,Object? mostListenedMonth = freezed,Object? numBooksFinished = freezed,Object? numBooksListened = freezed,Object? longestAudiobookFinished = freezed,Object? booksWithCovers = null,Object? finishedBooksWithCovers = null,Object? numListeningSessions = freezed,Object? numBooksAdded = freezed,Object? numAuthorsAdded = freezed,Object? totalBooksAddedSize = freezed,Object? totalBooksAddedDuration = freezed,Object? booksAddedWithCovers = null,Object? totalBooksSize = freezed,Object? totalBooksDuration = freezed,Object? numBooks = freezed,Object? topNarrators = null,}) {
  return _then(_self.copyWith(
totalListeningSessions: freezed == totalListeningSessions ? _self.totalListeningSessions : totalListeningSessions // ignore: cast_nullable_to_non_nullable
as int?,totalListeningTime: freezed == totalListeningTime ? _self.totalListeningTime : totalListeningTime // ignore: cast_nullable_to_non_nullable
as int?,totalBookListeningTime: freezed == totalBookListeningTime ? _self.totalBookListeningTime : totalBookListeningTime // ignore: cast_nullable_to_non_nullable
as int?,totalPodcastListeningTime: freezed == totalPodcastListeningTime ? _self.totalPodcastListeningTime : totalPodcastListeningTime // ignore: cast_nullable_to_non_nullable
as int?,topAuthors: null == topAuthors ? _self.topAuthors : topAuthors // ignore: cast_nullable_to_non_nullable
as List<YearInReviewNamedStat>,topGenres: null == topGenres ? _self.topGenres : topGenres // ignore: cast_nullable_to_non_nullable
as List<YearInReviewGenreStat>,mostListenedNarrator: freezed == mostListenedNarrator ? _self.mostListenedNarrator : mostListenedNarrator // ignore: cast_nullable_to_non_nullable
as YearInReviewNamedStat?,mostListenedMonth: freezed == mostListenedMonth ? _self.mostListenedMonth : mostListenedMonth // ignore: cast_nullable_to_non_nullable
as YearInReviewMonthStat?,numBooksFinished: freezed == numBooksFinished ? _self.numBooksFinished : numBooksFinished // ignore: cast_nullable_to_non_nullable
as int?,numBooksListened: freezed == numBooksListened ? _self.numBooksListened : numBooksListened // ignore: cast_nullable_to_non_nullable
as int?,longestAudiobookFinished: freezed == longestAudiobookFinished ? _self.longestAudiobookFinished : longestAudiobookFinished // ignore: cast_nullable_to_non_nullable
as YearInReviewBookStat?,booksWithCovers: null == booksWithCovers ? _self.booksWithCovers : booksWithCovers // ignore: cast_nullable_to_non_nullable
as List<String>,finishedBooksWithCovers: null == finishedBooksWithCovers ? _self.finishedBooksWithCovers : finishedBooksWithCovers // ignore: cast_nullable_to_non_nullable
as List<String>,numListeningSessions: freezed == numListeningSessions ? _self.numListeningSessions : numListeningSessions // ignore: cast_nullable_to_non_nullable
as int?,numBooksAdded: freezed == numBooksAdded ? _self.numBooksAdded : numBooksAdded // ignore: cast_nullable_to_non_nullable
as int?,numAuthorsAdded: freezed == numAuthorsAdded ? _self.numAuthorsAdded : numAuthorsAdded // ignore: cast_nullable_to_non_nullable
as int?,totalBooksAddedSize: freezed == totalBooksAddedSize ? _self.totalBooksAddedSize : totalBooksAddedSize // ignore: cast_nullable_to_non_nullable
as int?,totalBooksAddedDuration: freezed == totalBooksAddedDuration ? _self.totalBooksAddedDuration : totalBooksAddedDuration // ignore: cast_nullable_to_non_nullable
as int?,booksAddedWithCovers: null == booksAddedWithCovers ? _self.booksAddedWithCovers : booksAddedWithCovers // ignore: cast_nullable_to_non_nullable
as List<String>,totalBooksSize: freezed == totalBooksSize ? _self.totalBooksSize : totalBooksSize // ignore: cast_nullable_to_non_nullable
as int?,totalBooksDuration: freezed == totalBooksDuration ? _self.totalBooksDuration : totalBooksDuration // ignore: cast_nullable_to_non_nullable
as int?,numBooks: freezed == numBooks ? _self.numBooks : numBooks // ignore: cast_nullable_to_non_nullable
as int?,topNarrators: null == topNarrators ? _self.topNarrators : topNarrators // ignore: cast_nullable_to_non_nullable
as List<YearInReviewNamedStat>,
  ));
}
/// Create a copy of YearInReviewStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$YearInReviewNamedStatCopyWith<$Res>? get mostListenedNarrator {
    if (_self.mostListenedNarrator == null) {
    return null;
  }

  return $YearInReviewNamedStatCopyWith<$Res>(_self.mostListenedNarrator!, (value) {
    return _then(_self.copyWith(mostListenedNarrator: value));
  });
}/// Create a copy of YearInReviewStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$YearInReviewMonthStatCopyWith<$Res>? get mostListenedMonth {
    if (_self.mostListenedMonth == null) {
    return null;
  }

  return $YearInReviewMonthStatCopyWith<$Res>(_self.mostListenedMonth!, (value) {
    return _then(_self.copyWith(mostListenedMonth: value));
  });
}/// Create a copy of YearInReviewStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$YearInReviewBookStatCopyWith<$Res>? get longestAudiobookFinished {
    if (_self.longestAudiobookFinished == null) {
    return null;
  }

  return $YearInReviewBookStatCopyWith<$Res>(_self.longestAudiobookFinished!, (value) {
    return _then(_self.copyWith(longestAudiobookFinished: value));
  });
}
}


/// Adds pattern-matching-related methods to [YearInReviewStats].
extension YearInReviewStatsPatterns on YearInReviewStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _YearInReviewStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _YearInReviewStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _YearInReviewStats value)  $default,){
final _that = this;
switch (_that) {
case _YearInReviewStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _YearInReviewStats value)?  $default,){
final _that = this;
switch (_that) {
case _YearInReviewStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'totalListeningSessions', fromJson: jsonIntFromDynamic)  int? totalListeningSessions, @JsonKey(name: 'totalListeningTime', fromJson: jsonIntFromDynamic)  int? totalListeningTime, @JsonKey(name: 'totalBookListeningTime', fromJson: jsonIntFromDynamic)  int? totalBookListeningTime, @JsonKey(name: 'totalPodcastListeningTime', fromJson: jsonIntFromDynamic)  int? totalPodcastListeningTime, @JsonKey(name: 'topAuthors')  List<YearInReviewNamedStat> topAuthors, @JsonKey(name: 'topGenres')  List<YearInReviewGenreStat> topGenres, @JsonKey(name: 'mostListenedNarrator')  YearInReviewNamedStat? mostListenedNarrator, @JsonKey(name: 'mostListenedMonth')  YearInReviewMonthStat? mostListenedMonth, @JsonKey(name: 'numBooksFinished', fromJson: jsonIntFromDynamic)  int? numBooksFinished, @JsonKey(name: 'numBooksListened', fromJson: jsonIntFromDynamic)  int? numBooksListened, @JsonKey(name: 'longestAudiobookFinished')  YearInReviewBookStat? longestAudiobookFinished, @JsonKey(name: 'booksWithCovers')  List<String> booksWithCovers, @JsonKey(name: 'finishedBooksWithCovers')  List<String> finishedBooksWithCovers, @JsonKey(name: 'numListeningSessions', fromJson: jsonIntFromDynamic)  int? numListeningSessions, @JsonKey(name: 'numBooksAdded', fromJson: jsonIntFromDynamic)  int? numBooksAdded, @JsonKey(name: 'numAuthorsAdded', fromJson: jsonIntFromDynamic)  int? numAuthorsAdded, @JsonKey(name: 'totalBooksAddedSize', fromJson: jsonIntFromDynamic)  int? totalBooksAddedSize, @JsonKey(name: 'totalBooksAddedDuration', fromJson: jsonIntFromDynamic)  int? totalBooksAddedDuration, @JsonKey(name: 'booksAddedWithCovers')  List<String> booksAddedWithCovers, @JsonKey(name: 'totalBooksSize', fromJson: jsonIntFromDynamic)  int? totalBooksSize, @JsonKey(name: 'totalBooksDuration', fromJson: jsonIntFromDynamic)  int? totalBooksDuration, @JsonKey(name: 'numBooks', fromJson: jsonIntFromDynamic)  int? numBooks, @JsonKey(name: 'topNarrators')  List<YearInReviewNamedStat> topNarrators)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _YearInReviewStats() when $default != null:
return $default(_that.totalListeningSessions,_that.totalListeningTime,_that.totalBookListeningTime,_that.totalPodcastListeningTime,_that.topAuthors,_that.topGenres,_that.mostListenedNarrator,_that.mostListenedMonth,_that.numBooksFinished,_that.numBooksListened,_that.longestAudiobookFinished,_that.booksWithCovers,_that.finishedBooksWithCovers,_that.numListeningSessions,_that.numBooksAdded,_that.numAuthorsAdded,_that.totalBooksAddedSize,_that.totalBooksAddedDuration,_that.booksAddedWithCovers,_that.totalBooksSize,_that.totalBooksDuration,_that.numBooks,_that.topNarrators);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'totalListeningSessions', fromJson: jsonIntFromDynamic)  int? totalListeningSessions, @JsonKey(name: 'totalListeningTime', fromJson: jsonIntFromDynamic)  int? totalListeningTime, @JsonKey(name: 'totalBookListeningTime', fromJson: jsonIntFromDynamic)  int? totalBookListeningTime, @JsonKey(name: 'totalPodcastListeningTime', fromJson: jsonIntFromDynamic)  int? totalPodcastListeningTime, @JsonKey(name: 'topAuthors')  List<YearInReviewNamedStat> topAuthors, @JsonKey(name: 'topGenres')  List<YearInReviewGenreStat> topGenres, @JsonKey(name: 'mostListenedNarrator')  YearInReviewNamedStat? mostListenedNarrator, @JsonKey(name: 'mostListenedMonth')  YearInReviewMonthStat? mostListenedMonth, @JsonKey(name: 'numBooksFinished', fromJson: jsonIntFromDynamic)  int? numBooksFinished, @JsonKey(name: 'numBooksListened', fromJson: jsonIntFromDynamic)  int? numBooksListened, @JsonKey(name: 'longestAudiobookFinished')  YearInReviewBookStat? longestAudiobookFinished, @JsonKey(name: 'booksWithCovers')  List<String> booksWithCovers, @JsonKey(name: 'finishedBooksWithCovers')  List<String> finishedBooksWithCovers, @JsonKey(name: 'numListeningSessions', fromJson: jsonIntFromDynamic)  int? numListeningSessions, @JsonKey(name: 'numBooksAdded', fromJson: jsonIntFromDynamic)  int? numBooksAdded, @JsonKey(name: 'numAuthorsAdded', fromJson: jsonIntFromDynamic)  int? numAuthorsAdded, @JsonKey(name: 'totalBooksAddedSize', fromJson: jsonIntFromDynamic)  int? totalBooksAddedSize, @JsonKey(name: 'totalBooksAddedDuration', fromJson: jsonIntFromDynamic)  int? totalBooksAddedDuration, @JsonKey(name: 'booksAddedWithCovers')  List<String> booksAddedWithCovers, @JsonKey(name: 'totalBooksSize', fromJson: jsonIntFromDynamic)  int? totalBooksSize, @JsonKey(name: 'totalBooksDuration', fromJson: jsonIntFromDynamic)  int? totalBooksDuration, @JsonKey(name: 'numBooks', fromJson: jsonIntFromDynamic)  int? numBooks, @JsonKey(name: 'topNarrators')  List<YearInReviewNamedStat> topNarrators)  $default,) {final _that = this;
switch (_that) {
case _YearInReviewStats():
return $default(_that.totalListeningSessions,_that.totalListeningTime,_that.totalBookListeningTime,_that.totalPodcastListeningTime,_that.topAuthors,_that.topGenres,_that.mostListenedNarrator,_that.mostListenedMonth,_that.numBooksFinished,_that.numBooksListened,_that.longestAudiobookFinished,_that.booksWithCovers,_that.finishedBooksWithCovers,_that.numListeningSessions,_that.numBooksAdded,_that.numAuthorsAdded,_that.totalBooksAddedSize,_that.totalBooksAddedDuration,_that.booksAddedWithCovers,_that.totalBooksSize,_that.totalBooksDuration,_that.numBooks,_that.topNarrators);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'totalListeningSessions', fromJson: jsonIntFromDynamic)  int? totalListeningSessions, @JsonKey(name: 'totalListeningTime', fromJson: jsonIntFromDynamic)  int? totalListeningTime, @JsonKey(name: 'totalBookListeningTime', fromJson: jsonIntFromDynamic)  int? totalBookListeningTime, @JsonKey(name: 'totalPodcastListeningTime', fromJson: jsonIntFromDynamic)  int? totalPodcastListeningTime, @JsonKey(name: 'topAuthors')  List<YearInReviewNamedStat> topAuthors, @JsonKey(name: 'topGenres')  List<YearInReviewGenreStat> topGenres, @JsonKey(name: 'mostListenedNarrator')  YearInReviewNamedStat? mostListenedNarrator, @JsonKey(name: 'mostListenedMonth')  YearInReviewMonthStat? mostListenedMonth, @JsonKey(name: 'numBooksFinished', fromJson: jsonIntFromDynamic)  int? numBooksFinished, @JsonKey(name: 'numBooksListened', fromJson: jsonIntFromDynamic)  int? numBooksListened, @JsonKey(name: 'longestAudiobookFinished')  YearInReviewBookStat? longestAudiobookFinished, @JsonKey(name: 'booksWithCovers')  List<String> booksWithCovers, @JsonKey(name: 'finishedBooksWithCovers')  List<String> finishedBooksWithCovers, @JsonKey(name: 'numListeningSessions', fromJson: jsonIntFromDynamic)  int? numListeningSessions, @JsonKey(name: 'numBooksAdded', fromJson: jsonIntFromDynamic)  int? numBooksAdded, @JsonKey(name: 'numAuthorsAdded', fromJson: jsonIntFromDynamic)  int? numAuthorsAdded, @JsonKey(name: 'totalBooksAddedSize', fromJson: jsonIntFromDynamic)  int? totalBooksAddedSize, @JsonKey(name: 'totalBooksAddedDuration', fromJson: jsonIntFromDynamic)  int? totalBooksAddedDuration, @JsonKey(name: 'booksAddedWithCovers')  List<String> booksAddedWithCovers, @JsonKey(name: 'totalBooksSize', fromJson: jsonIntFromDynamic)  int? totalBooksSize, @JsonKey(name: 'totalBooksDuration', fromJson: jsonIntFromDynamic)  int? totalBooksDuration, @JsonKey(name: 'numBooks', fromJson: jsonIntFromDynamic)  int? numBooks, @JsonKey(name: 'topNarrators')  List<YearInReviewNamedStat> topNarrators)?  $default,) {final _that = this;
switch (_that) {
case _YearInReviewStats() when $default != null:
return $default(_that.totalListeningSessions,_that.totalListeningTime,_that.totalBookListeningTime,_that.totalPodcastListeningTime,_that.topAuthors,_that.topGenres,_that.mostListenedNarrator,_that.mostListenedMonth,_that.numBooksFinished,_that.numBooksListened,_that.longestAudiobookFinished,_that.booksWithCovers,_that.finishedBooksWithCovers,_that.numListeningSessions,_that.numBooksAdded,_that.numAuthorsAdded,_that.totalBooksAddedSize,_that.totalBooksAddedDuration,_that.booksAddedWithCovers,_that.totalBooksSize,_that.totalBooksDuration,_that.numBooks,_that.topNarrators);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _YearInReviewStats implements YearInReviewStats {
  const _YearInReviewStats({@JsonKey(name: 'totalListeningSessions', fromJson: jsonIntFromDynamic) this.totalListeningSessions, @JsonKey(name: 'totalListeningTime', fromJson: jsonIntFromDynamic) this.totalListeningTime, @JsonKey(name: 'totalBookListeningTime', fromJson: jsonIntFromDynamic) this.totalBookListeningTime, @JsonKey(name: 'totalPodcastListeningTime', fromJson: jsonIntFromDynamic) this.totalPodcastListeningTime, @JsonKey(name: 'topAuthors') final  List<YearInReviewNamedStat> topAuthors = const <YearInReviewNamedStat>[], @JsonKey(name: 'topGenres') final  List<YearInReviewGenreStat> topGenres = const <YearInReviewGenreStat>[], @JsonKey(name: 'mostListenedNarrator') this.mostListenedNarrator, @JsonKey(name: 'mostListenedMonth') this.mostListenedMonth, @JsonKey(name: 'numBooksFinished', fromJson: jsonIntFromDynamic) this.numBooksFinished, @JsonKey(name: 'numBooksListened', fromJson: jsonIntFromDynamic) this.numBooksListened, @JsonKey(name: 'longestAudiobookFinished') this.longestAudiobookFinished, @JsonKey(name: 'booksWithCovers') final  List<String> booksWithCovers = const <String>[], @JsonKey(name: 'finishedBooksWithCovers') final  List<String> finishedBooksWithCovers = const <String>[], @JsonKey(name: 'numListeningSessions', fromJson: jsonIntFromDynamic) this.numListeningSessions, @JsonKey(name: 'numBooksAdded', fromJson: jsonIntFromDynamic) this.numBooksAdded, @JsonKey(name: 'numAuthorsAdded', fromJson: jsonIntFromDynamic) this.numAuthorsAdded, @JsonKey(name: 'totalBooksAddedSize', fromJson: jsonIntFromDynamic) this.totalBooksAddedSize, @JsonKey(name: 'totalBooksAddedDuration', fromJson: jsonIntFromDynamic) this.totalBooksAddedDuration, @JsonKey(name: 'booksAddedWithCovers') final  List<String> booksAddedWithCovers = const <String>[], @JsonKey(name: 'totalBooksSize', fromJson: jsonIntFromDynamic) this.totalBooksSize, @JsonKey(name: 'totalBooksDuration', fromJson: jsonIntFromDynamic) this.totalBooksDuration, @JsonKey(name: 'numBooks', fromJson: jsonIntFromDynamic) this.numBooks, @JsonKey(name: 'topNarrators') final  List<YearInReviewNamedStat> topNarrators = const <YearInReviewNamedStat>[]}): _topAuthors = topAuthors,_topGenres = topGenres,_booksWithCovers = booksWithCovers,_finishedBooksWithCovers = finishedBooksWithCovers,_booksAddedWithCovers = booksAddedWithCovers,_topNarrators = topNarrators;
  factory _YearInReviewStats.fromJson(Map<String, dynamic> json) => _$YearInReviewStatsFromJson(json);

@override@JsonKey(name: 'totalListeningSessions', fromJson: jsonIntFromDynamic) final  int? totalListeningSessions;
@override@JsonKey(name: 'totalListeningTime', fromJson: jsonIntFromDynamic) final  int? totalListeningTime;
@override@JsonKey(name: 'totalBookListeningTime', fromJson: jsonIntFromDynamic) final  int? totalBookListeningTime;
@override@JsonKey(name: 'totalPodcastListeningTime', fromJson: jsonIntFromDynamic) final  int? totalPodcastListeningTime;
 final  List<YearInReviewNamedStat> _topAuthors;
@override@JsonKey(name: 'topAuthors') List<YearInReviewNamedStat> get topAuthors {
  if (_topAuthors is EqualUnmodifiableListView) return _topAuthors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topAuthors);
}

 final  List<YearInReviewGenreStat> _topGenres;
@override@JsonKey(name: 'topGenres') List<YearInReviewGenreStat> get topGenres {
  if (_topGenres is EqualUnmodifiableListView) return _topGenres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topGenres);
}

@override@JsonKey(name: 'mostListenedNarrator') final  YearInReviewNamedStat? mostListenedNarrator;
@override@JsonKey(name: 'mostListenedMonth') final  YearInReviewMonthStat? mostListenedMonth;
@override@JsonKey(name: 'numBooksFinished', fromJson: jsonIntFromDynamic) final  int? numBooksFinished;
@override@JsonKey(name: 'numBooksListened', fromJson: jsonIntFromDynamic) final  int? numBooksListened;
@override@JsonKey(name: 'longestAudiobookFinished') final  YearInReviewBookStat? longestAudiobookFinished;
 final  List<String> _booksWithCovers;
@override@JsonKey(name: 'booksWithCovers') List<String> get booksWithCovers {
  if (_booksWithCovers is EqualUnmodifiableListView) return _booksWithCovers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_booksWithCovers);
}

 final  List<String> _finishedBooksWithCovers;
@override@JsonKey(name: 'finishedBooksWithCovers') List<String> get finishedBooksWithCovers {
  if (_finishedBooksWithCovers is EqualUnmodifiableListView) return _finishedBooksWithCovers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_finishedBooksWithCovers);
}

@override@JsonKey(name: 'numListeningSessions', fromJson: jsonIntFromDynamic) final  int? numListeningSessions;
@override@JsonKey(name: 'numBooksAdded', fromJson: jsonIntFromDynamic) final  int? numBooksAdded;
@override@JsonKey(name: 'numAuthorsAdded', fromJson: jsonIntFromDynamic) final  int? numAuthorsAdded;
@override@JsonKey(name: 'totalBooksAddedSize', fromJson: jsonIntFromDynamic) final  int? totalBooksAddedSize;
@override@JsonKey(name: 'totalBooksAddedDuration', fromJson: jsonIntFromDynamic) final  int? totalBooksAddedDuration;
 final  List<String> _booksAddedWithCovers;
@override@JsonKey(name: 'booksAddedWithCovers') List<String> get booksAddedWithCovers {
  if (_booksAddedWithCovers is EqualUnmodifiableListView) return _booksAddedWithCovers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_booksAddedWithCovers);
}

@override@JsonKey(name: 'totalBooksSize', fromJson: jsonIntFromDynamic) final  int? totalBooksSize;
@override@JsonKey(name: 'totalBooksDuration', fromJson: jsonIntFromDynamic) final  int? totalBooksDuration;
@override@JsonKey(name: 'numBooks', fromJson: jsonIntFromDynamic) final  int? numBooks;
 final  List<YearInReviewNamedStat> _topNarrators;
@override@JsonKey(name: 'topNarrators') List<YearInReviewNamedStat> get topNarrators {
  if (_topNarrators is EqualUnmodifiableListView) return _topNarrators;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topNarrators);
}


/// Create a copy of YearInReviewStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YearInReviewStatsCopyWith<_YearInReviewStats> get copyWith => __$YearInReviewStatsCopyWithImpl<_YearInReviewStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$YearInReviewStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _YearInReviewStats&&(identical(other.totalListeningSessions, totalListeningSessions) || other.totalListeningSessions == totalListeningSessions)&&(identical(other.totalListeningTime, totalListeningTime) || other.totalListeningTime == totalListeningTime)&&(identical(other.totalBookListeningTime, totalBookListeningTime) || other.totalBookListeningTime == totalBookListeningTime)&&(identical(other.totalPodcastListeningTime, totalPodcastListeningTime) || other.totalPodcastListeningTime == totalPodcastListeningTime)&&const DeepCollectionEquality().equals(other._topAuthors, _topAuthors)&&const DeepCollectionEquality().equals(other._topGenres, _topGenres)&&(identical(other.mostListenedNarrator, mostListenedNarrator) || other.mostListenedNarrator == mostListenedNarrator)&&(identical(other.mostListenedMonth, mostListenedMonth) || other.mostListenedMonth == mostListenedMonth)&&(identical(other.numBooksFinished, numBooksFinished) || other.numBooksFinished == numBooksFinished)&&(identical(other.numBooksListened, numBooksListened) || other.numBooksListened == numBooksListened)&&(identical(other.longestAudiobookFinished, longestAudiobookFinished) || other.longestAudiobookFinished == longestAudiobookFinished)&&const DeepCollectionEquality().equals(other._booksWithCovers, _booksWithCovers)&&const DeepCollectionEquality().equals(other._finishedBooksWithCovers, _finishedBooksWithCovers)&&(identical(other.numListeningSessions, numListeningSessions) || other.numListeningSessions == numListeningSessions)&&(identical(other.numBooksAdded, numBooksAdded) || other.numBooksAdded == numBooksAdded)&&(identical(other.numAuthorsAdded, numAuthorsAdded) || other.numAuthorsAdded == numAuthorsAdded)&&(identical(other.totalBooksAddedSize, totalBooksAddedSize) || other.totalBooksAddedSize == totalBooksAddedSize)&&(identical(other.totalBooksAddedDuration, totalBooksAddedDuration) || other.totalBooksAddedDuration == totalBooksAddedDuration)&&const DeepCollectionEquality().equals(other._booksAddedWithCovers, _booksAddedWithCovers)&&(identical(other.totalBooksSize, totalBooksSize) || other.totalBooksSize == totalBooksSize)&&(identical(other.totalBooksDuration, totalBooksDuration) || other.totalBooksDuration == totalBooksDuration)&&(identical(other.numBooks, numBooks) || other.numBooks == numBooks)&&const DeepCollectionEquality().equals(other._topNarrators, _topNarrators));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,totalListeningSessions,totalListeningTime,totalBookListeningTime,totalPodcastListeningTime,const DeepCollectionEquality().hash(_topAuthors),const DeepCollectionEquality().hash(_topGenres),mostListenedNarrator,mostListenedMonth,numBooksFinished,numBooksListened,longestAudiobookFinished,const DeepCollectionEquality().hash(_booksWithCovers),const DeepCollectionEquality().hash(_finishedBooksWithCovers),numListeningSessions,numBooksAdded,numAuthorsAdded,totalBooksAddedSize,totalBooksAddedDuration,const DeepCollectionEquality().hash(_booksAddedWithCovers),totalBooksSize,totalBooksDuration,numBooks,const DeepCollectionEquality().hash(_topNarrators)]);

@override
String toString() {
  return 'YearInReviewStats(totalListeningSessions: $totalListeningSessions, totalListeningTime: $totalListeningTime, totalBookListeningTime: $totalBookListeningTime, totalPodcastListeningTime: $totalPodcastListeningTime, topAuthors: $topAuthors, topGenres: $topGenres, mostListenedNarrator: $mostListenedNarrator, mostListenedMonth: $mostListenedMonth, numBooksFinished: $numBooksFinished, numBooksListened: $numBooksListened, longestAudiobookFinished: $longestAudiobookFinished, booksWithCovers: $booksWithCovers, finishedBooksWithCovers: $finishedBooksWithCovers, numListeningSessions: $numListeningSessions, numBooksAdded: $numBooksAdded, numAuthorsAdded: $numAuthorsAdded, totalBooksAddedSize: $totalBooksAddedSize, totalBooksAddedDuration: $totalBooksAddedDuration, booksAddedWithCovers: $booksAddedWithCovers, totalBooksSize: $totalBooksSize, totalBooksDuration: $totalBooksDuration, numBooks: $numBooks, topNarrators: $topNarrators)';
}


}

/// @nodoc
abstract mixin class _$YearInReviewStatsCopyWith<$Res> implements $YearInReviewStatsCopyWith<$Res> {
  factory _$YearInReviewStatsCopyWith(_YearInReviewStats value, $Res Function(_YearInReviewStats) _then) = __$YearInReviewStatsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'totalListeningSessions', fromJson: jsonIntFromDynamic) int? totalListeningSessions,@JsonKey(name: 'totalListeningTime', fromJson: jsonIntFromDynamic) int? totalListeningTime,@JsonKey(name: 'totalBookListeningTime', fromJson: jsonIntFromDynamic) int? totalBookListeningTime,@JsonKey(name: 'totalPodcastListeningTime', fromJson: jsonIntFromDynamic) int? totalPodcastListeningTime,@JsonKey(name: 'topAuthors') List<YearInReviewNamedStat> topAuthors,@JsonKey(name: 'topGenres') List<YearInReviewGenreStat> topGenres,@JsonKey(name: 'mostListenedNarrator') YearInReviewNamedStat? mostListenedNarrator,@JsonKey(name: 'mostListenedMonth') YearInReviewMonthStat? mostListenedMonth,@JsonKey(name: 'numBooksFinished', fromJson: jsonIntFromDynamic) int? numBooksFinished,@JsonKey(name: 'numBooksListened', fromJson: jsonIntFromDynamic) int? numBooksListened,@JsonKey(name: 'longestAudiobookFinished') YearInReviewBookStat? longestAudiobookFinished,@JsonKey(name: 'booksWithCovers') List<String> booksWithCovers,@JsonKey(name: 'finishedBooksWithCovers') List<String> finishedBooksWithCovers,@JsonKey(name: 'numListeningSessions', fromJson: jsonIntFromDynamic) int? numListeningSessions,@JsonKey(name: 'numBooksAdded', fromJson: jsonIntFromDynamic) int? numBooksAdded,@JsonKey(name: 'numAuthorsAdded', fromJson: jsonIntFromDynamic) int? numAuthorsAdded,@JsonKey(name: 'totalBooksAddedSize', fromJson: jsonIntFromDynamic) int? totalBooksAddedSize,@JsonKey(name: 'totalBooksAddedDuration', fromJson: jsonIntFromDynamic) int? totalBooksAddedDuration,@JsonKey(name: 'booksAddedWithCovers') List<String> booksAddedWithCovers,@JsonKey(name: 'totalBooksSize', fromJson: jsonIntFromDynamic) int? totalBooksSize,@JsonKey(name: 'totalBooksDuration', fromJson: jsonIntFromDynamic) int? totalBooksDuration,@JsonKey(name: 'numBooks', fromJson: jsonIntFromDynamic) int? numBooks,@JsonKey(name: 'topNarrators') List<YearInReviewNamedStat> topNarrators
});


@override $YearInReviewNamedStatCopyWith<$Res>? get mostListenedNarrator;@override $YearInReviewMonthStatCopyWith<$Res>? get mostListenedMonth;@override $YearInReviewBookStatCopyWith<$Res>? get longestAudiobookFinished;

}
/// @nodoc
class __$YearInReviewStatsCopyWithImpl<$Res>
    implements _$YearInReviewStatsCopyWith<$Res> {
  __$YearInReviewStatsCopyWithImpl(this._self, this._then);

  final _YearInReviewStats _self;
  final $Res Function(_YearInReviewStats) _then;

/// Create a copy of YearInReviewStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalListeningSessions = freezed,Object? totalListeningTime = freezed,Object? totalBookListeningTime = freezed,Object? totalPodcastListeningTime = freezed,Object? topAuthors = null,Object? topGenres = null,Object? mostListenedNarrator = freezed,Object? mostListenedMonth = freezed,Object? numBooksFinished = freezed,Object? numBooksListened = freezed,Object? longestAudiobookFinished = freezed,Object? booksWithCovers = null,Object? finishedBooksWithCovers = null,Object? numListeningSessions = freezed,Object? numBooksAdded = freezed,Object? numAuthorsAdded = freezed,Object? totalBooksAddedSize = freezed,Object? totalBooksAddedDuration = freezed,Object? booksAddedWithCovers = null,Object? totalBooksSize = freezed,Object? totalBooksDuration = freezed,Object? numBooks = freezed,Object? topNarrators = null,}) {
  return _then(_YearInReviewStats(
totalListeningSessions: freezed == totalListeningSessions ? _self.totalListeningSessions : totalListeningSessions // ignore: cast_nullable_to_non_nullable
as int?,totalListeningTime: freezed == totalListeningTime ? _self.totalListeningTime : totalListeningTime // ignore: cast_nullable_to_non_nullable
as int?,totalBookListeningTime: freezed == totalBookListeningTime ? _self.totalBookListeningTime : totalBookListeningTime // ignore: cast_nullable_to_non_nullable
as int?,totalPodcastListeningTime: freezed == totalPodcastListeningTime ? _self.totalPodcastListeningTime : totalPodcastListeningTime // ignore: cast_nullable_to_non_nullable
as int?,topAuthors: null == topAuthors ? _self._topAuthors : topAuthors // ignore: cast_nullable_to_non_nullable
as List<YearInReviewNamedStat>,topGenres: null == topGenres ? _self._topGenres : topGenres // ignore: cast_nullable_to_non_nullable
as List<YearInReviewGenreStat>,mostListenedNarrator: freezed == mostListenedNarrator ? _self.mostListenedNarrator : mostListenedNarrator // ignore: cast_nullable_to_non_nullable
as YearInReviewNamedStat?,mostListenedMonth: freezed == mostListenedMonth ? _self.mostListenedMonth : mostListenedMonth // ignore: cast_nullable_to_non_nullable
as YearInReviewMonthStat?,numBooksFinished: freezed == numBooksFinished ? _self.numBooksFinished : numBooksFinished // ignore: cast_nullable_to_non_nullable
as int?,numBooksListened: freezed == numBooksListened ? _self.numBooksListened : numBooksListened // ignore: cast_nullable_to_non_nullable
as int?,longestAudiobookFinished: freezed == longestAudiobookFinished ? _self.longestAudiobookFinished : longestAudiobookFinished // ignore: cast_nullable_to_non_nullable
as YearInReviewBookStat?,booksWithCovers: null == booksWithCovers ? _self._booksWithCovers : booksWithCovers // ignore: cast_nullable_to_non_nullable
as List<String>,finishedBooksWithCovers: null == finishedBooksWithCovers ? _self._finishedBooksWithCovers : finishedBooksWithCovers // ignore: cast_nullable_to_non_nullable
as List<String>,numListeningSessions: freezed == numListeningSessions ? _self.numListeningSessions : numListeningSessions // ignore: cast_nullable_to_non_nullable
as int?,numBooksAdded: freezed == numBooksAdded ? _self.numBooksAdded : numBooksAdded // ignore: cast_nullable_to_non_nullable
as int?,numAuthorsAdded: freezed == numAuthorsAdded ? _self.numAuthorsAdded : numAuthorsAdded // ignore: cast_nullable_to_non_nullable
as int?,totalBooksAddedSize: freezed == totalBooksAddedSize ? _self.totalBooksAddedSize : totalBooksAddedSize // ignore: cast_nullable_to_non_nullable
as int?,totalBooksAddedDuration: freezed == totalBooksAddedDuration ? _self.totalBooksAddedDuration : totalBooksAddedDuration // ignore: cast_nullable_to_non_nullable
as int?,booksAddedWithCovers: null == booksAddedWithCovers ? _self._booksAddedWithCovers : booksAddedWithCovers // ignore: cast_nullable_to_non_nullable
as List<String>,totalBooksSize: freezed == totalBooksSize ? _self.totalBooksSize : totalBooksSize // ignore: cast_nullable_to_non_nullable
as int?,totalBooksDuration: freezed == totalBooksDuration ? _self.totalBooksDuration : totalBooksDuration // ignore: cast_nullable_to_non_nullable
as int?,numBooks: freezed == numBooks ? _self.numBooks : numBooks // ignore: cast_nullable_to_non_nullable
as int?,topNarrators: null == topNarrators ? _self._topNarrators : topNarrators // ignore: cast_nullable_to_non_nullable
as List<YearInReviewNamedStat>,
  ));
}

/// Create a copy of YearInReviewStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$YearInReviewNamedStatCopyWith<$Res>? get mostListenedNarrator {
    if (_self.mostListenedNarrator == null) {
    return null;
  }

  return $YearInReviewNamedStatCopyWith<$Res>(_self.mostListenedNarrator!, (value) {
    return _then(_self.copyWith(mostListenedNarrator: value));
  });
}/// Create a copy of YearInReviewStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$YearInReviewMonthStatCopyWith<$Res>? get mostListenedMonth {
    if (_self.mostListenedMonth == null) {
    return null;
  }

  return $YearInReviewMonthStatCopyWith<$Res>(_self.mostListenedMonth!, (value) {
    return _then(_self.copyWith(mostListenedMonth: value));
  });
}/// Create a copy of YearInReviewStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$YearInReviewBookStatCopyWith<$Res>? get longestAudiobookFinished {
    if (_self.longestAudiobookFinished == null) {
    return null;
  }

  return $YearInReviewBookStatCopyWith<$Res>(_self.longestAudiobookFinished!, (value) {
    return _then(_self.copyWith(longestAudiobookFinished: value));
  });
}
}

// dart format on
