// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserProfileDto {

 String get id; String get email; String get displayName; String? get avatarUrl; DateTime get joinedAt; bool get onboardingDone; int get dailyGoalMinutes; String get dominantHand; String get timezone; UserStatsDto get stats;
/// Create a copy of UserProfileDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileDtoCopyWith<UserProfileDto> get copyWith => _$UserProfileDtoCopyWithImpl<UserProfileDto>(this as UserProfileDto, _$identity);

  /// Serializes this UserProfileDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UserProfileDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfileDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.avatarUrl, _this.avatarUrl) || other.avatarUrl == _this.avatarUrl)&&(identical(other.joinedAt, _this.joinedAt) || other.joinedAt == _this.joinedAt)&&(identical(other.onboardingDone, _this.onboardingDone) || other.onboardingDone == _this.onboardingDone)&&(identical(other.dailyGoalMinutes, _this.dailyGoalMinutes) || other.dailyGoalMinutes == _this.dailyGoalMinutes)&&(identical(other.dominantHand, _this.dominantHand) || other.dominantHand == _this.dominantHand)&&(identical(other.timezone, _this.timezone) || other.timezone == _this.timezone)&&(identical(other.stats, _this.stats) || other.stats == _this.stats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UserProfileDto;
  return Object.hash(runtimeType,_this.id,_this.email,_this.displayName,_this.avatarUrl,_this.joinedAt,_this.onboardingDone,_this.dailyGoalMinutes,_this.dominantHand,_this.timezone,_this.stats);
}

@override
String toString() {
  final _this = this as UserProfileDto;
  return 'UserProfileDto(id: ${_this.id}, email: ${_this.email}, displayName: ${_this.displayName}, avatarUrl: ${_this.avatarUrl}, joinedAt: ${_this.joinedAt}, onboardingDone: ${_this.onboardingDone}, dailyGoalMinutes: ${_this.dailyGoalMinutes}, dominantHand: ${_this.dominantHand}, timezone: ${_this.timezone}, stats: ${_this.stats})';
}


}

/// @nodoc
abstract mixin class $UserProfileDtoCopyWith<$Res>  {
  factory $UserProfileDtoCopyWith(UserProfileDto value, $Res Function(UserProfileDto) _then) = _$UserProfileDtoCopyWithImpl;
@useResult
$Res call({
 String id, String email, String displayName, String? avatarUrl, DateTime joinedAt, bool onboardingDone, int dailyGoalMinutes, String dominantHand, String timezone, UserStatsDto stats
});


$UserStatsDtoCopyWith<$Res> get stats;

}
/// @nodoc
class _$UserProfileDtoCopyWithImpl<$Res>
    implements $UserProfileDtoCopyWith<$Res> {
  _$UserProfileDtoCopyWithImpl(this._self, this._then);

  final UserProfileDto _self;
  final $Res Function(UserProfileDto) _then;

/// Create a copy of UserProfileDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? displayName = null,Object? avatarUrl = freezed,Object? joinedAt = null,Object? onboardingDone = null,Object? dailyGoalMinutes = null,Object? dominantHand = null,Object? timezone = null,Object? stats = null,}) {
  return _then(UserProfileDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,onboardingDone: null == onboardingDone ? _self.onboardingDone : onboardingDone // ignore: cast_nullable_to_non_nullable
as bool,dailyGoalMinutes: null == dailyGoalMinutes ? _self.dailyGoalMinutes : dailyGoalMinutes // ignore: cast_nullable_to_non_nullable
as int,dominantHand: null == dominantHand ? _self.dominantHand : dominantHand // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as UserStatsDto,
  ));
}
/// Create a copy of UserProfileDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserStatsDtoCopyWith<$Res> get stats {
  
  return $UserStatsDtoCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserProfileDto].
extension UserProfileDtoPatterns on UserProfileDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfileDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfileDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfileDto value)  $default,){
final _that = this;
switch (_that) {
case _UserProfileDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfileDto value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfileDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String displayName,  String? avatarUrl,  DateTime joinedAt,  bool onboardingDone,  int dailyGoalMinutes,  String dominantHand,  String timezone,  UserStatsDto stats)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfileDto() when $default != null:
return $default(_that.id,_that.email,_that.displayName,_that.avatarUrl,_that.joinedAt,_that.onboardingDone,_that.dailyGoalMinutes,_that.dominantHand,_that.timezone,_that.stats);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String displayName,  String? avatarUrl,  DateTime joinedAt,  bool onboardingDone,  int dailyGoalMinutes,  String dominantHand,  String timezone,  UserStatsDto stats)  $default,) {final _that = this;
switch (_that) {
case _UserProfileDto():
return $default(_that.id,_that.email,_that.displayName,_that.avatarUrl,_that.joinedAt,_that.onboardingDone,_that.dailyGoalMinutes,_that.dominantHand,_that.timezone,_that.stats);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String displayName,  String? avatarUrl,  DateTime joinedAt,  bool onboardingDone,  int dailyGoalMinutes,  String dominantHand,  String timezone,  UserStatsDto stats)?  $default,) {final _that = this;
switch (_that) {
case _UserProfileDto() when $default != null:
return $default(_that.id,_that.email,_that.displayName,_that.avatarUrl,_that.joinedAt,_that.onboardingDone,_that.dailyGoalMinutes,_that.dominantHand,_that.timezone,_that.stats);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserProfileDto extends UserProfileDto {
  const _UserProfileDto({required this.id, required this.email, required this.displayName, this.avatarUrl, required this.joinedAt, required this.onboardingDone, required this.dailyGoalMinutes, required this.dominantHand, required this.timezone, required this.stats}): super._();
  factory _UserProfileDto.fromJson(Map<String, dynamic> json) => _$UserProfileDtoFromJson(json);

@override final  String id;
@override final  String email;
@override final  String displayName;
@override final  String? avatarUrl;
@override final  DateTime joinedAt;
@override final  bool onboardingDone;
@override final  int dailyGoalMinutes;
@override final  String dominantHand;
@override final  String timezone;
@override final  UserStatsDto stats;

/// Create a copy of UserProfileDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileDtoCopyWith<_UserProfileDto> get copyWith => __$UserProfileDtoCopyWithImpl<_UserProfileDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserProfileDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfileDto&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.onboardingDone, onboardingDone) || other.onboardingDone == onboardingDone)&&(identical(other.dailyGoalMinutes, dailyGoalMinutes) || other.dailyGoalMinutes == dailyGoalMinutes)&&(identical(other.dominantHand, dominantHand) || other.dominantHand == dominantHand)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.stats, stats) || other.stats == stats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,email,displayName,avatarUrl,joinedAt,onboardingDone,dailyGoalMinutes,dominantHand,timezone,stats);
}

@override
String toString() {
    return 'UserProfileDto(id: $id, email: $email, displayName: $displayName, avatarUrl: $avatarUrl, joinedAt: $joinedAt, onboardingDone: $onboardingDone, dailyGoalMinutes: $dailyGoalMinutes, dominantHand: $dominantHand, timezone: $timezone, stats: $stats)';
}


}

/// @nodoc
abstract mixin class _$UserProfileDtoCopyWith<$Res> implements $UserProfileDtoCopyWith<$Res> {
  factory _$UserProfileDtoCopyWith(_UserProfileDto value, $Res Function(_UserProfileDto) _then) = __$UserProfileDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String displayName, String? avatarUrl, DateTime joinedAt, bool onboardingDone, int dailyGoalMinutes, String dominantHand, String timezone, UserStatsDto stats
});


@override $UserStatsDtoCopyWith<$Res> get stats;

}
/// @nodoc
class __$UserProfileDtoCopyWithImpl<$Res>
    implements _$UserProfileDtoCopyWith<$Res> {
  __$UserProfileDtoCopyWithImpl(this._self, this._then);

  final _UserProfileDto _self;
  final $Res Function(_UserProfileDto) _then;

/// Create a copy of UserProfileDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? displayName = null,Object? avatarUrl = freezed,Object? joinedAt = null,Object? onboardingDone = null,Object? dailyGoalMinutes = null,Object? dominantHand = null,Object? timezone = null,Object? stats = null,}) {
  return _then(_UserProfileDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,onboardingDone: null == onboardingDone ? _self.onboardingDone : onboardingDone // ignore: cast_nullable_to_non_nullable
as bool,dailyGoalMinutes: null == dailyGoalMinutes ? _self.dailyGoalMinutes : dailyGoalMinutes // ignore: cast_nullable_to_non_nullable
as int,dominantHand: null == dominantHand ? _self.dominantHand : dominantHand // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as UserStatsDto,
  ));
}

/// Create a copy of UserProfileDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserStatsDtoCopyWith<$Res> get stats {
  
  return $UserStatsDtoCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}


/// @nodoc
mixin _$UserStatsDto {

 int get totalXp; int get weeklyXp; int get streakDays; int get longestStreakDays; int get streakFreezes; int get hearts; int get maxHearts; DateTime? get heartsRefillAt; int get signsLearned; double get cameraAccuracy; DateTime get weekStart; List<int> get weekXp; int get todayIndex;
/// Create a copy of UserStatsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserStatsDtoCopyWith<UserStatsDto> get copyWith => _$UserStatsDtoCopyWithImpl<UserStatsDto>(this as UserStatsDto, _$identity);

  /// Serializes this UserStatsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UserStatsDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserStatsDto&&(identical(other.totalXp, _this.totalXp) || other.totalXp == _this.totalXp)&&(identical(other.weeklyXp, _this.weeklyXp) || other.weeklyXp == _this.weeklyXp)&&(identical(other.streakDays, _this.streakDays) || other.streakDays == _this.streakDays)&&(identical(other.longestStreakDays, _this.longestStreakDays) || other.longestStreakDays == _this.longestStreakDays)&&(identical(other.streakFreezes, _this.streakFreezes) || other.streakFreezes == _this.streakFreezes)&&(identical(other.hearts, _this.hearts) || other.hearts == _this.hearts)&&(identical(other.maxHearts, _this.maxHearts) || other.maxHearts == _this.maxHearts)&&(identical(other.heartsRefillAt, _this.heartsRefillAt) || other.heartsRefillAt == _this.heartsRefillAt)&&(identical(other.signsLearned, _this.signsLearned) || other.signsLearned == _this.signsLearned)&&(identical(other.cameraAccuracy, _this.cameraAccuracy) || other.cameraAccuracy == _this.cameraAccuracy)&&(identical(other.weekStart, _this.weekStart) || other.weekStart == _this.weekStart)&&const DeepCollectionEquality().equals(other.weekXp, _this.weekXp)&&(identical(other.todayIndex, _this.todayIndex) || other.todayIndex == _this.todayIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UserStatsDto;
  return Object.hash(runtimeType,_this.totalXp,_this.weeklyXp,_this.streakDays,_this.longestStreakDays,_this.streakFreezes,_this.hearts,_this.maxHearts,_this.heartsRefillAt,_this.signsLearned,_this.cameraAccuracy,_this.weekStart,const DeepCollectionEquality().hash(_this.weekXp),_this.todayIndex);
}

@override
String toString() {
  final _this = this as UserStatsDto;
  return 'UserStatsDto(totalXp: ${_this.totalXp}, weeklyXp: ${_this.weeklyXp}, streakDays: ${_this.streakDays}, longestStreakDays: ${_this.longestStreakDays}, streakFreezes: ${_this.streakFreezes}, hearts: ${_this.hearts}, maxHearts: ${_this.maxHearts}, heartsRefillAt: ${_this.heartsRefillAt}, signsLearned: ${_this.signsLearned}, cameraAccuracy: ${_this.cameraAccuracy}, weekStart: ${_this.weekStart}, weekXp: ${_this.weekXp}, todayIndex: ${_this.todayIndex})';
}


}

/// @nodoc
abstract mixin class $UserStatsDtoCopyWith<$Res>  {
  factory $UserStatsDtoCopyWith(UserStatsDto value, $Res Function(UserStatsDto) _then) = _$UserStatsDtoCopyWithImpl;
@useResult
$Res call({
 int totalXp, int weeklyXp, int streakDays, int longestStreakDays, int streakFreezes, int hearts, int maxHearts, DateTime? heartsRefillAt, int signsLearned, double cameraAccuracy, DateTime weekStart, List<int> weekXp, int todayIndex
});




}
/// @nodoc
class _$UserStatsDtoCopyWithImpl<$Res>
    implements $UserStatsDtoCopyWith<$Res> {
  _$UserStatsDtoCopyWithImpl(this._self, this._then);

  final UserStatsDto _self;
  final $Res Function(UserStatsDto) _then;

/// Create a copy of UserStatsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalXp = null,Object? weeklyXp = null,Object? streakDays = null,Object? longestStreakDays = null,Object? streakFreezes = null,Object? hearts = null,Object? maxHearts = null,Object? heartsRefillAt = freezed,Object? signsLearned = null,Object? cameraAccuracy = null,Object? weekStart = null,Object? weekXp = null,Object? todayIndex = null,}) {
  return _then(UserStatsDto(
totalXp: null == totalXp ? _self.totalXp : totalXp // ignore: cast_nullable_to_non_nullable
as int,weeklyXp: null == weeklyXp ? _self.weeklyXp : weeklyXp // ignore: cast_nullable_to_non_nullable
as int,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,longestStreakDays: null == longestStreakDays ? _self.longestStreakDays : longestStreakDays // ignore: cast_nullable_to_non_nullable
as int,streakFreezes: null == streakFreezes ? _self.streakFreezes : streakFreezes // ignore: cast_nullable_to_non_nullable
as int,hearts: null == hearts ? _self.hearts : hearts // ignore: cast_nullable_to_non_nullable
as int,maxHearts: null == maxHearts ? _self.maxHearts : maxHearts // ignore: cast_nullable_to_non_nullable
as int,heartsRefillAt: freezed == heartsRefillAt ? _self.heartsRefillAt : heartsRefillAt // ignore: cast_nullable_to_non_nullable
as DateTime?,signsLearned: null == signsLearned ? _self.signsLearned : signsLearned // ignore: cast_nullable_to_non_nullable
as int,cameraAccuracy: null == cameraAccuracy ? _self.cameraAccuracy : cameraAccuracy // ignore: cast_nullable_to_non_nullable
as double,weekStart: null == weekStart ? _self.weekStart : weekStart // ignore: cast_nullable_to_non_nullable
as DateTime,weekXp: null == weekXp ? _self.weekXp : weekXp // ignore: cast_nullable_to_non_nullable
as List<int>,todayIndex: null == todayIndex ? _self.todayIndex : todayIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UserStatsDto].
extension UserStatsDtoPatterns on UserStatsDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserStatsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserStatsDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserStatsDto value)  $default,){
final _that = this;
switch (_that) {
case _UserStatsDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserStatsDto value)?  $default,){
final _that = this;
switch (_that) {
case _UserStatsDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalXp,  int weeklyXp,  int streakDays,  int longestStreakDays,  int streakFreezes,  int hearts,  int maxHearts,  DateTime? heartsRefillAt,  int signsLearned,  double cameraAccuracy,  DateTime weekStart,  List<int> weekXp,  int todayIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserStatsDto() when $default != null:
return $default(_that.totalXp,_that.weeklyXp,_that.streakDays,_that.longestStreakDays,_that.streakFreezes,_that.hearts,_that.maxHearts,_that.heartsRefillAt,_that.signsLearned,_that.cameraAccuracy,_that.weekStart,_that.weekXp,_that.todayIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalXp,  int weeklyXp,  int streakDays,  int longestStreakDays,  int streakFreezes,  int hearts,  int maxHearts,  DateTime? heartsRefillAt,  int signsLearned,  double cameraAccuracy,  DateTime weekStart,  List<int> weekXp,  int todayIndex)  $default,) {final _that = this;
switch (_that) {
case _UserStatsDto():
return $default(_that.totalXp,_that.weeklyXp,_that.streakDays,_that.longestStreakDays,_that.streakFreezes,_that.hearts,_that.maxHearts,_that.heartsRefillAt,_that.signsLearned,_that.cameraAccuracy,_that.weekStart,_that.weekXp,_that.todayIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalXp,  int weeklyXp,  int streakDays,  int longestStreakDays,  int streakFreezes,  int hearts,  int maxHearts,  DateTime? heartsRefillAt,  int signsLearned,  double cameraAccuracy,  DateTime weekStart,  List<int> weekXp,  int todayIndex)?  $default,) {final _that = this;
switch (_that) {
case _UserStatsDto() when $default != null:
return $default(_that.totalXp,_that.weeklyXp,_that.streakDays,_that.longestStreakDays,_that.streakFreezes,_that.hearts,_that.maxHearts,_that.heartsRefillAt,_that.signsLearned,_that.cameraAccuracy,_that.weekStart,_that.weekXp,_that.todayIndex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserStatsDto extends UserStatsDto {
  const _UserStatsDto({required this.totalXp, required this.weeklyXp, required this.streakDays, required this.longestStreakDays, required this.streakFreezes, required this.hearts, required this.maxHearts, this.heartsRefillAt, required this.signsLearned, required this.cameraAccuracy, required this.weekStart, required  List<int> weekXp, required this.todayIndex}): _weekXp = weekXp,super._();
  factory _UserStatsDto.fromJson(Map<String, dynamic> json) => _$UserStatsDtoFromJson(json);

@override final  int totalXp;
@override final  int weeklyXp;
@override final  int streakDays;
@override final  int longestStreakDays;
@override final  int streakFreezes;
@override final  int hearts;
@override final  int maxHearts;
@override final  DateTime? heartsRefillAt;
@override final  int signsLearned;
@override final  double cameraAccuracy;
@override final  DateTime weekStart;
 final  List<int> _weekXp;
@override List<int> get weekXp {
  if (_weekXp is EqualUnmodifiableListView) return _weekXp;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weekXp);
}

@override final  int todayIndex;

/// Create a copy of UserStatsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserStatsDtoCopyWith<_UserStatsDto> get copyWith => __$UserStatsDtoCopyWithImpl<_UserStatsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserStatsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserStatsDto&&(identical(other.totalXp, totalXp) || other.totalXp == totalXp)&&(identical(other.weeklyXp, weeklyXp) || other.weeklyXp == weeklyXp)&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&(identical(other.longestStreakDays, longestStreakDays) || other.longestStreakDays == longestStreakDays)&&(identical(other.streakFreezes, streakFreezes) || other.streakFreezes == streakFreezes)&&(identical(other.hearts, hearts) || other.hearts == hearts)&&(identical(other.maxHearts, maxHearts) || other.maxHearts == maxHearts)&&(identical(other.heartsRefillAt, heartsRefillAt) || other.heartsRefillAt == heartsRefillAt)&&(identical(other.signsLearned, signsLearned) || other.signsLearned == signsLearned)&&(identical(other.cameraAccuracy, cameraAccuracy) || other.cameraAccuracy == cameraAccuracy)&&(identical(other.weekStart, weekStart) || other.weekStart == weekStart)&&const DeepCollectionEquality().equals(other.weekXp, _weekXp)&&(identical(other.todayIndex, todayIndex) || other.todayIndex == todayIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,totalXp,weeklyXp,streakDays,longestStreakDays,streakFreezes,hearts,maxHearts,heartsRefillAt,signsLearned,cameraAccuracy,weekStart,const DeepCollectionEquality().hash(_weekXp),todayIndex);
}

@override
String toString() {
    return 'UserStatsDto(totalXp: $totalXp, weeklyXp: $weeklyXp, streakDays: $streakDays, longestStreakDays: $longestStreakDays, streakFreezes: $streakFreezes, hearts: $hearts, maxHearts: $maxHearts, heartsRefillAt: $heartsRefillAt, signsLearned: $signsLearned, cameraAccuracy: $cameraAccuracy, weekStart: $weekStart, weekXp: $weekXp, todayIndex: $todayIndex)';
}


}

/// @nodoc
abstract mixin class _$UserStatsDtoCopyWith<$Res> implements $UserStatsDtoCopyWith<$Res> {
  factory _$UserStatsDtoCopyWith(_UserStatsDto value, $Res Function(_UserStatsDto) _then) = __$UserStatsDtoCopyWithImpl;
@override @useResult
$Res call({
 int totalXp, int weeklyXp, int streakDays, int longestStreakDays, int streakFreezes, int hearts, int maxHearts, DateTime? heartsRefillAt, int signsLearned, double cameraAccuracy, DateTime weekStart, List<int> weekXp, int todayIndex
});




}
/// @nodoc
class __$UserStatsDtoCopyWithImpl<$Res>
    implements _$UserStatsDtoCopyWith<$Res> {
  __$UserStatsDtoCopyWithImpl(this._self, this._then);

  final _UserStatsDto _self;
  final $Res Function(_UserStatsDto) _then;

/// Create a copy of UserStatsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalXp = null,Object? weeklyXp = null,Object? streakDays = null,Object? longestStreakDays = null,Object? streakFreezes = null,Object? hearts = null,Object? maxHearts = null,Object? heartsRefillAt = freezed,Object? signsLearned = null,Object? cameraAccuracy = null,Object? weekStart = null,Object? weekXp = null,Object? todayIndex = null,}) {
  return _then(_UserStatsDto(
totalXp: null == totalXp ? _self.totalXp : totalXp // ignore: cast_nullable_to_non_nullable
as int,weeklyXp: null == weeklyXp ? _self.weeklyXp : weeklyXp // ignore: cast_nullable_to_non_nullable
as int,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,longestStreakDays: null == longestStreakDays ? _self.longestStreakDays : longestStreakDays // ignore: cast_nullable_to_non_nullable
as int,streakFreezes: null == streakFreezes ? _self.streakFreezes : streakFreezes // ignore: cast_nullable_to_non_nullable
as int,hearts: null == hearts ? _self.hearts : hearts // ignore: cast_nullable_to_non_nullable
as int,maxHearts: null == maxHearts ? _self.maxHearts : maxHearts // ignore: cast_nullable_to_non_nullable
as int,heartsRefillAt: freezed == heartsRefillAt ? _self.heartsRefillAt : heartsRefillAt // ignore: cast_nullable_to_non_nullable
as DateTime?,signsLearned: null == signsLearned ? _self.signsLearned : signsLearned // ignore: cast_nullable_to_non_nullable
as int,cameraAccuracy: null == cameraAccuracy ? _self.cameraAccuracy : cameraAccuracy // ignore: cast_nullable_to_non_nullable
as double,weekStart: null == weekStart ? _self.weekStart : weekStart // ignore: cast_nullable_to_non_nullable
as DateTime,weekXp: null == weekXp ? _self._weekXp : weekXp // ignore: cast_nullable_to_non_nullable
as List<int>,todayIndex: null == todayIndex ? _self.todayIndex : todayIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
