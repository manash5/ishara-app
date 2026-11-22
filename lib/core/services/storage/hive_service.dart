import 'dart:convert';
import 'dart:typed_data';

import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../error/app_exception.dart';

part 'hive_service.g.dart';

/// The app's Hive boxes. Values are JSON maps, so no type adapters are needed.
enum HiveBoxes {
  /// API responses with the time they were fetched (cache-first reads).
  cache('cache'),

  /// Lesson completions waiting for `POST /progress/sync`.
  syncQueue('sync_queue'),

  /// Local preferences.
  settings('settings');

  const HiveBoxes(this.boxName);

  /// File name on disk (Hive lower-cases names, so keep them snake_case).
  final String boxName;
}

/// A cached value and when it was fetched.
class CacheEntry<T> {
  const CacheEntry(this.value, this.fetchedAt);

  final T value;
  final DateTime fetchedAt;

  bool isStale(Duration maxAge, {DateTime? now}) =>
      (now ?? DateTime.now()).difference(fetchedAt) > maxAge;
}

/// Opens Hive once at start-up (`main.dart`) and gives typed access to the
/// boxes. Only `data/` uses it; widgets never touch Hive.
class HiveService {
  HiveService._(this.cache, this.syncQueue, this.settings);

  /// Opens every box. [path] is for tests; the app uses the documents folder.
  static Future<HiveService> init({String? path}) async {
    if (path == null) {
      await Hive.initFlutter();
    } else {
      Hive.init(path);
    }
    return HiveService._(
      await Hive.openBox<Map<dynamic, dynamic>>(HiveBoxes.cache.boxName),
      await Hive.openBox<Map<dynamic, dynamic>>(HiveBoxes.syncQueue.boxName),
      await Hive.openBox<Object?>(HiveBoxes.settings.boxName),
    );
  }

  /// Boxes held in memory only (no disk IO), for tests: their writes finish
  /// without real IO, so they work inside fake-async widget tests.
  static Future<HiveService> inMemory() async => HiveService._(
    await Hive.openBox<Map<dynamic, dynamic>>(
      HiveBoxes.cache.boxName,
      bytes: Uint8List(0),
    ),
    await Hive.openBox<Map<dynamic, dynamic>>(
      HiveBoxes.syncQueue.boxName,
      bytes: Uint8List(0),
    ),
    await Hive.openBox<Object?>(
      HiveBoxes.settings.boxName,
      bytes: Uint8List(0),
    ),
  );

  /// Empties every box (logout, tests).
  Future<void> clearAll() async {
    await cache.clear();
    await syncQueue.clear();
    await settings.clear();
  }

  final Box<Map<dynamic, dynamic>> cache;
  final Box<Map<dynamic, dynamic>> syncQueue;
  final Box<Object?> settings;

  /// Stores [json] (anything `jsonEncode` accepts) under [key] with the time.
  Future<void> putCache(String key, Object? json, {DateTime? fetchedAt}) async {
    try {
      await cache.put(key, {
        'value': jsonEncode(json),
        'fetchedAt': (fetchedAt ?? DateTime.now()).toUtc().toIso8601String(),
      });
    } catch (_) {
      throw const CacheException();
    }
  }

  /// The entry under [key], or null if there is none. Throws
  /// [CacheException] if it can't be read.
  CacheEntry<T>? readCache<T>(String key, T Function(Object? json) fromJson) {
    final raw = cache.get(key);
    if (raw == null) return null;
    try {
      return CacheEntry(
        fromJson(jsonDecode(raw['value'] as String)),
        DateTime.parse(raw['fetchedAt'] as String),
      );
    } catch (_) {
      throw const CacheException();
    }
  }

  Future<void> removeCache(String key) => cache.delete(key);

  Future<void> close() => Hive.close();
}

/// Opened in `main.dart` and injected with `overrideWithValue`.
@Riverpod(keepAlive: true)
HiveService hiveService(Ref ref) => throw UnimplementedError(
  'Override hiveServiceProvider after HiveService.init().',
);
