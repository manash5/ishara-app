// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'progress_sync_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProgressSyncDto {

 List<SyncEventResultDto> get results;
/// Create a copy of ProgressSyncDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgressSyncDtoCopyWith<ProgressSyncDto> get copyWith => _$ProgressSyncDtoCopyWithImpl<ProgressSyncDto>(this as ProgressSyncDto, _$identity);

  /// Serializes this ProgressSyncDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProgressSyncDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgressSyncDto&&const DeepCollectionEquality().equals(other.results, _this.results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProgressSyncDto;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.results));
}

@override
String toString() {
  final _this = this as ProgressSyncDto;
  return 'ProgressSyncDto(results: ${_this.results})';
}


}

/// @nodoc
abstract mixin class $ProgressSyncDtoCopyWith<$Res>  {
  factory $ProgressSyncDtoCopyWith(ProgressSyncDto value, $Res Function(ProgressSyncDto) _then) = _$ProgressSyncDtoCopyWithImpl;
@useResult
$Res call({
 List<SyncEventResultDto> results
});




}
/// @nodoc
class _$ProgressSyncDtoCopyWithImpl<$Res>
    implements $ProgressSyncDtoCopyWith<$Res> {
  _$ProgressSyncDtoCopyWithImpl(this._self, this._then);

  final ProgressSyncDto _self;
  final $Res Function(ProgressSyncDto) _then;

/// Create a copy of ProgressSyncDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? results = null,}) {
  return _then(ProgressSyncDto(
results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<SyncEventResultDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProgressSyncDto].
extension ProgressSyncDtoPatterns on ProgressSyncDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgressSyncDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgressSyncDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgressSyncDto value)  $default,){
final _that = this;
switch (_that) {
case _ProgressSyncDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgressSyncDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProgressSyncDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SyncEventResultDto> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgressSyncDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SyncEventResultDto> results)  $default,) {final _that = this;
switch (_that) {
case _ProgressSyncDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SyncEventResultDto> results)?  $default,) {final _that = this;
switch (_that) {
case _ProgressSyncDto() when $default != null:
return $default(_that.results);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProgressSyncDto implements ProgressSyncDto {
  const _ProgressSyncDto({required  List<SyncEventResultDto> results}): _results = results;
  factory _ProgressSyncDto.fromJson(Map<String, dynamic> json) => _$ProgressSyncDtoFromJson(json);

 final  List<SyncEventResultDto> _results;
@override List<SyncEventResultDto> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of ProgressSyncDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgressSyncDtoCopyWith<_ProgressSyncDto> get copyWith => __$ProgressSyncDtoCopyWithImpl<_ProgressSyncDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProgressSyncDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgressSyncDto&&const DeepCollectionEquality().equals(other.results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_results));
}

@override
String toString() {
    return 'ProgressSyncDto(results: $results)';
}


}

/// @nodoc
abstract mixin class _$ProgressSyncDtoCopyWith<$Res> implements $ProgressSyncDtoCopyWith<$Res> {
  factory _$ProgressSyncDtoCopyWith(_ProgressSyncDto value, $Res Function(_ProgressSyncDto) _then) = __$ProgressSyncDtoCopyWithImpl;
@override @useResult
$Res call({
 List<SyncEventResultDto> results
});




}
/// @nodoc
class __$ProgressSyncDtoCopyWithImpl<$Res>
    implements _$ProgressSyncDtoCopyWith<$Res> {
  __$ProgressSyncDtoCopyWithImpl(this._self, this._then);

  final _ProgressSyncDto _self;
  final $Res Function(_ProgressSyncDto) _then;

/// Create a copy of ProgressSyncDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? results = null,}) {
  return _then(_ProgressSyncDto(
results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<SyncEventResultDto>,
  ));
}


}


/// @nodoc
mixin _$SyncEventResultDto {

 String get clientEventId;@JsonKey(unknownEnumValue: SyncEventStatus.unknown) SyncEventStatus get status; String? get message; LessonResultDto? get result;
/// Create a copy of SyncEventResultDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncEventResultDtoCopyWith<SyncEventResultDto> get copyWith => _$SyncEventResultDtoCopyWithImpl<SyncEventResultDto>(this as SyncEventResultDto, _$identity);

  /// Serializes this SyncEventResultDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SyncEventResultDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncEventResultDto&&(identical(other.clientEventId, _this.clientEventId) || other.clientEventId == _this.clientEventId)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.result, _this.result) || other.result == _this.result));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SyncEventResultDto;
  return Object.hash(runtimeType,_this.clientEventId,_this.status,_this.message,_this.result);
}

@override
String toString() {
  final _this = this as SyncEventResultDto;
  return 'SyncEventResultDto(clientEventId: ${_this.clientEventId}, status: ${_this.status}, message: ${_this.message}, result: ${_this.result})';
}


}

/// @nodoc
abstract mixin class $SyncEventResultDtoCopyWith<$Res>  {
  factory $SyncEventResultDtoCopyWith(SyncEventResultDto value, $Res Function(SyncEventResultDto) _then) = _$SyncEventResultDtoCopyWithImpl;
@useResult
$Res call({
 String clientEventId,@JsonKey(unknownEnumValue: SyncEventStatus.unknown) SyncEventStatus status, String? message, LessonResultDto? result
});


$LessonResultDtoCopyWith<$Res>? get result;

}
/// @nodoc
class _$SyncEventResultDtoCopyWithImpl<$Res>
    implements $SyncEventResultDtoCopyWith<$Res> {
  _$SyncEventResultDtoCopyWithImpl(this._self, this._then);

  final SyncEventResultDto _self;
  final $Res Function(SyncEventResultDto) _then;

/// Create a copy of SyncEventResultDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? clientEventId = null,Object? status = null,Object? message = freezed,Object? result = freezed,}) {
  return _then(SyncEventResultDto(
clientEventId: null == clientEventId ? _self.clientEventId : clientEventId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SyncEventStatus,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as LessonResultDto?,
  ));
}
/// Create a copy of SyncEventResultDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonResultDtoCopyWith<$Res>? get result {
    if (_self.result == null) {
    return null;
  }

  return $LessonResultDtoCopyWith<$Res>(_self.result!, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}


/// Adds pattern-matching-related methods to [SyncEventResultDto].
extension SyncEventResultDtoPatterns on SyncEventResultDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncEventResultDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncEventResultDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncEventResultDto value)  $default,){
final _that = this;
switch (_that) {
case _SyncEventResultDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncEventResultDto value)?  $default,){
final _that = this;
switch (_that) {
case _SyncEventResultDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String clientEventId, @JsonKey(unknownEnumValue: SyncEventStatus.unknown)  SyncEventStatus status,  String? message,  LessonResultDto? result)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncEventResultDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String clientEventId, @JsonKey(unknownEnumValue: SyncEventStatus.unknown)  SyncEventStatus status,  String? message,  LessonResultDto? result)  $default,) {final _that = this;
switch (_that) {
case _SyncEventResultDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String clientEventId, @JsonKey(unknownEnumValue: SyncEventStatus.unknown)  SyncEventStatus status,  String? message,  LessonResultDto? result)?  $default,) {final _that = this;
switch (_that) {
case _SyncEventResultDto() when $default != null:
return $default(_that.clientEventId,_that.status,_that.message,_that.result);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncEventResultDto implements SyncEventResultDto {
  const _SyncEventResultDto({required this.clientEventId, @JsonKey(unknownEnumValue: SyncEventStatus.unknown) required this.status, this.message, this.result});
  factory _SyncEventResultDto.fromJson(Map<String, dynamic> json) => _$SyncEventResultDtoFromJson(json);

@override final  String clientEventId;
@override@JsonKey(unknownEnumValue: SyncEventStatus.unknown) final  SyncEventStatus status;
@override final  String? message;
@override final  LessonResultDto? result;

/// Create a copy of SyncEventResultDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncEventResultDtoCopyWith<_SyncEventResultDto> get copyWith => __$SyncEventResultDtoCopyWithImpl<_SyncEventResultDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncEventResultDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncEventResultDto&&(identical(other.clientEventId, clientEventId) || other.clientEventId == clientEventId)&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.result, result) || other.result == result));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,clientEventId,status,message,result);
}

@override
String toString() {
    return 'SyncEventResultDto(clientEventId: $clientEventId, status: $status, message: $message, result: $result)';
}


}

/// @nodoc
abstract mixin class _$SyncEventResultDtoCopyWith<$Res> implements $SyncEventResultDtoCopyWith<$Res> {
  factory _$SyncEventResultDtoCopyWith(_SyncEventResultDto value, $Res Function(_SyncEventResultDto) _then) = __$SyncEventResultDtoCopyWithImpl;
@override @useResult
$Res call({
 String clientEventId,@JsonKey(unknownEnumValue: SyncEventStatus.unknown) SyncEventStatus status, String? message, LessonResultDto? result
});


@override $LessonResultDtoCopyWith<$Res>? get result;

}
/// @nodoc
class __$SyncEventResultDtoCopyWithImpl<$Res>
    implements _$SyncEventResultDtoCopyWith<$Res> {
  __$SyncEventResultDtoCopyWithImpl(this._self, this._then);

  final _SyncEventResultDto _self;
  final $Res Function(_SyncEventResultDto) _then;

/// Create a copy of SyncEventResultDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? clientEventId = null,Object? status = null,Object? message = freezed,Object? result = freezed,}) {
  return _then(_SyncEventResultDto(
clientEventId: null == clientEventId ? _self.clientEventId : clientEventId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SyncEventStatus,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as LessonResultDto?,
  ));
}

/// Create a copy of SyncEventResultDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonResultDtoCopyWith<$Res>? get result {
    if (_self.result == null) {
    return null;
  }

  return $LessonResultDtoCopyWith<$Res>(_self.result!, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}

// dart format on
