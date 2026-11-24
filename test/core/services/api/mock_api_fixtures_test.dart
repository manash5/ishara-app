import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:ishara_app/core/services/api/api_response.dart';
import 'package:ishara_app/core/services/api/mock_api_adapter.dart';
import 'package:ishara_app/features/auth/data/models/auth_session_dto.dart';
import 'package:ishara_app/features/dictionary/data/models/sign_dto.dart';
import 'package:ishara_app/features/learn/data/models/path_dto.dart';
import 'package:ishara_app/features/lesson/data/models/lesson_dto.dart';
import 'package:ishara_app/features/lesson/data/models/lesson_result_dto.dart';
import 'package:ishara_app/features/profile/data/models/user_profile_dto.dart';
import 'package:ishara_app/features/ranks/data/models/weekly_leaderboard_dto.dart';

import '../../../helpers/mock_api.dart';

/// Every fixture name (`auth/login_200`), from the files on disk.
List<String> fixtureNames() {
  final root = Directory(MockApiAdapter.fixtureRoot);
  return [
    for (final f in root.listSync(recursive: true).whereType<File>())
      if (f.path.endsWith('.json'))
        f.path
            .replaceAll(r'\', '/')
            .split(MockApiAdapter.fixtureRoot)
            .last
            .replaceAll('.json', ''),
  ]..sort();
}

final _uuid = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
);

/// Every `id` / `*Id` string value anywhere in [json].
Iterable<String> _ids(Object? json) sync* {
  if (json is Map) {
    for (final MapEntry(:key, :value) in json.entries) {
      if ((key == 'id' || '$key'.endsWith('Id')) && value is String) {
        yield value;
      }
      yield* _ids(value);
    }
  } else if (json is List) {
    for (final v in json) {
      yield* _ids(v);
    }
  }
}

void main() {
  final names = fixtureNames();

  test('there are fixtures', () => expect(names.length, greaterThan(30)));

  group('every fixture is a valid envelope', () {
    for (final name in names) {
      test(name, () {
        final json = fixture(name);
        final envelope = ApiEnvelope.fromJson(json, (d) => d);
        final status = envelope.status;

        // File names end in their HTTP status (`login_401`).
        final suffix = RegExp(r'_(\d{3})$').firstMatch(name)?.group(1);
        if (suffix != null) expect(status, int.parse(suffix));

        expect(envelope.success, status < 400);
        expect(envelope.message, isNotEmpty);
        if (status >= 400) {
          expect(json.containsKey('data'), isFalse);
          expect(envelope.meta, isNull);
        }
        if (envelope.meta case final meta?) {
          expect(envelope.data, isA<List<Object?>>());
          expect(meta.totalPages, (meta.total / meta.limit).ceil());
          expect(
            (envelope.data! as List).length,
            lessThanOrEqualTo(meta.limit),
          );
        }
        for (final id in _ids(json)) {
          expect(id, matches(_uuid), reason: '$name: $id');
        }
      });
    }
  });

  test('every fixture is served by a mock route, and every route fixture '
      'exists', () {
    final served = MockApiAdapter().fixtures;
    expect(served.toSet(), names.toSet());
  });

  group('DTOs parse their fixtures', () {
    Map<String, dynamic> data(String name) => fixtureData(name);

    test('session', () {
      for (final name in [
        'auth/login_200',
        'auth/register_201',
        'auth/google_200',
        'auth/refresh_200',
        'auth/reset_password_200',
      ]) {
        final session = AuthSessionDto.fromJson(data(name)).toEntity();
        expect(session.user.email, isNotEmpty, reason: name);
      }
    });

    test('profile', () {
      for (final name in ['me/get_200', 'me/put_200', 'me/onboarding_200']) {
        final p = UserProfileDto.fromJson(data(name)).toEntity();
        expect(p.stats.weekXp, hasLength(7), reason: name);
      }
      final me = UserProfileDto.fromJson(data('me/get_200')).toEntity();
      expect(me.stats.totalXp, 1240);
      expect(me.stats.weeklyXp, 480);
      expect(me.stats.practisedDays, everyElement(isTrue));
    });

    test('path', () {
      final units = PathDto.fromJson(data('path/get_200')).toEntity();
      expect(units, hasLength(4));
      expect(units.first.stops.where((s) => s.lesson != null), hasLength(6));
    });

    test('lesson', () {
      final lesson = LessonDto.fromJson(data('lessons/get_200')).toEntity();
      expect(lesson.exercises, hasLength(6));
      expect(lesson.summary!.title, 'Thank you');
    });

    test('lesson results', () {
      for (final name in [
        'lessons/complete_200',
        'lessons/complete_replay_200',
      ]) {
        final result = LessonResultDto.fromJson(data(name)).toEntity();
        expect(result.xpEarned, 15, reason: name);
        expect(result.duration, const Duration(minutes: 4, seconds: 12));
      }
      final sync = data('progress/sync_200')['results'] as List;
      expect(sync.map((r) => (r as Map)['status']), [
        'applied',
        'duplicate',
        'rejected',
      ]);
    });

    test('signs', () {
      for (final name in [
        'signs/list_page1',
        'signs/list_page2',
        'signs/list_category',
        'signs/list_search',
      ]) {
        for (final s in fixtureData<List<dynamic>>(name)) {
          SignDto.fromJson(s as Map<String, dynamic>).toEntity();
        }
      }
      final namaste = SignDto.fromJson(data('signs/get_200')).toEntity();
      expect(namaste.etiquetteTip, isNotNull);
      // No invented NSL text (CLAUDE.md content rule).
      expect(namaste.meaning, isNull);
      expect(namaste.steps, isEmpty);
    });

    test('leaderboard', () {
      final board = WeeklyLeaderboardDto.fromJson(
        data('leaderboard/weekly_200'),
      ).toEntity();
      expect(board.entries, hasLength(10));
      expect(board.entries.where((e) => e.isMe), hasLength(1));
    });
  });
}
