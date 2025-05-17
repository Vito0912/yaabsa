// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'days_of_week.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DaysOfWeek {

@JsonKey(name: "Monday") double? get monday;@JsonKey(name: "Tuesday") double? get tuesday;@JsonKey(name: "Wednesday") double? get wednesday;@JsonKey(name: "Thursday") double? get thursday;@JsonKey(name: "Friday") double? get friday;@JsonKey(name: "Saturday") double? get saturday;@JsonKey(name: "Sunday") double? get sunday;
/// Create a copy of DaysOfWeek
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DaysOfWeekCopyWith<DaysOfWeek> get copyWith => _$DaysOfWeekCopyWithImpl<DaysOfWeek>(this as DaysOfWeek, _$identity);

  /// Serializes this DaysOfWeek to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DaysOfWeek&&(identical(other.monday, monday) || other.monday == monday)&&(identical(other.tuesday, tuesday) || other.tuesday == tuesday)&&(identical(other.wednesday, wednesday) || other.wednesday == wednesday)&&(identical(other.thursday, thursday) || other.thursday == thursday)&&(identical(other.friday, friday) || other.friday == friday)&&(identical(other.saturday, saturday) || other.saturday == saturday)&&(identical(other.sunday, sunday) || other.sunday == sunday));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,monday,tuesday,wednesday,thursday,friday,saturday,sunday);

@override
String toString() {
  return 'DaysOfWeek(monday: $monday, tuesday: $tuesday, wednesday: $wednesday, thursday: $thursday, friday: $friday, saturday: $saturday, sunday: $sunday)';
}


}

/// @nodoc
abstract mixin class $DaysOfWeekCopyWith<$Res>  {
  factory $DaysOfWeekCopyWith(DaysOfWeek value, $Res Function(DaysOfWeek) _then) = _$DaysOfWeekCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "Monday") double? monday,@JsonKey(name: "Tuesday") double? tuesday,@JsonKey(name: "Wednesday") double? wednesday,@JsonKey(name: "Thursday") double? thursday,@JsonKey(name: "Friday") double? friday,@JsonKey(name: "Saturday") double? saturday,@JsonKey(name: "Sunday") double? sunday
});




}
/// @nodoc
class _$DaysOfWeekCopyWithImpl<$Res>
    implements $DaysOfWeekCopyWith<$Res> {
  _$DaysOfWeekCopyWithImpl(this._self, this._then);

  final DaysOfWeek _self;
  final $Res Function(DaysOfWeek) _then;

/// Create a copy of DaysOfWeek
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? monday = freezed,Object? tuesday = freezed,Object? wednesday = freezed,Object? thursday = freezed,Object? friday = freezed,Object? saturday = freezed,Object? sunday = freezed,}) {
  return _then(_self.copyWith(
monday: freezed == monday ? _self.monday : monday // ignore: cast_nullable_to_non_nullable
as double?,tuesday: freezed == tuesday ? _self.tuesday : tuesday // ignore: cast_nullable_to_non_nullable
as double?,wednesday: freezed == wednesday ? _self.wednesday : wednesday // ignore: cast_nullable_to_non_nullable
as double?,thursday: freezed == thursday ? _self.thursday : thursday // ignore: cast_nullable_to_non_nullable
as double?,friday: freezed == friday ? _self.friday : friday // ignore: cast_nullable_to_non_nullable
as double?,saturday: freezed == saturday ? _self.saturday : saturday // ignore: cast_nullable_to_non_nullable
as double?,sunday: freezed == sunday ? _self.sunday : sunday // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _DaysOfWeek implements DaysOfWeek {
  const _DaysOfWeek({@JsonKey(name: "Monday") this.monday, @JsonKey(name: "Tuesday") this.tuesday, @JsonKey(name: "Wednesday") this.wednesday, @JsonKey(name: "Thursday") this.thursday, @JsonKey(name: "Friday") this.friday, @JsonKey(name: "Saturday") this.saturday, @JsonKey(name: "Sunday") this.sunday});
  factory _DaysOfWeek.fromJson(Map<String, dynamic> json) => _$DaysOfWeekFromJson(json);

@override@JsonKey(name: "Monday") final  double? monday;
@override@JsonKey(name: "Tuesday") final  double? tuesday;
@override@JsonKey(name: "Wednesday") final  double? wednesday;
@override@JsonKey(name: "Thursday") final  double? thursday;
@override@JsonKey(name: "Friday") final  double? friday;
@override@JsonKey(name: "Saturday") final  double? saturday;
@override@JsonKey(name: "Sunday") final  double? sunday;

/// Create a copy of DaysOfWeek
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DaysOfWeekCopyWith<_DaysOfWeek> get copyWith => __$DaysOfWeekCopyWithImpl<_DaysOfWeek>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DaysOfWeekToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DaysOfWeek&&(identical(other.monday, monday) || other.monday == monday)&&(identical(other.tuesday, tuesday) || other.tuesday == tuesday)&&(identical(other.wednesday, wednesday) || other.wednesday == wednesday)&&(identical(other.thursday, thursday) || other.thursday == thursday)&&(identical(other.friday, friday) || other.friday == friday)&&(identical(other.saturday, saturday) || other.saturday == saturday)&&(identical(other.sunday, sunday) || other.sunday == sunday));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,monday,tuesday,wednesday,thursday,friday,saturday,sunday);

@override
String toString() {
  return 'DaysOfWeek(monday: $monday, tuesday: $tuesday, wednesday: $wednesday, thursday: $thursday, friday: $friday, saturday: $saturday, sunday: $sunday)';
}


}

/// @nodoc
abstract mixin class _$DaysOfWeekCopyWith<$Res> implements $DaysOfWeekCopyWith<$Res> {
  factory _$DaysOfWeekCopyWith(_DaysOfWeek value, $Res Function(_DaysOfWeek) _then) = __$DaysOfWeekCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "Monday") double? monday,@JsonKey(name: "Tuesday") double? tuesday,@JsonKey(name: "Wednesday") double? wednesday,@JsonKey(name: "Thursday") double? thursday,@JsonKey(name: "Friday") double? friday,@JsonKey(name: "Saturday") double? saturday,@JsonKey(name: "Sunday") double? sunday
});




}
/// @nodoc
class __$DaysOfWeekCopyWithImpl<$Res>
    implements _$DaysOfWeekCopyWith<$Res> {
  __$DaysOfWeekCopyWithImpl(this._self, this._then);

  final _DaysOfWeek _self;
  final $Res Function(_DaysOfWeek) _then;

/// Create a copy of DaysOfWeek
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? monday = freezed,Object? tuesday = freezed,Object? wednesday = freezed,Object? thursday = freezed,Object? friday = freezed,Object? saturday = freezed,Object? sunday = freezed,}) {
  return _then(_DaysOfWeek(
monday: freezed == monday ? _self.monday : monday // ignore: cast_nullable_to_non_nullable
as double?,tuesday: freezed == tuesday ? _self.tuesday : tuesday // ignore: cast_nullable_to_non_nullable
as double?,wednesday: freezed == wednesday ? _self.wednesday : wednesday // ignore: cast_nullable_to_non_nullable
as double?,thursday: freezed == thursday ? _self.thursday : thursday // ignore: cast_nullable_to_non_nullable
as double?,friday: freezed == friday ? _self.friday : friday // ignore: cast_nullable_to_non_nullable
as double?,saturday: freezed == saturday ? _self.saturday : saturday // ignore: cast_nullable_to_non_nullable
as double?,sunday: freezed == sunday ? _self.sunday : sunday // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
