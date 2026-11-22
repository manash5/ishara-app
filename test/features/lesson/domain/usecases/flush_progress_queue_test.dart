import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/error/result.dart';
import 'package:ishara_app/features/lesson/domain/entities/progress_sync_report.dart';
import 'package:ishara_app/features/lesson/domain/repositories/lesson_repository.dart';
import 'package:ishara_app/features/lesson/domain/usecases/flush_progress_queue.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements LessonRepository {}

void main() {
  late _MockRepo repo;
  setUp(() => repo = _MockRepo());

  test('FlushProgressQueue returns the report', () async {
    const report = ProgressSyncReport(duplicates: 1);
    when(() => repo.flushQueue()).thenAnswer((_) async => const Ok(report));

    expect((await FlushProgressQueue(repo)()).valueOrNull, report);
  });

  test('retry delay doubles from 30 s and caps at 30 min', () {
    expect(FlushProgressQueue.retryDelay(0), const Duration(seconds: 30));
    expect(FlushProgressQueue.retryDelay(1), const Duration(seconds: 30));
    expect(FlushProgressQueue.retryDelay(2), const Duration(minutes: 1));
    expect(FlushProgressQueue.retryDelay(3), const Duration(minutes: 2));
    expect(FlushProgressQueue.retryDelay(6), const Duration(minutes: 16));
    expect(FlushProgressQueue.retryDelay(7), const Duration(minutes: 30));
    expect(FlushProgressQueue.retryDelay(100), const Duration(minutes: 30));
  });
}
