// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'progress_sync_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProgressSyncReport {

/// What the server awarded for each newly applied completion.
 List<LessonResult> get applied;/// Events the server had already recorded (dropped from the queue).
 int get duplicates;/// Events the server can't apply (dropped; the contract says never retry).
 int get rejected;/// Events still waiting in the queue after this flush.
 int get remaining;
/// Create a copy of ProgressSyncReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgressSyncReportCopyWith<ProgressSyncReport> get copyWith => _$ProgressSyncReportCopyWithImpl<ProgressSyncReport>(this as ProgressSyncReport, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProgressSyncReport;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgressSyncReport&&const DeepCollectionEquality().equals(other.applied, _this.applied)&&(identical(other.duplicates, _this.duplicates) || other.duplicates == _this.duplicates)&&(identical(other.rejected, _this.rejected) || other.rejected == _this.rejected)&&(identical(other.remaining, _this.remaining) || other.remaining == _this.remaining));
}


@override
int get hashCode {
  final _this = this as ProgressSyncReport;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.applied),_this.duplicates,_this.rejected,_this.remaining);
}

@override
String toString() {
  final _this = this as ProgressSyncReport;
  return 'ProgressSyncReport(applied: ${_this.applied}, duplicates: ${_this.duplicates}, rejected: ${_this.rejected}, remaining: ${_this.remaining})';
}


}

/// @nodoc
abstract mixin class $ProgressSyncReportCopyWith<$Res>  {
  factory $ProgressSyncReportCopyWith(ProgressSyncReport value, $Res Function(ProgressSyncReport) _then) = _$ProgressSyncReportCopyWithImpl;
@useResult
$Res call({
 List<LessonResult> applied, int duplicates, int rejected, int remaining
});




}
/// @nodoc
class _$ProgressSyncReportCopyWithImpl<$Res>
    implements $ProgressSyncReportCopyWith<$Res> {
  _$ProgressSyncReportCopyWithImpl(this._self, this._then);

  final ProgressSyncReport _self;
  final $Res Function(ProgressSyncReport) _then;

/// Create a copy of ProgressSyncReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? applied = null,Object? duplicates = null,Object? rejected = null,Object? remaining = null,}) {
  return _then(ProgressSyncReport(
applied: null == applied ? _self.applied : applied // ignore: cast_nullable_to_non_nullable
as List<LessonResult>,duplicates: null == duplicates ? _self.duplicates : duplicates // ignore: cast_nullable_to_non_nullable
as int,rejected: null == rejected ? _self.rejected : rejected // ignore: cast_nullable_to_non_nullable
as int,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProgressSyncReport].
extension ProgressSyncReportPatterns on ProgressSyncReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgressSyncReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgressSyncReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgressSyncReport value)  $default,){
final _that = this;
switch (_that) {
case _ProgressSyncReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgressSyncReport value)?  $default,){
final _that = this;
switch (_that) {
case _ProgressSyncReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<LessonResult> applied,  int duplicates,  int rejected,  int remaining)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgressSyncReport() when $default != null:
return $default(_that.applied,_that.duplicates,_that.rejected,_that.remaining);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<LessonResult> applied,  int duplicates,  int rejected,  int remaining)  $default,) {final _that = this;
switch (_that) {
case _ProgressSyncReport():
return $default(_that.applied,_that.duplicates,_that.rejected,_that.remaining);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<LessonResult> applied,  int duplicates,  int rejected,  int remaining)?  $default,) {final _that = this;
switch (_that) {
case _ProgressSyncReport() when $default != null:
return $default(_that.applied,_that.duplicates,_that.rejected,_that.remaining);case _:
  return null;

}
}

}

/// @nodoc


class _ProgressSyncReport implements ProgressSyncReport {
  const _ProgressSyncReport({ List<LessonResult> applied = const <LessonResult>[], this.duplicates = 0, this.rejected = 0, this.remaining = 0}): _applied = applied;
  

/// What the server awarded for each newly applied completion.
 final  List<LessonResult> _applied;
/// What the server awarded for each newly applied completion.
@override@JsonKey() List<LessonResult> get applied {
  if (_applied is EqualUnmodifiableListView) return _applied;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_applied);
}

/// Events the server had already recorded (dropped from the queue).
@override@JsonKey() final  int duplicates;
/// Events the server can't apply (dropped; the contract says never retry).
@override@JsonKey() final  int rejected;
/// Events still waiting in the queue after this flush.
@override@JsonKey() final  int remaining;

/// Create a copy of ProgressSyncReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgressSyncReportCopyWith<_ProgressSyncReport> get copyWith => __$ProgressSyncReportCopyWithImpl<_ProgressSyncReport>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgressSyncReport&&const DeepCollectionEquality().equals(other.applied, _applied)&&(identical(other.duplicates, duplicates) || other.duplicates == duplicates)&&(identical(other.rejected, rejected) || other.rejected == rejected)&&(identical(other.remaining, remaining) || other.remaining == remaining));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_applied),duplicates,rejected,remaining);
}

@override
String toString() {
    return 'ProgressSyncReport(applied: $applied, duplicates: $duplicates, rejected: $rejected, remaining: $remaining)';
}


}

/// @nodoc
abstract mixin class _$ProgressSyncReportCopyWith<$Res> implements $ProgressSyncReportCopyWith<$Res> {
  factory _$ProgressSyncReportCopyWith(_ProgressSyncReport value, $Res Function(_ProgressSyncReport) _then) = __$ProgressSyncReportCopyWithImpl;
@override @useResult
$Res call({
 List<LessonResult> applied, int duplicates, int rejected, int remaining
});




}
/// @nodoc
class __$ProgressSyncReportCopyWithImpl<$Res>
    implements _$ProgressSyncReportCopyWith<$Res> {
  __$ProgressSyncReportCopyWithImpl(this._self, this._then);

  final _ProgressSyncReport _self;
  final $Res Function(_ProgressSyncReport) _then;

/// Create a copy of ProgressSyncReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? applied = null,Object? duplicates = null,Object? rejected = null,Object? remaining = null,}) {
  return _then(_ProgressSyncReport(
applied: null == applied ? _self._applied : applied // ignore: cast_nullable_to_non_nullable
as List<LessonResult>,duplicates: null == duplicates ? _self.duplicates : duplicates // ignore: cast_nullable_to_non_nullable
as int,rejected: null == rejected ? _self.rejected : rejected // ignore: cast_nullable_to_non_nullable
as int,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
