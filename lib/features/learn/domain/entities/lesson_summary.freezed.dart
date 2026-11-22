// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LessonSummary {

 String get id; String get unitId; String get title; LessonKind get kind; LessonState get state; int get signCount; int get minutes;
/// Create a copy of LessonSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonSummaryCopyWith<LessonSummary> get copyWith => _$LessonSummaryCopyWithImpl<LessonSummary>(this as LessonSummary, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LessonSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonSummary&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.unitId, _this.unitId) || other.unitId == _this.unitId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.signCount, _this.signCount) || other.signCount == _this.signCount)&&(identical(other.minutes, _this.minutes) || other.minutes == _this.minutes));
}


@override
int get hashCode {
  final _this = this as LessonSummary;
  return Object.hash(runtimeType,_this.id,_this.unitId,_this.title,_this.kind,_this.state,_this.signCount,_this.minutes);
}

@override
String toString() {
  final _this = this as LessonSummary;
  return 'LessonSummary(id: ${_this.id}, unitId: ${_this.unitId}, title: ${_this.title}, kind: ${_this.kind}, state: ${_this.state}, signCount: ${_this.signCount}, minutes: ${_this.minutes})';
}


}

/// @nodoc
abstract mixin class $LessonSummaryCopyWith<$Res>  {
  factory $LessonSummaryCopyWith(LessonSummary value, $Res Function(LessonSummary) _then) = _$LessonSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String unitId, String title, LessonKind kind, LessonState state, int signCount, int minutes
});




}
/// @nodoc
class _$LessonSummaryCopyWithImpl<$Res>
    implements $LessonSummaryCopyWith<$Res> {
  _$LessonSummaryCopyWithImpl(this._self, this._then);

  final LessonSummary _self;
  final $Res Function(LessonSummary) _then;

/// Create a copy of LessonSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? unitId = null,Object? title = null,Object? kind = null,Object? state = null,Object? signCount = null,Object? minutes = null,}) {
  return _then(LessonSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,unitId: null == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as LessonKind,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as LessonState,signCount: null == signCount ? _self.signCount : signCount // ignore: cast_nullable_to_non_nullable
as int,minutes: null == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LessonSummary].
extension LessonSummaryPatterns on LessonSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonSummary value)  $default,){
final _that = this;
switch (_that) {
case _LessonSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonSummary value)?  $default,){
final _that = this;
switch (_that) {
case _LessonSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String unitId,  String title,  LessonKind kind,  LessonState state,  int signCount,  int minutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonSummary() when $default != null:
return $default(_that.id,_that.unitId,_that.title,_that.kind,_that.state,_that.signCount,_that.minutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String unitId,  String title,  LessonKind kind,  LessonState state,  int signCount,  int minutes)  $default,) {final _that = this;
switch (_that) {
case _LessonSummary():
return $default(_that.id,_that.unitId,_that.title,_that.kind,_that.state,_that.signCount,_that.minutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String unitId,  String title,  LessonKind kind,  LessonState state,  int signCount,  int minutes)?  $default,) {final _that = this;
switch (_that) {
case _LessonSummary() when $default != null:
return $default(_that.id,_that.unitId,_that.title,_that.kind,_that.state,_that.signCount,_that.minutes);case _:
  return null;

}
}

}

/// @nodoc


class _LessonSummary implements LessonSummary {
  const _LessonSummary({required this.id, required this.unitId, required this.title, required this.kind, required this.state, required this.signCount, required this.minutes});
  

@override final  String id;
@override final  String unitId;
@override final  String title;
@override final  LessonKind kind;
@override final  LessonState state;
@override final  int signCount;
@override final  int minutes;

/// Create a copy of LessonSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonSummaryCopyWith<_LessonSummary> get copyWith => __$LessonSummaryCopyWithImpl<_LessonSummary>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.unitId, unitId) || other.unitId == unitId)&&(identical(other.title, title) || other.title == title)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.state, state) || other.state == state)&&(identical(other.signCount, signCount) || other.signCount == signCount)&&(identical(other.minutes, minutes) || other.minutes == minutes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,unitId,title,kind,state,signCount,minutes);
}

@override
String toString() {
    return 'LessonSummary(id: $id, unitId: $unitId, title: $title, kind: $kind, state: $state, signCount: $signCount, minutes: $minutes)';
}


}

/// @nodoc
abstract mixin class _$LessonSummaryCopyWith<$Res> implements $LessonSummaryCopyWith<$Res> {
  factory _$LessonSummaryCopyWith(_LessonSummary value, $Res Function(_LessonSummary) _then) = __$LessonSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String unitId, String title, LessonKind kind, LessonState state, int signCount, int minutes
});




}
/// @nodoc
class __$LessonSummaryCopyWithImpl<$Res>
    implements _$LessonSummaryCopyWith<$Res> {
  __$LessonSummaryCopyWithImpl(this._self, this._then);

  final _LessonSummary _self;
  final $Res Function(_LessonSummary) _then;

/// Create a copy of LessonSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? unitId = null,Object? title = null,Object? kind = null,Object? state = null,Object? signCount = null,Object? minutes = null,}) {
  return _then(_LessonSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,unitId: null == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as LessonKind,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as LessonState,signCount: null == signCount ? _self.signCount : signCount // ignore: cast_nullable_to_non_nullable
as int,minutes: null == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
