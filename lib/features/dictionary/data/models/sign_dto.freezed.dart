// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sign_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SignDto {

 String get id; String get name; String get category; String get status; String? get videoUrl; String? get meaning; List<String> get steps; String? get etiquetteTip;
/// Create a copy of SignDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignDtoCopyWith<SignDto> get copyWith => _$SignDtoCopyWithImpl<SignDto>(this as SignDto, _$identity);

  /// Serializes this SignDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SignDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.videoUrl, _this.videoUrl) || other.videoUrl == _this.videoUrl)&&(identical(other.meaning, _this.meaning) || other.meaning == _this.meaning)&&const DeepCollectionEquality().equals(other.steps, _this.steps)&&(identical(other.etiquetteTip, _this.etiquetteTip) || other.etiquetteTip == _this.etiquetteTip));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SignDto;
  return Object.hash(runtimeType,_this.id,_this.name,_this.category,_this.status,_this.videoUrl,_this.meaning,const DeepCollectionEquality().hash(_this.steps),_this.etiquetteTip);
}

@override
String toString() {
  final _this = this as SignDto;
  return 'SignDto(id: ${_this.id}, name: ${_this.name}, category: ${_this.category}, status: ${_this.status}, videoUrl: ${_this.videoUrl}, meaning: ${_this.meaning}, steps: ${_this.steps}, etiquetteTip: ${_this.etiquetteTip})';
}


}

/// @nodoc
abstract mixin class $SignDtoCopyWith<$Res>  {
  factory $SignDtoCopyWith(SignDto value, $Res Function(SignDto) _then) = _$SignDtoCopyWithImpl;
@useResult
$Res call({
 String id, String name, String category, String status, String? videoUrl, String? meaning, List<String> steps, String? etiquetteTip
});




}
/// @nodoc
class _$SignDtoCopyWithImpl<$Res>
    implements $SignDtoCopyWith<$Res> {
  _$SignDtoCopyWithImpl(this._self, this._then);

  final SignDto _self;
  final $Res Function(SignDto) _then;

/// Create a copy of SignDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? category = null,Object? status = null,Object? videoUrl = freezed,Object? meaning = freezed,Object? steps = null,Object? etiquetteTip = freezed,}) {
  return _then(SignDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,videoUrl: freezed == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String?,meaning: freezed == meaning ? _self.meaning : meaning // ignore: cast_nullable_to_non_nullable
as String?,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<String>,etiquetteTip: freezed == etiquetteTip ? _self.etiquetteTip : etiquetteTip // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SignDto].
extension SignDtoPatterns on SignDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SignDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SignDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SignDto value)  $default,){
final _that = this;
switch (_that) {
case _SignDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SignDto value)?  $default,){
final _that = this;
switch (_that) {
case _SignDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String category,  String status,  String? videoUrl,  String? meaning,  List<String> steps,  String? etiquetteTip)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SignDto() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.status,_that.videoUrl,_that.meaning,_that.steps,_that.etiquetteTip);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String category,  String status,  String? videoUrl,  String? meaning,  List<String> steps,  String? etiquetteTip)  $default,) {final _that = this;
switch (_that) {
case _SignDto():
return $default(_that.id,_that.name,_that.category,_that.status,_that.videoUrl,_that.meaning,_that.steps,_that.etiquetteTip);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String category,  String status,  String? videoUrl,  String? meaning,  List<String> steps,  String? etiquetteTip)?  $default,) {final _that = this;
switch (_that) {
case _SignDto() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.status,_that.videoUrl,_that.meaning,_that.steps,_that.etiquetteTip);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SignDto extends SignDto {
  const _SignDto({required this.id, required this.name, required this.category, required this.status, this.videoUrl, this.meaning,  List<String> steps = const [], this.etiquetteTip}): _steps = steps,super._();
  factory _SignDto.fromJson(Map<String, dynamic> json) => _$SignDtoFromJson(json);

@override final  String id;
@override final  String name;
@override final  String category;
@override final  String status;
@override final  String? videoUrl;
@override final  String? meaning;
 final  List<String> _steps;
@override@JsonKey() List<String> get steps {
  if (_steps is EqualUnmodifiableListView) return _steps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_steps);
}

@override final  String? etiquetteTip;

/// Create a copy of SignDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SignDtoCopyWith<_SignDto> get copyWith => __$SignDtoCopyWithImpl<_SignDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SignDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.status, status) || other.status == status)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl)&&(identical(other.meaning, meaning) || other.meaning == meaning)&&const DeepCollectionEquality().equals(other.steps, _steps)&&(identical(other.etiquetteTip, etiquetteTip) || other.etiquetteTip == etiquetteTip));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,category,status,videoUrl,meaning,const DeepCollectionEquality().hash(_steps),etiquetteTip);
}

@override
String toString() {
    return 'SignDto(id: $id, name: $name, category: $category, status: $status, videoUrl: $videoUrl, meaning: $meaning, steps: $steps, etiquetteTip: $etiquetteTip)';
}


}

/// @nodoc
abstract mixin class _$SignDtoCopyWith<$Res> implements $SignDtoCopyWith<$Res> {
  factory _$SignDtoCopyWith(_SignDto value, $Res Function(_SignDto) _then) = __$SignDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String category, String status, String? videoUrl, String? meaning, List<String> steps, String? etiquetteTip
});




}
/// @nodoc
class __$SignDtoCopyWithImpl<$Res>
    implements _$SignDtoCopyWith<$Res> {
  __$SignDtoCopyWithImpl(this._self, this._then);

  final _SignDto _self;
  final $Res Function(_SignDto) _then;

/// Create a copy of SignDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? category = null,Object? status = null,Object? videoUrl = freezed,Object? meaning = freezed,Object? steps = null,Object? etiquetteTip = freezed,}) {
  return _then(_SignDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,videoUrl: freezed == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String?,meaning: freezed == meaning ? _self.meaning : meaning // ignore: cast_nullable_to_non_nullable
as String?,steps: null == steps ? _self._steps : steps // ignore: cast_nullable_to_non_nullable
as List<String>,etiquetteTip: freezed == etiquetteTip ? _self.etiquetteTip : etiquetteTip // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
