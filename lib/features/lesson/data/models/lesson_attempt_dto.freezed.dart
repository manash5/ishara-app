// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_attempt_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LessonAttemptDto {

 String get clientEventId; String get lessonId; int get mistakes; int get durationSeconds; DateTime get completedAt;
/// Create a copy of LessonAttemptDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonAttemptDtoCopyWith<LessonAttemptDto> get copyWith => _$LessonAttemptDtoCopyWithImpl<LessonAttemptDto>(this as LessonAttemptDto, _$identity);

  /// Serializes this LessonAttemptDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LessonAttemptDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonAttemptDto&&(identical(other.clientEventId, _this.clientEventId) || other.clientEventId == _this.clientEventId)&&(identical(other.lessonId, _this.lessonId) || other.lessonId == _this.lessonId)&&(identical(other.mistakes, _this.mistakes) || other.mistakes == _this.mistakes)&&(identical(other.durationSeconds, _this.durationSeconds) || other.durationSeconds == _this.durationSeconds)&&(identical(other.completedAt, _this.completedAt) || other.completedAt == _this.completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LessonAttemptDto;
  return Object.hash(runtimeType,_this.clientEventId,_this.lessonId,_this.mistakes,_this.durationSeconds,_this.completedAt);
}

@override
String toString() {
  final _this = this as LessonAttemptDto;
  return 'LessonAttemptDto(clientEventId: ${_this.clientEventId}, lessonId: ${_this.lessonId}, mistakes: ${_this.mistakes}, durationSeconds: ${_this.durationSeconds}, completedAt: ${_this.completedAt})';
}


}

/// @nodoc
abstract mixin class $LessonAttemptDtoCopyWith<$Res>  {
  factory $LessonAttemptDtoCopyWith(LessonAttemptDto value, $Res Function(LessonAttemptDto) _then) = _$LessonAttemptDtoCopyWithImpl;
@useResult
$Res call({
 String clientEventId, String lessonId, int mistakes, int durationSeconds, DateTime completedAt
});




}
/// @nodoc
class _$LessonAttemptDtoCopyWithImpl<$Res>
    implements $LessonAttemptDtoCopyWith<$Res> {
  _$LessonAttemptDtoCopyWithImpl(this._self, this._then);

  final LessonAttemptDto _self;
  final $Res Function(LessonAttemptDto) _then;

/// Create a copy of LessonAttemptDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? clientEventId = null,Object? lessonId = null,Object? mistakes = null,Object? durationSeconds = null,Object? completedAt = null,}) {
  return _then(LessonAttemptDto(
clientEventId: null == clientEventId ? _self.clientEventId : clientEventId // ignore: cast_nullable_to_non_nullable
as String,lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String,mistakes: null == mistakes ? _self.mistakes : mistakes // ignore: cast_nullable_to_non_nullable
as int,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,completedAt: null == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [LessonAttemptDto].
extension LessonAttemptDtoPatterns on LessonAttemptDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonAttemptDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonAttemptDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonAttemptDto value)  $default,){
final _that = this;
switch (_that) {
case _LessonAttemptDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonAttemptDto value)?  $default,){
final _that = this;
switch (_that) {
case _LessonAttemptDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String clientEventId,  String lessonId,  int mistakes,  int durationSeconds,  DateTime completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonAttemptDto() when $default != null:
return $default(_that.clientEventId,_that.lessonId,_that.mistakes,_that.durationSeconds,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String clientEventId,  String lessonId,  int mistakes,  int durationSeconds,  DateTime completedAt)  $default,) {final _that = this;
switch (_that) {
case _LessonAttemptDto():
return $default(_that.clientEventId,_that.lessonId,_that.mistakes,_that.durationSeconds,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String clientEventId,  String lessonId,  int mistakes,  int durationSeconds,  DateTime completedAt)?  $default,) {final _that = this;
switch (_that) {
case _LessonAttemptDto() when $default != null:
return $default(_that.clientEventId,_that.lessonId,_that.mistakes,_that.durationSeconds,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LessonAttemptDto extends LessonAttemptDto {
  const _LessonAttemptDto({required this.clientEventId, required this.lessonId, required this.mistakes, required this.durationSeconds, required this.completedAt}): super._();
  factory _LessonAttemptDto.fromJson(Map<String, dynamic> json) => _$LessonAttemptDtoFromJson(json);

@override final  String clientEventId;
@override final  String lessonId;
@override final  int mistakes;
@override final  int durationSeconds;
@override final  DateTime completedAt;

/// Create a copy of LessonAttemptDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonAttemptDtoCopyWith<_LessonAttemptDto> get copyWith => __$LessonAttemptDtoCopyWithImpl<_LessonAttemptDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonAttemptDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonAttemptDto&&(identical(other.clientEventId, clientEventId) || other.clientEventId == clientEventId)&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.mistakes, mistakes) || other.mistakes == mistakes)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,clientEventId,lessonId,mistakes,durationSeconds,completedAt);
}

@override
String toString() {
    return 'LessonAttemptDto(clientEventId: $clientEventId, lessonId: $lessonId, mistakes: $mistakes, durationSeconds: $durationSeconds, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$LessonAttemptDtoCopyWith<$Res> implements $LessonAttemptDtoCopyWith<$Res> {
  factory _$LessonAttemptDtoCopyWith(_LessonAttemptDto value, $Res Function(_LessonAttemptDto) _then) = __$LessonAttemptDtoCopyWithImpl;
@override @useResult
$Res call({
 String clientEventId, String lessonId, int mistakes, int durationSeconds, DateTime completedAt
});




}
/// @nodoc
class __$LessonAttemptDtoCopyWithImpl<$Res>
    implements _$LessonAttemptDtoCopyWith<$Res> {
  __$LessonAttemptDtoCopyWithImpl(this._self, this._then);

  final _LessonAttemptDto _self;
  final $Res Function(_LessonAttemptDto) _then;

/// Create a copy of LessonAttemptDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? clientEventId = null,Object? lessonId = null,Object? mistakes = null,Object? durationSeconds = null,Object? completedAt = null,}) {
  return _then(_LessonAttemptDto(
clientEventId: null == clientEventId ? _self.clientEventId : clientEventId // ignore: cast_nullable_to_non_nullable
as String,lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String,mistakes: null == mistakes ? _self.mistakes : mistakes // ignore: cast_nullable_to_non_nullable
as int,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,completedAt: null == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
