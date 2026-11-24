// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_result_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SyncResponseDto {

 List<SyncResultDto> get results;
/// Create a copy of SyncResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncResponseDtoCopyWith<SyncResponseDto> get copyWith => _$SyncResponseDtoCopyWithImpl<SyncResponseDto>(this as SyncResponseDto, _$identity);

  /// Serializes this SyncResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SyncResponseDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncResponseDto&&const DeepCollectionEquality().equals(other.results, _this.results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SyncResponseDto;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.results));
}

@override
String toString() {
  final _this = this as SyncResponseDto;
  return 'SyncResponseDto(results: ${_this.results})';
}


}

/// @nodoc
abstract mixin class $SyncResponseDtoCopyWith<$Res>  {
  factory $SyncResponseDtoCopyWith(SyncResponseDto value, $Res Function(SyncResponseDto) _then) = _$SyncResponseDtoCopyWithImpl;
@useResult
$Res call({
 List<SyncResultDto> results
});




}
/// @nodoc
class _$SyncResponseDtoCopyWithImpl<$Res>
    implements $SyncResponseDtoCopyWith<$Res> {
  _$SyncResponseDtoCopyWithImpl(this._self, this._then);

  final SyncResponseDto _self;
  final $Res Function(SyncResponseDto) _then;

/// Create a copy of SyncResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? results = null,}) {
  return _then(SyncResponseDto(
results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<SyncResultDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncResponseDto].
extension SyncResponseDtoPatterns on SyncResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _SyncResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _SyncResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SyncResultDto> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncResponseDto() when $default != null:
return $default(_that.results);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SyncResultDto> results)  $default,) {final _that = this;
switch (_that) {
case _SyncResponseDto():
return $default(_that.results);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SyncResultDto> results)?  $default,) {final _that = this;
switch (_that) {
case _SyncResponseDto() when $default != null:
return $default(_that.results);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncResponseDto implements SyncResponseDto {
  const _SyncResponseDto({required  List<SyncResultDto> results}): _results = results;
  factory _SyncResponseDto.fromJson(Map<String, dynamic> json) => _$SyncResponseDtoFromJson(json);

 final  List<SyncResultDto> _results;
@override List<SyncResultDto> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of SyncResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncResponseDtoCopyWith<_SyncResponseDto> get copyWith => __$SyncResponseDtoCopyWithImpl<_SyncResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncResponseDto&&const DeepCollectionEquality().equals(other.results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_results));
}

@override
String toString() {
    return 'SyncResponseDto(results: $results)';
}


}

/// @nodoc
abstract mixin class _$SyncResponseDtoCopyWith<$Res> implements $SyncResponseDtoCopyWith<$Res> {
  factory _$SyncResponseDtoCopyWith(_SyncResponseDto value, $Res Function(_SyncResponseDto) _then) = __$SyncResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 List<SyncResultDto> results
});




}
/// @nodoc
class __$SyncResponseDtoCopyWithImpl<$Res>
    implements _$SyncResponseDtoCopyWith<$Res> {
  __$SyncResponseDtoCopyWithImpl(this._self, this._then);

  final _SyncResponseDto _self;
  final $Res Function(_SyncResponseDto) _then;

/// Create a copy of SyncResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? results = null,}) {
  return _then(_SyncResponseDto(
results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<SyncResultDto>,
  ));
}


}


/// @nodoc
mixin _$SyncResultDto {

 String get clientEventId; String get status; String? get message;/// The event's result (a `LessonResult` for `lessonComplete`), passed on
/// as JSON to the feature that owns it.
 Map<String, dynamic>? get result;
/// Create a copy of SyncResultDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncResultDtoCopyWith<SyncResultDto> get copyWith => _$SyncResultDtoCopyWithImpl<SyncResultDto>(this as SyncResultDto, _$identity);

  /// Serializes this SyncResultDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SyncResultDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncResultDto&&(identical(other.clientEventId, _this.clientEventId) || other.clientEventId == _this.clientEventId)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.message, _this.message) || other.message == _this.message)&&const DeepCollectionEquality().equals(other.result, _this.result));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SyncResultDto;
  return Object.hash(runtimeType,_this.clientEventId,_this.status,_this.message,const DeepCollectionEquality().hash(_this.result));
}

@override
String toString() {
  final _this = this as SyncResultDto;
  return 'SyncResultDto(clientEventId: ${_this.clientEventId}, status: ${_this.status}, message: ${_this.message}, result: ${_this.result})';
}


}

/// @nodoc
abstract mixin class $SyncResultDtoCopyWith<$Res>  {
  factory $SyncResultDtoCopyWith(SyncResultDto value, $Res Function(SyncResultDto) _then) = _$SyncResultDtoCopyWithImpl;
@useResult
$Res call({
 String clientEventId, String status, String? message, Map<String, dynamic>? result
});




}
/// @nodoc
class _$SyncResultDtoCopyWithImpl<$Res>
    implements $SyncResultDtoCopyWith<$Res> {
  _$SyncResultDtoCopyWithImpl(this._self, this._then);

  final SyncResultDto _self;
  final $Res Function(SyncResultDto) _then;

/// Create a copy of SyncResultDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? clientEventId = null,Object? status = null,Object? message = freezed,Object? result = freezed,}) {
  return _then(SyncResultDto(
clientEventId: null == clientEventId ? _self.clientEventId : clientEventId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncResultDto].
extension SyncResultDtoPatterns on SyncResultDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncResultDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncResultDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncResultDto value)  $default,){
final _that = this;
switch (_that) {
case _SyncResultDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncResultDto value)?  $default,){
final _that = this;
switch (_that) {
case _SyncResultDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String clientEventId,  String status,  String? message,  Map<String, dynamic>? result)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncResultDto() when $default != null:
return $default(_that.clientEventId,_that.status,_that.message,_that.result);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String clientEventId,  String status,  String? message,  Map<String, dynamic>? result)  $default,) {final _that = this;
switch (_that) {
case _SyncResultDto():
return $default(_that.clientEventId,_that.status,_that.message,_that.result);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String clientEventId,  String status,  String? message,  Map<String, dynamic>? result)?  $default,) {final _that = this;
switch (_that) {
case _SyncResultDto() when $default != null:
return $default(_that.clientEventId,_that.status,_that.message,_that.result);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncResultDto implements SyncResultDto {
  const _SyncResultDto({required this.clientEventId, required this.status, this.message,  Map<String, dynamic>? result}): _result = result;
  factory _SyncResultDto.fromJson(Map<String, dynamic> json) => _$SyncResultDtoFromJson(json);

@override final  String clientEventId;
@override final  String status;
@override final  String? message;
/// The event's result (a `LessonResult` for `lessonComplete`), passed on
/// as JSON to the feature that owns it.
 final  Map<String, dynamic>? _result;
/// The event's result (a `LessonResult` for `lessonComplete`), passed on
/// as JSON to the feature that owns it.
@override Map<String, dynamic>? get result {
  final value = _result;
  if (value == null) return null;
  if (_result is EqualUnmodifiableMapView) return _result;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of SyncResultDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncResultDtoCopyWith<_SyncResultDto> get copyWith => __$SyncResultDtoCopyWithImpl<_SyncResultDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncResultDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncResultDto&&(identical(other.clientEventId, clientEventId) || other.clientEventId == clientEventId)&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.result, _result));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,clientEventId,status,message,const DeepCollectionEquality().hash(_result));
}

@override
String toString() {
    return 'SyncResultDto(clientEventId: $clientEventId, status: $status, message: $message, result: $result)';
}


}

/// @nodoc
abstract mixin class _$SyncResultDtoCopyWith<$Res> implements $SyncResultDtoCopyWith<$Res> {
  factory _$SyncResultDtoCopyWith(_SyncResultDto value, $Res Function(_SyncResultDto) _then) = __$SyncResultDtoCopyWithImpl;
@override @useResult
$Res call({
 String clientEventId, String status, String? message, Map<String, dynamic>? result
});




}
/// @nodoc
class __$SyncResultDtoCopyWithImpl<$Res>
    implements _$SyncResultDtoCopyWith<$Res> {
  __$SyncResultDtoCopyWithImpl(this._self, this._then);

  final _SyncResultDto _self;
  final $Res Function(_SyncResultDto) _then;

/// Create a copy of SyncResultDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? clientEventId = null,Object? status = null,Object? message = freezed,Object? result = freezed,}) {
  return _then(_SyncResultDto(
clientEventId: null == clientEventId ? _self.clientEventId : clientEventId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,result: freezed == result ? _self._result : result // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
