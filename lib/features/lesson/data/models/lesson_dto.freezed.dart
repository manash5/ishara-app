// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LessonDto {

 LessonSummaryDto get lesson; List<ExerciseDto> get exercises;
/// Create a copy of LessonDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonDtoCopyWith<LessonDto> get copyWith => _$LessonDtoCopyWithImpl<LessonDto>(this as LessonDto, _$identity);

  /// Serializes this LessonDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LessonDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonDto&&(identical(other.lesson, _this.lesson) || other.lesson == _this.lesson)&&const DeepCollectionEquality().equals(other.exercises, _this.exercises));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LessonDto;
  return Object.hash(runtimeType,_this.lesson,const DeepCollectionEquality().hash(_this.exercises));
}

@override
String toString() {
  final _this = this as LessonDto;
  return 'LessonDto(lesson: ${_this.lesson}, exercises: ${_this.exercises})';
}


}

/// @nodoc
abstract mixin class $LessonDtoCopyWith<$Res>  {
  factory $LessonDtoCopyWith(LessonDto value, $Res Function(LessonDto) _then) = _$LessonDtoCopyWithImpl;
@useResult
$Res call({
 LessonSummaryDto lesson, List<ExerciseDto> exercises
});


$LessonSummaryDtoCopyWith<$Res> get lesson;

}
/// @nodoc
class _$LessonDtoCopyWithImpl<$Res>
    implements $LessonDtoCopyWith<$Res> {
  _$LessonDtoCopyWithImpl(this._self, this._then);

  final LessonDto _self;
  final $Res Function(LessonDto) _then;

/// Create a copy of LessonDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lesson = null,Object? exercises = null,}) {
  return _then(LessonDto(
lesson: null == lesson ? _self.lesson : lesson // ignore: cast_nullable_to_non_nullable
as LessonSummaryDto,exercises: null == exercises ? _self.exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<ExerciseDto>,
  ));
}
/// Create a copy of LessonDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonSummaryDtoCopyWith<$Res> get lesson {
  
  return $LessonSummaryDtoCopyWith<$Res>(_self.lesson, (value) {
    return _then(_self.copyWith(lesson: value));
  });
}
}


/// Adds pattern-matching-related methods to [LessonDto].
extension LessonDtoPatterns on LessonDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonDto value)  $default,){
final _that = this;
switch (_that) {
case _LessonDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonDto value)?  $default,){
final _that = this;
switch (_that) {
case _LessonDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LessonSummaryDto lesson,  List<ExerciseDto> exercises)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonDto() when $default != null:
return $default(_that.lesson,_that.exercises);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LessonSummaryDto lesson,  List<ExerciseDto> exercises)  $default,) {final _that = this;
switch (_that) {
case _LessonDto():
return $default(_that.lesson,_that.exercises);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LessonSummaryDto lesson,  List<ExerciseDto> exercises)?  $default,) {final _that = this;
switch (_that) {
case _LessonDto() when $default != null:
return $default(_that.lesson,_that.exercises);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LessonDto extends LessonDto {
  const _LessonDto({required this.lesson, required  List<ExerciseDto> exercises}): _exercises = exercises,super._();
  factory _LessonDto.fromJson(Map<String, dynamic> json) => _$LessonDtoFromJson(json);

@override final  LessonSummaryDto lesson;
 final  List<ExerciseDto> _exercises;
@override List<ExerciseDto> get exercises {
  if (_exercises is EqualUnmodifiableListView) return _exercises;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exercises);
}


/// Create a copy of LessonDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonDtoCopyWith<_LessonDto> get copyWith => __$LessonDtoCopyWithImpl<_LessonDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonDto&&(identical(other.lesson, lesson) || other.lesson == lesson)&&const DeepCollectionEquality().equals(other.exercises, _exercises));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,lesson,const DeepCollectionEquality().hash(_exercises));
}

@override
String toString() {
    return 'LessonDto(lesson: $lesson, exercises: $exercises)';
}


}

/// @nodoc
abstract mixin class _$LessonDtoCopyWith<$Res> implements $LessonDtoCopyWith<$Res> {
  factory _$LessonDtoCopyWith(_LessonDto value, $Res Function(_LessonDto) _then) = __$LessonDtoCopyWithImpl;
@override @useResult
$Res call({
 LessonSummaryDto lesson, List<ExerciseDto> exercises
});


@override $LessonSummaryDtoCopyWith<$Res> get lesson;

}
/// @nodoc
class __$LessonDtoCopyWithImpl<$Res>
    implements _$LessonDtoCopyWith<$Res> {
  __$LessonDtoCopyWithImpl(this._self, this._then);

  final _LessonDto _self;
  final $Res Function(_LessonDto) _then;

/// Create a copy of LessonDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lesson = null,Object? exercises = null,}) {
  return _then(_LessonDto(
lesson: null == lesson ? _self.lesson : lesson // ignore: cast_nullable_to_non_nullable
as LessonSummaryDto,exercises: null == exercises ? _self._exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<ExerciseDto>,
  ));
}

/// Create a copy of LessonDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonSummaryDtoCopyWith<$Res> get lesson {
  
  return $LessonSummaryDtoCopyWith<$Res>(_self.lesson, (value) {
    return _then(_self.copyWith(lesson: value));
  });
}
}

ExerciseDto _$ExerciseDtoFromJson(
  Map<String, dynamic> json
) {
        switch (json['type']) {
                  case 'watch':
          return WatchExerciseDto.fromJson(
            json
          );
                case 'recognise':
          return RecogniseExerciseDto.fromJson(
            json
          );
                case 'pickSign':
          return PickSignExerciseDto.fromJson(
            json
          );
                case 'matchPairs':
          return MatchPairsExerciseDto.fromJson(
            json
          );
                case 'signIt':
          return SignItExerciseDto.fromJson(
            json
          );
                case 'fingerspell':
          return FingerspellExerciseDto.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'type',
  'ExerciseDto',
  'Invalid union type "${json['type']}"!'
);
        }
      
}

/// @nodoc
mixin _$ExerciseDto {

 String get signId;
/// Create a copy of ExerciseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseDtoCopyWith<ExerciseDto> get copyWith => _$ExerciseDtoCopyWithImpl<ExerciseDto>(this as ExerciseDto, _$identity);

  /// Serializes this ExerciseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ExerciseDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseDto&&(identical(other.signId, _this.signId) || other.signId == _this.signId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ExerciseDto;
  return Object.hash(runtimeType,_this.signId);
}

@override
String toString() {
  final _this = this as ExerciseDto;
  return 'ExerciseDto(signId: ${_this.signId})';
}


}

/// @nodoc
abstract mixin class $ExerciseDtoCopyWith<$Res>  {
  factory $ExerciseDtoCopyWith(ExerciseDto value, $Res Function(ExerciseDto) _then) = _$ExerciseDtoCopyWithImpl;
@useResult
$Res call({
 String signId
});




}
/// @nodoc
class _$ExerciseDtoCopyWithImpl<$Res>
    implements $ExerciseDtoCopyWith<$Res> {
  _$ExerciseDtoCopyWithImpl(this._self, this._then);

  final ExerciseDto _self;
  final $Res Function(ExerciseDto) _then;

/// Create a copy of ExerciseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? signId = null,}) {
  return _then(_self.copyWith(
signId: null == signId ? _self.signId : signId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ExerciseDto].
extension ExerciseDtoPatterns on ExerciseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( WatchExerciseDto value)?  watch,TResult Function( RecogniseExerciseDto value)?  recognise,TResult Function( PickSignExerciseDto value)?  pickSign,TResult Function( MatchPairsExerciseDto value)?  matchPairs,TResult Function( SignItExerciseDto value)?  signIt,TResult Function( FingerspellExerciseDto value)?  fingerspell,required TResult orElse(),}){
final _that = this;
switch (_that) {
case WatchExerciseDto() when watch != null:
return watch(_that);case RecogniseExerciseDto() when recognise != null:
return recognise(_that);case PickSignExerciseDto() when pickSign != null:
return pickSign(_that);case MatchPairsExerciseDto() when matchPairs != null:
return matchPairs(_that);case SignItExerciseDto() when signIt != null:
return signIt(_that);case FingerspellExerciseDto() when fingerspell != null:
return fingerspell(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( WatchExerciseDto value)  watch,required TResult Function( RecogniseExerciseDto value)  recognise,required TResult Function( PickSignExerciseDto value)  pickSign,required TResult Function( MatchPairsExerciseDto value)  matchPairs,required TResult Function( SignItExerciseDto value)  signIt,required TResult Function( FingerspellExerciseDto value)  fingerspell,}){
final _that = this;
switch (_that) {
case WatchExerciseDto():
return watch(_that);case RecogniseExerciseDto():
return recognise(_that);case PickSignExerciseDto():
return pickSign(_that);case MatchPairsExerciseDto():
return matchPairs(_that);case SignItExerciseDto():
return signIt(_that);case FingerspellExerciseDto():
return fingerspell(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( WatchExerciseDto value)?  watch,TResult? Function( RecogniseExerciseDto value)?  recognise,TResult? Function( PickSignExerciseDto value)?  pickSign,TResult? Function( MatchPairsExerciseDto value)?  matchPairs,TResult? Function( SignItExerciseDto value)?  signIt,TResult? Function( FingerspellExerciseDto value)?  fingerspell,}){
final _that = this;
switch (_that) {
case WatchExerciseDto() when watch != null:
return watch(_that);case RecogniseExerciseDto() when recognise != null:
return recognise(_that);case PickSignExerciseDto() when pickSign != null:
return pickSign(_that);case MatchPairsExerciseDto() when matchPairs != null:
return matchPairs(_that);case SignItExerciseDto() when signIt != null:
return signIt(_that);case FingerspellExerciseDto() when fingerspell != null:
return fingerspell(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String signId,  String title,  String description,  String tip,  bool verified)?  watch,TResult Function( String signId,  List<String> options,  int answerIndex)?  recognise,TResult Function( String signId,  String meaning,  int answerIndex,  int optionCount)?  pickSign,TResult Function( String signId,  List<String> words,  List<int> videoOrder)?  matchPairs,TResult Function( String signId,  String title,  String almostChip,  String almostHint,  ExerciseDto fallback,  bool verified)?  signIt,TResult Function( String signId,  List<String> letters,  String meaning,  ExerciseDto fallback)?  fingerspell,required TResult orElse(),}) {final _that = this;
switch (_that) {
case WatchExerciseDto() when watch != null:
return watch(_that.signId,_that.title,_that.description,_that.tip,_that.verified);case RecogniseExerciseDto() when recognise != null:
return recognise(_that.signId,_that.options,_that.answerIndex);case PickSignExerciseDto() when pickSign != null:
return pickSign(_that.signId,_that.meaning,_that.answerIndex,_that.optionCount);case MatchPairsExerciseDto() when matchPairs != null:
return matchPairs(_that.signId,_that.words,_that.videoOrder);case SignItExerciseDto() when signIt != null:
return signIt(_that.signId,_that.title,_that.almostChip,_that.almostHint,_that.fallback,_that.verified);case FingerspellExerciseDto() when fingerspell != null:
return fingerspell(_that.signId,_that.letters,_that.meaning,_that.fallback);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String signId,  String title,  String description,  String tip,  bool verified)  watch,required TResult Function( String signId,  List<String> options,  int answerIndex)  recognise,required TResult Function( String signId,  String meaning,  int answerIndex,  int optionCount)  pickSign,required TResult Function( String signId,  List<String> words,  List<int> videoOrder)  matchPairs,required TResult Function( String signId,  String title,  String almostChip,  String almostHint,  ExerciseDto fallback,  bool verified)  signIt,required TResult Function( String signId,  List<String> letters,  String meaning,  ExerciseDto fallback)  fingerspell,}) {final _that = this;
switch (_that) {
case WatchExerciseDto():
return watch(_that.signId,_that.title,_that.description,_that.tip,_that.verified);case RecogniseExerciseDto():
return recognise(_that.signId,_that.options,_that.answerIndex);case PickSignExerciseDto():
return pickSign(_that.signId,_that.meaning,_that.answerIndex,_that.optionCount);case MatchPairsExerciseDto():
return matchPairs(_that.signId,_that.words,_that.videoOrder);case SignItExerciseDto():
return signIt(_that.signId,_that.title,_that.almostChip,_that.almostHint,_that.fallback,_that.verified);case FingerspellExerciseDto():
return fingerspell(_that.signId,_that.letters,_that.meaning,_that.fallback);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String signId,  String title,  String description,  String tip,  bool verified)?  watch,TResult? Function( String signId,  List<String> options,  int answerIndex)?  recognise,TResult? Function( String signId,  String meaning,  int answerIndex,  int optionCount)?  pickSign,TResult? Function( String signId,  List<String> words,  List<int> videoOrder)?  matchPairs,TResult? Function( String signId,  String title,  String almostChip,  String almostHint,  ExerciseDto fallback,  bool verified)?  signIt,TResult? Function( String signId,  List<String> letters,  String meaning,  ExerciseDto fallback)?  fingerspell,}) {final _that = this;
switch (_that) {
case WatchExerciseDto() when watch != null:
return watch(_that.signId,_that.title,_that.description,_that.tip,_that.verified);case RecogniseExerciseDto() when recognise != null:
return recognise(_that.signId,_that.options,_that.answerIndex);case PickSignExerciseDto() when pickSign != null:
return pickSign(_that.signId,_that.meaning,_that.answerIndex,_that.optionCount);case MatchPairsExerciseDto() when matchPairs != null:
return matchPairs(_that.signId,_that.words,_that.videoOrder);case SignItExerciseDto() when signIt != null:
return signIt(_that.signId,_that.title,_that.almostChip,_that.almostHint,_that.fallback,_that.verified);case FingerspellExerciseDto() when fingerspell != null:
return fingerspell(_that.signId,_that.letters,_that.meaning,_that.fallback);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class WatchExerciseDto extends ExerciseDto {
  const WatchExerciseDto({required this.signId, required this.title, required this.description, required this.tip, this.verified = false,  String? $type}): $type = $type ?? 'watch',super._();
  factory WatchExerciseDto.fromJson(Map<String, dynamic> json) => _$WatchExerciseDtoFromJson(json);

@override final  String signId;
 final  String title;
 final  String description;
 final  String tip;
@JsonKey() final  bool verified;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of ExerciseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchExerciseDtoCopyWith<WatchExerciseDto> get copyWith => _$WatchExerciseDtoCopyWithImpl<WatchExerciseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WatchExerciseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchExerciseDto&&(identical(other.signId, signId) || other.signId == signId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.tip, tip) || other.tip == tip)&&(identical(other.verified, verified) || other.verified == verified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,signId,title,description,tip,verified);
}

@override
String toString() {
    return 'ExerciseDto.watch(signId: $signId, title: $title, description: $description, tip: $tip, verified: $verified)';
}


}

/// @nodoc
abstract mixin class $WatchExerciseDtoCopyWith<$Res> implements $ExerciseDtoCopyWith<$Res> {
  factory $WatchExerciseDtoCopyWith(WatchExerciseDto value, $Res Function(WatchExerciseDto) _then) = _$WatchExerciseDtoCopyWithImpl;
@override @useResult
$Res call({
 String signId, String title, String description, String tip, bool verified
});




}
/// @nodoc
class _$WatchExerciseDtoCopyWithImpl<$Res>
    implements $WatchExerciseDtoCopyWith<$Res> {
  _$WatchExerciseDtoCopyWithImpl(this._self, this._then);

  final WatchExerciseDto _self;
  final $Res Function(WatchExerciseDto) _then;

/// Create a copy of ExerciseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? signId = null,Object? title = null,Object? description = null,Object? tip = null,Object? verified = null,}) {
  return _then(WatchExerciseDto(
signId: null == signId ? _self.signId : signId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,tip: null == tip ? _self.tip : tip // ignore: cast_nullable_to_non_nullable
as String,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
@JsonSerializable()

class RecogniseExerciseDto extends ExerciseDto {
  const RecogniseExerciseDto({required this.signId, required  List<String> options, required this.answerIndex,  String? $type}): _options = options,$type = $type ?? 'recognise',super._();
  factory RecogniseExerciseDto.fromJson(Map<String, dynamic> json) => _$RecogniseExerciseDtoFromJson(json);

@override final  String signId;
 final  List<String> _options;
 List<String> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

 final  int answerIndex;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of ExerciseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecogniseExerciseDtoCopyWith<RecogniseExerciseDto> get copyWith => _$RecogniseExerciseDtoCopyWithImpl<RecogniseExerciseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecogniseExerciseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RecogniseExerciseDto&&(identical(other.signId, signId) || other.signId == signId)&&const DeepCollectionEquality().equals(other.options, _options)&&(identical(other.answerIndex, answerIndex) || other.answerIndex == answerIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,signId,const DeepCollectionEquality().hash(_options),answerIndex);
}

@override
String toString() {
    return 'ExerciseDto.recognise(signId: $signId, options: $options, answerIndex: $answerIndex)';
}


}

/// @nodoc
abstract mixin class $RecogniseExerciseDtoCopyWith<$Res> implements $ExerciseDtoCopyWith<$Res> {
  factory $RecogniseExerciseDtoCopyWith(RecogniseExerciseDto value, $Res Function(RecogniseExerciseDto) _then) = _$RecogniseExerciseDtoCopyWithImpl;
@override @useResult
$Res call({
 String signId, List<String> options, int answerIndex
});




}
/// @nodoc
class _$RecogniseExerciseDtoCopyWithImpl<$Res>
    implements $RecogniseExerciseDtoCopyWith<$Res> {
  _$RecogniseExerciseDtoCopyWithImpl(this._self, this._then);

  final RecogniseExerciseDto _self;
  final $Res Function(RecogniseExerciseDto) _then;

/// Create a copy of ExerciseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? signId = null,Object? options = null,Object? answerIndex = null,}) {
  return _then(RecogniseExerciseDto(
signId: null == signId ? _self.signId : signId // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>,answerIndex: null == answerIndex ? _self.answerIndex : answerIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class PickSignExerciseDto extends ExerciseDto {
  const PickSignExerciseDto({required this.signId, required this.meaning, required this.answerIndex, this.optionCount = 4,  String? $type}): $type = $type ?? 'pickSign',super._();
  factory PickSignExerciseDto.fromJson(Map<String, dynamic> json) => _$PickSignExerciseDtoFromJson(json);

@override final  String signId;
 final  String meaning;
 final  int answerIndex;
@JsonKey() final  int optionCount;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of ExerciseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PickSignExerciseDtoCopyWith<PickSignExerciseDto> get copyWith => _$PickSignExerciseDtoCopyWithImpl<PickSignExerciseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PickSignExerciseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PickSignExerciseDto&&(identical(other.signId, signId) || other.signId == signId)&&(identical(other.meaning, meaning) || other.meaning == meaning)&&(identical(other.answerIndex, answerIndex) || other.answerIndex == answerIndex)&&(identical(other.optionCount, optionCount) || other.optionCount == optionCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,signId,meaning,answerIndex,optionCount);
}

@override
String toString() {
    return 'ExerciseDto.pickSign(signId: $signId, meaning: $meaning, answerIndex: $answerIndex, optionCount: $optionCount)';
}


}

/// @nodoc
abstract mixin class $PickSignExerciseDtoCopyWith<$Res> implements $ExerciseDtoCopyWith<$Res> {
  factory $PickSignExerciseDtoCopyWith(PickSignExerciseDto value, $Res Function(PickSignExerciseDto) _then) = _$PickSignExerciseDtoCopyWithImpl;
@override @useResult
$Res call({
 String signId, String meaning, int answerIndex, int optionCount
});




}
/// @nodoc
class _$PickSignExerciseDtoCopyWithImpl<$Res>
    implements $PickSignExerciseDtoCopyWith<$Res> {
  _$PickSignExerciseDtoCopyWithImpl(this._self, this._then);

  final PickSignExerciseDto _self;
  final $Res Function(PickSignExerciseDto) _then;

/// Create a copy of ExerciseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? signId = null,Object? meaning = null,Object? answerIndex = null,Object? optionCount = null,}) {
  return _then(PickSignExerciseDto(
signId: null == signId ? _self.signId : signId // ignore: cast_nullable_to_non_nullable
as String,meaning: null == meaning ? _self.meaning : meaning // ignore: cast_nullable_to_non_nullable
as String,answerIndex: null == answerIndex ? _self.answerIndex : answerIndex // ignore: cast_nullable_to_non_nullable
as int,optionCount: null == optionCount ? _self.optionCount : optionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class MatchPairsExerciseDto extends ExerciseDto {
  const MatchPairsExerciseDto({required this.signId, required  List<String> words, required  List<int> videoOrder,  String? $type}): _words = words,_videoOrder = videoOrder,$type = $type ?? 'matchPairs',super._();
  factory MatchPairsExerciseDto.fromJson(Map<String, dynamic> json) => _$MatchPairsExerciseDtoFromJson(json);

@override final  String signId;
 final  List<String> _words;
 List<String> get words {
  if (_words is EqualUnmodifiableListView) return _words;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_words);
}

 final  List<int> _videoOrder;
 List<int> get videoOrder {
  if (_videoOrder is EqualUnmodifiableListView) return _videoOrder;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_videoOrder);
}


@JsonKey(name: 'type')
final String $type;


/// Create a copy of ExerciseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchPairsExerciseDtoCopyWith<MatchPairsExerciseDto> get copyWith => _$MatchPairsExerciseDtoCopyWithImpl<MatchPairsExerciseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MatchPairsExerciseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchPairsExerciseDto&&(identical(other.signId, signId) || other.signId == signId)&&const DeepCollectionEquality().equals(other.words, _words)&&const DeepCollectionEquality().equals(other.videoOrder, _videoOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,signId,const DeepCollectionEquality().hash(_words),const DeepCollectionEquality().hash(_videoOrder));
}

@override
String toString() {
    return 'ExerciseDto.matchPairs(signId: $signId, words: $words, videoOrder: $videoOrder)';
}


}

/// @nodoc
abstract mixin class $MatchPairsExerciseDtoCopyWith<$Res> implements $ExerciseDtoCopyWith<$Res> {
  factory $MatchPairsExerciseDtoCopyWith(MatchPairsExerciseDto value, $Res Function(MatchPairsExerciseDto) _then) = _$MatchPairsExerciseDtoCopyWithImpl;
@override @useResult
$Res call({
 String signId, List<String> words, List<int> videoOrder
});




}
/// @nodoc
class _$MatchPairsExerciseDtoCopyWithImpl<$Res>
    implements $MatchPairsExerciseDtoCopyWith<$Res> {
  _$MatchPairsExerciseDtoCopyWithImpl(this._self, this._then);

  final MatchPairsExerciseDto _self;
  final $Res Function(MatchPairsExerciseDto) _then;

/// Create a copy of ExerciseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? signId = null,Object? words = null,Object? videoOrder = null,}) {
  return _then(MatchPairsExerciseDto(
signId: null == signId ? _self.signId : signId // ignore: cast_nullable_to_non_nullable
as String,words: null == words ? _self._words : words // ignore: cast_nullable_to_non_nullable
as List<String>,videoOrder: null == videoOrder ? _self._videoOrder : videoOrder // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class SignItExerciseDto extends ExerciseDto {
  const SignItExerciseDto({required this.signId, required this.title, required this.almostChip, required this.almostHint, required this.fallback, this.verified = false,  String? $type}): $type = $type ?? 'signIt',super._();
  factory SignItExerciseDto.fromJson(Map<String, dynamic> json) => _$SignItExerciseDtoFromJson(json);

@override final  String signId;
 final  String title;
 final  String almostChip;
 final  String almostHint;
 final  ExerciseDto fallback;
@JsonKey() final  bool verified;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of ExerciseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignItExerciseDtoCopyWith<SignItExerciseDto> get copyWith => _$SignItExerciseDtoCopyWithImpl<SignItExerciseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SignItExerciseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SignItExerciseDto&&(identical(other.signId, signId) || other.signId == signId)&&(identical(other.title, title) || other.title == title)&&(identical(other.almostChip, almostChip) || other.almostChip == almostChip)&&(identical(other.almostHint, almostHint) || other.almostHint == almostHint)&&(identical(other.fallback, fallback) || other.fallback == fallback)&&(identical(other.verified, verified) || other.verified == verified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,signId,title,almostChip,almostHint,fallback,verified);
}

@override
String toString() {
    return 'ExerciseDto.signIt(signId: $signId, title: $title, almostChip: $almostChip, almostHint: $almostHint, fallback: $fallback, verified: $verified)';
}


}

/// @nodoc
abstract mixin class $SignItExerciseDtoCopyWith<$Res> implements $ExerciseDtoCopyWith<$Res> {
  factory $SignItExerciseDtoCopyWith(SignItExerciseDto value, $Res Function(SignItExerciseDto) _then) = _$SignItExerciseDtoCopyWithImpl;
@override @useResult
$Res call({
 String signId, String title, String almostChip, String almostHint, ExerciseDto fallback, bool verified
});


$ExerciseDtoCopyWith<$Res> get fallback;

}
/// @nodoc
class _$SignItExerciseDtoCopyWithImpl<$Res>
    implements $SignItExerciseDtoCopyWith<$Res> {
  _$SignItExerciseDtoCopyWithImpl(this._self, this._then);

  final SignItExerciseDto _self;
  final $Res Function(SignItExerciseDto) _then;

/// Create a copy of ExerciseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? signId = null,Object? title = null,Object? almostChip = null,Object? almostHint = null,Object? fallback = null,Object? verified = null,}) {
  return _then(SignItExerciseDto(
signId: null == signId ? _self.signId : signId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,almostChip: null == almostChip ? _self.almostChip : almostChip // ignore: cast_nullable_to_non_nullable
as String,almostHint: null == almostHint ? _self.almostHint : almostHint // ignore: cast_nullable_to_non_nullable
as String,fallback: null == fallback ? _self.fallback : fallback // ignore: cast_nullable_to_non_nullable
as ExerciseDto,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of ExerciseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExerciseDtoCopyWith<$Res> get fallback {
  
  return $ExerciseDtoCopyWith<$Res>(_self.fallback, (value) {
    return _then(_self.copyWith(fallback: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class FingerspellExerciseDto extends ExerciseDto {
  const FingerspellExerciseDto({required this.signId, required  List<String> letters, required this.meaning, required this.fallback,  String? $type}): _letters = letters,$type = $type ?? 'fingerspell',super._();
  factory FingerspellExerciseDto.fromJson(Map<String, dynamic> json) => _$FingerspellExerciseDtoFromJson(json);

@override final  String signId;
 final  List<String> _letters;
 List<String> get letters {
  if (_letters is EqualUnmodifiableListView) return _letters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_letters);
}

 final  String meaning;
 final  ExerciseDto fallback;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of ExerciseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FingerspellExerciseDtoCopyWith<FingerspellExerciseDto> get copyWith => _$FingerspellExerciseDtoCopyWithImpl<FingerspellExerciseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FingerspellExerciseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is FingerspellExerciseDto&&(identical(other.signId, signId) || other.signId == signId)&&const DeepCollectionEquality().equals(other.letters, _letters)&&(identical(other.meaning, meaning) || other.meaning == meaning)&&(identical(other.fallback, fallback) || other.fallback == fallback));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,signId,const DeepCollectionEquality().hash(_letters),meaning,fallback);
}

@override
String toString() {
    return 'ExerciseDto.fingerspell(signId: $signId, letters: $letters, meaning: $meaning, fallback: $fallback)';
}


}

/// @nodoc
abstract mixin class $FingerspellExerciseDtoCopyWith<$Res> implements $ExerciseDtoCopyWith<$Res> {
  factory $FingerspellExerciseDtoCopyWith(FingerspellExerciseDto value, $Res Function(FingerspellExerciseDto) _then) = _$FingerspellExerciseDtoCopyWithImpl;
@override @useResult
$Res call({
 String signId, List<String> letters, String meaning, ExerciseDto fallback
});


$ExerciseDtoCopyWith<$Res> get fallback;

}
/// @nodoc
class _$FingerspellExerciseDtoCopyWithImpl<$Res>
    implements $FingerspellExerciseDtoCopyWith<$Res> {
  _$FingerspellExerciseDtoCopyWithImpl(this._self, this._then);

  final FingerspellExerciseDto _self;
  final $Res Function(FingerspellExerciseDto) _then;

/// Create a copy of ExerciseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? signId = null,Object? letters = null,Object? meaning = null,Object? fallback = null,}) {
  return _then(FingerspellExerciseDto(
signId: null == signId ? _self.signId : signId // ignore: cast_nullable_to_non_nullable
as String,letters: null == letters ? _self._letters : letters // ignore: cast_nullable_to_non_nullable
as List<String>,meaning: null == meaning ? _self.meaning : meaning // ignore: cast_nullable_to_non_nullable
as String,fallback: null == fallback ? _self.fallback : fallback // ignore: cast_nullable_to_non_nullable
as ExerciseDto,
  ));
}

/// Create a copy of ExerciseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExerciseDtoCopyWith<$Res> get fallback {
  
  return $ExerciseDtoCopyWith<$Res>(_self.fallback, (value) {
    return _then(_self.copyWith(fallback: value));
  });
}
}

// dart format on
