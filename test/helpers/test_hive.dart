import 'package:ishara_app/core/services/storage/hive_service.dart';

/// The in-memory [HiveService] opened by `test/flutter_test_config.dart`.
/// `mockApiOverrides()` (and so `pumpApp`) inject it as `hiveServiceProvider`;
/// its boxes are emptied before every test.
abstract final class TestHive {
  static late HiveService instance;
}
