// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProgressStats {

 int get streakDays; int get totalXp; int get hearts; int get maxHearts;
/// Create a copy of ProgressStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgressStatsCopyWith<ProgressStats> get copyWith => _$ProgressStatsCopyWithImpl<ProgressStats>(this as ProgressStats, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProgressStats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgressStats&&(identical(other.streakDays, _this.streakDays) || other.streakDays == _this.streakDays)&&(identical(other.totalXp, _this.totalXp) || other.totalXp == _this.totalXp)&&(identical(other.hearts, _this.hearts) || other.hearts == _this.hearts)&&(identical(other.maxHearts, _this.maxHearts) || other.maxHearts == _this.maxHearts));
}


@override
int get hashCode {
  final _this = this as ProgressStats;
  return Object.hash(runtimeType,_this.streakDays,_this.totalXp,_this.hearts,_this.maxHearts);
}

@override
String toString() {
  final _this = this as ProgressStats;
  return 'ProgressStats(streakDays: ${_this.streakDays}, totalXp: ${_this.totalXp}, hearts: ${_this.hearts}, maxHearts: ${_this.maxHearts})';
}


}

/// @nodoc
abstract mixin class $ProgressStatsCopyWith<$Res>  {
  factory $ProgressStatsCopyWith(ProgressStats value, $Res Function(ProgressStats) _then) = _$ProgressStatsCopyWithImpl;
@useResult
$Res call({
 int streakDays, int totalXp, int hearts, int maxHearts
});




}
/// @nodoc
class _$ProgressStatsCopyWithImpl<$Res>
    implements $ProgressStatsCopyWith<$Res> {
  _$ProgressStatsCopyWithImpl(this._self, this._then);

  final ProgressStats _self;
  final $Res Function(ProgressStats) _then;

/// Create a copy of ProgressStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? streakDays = null,Object? totalXp = null,Object? hearts = null,Object? maxHearts = null,}) {
  return _then(ProgressStats(
streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,totalXp: null == totalXp ? _self.totalXp : totalXp // ignore: cast_nullable_to_non_nullable
as int,hearts: null == hearts ? _self.hearts : hearts // ignore: cast_nullable_to_non_nullable
as int,maxHearts: null == maxHearts ? _self.maxHearts : maxHearts // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProgressStats].
extension ProgressStatsPatterns on ProgressStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgressStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgressStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgressStats value)  $default,){
final _that = this;
switch (_that) {
case _ProgressStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgressStats value)?  $default,){
final _that = this;
switch (_that) {
case _ProgressStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int streakDays,  int totalXp,  int hearts,  int maxHearts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgressStats() when $default != null:
return $default(_that.streakDays,_that.totalXp,_that.hearts,_that.maxHearts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int streakDays,  int totalXp,  int hearts,  int maxHearts)  $default,) {final _that = this;
switch (_that) {
case _ProgressStats():
return $default(_that.streakDays,_that.totalXp,_that.hearts,_that.maxHearts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int streakDays,  int totalXp,  int hearts,  int maxHearts)?  $default,) {final _that = this;
switch (_that) {
case _ProgressStats() when $default != null:
return $default(_that.streakDays,_that.totalXp,_that.hearts,_that.maxHearts);case _:
  return null;

}
}

}

/// @nodoc


class _ProgressStats implements ProgressStats {
  const _ProgressStats({required this.streakDays, required this.totalXp, required this.hearts, required this.maxHearts});
  

@override final  int streakDays;
@override final  int totalXp;
@override final  int hearts;
@override final  int maxHearts;

/// Create a copy of ProgressStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgressStatsCopyWith<_ProgressStats> get copyWith => __$ProgressStatsCopyWithImpl<_ProgressStats>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgressStats&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&(identical(other.totalXp, totalXp) || other.totalXp == totalXp)&&(identical(other.hearts, hearts) || other.hearts == hearts)&&(identical(other.maxHearts, maxHearts) || other.maxHearts == maxHearts));
}


@override
int get hashCode {
    return Object.hash(runtimeType,streakDays,totalXp,hearts,maxHearts);
}

@override
String toString() {
    return 'ProgressStats(streakDays: $streakDays, totalXp: $totalXp, hearts: $hearts, maxHearts: $maxHearts)';
}


}

/// @nodoc
abstract mixin class _$ProgressStatsCopyWith<$Res> implements $ProgressStatsCopyWith<$Res> {
  factory _$ProgressStatsCopyWith(_ProgressStats value, $Res Function(_ProgressStats) _then) = __$ProgressStatsCopyWithImpl;
@override @useResult
$Res call({
 int streakDays, int totalXp, int hearts, int maxHearts
});




}
/// @nodoc
class __$ProgressStatsCopyWithImpl<$Res>
    implements _$ProgressStatsCopyWith<$Res> {
  __$ProgressStatsCopyWithImpl(this._self, this._then);

  final _ProgressStats _self;
  final $Res Function(_ProgressStats) _then;

/// Create a copy of ProgressStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? streakDays = null,Object? totalXp = null,Object? hearts = null,Object? maxHearts = null,}) {
  return _then(_ProgressStats(
streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,totalXp: null == totalXp ? _self.totalXp : totalXp // ignore: cast_nullable_to_non_nullable
as int,hearts: null == hearts ? _self.hearts : hearts // ignore: cast_nullable_to_non_nullable
as int,maxHearts: null == maxHearts ? _self.maxHearts : maxHearts // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$StreakStats {

/// Current streak in days.
 int get days; int get longestDays;/// Streak freezes ready to use.
 int get freezes;/// Practised (earned XP) on each day this week, Monday first (7 values).
 List<bool> get practisedDays;/// Index into [practisedDays] of today (0 = Monday).
 int get todayIndex;
/// Create a copy of StreakStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StreakStatsCopyWith<StreakStats> get copyWith => _$StreakStatsCopyWithImpl<StreakStats>(this as StreakStats, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StreakStats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StreakStats&&(identical(other.days, _this.days) || other.days == _this.days)&&(identical(other.longestDays, _this.longestDays) || other.longestDays == _this.longestDays)&&(identical(other.freezes, _this.freezes) || other.freezes == _this.freezes)&&const DeepCollectionEquality().equals(other.practisedDays, _this.practisedDays)&&(identical(other.todayIndex, _this.todayIndex) || other.todayIndex == _this.todayIndex));
}


@override
int get hashCode {
  final _this = this as StreakStats;
  return Object.hash(runtimeType,_this.days,_this.longestDays,_this.freezes,const DeepCollectionEquality().hash(_this.practisedDays),_this.todayIndex);
}

@override
String toString() {
  final _this = this as StreakStats;
  return 'StreakStats(days: ${_this.days}, longestDays: ${_this.longestDays}, freezes: ${_this.freezes}, practisedDays: ${_this.practisedDays}, todayIndex: ${_this.todayIndex})';
}


}

/// @nodoc
abstract mixin class $StreakStatsCopyWith<$Res>  {
  factory $StreakStatsCopyWith(StreakStats value, $Res Function(StreakStats) _then) = _$StreakStatsCopyWithImpl;
@useResult
$Res call({
 int days, int longestDays, int freezes, List<bool> practisedDays, int todayIndex
});




}
/// @nodoc
class _$StreakStatsCopyWithImpl<$Res>
    implements $StreakStatsCopyWith<$Res> {
  _$StreakStatsCopyWithImpl(this._self, this._then);

  final StreakStats _self;
  final $Res Function(StreakStats) _then;

/// Create a copy of StreakStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? days = null,Object? longestDays = null,Object? freezes = null,Object? practisedDays = null,Object? todayIndex = null,}) {
  return _then(StreakStats(
days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,longestDays: null == longestDays ? _self.longestDays : longestDays // ignore: cast_nullable_to_non_nullable
as int,freezes: null == freezes ? _self.freezes : freezes // ignore: cast_nullable_to_non_nullable
as int,practisedDays: null == practisedDays ? _self.practisedDays : practisedDays // ignore: cast_nullable_to_non_nullable
as List<bool>,todayIndex: null == todayIndex ? _self.todayIndex : todayIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StreakStats].
extension StreakStatsPatterns on StreakStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StreakStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StreakStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StreakStats value)  $default,){
final _that = this;
switch (_that) {
case _StreakStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StreakStats value)?  $default,){
final _that = this;
switch (_that) {
case _StreakStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int days,  int longestDays,  int freezes,  List<bool> practisedDays,  int todayIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StreakStats() when $default != null:
return $default(_that.days,_that.longestDays,_that.freezes,_that.practisedDays,_that.todayIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int days,  int longestDays,  int freezes,  List<bool> practisedDays,  int todayIndex)  $default,) {final _that = this;
switch (_that) {
case _StreakStats():
return $default(_that.days,_that.longestDays,_that.freezes,_that.practisedDays,_that.todayIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int days,  int longestDays,  int freezes,  List<bool> practisedDays,  int todayIndex)?  $default,) {final _that = this;
switch (_that) {
case _StreakStats() when $default != null:
return $default(_that.days,_that.longestDays,_that.freezes,_that.practisedDays,_that.todayIndex);case _:
  return null;

}
}

}

/// @nodoc


class _StreakStats implements StreakStats {
  const _StreakStats({required this.days, required this.longestDays, required this.freezes, required  List<bool> practisedDays, required this.todayIndex}): _practisedDays = practisedDays;
  

/// Current streak in days.
@override final  int days;
@override final  int longestDays;
/// Streak freezes ready to use.
@override final  int freezes;
/// Practised (earned XP) on each day this week, Monday first (7 values).
 final  List<bool> _practisedDays;
/// Practised (earned XP) on each day this week, Monday first (7 values).
@override List<bool> get practisedDays {
  if (_practisedDays is EqualUnmodifiableListView) return _practisedDays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_practisedDays);
}

/// Index into [practisedDays] of today (0 = Monday).
@override final  int todayIndex;

/// Create a copy of StreakStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StreakStatsCopyWith<_StreakStats> get copyWith => __$StreakStatsCopyWithImpl<_StreakStats>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StreakStats&&(identical(other.days, days) || other.days == days)&&(identical(other.longestDays, longestDays) || other.longestDays == longestDays)&&(identical(other.freezes, freezes) || other.freezes == freezes)&&const DeepCollectionEquality().equals(other.practisedDays, _practisedDays)&&(identical(other.todayIndex, todayIndex) || other.todayIndex == todayIndex));
}


@override
int get hashCode {
    return Object.hash(runtimeType,days,longestDays,freezes,const DeepCollectionEquality().hash(_practisedDays),todayIndex);
}

@override
String toString() {
    return 'StreakStats(days: $days, longestDays: $longestDays, freezes: $freezes, practisedDays: $practisedDays, todayIndex: $todayIndex)';
}


}

/// @nodoc
abstract mixin class _$StreakStatsCopyWith<$Res> implements $StreakStatsCopyWith<$Res> {
  factory _$StreakStatsCopyWith(_StreakStats value, $Res Function(_StreakStats) _then) = __$StreakStatsCopyWithImpl;
@override @useResult
$Res call({
 int days, int longestDays, int freezes, List<bool> practisedDays, int todayIndex
});




}
/// @nodoc
class __$StreakStatsCopyWithImpl<$Res>
    implements _$StreakStatsCopyWith<$Res> {
  __$StreakStatsCopyWithImpl(this._self, this._then);

  final _StreakStats _self;
  final $Res Function(_StreakStats) _then;

/// Create a copy of StreakStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? days = null,Object? longestDays = null,Object? freezes = null,Object? practisedDays = null,Object? todayIndex = null,}) {
  return _then(_StreakStats(
days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,longestDays: null == longestDays ? _self.longestDays : longestDays // ignore: cast_nullable_to_non_nullable
as int,freezes: null == freezes ? _self.freezes : freezes // ignore: cast_nullable_to_non_nullable
as int,practisedDays: null == practisedDays ? _self._practisedDays : practisedDays // ignore: cast_nullable_to_non_nullable
as List<bool>,todayIndex: null == todayIndex ? _self.todayIndex : todayIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
