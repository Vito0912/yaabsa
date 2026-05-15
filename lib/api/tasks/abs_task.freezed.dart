// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'abs_task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AbsTask {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'action') String get action;@JsonKey(name: 'data') AbsTaskData? get data;@JsonKey(name: 'title') String? get title;@JsonKey(name: 'titleKey') String? get titleKey;@JsonKey(name: 'titleSubs', fromJson: _stringListFromDynamic) List<String> get titleSubs;@JsonKey(name: 'description') String? get description;@JsonKey(name: 'descriptionKey') String? get descriptionKey;@JsonKey(name: 'descriptionSubs', fromJson: _stringListFromDynamic) List<String> get descriptionSubs;@JsonKey(name: 'error') String? get error;@JsonKey(name: 'errorKey') String? get errorKey;@JsonKey(name: 'errorSubs', fromJson: _stringListFromDynamic) List<String> get errorSubs;@JsonKey(name: 'showSuccess') bool get showSuccess;@JsonKey(name: 'isFailed') bool get isFailed;@JsonKey(name: 'isFinished') bool get isFinished;@JsonKey(name: 'startedAt', fromJson: jsonIntFromDynamic) int? get startedAt;@JsonKey(name: 'finishedAt', fromJson: jsonIntFromDynamic) int? get finishedAt;
/// Create a copy of AbsTask
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AbsTaskCopyWith<AbsTask> get copyWith => _$AbsTaskCopyWithImpl<AbsTask>(this as AbsTask, _$identity);

  /// Serializes this AbsTask to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AbsTask&&(identical(other.id, id) || other.id == id)&&(identical(other.action, action) || other.action == action)&&(identical(other.data, data) || other.data == data)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleKey, titleKey) || other.titleKey == titleKey)&&const DeepCollectionEquality().equals(other.titleSubs, titleSubs)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionKey, descriptionKey) || other.descriptionKey == descriptionKey)&&const DeepCollectionEquality().equals(other.descriptionSubs, descriptionSubs)&&(identical(other.error, error) || other.error == error)&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey)&&const DeepCollectionEquality().equals(other.errorSubs, errorSubs)&&(identical(other.showSuccess, showSuccess) || other.showSuccess == showSuccess)&&(identical(other.isFailed, isFailed) || other.isFailed == isFailed)&&(identical(other.isFinished, isFinished) || other.isFinished == isFinished)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,action,data,title,titleKey,const DeepCollectionEquality().hash(titleSubs),description,descriptionKey,const DeepCollectionEquality().hash(descriptionSubs),error,errorKey,const DeepCollectionEquality().hash(errorSubs),showSuccess,isFailed,isFinished,startedAt,finishedAt);

@override
String toString() {
  return 'AbsTask(id: $id, action: $action, data: $data, title: $title, titleKey: $titleKey, titleSubs: $titleSubs, description: $description, descriptionKey: $descriptionKey, descriptionSubs: $descriptionSubs, error: $error, errorKey: $errorKey, errorSubs: $errorSubs, showSuccess: $showSuccess, isFailed: $isFailed, isFinished: $isFinished, startedAt: $startedAt, finishedAt: $finishedAt)';
}


}

/// @nodoc
abstract mixin class $AbsTaskCopyWith<$Res>  {
  factory $AbsTaskCopyWith(AbsTask value, $Res Function(AbsTask) _then) = _$AbsTaskCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'action') String action,@JsonKey(name: 'data') AbsTaskData? data,@JsonKey(name: 'title') String? title,@JsonKey(name: 'titleKey') String? titleKey,@JsonKey(name: 'titleSubs', fromJson: _stringListFromDynamic) List<String> titleSubs,@JsonKey(name: 'description') String? description,@JsonKey(name: 'descriptionKey') String? descriptionKey,@JsonKey(name: 'descriptionSubs', fromJson: _stringListFromDynamic) List<String> descriptionSubs,@JsonKey(name: 'error') String? error,@JsonKey(name: 'errorKey') String? errorKey,@JsonKey(name: 'errorSubs', fromJson: _stringListFromDynamic) List<String> errorSubs,@JsonKey(name: 'showSuccess') bool showSuccess,@JsonKey(name: 'isFailed') bool isFailed,@JsonKey(name: 'isFinished') bool isFinished,@JsonKey(name: 'startedAt', fromJson: jsonIntFromDynamic) int? startedAt,@JsonKey(name: 'finishedAt', fromJson: jsonIntFromDynamic) int? finishedAt
});


$AbsTaskDataCopyWith<$Res>? get data;

}
/// @nodoc
class _$AbsTaskCopyWithImpl<$Res>
    implements $AbsTaskCopyWith<$Res> {
  _$AbsTaskCopyWithImpl(this._self, this._then);

  final AbsTask _self;
  final $Res Function(AbsTask) _then;

/// Create a copy of AbsTask
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? action = null,Object? data = freezed,Object? title = freezed,Object? titleKey = freezed,Object? titleSubs = null,Object? description = freezed,Object? descriptionKey = freezed,Object? descriptionSubs = null,Object? error = freezed,Object? errorKey = freezed,Object? errorSubs = null,Object? showSuccess = null,Object? isFailed = null,Object? isFinished = null,Object? startedAt = freezed,Object? finishedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AbsTaskData?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,titleKey: freezed == titleKey ? _self.titleKey : titleKey // ignore: cast_nullable_to_non_nullable
as String?,titleSubs: null == titleSubs ? _self.titleSubs : titleSubs // ignore: cast_nullable_to_non_nullable
as List<String>,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionKey: freezed == descriptionKey ? _self.descriptionKey : descriptionKey // ignore: cast_nullable_to_non_nullable
as String?,descriptionSubs: null == descriptionSubs ? _self.descriptionSubs : descriptionSubs // ignore: cast_nullable_to_non_nullable
as List<String>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,errorKey: freezed == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String?,errorSubs: null == errorSubs ? _self.errorSubs : errorSubs // ignore: cast_nullable_to_non_nullable
as List<String>,showSuccess: null == showSuccess ? _self.showSuccess : showSuccess // ignore: cast_nullable_to_non_nullable
as bool,isFailed: null == isFailed ? _self.isFailed : isFailed // ignore: cast_nullable_to_non_nullable
as bool,isFinished: null == isFinished ? _self.isFinished : isFinished // ignore: cast_nullable_to_non_nullable
as bool,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as int?,finishedAt: freezed == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of AbsTask
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AbsTaskDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $AbsTaskDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [AbsTask].
extension AbsTaskPatterns on AbsTask {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AbsTask value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AbsTask() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AbsTask value)  $default,){
final _that = this;
switch (_that) {
case _AbsTask():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AbsTask value)?  $default,){
final _that = this;
switch (_that) {
case _AbsTask() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'action')  String action, @JsonKey(name: 'data')  AbsTaskData? data, @JsonKey(name: 'title')  String? title, @JsonKey(name: 'titleKey')  String? titleKey, @JsonKey(name: 'titleSubs', fromJson: _stringListFromDynamic)  List<String> titleSubs, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'descriptionKey')  String? descriptionKey, @JsonKey(name: 'descriptionSubs', fromJson: _stringListFromDynamic)  List<String> descriptionSubs, @JsonKey(name: 'error')  String? error, @JsonKey(name: 'errorKey')  String? errorKey, @JsonKey(name: 'errorSubs', fromJson: _stringListFromDynamic)  List<String> errorSubs, @JsonKey(name: 'showSuccess')  bool showSuccess, @JsonKey(name: 'isFailed')  bool isFailed, @JsonKey(name: 'isFinished')  bool isFinished, @JsonKey(name: 'startedAt', fromJson: jsonIntFromDynamic)  int? startedAt, @JsonKey(name: 'finishedAt', fromJson: jsonIntFromDynamic)  int? finishedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AbsTask() when $default != null:
return $default(_that.id,_that.action,_that.data,_that.title,_that.titleKey,_that.titleSubs,_that.description,_that.descriptionKey,_that.descriptionSubs,_that.error,_that.errorKey,_that.errorSubs,_that.showSuccess,_that.isFailed,_that.isFinished,_that.startedAt,_that.finishedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'action')  String action, @JsonKey(name: 'data')  AbsTaskData? data, @JsonKey(name: 'title')  String? title, @JsonKey(name: 'titleKey')  String? titleKey, @JsonKey(name: 'titleSubs', fromJson: _stringListFromDynamic)  List<String> titleSubs, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'descriptionKey')  String? descriptionKey, @JsonKey(name: 'descriptionSubs', fromJson: _stringListFromDynamic)  List<String> descriptionSubs, @JsonKey(name: 'error')  String? error, @JsonKey(name: 'errorKey')  String? errorKey, @JsonKey(name: 'errorSubs', fromJson: _stringListFromDynamic)  List<String> errorSubs, @JsonKey(name: 'showSuccess')  bool showSuccess, @JsonKey(name: 'isFailed')  bool isFailed, @JsonKey(name: 'isFinished')  bool isFinished, @JsonKey(name: 'startedAt', fromJson: jsonIntFromDynamic)  int? startedAt, @JsonKey(name: 'finishedAt', fromJson: jsonIntFromDynamic)  int? finishedAt)  $default,) {final _that = this;
switch (_that) {
case _AbsTask():
return $default(_that.id,_that.action,_that.data,_that.title,_that.titleKey,_that.titleSubs,_that.description,_that.descriptionKey,_that.descriptionSubs,_that.error,_that.errorKey,_that.errorSubs,_that.showSuccess,_that.isFailed,_that.isFinished,_that.startedAt,_that.finishedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'action')  String action, @JsonKey(name: 'data')  AbsTaskData? data, @JsonKey(name: 'title')  String? title, @JsonKey(name: 'titleKey')  String? titleKey, @JsonKey(name: 'titleSubs', fromJson: _stringListFromDynamic)  List<String> titleSubs, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'descriptionKey')  String? descriptionKey, @JsonKey(name: 'descriptionSubs', fromJson: _stringListFromDynamic)  List<String> descriptionSubs, @JsonKey(name: 'error')  String? error, @JsonKey(name: 'errorKey')  String? errorKey, @JsonKey(name: 'errorSubs', fromJson: _stringListFromDynamic)  List<String> errorSubs, @JsonKey(name: 'showSuccess')  bool showSuccess, @JsonKey(name: 'isFailed')  bool isFailed, @JsonKey(name: 'isFinished')  bool isFinished, @JsonKey(name: 'startedAt', fromJson: jsonIntFromDynamic)  int? startedAt, @JsonKey(name: 'finishedAt', fromJson: jsonIntFromDynamic)  int? finishedAt)?  $default,) {final _that = this;
switch (_that) {
case _AbsTask() when $default != null:
return $default(_that.id,_that.action,_that.data,_that.title,_that.titleKey,_that.titleSubs,_that.description,_that.descriptionKey,_that.descriptionSubs,_that.error,_that.errorKey,_that.errorSubs,_that.showSuccess,_that.isFailed,_that.isFinished,_that.startedAt,_that.finishedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AbsTask implements AbsTask {
  const _AbsTask({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'action') this.action = '', @JsonKey(name: 'data') this.data, @JsonKey(name: 'title') this.title, @JsonKey(name: 'titleKey') this.titleKey, @JsonKey(name: 'titleSubs', fromJson: _stringListFromDynamic) final  List<String> titleSubs = const <String>[], @JsonKey(name: 'description') this.description, @JsonKey(name: 'descriptionKey') this.descriptionKey, @JsonKey(name: 'descriptionSubs', fromJson: _stringListFromDynamic) final  List<String> descriptionSubs = const <String>[], @JsonKey(name: 'error') this.error, @JsonKey(name: 'errorKey') this.errorKey, @JsonKey(name: 'errorSubs', fromJson: _stringListFromDynamic) final  List<String> errorSubs = const <String>[], @JsonKey(name: 'showSuccess') this.showSuccess = false, @JsonKey(name: 'isFailed') this.isFailed = false, @JsonKey(name: 'isFinished') this.isFinished = false, @JsonKey(name: 'startedAt', fromJson: jsonIntFromDynamic) this.startedAt, @JsonKey(name: 'finishedAt', fromJson: jsonIntFromDynamic) this.finishedAt}): _titleSubs = titleSubs,_descriptionSubs = descriptionSubs,_errorSubs = errorSubs;
  factory _AbsTask.fromJson(Map<String, dynamic> json) => _$AbsTaskFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'action') final  String action;
@override@JsonKey(name: 'data') final  AbsTaskData? data;
@override@JsonKey(name: 'title') final  String? title;
@override@JsonKey(name: 'titleKey') final  String? titleKey;
 final  List<String> _titleSubs;
@override@JsonKey(name: 'titleSubs', fromJson: _stringListFromDynamic) List<String> get titleSubs {
  if (_titleSubs is EqualUnmodifiableListView) return _titleSubs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_titleSubs);
}

@override@JsonKey(name: 'description') final  String? description;
@override@JsonKey(name: 'descriptionKey') final  String? descriptionKey;
 final  List<String> _descriptionSubs;
@override@JsonKey(name: 'descriptionSubs', fromJson: _stringListFromDynamic) List<String> get descriptionSubs {
  if (_descriptionSubs is EqualUnmodifiableListView) return _descriptionSubs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_descriptionSubs);
}

@override@JsonKey(name: 'error') final  String? error;
@override@JsonKey(name: 'errorKey') final  String? errorKey;
 final  List<String> _errorSubs;
@override@JsonKey(name: 'errorSubs', fromJson: _stringListFromDynamic) List<String> get errorSubs {
  if (_errorSubs is EqualUnmodifiableListView) return _errorSubs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_errorSubs);
}

@override@JsonKey(name: 'showSuccess') final  bool showSuccess;
@override@JsonKey(name: 'isFailed') final  bool isFailed;
@override@JsonKey(name: 'isFinished') final  bool isFinished;
@override@JsonKey(name: 'startedAt', fromJson: jsonIntFromDynamic) final  int? startedAt;
@override@JsonKey(name: 'finishedAt', fromJson: jsonIntFromDynamic) final  int? finishedAt;

/// Create a copy of AbsTask
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AbsTaskCopyWith<_AbsTask> get copyWith => __$AbsTaskCopyWithImpl<_AbsTask>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AbsTaskToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AbsTask&&(identical(other.id, id) || other.id == id)&&(identical(other.action, action) || other.action == action)&&(identical(other.data, data) || other.data == data)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleKey, titleKey) || other.titleKey == titleKey)&&const DeepCollectionEquality().equals(other._titleSubs, _titleSubs)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionKey, descriptionKey) || other.descriptionKey == descriptionKey)&&const DeepCollectionEquality().equals(other._descriptionSubs, _descriptionSubs)&&(identical(other.error, error) || other.error == error)&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey)&&const DeepCollectionEquality().equals(other._errorSubs, _errorSubs)&&(identical(other.showSuccess, showSuccess) || other.showSuccess == showSuccess)&&(identical(other.isFailed, isFailed) || other.isFailed == isFailed)&&(identical(other.isFinished, isFinished) || other.isFinished == isFinished)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,action,data,title,titleKey,const DeepCollectionEquality().hash(_titleSubs),description,descriptionKey,const DeepCollectionEquality().hash(_descriptionSubs),error,errorKey,const DeepCollectionEquality().hash(_errorSubs),showSuccess,isFailed,isFinished,startedAt,finishedAt);

@override
String toString() {
  return 'AbsTask(id: $id, action: $action, data: $data, title: $title, titleKey: $titleKey, titleSubs: $titleSubs, description: $description, descriptionKey: $descriptionKey, descriptionSubs: $descriptionSubs, error: $error, errorKey: $errorKey, errorSubs: $errorSubs, showSuccess: $showSuccess, isFailed: $isFailed, isFinished: $isFinished, startedAt: $startedAt, finishedAt: $finishedAt)';
}


}

/// @nodoc
abstract mixin class _$AbsTaskCopyWith<$Res> implements $AbsTaskCopyWith<$Res> {
  factory _$AbsTaskCopyWith(_AbsTask value, $Res Function(_AbsTask) _then) = __$AbsTaskCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'action') String action,@JsonKey(name: 'data') AbsTaskData? data,@JsonKey(name: 'title') String? title,@JsonKey(name: 'titleKey') String? titleKey,@JsonKey(name: 'titleSubs', fromJson: _stringListFromDynamic) List<String> titleSubs,@JsonKey(name: 'description') String? description,@JsonKey(name: 'descriptionKey') String? descriptionKey,@JsonKey(name: 'descriptionSubs', fromJson: _stringListFromDynamic) List<String> descriptionSubs,@JsonKey(name: 'error') String? error,@JsonKey(name: 'errorKey') String? errorKey,@JsonKey(name: 'errorSubs', fromJson: _stringListFromDynamic) List<String> errorSubs,@JsonKey(name: 'showSuccess') bool showSuccess,@JsonKey(name: 'isFailed') bool isFailed,@JsonKey(name: 'isFinished') bool isFinished,@JsonKey(name: 'startedAt', fromJson: jsonIntFromDynamic) int? startedAt,@JsonKey(name: 'finishedAt', fromJson: jsonIntFromDynamic) int? finishedAt
});


@override $AbsTaskDataCopyWith<$Res>? get data;

}
/// @nodoc
class __$AbsTaskCopyWithImpl<$Res>
    implements _$AbsTaskCopyWith<$Res> {
  __$AbsTaskCopyWithImpl(this._self, this._then);

  final _AbsTask _self;
  final $Res Function(_AbsTask) _then;

/// Create a copy of AbsTask
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? action = null,Object? data = freezed,Object? title = freezed,Object? titleKey = freezed,Object? titleSubs = null,Object? description = freezed,Object? descriptionKey = freezed,Object? descriptionSubs = null,Object? error = freezed,Object? errorKey = freezed,Object? errorSubs = null,Object? showSuccess = null,Object? isFailed = null,Object? isFinished = null,Object? startedAt = freezed,Object? finishedAt = freezed,}) {
  return _then(_AbsTask(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AbsTaskData?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,titleKey: freezed == titleKey ? _self.titleKey : titleKey // ignore: cast_nullable_to_non_nullable
as String?,titleSubs: null == titleSubs ? _self._titleSubs : titleSubs // ignore: cast_nullable_to_non_nullable
as List<String>,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionKey: freezed == descriptionKey ? _self.descriptionKey : descriptionKey // ignore: cast_nullable_to_non_nullable
as String?,descriptionSubs: null == descriptionSubs ? _self._descriptionSubs : descriptionSubs // ignore: cast_nullable_to_non_nullable
as List<String>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,errorKey: freezed == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String?,errorSubs: null == errorSubs ? _self._errorSubs : errorSubs // ignore: cast_nullable_to_non_nullable
as List<String>,showSuccess: null == showSuccess ? _self.showSuccess : showSuccess // ignore: cast_nullable_to_non_nullable
as bool,isFailed: null == isFailed ? _self.isFailed : isFailed // ignore: cast_nullable_to_non_nullable
as bool,isFinished: null == isFinished ? _self.isFinished : isFinished // ignore: cast_nullable_to_non_nullable
as bool,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as int?,finishedAt: freezed == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of AbsTask
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AbsTaskDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $AbsTaskDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$AbsTaskData {

@JsonKey(name: 'libraryItemId', fromJson: _stringFromDynamic) String? get libraryItemId;@JsonKey(name: 'libraryId', fromJson: _stringFromDynamic) String? get libraryId;@JsonKey(name: 'ino', fromJson: _stringFromDynamic) String? get ino;@JsonKey(name: 'encodeOptions') AbsTaskEncodeOptions? get encodeOptions;@JsonKey(name: 'scanResults') AbsTaskScanResults? get scanResults;
/// Create a copy of AbsTaskData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AbsTaskDataCopyWith<AbsTaskData> get copyWith => _$AbsTaskDataCopyWithImpl<AbsTaskData>(this as AbsTaskData, _$identity);

  /// Serializes this AbsTaskData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AbsTaskData&&(identical(other.libraryItemId, libraryItemId) || other.libraryItemId == libraryItemId)&&(identical(other.libraryId, libraryId) || other.libraryId == libraryId)&&(identical(other.ino, ino) || other.ino == ino)&&(identical(other.encodeOptions, encodeOptions) || other.encodeOptions == encodeOptions)&&(identical(other.scanResults, scanResults) || other.scanResults == scanResults));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,libraryItemId,libraryId,ino,encodeOptions,scanResults);

@override
String toString() {
  return 'AbsTaskData(libraryItemId: $libraryItemId, libraryId: $libraryId, ino: $ino, encodeOptions: $encodeOptions, scanResults: $scanResults)';
}


}

/// @nodoc
abstract mixin class $AbsTaskDataCopyWith<$Res>  {
  factory $AbsTaskDataCopyWith(AbsTaskData value, $Res Function(AbsTaskData) _then) = _$AbsTaskDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'libraryItemId', fromJson: _stringFromDynamic) String? libraryItemId,@JsonKey(name: 'libraryId', fromJson: _stringFromDynamic) String? libraryId,@JsonKey(name: 'ino', fromJson: _stringFromDynamic) String? ino,@JsonKey(name: 'encodeOptions') AbsTaskEncodeOptions? encodeOptions,@JsonKey(name: 'scanResults') AbsTaskScanResults? scanResults
});


$AbsTaskEncodeOptionsCopyWith<$Res>? get encodeOptions;$AbsTaskScanResultsCopyWith<$Res>? get scanResults;

}
/// @nodoc
class _$AbsTaskDataCopyWithImpl<$Res>
    implements $AbsTaskDataCopyWith<$Res> {
  _$AbsTaskDataCopyWithImpl(this._self, this._then);

  final AbsTaskData _self;
  final $Res Function(AbsTaskData) _then;

/// Create a copy of AbsTaskData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? libraryItemId = freezed,Object? libraryId = freezed,Object? ino = freezed,Object? encodeOptions = freezed,Object? scanResults = freezed,}) {
  return _then(_self.copyWith(
libraryItemId: freezed == libraryItemId ? _self.libraryItemId : libraryItemId // ignore: cast_nullable_to_non_nullable
as String?,libraryId: freezed == libraryId ? _self.libraryId : libraryId // ignore: cast_nullable_to_non_nullable
as String?,ino: freezed == ino ? _self.ino : ino // ignore: cast_nullable_to_non_nullable
as String?,encodeOptions: freezed == encodeOptions ? _self.encodeOptions : encodeOptions // ignore: cast_nullable_to_non_nullable
as AbsTaskEncodeOptions?,scanResults: freezed == scanResults ? _self.scanResults : scanResults // ignore: cast_nullable_to_non_nullable
as AbsTaskScanResults?,
  ));
}
/// Create a copy of AbsTaskData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AbsTaskEncodeOptionsCopyWith<$Res>? get encodeOptions {
    if (_self.encodeOptions == null) {
    return null;
  }

  return $AbsTaskEncodeOptionsCopyWith<$Res>(_self.encodeOptions!, (value) {
    return _then(_self.copyWith(encodeOptions: value));
  });
}/// Create a copy of AbsTaskData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AbsTaskScanResultsCopyWith<$Res>? get scanResults {
    if (_self.scanResults == null) {
    return null;
  }

  return $AbsTaskScanResultsCopyWith<$Res>(_self.scanResults!, (value) {
    return _then(_self.copyWith(scanResults: value));
  });
}
}


/// Adds pattern-matching-related methods to [AbsTaskData].
extension AbsTaskDataPatterns on AbsTaskData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AbsTaskData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AbsTaskData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AbsTaskData value)  $default,){
final _that = this;
switch (_that) {
case _AbsTaskData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AbsTaskData value)?  $default,){
final _that = this;
switch (_that) {
case _AbsTaskData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'libraryItemId', fromJson: _stringFromDynamic)  String? libraryItemId, @JsonKey(name: 'libraryId', fromJson: _stringFromDynamic)  String? libraryId, @JsonKey(name: 'ino', fromJson: _stringFromDynamic)  String? ino, @JsonKey(name: 'encodeOptions')  AbsTaskEncodeOptions? encodeOptions, @JsonKey(name: 'scanResults')  AbsTaskScanResults? scanResults)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AbsTaskData() when $default != null:
return $default(_that.libraryItemId,_that.libraryId,_that.ino,_that.encodeOptions,_that.scanResults);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'libraryItemId', fromJson: _stringFromDynamic)  String? libraryItemId, @JsonKey(name: 'libraryId', fromJson: _stringFromDynamic)  String? libraryId, @JsonKey(name: 'ino', fromJson: _stringFromDynamic)  String? ino, @JsonKey(name: 'encodeOptions')  AbsTaskEncodeOptions? encodeOptions, @JsonKey(name: 'scanResults')  AbsTaskScanResults? scanResults)  $default,) {final _that = this;
switch (_that) {
case _AbsTaskData():
return $default(_that.libraryItemId,_that.libraryId,_that.ino,_that.encodeOptions,_that.scanResults);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'libraryItemId', fromJson: _stringFromDynamic)  String? libraryItemId, @JsonKey(name: 'libraryId', fromJson: _stringFromDynamic)  String? libraryId, @JsonKey(name: 'ino', fromJson: _stringFromDynamic)  String? ino, @JsonKey(name: 'encodeOptions')  AbsTaskEncodeOptions? encodeOptions, @JsonKey(name: 'scanResults')  AbsTaskScanResults? scanResults)?  $default,) {final _that = this;
switch (_that) {
case _AbsTaskData() when $default != null:
return $default(_that.libraryItemId,_that.libraryId,_that.ino,_that.encodeOptions,_that.scanResults);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AbsTaskData implements AbsTaskData {
  const _AbsTaskData({@JsonKey(name: 'libraryItemId', fromJson: _stringFromDynamic) this.libraryItemId, @JsonKey(name: 'libraryId', fromJson: _stringFromDynamic) this.libraryId, @JsonKey(name: 'ino', fromJson: _stringFromDynamic) this.ino, @JsonKey(name: 'encodeOptions') this.encodeOptions, @JsonKey(name: 'scanResults') this.scanResults});
  factory _AbsTaskData.fromJson(Map<String, dynamic> json) => _$AbsTaskDataFromJson(json);

@override@JsonKey(name: 'libraryItemId', fromJson: _stringFromDynamic) final  String? libraryItemId;
@override@JsonKey(name: 'libraryId', fromJson: _stringFromDynamic) final  String? libraryId;
@override@JsonKey(name: 'ino', fromJson: _stringFromDynamic) final  String? ino;
@override@JsonKey(name: 'encodeOptions') final  AbsTaskEncodeOptions? encodeOptions;
@override@JsonKey(name: 'scanResults') final  AbsTaskScanResults? scanResults;

/// Create a copy of AbsTaskData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AbsTaskDataCopyWith<_AbsTaskData> get copyWith => __$AbsTaskDataCopyWithImpl<_AbsTaskData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AbsTaskDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AbsTaskData&&(identical(other.libraryItemId, libraryItemId) || other.libraryItemId == libraryItemId)&&(identical(other.libraryId, libraryId) || other.libraryId == libraryId)&&(identical(other.ino, ino) || other.ino == ino)&&(identical(other.encodeOptions, encodeOptions) || other.encodeOptions == encodeOptions)&&(identical(other.scanResults, scanResults) || other.scanResults == scanResults));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,libraryItemId,libraryId,ino,encodeOptions,scanResults);

@override
String toString() {
  return 'AbsTaskData(libraryItemId: $libraryItemId, libraryId: $libraryId, ino: $ino, encodeOptions: $encodeOptions, scanResults: $scanResults)';
}


}

/// @nodoc
abstract mixin class _$AbsTaskDataCopyWith<$Res> implements $AbsTaskDataCopyWith<$Res> {
  factory _$AbsTaskDataCopyWith(_AbsTaskData value, $Res Function(_AbsTaskData) _then) = __$AbsTaskDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'libraryItemId', fromJson: _stringFromDynamic) String? libraryItemId,@JsonKey(name: 'libraryId', fromJson: _stringFromDynamic) String? libraryId,@JsonKey(name: 'ino', fromJson: _stringFromDynamic) String? ino,@JsonKey(name: 'encodeOptions') AbsTaskEncodeOptions? encodeOptions,@JsonKey(name: 'scanResults') AbsTaskScanResults? scanResults
});


@override $AbsTaskEncodeOptionsCopyWith<$Res>? get encodeOptions;@override $AbsTaskScanResultsCopyWith<$Res>? get scanResults;

}
/// @nodoc
class __$AbsTaskDataCopyWithImpl<$Res>
    implements _$AbsTaskDataCopyWith<$Res> {
  __$AbsTaskDataCopyWithImpl(this._self, this._then);

  final _AbsTaskData _self;
  final $Res Function(_AbsTaskData) _then;

/// Create a copy of AbsTaskData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? libraryItemId = freezed,Object? libraryId = freezed,Object? ino = freezed,Object? encodeOptions = freezed,Object? scanResults = freezed,}) {
  return _then(_AbsTaskData(
libraryItemId: freezed == libraryItemId ? _self.libraryItemId : libraryItemId // ignore: cast_nullable_to_non_nullable
as String?,libraryId: freezed == libraryId ? _self.libraryId : libraryId // ignore: cast_nullable_to_non_nullable
as String?,ino: freezed == ino ? _self.ino : ino // ignore: cast_nullable_to_non_nullable
as String?,encodeOptions: freezed == encodeOptions ? _self.encodeOptions : encodeOptions // ignore: cast_nullable_to_non_nullable
as AbsTaskEncodeOptions?,scanResults: freezed == scanResults ? _self.scanResults : scanResults // ignore: cast_nullable_to_non_nullable
as AbsTaskScanResults?,
  ));
}

/// Create a copy of AbsTaskData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AbsTaskEncodeOptionsCopyWith<$Res>? get encodeOptions {
    if (_self.encodeOptions == null) {
    return null;
  }

  return $AbsTaskEncodeOptionsCopyWith<$Res>(_self.encodeOptions!, (value) {
    return _then(_self.copyWith(encodeOptions: value));
  });
}/// Create a copy of AbsTaskData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AbsTaskScanResultsCopyWith<$Res>? get scanResults {
    if (_self.scanResults == null) {
    return null;
  }

  return $AbsTaskScanResultsCopyWith<$Res>(_self.scanResults!, (value) {
    return _then(_self.copyWith(scanResults: value));
  });
}
}


/// @nodoc
mixin _$AbsTaskEncodeOptions {

@JsonKey(name: 'codec', fromJson: _stringFromDynamic) String? get codec;@JsonKey(name: 'bitrate', fromJson: _stringFromDynamic) String? get bitrate;@JsonKey(name: 'channels', fromJson: jsonIntFromDynamic) int? get channels;
/// Create a copy of AbsTaskEncodeOptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AbsTaskEncodeOptionsCopyWith<AbsTaskEncodeOptions> get copyWith => _$AbsTaskEncodeOptionsCopyWithImpl<AbsTaskEncodeOptions>(this as AbsTaskEncodeOptions, _$identity);

  /// Serializes this AbsTaskEncodeOptions to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AbsTaskEncodeOptions&&(identical(other.codec, codec) || other.codec == codec)&&(identical(other.bitrate, bitrate) || other.bitrate == bitrate)&&(identical(other.channels, channels) || other.channels == channels));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,codec,bitrate,channels);

@override
String toString() {
  return 'AbsTaskEncodeOptions(codec: $codec, bitrate: $bitrate, channels: $channels)';
}


}

/// @nodoc
abstract mixin class $AbsTaskEncodeOptionsCopyWith<$Res>  {
  factory $AbsTaskEncodeOptionsCopyWith(AbsTaskEncodeOptions value, $Res Function(AbsTaskEncodeOptions) _then) = _$AbsTaskEncodeOptionsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'codec', fromJson: _stringFromDynamic) String? codec,@JsonKey(name: 'bitrate', fromJson: _stringFromDynamic) String? bitrate,@JsonKey(name: 'channels', fromJson: jsonIntFromDynamic) int? channels
});




}
/// @nodoc
class _$AbsTaskEncodeOptionsCopyWithImpl<$Res>
    implements $AbsTaskEncodeOptionsCopyWith<$Res> {
  _$AbsTaskEncodeOptionsCopyWithImpl(this._self, this._then);

  final AbsTaskEncodeOptions _self;
  final $Res Function(AbsTaskEncodeOptions) _then;

/// Create a copy of AbsTaskEncodeOptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? codec = freezed,Object? bitrate = freezed,Object? channels = freezed,}) {
  return _then(_self.copyWith(
codec: freezed == codec ? _self.codec : codec // ignore: cast_nullable_to_non_nullable
as String?,bitrate: freezed == bitrate ? _self.bitrate : bitrate // ignore: cast_nullable_to_non_nullable
as String?,channels: freezed == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [AbsTaskEncodeOptions].
extension AbsTaskEncodeOptionsPatterns on AbsTaskEncodeOptions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AbsTaskEncodeOptions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AbsTaskEncodeOptions() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AbsTaskEncodeOptions value)  $default,){
final _that = this;
switch (_that) {
case _AbsTaskEncodeOptions():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AbsTaskEncodeOptions value)?  $default,){
final _that = this;
switch (_that) {
case _AbsTaskEncodeOptions() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'codec', fromJson: _stringFromDynamic)  String? codec, @JsonKey(name: 'bitrate', fromJson: _stringFromDynamic)  String? bitrate, @JsonKey(name: 'channels', fromJson: jsonIntFromDynamic)  int? channels)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AbsTaskEncodeOptions() when $default != null:
return $default(_that.codec,_that.bitrate,_that.channels);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'codec', fromJson: _stringFromDynamic)  String? codec, @JsonKey(name: 'bitrate', fromJson: _stringFromDynamic)  String? bitrate, @JsonKey(name: 'channels', fromJson: jsonIntFromDynamic)  int? channels)  $default,) {final _that = this;
switch (_that) {
case _AbsTaskEncodeOptions():
return $default(_that.codec,_that.bitrate,_that.channels);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'codec', fromJson: _stringFromDynamic)  String? codec, @JsonKey(name: 'bitrate', fromJson: _stringFromDynamic)  String? bitrate, @JsonKey(name: 'channels', fromJson: jsonIntFromDynamic)  int? channels)?  $default,) {final _that = this;
switch (_that) {
case _AbsTaskEncodeOptions() when $default != null:
return $default(_that.codec,_that.bitrate,_that.channels);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AbsTaskEncodeOptions implements AbsTaskEncodeOptions {
  const _AbsTaskEncodeOptions({@JsonKey(name: 'codec', fromJson: _stringFromDynamic) this.codec, @JsonKey(name: 'bitrate', fromJson: _stringFromDynamic) this.bitrate, @JsonKey(name: 'channels', fromJson: jsonIntFromDynamic) this.channels});
  factory _AbsTaskEncodeOptions.fromJson(Map<String, dynamic> json) => _$AbsTaskEncodeOptionsFromJson(json);

@override@JsonKey(name: 'codec', fromJson: _stringFromDynamic) final  String? codec;
@override@JsonKey(name: 'bitrate', fromJson: _stringFromDynamic) final  String? bitrate;
@override@JsonKey(name: 'channels', fromJson: jsonIntFromDynamic) final  int? channels;

/// Create a copy of AbsTaskEncodeOptions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AbsTaskEncodeOptionsCopyWith<_AbsTaskEncodeOptions> get copyWith => __$AbsTaskEncodeOptionsCopyWithImpl<_AbsTaskEncodeOptions>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AbsTaskEncodeOptionsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AbsTaskEncodeOptions&&(identical(other.codec, codec) || other.codec == codec)&&(identical(other.bitrate, bitrate) || other.bitrate == bitrate)&&(identical(other.channels, channels) || other.channels == channels));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,codec,bitrate,channels);

@override
String toString() {
  return 'AbsTaskEncodeOptions(codec: $codec, bitrate: $bitrate, channels: $channels)';
}


}

/// @nodoc
abstract mixin class _$AbsTaskEncodeOptionsCopyWith<$Res> implements $AbsTaskEncodeOptionsCopyWith<$Res> {
  factory _$AbsTaskEncodeOptionsCopyWith(_AbsTaskEncodeOptions value, $Res Function(_AbsTaskEncodeOptions) _then) = __$AbsTaskEncodeOptionsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'codec', fromJson: _stringFromDynamic) String? codec,@JsonKey(name: 'bitrate', fromJson: _stringFromDynamic) String? bitrate,@JsonKey(name: 'channels', fromJson: jsonIntFromDynamic) int? channels
});




}
/// @nodoc
class __$AbsTaskEncodeOptionsCopyWithImpl<$Res>
    implements _$AbsTaskEncodeOptionsCopyWith<$Res> {
  __$AbsTaskEncodeOptionsCopyWithImpl(this._self, this._then);

  final _AbsTaskEncodeOptions _self;
  final $Res Function(_AbsTaskEncodeOptions) _then;

/// Create a copy of AbsTaskEncodeOptions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? codec = freezed,Object? bitrate = freezed,Object? channels = freezed,}) {
  return _then(_AbsTaskEncodeOptions(
codec: freezed == codec ? _self.codec : codec // ignore: cast_nullable_to_non_nullable
as String?,bitrate: freezed == bitrate ? _self.bitrate : bitrate // ignore: cast_nullable_to_non_nullable
as String?,channels: freezed == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$AbsTaskScanResults {

@JsonKey(name: 'added', fromJson: jsonIntFromDynamic) int? get added;@JsonKey(name: 'updated', fromJson: jsonIntFromDynamic) int? get updated;@JsonKey(name: 'missing', fromJson: jsonIntFromDynamic) int? get missing;@JsonKey(name: 'elapsed', fromJson: jsonIntFromDynamic) int? get elapsed;
/// Create a copy of AbsTaskScanResults
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AbsTaskScanResultsCopyWith<AbsTaskScanResults> get copyWith => _$AbsTaskScanResultsCopyWithImpl<AbsTaskScanResults>(this as AbsTaskScanResults, _$identity);

  /// Serializes this AbsTaskScanResults to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AbsTaskScanResults&&(identical(other.added, added) || other.added == added)&&(identical(other.updated, updated) || other.updated == updated)&&(identical(other.missing, missing) || other.missing == missing)&&(identical(other.elapsed, elapsed) || other.elapsed == elapsed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,added,updated,missing,elapsed);

@override
String toString() {
  return 'AbsTaskScanResults(added: $added, updated: $updated, missing: $missing, elapsed: $elapsed)';
}


}

/// @nodoc
abstract mixin class $AbsTaskScanResultsCopyWith<$Res>  {
  factory $AbsTaskScanResultsCopyWith(AbsTaskScanResults value, $Res Function(AbsTaskScanResults) _then) = _$AbsTaskScanResultsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'added', fromJson: jsonIntFromDynamic) int? added,@JsonKey(name: 'updated', fromJson: jsonIntFromDynamic) int? updated,@JsonKey(name: 'missing', fromJson: jsonIntFromDynamic) int? missing,@JsonKey(name: 'elapsed', fromJson: jsonIntFromDynamic) int? elapsed
});




}
/// @nodoc
class _$AbsTaskScanResultsCopyWithImpl<$Res>
    implements $AbsTaskScanResultsCopyWith<$Res> {
  _$AbsTaskScanResultsCopyWithImpl(this._self, this._then);

  final AbsTaskScanResults _self;
  final $Res Function(AbsTaskScanResults) _then;

/// Create a copy of AbsTaskScanResults
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? added = freezed,Object? updated = freezed,Object? missing = freezed,Object? elapsed = freezed,}) {
  return _then(_self.copyWith(
added: freezed == added ? _self.added : added // ignore: cast_nullable_to_non_nullable
as int?,updated: freezed == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as int?,missing: freezed == missing ? _self.missing : missing // ignore: cast_nullable_to_non_nullable
as int?,elapsed: freezed == elapsed ? _self.elapsed : elapsed // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [AbsTaskScanResults].
extension AbsTaskScanResultsPatterns on AbsTaskScanResults {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AbsTaskScanResults value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AbsTaskScanResults() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AbsTaskScanResults value)  $default,){
final _that = this;
switch (_that) {
case _AbsTaskScanResults():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AbsTaskScanResults value)?  $default,){
final _that = this;
switch (_that) {
case _AbsTaskScanResults() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'added', fromJson: jsonIntFromDynamic)  int? added, @JsonKey(name: 'updated', fromJson: jsonIntFromDynamic)  int? updated, @JsonKey(name: 'missing', fromJson: jsonIntFromDynamic)  int? missing, @JsonKey(name: 'elapsed', fromJson: jsonIntFromDynamic)  int? elapsed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AbsTaskScanResults() when $default != null:
return $default(_that.added,_that.updated,_that.missing,_that.elapsed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'added', fromJson: jsonIntFromDynamic)  int? added, @JsonKey(name: 'updated', fromJson: jsonIntFromDynamic)  int? updated, @JsonKey(name: 'missing', fromJson: jsonIntFromDynamic)  int? missing, @JsonKey(name: 'elapsed', fromJson: jsonIntFromDynamic)  int? elapsed)  $default,) {final _that = this;
switch (_that) {
case _AbsTaskScanResults():
return $default(_that.added,_that.updated,_that.missing,_that.elapsed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'added', fromJson: jsonIntFromDynamic)  int? added, @JsonKey(name: 'updated', fromJson: jsonIntFromDynamic)  int? updated, @JsonKey(name: 'missing', fromJson: jsonIntFromDynamic)  int? missing, @JsonKey(name: 'elapsed', fromJson: jsonIntFromDynamic)  int? elapsed)?  $default,) {final _that = this;
switch (_that) {
case _AbsTaskScanResults() when $default != null:
return $default(_that.added,_that.updated,_that.missing,_that.elapsed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AbsTaskScanResults implements AbsTaskScanResults {
  const _AbsTaskScanResults({@JsonKey(name: 'added', fromJson: jsonIntFromDynamic) this.added, @JsonKey(name: 'updated', fromJson: jsonIntFromDynamic) this.updated, @JsonKey(name: 'missing', fromJson: jsonIntFromDynamic) this.missing, @JsonKey(name: 'elapsed', fromJson: jsonIntFromDynamic) this.elapsed});
  factory _AbsTaskScanResults.fromJson(Map<String, dynamic> json) => _$AbsTaskScanResultsFromJson(json);

@override@JsonKey(name: 'added', fromJson: jsonIntFromDynamic) final  int? added;
@override@JsonKey(name: 'updated', fromJson: jsonIntFromDynamic) final  int? updated;
@override@JsonKey(name: 'missing', fromJson: jsonIntFromDynamic) final  int? missing;
@override@JsonKey(name: 'elapsed', fromJson: jsonIntFromDynamic) final  int? elapsed;

/// Create a copy of AbsTaskScanResults
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AbsTaskScanResultsCopyWith<_AbsTaskScanResults> get copyWith => __$AbsTaskScanResultsCopyWithImpl<_AbsTaskScanResults>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AbsTaskScanResultsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AbsTaskScanResults&&(identical(other.added, added) || other.added == added)&&(identical(other.updated, updated) || other.updated == updated)&&(identical(other.missing, missing) || other.missing == missing)&&(identical(other.elapsed, elapsed) || other.elapsed == elapsed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,added,updated,missing,elapsed);

@override
String toString() {
  return 'AbsTaskScanResults(added: $added, updated: $updated, missing: $missing, elapsed: $elapsed)';
}


}

/// @nodoc
abstract mixin class _$AbsTaskScanResultsCopyWith<$Res> implements $AbsTaskScanResultsCopyWith<$Res> {
  factory _$AbsTaskScanResultsCopyWith(_AbsTaskScanResults value, $Res Function(_AbsTaskScanResults) _then) = __$AbsTaskScanResultsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'added', fromJson: jsonIntFromDynamic) int? added,@JsonKey(name: 'updated', fromJson: jsonIntFromDynamic) int? updated,@JsonKey(name: 'missing', fromJson: jsonIntFromDynamic) int? missing,@JsonKey(name: 'elapsed', fromJson: jsonIntFromDynamic) int? elapsed
});




}
/// @nodoc
class __$AbsTaskScanResultsCopyWithImpl<$Res>
    implements _$AbsTaskScanResultsCopyWith<$Res> {
  __$AbsTaskScanResultsCopyWithImpl(this._self, this._then);

  final _AbsTaskScanResults _self;
  final $Res Function(_AbsTaskScanResults) _then;

/// Create a copy of AbsTaskScanResults
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? added = freezed,Object? updated = freezed,Object? missing = freezed,Object? elapsed = freezed,}) {
  return _then(_AbsTaskScanResults(
added: freezed == added ? _self.added : added // ignore: cast_nullable_to_non_nullable
as int?,updated: freezed == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as int?,missing: freezed == missing ? _self.missing : missing // ignore: cast_nullable_to_non_nullable
as int?,elapsed: freezed == elapsed ? _self.elapsed : elapsed // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
