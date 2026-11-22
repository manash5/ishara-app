// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'path_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PathDto {

 List<PathUnitDto> get units;
/// Create a copy of PathDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PathDtoCopyWith<PathDto> get copyWith => _$PathDtoCopyWithImpl<PathDto>(this as PathDto, _$identity);

  /// Serializes this PathDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PathDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PathDto&&const DeepCollectionEquality().equals(other.units, _this.units));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PathDto;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.units));
}

@override
String toString() {
  final _this = this as PathDto;
  return 'PathDto(units: ${_this.units})';
}


}

/// @nodoc
abstract mixin class $PathDtoCopyWith<$Res>  {
  factory $PathDtoCopyWith(PathDto value, $Res Function(PathDto) _then) = _$PathDtoCopyWithImpl;
@useResult
$Res call({
 List<PathUnitDto> units
});




}
/// @nodoc
class _$PathDtoCopyWithImpl<$Res>
    implements $PathDtoCopyWith<$Res> {
  _$PathDtoCopyWithImpl(this._self, this._then);

  final PathDto _self;
  final $Res Function(PathDto) _then;

/// Create a copy of PathDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? units = null,}) {
  return _then(PathDto(
units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as List<PathUnitDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [PathDto].
extension PathDtoPatterns on PathDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PathDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PathDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PathDto value)  $default,){
final _that = this;
switch (_that) {
case _PathDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PathDto value)?  $default,){
final _that = this;
switch (_that) {
case _PathDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PathUnitDto> units)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PathDto() when $default != null:
return $default(_that.units);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PathUnitDto> units)  $default,) {final _that = this;
switch (_that) {
case _PathDto():
return $default(_that.units);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PathUnitDto> units)?  $default,) {final _that = this;
switch (_that) {
case _PathDto() when $default != null:
return $default(_that.units);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PathDto extends PathDto {
  const _PathDto({required  List<PathUnitDto> units}): _units = units,super._();
  factory _PathDto.fromJson(Map<String, dynamic> json) => _$PathDtoFromJson(json);

 final  List<PathUnitDto> _units;
@override List<PathUnitDto> get units {
  if (_units is EqualUnmodifiableListView) return _units;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_units);
}


/// Create a copy of PathDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PathDtoCopyWith<_PathDto> get copyWith => __$PathDtoCopyWithImpl<_PathDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PathDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PathDto&&const DeepCollectionEquality().equals(other.units, _units));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_units));
}

@override
String toString() {
    return 'PathDto(units: $units)';
}


}

/// @nodoc
abstract mixin class _$PathDtoCopyWith<$Res> implements $PathDtoCopyWith<$Res> {
  factory _$PathDtoCopyWith(_PathDto value, $Res Function(_PathDto) _then) = __$PathDtoCopyWithImpl;
@override @useResult
$Res call({
 List<PathUnitDto> units
});




}
/// @nodoc
class __$PathDtoCopyWithImpl<$Res>
    implements _$PathDtoCopyWith<$Res> {
  __$PathDtoCopyWithImpl(this._self, this._then);

  final _PathDto _self;
  final $Res Function(_PathDto) _then;

/// Create a copy of PathDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? units = null,}) {
  return _then(_PathDto(
units: null == units ? _self._units : units // ignore: cast_nullable_to_non_nullable
as List<PathUnitDto>,
  ));
}


}


/// @nodoc
mixin _$PathUnitDto {

 String get id; int get number; String get title; String get color; int get learnedCount; int get totalCount; List<PathStopDto> get stops;
/// Create a copy of PathUnitDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PathUnitDtoCopyWith<PathUnitDto> get copyWith => _$PathUnitDtoCopyWithImpl<PathUnitDto>(this as PathUnitDto, _$identity);

  /// Serializes this PathUnitDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PathUnitDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PathUnitDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.number, _this.number) || other.number == _this.number)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.color, _this.color) || other.color == _this.color)&&(identical(other.learnedCount, _this.learnedCount) || other.learnedCount == _this.learnedCount)&&(identical(other.totalCount, _this.totalCount) || other.totalCount == _this.totalCount)&&const DeepCollectionEquality().equals(other.stops, _this.stops));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PathUnitDto;
  return Object.hash(runtimeType,_this.id,_this.number,_this.title,_this.color,_this.learnedCount,_this.totalCount,const DeepCollectionEquality().hash(_this.stops));
}

@override
String toString() {
  final _this = this as PathUnitDto;
  return 'PathUnitDto(id: ${_this.id}, number: ${_this.number}, title: ${_this.title}, color: ${_this.color}, learnedCount: ${_this.learnedCount}, totalCount: ${_this.totalCount}, stops: ${_this.stops})';
}


}

/// @nodoc
abstract mixin class $PathUnitDtoCopyWith<$Res>  {
  factory $PathUnitDtoCopyWith(PathUnitDto value, $Res Function(PathUnitDto) _then) = _$PathUnitDtoCopyWithImpl;
@useResult
$Res call({
 String id, int number, String title, String color, int learnedCount, int totalCount, List<PathStopDto> stops
});




}
/// @nodoc
class _$PathUnitDtoCopyWithImpl<$Res>
    implements $PathUnitDtoCopyWith<$Res> {
  _$PathUnitDtoCopyWithImpl(this._self, this._then);

  final PathUnitDto _self;
  final $Res Function(PathUnitDto) _then;

/// Create a copy of PathUnitDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? number = null,Object? title = null,Object? color = null,Object? learnedCount = null,Object? totalCount = null,Object? stops = null,}) {
  return _then(PathUnitDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,learnedCount: null == learnedCount ? _self.learnedCount : learnedCount // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,stops: null == stops ? _self.stops : stops // ignore: cast_nullable_to_non_nullable
as List<PathStopDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [PathUnitDto].
extension PathUnitDtoPatterns on PathUnitDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PathUnitDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PathUnitDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PathUnitDto value)  $default,){
final _that = this;
switch (_that) {
case _PathUnitDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PathUnitDto value)?  $default,){
final _that = this;
switch (_that) {
case _PathUnitDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int number,  String title,  String color,  int learnedCount,  int totalCount,  List<PathStopDto> stops)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PathUnitDto() when $default != null:
return $default(_that.id,_that.number,_that.title,_that.color,_that.learnedCount,_that.totalCount,_that.stops);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int number,  String title,  String color,  int learnedCount,  int totalCount,  List<PathStopDto> stops)  $default,) {final _that = this;
switch (_that) {
case _PathUnitDto():
return $default(_that.id,_that.number,_that.title,_that.color,_that.learnedCount,_that.totalCount,_that.stops);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int number,  String title,  String color,  int learnedCount,  int totalCount,  List<PathStopDto> stops)?  $default,) {final _that = this;
switch (_that) {
case _PathUnitDto() when $default != null:
return $default(_that.id,_that.number,_that.title,_that.color,_that.learnedCount,_that.totalCount,_that.stops);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PathUnitDto extends PathUnitDto {
  const _PathUnitDto({required this.id, required this.number, required this.title, required this.color, required this.learnedCount, required this.totalCount, required  List<PathStopDto> stops}): _stops = stops,super._();
  factory _PathUnitDto.fromJson(Map<String, dynamic> json) => _$PathUnitDtoFromJson(json);

@override final  String id;
@override final  int number;
@override final  String title;
@override final  String color;
@override final  int learnedCount;
@override final  int totalCount;
 final  List<PathStopDto> _stops;
@override List<PathStopDto> get stops {
  if (_stops is EqualUnmodifiableListView) return _stops;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stops);
}


/// Create a copy of PathUnitDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PathUnitDtoCopyWith<_PathUnitDto> get copyWith => __$PathUnitDtoCopyWithImpl<_PathUnitDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PathUnitDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PathUnitDto&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.title, title) || other.title == title)&&(identical(other.color, color) || other.color == color)&&(identical(other.learnedCount, learnedCount) || other.learnedCount == learnedCount)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&const DeepCollectionEquality().equals(other.stops, _stops));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,number,title,color,learnedCount,totalCount,const DeepCollectionEquality().hash(_stops));
}

@override
String toString() {
    return 'PathUnitDto(id: $id, number: $number, title: $title, color: $color, learnedCount: $learnedCount, totalCount: $totalCount, stops: $stops)';
}


}

/// @nodoc
abstract mixin class _$PathUnitDtoCopyWith<$Res> implements $PathUnitDtoCopyWith<$Res> {
  factory _$PathUnitDtoCopyWith(_PathUnitDto value, $Res Function(_PathUnitDto) _then) = __$PathUnitDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, int number, String title, String color, int learnedCount, int totalCount, List<PathStopDto> stops
});




}
/// @nodoc
class __$PathUnitDtoCopyWithImpl<$Res>
    implements _$PathUnitDtoCopyWith<$Res> {
  __$PathUnitDtoCopyWithImpl(this._self, this._then);

  final _PathUnitDto _self;
  final $Res Function(_PathUnitDto) _then;

/// Create a copy of PathUnitDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? number = null,Object? title = null,Object? color = null,Object? learnedCount = null,Object? totalCount = null,Object? stops = null,}) {
  return _then(_PathUnitDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,learnedCount: null == learnedCount ? _self.learnedCount : learnedCount // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,stops: null == stops ? _self._stops : stops // ignore: cast_nullable_to_non_nullable
as List<PathStopDto>,
  ));
}


}


/// @nodoc
mixin _$PathStopDto {

 String get id; String get type; String get state; String get title; LessonSummaryDto? get lesson;
/// Create a copy of PathStopDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PathStopDtoCopyWith<PathStopDto> get copyWith => _$PathStopDtoCopyWithImpl<PathStopDto>(this as PathStopDto, _$identity);

  /// Serializes this PathStopDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PathStopDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PathStopDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.lesson, _this.lesson) || other.lesson == _this.lesson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PathStopDto;
  return Object.hash(runtimeType,_this.id,_this.type,_this.state,_this.title,_this.lesson);
}

@override
String toString() {
  final _this = this as PathStopDto;
  return 'PathStopDto(id: ${_this.id}, type: ${_this.type}, state: ${_this.state}, title: ${_this.title}, lesson: ${_this.lesson})';
}


}

/// @nodoc
abstract mixin class $PathStopDtoCopyWith<$Res>  {
  factory $PathStopDtoCopyWith(PathStopDto value, $Res Function(PathStopDto) _then) = _$PathStopDtoCopyWithImpl;
@useResult
$Res call({
 String id, String type, String state, String title, LessonSummaryDto? lesson
});


$LessonSummaryDtoCopyWith<$Res>? get lesson;

}
/// @nodoc
class _$PathStopDtoCopyWithImpl<$Res>
    implements $PathStopDtoCopyWith<$Res> {
  _$PathStopDtoCopyWithImpl(this._self, this._then);

  final PathStopDto _self;
  final $Res Function(PathStopDto) _then;

/// Create a copy of PathStopDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? state = null,Object? title = null,Object? lesson = freezed,}) {
  return _then(PathStopDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,lesson: freezed == lesson ? _self.lesson : lesson // ignore: cast_nullable_to_non_nullable
as LessonSummaryDto?,
  ));
}
/// Create a copy of PathStopDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonSummaryDtoCopyWith<$Res>? get lesson {
    if (_self.lesson == null) {
    return null;
  }

  return $LessonSummaryDtoCopyWith<$Res>(_self.lesson!, (value) {
    return _then(_self.copyWith(lesson: value));
  });
}
}


/// Adds pattern-matching-related methods to [PathStopDto].
extension PathStopDtoPatterns on PathStopDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PathStopDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PathStopDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PathStopDto value)  $default,){
final _that = this;
switch (_that) {
case _PathStopDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PathStopDto value)?  $default,){
final _that = this;
switch (_that) {
case _PathStopDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type,  String state,  String title,  LessonSummaryDto? lesson)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PathStopDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type,  String state,  String title,  LessonSummaryDto? lesson)  $default,) {final _that = this;
switch (_that) {
case _PathStopDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type,  String state,  String title,  LessonSummaryDto? lesson)?  $default,) {final _that = this;
switch (_that) {
case _PathStopDto() when $default != null:
return $default(_that.id,_that.type,_that.state,_that.title,_that.lesson);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PathStopDto extends PathStopDto {
  const _PathStopDto({required this.id, required this.type, required this.state, required this.title, this.lesson}): super._();
  factory _PathStopDto.fromJson(Map<String, dynamic> json) => _$PathStopDtoFromJson(json);

@override final  String id;
@override final  String type;
@override final  String state;
@override final  String title;
@override final  LessonSummaryDto? lesson;

/// Create a copy of PathStopDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PathStopDtoCopyWith<_PathStopDto> get copyWith => __$PathStopDtoCopyWithImpl<_PathStopDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PathStopDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PathStopDto&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.state, state) || other.state == state)&&(identical(other.title, title) || other.title == title)&&(identical(other.lesson, lesson) || other.lesson == lesson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,type,state,title,lesson);
}

@override
String toString() {
    return 'PathStopDto(id: $id, type: $type, state: $state, title: $title, lesson: $lesson)';
}


}

/// @nodoc
abstract mixin class _$PathStopDtoCopyWith<$Res> implements $PathStopDtoCopyWith<$Res> {
  factory _$PathStopDtoCopyWith(_PathStopDto value, $Res Function(_PathStopDto) _then) = __$PathStopDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String type, String state, String title, LessonSummaryDto? lesson
});


@override $LessonSummaryDtoCopyWith<$Res>? get lesson;

}
/// @nodoc
class __$PathStopDtoCopyWithImpl<$Res>
    implements _$PathStopDtoCopyWith<$Res> {
  __$PathStopDtoCopyWithImpl(this._self, this._then);

  final _PathStopDto _self;
  final $Res Function(_PathStopDto) _then;

/// Create a copy of PathStopDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? state = null,Object? title = null,Object? lesson = freezed,}) {
  return _then(_PathStopDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,lesson: freezed == lesson ? _self.lesson : lesson // ignore: cast_nullable_to_non_nullable
as LessonSummaryDto?,
  ));
}

/// Create a copy of PathStopDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonSummaryDtoCopyWith<$Res>? get lesson {
    if (_self.lesson == null) {
    return null;
  }

  return $LessonSummaryDtoCopyWith<$Res>(_self.lesson!, (value) {
    return _then(_self.copyWith(lesson: value));
  });
}
}


/// @nodoc
mixin _$LessonSummaryDto {

 String get id; String get unitId; String get title; String get kind; String get state; int get signCount; int get minutes;
/// Create a copy of LessonSummaryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonSummaryDtoCopyWith<LessonSummaryDto> get copyWith => _$LessonSummaryDtoCopyWithImpl<LessonSummaryDto>(this as LessonSummaryDto, _$identity);

  /// Serializes this LessonSummaryDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LessonSummaryDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonSummaryDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.unitId, _this.unitId) || other.unitId == _this.unitId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.signCount, _this.signCount) || other.signCount == _this.signCount)&&(identical(other.minutes, _this.minutes) || other.minutes == _this.minutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LessonSummaryDto;
  return Object.hash(runtimeType,_this.id,_this.unitId,_this.title,_this.kind,_this.state,_this.signCount,_this.minutes);
}

@override
String toString() {
  final _this = this as LessonSummaryDto;
  return 'LessonSummaryDto(id: ${_this.id}, unitId: ${_this.unitId}, title: ${_this.title}, kind: ${_this.kind}, state: ${_this.state}, signCount: ${_this.signCount}, minutes: ${_this.minutes})';
}


}

/// @nodoc
abstract mixin class $LessonSummaryDtoCopyWith<$Res>  {
  factory $LessonSummaryDtoCopyWith(LessonSummaryDto value, $Res Function(LessonSummaryDto) _then) = _$LessonSummaryDtoCopyWithImpl;
@useResult
$Res call({
 String id, String unitId, String title, String kind, String state, int signCount, int minutes
});




}
/// @nodoc
class _$LessonSummaryDtoCopyWithImpl<$Res>
    implements $LessonSummaryDtoCopyWith<$Res> {
  _$LessonSummaryDtoCopyWithImpl(this._self, this._then);

  final LessonSummaryDto _self;
  final $Res Function(LessonSummaryDto) _then;

/// Create a copy of LessonSummaryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? unitId = null,Object? title = null,Object? kind = null,Object? state = null,Object? signCount = null,Object? minutes = null,}) {
  return _then(LessonSummaryDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,unitId: null == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,signCount: null == signCount ? _self.signCount : signCount // ignore: cast_nullable_to_non_nullable
as int,minutes: null == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LessonSummaryDto].
extension LessonSummaryDtoPatterns on LessonSummaryDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonSummaryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonSummaryDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonSummaryDto value)  $default,){
final _that = this;
switch (_that) {
case _LessonSummaryDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonSummaryDto value)?  $default,){
final _that = this;
switch (_that) {
case _LessonSummaryDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String unitId,  String title,  String kind,  String state,  int signCount,  int minutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonSummaryDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String unitId,  String title,  String kind,  String state,  int signCount,  int minutes)  $default,) {final _that = this;
switch (_that) {
case _LessonSummaryDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String unitId,  String title,  String kind,  String state,  int signCount,  int minutes)?  $default,) {final _that = this;
switch (_that) {
case _LessonSummaryDto() when $default != null:
return $default(_that.id,_that.unitId,_that.title,_that.kind,_that.state,_that.signCount,_that.minutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LessonSummaryDto extends LessonSummaryDto {
  const _LessonSummaryDto({required this.id, required this.unitId, required this.title, required this.kind, required this.state, required this.signCount, required this.minutes}): super._();
  factory _LessonSummaryDto.fromJson(Map<String, dynamic> json) => _$LessonSummaryDtoFromJson(json);

@override final  String id;
@override final  String unitId;
@override final  String title;
@override final  String kind;
@override final  String state;
@override final  int signCount;
@override final  int minutes;

/// Create a copy of LessonSummaryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonSummaryDtoCopyWith<_LessonSummaryDto> get copyWith => __$LessonSummaryDtoCopyWithImpl<_LessonSummaryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonSummaryDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonSummaryDto&&(identical(other.id, id) || other.id == id)&&(identical(other.unitId, unitId) || other.unitId == unitId)&&(identical(other.title, title) || other.title == title)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.state, state) || other.state == state)&&(identical(other.signCount, signCount) || other.signCount == signCount)&&(identical(other.minutes, minutes) || other.minutes == minutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,unitId,title,kind,state,signCount,minutes);
}

@override
String toString() {
    return 'LessonSummaryDto(id: $id, unitId: $unitId, title: $title, kind: $kind, state: $state, signCount: $signCount, minutes: $minutes)';
}


}

/// @nodoc
abstract mixin class _$LessonSummaryDtoCopyWith<$Res> implements $LessonSummaryDtoCopyWith<$Res> {
  factory _$LessonSummaryDtoCopyWith(_LessonSummaryDto value, $Res Function(_LessonSummaryDto) _then) = __$LessonSummaryDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String unitId, String title, String kind, String state, int signCount, int minutes
});




}
/// @nodoc
class __$LessonSummaryDtoCopyWithImpl<$Res>
    implements _$LessonSummaryDtoCopyWith<$Res> {
  __$LessonSummaryDtoCopyWithImpl(this._self, this._then);

  final _LessonSummaryDto _self;
  final $Res Function(_LessonSummaryDto) _then;

/// Create a copy of LessonSummaryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? unitId = null,Object? title = null,Object? kind = null,Object? state = null,Object? signCount = null,Object? minutes = null,}) {
  return _then(_LessonSummaryDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,unitId: null == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,signCount: null == signCount ? _self.signCount : signCount // ignore: cast_nullable_to_non_nullable
as int,minutes: null == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
