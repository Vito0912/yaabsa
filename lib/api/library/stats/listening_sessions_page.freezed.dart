// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'listening_sessions_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ListeningSessionsPage {

@JsonKey(name: 'total') int? get total;@JsonKey(name: 'numPages') int? get numPages;@JsonKey(name: 'page') int? get page;@JsonKey(name: 'itemsPerPage') int? get itemsPerPage;@JsonKey(name: 'sessions') List<PlaybackSession> get sessions;
/// Create a copy of ListeningSessionsPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListeningSessionsPageCopyWith<ListeningSessionsPage> get copyWith => _$ListeningSessionsPageCopyWithImpl<ListeningSessionsPage>(this as ListeningSessionsPage, _$identity);

  /// Serializes this ListeningSessionsPage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListeningSessionsPage&&(identical(other.total, total) || other.total == total)&&(identical(other.numPages, numPages) || other.numPages == numPages)&&(identical(other.page, page) || other.page == page)&&(identical(other.itemsPerPage, itemsPerPage) || other.itemsPerPage == itemsPerPage)&&const DeepCollectionEquality().equals(other.sessions, sessions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,numPages,page,itemsPerPage,const DeepCollectionEquality().hash(sessions));

@override
String toString() {
  return 'ListeningSessionsPage(total: $total, numPages: $numPages, page: $page, itemsPerPage: $itemsPerPage, sessions: $sessions)';
}


}

/// @nodoc
abstract mixin class $ListeningSessionsPageCopyWith<$Res>  {
  factory $ListeningSessionsPageCopyWith(ListeningSessionsPage value, $Res Function(ListeningSessionsPage) _then) = _$ListeningSessionsPageCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total') int? total,@JsonKey(name: 'numPages') int? numPages,@JsonKey(name: 'page') int? page,@JsonKey(name: 'itemsPerPage') int? itemsPerPage,@JsonKey(name: 'sessions') List<PlaybackSession> sessions
});




}
/// @nodoc
class _$ListeningSessionsPageCopyWithImpl<$Res>
    implements $ListeningSessionsPageCopyWith<$Res> {
  _$ListeningSessionsPageCopyWithImpl(this._self, this._then);

  final ListeningSessionsPage _self;
  final $Res Function(ListeningSessionsPage) _then;

/// Create a copy of ListeningSessionsPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = freezed,Object? numPages = freezed,Object? page = freezed,Object? itemsPerPage = freezed,Object? sessions = null,}) {
  return _then(_self.copyWith(
total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,numPages: freezed == numPages ? _self.numPages : numPages // ignore: cast_nullable_to_non_nullable
as int?,page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int?,itemsPerPage: freezed == itemsPerPage ? _self.itemsPerPage : itemsPerPage // ignore: cast_nullable_to_non_nullable
as int?,sessions: null == sessions ? _self.sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<PlaybackSession>,
  ));
}

}


/// Adds pattern-matching-related methods to [ListeningSessionsPage].
extension ListeningSessionsPagePatterns on ListeningSessionsPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListeningSessionsPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListeningSessionsPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListeningSessionsPage value)  $default,){
final _that = this;
switch (_that) {
case _ListeningSessionsPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListeningSessionsPage value)?  $default,){
final _that = this;
switch (_that) {
case _ListeningSessionsPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total')  int? total, @JsonKey(name: 'numPages')  int? numPages, @JsonKey(name: 'page')  int? page, @JsonKey(name: 'itemsPerPage')  int? itemsPerPage, @JsonKey(name: 'sessions')  List<PlaybackSession> sessions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ListeningSessionsPage() when $default != null:
return $default(_that.total,_that.numPages,_that.page,_that.itemsPerPage,_that.sessions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total')  int? total, @JsonKey(name: 'numPages')  int? numPages, @JsonKey(name: 'page')  int? page, @JsonKey(name: 'itemsPerPage')  int? itemsPerPage, @JsonKey(name: 'sessions')  List<PlaybackSession> sessions)  $default,) {final _that = this;
switch (_that) {
case _ListeningSessionsPage():
return $default(_that.total,_that.numPages,_that.page,_that.itemsPerPage,_that.sessions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total')  int? total, @JsonKey(name: 'numPages')  int? numPages, @JsonKey(name: 'page')  int? page, @JsonKey(name: 'itemsPerPage')  int? itemsPerPage, @JsonKey(name: 'sessions')  List<PlaybackSession> sessions)?  $default,) {final _that = this;
switch (_that) {
case _ListeningSessionsPage() when $default != null:
return $default(_that.total,_that.numPages,_that.page,_that.itemsPerPage,_that.sessions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ListeningSessionsPage implements ListeningSessionsPage {
  const _ListeningSessionsPage({@JsonKey(name: 'total') this.total, @JsonKey(name: 'numPages') this.numPages, @JsonKey(name: 'page') this.page, @JsonKey(name: 'itemsPerPage') this.itemsPerPage, @JsonKey(name: 'sessions') final  List<PlaybackSession> sessions = const <PlaybackSession>[]}): _sessions = sessions;
  factory _ListeningSessionsPage.fromJson(Map<String, dynamic> json) => _$ListeningSessionsPageFromJson(json);

@override@JsonKey(name: 'total') final  int? total;
@override@JsonKey(name: 'numPages') final  int? numPages;
@override@JsonKey(name: 'page') final  int? page;
@override@JsonKey(name: 'itemsPerPage') final  int? itemsPerPage;
 final  List<PlaybackSession> _sessions;
@override@JsonKey(name: 'sessions') List<PlaybackSession> get sessions {
  if (_sessions is EqualUnmodifiableListView) return _sessions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sessions);
}


/// Create a copy of ListeningSessionsPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListeningSessionsPageCopyWith<_ListeningSessionsPage> get copyWith => __$ListeningSessionsPageCopyWithImpl<_ListeningSessionsPage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ListeningSessionsPageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListeningSessionsPage&&(identical(other.total, total) || other.total == total)&&(identical(other.numPages, numPages) || other.numPages == numPages)&&(identical(other.page, page) || other.page == page)&&(identical(other.itemsPerPage, itemsPerPage) || other.itemsPerPage == itemsPerPage)&&const DeepCollectionEquality().equals(other._sessions, _sessions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,numPages,page,itemsPerPage,const DeepCollectionEquality().hash(_sessions));

@override
String toString() {
  return 'ListeningSessionsPage(total: $total, numPages: $numPages, page: $page, itemsPerPage: $itemsPerPage, sessions: $sessions)';
}


}

/// @nodoc
abstract mixin class _$ListeningSessionsPageCopyWith<$Res> implements $ListeningSessionsPageCopyWith<$Res> {
  factory _$ListeningSessionsPageCopyWith(_ListeningSessionsPage value, $Res Function(_ListeningSessionsPage) _then) = __$ListeningSessionsPageCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total') int? total,@JsonKey(name: 'numPages') int? numPages,@JsonKey(name: 'page') int? page,@JsonKey(name: 'itemsPerPage') int? itemsPerPage,@JsonKey(name: 'sessions') List<PlaybackSession> sessions
});




}
/// @nodoc
class __$ListeningSessionsPageCopyWithImpl<$Res>
    implements _$ListeningSessionsPageCopyWith<$Res> {
  __$ListeningSessionsPageCopyWithImpl(this._self, this._then);

  final _ListeningSessionsPage _self;
  final $Res Function(_ListeningSessionsPage) _then;

/// Create a copy of ListeningSessionsPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = freezed,Object? numPages = freezed,Object? page = freezed,Object? itemsPerPage = freezed,Object? sessions = null,}) {
  return _then(_ListeningSessionsPage(
total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,numPages: freezed == numPages ? _self.numPages : numPages // ignore: cast_nullable_to_non_nullable
as int?,page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int?,itemsPerPage: freezed == itemsPerPage ? _self.itemsPerPage : itemsPerPage // ignore: cast_nullable_to_non_nullable
as int?,sessions: null == sessions ? _self._sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<PlaybackSession>,
  ));
}


}

// dart format on
