// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LessonAttempt {

 String get clientEventId; String get lessonId;/// Wrong answers (camera "almost" doesn't count).
 int get mistakes; Duration get duration; DateTime get completedAt;
/// Create a copy of LessonAttempt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonAttemptCopyWith<LessonAttempt> get copyWith => _$LessonAttemptCopyWithImpl<LessonAttempt>(this as LessonAttempt, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LessonAttempt;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonAttempt&&(identical(other.clientEventId, _this.clientEventId) || other.clientEventId == _this.clientEventId)&&(identical(other.lessonId, _this.lessonId) || other.lessonId == _this.lessonId)&&(identical(other.mistakes, _this.mistakes) || other.mistakes == _this.mistakes)&&(identical(other.duration, _this.duration) || other.duration == _this.duration)&&(identical(other.completedAt, _this.completedAt) || other.completedAt == _this.completedAt));
}


@override
int get hashCode {
  final _this = this as LessonAttempt;
  return Object.hash(runtimeType,_this.clientEventId,_this.lessonId,_this.mistakes,_this.duration,_this.completedAt);
}

@override
String toString() {
  final _this = this as LessonAttempt;
  return 'LessonAttempt(clientEventId: ${_this.clientEventId}, lessonId: ${_this.lessonId}, mistakes: ${_this.mistakes}, duration: ${_this.duration}, completedAt: ${_this.completedAt})';
}


}

/// @nodoc
abstract mixin class $LessonAttemptCopyWith<$Res>  {
  factory $LessonAttemptCopyWith(LessonAttempt value, $Res Function(LessonAttempt) _then) = _$LessonAttemptCopyWithImpl;
@useResult
$Res call({
 String clientEventId, String lessonId, int mistakes, Duration duration, DateTime completedAt
});




}
/// @nodoc
class _$LessonAttemptCopyWithImpl<$Res>
    implements $LessonAttemptCopyWith<$Res> {
  _$LessonAttemptCopyWithImpl(this._self, this._then);

  final LessonAttempt _self;
  final $Res Function(LessonAttempt) _then;

/// Create a copy of LessonAttempt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? clientEventId = null,Object? lessonId = null,Object? mistakes = null,Object? duration = null,Object? completedAt = null,}) {
  return _then(LessonAttempt(
clientEventId: null == clientEventId ? _self.clientEventId : clientEventId // ignore: cast_nullable_to_non_nullable
as String,lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String,mistakes: null == mistakes ? _self.mistakes : mistakes // ignore: cast_nullable_to_non_nullable
as int,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,completedAt: null == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [LessonAttempt].
extension LessonAttemptPatterns on LessonAttempt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonAttempt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonAttempt() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonAttempt value)  $default,){
final _that = this;
switch (_that) {
case _LessonAttempt():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonAttempt value)?  $default,){
final _that = this;
switch (_that) {
case _LessonAttempt() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String clientEventId,  String lessonId,  int mistakes,  Duration duration,  DateTime completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonAttempt() when $default != null:
return $default(_that.clientEventId,_that.lessonId,_that.mistakes,_that.duration,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String clientEventId,  String lessonId,  int mistakes,  Duration duration,  DateTime completedAt)  $default,) {final _that = this;
switch (_that) {
case _LessonAttempt():
return $default(_that.clientEventId,_that.lessonId,_that.mistakes,_that.duration,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String clientEventId,  String lessonId,  int mistakes,  Duration duration,  DateTime completedAt)?  $default,) {final _that = this;
switch (_that) {
case _LessonAttempt() when $default != null:
return $default(_that.clientEventId,_that.lessonId,_that.mistakes,_that.duration,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc


class _LessonAttempt implements LessonAttempt {
  const _LessonAttempt({required this.clientEventId, required this.lessonId, required this.mistakes, required this.duration, required this.completedAt});
  

@override final  String clientEventId;
@override final  String lessonId;
/// Wrong answers (camera "almost" doesn't count).
@override final  int mistakes;
@override final  Duration duration;
@override final  DateTime completedAt;

/// Create a copy of LessonAttempt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonAttemptCopyWith<_LessonAttempt> get copyWith => __$LessonAttemptCopyWithImpl<_LessonAttempt>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonAttempt&&(identical(other.clientEventId, clientEventId) || other.clientEventId == clientEventId)&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.mistakes, mistakes) || other.mistakes == mistakes)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,clientEventId,lessonId,mistakes,duration,completedAt);
}

@override
String toString() {
    return 'LessonAttempt(clientEventId: $clientEventId, lessonId: $lessonId, mistakes: $mistakes, duration: $duration, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$LessonAttemptCopyWith<$Res> implements $LessonAttemptCopyWith<$Res> {
  factory _$LessonAttemptCopyWith(_LessonAttempt value, $Res Function(_LessonAttempt) _then) = __$LessonAttemptCopyWithImpl;
@override @useResult
$Res call({
 String clientEventId, String lessonId, int mistakes, Duration duration, DateTime completedAt
});




}
/// @nodoc
class __$LessonAttemptCopyWithImpl<$Res>
    implements _$LessonAttemptCopyWith<$Res> {
  __$LessonAttemptCopyWithImpl(this._self, this._then);

  final _LessonAttempt _self;
  final $Res Function(_LessonAttempt) _then;

/// Create a copy of LessonAttempt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? clientEventId = null,Object? lessonId = null,Object? mistakes = null,Object? duration = null,Object? completedAt = null,}) {
  return _then(_LessonAttempt(
clientEventId: null == clientEventId ? _self.clientEventId : clientEventId // ignore: cast_nullable_to_non_nullable
as String,lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String,mistakes: null == mistakes ? _self.mistakes : mistakes // ignore: cast_nullable_to_non_nullable
as int,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,completedAt: null == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$LessonResult {

 String get lessonId; String get clientEventId;/// Lesson reward + perfect bonus (game-rules.md).
 int get xpEarned;/// 0–1 share of answers right first time.
 double get accuracy; Duration get duration;/// Headline count ("You learned 5 new greetings.").
 int get newSignCount; List<Sign> get signs;/// Whether this lesson extended the streak (then Figma 27 follows).
 bool get streakExtended; int get streakDays; int get hearts; DateTime get completedAt;
/// Create a copy of LessonResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonResultCopyWith<LessonResult> get copyWith => _$LessonResultCopyWithImpl<LessonResult>(this as LessonResult, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LessonResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonResult&&(identical(other.lessonId, _this.lessonId) || other.lessonId == _this.lessonId)&&(identical(other.clientEventId, _this.clientEventId) || other.clientEventId == _this.clientEventId)&&(identical(other.xpEarned, _this.xpEarned) || other.xpEarned == _this.xpEarned)&&(identical(other.accuracy, _this.accuracy) || other.accuracy == _this.accuracy)&&(identical(other.duration, _this.duration) || other.duration == _this.duration)&&(identical(other.newSignCount, _this.newSignCount) || other.newSignCount == _this.newSignCount)&&const DeepCollectionEquality().equals(other.signs, _this.signs)&&(identical(other.streakExtended, _this.streakExtended) || other.streakExtended == _this.streakExtended)&&(identical(other.streakDays, _this.streakDays) || other.streakDays == _this.streakDays)&&(identical(other.hearts, _this.hearts) || other.hearts == _this.hearts)&&(identical(other.completedAt, _this.completedAt) || other.completedAt == _this.completedAt));
}


@override
int get hashCode {
  final _this = this as LessonResult;
  return Object.hash(runtimeType,_this.lessonId,_this.clientEventId,_this.xpEarned,_this.accuracy,_this.duration,_this.newSignCount,const DeepCollectionEquality().hash(_this.signs),_this.streakExtended,_this.streakDays,_this.hearts,_this.completedAt);
}

@override
String toString() {
  final _this = this as LessonResult;
  return 'LessonResult(lessonId: ${_this.lessonId}, clientEventId: ${_this.clientEventId}, xpEarned: ${_this.xpEarned}, accuracy: ${_this.accuracy}, duration: ${_this.duration}, newSignCount: ${_this.newSignCount}, signs: ${_this.signs}, streakExtended: ${_this.streakExtended}, streakDays: ${_this.streakDays}, hearts: ${_this.hearts}, completedAt: ${_this.completedAt})';
}


}

/// @nodoc
abstract mixin class $LessonResultCopyWith<$Res>  {
  factory $LessonResultCopyWith(LessonResult value, $Res Function(LessonResult) _then) = _$LessonResultCopyWithImpl;
@useResult
$Res call({
 String lessonId, String clientEventId, int xpEarned, double accuracy, Duration duration, int newSignCount, List<Sign> signs, bool streakExtended, int streakDays, int hearts, DateTime completedAt
});




}
/// @nodoc
class _$LessonResultCopyWithImpl<$Res>
    implements $LessonResultCopyWith<$Res> {
  _$LessonResultCopyWithImpl(this._self, this._then);

  final LessonResult _self;
  final $Res Function(LessonResult) _then;

/// Create a copy of LessonResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lessonId = null,Object? clientEventId = null,Object? xpEarned = null,Object? accuracy = null,Object? duration = null,Object? newSignCount = null,Object? signs = null,Object? streakExtended = null,Object? streakDays = null,Object? hearts = null,Object? completedAt = null,}) {
  return _then(LessonResult(
lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String,clientEventId: null == clientEventId ? _self.clientEventId : clientEventId // ignore: cast_nullable_to_non_nullable
as String,xpEarned: null == xpEarned ? _self.xpEarned : xpEarned // ignore: cast_nullable_to_non_nullable
as int,accuracy: null == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,newSignCount: null == newSignCount ? _self.newSignCount : newSignCount // ignore: cast_nullable_to_non_nullable
as int,signs: null == signs ? _self.signs : signs // ignore: cast_nullable_to_non_nullable
as List<Sign>,streakExtended: null == streakExtended ? _self.streakExtended : streakExtended // ignore: cast_nullable_to_non_nullable
as bool,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,hearts: null == hearts ? _self.hearts : hearts // ignore: cast_nullable_to_non_nullable
as int,completedAt: null == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [LessonResult].
extension LessonResultPatterns on LessonResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonResult value)  $default,){
final _that = this;
switch (_that) {
case _LessonResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonResult value)?  $default,){
final _that = this;
switch (_that) {
case _LessonResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String lessonId,  String clientEventId,  int xpEarned,  double accuracy,  Duration duration,  int newSignCount,  List<Sign> signs,  bool streakExtended,  int streakDays,  int hearts,  DateTime completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonResult() when $default != null:
return $default(_that.lessonId,_that.clientEventId,_that.xpEarned,_that.accuracy,_that.duration,_that.newSignCount,_that.signs,_that.streakExtended,_that.streakDays,_that.hearts,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String lessonId,  String clientEventId,  int xpEarned,  double accuracy,  Duration duration,  int newSignCount,  List<Sign> signs,  bool streakExtended,  int streakDays,  int hearts,  DateTime completedAt)  $default,) {final _that = this;
switch (_that) {
case _LessonResult():
return $default(_that.lessonId,_that.clientEventId,_that.xpEarned,_that.accuracy,_that.duration,_that.newSignCount,_that.signs,_that.streakExtended,_that.streakDays,_that.hearts,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String lessonId,  String clientEventId,  int xpEarned,  double accuracy,  Duration duration,  int newSignCount,  List<Sign> signs,  bool streakExtended,  int streakDays,  int hearts,  DateTime completedAt)?  $default,) {final _that = this;
switch (_that) {
case _LessonResult() when $default != null:
return $default(_that.lessonId,_that.clientEventId,_that.xpEarned,_that.accuracy,_that.duration,_that.newSignCount,_that.signs,_that.streakExtended,_that.streakDays,_that.hearts,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc


class _LessonResult implements LessonResult {
  const _LessonResult({required this.lessonId, required this.clientEventId, required this.xpEarned, required this.accuracy, required this.duration, required this.newSignCount, required  List<Sign> signs, required this.streakExtended, required this.streakDays, required this.hearts, required this.completedAt}): _signs = signs;
  

@override final  String lessonId;
@override final  String clientEventId;
/// Lesson reward + perfect bonus (game-rules.md).
@override final  int xpEarned;
/// 0–1 share of answers right first time.
@override final  double accuracy;
@override final  Duration duration;
/// Headline count ("You learned 5 new greetings.").
@override final  int newSignCount;
 final  List<Sign> _signs;
@override List<Sign> get signs {
  if (_signs is EqualUnmodifiableListView) return _signs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_signs);
}

/// Whether this lesson extended the streak (then Figma 27 follows).
@override final  bool streakExtended;
@override final  int streakDays;
@override final  int hearts;
@override final  DateTime completedAt;

/// Create a copy of LessonResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonResultCopyWith<_LessonResult> get copyWith => __$LessonResultCopyWithImpl<_LessonResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonResult&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.clientEventId, clientEventId) || other.clientEventId == clientEventId)&&(identical(other.xpEarned, xpEarned) || other.xpEarned == xpEarned)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.newSignCount, newSignCount) || other.newSignCount == newSignCount)&&const DeepCollectionEquality().equals(other.signs, _signs)&&(identical(other.streakExtended, streakExtended) || other.streakExtended == streakExtended)&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&(identical(other.hearts, hearts) || other.hearts == hearts)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,lessonId,clientEventId,xpEarned,accuracy,duration,newSignCount,const DeepCollectionEquality().hash(_signs),streakExtended,streakDays,hearts,completedAt);
}

@override
String toString() {
    return 'LessonResult(lessonId: $lessonId, clientEventId: $clientEventId, xpEarned: $xpEarned, accuracy: $accuracy, duration: $duration, newSignCount: $newSignCount, signs: $signs, streakExtended: $streakExtended, streakDays: $streakDays, hearts: $hearts, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$LessonResultCopyWith<$Res> implements $LessonResultCopyWith<$Res> {
  factory _$LessonResultCopyWith(_LessonResult value, $Res Function(_LessonResult) _then) = __$LessonResultCopyWithImpl;
@override @useResult
$Res call({
 String lessonId, String clientEventId, int xpEarned, double accuracy, Duration duration, int newSignCount, List<Sign> signs, bool streakExtended, int streakDays, int hearts, DateTime completedAt
});




}
/// @nodoc
class __$LessonResultCopyWithImpl<$Res>
    implements _$LessonResultCopyWith<$Res> {
  __$LessonResultCopyWithImpl(this._self, this._then);

  final _LessonResult _self;
  final $Res Function(_LessonResult) _then;

/// Create a copy of LessonResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lessonId = null,Object? clientEventId = null,Object? xpEarned = null,Object? accuracy = null,Object? duration = null,Object? newSignCount = null,Object? signs = null,Object? streakExtended = null,Object? streakDays = null,Object? hearts = null,Object? completedAt = null,}) {
  return _then(_LessonResult(
lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String,clientEventId: null == clientEventId ? _self.clientEventId : clientEventId // ignore: cast_nullable_to_non_nullable
as String,xpEarned: null == xpEarned ? _self.xpEarned : xpEarned // ignore: cast_nullable_to_non_nullable
as int,accuracy: null == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,newSignCount: null == newSignCount ? _self.newSignCount : newSignCount // ignore: cast_nullable_to_non_nullable
as int,signs: null == signs ? _self._signs : signs // ignore: cast_nullable_to_non_nullable
as List<Sign>,streakExtended: null == streakExtended ? _self.streakExtended : streakExtended // ignore: cast_nullable_to_non_nullable
as bool,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,hearts: null == hearts ? _self.hearts : hearts // ignore: cast_nullable_to_non_nullable
as int,completedAt: null == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
