import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/result.dart';
import '../../../../core/services/api/api_client.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/entities/lesson_result.dart';
import '../../domain/repositories/lesson_repository.dart';
import '../datasources/lesson_remote_data_source.dart';

part 'lesson_repository_impl.g.dart';

class LessonRepositoryImpl implements LessonRepository {
  const LessonRepositoryImpl(this._remote);

  final LessonRemoteDataSource _remote;

  @override
  Future<Result<Lesson>> getLesson(String lessonId) =>
      guard(() async => (await _remote.fetchLesson(lessonId)).toEntity());

  @override
  Future<Result<LessonResult>> completeLesson(LessonAttempt attempt) =>
      guard(() async => (await _remote.completeLesson(attempt)).toEntity());
}

@Riverpod(keepAlive: true)
LessonRepository lessonRepository(Ref ref) =>
    LessonRepositoryImpl(LessonRemoteDataSource(ref.watch(apiClientProvider)));
