// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_result_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LessonResultDto {

 String get lessonId; String get clientEventId; int get xpEarned; double get accuracy; int get durationSeconds; int get newSignCount; List<SignDto> get signs; bool get streakExtended; int get streakDays; int get hearts; DateTime get completedAt;
/// Create a copy of LessonResultDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonResultDtoCopyWith<LessonResultDto> get copyWith => _$LessonResultDtoCopyWithImpl<LessonResultDto>(this as LessonResultDto, _$identity);

  /// Serializes this LessonResultDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LessonResultDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonResultDto&&(identical(other.lessonId, _this.lessonId) || other.lessonId == _this.lessonId)&&(identical(other.clientEventId, _this.clientEventId) || other.clientEventId == _this.clientEventId)&&(identical(other.xpEarned, _this.xpEarned) || other.xpEarned == _this.xpEarned)&&(identical(other.accuracy, _this.accuracy) || other.accuracy == _this.accuracy)&&(identical(other.durationSeconds, _this.durationSeconds) || other.durationSeconds == _this.durationSeconds)&&(identical(other.newSignCount, _this.newSignCount) || other.newSignCount == _this.newSignCount)&&const DeepCollectionEquality().equals(other.signs, _this.signs)&&(identical(other.streakExtended, _this.streakExtended) || other.streakExtended == _this.streakExtended)&&(identical(other.streakDays, _this.streakDays) || other.streakDays == _this.streakDays)&&(identical(other.hearts, _this.hearts) || other.hearts == _this.hearts)&&(identical(other.completedAt, _this.completedAt) || other.completedAt == _this.completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LessonResultDto;
  return Object.hash(runtimeType,_this.lessonId,_this.clientEventId,_this.xpEarned,_this.accuracy,_this.durationSeconds,_this.newSignCount,const DeepCollectionEquality().hash(_this.signs),_this.streakExtended,_this.streakDays,_this.hearts,_this.completedAt);
}

@override
String toString() {
  final _this = this as LessonResultDto;
  return 'LessonResultDto(lessonId: ${_this.lessonId}, clientEventId: ${_this.clientEventId}, xpEarned: ${_this.xpEarned}, accuracy: ${_this.accuracy}, durationSeconds: ${_this.durationSeconds}, newSignCount: ${_this.newSignCount}, signs: ${_this.signs}, streakExtended: ${_this.streakExtended}, streakDays: ${_this.streakDays}, hearts: ${_this.hearts}, completedAt: ${_this.completedAt})';
}


}

/// @nodoc
abstract mixin class $LessonResultDtoCopyWith<$Res>  {
  factory $LessonResultDtoCopyWith(LessonResultDto value, $Res Function(LessonResultDto) _then) = _$LessonResultDtoCopyWithImpl;
@useResult
$Res call({
 String lessonId, String clientEventId, int xpEarned, double accuracy, int durationSeconds, int newSignCount, List<SignDto> signs, bool streakExtended, int streakDays, int hearts, DateTime completedAt
});




}
/// @nodoc
class _$LessonResultDtoCopyWithImpl<$Res>
    implements $LessonResultDtoCopyWith<$Res> {
  _$LessonResultDtoCopyWithImpl(this._self, this._then);

  final LessonResultDto _self;
  final $Res Function(LessonResultDto) _then;

/// Create a copy of LessonResultDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lessonId = null,Object? clientEventId = null,Object? xpEarned = null,Object? accuracy = null,Object? durationSeconds = null,Object? newSignCount = null,Object? signs = null,Object? streakExtended = null,Object? streakDays = null,Object? hearts = null,Object? completedAt = null,}) {
  return _then(LessonResultDto(
lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String,clientEventId: null == clientEventId ? _self.clientEventId : clientEventId // ignore: cast_nullable_to_non_nullable
as String,xpEarned: null == xpEarned ? _self.xpEarned : xpEarned // ignore: cast_nullable_to_non_nullable
as int,accuracy: null == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,newSignCount: null == newSignCount ? _self.newSignCount : newSignCount // ignore: cast_nullable_to_non_nullable
as int,signs: null == signs ? _self.signs : signs // ignore: cast_nullable_to_non_nullable
as List<SignDto>,streakExtended: null == streakExtended ? _self.streakExtended : streakExtended // ignore: cast_nullable_to_non_nullable
as bool,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,hearts: null == hearts ? _self.hearts : hearts // ignore: cast_nullable_to_non_nullable
as int,completedAt: null == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [LessonResultDto].
extension LessonResultDtoPatterns on LessonResultDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonResultDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonResultDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonResultDto value)  $default,){
final _that = this;
switch (_that) {
case _LessonResultDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonResultDto value)?  $default,){
final _that = this;
switch (_that) {
case _LessonResultDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String lessonId,  String clientEventId,  int xpEarned,  double accuracy,  int durationSeconds,  int newSignCount,  List<SignDto> signs,  bool streakExtended,  int streakDays,  int hearts,  DateTime completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonResultDto() when $default != null:
return $default(_that.lessonId,_that.clientEventId,_that.xpEarned,_that.accuracy,_that.durationSeconds,_that.newSignCount,_that.signs,_that.streakExtended,_that.streakDays,_that.hearts,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String lessonId,  String clientEventId,  int xpEarned,  double accuracy,  int durationSeconds,  int newSignCount,  List<SignDto> signs,  bool streakExtended,  int streakDays,  int hearts,  DateTime completedAt)  $default,) {final _that = this;
switch (_that) {
case _LessonResultDto():
return $default(_that.lessonId,_that.clientEventId,_that.xpEarned,_that.accuracy,_that.durationSeconds,_that.newSignCount,_that.signs,_that.streakExtended,_that.streakDays,_that.hearts,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String lessonId,  String clientEventId,  int xpEarned,  double accuracy,  int durationSeconds,  int newSignCount,  List<SignDto> signs,  bool streakExtended,  int streakDays,  int hearts,  DateTime completedAt)?  $default,) {final _that = this;
switch (_that) {
case _LessonResultDto() when $default != null:
return $default(_that.lessonId,_that.clientEventId,_that.xpEarned,_that.accuracy,_that.durationSeconds,_that.newSignCount,_that.signs,_that.streakExtended,_that.streakDays,_that.hearts,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LessonResultDto extends LessonResultDto {
  const _LessonResultDto({required this.lessonId, required this.clientEventId, required this.xpEarned, required this.accuracy, required this.durationSeconds, required this.newSignCount, required  List<SignDto> signs, required this.streakExtended, required this.streakDays, required this.hearts, required this.completedAt}): _signs = signs,super._();
  factory _LessonResultDto.fromJson(Map<String, dynamic> json) => _$LessonResultDtoFromJson(json);

@override final  String lessonId;
@override final  String clientEventId;
@override final  int xpEarned;
@override final  double accuracy;
@override final  int durationSeconds;
@override final  int newSignCount;
 final  List<SignDto> _signs;
@override List<SignDto> get signs {
  if (_signs is EqualUnmodifiableListView) return _signs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_signs);
}

@override final  bool streakExtended;
@override final  int streakDays;
@override final  int hearts;
@override final  DateTime completedAt;

/// Create a copy of LessonResultDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonResultDtoCopyWith<_LessonResultDto> get copyWith => __$LessonResultDtoCopyWithImpl<_LessonResultDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonResultDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonResultDto&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.clientEventId, clientEventId) || other.clientEventId == clientEventId)&&(identical(other.xpEarned, xpEarned) || other.xpEarned == xpEarned)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.newSignCount, newSignCount) || other.newSignCount == newSignCount)&&const DeepCollectionEquality().equals(other.signs, _signs)&&(identical(other.streakExtended, streakExtended) || other.streakExtended == streakExtended)&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&(identical(other.hearts, hearts) || other.hearts == hearts)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,lessonId,clientEventId,xpEarned,accuracy,durationSeconds,newSignCount,const DeepCollectionEquality().hash(_signs),streakExtended,streakDays,hearts,completedAt);
}

@override
String toString() {
    return 'LessonResultDto(lessonId: $lessonId, clientEventId: $clientEventId, xpEarned: $xpEarned, accuracy: $accuracy, durationSeconds: $durationSeconds, newSignCount: $newSignCount, signs: $signs, streakExtended: $streakExtended, streakDays: $streakDays, hearts: $hearts, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$LessonResultDtoCopyWith<$Res> implements $LessonResultDtoCopyWith<$Res> {
  factory _$LessonResultDtoCopyWith(_LessonResultDto value, $Res Function(_LessonResultDto) _then) = __$LessonResultDtoCopyWithImpl;
@override @useResult
$Res call({
 String lessonId, String clientEventId, int xpEarned, double accuracy, int durationSeconds, int newSignCount, List<SignDto> signs, bool streakExtended, int streakDays, int hearts, DateTime completedAt
});




}
/// @nodoc
class __$LessonResultDtoCopyWithImpl<$Res>
    implements _$LessonResultDtoCopyWith<$Res> {
  __$LessonResultDtoCopyWithImpl(this._self, this._then);

  final _LessonResultDto _self;
  final $Res Function(_LessonResultDto) _then;

/// Create a copy of LessonResultDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lessonId = null,Object? clientEventId = null,Object? xpEarned = null,Object? accuracy = null,Object? durationSeconds = null,Object? newSignCount = null,Object? signs = null,Object? streakExtended = null,Object? streakDays = null,Object? hearts = null,Object? completedAt = null,}) {
  return _then(_LessonResultDto(
lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String,clientEventId: null == clientEventId ? _self.clientEventId : clientEventId // ignore: cast_nullable_to_non_nullable
as String,xpEarned: null == xpEarned ? _self.xpEarned : xpEarned // ignore: cast_nullable_to_non_nullable
as int,accuracy: null == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,newSignCount: null == newSignCount ? _self.newSignCount : newSignCount // ignore: cast_nullable_to_non_nullable
as int,signs: null == signs ? _self._signs : signs // ignore: cast_nullable_to_non_nullable
as List<SignDto>,streakExtended: null == streakExtended ? _self.streakExtended : streakExtended // ignore: cast_nullable_to_non_nullable
as bool,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,hearts: null == hearts ? _self.hearts : hearts // ignore: cast_nullable_to_non_nullable
as int,completedAt: null == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
