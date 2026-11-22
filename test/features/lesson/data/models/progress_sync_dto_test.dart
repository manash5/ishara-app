import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/features/lesson/data/models/progress_sync_dto.dart';

import '../../../../helpers/mock_api.dart';

void main() {
  test('parses progress/sync_200: applied, duplicate, rejected', () {
    final dto = ProgressSyncDto.fromJson(fixtureData('progress/sync_200'));
    expect(dto.results.map((r) => r.status), [
      SyncEventStatus.applied,
      SyncEventStatus.duplicate,
      SyncEventStatus.rejected,
    ]);
    expect(dto.results.first.result!.toEntity().xpEarned, 15);
    expect(dto.results.last.result, isNull);
    expect(dto.results.last.message, 'Lesson not found.');
  });

  test('an unknown status parses as unknown (kept in the queue)', () {
    final dto = SyncEventResultDto.fromJson({
      'clientEventId': 'e-1',
      'status': 'deferred',
      'message': null,
      'result': null,
    });
    expect(dto.status, SyncEventStatus.unknown);
  });
}
