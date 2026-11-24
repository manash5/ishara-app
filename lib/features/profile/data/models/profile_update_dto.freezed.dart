// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_update_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfileUpdateDto {

 String? get displayName; int? get dailyGoalMinutes; String? get dominantHand; String? get timezone;
/// Create a copy of ProfileUpdateDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileUpdateDtoCopyWith<ProfileUpdateDto> get copyWith => _$ProfileUpdateDtoCopyWithImpl<ProfileUpdateDto>(this as ProfileUpdateDto, _$identity);

  /// Serializes this ProfileUpdateDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProfileUpdateDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileUpdateDto&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.dailyGoalMinutes, _this.dailyGoalMinutes) || other.dailyGoalMinutes == _this.dailyGoalMinutes)&&(identical(other.dominantHand, _this.dominantHand) || other.dominantHand == _this.dominantHand)&&(identical(other.timezone, _this.timezone) || other.timezone == _this.timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProfileUpdateDto;
  return Object.hash(runtimeType,_this.displayName,_this.dailyGoalMinutes,_this.dominantHand,_this.timezone);
}

@override
String toString() {
  final _this = this as ProfileUpdateDto;
  return 'ProfileUpdateDto(displayName: ${_this.displayName}, dailyGoalMinutes: ${_this.dailyGoalMinutes}, dominantHand: ${_this.dominantHand}, timezone: ${_this.timezone})';
}


}

/// @nodoc
abstract mixin class $ProfileUpdateDtoCopyWith<$Res>  {
  factory $ProfileUpdateDtoCopyWith(ProfileUpdateDto value, $Res Function(ProfileUpdateDto) _then) = _$ProfileUpdateDtoCopyWithImpl;
@useResult
$Res call({
 String? displayName, int? dailyGoalMinutes, String? dominantHand, String? timezone
});




}
/// @nodoc
class _$ProfileUpdateDtoCopyWithImpl<$Res>
    implements $ProfileUpdateDtoCopyWith<$Res> {
  _$ProfileUpdateDtoCopyWithImpl(this._self, this._then);

  final ProfileUpdateDto _self;
  final $Res Function(ProfileUpdateDto) _then;

/// Create a copy of ProfileUpdateDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? displayName = freezed,Object? dailyGoalMinutes = freezed,Object? dominantHand = freezed,Object? timezone = freezed,}) {
  return _then(ProfileUpdateDto(
displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,dailyGoalMinutes: freezed == dailyGoalMinutes ? _self.dailyGoalMinutes : dailyGoalMinutes // ignore: cast_nullable_to_non_nullable
as int?,dominantHand: freezed == dominantHand ? _self.dominantHand : dominantHand // ignore: cast_nullable_to_non_nullable
as String?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileUpdateDto].
extension ProfileUpdateDtoPatterns on ProfileUpdateDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileUpdateDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileUpdateDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileUpdateDto value)  $default,){
final _that = this;
switch (_that) {
case _ProfileUpdateDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileUpdateDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileUpdateDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? displayName,  int? dailyGoalMinutes,  String? dominantHand,  String? timezone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileUpdateDto() when $default != null:
return $default(_that.displayName,_that.dailyGoalMinutes,_that.dominantHand,_that.timezone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? displayName,  int? dailyGoalMinutes,  String? dominantHand,  String? timezone)  $default,) {final _that = this;
switch (_that) {
case _ProfileUpdateDto():
return $default(_that.displayName,_that.dailyGoalMinutes,_that.dominantHand,_that.timezone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? displayName,  int? dailyGoalMinutes,  String? dominantHand,  String? timezone)?  $default,) {final _that = this;
switch (_that) {
case _ProfileUpdateDto() when $default != null:
return $default(_that.displayName,_that.dailyGoalMinutes,_that.dominantHand,_that.timezone);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(includeIfNull: false)
class _ProfileUpdateDto implements ProfileUpdateDto {
  const _ProfileUpdateDto({this.displayName, this.dailyGoalMinutes, this.dominantHand, this.timezone});
  factory _ProfileUpdateDto.fromJson(Map<String, dynamic> json) => _$ProfileUpdateDtoFromJson(json);

@override final  String? displayName;
@override final  int? dailyGoalMinutes;
@override final  String? dominantHand;
@override final  String? timezone;

/// Create a copy of ProfileUpdateDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileUpdateDtoCopyWith<_ProfileUpdateDto> get copyWith => __$ProfileUpdateDtoCopyWithImpl<_ProfileUpdateDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileUpdateDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileUpdateDto&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.dailyGoalMinutes, dailyGoalMinutes) || other.dailyGoalMinutes == dailyGoalMinutes)&&(identical(other.dominantHand, dominantHand) || other.dominantHand == dominantHand)&&(identical(other.timezone, timezone) || other.timezone == timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,displayName,dailyGoalMinutes,dominantHand,timezone);
}

@override
String toString() {
    return 'ProfileUpdateDto(displayName: $displayName, dailyGoalMinutes: $dailyGoalMinutes, dominantHand: $dominantHand, timezone: $timezone)';
}


}

/// @nodoc
abstract mixin class _$ProfileUpdateDtoCopyWith<$Res> implements $ProfileUpdateDtoCopyWith<$Res> {
  factory _$ProfileUpdateDtoCopyWith(_ProfileUpdateDto value, $Res Function(_ProfileUpdateDto) _then) = __$ProfileUpdateDtoCopyWithImpl;
@override @useResult
$Res call({
 String? displayName, int? dailyGoalMinutes, String? dominantHand, String? timezone
});




}
/// @nodoc
class __$ProfileUpdateDtoCopyWithImpl<$Res>
    implements _$ProfileUpdateDtoCopyWith<$Res> {
  __$ProfileUpdateDtoCopyWithImpl(this._self, this._then);

  final _ProfileUpdateDto _self;
  final $Res Function(_ProfileUpdateDto) _then;

/// Create a copy of ProfileUpdateDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? displayName = freezed,Object? dailyGoalMinutes = freezed,Object? dominantHand = freezed,Object? timezone = freezed,}) {
  return _then(_ProfileUpdateDto(
displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,dailyGoalMinutes: freezed == dailyGoalMinutes ? _self.dailyGoalMinutes : dailyGoalMinutes // ignore: cast_nullable_to_non_nullable
as int?,dominantHand: freezed == dominantHand ? _self.dominantHand : dominantHand // ignore: cast_nullable_to_non_nullable
as String?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
