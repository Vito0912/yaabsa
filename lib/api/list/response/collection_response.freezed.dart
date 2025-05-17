// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collection_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CollectionResponse {

@JsonKey(name: "collections") List<Collection> get items;
/// Create a copy of CollectionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollectionResponseCopyWith<CollectionResponse> get copyWith => _$CollectionResponseCopyWithImpl<CollectionResponse>(this as CollectionResponse, _$identity);

  /// Serializes this CollectionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollectionResponse&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'CollectionResponse(items: $items)';
}


}

/// @nodoc
abstract mixin class $CollectionResponseCopyWith<$Res>  {
  factory $CollectionResponseCopyWith(CollectionResponse value, $Res Function(CollectionResponse) _then) = _$CollectionResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "collections") List<Collection> items
});




}
/// @nodoc
class _$CollectionResponseCopyWithImpl<$Res>
    implements $CollectionResponseCopyWith<$Res> {
  _$CollectionResponseCopyWithImpl(this._self, this._then);

  final CollectionResponse _self;
  final $Res Function(CollectionResponse) _then;

/// Create a copy of CollectionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Collection>,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _CollectionResponse implements CollectionResponse {
  const _CollectionResponse({@JsonKey(name: "collections") required final  List<Collection> items}): _items = items;
  factory _CollectionResponse.fromJson(Map<String, dynamic> json) => _$CollectionResponseFromJson(json);

 final  List<Collection> _items;
@override@JsonKey(name: "collections") List<Collection> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of CollectionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CollectionResponseCopyWith<_CollectionResponse> get copyWith => __$CollectionResponseCopyWithImpl<_CollectionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CollectionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CollectionResponse&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'CollectionResponse(items: $items)';
}


}

/// @nodoc
abstract mixin class _$CollectionResponseCopyWith<$Res> implements $CollectionResponseCopyWith<$Res> {
  factory _$CollectionResponseCopyWith(_CollectionResponse value, $Res Function(_CollectionResponse) _then) = __$CollectionResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "collections") List<Collection> items
});




}
/// @nodoc
class __$CollectionResponseCopyWithImpl<$Res>
    implements _$CollectionResponseCopyWith<$Res> {
  __$CollectionResponseCopyWithImpl(this._self, this._then);

  final _CollectionResponse _self;
  final $Res Function(_CollectionResponse) _then;

/// Create a copy of CollectionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_CollectionResponse(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Collection>,
  ));
}


}

// dart format on
