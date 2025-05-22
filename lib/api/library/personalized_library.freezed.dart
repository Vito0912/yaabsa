// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'personalized_library.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PersonalizedLibrary {

 ShelfEntry<LibraryItem>? get continueListening; ShelfEntry<LibraryItem>? get recentlyAdded; ShelfEntry<Series>? get recentSeries; ShelfEntry<LibraryItem>? get discover; ShelfEntry<LibraryItem>? get listenAgain; ShelfEntry<Author>? get newestAuthors; ShelfEntry<Episode>? get newestEpisodes; ShelfEntry<LibraryItem>? get continueSeries;
/// Create a copy of PersonalizedLibrary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonalizedLibraryCopyWith<PersonalizedLibrary> get copyWith => _$PersonalizedLibraryCopyWithImpl<PersonalizedLibrary>(this as PersonalizedLibrary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonalizedLibrary&&(identical(other.continueListening, continueListening) || other.continueListening == continueListening)&&(identical(other.recentlyAdded, recentlyAdded) || other.recentlyAdded == recentlyAdded)&&(identical(other.recentSeries, recentSeries) || other.recentSeries == recentSeries)&&(identical(other.discover, discover) || other.discover == discover)&&(identical(other.listenAgain, listenAgain) || other.listenAgain == listenAgain)&&(identical(other.newestAuthors, newestAuthors) || other.newestAuthors == newestAuthors)&&(identical(other.newestEpisodes, newestEpisodes) || other.newestEpisodes == newestEpisodes)&&(identical(other.continueSeries, continueSeries) || other.continueSeries == continueSeries));
}


@override
int get hashCode => Object.hash(runtimeType,continueListening,recentlyAdded,recentSeries,discover,listenAgain,newestAuthors,newestEpisodes,continueSeries);

@override
String toString() {
  return 'PersonalizedLibrary(continueListening: $continueListening, recentlyAdded: $recentlyAdded, recentSeries: $recentSeries, discover: $discover, listenAgain: $listenAgain, newestAuthors: $newestAuthors, newestEpisodes: $newestEpisodes, continueSeries: $continueSeries)';
}


}

/// @nodoc
abstract mixin class $PersonalizedLibraryCopyWith<$Res>  {
  factory $PersonalizedLibraryCopyWith(PersonalizedLibrary value, $Res Function(PersonalizedLibrary) _then) = _$PersonalizedLibraryCopyWithImpl;
@useResult
$Res call({
 ShelfEntry<LibraryItem>? continueListening, ShelfEntry<LibraryItem>? recentlyAdded, ShelfEntry<Series>? recentSeries, ShelfEntry<LibraryItem>? discover, ShelfEntry<LibraryItem>? listenAgain, ShelfEntry<Author>? newestAuthors, ShelfEntry<Episode>? newestEpisodes, ShelfEntry<LibraryItem>? continueSeries
});


$ShelfEntryCopyWith<LibraryItem, $Res>? get continueListening;$ShelfEntryCopyWith<LibraryItem, $Res>? get recentlyAdded;$ShelfEntryCopyWith<Series, $Res>? get recentSeries;$ShelfEntryCopyWith<LibraryItem, $Res>? get discover;$ShelfEntryCopyWith<LibraryItem, $Res>? get listenAgain;$ShelfEntryCopyWith<Author, $Res>? get newestAuthors;$ShelfEntryCopyWith<Episode, $Res>? get newestEpisodes;$ShelfEntryCopyWith<LibraryItem, $Res>? get continueSeries;

}
/// @nodoc
class _$PersonalizedLibraryCopyWithImpl<$Res>
    implements $PersonalizedLibraryCopyWith<$Res> {
  _$PersonalizedLibraryCopyWithImpl(this._self, this._then);

  final PersonalizedLibrary _self;
  final $Res Function(PersonalizedLibrary) _then;

/// Create a copy of PersonalizedLibrary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? continueListening = freezed,Object? recentlyAdded = freezed,Object? recentSeries = freezed,Object? discover = freezed,Object? listenAgain = freezed,Object? newestAuthors = freezed,Object? newestEpisodes = freezed,Object? continueSeries = freezed,}) {
  return _then(_self.copyWith(
continueListening: freezed == continueListening ? _self.continueListening : continueListening // ignore: cast_nullable_to_non_nullable
as ShelfEntry<LibraryItem>?,recentlyAdded: freezed == recentlyAdded ? _self.recentlyAdded : recentlyAdded // ignore: cast_nullable_to_non_nullable
as ShelfEntry<LibraryItem>?,recentSeries: freezed == recentSeries ? _self.recentSeries : recentSeries // ignore: cast_nullable_to_non_nullable
as ShelfEntry<Series>?,discover: freezed == discover ? _self.discover : discover // ignore: cast_nullable_to_non_nullable
as ShelfEntry<LibraryItem>?,listenAgain: freezed == listenAgain ? _self.listenAgain : listenAgain // ignore: cast_nullable_to_non_nullable
as ShelfEntry<LibraryItem>?,newestAuthors: freezed == newestAuthors ? _self.newestAuthors : newestAuthors // ignore: cast_nullable_to_non_nullable
as ShelfEntry<Author>?,newestEpisodes: freezed == newestEpisodes ? _self.newestEpisodes : newestEpisodes // ignore: cast_nullable_to_non_nullable
as ShelfEntry<Episode>?,continueSeries: freezed == continueSeries ? _self.continueSeries : continueSeries // ignore: cast_nullable_to_non_nullable
as ShelfEntry<LibraryItem>?,
  ));
}
/// Create a copy of PersonalizedLibrary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShelfEntryCopyWith<LibraryItem, $Res>? get continueListening {
    if (_self.continueListening == null) {
    return null;
  }

  return $ShelfEntryCopyWith<LibraryItem, $Res>(_self.continueListening!, (value) {
    return _then(_self.copyWith(continueListening: value));
  });
}/// Create a copy of PersonalizedLibrary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShelfEntryCopyWith<LibraryItem, $Res>? get recentlyAdded {
    if (_self.recentlyAdded == null) {
    return null;
  }

  return $ShelfEntryCopyWith<LibraryItem, $Res>(_self.recentlyAdded!, (value) {
    return _then(_self.copyWith(recentlyAdded: value));
  });
}/// Create a copy of PersonalizedLibrary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShelfEntryCopyWith<Series, $Res>? get recentSeries {
    if (_self.recentSeries == null) {
    return null;
  }

  return $ShelfEntryCopyWith<Series, $Res>(_self.recentSeries!, (value) {
    return _then(_self.copyWith(recentSeries: value));
  });
}/// Create a copy of PersonalizedLibrary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShelfEntryCopyWith<LibraryItem, $Res>? get discover {
    if (_self.discover == null) {
    return null;
  }

  return $ShelfEntryCopyWith<LibraryItem, $Res>(_self.discover!, (value) {
    return _then(_self.copyWith(discover: value));
  });
}/// Create a copy of PersonalizedLibrary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShelfEntryCopyWith<LibraryItem, $Res>? get listenAgain {
    if (_self.listenAgain == null) {
    return null;
  }

  return $ShelfEntryCopyWith<LibraryItem, $Res>(_self.listenAgain!, (value) {
    return _then(_self.copyWith(listenAgain: value));
  });
}/// Create a copy of PersonalizedLibrary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShelfEntryCopyWith<Author, $Res>? get newestAuthors {
    if (_self.newestAuthors == null) {
    return null;
  }

  return $ShelfEntryCopyWith<Author, $Res>(_self.newestAuthors!, (value) {
    return _then(_self.copyWith(newestAuthors: value));
  });
}/// Create a copy of PersonalizedLibrary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShelfEntryCopyWith<Episode, $Res>? get newestEpisodes {
    if (_self.newestEpisodes == null) {
    return null;
  }

  return $ShelfEntryCopyWith<Episode, $Res>(_self.newestEpisodes!, (value) {
    return _then(_self.copyWith(newestEpisodes: value));
  });
}/// Create a copy of PersonalizedLibrary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShelfEntryCopyWith<LibraryItem, $Res>? get continueSeries {
    if (_self.continueSeries == null) {
    return null;
  }

  return $ShelfEntryCopyWith<LibraryItem, $Res>(_self.continueSeries!, (value) {
    return _then(_self.copyWith(continueSeries: value));
  });
}
}


/// @nodoc


class _PersonalizedLibrary extends PersonalizedLibrary {
  const _PersonalizedLibrary({this.continueListening, this.recentlyAdded, this.recentSeries, this.discover, this.listenAgain, this.newestAuthors, this.newestEpisodes, this.continueSeries}): super._();
  

@override final  ShelfEntry<LibraryItem>? continueListening;
@override final  ShelfEntry<LibraryItem>? recentlyAdded;
@override final  ShelfEntry<Series>? recentSeries;
@override final  ShelfEntry<LibraryItem>? discover;
@override final  ShelfEntry<LibraryItem>? listenAgain;
@override final  ShelfEntry<Author>? newestAuthors;
@override final  ShelfEntry<Episode>? newestEpisodes;
@override final  ShelfEntry<LibraryItem>? continueSeries;

/// Create a copy of PersonalizedLibrary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonalizedLibraryCopyWith<_PersonalizedLibrary> get copyWith => __$PersonalizedLibraryCopyWithImpl<_PersonalizedLibrary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonalizedLibrary&&(identical(other.continueListening, continueListening) || other.continueListening == continueListening)&&(identical(other.recentlyAdded, recentlyAdded) || other.recentlyAdded == recentlyAdded)&&(identical(other.recentSeries, recentSeries) || other.recentSeries == recentSeries)&&(identical(other.discover, discover) || other.discover == discover)&&(identical(other.listenAgain, listenAgain) || other.listenAgain == listenAgain)&&(identical(other.newestAuthors, newestAuthors) || other.newestAuthors == newestAuthors)&&(identical(other.newestEpisodes, newestEpisodes) || other.newestEpisodes == newestEpisodes)&&(identical(other.continueSeries, continueSeries) || other.continueSeries == continueSeries));
}


@override
int get hashCode => Object.hash(runtimeType,continueListening,recentlyAdded,recentSeries,discover,listenAgain,newestAuthors,newestEpisodes,continueSeries);

@override
String toString() {
  return 'PersonalizedLibrary(continueListening: $continueListening, recentlyAdded: $recentlyAdded, recentSeries: $recentSeries, discover: $discover, listenAgain: $listenAgain, newestAuthors: $newestAuthors, newestEpisodes: $newestEpisodes, continueSeries: $continueSeries)';
}


}

/// @nodoc
abstract mixin class _$PersonalizedLibraryCopyWith<$Res> implements $PersonalizedLibraryCopyWith<$Res> {
  factory _$PersonalizedLibraryCopyWith(_PersonalizedLibrary value, $Res Function(_PersonalizedLibrary) _then) = __$PersonalizedLibraryCopyWithImpl;
@override @useResult
$Res call({
 ShelfEntry<LibraryItem>? continueListening, ShelfEntry<LibraryItem>? recentlyAdded, ShelfEntry<Series>? recentSeries, ShelfEntry<LibraryItem>? discover, ShelfEntry<LibraryItem>? listenAgain, ShelfEntry<Author>? newestAuthors, ShelfEntry<Episode>? newestEpisodes, ShelfEntry<LibraryItem>? continueSeries
});


@override $ShelfEntryCopyWith<LibraryItem, $Res>? get continueListening;@override $ShelfEntryCopyWith<LibraryItem, $Res>? get recentlyAdded;@override $ShelfEntryCopyWith<Series, $Res>? get recentSeries;@override $ShelfEntryCopyWith<LibraryItem, $Res>? get discover;@override $ShelfEntryCopyWith<LibraryItem, $Res>? get listenAgain;@override $ShelfEntryCopyWith<Author, $Res>? get newestAuthors;@override $ShelfEntryCopyWith<Episode, $Res>? get newestEpisodes;@override $ShelfEntryCopyWith<LibraryItem, $Res>? get continueSeries;

}
/// @nodoc
class __$PersonalizedLibraryCopyWithImpl<$Res>
    implements _$PersonalizedLibraryCopyWith<$Res> {
  __$PersonalizedLibraryCopyWithImpl(this._self, this._then);

  final _PersonalizedLibrary _self;
  final $Res Function(_PersonalizedLibrary) _then;

/// Create a copy of PersonalizedLibrary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? continueListening = freezed,Object? recentlyAdded = freezed,Object? recentSeries = freezed,Object? discover = freezed,Object? listenAgain = freezed,Object? newestAuthors = freezed,Object? newestEpisodes = freezed,Object? continueSeries = freezed,}) {
  return _then(_PersonalizedLibrary(
continueListening: freezed == continueListening ? _self.continueListening : continueListening // ignore: cast_nullable_to_non_nullable
as ShelfEntry<LibraryItem>?,recentlyAdded: freezed == recentlyAdded ? _self.recentlyAdded : recentlyAdded // ignore: cast_nullable_to_non_nullable
as ShelfEntry<LibraryItem>?,recentSeries: freezed == recentSeries ? _self.recentSeries : recentSeries // ignore: cast_nullable_to_non_nullable
as ShelfEntry<Series>?,discover: freezed == discover ? _self.discover : discover // ignore: cast_nullable_to_non_nullable
as ShelfEntry<LibraryItem>?,listenAgain: freezed == listenAgain ? _self.listenAgain : listenAgain // ignore: cast_nullable_to_non_nullable
as ShelfEntry<LibraryItem>?,newestAuthors: freezed == newestAuthors ? _self.newestAuthors : newestAuthors // ignore: cast_nullable_to_non_nullable
as ShelfEntry<Author>?,newestEpisodes: freezed == newestEpisodes ? _self.newestEpisodes : newestEpisodes // ignore: cast_nullable_to_non_nullable
as ShelfEntry<Episode>?,continueSeries: freezed == continueSeries ? _self.continueSeries : continueSeries // ignore: cast_nullable_to_non_nullable
as ShelfEntry<LibraryItem>?,
  ));
}

/// Create a copy of PersonalizedLibrary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShelfEntryCopyWith<LibraryItem, $Res>? get continueListening {
    if (_self.continueListening == null) {
    return null;
  }

  return $ShelfEntryCopyWith<LibraryItem, $Res>(_self.continueListening!, (value) {
    return _then(_self.copyWith(continueListening: value));
  });
}/// Create a copy of PersonalizedLibrary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShelfEntryCopyWith<LibraryItem, $Res>? get recentlyAdded {
    if (_self.recentlyAdded == null) {
    return null;
  }

  return $ShelfEntryCopyWith<LibraryItem, $Res>(_self.recentlyAdded!, (value) {
    return _then(_self.copyWith(recentlyAdded: value));
  });
}/// Create a copy of PersonalizedLibrary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShelfEntryCopyWith<Series, $Res>? get recentSeries {
    if (_self.recentSeries == null) {
    return null;
  }

  return $ShelfEntryCopyWith<Series, $Res>(_self.recentSeries!, (value) {
    return _then(_self.copyWith(recentSeries: value));
  });
}/// Create a copy of PersonalizedLibrary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShelfEntryCopyWith<LibraryItem, $Res>? get discover {
    if (_self.discover == null) {
    return null;
  }

  return $ShelfEntryCopyWith<LibraryItem, $Res>(_self.discover!, (value) {
    return _then(_self.copyWith(discover: value));
  });
}/// Create a copy of PersonalizedLibrary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShelfEntryCopyWith<LibraryItem, $Res>? get listenAgain {
    if (_self.listenAgain == null) {
    return null;
  }

  return $ShelfEntryCopyWith<LibraryItem, $Res>(_self.listenAgain!, (value) {
    return _then(_self.copyWith(listenAgain: value));
  });
}/// Create a copy of PersonalizedLibrary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShelfEntryCopyWith<Author, $Res>? get newestAuthors {
    if (_self.newestAuthors == null) {
    return null;
  }

  return $ShelfEntryCopyWith<Author, $Res>(_self.newestAuthors!, (value) {
    return _then(_self.copyWith(newestAuthors: value));
  });
}/// Create a copy of PersonalizedLibrary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShelfEntryCopyWith<Episode, $Res>? get newestEpisodes {
    if (_self.newestEpisodes == null) {
    return null;
  }

  return $ShelfEntryCopyWith<Episode, $Res>(_self.newestEpisodes!, (value) {
    return _then(_self.copyWith(newestEpisodes: value));
  });
}/// Create a copy of PersonalizedLibrary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShelfEntryCopyWith<LibraryItem, $Res>? get continueSeries {
    if (_self.continueSeries == null) {
    return null;
  }

  return $ShelfEntryCopyWith<LibraryItem, $Res>(_self.continueSeries!, (value) {
    return _then(_self.copyWith(continueSeries: value));
  });
}
}


/// @nodoc
mixin _$ShelfEntry<T> {

@JsonKey(name: "id") String get id;@JsonKey(name: "label") String get label;@JsonKey(name: "labelStringKey") String get labelStringKey;@JsonKey(name: "type") ShelfType get type;@JsonKey(name: "total") int get total;@JsonKey(name: "entities") List<T> get entities;
/// Create a copy of ShelfEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShelfEntryCopyWith<T, ShelfEntry<T>> get copyWith => _$ShelfEntryCopyWithImpl<T, ShelfEntry<T>>(this as ShelfEntry<T>, _$identity);

  /// Serializes this ShelfEntry to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT);


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShelfEntry<T>&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.labelStringKey, labelStringKey) || other.labelStringKey == labelStringKey)&&(identical(other.type, type) || other.type == type)&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other.entities, entities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,labelStringKey,type,total,const DeepCollectionEquality().hash(entities));

@override
String toString() {
  return 'ShelfEntry<$T>(id: $id, label: $label, labelStringKey: $labelStringKey, type: $type, total: $total, entities: $entities)';
}


}

/// @nodoc
abstract mixin class $ShelfEntryCopyWith<T,$Res>  {
  factory $ShelfEntryCopyWith(ShelfEntry<T> value, $Res Function(ShelfEntry<T>) _then) = _$ShelfEntryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "label") String label,@JsonKey(name: "labelStringKey") String labelStringKey,@JsonKey(name: "type") ShelfType type,@JsonKey(name: "total") int total,@JsonKey(name: "entities") List<T> entities
});




}
/// @nodoc
class _$ShelfEntryCopyWithImpl<T,$Res>
    implements $ShelfEntryCopyWith<T, $Res> {
  _$ShelfEntryCopyWithImpl(this._self, this._then);

  final ShelfEntry<T> _self;
  final $Res Function(ShelfEntry<T>) _then;

/// Create a copy of ShelfEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? labelStringKey = null,Object? type = null,Object? total = null,Object? entities = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,labelStringKey: null == labelStringKey ? _self.labelStringKey : labelStringKey // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ShelfType,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,entities: null == entities ? _self.entities : entities // ignore: cast_nullable_to_non_nullable
as List<T>,
  ));
}

}


/// @nodoc
@JsonSerializable(genericArgumentFactories: true)

class _ShelfEntry<T> implements ShelfEntry<T> {
  const _ShelfEntry({@JsonKey(name: "id") required this.id, @JsonKey(name: "label") required this.label, @JsonKey(name: "labelStringKey") required this.labelStringKey, @JsonKey(name: "type") required this.type, @JsonKey(name: "total") required this.total, @JsonKey(name: "entities") required final  List<T> entities}): _entities = entities;
  factory _ShelfEntry.fromJson(Map<String, dynamic> json,T Function(Object?) fromJsonT) => _$ShelfEntryFromJson(json,fromJsonT);

@override@JsonKey(name: "id") final  String id;
@override@JsonKey(name: "label") final  String label;
@override@JsonKey(name: "labelStringKey") final  String labelStringKey;
@override@JsonKey(name: "type") final  ShelfType type;
@override@JsonKey(name: "total") final  int total;
 final  List<T> _entities;
@override@JsonKey(name: "entities") List<T> get entities {
  if (_entities is EqualUnmodifiableListView) return _entities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entities);
}


/// Create a copy of ShelfEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShelfEntryCopyWith<T, _ShelfEntry<T>> get copyWith => __$ShelfEntryCopyWithImpl<T, _ShelfEntry<T>>(this, _$identity);

@override
Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
  return _$ShelfEntryToJson<T>(this, toJsonT);
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShelfEntry<T>&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.labelStringKey, labelStringKey) || other.labelStringKey == labelStringKey)&&(identical(other.type, type) || other.type == type)&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other._entities, _entities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,labelStringKey,type,total,const DeepCollectionEquality().hash(_entities));

@override
String toString() {
  return 'ShelfEntry<$T>(id: $id, label: $label, labelStringKey: $labelStringKey, type: $type, total: $total, entities: $entities)';
}


}

/// @nodoc
abstract mixin class _$ShelfEntryCopyWith<T,$Res> implements $ShelfEntryCopyWith<T, $Res> {
  factory _$ShelfEntryCopyWith(_ShelfEntry<T> value, $Res Function(_ShelfEntry<T>) _then) = __$ShelfEntryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "label") String label,@JsonKey(name: "labelStringKey") String labelStringKey,@JsonKey(name: "type") ShelfType type,@JsonKey(name: "total") int total,@JsonKey(name: "entities") List<T> entities
});




}
/// @nodoc
class __$ShelfEntryCopyWithImpl<T,$Res>
    implements _$ShelfEntryCopyWith<T, $Res> {
  __$ShelfEntryCopyWithImpl(this._self, this._then);

  final _ShelfEntry<T> _self;
  final $Res Function(_ShelfEntry<T>) _then;

/// Create a copy of ShelfEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? labelStringKey = null,Object? type = null,Object? total = null,Object? entities = null,}) {
  return _then(_ShelfEntry<T>(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,labelStringKey: null == labelStringKey ? _self.labelStringKey : labelStringKey // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ShelfType,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,entities: null == entities ? _self._entities : entities // ignore: cast_nullable_to_non_nullable
as List<T>,
  ));
}


}

// dart format on
