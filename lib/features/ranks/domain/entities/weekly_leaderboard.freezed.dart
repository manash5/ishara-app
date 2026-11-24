// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weekly_leaderboard.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WeeklyLeaderboard {

 String get leagueName; String get nextLeagueName; int get weekNumber; int get learnerCount;/// Monday 00:00 Asia/Kathmandu, in UTC.
 DateTime get endsAt; int get promotionCount;/// XP the learner still needs, as computed by the backend.
 int get xpToPromotion; List<LeaderboardEntry> get entries;
/// Create a copy of WeeklyLeaderboard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeeklyLeaderboardCopyWith<WeeklyLeaderboard> get copyWith => _$WeeklyLeaderboardCopyWithImpl<WeeklyLeaderboard>(this as WeeklyLeaderboard, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WeeklyLeaderboard;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeeklyLeaderboard&&(identical(other.leagueName, _this.leagueName) || other.leagueName == _this.leagueName)&&(identical(other.nextLeagueName, _this.nextLeagueName) || other.nextLeagueName == _this.nextLeagueName)&&(identical(other.weekNumber, _this.weekNumber) || other.weekNumber == _this.weekNumber)&&(identical(other.learnerCount, _this.learnerCount) || other.learnerCount == _this.learnerCount)&&(identical(other.endsAt, _this.endsAt) || other.endsAt == _this.endsAt)&&(identical(other.promotionCount, _this.promotionCount) || other.promotionCount == _this.promotionCount)&&(identical(other.xpToPromotion, _this.xpToPromotion) || other.xpToPromotion == _this.xpToPromotion)&&const DeepCollectionEquality().equals(other.entries, _this.entries));
}


@override
int get hashCode {
  final _this = this as WeeklyLeaderboard;
  return Object.hash(runtimeType,_this.leagueName,_this.nextLeagueName,_this.weekNumber,_this.learnerCount,_this.endsAt,_this.promotionCount,_this.xpToPromotion,const DeepCollectionEquality().hash(_this.entries));
}

@override
String toString() {
  final _this = this as WeeklyLeaderboard;
  return 'WeeklyLeaderboard(leagueName: ${_this.leagueName}, nextLeagueName: ${_this.nextLeagueName}, weekNumber: ${_this.weekNumber}, learnerCount: ${_this.learnerCount}, endsAt: ${_this.endsAt}, promotionCount: ${_this.promotionCount}, xpToPromotion: ${_this.xpToPromotion}, entries: ${_this.entries})';
}


}

/// @nodoc
abstract mixin class $WeeklyLeaderboardCopyWith<$Res>  {
  factory $WeeklyLeaderboardCopyWith(WeeklyLeaderboard value, $Res Function(WeeklyLeaderboard) _then) = _$WeeklyLeaderboardCopyWithImpl;
@useResult
$Res call({
 String leagueName, String nextLeagueName, int weekNumber, int learnerCount, DateTime endsAt, int promotionCount, int xpToPromotion, List<LeaderboardEntry> entries
});




}
/// @nodoc
class _$WeeklyLeaderboardCopyWithImpl<$Res>
    implements $WeeklyLeaderboardCopyWith<$Res> {
  _$WeeklyLeaderboardCopyWithImpl(this._self, this._then);

  final WeeklyLeaderboard _self;
  final $Res Function(WeeklyLeaderboard) _then;

/// Create a copy of WeeklyLeaderboard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? leagueName = null,Object? nextLeagueName = null,Object? weekNumber = null,Object? learnerCount = null,Object? endsAt = null,Object? promotionCount = null,Object? xpToPromotion = null,Object? entries = null,}) {
  return _then(WeeklyLeaderboard(
leagueName: null == leagueName ? _self.leagueName : leagueName // ignore: cast_nullable_to_non_nullable
as String,nextLeagueName: null == nextLeagueName ? _self.nextLeagueName : nextLeagueName // ignore: cast_nullable_to_non_nullable
as String,weekNumber: null == weekNumber ? _self.weekNumber : weekNumber // ignore: cast_nullable_to_non_nullable
as int,learnerCount: null == learnerCount ? _self.learnerCount : learnerCount // ignore: cast_nullable_to_non_nullable
as int,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,promotionCount: null == promotionCount ? _self.promotionCount : promotionCount // ignore: cast_nullable_to_non_nullable
as int,xpToPromotion: null == xpToPromotion ? _self.xpToPromotion : xpToPromotion // ignore: cast_nullable_to_non_nullable
as int,entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<LeaderboardEntry>,
  ));
}

}


/// Adds pattern-matching-related methods to [WeeklyLeaderboard].
extension WeeklyLeaderboardPatterns on WeeklyLeaderboard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeeklyLeaderboard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeeklyLeaderboard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeeklyLeaderboard value)  $default,){
final _that = this;
switch (_that) {
case _WeeklyLeaderboard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeeklyLeaderboard value)?  $default,){
final _that = this;
switch (_that) {
case _WeeklyLeaderboard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String leagueName,  String nextLeagueName,  int weekNumber,  int learnerCount,  DateTime endsAt,  int promotionCount,  int xpToPromotion,  List<LeaderboardEntry> entries)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeeklyLeaderboard() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String leagueName,  String nextLeagueName,  int weekNumber,  int learnerCount,  DateTime endsAt,  int promotionCount,  int xpToPromotion,  List<LeaderboardEntry> entries)  $default,) {final _that = this;
switch (_that) {
case _WeeklyLeaderboard():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String leagueName,  String nextLeagueName,  int weekNumber,  int learnerCount,  DateTime endsAt,  int promotionCount,  int xpToPromotion,  List<LeaderboardEntry> entries)?  $default,) {final _that = this;
switch (_that) {
case _WeeklyLeaderboard() when $default != null:
return $default(_that.leagueName,_that.nextLeagueName,_that.weekNumber,_that.learnerCount,_that.endsAt,_that.promotionCount,_that.xpToPromotion,_that.entries);case _:
  return null;

}
}

}

/// @nodoc


class _WeeklyLeaderboard implements WeeklyLeaderboard {
  const _WeeklyLeaderboard({required this.leagueName, required this.nextLeagueName, required this.weekNumber, required this.learnerCount, required this.endsAt, required this.promotionCount, required this.xpToPromotion, required  List<LeaderboardEntry> entries}): _entries = entries;
  

@override final  String leagueName;
@override final  String nextLeagueName;
@override final  int weekNumber;
@override final  int learnerCount;
/// Monday 00:00 Asia/Kathmandu, in UTC.
@override final  DateTime endsAt;
@override final  int promotionCount;
/// XP the learner still needs, as computed by the backend.
@override final  int xpToPromotion;
 final  List<LeaderboardEntry> _entries;
@override List<LeaderboardEntry> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}


/// Create a copy of WeeklyLeaderboard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeeklyLeaderboardCopyWith<_WeeklyLeaderboard> get copyWith => __$WeeklyLeaderboardCopyWithImpl<_WeeklyLeaderboard>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeeklyLeaderboard&&(identical(other.leagueName, leagueName) || other.leagueName == leagueName)&&(identical(other.nextLeagueName, nextLeagueName) || other.nextLeagueName == nextLeagueName)&&(identical(other.weekNumber, weekNumber) || other.weekNumber == weekNumber)&&(identical(other.learnerCount, learnerCount) || other.learnerCount == learnerCount)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.promotionCount, promotionCount) || other.promotionCount == promotionCount)&&(identical(other.xpToPromotion, xpToPromotion) || other.xpToPromotion == xpToPromotion)&&const DeepCollectionEquality().equals(other.entries, _entries));
}


@override
int get hashCode {
    return Object.hash(runtimeType,leagueName,nextLeagueName,weekNumber,learnerCount,endsAt,promotionCount,xpToPromotion,const DeepCollectionEquality().hash(_entries));
}

@override
String toString() {
    return 'WeeklyLeaderboard(leagueName: $leagueName, nextLeagueName: $nextLeagueName, weekNumber: $weekNumber, learnerCount: $learnerCount, endsAt: $endsAt, promotionCount: $promotionCount, xpToPromotion: $xpToPromotion, entries: $entries)';
}


}

/// @nodoc
abstract mixin class _$WeeklyLeaderboardCopyWith<$Res> implements $WeeklyLeaderboardCopyWith<$Res> {
  factory _$WeeklyLeaderboardCopyWith(_WeeklyLeaderboard value, $Res Function(_WeeklyLeaderboard) _then) = __$WeeklyLeaderboardCopyWithImpl;
@override @useResult
$Res call({
 String leagueName, String nextLeagueName, int weekNumber, int learnerCount, DateTime endsAt, int promotionCount, int xpToPromotion, List<LeaderboardEntry> entries
});




}
/// @nodoc
class __$WeeklyLeaderboardCopyWithImpl<$Res>
    implements _$WeeklyLeaderboardCopyWith<$Res> {
  __$WeeklyLeaderboardCopyWithImpl(this._self, this._then);

  final _WeeklyLeaderboard _self;
  final $Res Function(_WeeklyLeaderboard) _then;

/// Create a copy of WeeklyLeaderboard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? leagueName = null,Object? nextLeagueName = null,Object? weekNumber = null,Object? learnerCount = null,Object? endsAt = null,Object? promotionCount = null,Object? xpToPromotion = null,Object? entries = null,}) {
  return _then(_WeeklyLeaderboard(
leagueName: null == leagueName ? _self.leagueName : leagueName // ignore: cast_nullable_to_non_nullable
as String,nextLeagueName: null == nextLeagueName ? _self.nextLeagueName : nextLeagueName // ignore: cast_nullable_to_non_nullable
as String,weekNumber: null == weekNumber ? _self.weekNumber : weekNumber // ignore: cast_nullable_to_non_nullable
as int,learnerCount: null == learnerCount ? _self.learnerCount : learnerCount // ignore: cast_nullable_to_non_nullable
as int,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,promotionCount: null == promotionCount ? _self.promotionCount : promotionCount // ignore: cast_nullable_to_non_nullable
as int,xpToPromotion: null == xpToPromotion ? _self.xpToPromotion : xpToPromotion // ignore: cast_nullable_to_non_nullable
as int,entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<LeaderboardEntry>,
  ));
}


}

/// @nodoc
mixin _$LeaderboardEntry {

 int get rank; String get userId; String get displayName; String? get avatarUrl; int get xp;/// The signed-in learner (shown as "You").
 bool get isMe;
/// Create a copy of LeaderboardEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaderboardEntryCopyWith<LeaderboardEntry> get copyWith => _$LeaderboardEntryCopyWithImpl<LeaderboardEntry>(this as LeaderboardEntry, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LeaderboardEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaderboardEntry&&(identical(other.rank, _this.rank) || other.rank == _this.rank)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.avatarUrl, _this.avatarUrl) || other.avatarUrl == _this.avatarUrl)&&(identical(other.xp, _this.xp) || other.xp == _this.xp)&&(identical(other.isMe, _this.isMe) || other.isMe == _this.isMe));
}


@override
int get hashCode {
  final _this = this as LeaderboardEntry;
  return Object.hash(runtimeType,_this.rank,_this.userId,_this.displayName,_this.avatarUrl,_this.xp,_this.isMe);
}

@override
String toString() {
  final _this = this as LeaderboardEntry;
  return 'LeaderboardEntry(rank: ${_this.rank}, userId: ${_this.userId}, displayName: ${_this.displayName}, avatarUrl: ${_this.avatarUrl}, xp: ${_this.xp}, isMe: ${_this.isMe})';
}


}

/// @nodoc
abstract mixin class $LeaderboardEntryCopyWith<$Res>  {
  factory $LeaderboardEntryCopyWith(LeaderboardEntry value, $Res Function(LeaderboardEntry) _then) = _$LeaderboardEntryCopyWithImpl;
@useResult
$Res call({
 int rank, String userId, String displayName, String? avatarUrl, int xp, bool isMe
});




}
/// @nodoc
class _$LeaderboardEntryCopyWithImpl<$Res>
    implements $LeaderboardEntryCopyWith<$Res> {
  _$LeaderboardEntryCopyWithImpl(this._self, this._then);

  final LeaderboardEntry _self;
  final $Res Function(LeaderboardEntry) _then;

/// Create a copy of LeaderboardEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rank = null,Object? userId = null,Object? displayName = null,Object? avatarUrl = freezed,Object? xp = null,Object? isMe = null,}) {
  return _then(LeaderboardEntry(
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


/// Adds pattern-matching-related methods to [LeaderboardEntry].
extension LeaderboardEntryPatterns on LeaderboardEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaderboardEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaderboardEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaderboardEntry value)  $default,){
final _that = this;
switch (_that) {
case _LeaderboardEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaderboardEntry value)?  $default,){
final _that = this;
switch (_that) {
case _LeaderboardEntry() when $default != null:
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
case _LeaderboardEntry() when $default != null:
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
case _LeaderboardEntry():
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
case _LeaderboardEntry() when $default != null:
return $default(_that.rank,_that.userId,_that.displayName,_that.avatarUrl,_that.xp,_that.isMe);case _:
  return null;

}
}

}

/// @nodoc


class _LeaderboardEntry implements LeaderboardEntry {
  const _LeaderboardEntry({required this.rank, required this.userId, required this.displayName, this.avatarUrl, required this.xp, this.isMe = false});
  

@override final  int rank;
@override final  String userId;
@override final  String displayName;
@override final  String? avatarUrl;
@override final  int xp;
/// The signed-in learner (shown as "You").
@override@JsonKey() final  bool isMe;

/// Create a copy of LeaderboardEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaderboardEntryCopyWith<_LeaderboardEntry> get copyWith => __$LeaderboardEntryCopyWithImpl<_LeaderboardEntry>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaderboardEntry&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.xp, xp) || other.xp == xp)&&(identical(other.isMe, isMe) || other.isMe == isMe));
}


@override
int get hashCode {
    return Object.hash(runtimeType,rank,userId,displayName,avatarUrl,xp,isMe);
}

@override
String toString() {
    return 'LeaderboardEntry(rank: $rank, userId: $userId, displayName: $displayName, avatarUrl: $avatarUrl, xp: $xp, isMe: $isMe)';
}


}

/// @nodoc
abstract mixin class _$LeaderboardEntryCopyWith<$Res> implements $LeaderboardEntryCopyWith<$Res> {
  factory _$LeaderboardEntryCopyWith(_LeaderboardEntry value, $Res Function(_LeaderboardEntry) _then) = __$LeaderboardEntryCopyWithImpl;
@override @useResult
$Res call({
 int rank, String userId, String displayName, String? avatarUrl, int xp, bool isMe
});




}
/// @nodoc
class __$LeaderboardEntryCopyWithImpl<$Res>
    implements _$LeaderboardEntryCopyWith<$Res> {
  __$LeaderboardEntryCopyWithImpl(this._self, this._then);

  final _LeaderboardEntry _self;
  final $Res Function(_LeaderboardEntry) _then;

/// Create a copy of LeaderboardEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rank = null,Object? userId = null,Object? displayName = null,Object? avatarUrl = freezed,Object? xp = null,Object? isMe = null,}) {
  return _then(_LeaderboardEntry(
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
