// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'path_unit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PathUnit {

 String get id; int get number; String get title; UnitTint get tint; int get learnedCount; int get totalCount; List<PathStop> get stops;
/// Create a copy of PathUnit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PathUnitCopyWith<PathUnit> get copyWith => _$PathUnitCopyWithImpl<PathUnit>(this as PathUnit, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PathUnit;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PathUnit&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.number, _this.number) || other.number == _this.number)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.tint, _this.tint) || other.tint == _this.tint)&&(identical(other.learnedCount, _this.learnedCount) || other.learnedCount == _this.learnedCount)&&(identical(other.totalCount, _this.totalCount) || other.totalCount == _this.totalCount)&&const DeepCollectionEquality().equals(other.stops, _this.stops));
}


@override
int get hashCode {
  final _this = this as PathUnit;
  return Object.hash(runtimeType,_this.id,_this.number,_this.title,_this.tint,_this.learnedCount,_this.totalCount,const DeepCollectionEquality().hash(_this.stops));
}

@override
String toString() {
  final _this = this as PathUnit;
  return 'PathUnit(id: ${_this.id}, number: ${_this.number}, title: ${_this.title}, tint: ${_this.tint}, learnedCount: ${_this.learnedCount}, totalCount: ${_this.totalCount}, stops: ${_this.stops})';
}


}

/// @nodoc
abstract mixin class $PathUnitCopyWith<$Res>  {
  factory $PathUnitCopyWith(PathUnit value, $Res Function(PathUnit) _then) = _$PathUnitCopyWithImpl;
@useResult
$Res call({
 String id, int number, String title, UnitTint tint, int learnedCount, int totalCount, List<PathStop> stops
});




}
/// @nodoc
class _$PathUnitCopyWithImpl<$Res>
    implements $PathUnitCopyWith<$Res> {
  _$PathUnitCopyWithImpl(this._self, this._then);

  final PathUnit _self;
  final $Res Function(PathUnit) _then;

/// Create a copy of PathUnit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? number = null,Object? title = null,Object? tint = null,Object? learnedCount = null,Object? totalCount = null,Object? stops = null,}) {
  return _then(PathUnit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,tint: null == tint ? _self.tint : tint // ignore: cast_nullable_to_non_nullable
as UnitTint,learnedCount: null == learnedCount ? _self.learnedCount : learnedCount // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,stops: null == stops ? _self.stops : stops // ignore: cast_nullable_to_non_nullable
as List<PathStop>,
  ));
}

}


/// Adds pattern-matching-related methods to [PathUnit].
extension PathUnitPatterns on PathUnit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PathUnit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PathUnit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PathUnit value)  $default,){
final _that = this;
switch (_that) {
case _PathUnit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PathUnit value)?  $default,){
final _that = this;
switch (_that) {
case _PathUnit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int number,  String title,  UnitTint tint,  int learnedCount,  int totalCount,  List<PathStop> stops)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PathUnit() when $default != null:
return $default(_that.id,_that.number,_that.title,_that.tint,_that.learnedCount,_that.totalCount,_that.stops);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int number,  String title,  UnitTint tint,  int learnedCount,  int totalCount,  List<PathStop> stops)  $default,) {final _that = this;
switch (_that) {
case _PathUnit():
return $default(_that.id,_that.number,_that.title,_that.tint,_that.learnedCount,_that.totalCount,_that.stops);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int number,  String title,  UnitTint tint,  int learnedCount,  int totalCount,  List<PathStop> stops)?  $default,) {final _that = this;
switch (_that) {
case _PathUnit() when $default != null:
return $default(_that.id,_that.number,_that.title,_that.tint,_that.learnedCount,_that.totalCount,_that.stops);case _:
  return null;

}
}

}

/// @nodoc


class _PathUnit implements PathUnit {
  const _PathUnit({required this.id, required this.number, required this.title, required this.tint, required this.learnedCount, required this.totalCount, required  List<PathStop> stops}): _stops = stops;
  

@override final  String id;
@override final  int number;
@override final  String title;
@override final  UnitTint tint;
@override final  int learnedCount;
@override final  int totalCount;
 final  List<PathStop> _stops;
@override List<PathStop> get stops {
  if (_stops is EqualUnmodifiableListView) return _stops;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stops);
}


/// Create a copy of PathUnit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PathUnitCopyWith<_PathUnit> get copyWith => __$PathUnitCopyWithImpl<_PathUnit>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PathUnit&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.title, title) || other.title == title)&&(identical(other.tint, tint) || other.tint == tint)&&(identical(other.learnedCount, learnedCount) || other.learnedCount == learnedCount)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&const DeepCollectionEquality().equals(other.stops, _stops));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,number,title,tint,learnedCount,totalCount,const DeepCollectionEquality().hash(_stops));
}

@override
String toString() {
    return 'PathUnit(id: $id, number: $number, title: $title, tint: $tint, learnedCount: $learnedCount, totalCount: $totalCount, stops: $stops)';
}


}

/// @nodoc
abstract mixin class _$PathUnitCopyWith<$Res> implements $PathUnitCopyWith<$Res> {
  factory _$PathUnitCopyWith(_PathUnit value, $Res Function(_PathUnit) _then) = __$PathUnitCopyWithImpl;
@override @useResult
$Res call({
 String id, int number, String title, UnitTint tint, int learnedCount, int totalCount, List<PathStop> stops
});




}
/// @nodoc
class __$PathUnitCopyWithImpl<$Res>
    implements _$PathUnitCopyWith<$Res> {
  __$PathUnitCopyWithImpl(this._self, this._then);

  final _PathUnit _self;
  final $Res Function(_PathUnit) _then;

/// Create a copy of PathUnit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? number = null,Object? title = null,Object? tint = null,Object? learnedCount = null,Object? totalCount = null,Object? stops = null,}) {
  return _then(_PathUnit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,tint: null == tint ? _self.tint : tint // ignore: cast_nullable_to_non_nullable
as UnitTint,learnedCount: null == learnedCount ? _self.learnedCount : learnedCount // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,stops: null == stops ? _self._stops : stops // ignore: cast_nullable_to_non_nullable
as List<PathStop>,
  ));
}


}

/// @nodoc
mixin _$PathStop {

 String get id; StopType get type; LessonState get state; String get title; LessonSummary? get lesson;
/// Create a copy of PathStop
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PathStopCopyWith<PathStop> get copyWith => _$PathStopCopyWithImpl<PathStop>(this as PathStop, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PathStop;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PathStop&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.lesson, _this.lesson) || other.lesson == _this.lesson));
}


@override
int get hashCode {
  final _this = this as PathStop;
  return Object.hash(runtimeType,_this.id,_this.type,_this.state,_this.title,_this.lesson);
}

@override
String toString() {
  final _this = this as PathStop;
  return 'PathStop(id: ${_this.id}, type: ${_this.type}, state: ${_this.state}, title: ${_this.title}, lesson: ${_this.lesson})';
}


}

/// @nodoc
abstract mixin class $PathStopCopyWith<$Res>  {
  factory $PathStopCopyWith(PathStop value, $Res Function(PathStop) _then) = _$PathStopCopyWithImpl;
@useResult
$Res call({
 String id, StopType type, LessonState state, String title, LessonSummary? lesson
});


$LessonSummaryCopyWith<$Res>? get lesson;

}
/// @nodoc
class _$PathStopCopyWithImpl<$Res>
    implements $PathStopCopyWith<$Res> {
  _$PathStopCopyWithImpl(this._self, this._then);

  final PathStop _self;
  final $Res Function(PathStop) _then;

/// Create a copy of PathStop
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? state = null,Object? title = null,Object? lesson = freezed,}) {
  return _then(PathStop(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as StopType,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as LessonState,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,lesson: freezed == lesson ? _self.lesson : lesson // ignore: cast_nullable_to_non_nullable
as LessonSummary?,
  ));
}
/// Create a copy of PathStop
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonSummaryCopyWith<$Res>? get lesson {
    if (_self.lesson == null) {
    return null;
  }

  return $LessonSummaryCopyWith<$Res>(_self.lesson!, (value) {
    return _then(_self.copyWith(lesson: value));
  });
}
}


/// Adds pattern-matching-related methods to [PathStop].
extension PathStopPatterns on PathStop {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PathStop value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PathStop() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PathStop value)  $default,){
final _that = this;
switch (_that) {
case _PathStop():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PathStop value)?  $default,){
final _that = this;
switch (_that) {
case _PathStop() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  StopType type,  LessonState state,  String title,  LessonSummary? lesson)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PathStop() when $default != null:
return $default(_that.id,_that.type,_that.state,_that.title,_that.lesson);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  StopType type,  LessonState state,  String title,  LessonSummary? lesson)  $default,) {final _that = this;
switch (_that) {
case _PathStop():
return $default(_that.id,_that.type,_that.state,_that.title,_that.lesson);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  StopType type,  LessonState state,  String title,  LessonSummary? lesson)?  $default,) {final _that = this;
switch (_that) {
case _PathStop() when $default != null:
return $default(_that.id,_that.type,_that.state,_that.title,_that.lesson);case _:
  return null;

}
}

}

/// @nodoc


class _PathStop implements PathStop {
  const _PathStop({required this.id, required this.type, required this.state, required this.title, this.lesson});
  

@override final  String id;
@override final  StopType type;
@override final  LessonState state;
@override final  String title;
@override final  LessonSummary? lesson;

/// Create a copy of PathStop
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PathStopCopyWith<_PathStop> get copyWith => __$PathStopCopyWithImpl<_PathStop>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PathStop&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.state, state) || other.state == state)&&(identical(other.title, title) || other.title == title)&&(identical(other.lesson, lesson) || other.lesson == lesson));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,type,state,title,lesson);
}

@override
String toString() {
    return 'PathStop(id: $id, type: $type, state: $state, title: $title, lesson: $lesson)';
}


}

/// @nodoc
abstract mixin class _$PathStopCopyWith<$Res> implements $PathStopCopyWith<$Res> {
  factory _$PathStopCopyWith(_PathStop value, $Res Function(_PathStop) _then) = __$PathStopCopyWithImpl;
@override @useResult
$Res call({
 String id, StopType type, LessonState state, String title, LessonSummary? lesson
});


@override $LessonSummaryCopyWith<$Res>? get lesson;

}
/// @nodoc
class __$PathStopCopyWithImpl<$Res>
    implements _$PathStopCopyWith<$Res> {
  __$PathStopCopyWithImpl(this._self, this._then);

  final _PathStop _self;
  final $Res Function(_PathStop) _then;

/// Create a copy of PathStop
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? state = null,Object? title = null,Object? lesson = freezed,}) {
  return _then(_PathStop(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as StopType,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as LessonState,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,lesson: freezed == lesson ? _self.lesson : lesson // ignore: cast_nullable_to_non_nullable
as LessonSummary?,
  ));
}

/// Create a copy of PathStop
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonSummaryCopyWith<$Res>? get lesson {
    if (_self.lesson == null) {
    return null;
  }

  return $LessonSummaryCopyWith<$Res>(_self.lesson!, (value) {
    return _then(_self.copyWith(lesson: value));
  });
}
}

// dart format on
