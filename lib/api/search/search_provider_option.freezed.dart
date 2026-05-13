// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_provider_option.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchProviderOption {

@JsonKey(name: 'value') String get value;@JsonKey(name: 'text') String get text;
/// Create a copy of SearchProviderOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchProviderOptionCopyWith<SearchProviderOption> get copyWith => _$SearchProviderOptionCopyWithImpl<SearchProviderOption>(this as SearchProviderOption, _$identity);

  /// Serializes this SearchProviderOption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchProviderOption&&(identical(other.value, value) || other.value == value)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value,text);

@override
String toString() {
  return 'SearchProviderOption(value: $value, text: $text)';
}


}

/// @nodoc
abstract mixin class $SearchProviderOptionCopyWith<$Res>  {
  factory $SearchProviderOptionCopyWith(SearchProviderOption value, $Res Function(SearchProviderOption) _then) = _$SearchProviderOptionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'value') String value,@JsonKey(name: 'text') String text
});




}
/// @nodoc
class _$SearchProviderOptionCopyWithImpl<$Res>
    implements $SearchProviderOptionCopyWith<$Res> {
  _$SearchProviderOptionCopyWithImpl(this._self, this._then);

  final SearchProviderOption _self;
  final $Res Function(SearchProviderOption) _then;

/// Create a copy of SearchProviderOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,Object? text = null,}) {
  return _then(_self.copyWith(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchProviderOption].
extension SearchProviderOptionPatterns on SearchProviderOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchProviderOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchProviderOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchProviderOption value)  $default,){
final _that = this;
switch (_that) {
case _SearchProviderOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchProviderOption value)?  $default,){
final _that = this;
switch (_that) {
case _SearchProviderOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'value')  String value, @JsonKey(name: 'text')  String text)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchProviderOption() when $default != null:
return $default(_that.value,_that.text);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'value')  String value, @JsonKey(name: 'text')  String text)  $default,) {final _that = this;
switch (_that) {
case _SearchProviderOption():
return $default(_that.value,_that.text);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'value')  String value, @JsonKey(name: 'text')  String text)?  $default,) {final _that = this;
switch (_that) {
case _SearchProviderOption() when $default != null:
return $default(_that.value,_that.text);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchProviderOption implements SearchProviderOption {
  const _SearchProviderOption({@JsonKey(name: 'value') required this.value, @JsonKey(name: 'text') required this.text});
  factory _SearchProviderOption.fromJson(Map<String, dynamic> json) => _$SearchProviderOptionFromJson(json);

@override@JsonKey(name: 'value') final  String value;
@override@JsonKey(name: 'text') final  String text;

/// Create a copy of SearchProviderOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchProviderOptionCopyWith<_SearchProviderOption> get copyWith => __$SearchProviderOptionCopyWithImpl<_SearchProviderOption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchProviderOptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchProviderOption&&(identical(other.value, value) || other.value == value)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value,text);

@override
String toString() {
  return 'SearchProviderOption(value: $value, text: $text)';
}


}

/// @nodoc
abstract mixin class _$SearchProviderOptionCopyWith<$Res> implements $SearchProviderOptionCopyWith<$Res> {
  factory _$SearchProviderOptionCopyWith(_SearchProviderOption value, $Res Function(_SearchProviderOption) _then) = __$SearchProviderOptionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'value') String value,@JsonKey(name: 'text') String text
});




}
/// @nodoc
class __$SearchProviderOptionCopyWithImpl<$Res>
    implements _$SearchProviderOptionCopyWith<$Res> {
  __$SearchProviderOptionCopyWithImpl(this._self, this._then);

  final _SearchProviderOption _self;
  final $Res Function(_SearchProviderOption) _then;

/// Create a copy of SearchProviderOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,Object? text = null,}) {
  return _then(_SearchProviderOption(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
