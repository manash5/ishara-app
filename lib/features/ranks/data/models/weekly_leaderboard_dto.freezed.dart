// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weekly_leaderboard_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WeeklyLeaderboardDto {

 String get leagueName; String get nextLeagueName; int get weekNumber; int get learnerCount; DateTime get endsAt; int get promotionCount; int get xpToPromotion; List<LeaderboardEntryDto> get entries;
/// Create a copy of WeeklyLeaderboardDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeeklyLeaderboardDtoCopyWith<WeeklyLeaderboardDto> get copyWith => _$WeeklyLeaderboardDtoCopyWithImpl<WeeklyLeaderboardDto>(this as WeeklyLeaderboardDto, _$identity);

  /// Serializes this WeeklyLeaderboardDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WeeklyLeaderboardDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeeklyLeaderboardDto&&(identical(other.leagueName, _this.leagueName) || other.leagueName == _this.leagueName)&&(identical(other.nextLeagueName, _this.nextLeagueName) || other.nextLeagueName == _this.nextLeagueName)&&(identical(other.weekNumber, _this.weekNumber) || other.weekNumber == _this.weekNumber)&&(identical(other.learnerCount, _this.learnerCount) || other.learnerCount == _this.learnerCount)&&(identical(other.endsAt, _this.endsAt) || other.endsAt == _this.endsAt)&&(identical(other.promotionCount, _this.promotionCount) || other.promotionCount == _this.promotionCount)&&(identical(other.xpToPromotion, _this.xpToPromotion) || other.xpToPromotion == _this.xpToPromotion)&&const DeepCollectionEquality().equals(other.entries, _this.entries));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WeeklyLeaderboardDto;
  return Object.hash(runtimeType,_this.leagueName,_this.nextLeagueName,_this.weekNumber,_this.learnerCount,_this.endsAt,_this.promotionCount,_this.xpToPromotion,const DeepCollectionEquality().hash(_this.entries));
}

@override
String toString() {
  final _this = this as WeeklyLeaderboardDto;
  return 'WeeklyLeaderboardDto(leagueName: ${_this.leagueName}, nextLeagueName: ${_this.nextLeagueName}, weekNumber: ${_this.weekNumber}, learnerCount: ${_this.learnerCount}, endsAt: ${_this.endsAt}, promotionCount: ${_this.promotionCount}, xpToPromotion: ${_this.xpToPromotion}, entries: ${_this.entries})';
}


}

/// @nodoc
abstract mixin class $WeeklyLeaderboardDtoCopyWith<$Res>  {
  factory $WeeklyLeaderboardDtoCopyWith(WeeklyLeaderboardDto value, $Res Function(WeeklyLeaderboardDto) _then) = _$WeeklyLeaderboardDtoCopyWithImpl;
@useResult
$Res call({
 String leagueName, String nextLeagueName, int weekNumber, int learnerCount, DateTime endsAt, int promotionCount, int xpToPromotion, List<LeaderboardEntryDto> entries
});




}
/// @nodoc
class _$WeeklyLeaderboardDtoCopyWithImpl<$Res>
    implements $WeeklyLeaderboardDtoCopyWith<$Res> {
  _$WeeklyLeaderboardDtoCopyWithImpl(this._self, this._then);

  final WeeklyLeaderboardDto _self;
  final $Res Function(WeeklyLeaderboardDto) _then;

/// Create a copy of WeeklyLeaderboardDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? leagueName = null,Object? nextLeagueName = null,Object? weekNumber = null,Object? learnerCount = null,Object? endsAt = null,Object? promotionCount = null,Object? xpToPromotion = null,Object? entries = null,}) {
  return _then(WeeklyLeaderboardDto(
leagueName: null == leagueName ? _self.leagueName : leagueName // ignore: cast_nullable_to_non_nullable
as String,nextLeagueName: null == nextLeagueName ? _self.nextLeagueName : nextLeagueName // ignore: cast_nullable_to_non_nullable
as String,weekNumber: null == weekNumber ? _self.weekNumber : weekNumber // ignore: cast_nullable_to_non_nullable
as int,learnerCount: null == learnerCount ? _self.learnerCount : learnerCount // ignore: cast_nullable_to_non_nullable
as int,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,promotionCount: null == promotionCount ? _self.promotionCount : promotionCount // ignore: cast_nullable_to_non_nullable
as int,xpToPromotion: null == xpToPromotion ? _self.xpToPromotion : xpToPromotion // ignore: cast_nullable_to_non_nullable
as int,entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<LeaderboardEntryDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [WeeklyLeaderboardDto].
extension WeeklyLeaderboardDtoPatterns on WeeklyLeaderboardDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeeklyLeaderboardDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeeklyLeaderboardDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeeklyLeaderboardDto value)  $default,){
final _that = this;
switch (_that) {
case _WeeklyLeaderboardDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeeklyLeaderboardDto value)?  $default,){
final _that = this;
switch (_that) {
case _WeeklyLeaderboardDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String leagueName,  String nextLeagueName,  int weekNumber,  int learnerCount,  DateTime endsAt,  int promotionCount,  int xpToPromotion,  List<LeaderboardEntryDto> entries)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeeklyLeaderboardDto() when $default != null:
return $default(_that.leagueName,_that.nextLeagueName,_that.weekNumber,_that.learnerCount,_that.endsAt,_that.promotionCount,_that.xpToPromotion,_that.entries);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String leagueName,  String nextLeagueName,  int weekNumber,  int learnerCount,  DateTime endsAt,  int promotionCount,  int xpToPromotion,  List<LeaderboardEntryDto> entries)  $default,) {final _that = this;
switch (_that) {
case _WeeklyLeaderboardDto():
return $default(_that.leagueName,_that.nextLeagueName,_that.weekNumber,_that.learnerCount,_that.endsAt,_that.promotionCount,_that.xpToPromotion,_that.entries);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String leagueName,  String nextLeagueName,  int weekNumber,  int learnerCount,  DateTime endsAt,  int promotionCount,  int xpToPromotion,  List<LeaderboardEntryDto> entries)?  $default,) {final _that = this;
switch (_that) {
case _WeeklyLeaderboardDto() when $default != null:
return $default(_that.leagueName,_that.nextLeagueName,_that.weekNumber,_that.learnerCount,_that.endsAt,_that.promotionCount,_that.xpToPromotion,_that.entries);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeeklyLeaderboardDto extends WeeklyLeaderboardDto {
  const _WeeklyLeaderboardDto({required this.leagueName, required this.nextLeagueName, required this.weekNumber, required this.learnerCount, required this.endsAt, required this.promotionCount, required this.xpToPromotion, required  List<LeaderboardEntryDto> entries}): _entries = entries,super._();
  factory _WeeklyLeaderboardDto.fromJson(Map<String, dynamic> json) => _$WeeklyLeaderboardDtoFromJson(json);

@override final  String leagueName;
@override final  String nextLeagueName;
@override final  int weekNumber;
@override final  int learnerCount;
@override final  DateTime endsAt;
@override final  int promotionCount;
@override final  int xpToPromotion;
 final  List<LeaderboardEntryDto> _entries;
@override List<LeaderboardEntryDto> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}


/// Create a copy of WeeklyLeaderboardDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeeklyLeaderboardDtoCopyWith<_WeeklyLeaderboardDto> get copyWith => __$WeeklyLeaderboardDtoCopyWithImpl<_WeeklyLeaderboardDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeeklyLeaderboardDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeeklyLeaderboardDto&&(identical(other.leagueName, leagueName) || other.leagueName == leagueName)&&(identical(other.nextLeagueName, nextLeagueName) || other.nextLeagueName == nextLeagueName)&&(identical(other.weekNumber, weekNumber) || other.weekNumber == weekNumber)&&(identical(other.learnerCount, learnerCount) || other.learnerCount == learnerCount)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.promotionCount, promotionCount) || other.promotionCount == promotionCount)&&(identical(other.xpToPromotion, xpToPromotion) || other.xpToPromotion == xpToPromotion)&&const DeepCollectionEquality().equals(other.entries, _entries));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,leagueName,nextLeagueName,weekNumber,learnerCount,endsAt,promotionCount,xpToPromotion,const DeepCollectionEquality().hash(_entries));
}

@override
String toString() {
    return 'WeeklyLeaderboardDto(leagueName: $leagueName, nextLeagueName: $nextLeagueName, weekNumber: $weekNumber, learnerCount: $learnerCount, endsAt: $endsAt, promotionCount: $promotionCount, xpToPromotion: $xpToPromotion, entries: $entries)';
}


}

/// @nodoc
abstract mixin class _$WeeklyLeaderboardDtoCopyWith<$Res> implements $WeeklyLeaderboardDtoCopyWith<$Res> {
  factory _$WeeklyLeaderboardDtoCopyWith(_WeeklyLeaderboardDto value, $Res Function(_WeeklyLeaderboardDto) _then) = __$WeeklyLeaderboardDtoCopyWithImpl;
@override @useResult
$Res call({
 String leagueName, String nextLeagueName, int weekNumber, int learnerCount, DateTime endsAt, int promotionCount, int xpToPromotion, List<LeaderboardEntryDto> entries
});




}
/// @nodoc
class __$WeeklyLeaderboardDtoCopyWithImpl<$Res>
    implements _$WeeklyLeaderboardDtoCopyWith<$Res> {
  __$WeeklyLeaderboardDtoCopyWithImpl(this._self, this._then);

  final _WeeklyLeaderboardDto _self;
  final $Res Function(_WeeklyLeaderboardDto) _then;

/// Create a copy of WeeklyLeaderboardDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? leagueName = null,Object? nextLeagueName = null,Object? weekNumber = null,Object? learnerCount = null,Object? endsAt = null,Object? promotionCount = null,Object? xpToPromotion = null,Object? entries = null,}) {
  return _then(_WeeklyLeaderboardDto(
leagueName: null == leagueName ? _self.leagueName : leagueName // ignore: cast_nullable_to_non_nullable
as String,nextLeagueName: null == nextLeagueName ? _self.nextLeagueName : nextLeagueName // ignore: cast_nullable_to_non_nullable
as String,weekNumber: null == weekNumber ? _self.weekNumber : weekNumber // ignore: cast_nullable_to_non_nullable
as int,learnerCount: null == learnerCount ? _self.learnerCount : learnerCount // ignore: cast_nullable_to_non_nullable
as int,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,promotionCount: null == promotionCount ? _self.promotionCount : promotionCount // ignore: cast_nullable_to_non_nullable
as int,xpToPromotion: null == xpToPromotion ? _self.xpToPromotion : xpToPromotion // ignore: cast_nullable_to_non_nullable
as int,entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<LeaderboardEntryDto>,
  ));
}


}


/// @nodoc
mixin _$LeaderboardEntryDto {

 int get rank; String get userId; String get displayName; String? get avatarUrl; int get xp; bool get isMe;
/// Create a copy of LeaderboardEntryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaderboardEntryDtoCopyWith<LeaderboardEntryDto> get copyWith => _$LeaderboardEntryDtoCopyWithImpl<LeaderboardEntryDto>(this as LeaderboardEntryDto, _$identity);

  /// Serializes this LeaderboardEntryDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LeaderboardEntryDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaderboardEntryDto&&(identical(other.rank, _this.rank) || other.rank == _this.rank)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.avatarUrl, _this.avatarUrl) || other.avatarUrl == _this.avatarUrl)&&(identical(other.xp, _this.xp) || other.xp == _this.xp)&&(identical(other.isMe, _this.isMe) || other.isMe == _this.isMe));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LeaderboardEntryDto;
  return Object.hash(runtimeType,_this.rank,_this.userId,_this.displayName,_this.avatarUrl,_this.xp,_this.isMe);
}

@override
String toString() {
  final _this = this as LeaderboardEntryDto;
  return 'LeaderboardEntryDto(rank: ${_this.rank}, userId: ${_this.userId}, displayName: ${_this.displayName}, avatarUrl: ${_this.avatarUrl}, xp: ${_this.xp}, isMe: ${_this.isMe})';
}


}

/// @nodoc
abstract mixin class $LeaderboardEntryDtoCopyWith<$Res>  {
  factory $LeaderboardEntryDtoCopyWith(LeaderboardEntryDto value, $Res Function(LeaderboardEntryDto) _then) = _$LeaderboardEntryDtoCopyWithImpl;
@useResult
$Res call({
 int rank, String userId, String displayName, String? avatarUrl, int xp, bool isMe
});




}
/// @nodoc
class _$LeaderboardEntryDtoCopyWithImpl<$Res>
    implements $LeaderboardEntryDtoCopyWith<$Res> {
  _$LeaderboardEntryDtoCopyWithImpl(this._self, this._then);

  final LeaderboardEntryDto _self;
  final $Res Function(LeaderboardEntryDto) _then;

/// Create a copy of LeaderboardEntryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rank = null,Object? userId = null,Object? displayName = null,Object? avatarUrl = freezed,Object? xp = null,Object? isMe = null,}) {
  return _then(LeaderboardEntryDto(
rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,xp: null == xp ? _self.xp : xp // ignore: cast_nullable_to_non_nullable
as int,isMe: null == isMe ? _self.isMe : isMe // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaderboardEntryDto].
extension LeaderboardEntryDtoPatterns on LeaderboardEntryDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaderboardEntryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaderboardEntryDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaderboardEntryDto value)  $default,){
final _that = this;
switch (_that) {
case _LeaderboardEntryDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaderboardEntryDto value)?  $default,){
final _that = this;
switch (_that) {
case _LeaderboardEntryDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int rank,  String userId,  String displayName,  String? avatarUrl,  int xp,  bool isMe)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaderboardEntryDto() when $default != null:
return $default(_that.rank,_that.userId,_that.displayName,_that.avatarUrl,_that.xp,_that.isMe);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int rank,  String userId,  String displayName,  String? avatarUrl,  int xp,  bool isMe)  $default,) {final _that = this;
switch (_that) {
case _LeaderboardEntryDto():
return $default(_that.rank,_that.userId,_that.displayName,_that.avatarUrl,_that.xp,_that.isMe);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int rank,  String userId,  String displayName,  String? avatarUrl,  int xp,  bool isMe)?  $default,) {final _that = this;
switch (_that) {
case _LeaderboardEntryDto() when $default != null:
return $default(_that.rank,_that.userId,_that.displayName,_that.avatarUrl,_that.xp,_that.isMe);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaderboardEntryDto extends LeaderboardEntryDto {
  const _LeaderboardEntryDto({required this.rank, required this.userId, required this.displayName, this.avatarUrl, required this.xp, this.isMe = false}): super._();
  factory _LeaderboardEntryDto.fromJson(Map<String, dynamic> json) => _$LeaderboardEntryDtoFromJson(json);

@override final  int rank;
@override final  String userId;
@override final  String displayName;
@override final  String? avatarUrl;
@override final  int xp;
@override@JsonKey() final  bool isMe;

/// Create a copy of LeaderboardEntryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaderboardEntryDtoCopyWith<_LeaderboardEntryDto> get copyWith => __$LeaderboardEntryDtoCopyWithImpl<_LeaderboardEntryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaderboardEntryDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaderboardEntryDto&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.xp, xp) || other.xp == xp)&&(identical(other.isMe, isMe) || other.isMe == isMe));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,rank,userId,displayName,avatarUrl,xp,isMe);
}

@override
String toString() {
    return 'LeaderboardEntryDto(rank: $rank, userId: $userId, displayName: $displayName, avatarUrl: $avatarUrl, xp: $xp, isMe: $isMe)';
}


}

/// @nodoc
abstract mixin class _$LeaderboardEntryDtoCopyWith<$Res> implements $LeaderboardEntryDtoCopyWith<$Res> {
  factory _$LeaderboardEntryDtoCopyWith(_LeaderboardEntryDto value, $Res Function(_LeaderboardEntryDto) _then) = __$LeaderboardEntryDtoCopyWithImpl;
@override @useResult
$Res call({
 int rank, String userId, String displayName, String? avatarUrl, int xp, bool isMe
});




}
/// @nodoc
class __$LeaderboardEntryDtoCopyWithImpl<$Res>
    implements _$LeaderboardEntryDtoCopyWith<$Res> {
  __$LeaderboardEntryDtoCopyWithImpl(this._self, this._then);

  final _LeaderboardEntryDto _self;
  final $Res Function(_LeaderboardEntryDto) _then;

/// Create a copy of LeaderboardEntryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rank = null,Object? userId = null,Object? displayName = null,Object? avatarUrl = freezed,Object? xp = null,Object? isMe = null,}) {
  return _then(_LeaderboardEntryDto(
rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,xp: null == xp ? _self.xp : xp // ignore: cast_nullable_to_non_nullable
as int,isMe: null == isMe ? _self.isMe : isMe // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
