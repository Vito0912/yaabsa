// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'advanced_listening_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdvancedTopItem {

 String get id; String get title; String get author; String get mediaType; double get totalListeningTime; int get sessions;
/// Create a copy of AdvancedTopItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdvancedTopItemCopyWith<AdvancedTopItem> get copyWith => _$AdvancedTopItemCopyWithImpl<AdvancedTopItem>(this as AdvancedTopItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdvancedTopItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.totalListeningTime, totalListeningTime) || other.totalListeningTime == totalListeningTime)&&(identical(other.sessions, sessions) || other.sessions == sessions));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,author,mediaType,totalListeningTime,sessions);

@override
String toString() {
  return 'AdvancedTopItem(id: $id, title: $title, author: $author, mediaType: $mediaType, totalListeningTime: $totalListeningTime, sessions: $sessions)';
}


}

/// @nodoc
abstract mixin class $AdvancedTopItemCopyWith<$Res>  {
  factory $AdvancedTopItemCopyWith(AdvancedTopItem value, $Res Function(AdvancedTopItem) _then) = _$AdvancedTopItemCopyWithImpl;
@useResult
$Res call({
 String id, String title, String author, String mediaType, double totalListeningTime, int sessions
});




}
/// @nodoc
class _$AdvancedTopItemCopyWithImpl<$Res>
    implements $AdvancedTopItemCopyWith<$Res> {
  _$AdvancedTopItemCopyWithImpl(this._self, this._then);

  final AdvancedTopItem _self;
  final $Res Function(AdvancedTopItem) _then;

/// Create a copy of AdvancedTopItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? author = null,Object? mediaType = null,Object? totalListeningTime = null,Object? sessions = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String,totalListeningTime: null == totalListeningTime ? _self.totalListeningTime : totalListeningTime // ignore: cast_nullable_to_non_nullable
as double,sessions: null == sessions ? _self.sessions : sessions // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AdvancedTopItem].
extension AdvancedTopItemPatterns on AdvancedTopItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdvancedTopItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdvancedTopItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdvancedTopItem value)  $default,){
final _that = this;
switch (_that) {
case _AdvancedTopItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdvancedTopItem value)?  $default,){
final _that = this;
switch (_that) {
case _AdvancedTopItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String author,  String mediaType,  double totalListeningTime,  int sessions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdvancedTopItem() when $default != null:
return $default(_that.id,_that.title,_that.author,_that.mediaType,_that.totalListeningTime,_that.sessions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String author,  String mediaType,  double totalListeningTime,  int sessions)  $default,) {final _that = this;
switch (_that) {
case _AdvancedTopItem():
return $default(_that.id,_that.title,_that.author,_that.mediaType,_that.totalListeningTime,_that.sessions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String author,  String mediaType,  double totalListeningTime,  int sessions)?  $default,) {final _that = this;
switch (_that) {
case _AdvancedTopItem() when $default != null:
return $default(_that.id,_that.title,_that.author,_that.mediaType,_that.totalListeningTime,_that.sessions);case _:
  return null;

}
}

}

/// @nodoc


class _AdvancedTopItem implements AdvancedTopItem {
  const _AdvancedTopItem({required this.id, required this.title, required this.author, required this.mediaType, required this.totalListeningTime, required this.sessions});
  

@override final  String id;
@override final  String title;
@override final  String author;
@override final  String mediaType;
@override final  double totalListeningTime;
@override final  int sessions;

/// Create a copy of AdvancedTopItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdvancedTopItemCopyWith<_AdvancedTopItem> get copyWith => __$AdvancedTopItemCopyWithImpl<_AdvancedTopItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdvancedTopItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.totalListeningTime, totalListeningTime) || other.totalListeningTime == totalListeningTime)&&(identical(other.sessions, sessions) || other.sessions == sessions));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,author,mediaType,totalListeningTime,sessions);

@override
String toString() {
  return 'AdvancedTopItem(id: $id, title: $title, author: $author, mediaType: $mediaType, totalListeningTime: $totalListeningTime, sessions: $sessions)';
}


}

/// @nodoc
abstract mixin class _$AdvancedTopItemCopyWith<$Res> implements $AdvancedTopItemCopyWith<$Res> {
  factory _$AdvancedTopItemCopyWith(_AdvancedTopItem value, $Res Function(_AdvancedTopItem) _then) = __$AdvancedTopItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String author, String mediaType, double totalListeningTime, int sessions
});




}
/// @nodoc
class __$AdvancedTopItemCopyWithImpl<$Res>
    implements _$AdvancedTopItemCopyWith<$Res> {
  __$AdvancedTopItemCopyWithImpl(this._self, this._then);

  final _AdvancedTopItem _self;
  final $Res Function(_AdvancedTopItem) _then;

/// Create a copy of AdvancedTopItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? author = null,Object? mediaType = null,Object? totalListeningTime = null,Object? sessions = null,}) {
  return _then(_AdvancedTopItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String,totalListeningTime: null == totalListeningTime ? _self.totalListeningTime : totalListeningTime // ignore: cast_nullable_to_non_nullable
as double,sessions: null == sessions ? _self.sessions : sessions // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$AdvancedTopEntity {

 String get name; double get totalListeningTime; int get sessions;
/// Create a copy of AdvancedTopEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdvancedTopEntityCopyWith<AdvancedTopEntity> get copyWith => _$AdvancedTopEntityCopyWithImpl<AdvancedTopEntity>(this as AdvancedTopEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdvancedTopEntity&&(identical(other.name, name) || other.name == name)&&(identical(other.totalListeningTime, totalListeningTime) || other.totalListeningTime == totalListeningTime)&&(identical(other.sessions, sessions) || other.sessions == sessions));
}


@override
int get hashCode => Object.hash(runtimeType,name,totalListeningTime,sessions);

@override
String toString() {
  return 'AdvancedTopEntity(name: $name, totalListeningTime: $totalListeningTime, sessions: $sessions)';
}


}

/// @nodoc
abstract mixin class $AdvancedTopEntityCopyWith<$Res>  {
  factory $AdvancedTopEntityCopyWith(AdvancedTopEntity value, $Res Function(AdvancedTopEntity) _then) = _$AdvancedTopEntityCopyWithImpl;
@useResult
$Res call({
 String name, double totalListeningTime, int sessions
});




}
/// @nodoc
class _$AdvancedTopEntityCopyWithImpl<$Res>
    implements $AdvancedTopEntityCopyWith<$Res> {
  _$AdvancedTopEntityCopyWithImpl(this._self, this._then);

  final AdvancedTopEntity _self;
  final $Res Function(AdvancedTopEntity) _then;

/// Create a copy of AdvancedTopEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? totalListeningTime = null,Object? sessions = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,totalListeningTime: null == totalListeningTime ? _self.totalListeningTime : totalListeningTime // ignore: cast_nullable_to_non_nullable
as double,sessions: null == sessions ? _self.sessions : sessions // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AdvancedTopEntity].
extension AdvancedTopEntityPatterns on AdvancedTopEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdvancedTopEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdvancedTopEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdvancedTopEntity value)  $default,){
final _that = this;
switch (_that) {
case _AdvancedTopEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdvancedTopEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AdvancedTopEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  double totalListeningTime,  int sessions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdvancedTopEntity() when $default != null:
return $default(_that.name,_that.totalListeningTime,_that.sessions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  double totalListeningTime,  int sessions)  $default,) {final _that = this;
switch (_that) {
case _AdvancedTopEntity():
return $default(_that.name,_that.totalListeningTime,_that.sessions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  double totalListeningTime,  int sessions)?  $default,) {final _that = this;
switch (_that) {
case _AdvancedTopEntity() when $default != null:
return $default(_that.name,_that.totalListeningTime,_that.sessions);case _:
  return null;

}
}

}

/// @nodoc


class _AdvancedTopEntity implements AdvancedTopEntity {
  const _AdvancedTopEntity({required this.name, required this.totalListeningTime, required this.sessions});
  

@override final  String name;
@override final  double totalListeningTime;
@override final  int sessions;

/// Create a copy of AdvancedTopEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdvancedTopEntityCopyWith<_AdvancedTopEntity> get copyWith => __$AdvancedTopEntityCopyWithImpl<_AdvancedTopEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdvancedTopEntity&&(identical(other.name, name) || other.name == name)&&(identical(other.totalListeningTime, totalListeningTime) || other.totalListeningTime == totalListeningTime)&&(identical(other.sessions, sessions) || other.sessions == sessions));
}


@override
int get hashCode => Object.hash(runtimeType,name,totalListeningTime,sessions);

@override
String toString() {
  return 'AdvancedTopEntity(name: $name, totalListeningTime: $totalListeningTime, sessions: $sessions)';
}


}

/// @nodoc
abstract mixin class _$AdvancedTopEntityCopyWith<$Res> implements $AdvancedTopEntityCopyWith<$Res> {
  factory _$AdvancedTopEntityCopyWith(_AdvancedTopEntity value, $Res Function(_AdvancedTopEntity) _then) = __$AdvancedTopEntityCopyWithImpl;
@override @useResult
$Res call({
 String name, double totalListeningTime, int sessions
});




}
/// @nodoc
class __$AdvancedTopEntityCopyWithImpl<$Res>
    implements _$AdvancedTopEntityCopyWith<$Res> {
  __$AdvancedTopEntityCopyWithImpl(this._self, this._then);

  final _AdvancedTopEntity _self;
  final $Res Function(_AdvancedTopEntity) _then;

/// Create a copy of AdvancedTopEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? totalListeningTime = null,Object? sessions = null,}) {
  return _then(_AdvancedTopEntity(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,totalListeningTime: null == totalListeningTime ? _self.totalListeningTime : totalListeningTime // ignore: cast_nullable_to_non_nullable
as double,sessions: null == sessions ? _self.sessions : sessions // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$AdvancedTimeBucket {

 String get label; double get totalListeningTime;
/// Create a copy of AdvancedTimeBucket
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdvancedTimeBucketCopyWith<AdvancedTimeBucket> get copyWith => _$AdvancedTimeBucketCopyWithImpl<AdvancedTimeBucket>(this as AdvancedTimeBucket, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdvancedTimeBucket&&(identical(other.label, label) || other.label == label)&&(identical(other.totalListeningTime, totalListeningTime) || other.totalListeningTime == totalListeningTime));
}


@override
int get hashCode => Object.hash(runtimeType,label,totalListeningTime);

@override
String toString() {
  return 'AdvancedTimeBucket(label: $label, totalListeningTime: $totalListeningTime)';
}


}

/// @nodoc
abstract mixin class $AdvancedTimeBucketCopyWith<$Res>  {
  factory $AdvancedTimeBucketCopyWith(AdvancedTimeBucket value, $Res Function(AdvancedTimeBucket) _then) = _$AdvancedTimeBucketCopyWithImpl;
@useResult
$Res call({
 String label, double totalListeningTime
});




}
/// @nodoc
class _$AdvancedTimeBucketCopyWithImpl<$Res>
    implements $AdvancedTimeBucketCopyWith<$Res> {
  _$AdvancedTimeBucketCopyWithImpl(this._self, this._then);

  final AdvancedTimeBucket _self;
  final $Res Function(AdvancedTimeBucket) _then;

/// Create a copy of AdvancedTimeBucket
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? totalListeningTime = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,totalListeningTime: null == totalListeningTime ? _self.totalListeningTime : totalListeningTime // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [AdvancedTimeBucket].
extension AdvancedTimeBucketPatterns on AdvancedTimeBucket {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdvancedTimeBucket value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdvancedTimeBucket() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdvancedTimeBucket value)  $default,){
final _that = this;
switch (_that) {
case _AdvancedTimeBucket():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdvancedTimeBucket value)?  $default,){
final _that = this;
switch (_that) {
case _AdvancedTimeBucket() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  double totalListeningTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdvancedTimeBucket() when $default != null:
return $default(_that.label,_that.totalListeningTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  double totalListeningTime)  $default,) {final _that = this;
switch (_that) {
case _AdvancedTimeBucket():
return $default(_that.label,_that.totalListeningTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  double totalListeningTime)?  $default,) {final _that = this;
switch (_that) {
case _AdvancedTimeBucket() when $default != null:
return $default(_that.label,_that.totalListeningTime);case _:
  return null;

}
}

}

/// @nodoc


class _AdvancedTimeBucket implements AdvancedTimeBucket {
  const _AdvancedTimeBucket({required this.label, required this.totalListeningTime});
  

@override final  String label;
@override final  double totalListeningTime;

/// Create a copy of AdvancedTimeBucket
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdvancedTimeBucketCopyWith<_AdvancedTimeBucket> get copyWith => __$AdvancedTimeBucketCopyWithImpl<_AdvancedTimeBucket>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdvancedTimeBucket&&(identical(other.label, label) || other.label == label)&&(identical(other.totalListeningTime, totalListeningTime) || other.totalListeningTime == totalListeningTime));
}


@override
int get hashCode => Object.hash(runtimeType,label,totalListeningTime);

@override
String toString() {
  return 'AdvancedTimeBucket(label: $label, totalListeningTime: $totalListeningTime)';
}


}

/// @nodoc
abstract mixin class _$AdvancedTimeBucketCopyWith<$Res> implements $AdvancedTimeBucketCopyWith<$Res> {
  factory _$AdvancedTimeBucketCopyWith(_AdvancedTimeBucket value, $Res Function(_AdvancedTimeBucket) _then) = __$AdvancedTimeBucketCopyWithImpl;
@override @useResult
$Res call({
 String label, double totalListeningTime
});




}
/// @nodoc
class __$AdvancedTimeBucketCopyWithImpl<$Res>
    implements _$AdvancedTimeBucketCopyWith<$Res> {
  __$AdvancedTimeBucketCopyWithImpl(this._self, this._then);

  final _AdvancedTimeBucket _self;
  final $Res Function(_AdvancedTimeBucket) _then;

/// Create a copy of AdvancedTimeBucket
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? totalListeningTime = null,}) {
  return _then(_AdvancedTimeBucket(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,totalListeningTime: null == totalListeningTime ? _self.totalListeningTime : totalListeningTime // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$AdvancedListeningStats {

 int get loadedPages; int get totalSessions; int get totalAvailableSessions; double get totalListeningTime; double get totalBookListeningTime; double get totalPodcastListeningTime; double get averageSessionTime; double get medianSessionTime; double get longestSessionTime; int get uniqueItems; int get uniqueAuthors; int get longestStreakDays; int? get firstSessionAt; int? get lastSessionAt; String? get favoriteWeekday; int? get favoriteHour; List<AdvancedTopItem> get topItems; List<AdvancedTopEntity> get topAuthors; List<AdvancedTimeBucket> get weekdayBreakdown; List<AdvancedTimeBucket> get hourlyBreakdown; List<AdvancedTimeBucket> get monthlyBreakdown;
/// Create a copy of AdvancedListeningStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdvancedListeningStatsCopyWith<AdvancedListeningStats> get copyWith => _$AdvancedListeningStatsCopyWithImpl<AdvancedListeningStats>(this as AdvancedListeningStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdvancedListeningStats&&(identical(other.loadedPages, loadedPages) || other.loadedPages == loadedPages)&&(identical(other.totalSessions, totalSessions) || other.totalSessions == totalSessions)&&(identical(other.totalAvailableSessions, totalAvailableSessions) || other.totalAvailableSessions == totalAvailableSessions)&&(identical(other.totalListeningTime, totalListeningTime) || other.totalListeningTime == totalListeningTime)&&(identical(other.totalBookListeningTime, totalBookListeningTime) || other.totalBookListeningTime == totalBookListeningTime)&&(identical(other.totalPodcastListeningTime, totalPodcastListeningTime) || other.totalPodcastListeningTime == totalPodcastListeningTime)&&(identical(other.averageSessionTime, averageSessionTime) || other.averageSessionTime == averageSessionTime)&&(identical(other.medianSessionTime, medianSessionTime) || other.medianSessionTime == medianSessionTime)&&(identical(other.longestSessionTime, longestSessionTime) || other.longestSessionTime == longestSessionTime)&&(identical(other.uniqueItems, uniqueItems) || other.uniqueItems == uniqueItems)&&(identical(other.uniqueAuthors, uniqueAuthors) || other.uniqueAuthors == uniqueAuthors)&&(identical(other.longestStreakDays, longestStreakDays) || other.longestStreakDays == longestStreakDays)&&(identical(other.firstSessionAt, firstSessionAt) || other.firstSessionAt == firstSessionAt)&&(identical(other.lastSessionAt, lastSessionAt) || other.lastSessionAt == lastSessionAt)&&(identical(other.favoriteWeekday, favoriteWeekday) || other.favoriteWeekday == favoriteWeekday)&&(identical(other.favoriteHour, favoriteHour) || other.favoriteHour == favoriteHour)&&const DeepCollectionEquality().equals(other.topItems, topItems)&&const DeepCollectionEquality().equals(other.topAuthors, topAuthors)&&const DeepCollectionEquality().equals(other.weekdayBreakdown, weekdayBreakdown)&&const DeepCollectionEquality().equals(other.hourlyBreakdown, hourlyBreakdown)&&const DeepCollectionEquality().equals(other.monthlyBreakdown, monthlyBreakdown));
}


@override
int get hashCode => Object.hashAll([runtimeType,loadedPages,totalSessions,totalAvailableSessions,totalListeningTime,totalBookListeningTime,totalPodcastListeningTime,averageSessionTime,medianSessionTime,longestSessionTime,uniqueItems,uniqueAuthors,longestStreakDays,firstSessionAt,lastSessionAt,favoriteWeekday,favoriteHour,const DeepCollectionEquality().hash(topItems),const DeepCollectionEquality().hash(topAuthors),const DeepCollectionEquality().hash(weekdayBreakdown),const DeepCollectionEquality().hash(hourlyBreakdown),const DeepCollectionEquality().hash(monthlyBreakdown)]);

@override
String toString() {
  return 'AdvancedListeningStats(loadedPages: $loadedPages, totalSessions: $totalSessions, totalAvailableSessions: $totalAvailableSessions, totalListeningTime: $totalListeningTime, totalBookListeningTime: $totalBookListeningTime, totalPodcastListeningTime: $totalPodcastListeningTime, averageSessionTime: $averageSessionTime, medianSessionTime: $medianSessionTime, longestSessionTime: $longestSessionTime, uniqueItems: $uniqueItems, uniqueAuthors: $uniqueAuthors, longestStreakDays: $longestStreakDays, firstSessionAt: $firstSessionAt, lastSessionAt: $lastSessionAt, favoriteWeekday: $favoriteWeekday, favoriteHour: $favoriteHour, topItems: $topItems, topAuthors: $topAuthors, weekdayBreakdown: $weekdayBreakdown, hourlyBreakdown: $hourlyBreakdown, monthlyBreakdown: $monthlyBreakdown)';
}


}

/// @nodoc
abstract mixin class $AdvancedListeningStatsCopyWith<$Res>  {
  factory $AdvancedListeningStatsCopyWith(AdvancedListeningStats value, $Res Function(AdvancedListeningStats) _then) = _$AdvancedListeningStatsCopyWithImpl;
@useResult
$Res call({
 int loadedPages, int totalSessions, int totalAvailableSessions, double totalListeningTime, double totalBookListeningTime, double totalPodcastListeningTime, double averageSessionTime, double medianSessionTime, double longestSessionTime, int uniqueItems, int uniqueAuthors, int longestStreakDays, int? firstSessionAt, int? lastSessionAt, String? favoriteWeekday, int? favoriteHour, List<AdvancedTopItem> topItems, List<AdvancedTopEntity> topAuthors, List<AdvancedTimeBucket> weekdayBreakdown, List<AdvancedTimeBucket> hourlyBreakdown, List<AdvancedTimeBucket> monthlyBreakdown
});




}
/// @nodoc
class _$AdvancedListeningStatsCopyWithImpl<$Res>
    implements $AdvancedListeningStatsCopyWith<$Res> {
  _$AdvancedListeningStatsCopyWithImpl(this._self, this._then);

  final AdvancedListeningStats _self;
  final $Res Function(AdvancedListeningStats) _then;

/// Create a copy of AdvancedListeningStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loadedPages = null,Object? totalSessions = null,Object? totalAvailableSessions = null,Object? totalListeningTime = null,Object? totalBookListeningTime = null,Object? totalPodcastListeningTime = null,Object? averageSessionTime = null,Object? medianSessionTime = null,Object? longestSessionTime = null,Object? uniqueItems = null,Object? uniqueAuthors = null,Object? longestStreakDays = null,Object? firstSessionAt = freezed,Object? lastSessionAt = freezed,Object? favoriteWeekday = freezed,Object? favoriteHour = freezed,Object? topItems = null,Object? topAuthors = null,Object? weekdayBreakdown = null,Object? hourlyBreakdown = null,Object? monthlyBreakdown = null,}) {
  return _then(_self.copyWith(
loadedPages: null == loadedPages ? _self.loadedPages : loadedPages // ignore: cast_nullable_to_non_nullable
as int,totalSessions: null == totalSessions ? _self.totalSessions : totalSessions // ignore: cast_nullable_to_non_nullable
as int,totalAvailableSessions: null == totalAvailableSessions ? _self.totalAvailableSessions : totalAvailableSessions // ignore: cast_nullable_to_non_nullable
as int,totalListeningTime: null == totalListeningTime ? _self.totalListeningTime : totalListeningTime // ignore: cast_nullable_to_non_nullable
as double,totalBookListeningTime: null == totalBookListeningTime ? _self.totalBookListeningTime : totalBookListeningTime // ignore: cast_nullable_to_non_nullable
as double,totalPodcastListeningTime: null == totalPodcastListeningTime ? _self.totalPodcastListeningTime : totalPodcastListeningTime // ignore: cast_nullable_to_non_nullable
as double,averageSessionTime: null == averageSessionTime ? _self.averageSessionTime : averageSessionTime // ignore: cast_nullable_to_non_nullable
as double,medianSessionTime: null == medianSessionTime ? _self.medianSessionTime : medianSessionTime // ignore: cast_nullable_to_non_nullable
as double,longestSessionTime: null == longestSessionTime ? _self.longestSessionTime : longestSessionTime // ignore: cast_nullable_to_non_nullable
as double,uniqueItems: null == uniqueItems ? _self.uniqueItems : uniqueItems // ignore: cast_nullable_to_non_nullable
as int,uniqueAuthors: null == uniqueAuthors ? _self.uniqueAuthors : uniqueAuthors // ignore: cast_nullable_to_non_nullable
as int,longestStreakDays: null == longestStreakDays ? _self.longestStreakDays : longestStreakDays // ignore: cast_nullable_to_non_nullable
as int,firstSessionAt: freezed == firstSessionAt ? _self.firstSessionAt : firstSessionAt // ignore: cast_nullable_to_non_nullable
as int?,lastSessionAt: freezed == lastSessionAt ? _self.lastSessionAt : lastSessionAt // ignore: cast_nullable_to_non_nullable
as int?,favoriteWeekday: freezed == favoriteWeekday ? _self.favoriteWeekday : favoriteWeekday // ignore: cast_nullable_to_non_nullable
as String?,favoriteHour: freezed == favoriteHour ? _self.favoriteHour : favoriteHour // ignore: cast_nullable_to_non_nullable
as int?,topItems: null == topItems ? _self.topItems : topItems // ignore: cast_nullable_to_non_nullable
as List<AdvancedTopItem>,topAuthors: null == topAuthors ? _self.topAuthors : topAuthors // ignore: cast_nullable_to_non_nullable
as List<AdvancedTopEntity>,weekdayBreakdown: null == weekdayBreakdown ? _self.weekdayBreakdown : weekdayBreakdown // ignore: cast_nullable_to_non_nullable
as List<AdvancedTimeBucket>,hourlyBreakdown: null == hourlyBreakdown ? _self.hourlyBreakdown : hourlyBreakdown // ignore: cast_nullable_to_non_nullable
as List<AdvancedTimeBucket>,monthlyBreakdown: null == monthlyBreakdown ? _self.monthlyBreakdown : monthlyBreakdown // ignore: cast_nullable_to_non_nullable
as List<AdvancedTimeBucket>,
  ));
}

}


/// Adds pattern-matching-related methods to [AdvancedListeningStats].
extension AdvancedListeningStatsPatterns on AdvancedListeningStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdvancedListeningStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdvancedListeningStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdvancedListeningStats value)  $default,){
final _that = this;
switch (_that) {
case _AdvancedListeningStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdvancedListeningStats value)?  $default,){
final _that = this;
switch (_that) {
case _AdvancedListeningStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int loadedPages,  int totalSessions,  int totalAvailableSessions,  double totalListeningTime,  double totalBookListeningTime,  double totalPodcastListeningTime,  double averageSessionTime,  double medianSessionTime,  double longestSessionTime,  int uniqueItems,  int uniqueAuthors,  int longestStreakDays,  int? firstSessionAt,  int? lastSessionAt,  String? favoriteWeekday,  int? favoriteHour,  List<AdvancedTopItem> topItems,  List<AdvancedTopEntity> topAuthors,  List<AdvancedTimeBucket> weekdayBreakdown,  List<AdvancedTimeBucket> hourlyBreakdown,  List<AdvancedTimeBucket> monthlyBreakdown)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdvancedListeningStats() when $default != null:
return $default(_that.loadedPages,_that.totalSessions,_that.totalAvailableSessions,_that.totalListeningTime,_that.totalBookListeningTime,_that.totalPodcastListeningTime,_that.averageSessionTime,_that.medianSessionTime,_that.longestSessionTime,_that.uniqueItems,_that.uniqueAuthors,_that.longestStreakDays,_that.firstSessionAt,_that.lastSessionAt,_that.favoriteWeekday,_that.favoriteHour,_that.topItems,_that.topAuthors,_that.weekdayBreakdown,_that.hourlyBreakdown,_that.monthlyBreakdown);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int loadedPages,  int totalSessions,  int totalAvailableSessions,  double totalListeningTime,  double totalBookListeningTime,  double totalPodcastListeningTime,  double averageSessionTime,  double medianSessionTime,  double longestSessionTime,  int uniqueItems,  int uniqueAuthors,  int longestStreakDays,  int? firstSessionAt,  int? lastSessionAt,  String? favoriteWeekday,  int? favoriteHour,  List<AdvancedTopItem> topItems,  List<AdvancedTopEntity> topAuthors,  List<AdvancedTimeBucket> weekdayBreakdown,  List<AdvancedTimeBucket> hourlyBreakdown,  List<AdvancedTimeBucket> monthlyBreakdown)  $default,) {final _that = this;
switch (_that) {
case _AdvancedListeningStats():
return $default(_that.loadedPages,_that.totalSessions,_that.totalAvailableSessions,_that.totalListeningTime,_that.totalBookListeningTime,_that.totalPodcastListeningTime,_that.averageSessionTime,_that.medianSessionTime,_that.longestSessionTime,_that.uniqueItems,_that.uniqueAuthors,_that.longestStreakDays,_that.firstSessionAt,_that.lastSessionAt,_that.favoriteWeekday,_that.favoriteHour,_that.topItems,_that.topAuthors,_that.weekdayBreakdown,_that.hourlyBreakdown,_that.monthlyBreakdown);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int loadedPages,  int totalSessions,  int totalAvailableSessions,  double totalListeningTime,  double totalBookListeningTime,  double totalPodcastListeningTime,  double averageSessionTime,  double medianSessionTime,  double longestSessionTime,  int uniqueItems,  int uniqueAuthors,  int longestStreakDays,  int? firstSessionAt,  int? lastSessionAt,  String? favoriteWeekday,  int? favoriteHour,  List<AdvancedTopItem> topItems,  List<AdvancedTopEntity> topAuthors,  List<AdvancedTimeBucket> weekdayBreakdown,  List<AdvancedTimeBucket> hourlyBreakdown,  List<AdvancedTimeBucket> monthlyBreakdown)?  $default,) {final _that = this;
switch (_that) {
case _AdvancedListeningStats() when $default != null:
return $default(_that.loadedPages,_that.totalSessions,_that.totalAvailableSessions,_that.totalListeningTime,_that.totalBookListeningTime,_that.totalPodcastListeningTime,_that.averageSessionTime,_that.medianSessionTime,_that.longestSessionTime,_that.uniqueItems,_that.uniqueAuthors,_that.longestStreakDays,_that.firstSessionAt,_that.lastSessionAt,_that.favoriteWeekday,_that.favoriteHour,_that.topItems,_that.topAuthors,_that.weekdayBreakdown,_that.hourlyBreakdown,_that.monthlyBreakdown);case _:
  return null;

}
}

}

/// @nodoc


class _AdvancedListeningStats implements AdvancedListeningStats {
  const _AdvancedListeningStats({required this.loadedPages, required this.totalSessions, required this.totalAvailableSessions, required this.totalListeningTime, required this.totalBookListeningTime, required this.totalPodcastListeningTime, required this.averageSessionTime, required this.medianSessionTime, required this.longestSessionTime, required this.uniqueItems, required this.uniqueAuthors, required this.longestStreakDays, required this.firstSessionAt, required this.lastSessionAt, this.favoriteWeekday, this.favoriteHour, final  List<AdvancedTopItem> topItems = const <AdvancedTopItem>[], final  List<AdvancedTopEntity> topAuthors = const <AdvancedTopEntity>[], final  List<AdvancedTimeBucket> weekdayBreakdown = const <AdvancedTimeBucket>[], final  List<AdvancedTimeBucket> hourlyBreakdown = const <AdvancedTimeBucket>[], final  List<AdvancedTimeBucket> monthlyBreakdown = const <AdvancedTimeBucket>[]}): _topItems = topItems,_topAuthors = topAuthors,_weekdayBreakdown = weekdayBreakdown,_hourlyBreakdown = hourlyBreakdown,_monthlyBreakdown = monthlyBreakdown;
  

@override final  int loadedPages;
@override final  int totalSessions;
@override final  int totalAvailableSessions;
@override final  double totalListeningTime;
@override final  double totalBookListeningTime;
@override final  double totalPodcastListeningTime;
@override final  double averageSessionTime;
@override final  double medianSessionTime;
@override final  double longestSessionTime;
@override final  int uniqueItems;
@override final  int uniqueAuthors;
@override final  int longestStreakDays;
@override final  int? firstSessionAt;
@override final  int? lastSessionAt;
@override final  String? favoriteWeekday;
@override final  int? favoriteHour;
 final  List<AdvancedTopItem> _topItems;
@override@JsonKey() List<AdvancedTopItem> get topItems {
  if (_topItems is EqualUnmodifiableListView) return _topItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topItems);
}

 final  List<AdvancedTopEntity> _topAuthors;
@override@JsonKey() List<AdvancedTopEntity> get topAuthors {
  if (_topAuthors is EqualUnmodifiableListView) return _topAuthors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topAuthors);
}

 final  List<AdvancedTimeBucket> _weekdayBreakdown;
@override@JsonKey() List<AdvancedTimeBucket> get weekdayBreakdown {
  if (_weekdayBreakdown is EqualUnmodifiableListView) return _weekdayBreakdown;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weekdayBreakdown);
}

 final  List<AdvancedTimeBucket> _hourlyBreakdown;
@override@JsonKey() List<AdvancedTimeBucket> get hourlyBreakdown {
  if (_hourlyBreakdown is EqualUnmodifiableListView) return _hourlyBreakdown;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hourlyBreakdown);
}

 final  List<AdvancedTimeBucket> _monthlyBreakdown;
@override@JsonKey() List<AdvancedTimeBucket> get monthlyBreakdown {
  if (_monthlyBreakdown is EqualUnmodifiableListView) return _monthlyBreakdown;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_monthlyBreakdown);
}


/// Create a copy of AdvancedListeningStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdvancedListeningStatsCopyWith<_AdvancedListeningStats> get copyWith => __$AdvancedListeningStatsCopyWithImpl<_AdvancedListeningStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdvancedListeningStats&&(identical(other.loadedPages, loadedPages) || other.loadedPages == loadedPages)&&(identical(other.totalSessions, totalSessions) || other.totalSessions == totalSessions)&&(identical(other.totalAvailableSessions, totalAvailableSessions) || other.totalAvailableSessions == totalAvailableSessions)&&(identical(other.totalListeningTime, totalListeningTime) || other.totalListeningTime == totalListeningTime)&&(identical(other.totalBookListeningTime, totalBookListeningTime) || other.totalBookListeningTime == totalBookListeningTime)&&(identical(other.totalPodcastListeningTime, totalPodcastListeningTime) || other.totalPodcastListeningTime == totalPodcastListeningTime)&&(identical(other.averageSessionTime, averageSessionTime) || other.averageSessionTime == averageSessionTime)&&(identical(other.medianSessionTime, medianSessionTime) || other.medianSessionTime == medianSessionTime)&&(identical(other.longestSessionTime, longestSessionTime) || other.longestSessionTime == longestSessionTime)&&(identical(other.uniqueItems, uniqueItems) || other.uniqueItems == uniqueItems)&&(identical(other.uniqueAuthors, uniqueAuthors) || other.uniqueAuthors == uniqueAuthors)&&(identical(other.longestStreakDays, longestStreakDays) || other.longestStreakDays == longestStreakDays)&&(identical(other.firstSessionAt, firstSessionAt) || other.firstSessionAt == firstSessionAt)&&(identical(other.lastSessionAt, lastSessionAt) || other.lastSessionAt == lastSessionAt)&&(identical(other.favoriteWeekday, favoriteWeekday) || other.favoriteWeekday == favoriteWeekday)&&(identical(other.favoriteHour, favoriteHour) || other.favoriteHour == favoriteHour)&&const DeepCollectionEquality().equals(other._topItems, _topItems)&&const DeepCollectionEquality().equals(other._topAuthors, _topAuthors)&&const DeepCollectionEquality().equals(other._weekdayBreakdown, _weekdayBreakdown)&&const DeepCollectionEquality().equals(other._hourlyBreakdown, _hourlyBreakdown)&&const DeepCollectionEquality().equals(other._monthlyBreakdown, _monthlyBreakdown));
}


@override
int get hashCode => Object.hashAll([runtimeType,loadedPages,totalSessions,totalAvailableSessions,totalListeningTime,totalBookListeningTime,totalPodcastListeningTime,averageSessionTime,medianSessionTime,longestSessionTime,uniqueItems,uniqueAuthors,longestStreakDays,firstSessionAt,lastSessionAt,favoriteWeekday,favoriteHour,const DeepCollectionEquality().hash(_topItems),const DeepCollectionEquality().hash(_topAuthors),const DeepCollectionEquality().hash(_weekdayBreakdown),const DeepCollectionEquality().hash(_hourlyBreakdown),const DeepCollectionEquality().hash(_monthlyBreakdown)]);

@override
String toString() {
  return 'AdvancedListeningStats(loadedPages: $loadedPages, totalSessions: $totalSessions, totalAvailableSessions: $totalAvailableSessions, totalListeningTime: $totalListeningTime, totalBookListeningTime: $totalBookListeningTime, totalPodcastListeningTime: $totalPodcastListeningTime, averageSessionTime: $averageSessionTime, medianSessionTime: $medianSessionTime, longestSessionTime: $longestSessionTime, uniqueItems: $uniqueItems, uniqueAuthors: $uniqueAuthors, longestStreakDays: $longestStreakDays, firstSessionAt: $firstSessionAt, lastSessionAt: $lastSessionAt, favoriteWeekday: $favoriteWeekday, favoriteHour: $favoriteHour, topItems: $topItems, topAuthors: $topAuthors, weekdayBreakdown: $weekdayBreakdown, hourlyBreakdown: $hourlyBreakdown, monthlyBreakdown: $monthlyBreakdown)';
}


}

/// @nodoc
abstract mixin class _$AdvancedListeningStatsCopyWith<$Res> implements $AdvancedListeningStatsCopyWith<$Res> {
  factory _$AdvancedListeningStatsCopyWith(_AdvancedListeningStats value, $Res Function(_AdvancedListeningStats) _then) = __$AdvancedListeningStatsCopyWithImpl;
@override @useResult
$Res call({
 int loadedPages, int totalSessions, int totalAvailableSessions, double totalListeningTime, double totalBookListeningTime, double totalPodcastListeningTime, double averageSessionTime, double medianSessionTime, double longestSessionTime, int uniqueItems, int uniqueAuthors, int longestStreakDays, int? firstSessionAt, int? lastSessionAt, String? favoriteWeekday, int? favoriteHour, List<AdvancedTopItem> topItems, List<AdvancedTopEntity> topAuthors, List<AdvancedTimeBucket> weekdayBreakdown, List<AdvancedTimeBucket> hourlyBreakdown, List<AdvancedTimeBucket> monthlyBreakdown
});




}
/// @nodoc
class __$AdvancedListeningStatsCopyWithImpl<$Res>
    implements _$AdvancedListeningStatsCopyWith<$Res> {
  __$AdvancedListeningStatsCopyWithImpl(this._self, this._then);

  final _AdvancedListeningStats _self;
  final $Res Function(_AdvancedListeningStats) _then;

/// Create a copy of AdvancedListeningStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loadedPages = null,Object? totalSessions = null,Object? totalAvailableSessions = null,Object? totalListeningTime = null,Object? totalBookListeningTime = null,Object? totalPodcastListeningTime = null,Object? averageSessionTime = null,Object? medianSessionTime = null,Object? longestSessionTime = null,Object? uniqueItems = null,Object? uniqueAuthors = null,Object? longestStreakDays = null,Object? firstSessionAt = freezed,Object? lastSessionAt = freezed,Object? favoriteWeekday = freezed,Object? favoriteHour = freezed,Object? topItems = null,Object? topAuthors = null,Object? weekdayBreakdown = null,Object? hourlyBreakdown = null,Object? monthlyBreakdown = null,}) {
  return _then(_AdvancedListeningStats(
loadedPages: null == loadedPages ? _self.loadedPages : loadedPages // ignore: cast_nullable_to_non_nullable
as int,totalSessions: null == totalSessions ? _self.totalSessions : totalSessions // ignore: cast_nullable_to_non_nullable
as int,totalAvailableSessions: null == totalAvailableSessions ? _self.totalAvailableSessions : totalAvailableSessions // ignore: cast_nullable_to_non_nullable
as int,totalListeningTime: null == totalListeningTime ? _self.totalListeningTime : totalListeningTime // ignore: cast_nullable_to_non_nullable
as double,totalBookListeningTime: null == totalBookListeningTime ? _self.totalBookListeningTime : totalBookListeningTime // ignore: cast_nullable_to_non_nullable
as double,totalPodcastListeningTime: null == totalPodcastListeningTime ? _self.totalPodcastListeningTime : totalPodcastListeningTime // ignore: cast_nullable_to_non_nullable
as double,averageSessionTime: null == averageSessionTime ? _self.averageSessionTime : averageSessionTime // ignore: cast_nullable_to_non_nullable
as double,medianSessionTime: null == medianSessionTime ? _self.medianSessionTime : medianSessionTime // ignore: cast_nullable_to_non_nullable
as double,longestSessionTime: null == longestSessionTime ? _self.longestSessionTime : longestSessionTime // ignore: cast_nullable_to_non_nullable
as double,uniqueItems: null == uniqueItems ? _self.uniqueItems : uniqueItems // ignore: cast_nullable_to_non_nullable
as int,uniqueAuthors: null == uniqueAuthors ? _self.uniqueAuthors : uniqueAuthors // ignore: cast_nullable_to_non_nullable
as int,longestStreakDays: null == longestStreakDays ? _self.longestStreakDays : longestStreakDays // ignore: cast_nullable_to_non_nullable
as int,firstSessionAt: freezed == firstSessionAt ? _self.firstSessionAt : firstSessionAt // ignore: cast_nullable_to_non_nullable
as int?,lastSessionAt: freezed == lastSessionAt ? _self.lastSessionAt : lastSessionAt // ignore: cast_nullable_to_non_nullable
as int?,favoriteWeekday: freezed == favoriteWeekday ? _self.favoriteWeekday : favoriteWeekday // ignore: cast_nullable_to_non_nullable
as String?,favoriteHour: freezed == favoriteHour ? _self.favoriteHour : favoriteHour // ignore: cast_nullable_to_non_nullable
as int?,topItems: null == topItems ? _self._topItems : topItems // ignore: cast_nullable_to_non_nullable
as List<AdvancedTopItem>,topAuthors: null == topAuthors ? _self._topAuthors : topAuthors // ignore: cast_nullable_to_non_nullable
as List<AdvancedTopEntity>,weekdayBreakdown: null == weekdayBreakdown ? _self._weekdayBreakdown : weekdayBreakdown // ignore: cast_nullable_to_non_nullable
as List<AdvancedTimeBucket>,hourlyBreakdown: null == hourlyBreakdown ? _self._hourlyBreakdown : hourlyBreakdown // ignore: cast_nullable_to_non_nullable
as List<AdvancedTimeBucket>,monthlyBreakdown: null == monthlyBreakdown ? _self._monthlyBreakdown : monthlyBreakdown // ignore: cast_nullable_to_non_nullable
as List<AdvancedTimeBucket>,
  ));
}


}

// dart format on
