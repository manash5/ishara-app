// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OnboardingRequestDto {

 int get dailyGoalMinutes; String get dominantHand; String get timezone;
/// Create a copy of OnboardingRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingRequestDtoCopyWith<OnboardingRequestDto> get copyWith => _$OnboardingRequestDtoCopyWithImpl<OnboardingRequestDto>(this as OnboardingRequestDto, _$identity);

  /// Serializes this OnboardingRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OnboardingRequestDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingRequestDto&&(identical(other.dailyGoalMinutes, _this.dailyGoalMinutes) || other.dailyGoalMinutes == _this.dailyGoalMinutes)&&(identical(other.dominantHand, _this.dominantHand) || other.dominantHand == _this.dominantHand)&&(identical(other.timezone, _this.timezone) || other.timezone == _this.timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OnboardingRequestDto;
  return Object.hash(runtimeType,_this.dailyGoalMinutes,_this.dominantHand,_this.timezone);
}

@override
String toString() {
  final _this = this as OnboardingRequestDto;
  return 'OnboardingRequestDto(dailyGoalMinutes: ${_this.dailyGoalMinutes}, dominantHand: ${_this.dominantHand}, timezone: ${_this.timezone})';
}


}

/// @nodoc
abstract mixin class $OnboardingRequestDtoCopyWith<$Res>  {
  factory $OnboardingRequestDtoCopyWith(OnboardingRequestDto value, $Res Function(OnboardingRequestDto) _then) = _$OnboardingRequestDtoCopyWithImpl;
@useResult
$Res call({
 int dailyGoalMinutes, String dominantHand, String timezone
});




}
/// @nodoc
class _$OnboardingRequestDtoCopyWithImpl<$Res>
    implements $OnboardingRequestDtoCopyWith<$Res> {
  _$OnboardingRequestDtoCopyWithImpl(this._self, this._then);

  final OnboardingRequestDto _self;
  final $Res Function(OnboardingRequestDto) _then;

/// Create a copy of OnboardingRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dailyGoalMinutes = null,Object? dominantHand = null,Object? timezone = null,}) {
  return _then(OnboardingRequestDto(
dailyGoalMinutes: null == dailyGoalMinutes ? _self.dailyGoalMinutes : dailyGoalMinutes // ignore: cast_nullable_to_non_nullable
as int,dominantHand: null == dominantHand ? _self.dominantHand : dominantHand // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingRequestDto].
extension OnboardingRequestDtoPatterns on OnboardingRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int dailyGoalMinutes,  String dominantHand,  String timezone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingRequestDto() when $default != null:
return $default(_that.dailyGoalMinutes,_that.dominantHand,_that.timezone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int dailyGoalMinutes,  String dominantHand,  String timezone)  $default,) {final _that = this;
switch (_that) {
case _OnboardingRequestDto():
return $default(_that.dailyGoalMinutes,_that.dominantHand,_that.timezone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int dailyGoalMinutes,  String dominantHand,  String timezone)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingRequestDto() when $default != null:
return $default(_that.dailyGoalMinutes,_that.dominantHand,_that.timezone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OnboardingRequestDto implements OnboardingRequestDto {
  const _OnboardingRequestDto({required this.dailyGoalMinutes, required this.dominantHand, required this.timezone});
  factory _OnboardingRequestDto.fromJson(Map<String, dynamic> json) => _$OnboardingRequestDtoFromJson(json);

@override final  int dailyGoalMinutes;
@override final  String dominantHand;
@override final  String timezone;

/// Create a copy of OnboardingRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingRequestDtoCopyWith<_OnboardingRequestDto> get copyWith => __$OnboardingRequestDtoCopyWithImpl<_OnboardingRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OnboardingRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingRequestDto&&(identical(other.dailyGoalMinutes, dailyGoalMinutes) || other.dailyGoalMinutes == dailyGoalMinutes)&&(identical(other.dominantHand, dominantHand) || other.dominantHand == dominantHand)&&(identical(other.timezone, timezone) || other.timezone == timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,dailyGoalMinutes,dominantHand,timezone);
}

@override
String toString() {
    return 'OnboardingRequestDto(dailyGoalMinutes: $dailyGoalMinutes, dominantHand: $dominantHand, timezone: $timezone)';
}


}

/// @nodoc
abstract mixin class _$OnboardingRequestDtoCopyWith<$Res> implements $OnboardingRequestDtoCopyWith<$Res> {
  factory _$OnboardingRequestDtoCopyWith(_OnboardingRequestDto value, $Res Function(_OnboardingRequestDto) _then) = __$OnboardingRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 int dailyGoalMinutes, String dominantHand, String timezone
});




}
/// @nodoc
class __$OnboardingRequestDtoCopyWithImpl<$Res>
    implements _$OnboardingRequestDtoCopyWith<$Res> {
  __$OnboardingRequestDtoCopyWithImpl(this._self, this._then);

  final _OnboardingRequestDto _self;
  final $Res Function(_OnboardingRequestDto) _then;

/// Create a copy of OnboardingRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dailyGoalMinutes = null,Object? dominantHand = null,Object? timezone = null,}) {
  return _then(_OnboardingRequestDto(
dailyGoalMinutes: null == dailyGoalMinutes ? _self.dailyGoalMinutes : dailyGoalMinutes // ignore: cast_nullable_to_non_nullable
as int,dominantHand: null == dominantHand ? _self.dominantHand : dominantHand // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
