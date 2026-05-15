// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'abs_task_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AbsTaskListResponse {

@JsonKey(name: 'tasks') List<AbsTask> get tasks;@JsonKey(name: 'queuedTaskData') AbsQueuedTaskData? get queuedTaskData;
/// Create a copy of AbsTaskListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AbsTaskListResponseCopyWith<AbsTaskListResponse> get copyWith => _$AbsTaskListResponseCopyWithImpl<AbsTaskListResponse>(this as AbsTaskListResponse, _$identity);

  /// Serializes this AbsTaskListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AbsTaskListResponse&&const DeepCollectionEquality().equals(other.tasks, tasks)&&(identical(other.queuedTaskData, queuedTaskData) || other.queuedTaskData == queuedTaskData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(tasks),queuedTaskData);

@override
String toString() {
  return 'AbsTaskListResponse(tasks: $tasks, queuedTaskData: $queuedTaskData)';
}


}

/// @nodoc
abstract mixin class $AbsTaskListResponseCopyWith<$Res>  {
  factory $AbsTaskListResponseCopyWith(AbsTaskListResponse value, $Res Function(AbsTaskListResponse) _then) = _$AbsTaskListResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'tasks') List<AbsTask> tasks,@JsonKey(name: 'queuedTaskData') AbsQueuedTaskData? queuedTaskData
});


$AbsQueuedTaskDataCopyWith<$Res>? get queuedTaskData;

}
/// @nodoc
class _$AbsTaskListResponseCopyWithImpl<$Res>
    implements $AbsTaskListResponseCopyWith<$Res> {
  _$AbsTaskListResponseCopyWithImpl(this._self, this._then);

  final AbsTaskListResponse _self;
  final $Res Function(AbsTaskListResponse) _then;

/// Create a copy of AbsTaskListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tasks = null,Object? queuedTaskData = freezed,}) {
  return _then(_self.copyWith(
tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<AbsTask>,queuedTaskData: freezed == queuedTaskData ? _self.queuedTaskData : queuedTaskData // ignore: cast_nullable_to_non_nullable
as AbsQueuedTaskData?,
  ));
}
/// Create a copy of AbsTaskListResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AbsQueuedTaskDataCopyWith<$Res>? get queuedTaskData {
    if (_self.queuedTaskData == null) {
    return null;
  }

  return $AbsQueuedTaskDataCopyWith<$Res>(_self.queuedTaskData!, (value) {
    return _then(_self.copyWith(queuedTaskData: value));
  });
}
}


/// Adds pattern-matching-related methods to [AbsTaskListResponse].
extension AbsTaskListResponsePatterns on AbsTaskListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AbsTaskListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AbsTaskListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AbsTaskListResponse value)  $default,){
final _that = this;
switch (_that) {
case _AbsTaskListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AbsTaskListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AbsTaskListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'tasks')  List<AbsTask> tasks, @JsonKey(name: 'queuedTaskData')  AbsQueuedTaskData? queuedTaskData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AbsTaskListResponse() when $default != null:
return $default(_that.tasks,_that.queuedTaskData);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'tasks')  List<AbsTask> tasks, @JsonKey(name: 'queuedTaskData')  AbsQueuedTaskData? queuedTaskData)  $default,) {final _that = this;
switch (_that) {
case _AbsTaskListResponse():
return $default(_that.tasks,_that.queuedTaskData);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'tasks')  List<AbsTask> tasks, @JsonKey(name: 'queuedTaskData')  AbsQueuedTaskData? queuedTaskData)?  $default,) {final _that = this;
switch (_that) {
case _AbsTaskListResponse() when $default != null:
return $default(_that.tasks,_that.queuedTaskData);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AbsTaskListResponse implements AbsTaskListResponse {
  const _AbsTaskListResponse({@JsonKey(name: 'tasks') final  List<AbsTask> tasks = const <AbsTask>[], @JsonKey(name: 'queuedTaskData') this.queuedTaskData}): _tasks = tasks;
  factory _AbsTaskListResponse.fromJson(Map<String, dynamic> json) => _$AbsTaskListResponseFromJson(json);

 final  List<AbsTask> _tasks;
@override@JsonKey(name: 'tasks') List<AbsTask> get tasks {
  if (_tasks is EqualUnmodifiableListView) return _tasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tasks);
}

@override@JsonKey(name: 'queuedTaskData') final  AbsQueuedTaskData? queuedTaskData;

/// Create a copy of AbsTaskListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AbsTaskListResponseCopyWith<_AbsTaskListResponse> get copyWith => __$AbsTaskListResponseCopyWithImpl<_AbsTaskListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AbsTaskListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AbsTaskListResponse&&const DeepCollectionEquality().equals(other._tasks, _tasks)&&(identical(other.queuedTaskData, queuedTaskData) || other.queuedTaskData == queuedTaskData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_tasks),queuedTaskData);

@override
String toString() {
  return 'AbsTaskListResponse(tasks: $tasks, queuedTaskData: $queuedTaskData)';
}


}

/// @nodoc
abstract mixin class _$AbsTaskListResponseCopyWith<$Res> implements $AbsTaskListResponseCopyWith<$Res> {
  factory _$AbsTaskListResponseCopyWith(_AbsTaskListResponse value, $Res Function(_AbsTaskListResponse) _then) = __$AbsTaskListResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'tasks') List<AbsTask> tasks,@JsonKey(name: 'queuedTaskData') AbsQueuedTaskData? queuedTaskData
});


@override $AbsQueuedTaskDataCopyWith<$Res>? get queuedTaskData;

}
/// @nodoc
class __$AbsTaskListResponseCopyWithImpl<$Res>
    implements _$AbsTaskListResponseCopyWith<$Res> {
  __$AbsTaskListResponseCopyWithImpl(this._self, this._then);

  final _AbsTaskListResponse _self;
  final $Res Function(_AbsTaskListResponse) _then;

/// Create a copy of AbsTaskListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tasks = null,Object? queuedTaskData = freezed,}) {
  return _then(_AbsTaskListResponse(
tasks: null == tasks ? _self._tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<AbsTask>,queuedTaskData: freezed == queuedTaskData ? _self.queuedTaskData : queuedTaskData // ignore: cast_nullable_to_non_nullable
as AbsQueuedTaskData?,
  ));
}

/// Create a copy of AbsTaskListResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AbsQueuedTaskDataCopyWith<$Res>? get queuedTaskData {
    if (_self.queuedTaskData == null) {
    return null;
  }

  return $AbsQueuedTaskDataCopyWith<$Res>(_self.queuedTaskData!, (value) {
    return _then(_self.copyWith(queuedTaskData: value));
  });
}
}


/// @nodoc
mixin _$AbsQueuedTaskData {

@JsonKey(name: 'embedMetadata') List<AbsQueuedEmbedMetadataTaskData> get embedMetadata;
/// Create a copy of AbsQueuedTaskData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AbsQueuedTaskDataCopyWith<AbsQueuedTaskData> get copyWith => _$AbsQueuedTaskDataCopyWithImpl<AbsQueuedTaskData>(this as AbsQueuedTaskData, _$identity);

  /// Serializes this AbsQueuedTaskData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AbsQueuedTaskData&&const DeepCollectionEquality().equals(other.embedMetadata, embedMetadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(embedMetadata));

@override
String toString() {
  return 'AbsQueuedTaskData(embedMetadata: $embedMetadata)';
}


}

/// @nodoc
abstract mixin class $AbsQueuedTaskDataCopyWith<$Res>  {
  factory $AbsQueuedTaskDataCopyWith(AbsQueuedTaskData value, $Res Function(AbsQueuedTaskData) _then) = _$AbsQueuedTaskDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'embedMetadata') List<AbsQueuedEmbedMetadataTaskData> embedMetadata
});




}
/// @nodoc
class _$AbsQueuedTaskDataCopyWithImpl<$Res>
    implements $AbsQueuedTaskDataCopyWith<$Res> {
  _$AbsQueuedTaskDataCopyWithImpl(this._self, this._then);

  final AbsQueuedTaskData _self;
  final $Res Function(AbsQueuedTaskData) _then;

/// Create a copy of AbsQueuedTaskData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? embedMetadata = null,}) {
  return _then(_self.copyWith(
embedMetadata: null == embedMetadata ? _self.embedMetadata : embedMetadata // ignore: cast_nullable_to_non_nullable
as List<AbsQueuedEmbedMetadataTaskData>,
  ));
}

}


/// Adds pattern-matching-related methods to [AbsQueuedTaskData].
extension AbsQueuedTaskDataPatterns on AbsQueuedTaskData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AbsQueuedTaskData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AbsQueuedTaskData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AbsQueuedTaskData value)  $default,){
final _that = this;
switch (_that) {
case _AbsQueuedTaskData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AbsQueuedTaskData value)?  $default,){
final _that = this;
switch (_that) {
case _AbsQueuedTaskData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'embedMetadata')  List<AbsQueuedEmbedMetadataTaskData> embedMetadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AbsQueuedTaskData() when $default != null:
return $default(_that.embedMetadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'embedMetadata')  List<AbsQueuedEmbedMetadataTaskData> embedMetadata)  $default,) {final _that = this;
switch (_that) {
case _AbsQueuedTaskData():
return $default(_that.embedMetadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'embedMetadata')  List<AbsQueuedEmbedMetadataTaskData> embedMetadata)?  $default,) {final _that = this;
switch (_that) {
case _AbsQueuedTaskData() when $default != null:
return $default(_that.embedMetadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AbsQueuedTaskData implements AbsQueuedTaskData {
  const _AbsQueuedTaskData({@JsonKey(name: 'embedMetadata') final  List<AbsQueuedEmbedMetadataTaskData> embedMetadata = const <AbsQueuedEmbedMetadataTaskData>[]}): _embedMetadata = embedMetadata;
  factory _AbsQueuedTaskData.fromJson(Map<String, dynamic> json) => _$AbsQueuedTaskDataFromJson(json);

 final  List<AbsQueuedEmbedMetadataTaskData> _embedMetadata;
@override@JsonKey(name: 'embedMetadata') List<AbsQueuedEmbedMetadataTaskData> get embedMetadata {
  if (_embedMetadata is EqualUnmodifiableListView) return _embedMetadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_embedMetadata);
}


/// Create a copy of AbsQueuedTaskData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AbsQueuedTaskDataCopyWith<_AbsQueuedTaskData> get copyWith => __$AbsQueuedTaskDataCopyWithImpl<_AbsQueuedTaskData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AbsQueuedTaskDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AbsQueuedTaskData&&const DeepCollectionEquality().equals(other._embedMetadata, _embedMetadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_embedMetadata));

@override
String toString() {
  return 'AbsQueuedTaskData(embedMetadata: $embedMetadata)';
}


}

/// @nodoc
abstract mixin class _$AbsQueuedTaskDataCopyWith<$Res> implements $AbsQueuedTaskDataCopyWith<$Res> {
  factory _$AbsQueuedTaskDataCopyWith(_AbsQueuedTaskData value, $Res Function(_AbsQueuedTaskData) _then) = __$AbsQueuedTaskDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'embedMetadata') List<AbsQueuedEmbedMetadataTaskData> embedMetadata
});




}
/// @nodoc
class __$AbsQueuedTaskDataCopyWithImpl<$Res>
    implements _$AbsQueuedTaskDataCopyWith<$Res> {
  __$AbsQueuedTaskDataCopyWithImpl(this._self, this._then);

  final _AbsQueuedTaskData _self;
  final $Res Function(_AbsQueuedTaskData) _then;

/// Create a copy of AbsQueuedTaskData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? embedMetadata = null,}) {
  return _then(_AbsQueuedTaskData(
embedMetadata: null == embedMetadata ? _self._embedMetadata : embedMetadata // ignore: cast_nullable_to_non_nullable
as List<AbsQueuedEmbedMetadataTaskData>,
  ));
}


}


/// @nodoc
mixin _$AbsQueuedEmbedMetadataTaskData {

@JsonKey(name: 'libraryItemId', fromJson: _stringFromDynamic) String? get libraryItemId;@JsonKey(name: 'libraryId', fromJson: _stringFromDynamic) String? get libraryId;
/// Create a copy of AbsQueuedEmbedMetadataTaskData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AbsQueuedEmbedMetadataTaskDataCopyWith<AbsQueuedEmbedMetadataTaskData> get copyWith => _$AbsQueuedEmbedMetadataTaskDataCopyWithImpl<AbsQueuedEmbedMetadataTaskData>(this as AbsQueuedEmbedMetadataTaskData, _$identity);

  /// Serializes this AbsQueuedEmbedMetadataTaskData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AbsQueuedEmbedMetadataTaskData&&(identical(other.libraryItemId, libraryItemId) || other.libraryItemId == libraryItemId)&&(identical(other.libraryId, libraryId) || other.libraryId == libraryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,libraryItemId,libraryId);

@override
String toString() {
  return 'AbsQueuedEmbedMetadataTaskData(libraryItemId: $libraryItemId, libraryId: $libraryId)';
}


}

/// @nodoc
abstract mixin class $AbsQueuedEmbedMetadataTaskDataCopyWith<$Res>  {
  factory $AbsQueuedEmbedMetadataTaskDataCopyWith(AbsQueuedEmbedMetadataTaskData value, $Res Function(AbsQueuedEmbedMetadataTaskData) _then) = _$AbsQueuedEmbedMetadataTaskDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'libraryItemId', fromJson: _stringFromDynamic) String? libraryItemId,@JsonKey(name: 'libraryId', fromJson: _stringFromDynamic) String? libraryId
});




}
/// @nodoc
class _$AbsQueuedEmbedMetadataTaskDataCopyWithImpl<$Res>
    implements $AbsQueuedEmbedMetadataTaskDataCopyWith<$Res> {
  _$AbsQueuedEmbedMetadataTaskDataCopyWithImpl(this._self, this._then);

  final AbsQueuedEmbedMetadataTaskData _self;
  final $Res Function(AbsQueuedEmbedMetadataTaskData) _then;

/// Create a copy of AbsQueuedEmbedMetadataTaskData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? libraryItemId = freezed,Object? libraryId = freezed,}) {
  return _then(_self.copyWith(
libraryItemId: freezed == libraryItemId ? _self.libraryItemId : libraryItemId // ignore: cast_nullable_to_non_nullable
as String?,libraryId: freezed == libraryId ? _self.libraryId : libraryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AbsQueuedEmbedMetadataTaskData].
extension AbsQueuedEmbedMetadataTaskDataPatterns on AbsQueuedEmbedMetadataTaskData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AbsQueuedEmbedMetadataTaskData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AbsQueuedEmbedMetadataTaskData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AbsQueuedEmbedMetadataTaskData value)  $default,){
final _that = this;
switch (_that) {
case _AbsQueuedEmbedMetadataTaskData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AbsQueuedEmbedMetadataTaskData value)?  $default,){
final _that = this;
switch (_that) {
case _AbsQueuedEmbedMetadataTaskData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'libraryItemId', fromJson: _stringFromDynamic)  String? libraryItemId, @JsonKey(name: 'libraryId', fromJson: _stringFromDynamic)  String? libraryId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AbsQueuedEmbedMetadataTaskData() when $default != null:
return $default(_that.libraryItemId,_that.libraryId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'libraryItemId', fromJson: _stringFromDynamic)  String? libraryItemId, @JsonKey(name: 'libraryId', fromJson: _stringFromDynamic)  String? libraryId)  $default,) {final _that = this;
switch (_that) {
case _AbsQueuedEmbedMetadataTaskData():
return $default(_that.libraryItemId,_that.libraryId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'libraryItemId', fromJson: _stringFromDynamic)  String? libraryItemId, @JsonKey(name: 'libraryId', fromJson: _stringFromDynamic)  String? libraryId)?  $default,) {final _that = this;
switch (_that) {
case _AbsQueuedEmbedMetadataTaskData() when $default != null:
return $default(_that.libraryItemId,_that.libraryId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AbsQueuedEmbedMetadataTaskData implements AbsQueuedEmbedMetadataTaskData {
  const _AbsQueuedEmbedMetadataTaskData({@JsonKey(name: 'libraryItemId', fromJson: _stringFromDynamic) this.libraryItemId, @JsonKey(name: 'libraryId', fromJson: _stringFromDynamic) this.libraryId});
  factory _AbsQueuedEmbedMetadataTaskData.fromJson(Map<String, dynamic> json) => _$AbsQueuedEmbedMetadataTaskDataFromJson(json);

@override@JsonKey(name: 'libraryItemId', fromJson: _stringFromDynamic) final  String? libraryItemId;
@override@JsonKey(name: 'libraryId', fromJson: _stringFromDynamic) final  String? libraryId;

/// Create a copy of AbsQueuedEmbedMetadataTaskData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AbsQueuedEmbedMetadataTaskDataCopyWith<_AbsQueuedEmbedMetadataTaskData> get copyWith => __$AbsQueuedEmbedMetadataTaskDataCopyWithImpl<_AbsQueuedEmbedMetadataTaskData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AbsQueuedEmbedMetadataTaskDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AbsQueuedEmbedMetadataTaskData&&(identical(other.libraryItemId, libraryItemId) || other.libraryItemId == libraryItemId)&&(identical(other.libraryId, libraryId) || other.libraryId == libraryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,libraryItemId,libraryId);

@override
String toString() {
  return 'AbsQueuedEmbedMetadataTaskData(libraryItemId: $libraryItemId, libraryId: $libraryId)';
}


}

/// @nodoc
abstract mixin class _$AbsQueuedEmbedMetadataTaskDataCopyWith<$Res> implements $AbsQueuedEmbedMetadataTaskDataCopyWith<$Res> {
  factory _$AbsQueuedEmbedMetadataTaskDataCopyWith(_AbsQueuedEmbedMetadataTaskData value, $Res Function(_AbsQueuedEmbedMetadataTaskData) _then) = __$AbsQueuedEmbedMetadataTaskDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'libraryItemId', fromJson: _stringFromDynamic) String? libraryItemId,@JsonKey(name: 'libraryId', fromJson: _stringFromDynamic) String? libraryId
});




}
/// @nodoc
class __$AbsQueuedEmbedMetadataTaskDataCopyWithImpl<$Res>
    implements _$AbsQueuedEmbedMetadataTaskDataCopyWith<$Res> {
  __$AbsQueuedEmbedMetadataTaskDataCopyWithImpl(this._self, this._then);

  final _AbsQueuedEmbedMetadataTaskData _self;
  final $Res Function(_AbsQueuedEmbedMetadataTaskData) _then;

/// Create a copy of AbsQueuedEmbedMetadataTaskData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? libraryItemId = freezed,Object? libraryId = freezed,}) {
  return _then(_AbsQueuedEmbedMetadataTaskData(
libraryItemId: freezed == libraryItemId ? _self.libraryItemId : libraryItemId // ignore: cast_nullable_to_non_nullable
as String?,libraryId: freezed == libraryId ? _self.libraryId : libraryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
