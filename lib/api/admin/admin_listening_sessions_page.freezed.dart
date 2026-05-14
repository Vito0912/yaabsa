// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_listening_sessions_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdminListeningSessionsPage {

 int get total; int get numPages; int get page; int get itemsPerPage; List<AdminListeningSession> get sessions;
/// Create a copy of AdminListeningSessionsPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminListeningSessionsPageCopyWith<AdminListeningSessionsPage> get copyWith => _$AdminListeningSessionsPageCopyWithImpl<AdminListeningSessionsPage>(this as AdminListeningSessionsPage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminListeningSessionsPage&&(identical(other.total, total) || other.total == total)&&(identical(other.numPages, numPages) || other.numPages == numPages)&&(identical(other.page, page) || other.page == page)&&(identical(other.itemsPerPage, itemsPerPage) || other.itemsPerPage == itemsPerPage)&&const DeepCollectionEquality().equals(other.sessions, sessions));
}


@override
int get hashCode => Object.hash(runtimeType,total,numPages,page,itemsPerPage,const DeepCollectionEquality().hash(sessions));

@override
String toString() {
  return 'AdminListeningSessionsPage(total: $total, numPages: $numPages, page: $page, itemsPerPage: $itemsPerPage, sessions: $sessions)';
}


}

/// @nodoc
abstract mixin class $AdminListeningSessionsPageCopyWith<$Res>  {
  factory $AdminListeningSessionsPageCopyWith(AdminListeningSessionsPage value, $Res Function(AdminListeningSessionsPage) _then) = _$AdminListeningSessionsPageCopyWithImpl;
@useResult
$Res call({
 int total, int numPages, int page, int itemsPerPage, List<AdminListeningSession> sessions
});




}
/// @nodoc
class _$AdminListeningSessionsPageCopyWithImpl<$Res>
    implements $AdminListeningSessionsPageCopyWith<$Res> {
  _$AdminListeningSessionsPageCopyWithImpl(this._self, this._then);

  final AdminListeningSessionsPage _self;
  final $Res Function(AdminListeningSessionsPage) _then;

/// Create a copy of AdminListeningSessionsPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? numPages = null,Object? page = null,Object? itemsPerPage = null,Object? sessions = null,}) {
  return _then(_self.copyWith(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,numPages: null == numPages ? _self.numPages : numPages // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,itemsPerPage: null == itemsPerPage ? _self.itemsPerPage : itemsPerPage // ignore: cast_nullable_to_non_nullable
as int,sessions: null == sessions ? _self.sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<AdminListeningSession>,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminListeningSessionsPage].
extension AdminListeningSessionsPagePatterns on AdminListeningSessionsPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminListeningSessionsPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminListeningSessionsPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminListeningSessionsPage value)  $default,){
final _that = this;
switch (_that) {
case _AdminListeningSessionsPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminListeningSessionsPage value)?  $default,){
final _that = this;
switch (_that) {
case _AdminListeningSessionsPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total,  int numPages,  int page,  int itemsPerPage,  List<AdminListeningSession> sessions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminListeningSessionsPage() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total,  int numPages,  int page,  int itemsPerPage,  List<AdminListeningSession> sessions)  $default,) {final _that = this;
switch (_that) {
case _AdminListeningSessionsPage():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total,  int numPages,  int page,  int itemsPerPage,  List<AdminListeningSession> sessions)?  $default,) {final _that = this;
switch (_that) {
case _AdminListeningSessionsPage() when $default != null:
return $default(_that.total,_that.numPages,_that.page,_that.itemsPerPage,_that.sessions);case _:
  return null;

}
}

}

/// @nodoc


class _AdminListeningSessionsPage implements AdminListeningSessionsPage {
  const _AdminListeningSessionsPage({this.total = 0, this.numPages = 0, this.page = 0, this.itemsPerPage = 0, final  List<AdminListeningSession> sessions = const <AdminListeningSession>[]}): _sessions = sessions;
  

@override@JsonKey() final  int total;
@override@JsonKey() final  int numPages;
@override@JsonKey() final  int page;
@override@JsonKey() final  int itemsPerPage;
 final  List<AdminListeningSession> _sessions;
@override@JsonKey() List<AdminListeningSession> get sessions {
  if (_sessions is EqualUnmodifiableListView) return _sessions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sessions);
}


/// Create a copy of AdminListeningSessionsPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminListeningSessionsPageCopyWith<_AdminListeningSessionsPage> get copyWith => __$AdminListeningSessionsPageCopyWithImpl<_AdminListeningSessionsPage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminListeningSessionsPage&&(identical(other.total, total) || other.total == total)&&(identical(other.numPages, numPages) || other.numPages == numPages)&&(identical(other.page, page) || other.page == page)&&(identical(other.itemsPerPage, itemsPerPage) || other.itemsPerPage == itemsPerPage)&&const DeepCollectionEquality().equals(other._sessions, _sessions));
}


@override
int get hashCode => Object.hash(runtimeType,total,numPages,page,itemsPerPage,const DeepCollectionEquality().hash(_sessions));

@override
String toString() {
  return 'AdminListeningSessionsPage(total: $total, numPages: $numPages, page: $page, itemsPerPage: $itemsPerPage, sessions: $sessions)';
}


}

/// @nodoc
abstract mixin class _$AdminListeningSessionsPageCopyWith<$Res> implements $AdminListeningSessionsPageCopyWith<$Res> {
  factory _$AdminListeningSessionsPageCopyWith(_AdminListeningSessionsPage value, $Res Function(_AdminListeningSessionsPage) _then) = __$AdminListeningSessionsPageCopyWithImpl;
@override @useResult
$Res call({
 int total, int numPages, int page, int itemsPerPage, List<AdminListeningSession> sessions
});




}
/// @nodoc
class __$AdminListeningSessionsPageCopyWithImpl<$Res>
    implements _$AdminListeningSessionsPageCopyWith<$Res> {
  __$AdminListeningSessionsPageCopyWithImpl(this._self, this._then);

  final _AdminListeningSessionsPage _self;
  final $Res Function(_AdminListeningSessionsPage) _then;

/// Create a copy of AdminListeningSessionsPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? numPages = null,Object? page = null,Object? itemsPerPage = null,Object? sessions = null,}) {
  return _then(_AdminListeningSessionsPage(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,numPages: null == numPages ? _self.numPages : numPages // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,itemsPerPage: null == itemsPerPage ? _self.itemsPerPage : itemsPerPage // ignore: cast_nullable_to_non_nullable
as int,sessions: null == sessions ? _self._sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<AdminListeningSession>,
  ));
}


}

// dart format on
