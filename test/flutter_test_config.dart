import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/services/storage/hive_service.dart';

import 'helpers/test_hive.dart';

/// Runs around every test file: opens in-memory Hive boxes once and empties
/// them before each test, so caches and the sync queue never leak between
/// tests and nothing touches the disk.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestHive.instance = await HiveService.inMemory();
  setUp(() => TestHive.instance.clearAll());
  await testMain();
}
