import 'package:flutter/foundation.dart';

/// One change made offline (or while the server failed), waiting in the
/// `syncQueue` Hive box until `POST /progress/sync` accepts it. Keyed by
/// [clientEventId], which also makes replays idempotent on the server.
@immutable
class SyncEvent {
  const SyncEvent({
    required this.clientEventId,
    required this.type,
    required this.payload,
    required this.occurredAt,
    required this.queuedAt,
    this.failedFlushes = 0,
  });

  /// Reads a stored event. Also accepts the lesson feature's earlier format
  /// (`{attempt, queuedAt, failedFlushes}`), so nothing queued is lost.
  factory SyncEvent.fromJson(Map<String, dynamic> json) {
    if (json['attempt'] case final Map<String, dynamic> attempt) {
      final payload = Map<String, dynamic>.of(attempt)..remove('clientEventId');
      return SyncEvent(
        clientEventId: attempt['clientEventId'] as String,
        type: lessonComplete,
        payload: payload,
        occurredAt: DateTime.parse(attempt['completedAt'] as String),
        queuedAt: DateTime.parse(json['queuedAt'] as String),
        failedFlushes: (json['failedFlushes'] as num?)?.toInt() ?? 0,
      );
    }
    return SyncEvent(
      clientEventId: json['clientEventId'] as String,
      type: json['type'] as String,
      payload: Map<String, dynamic>.of(json['payload'] as Map<String, dynamic>),
      occurredAt: DateTime.parse(json['occurredAt'] as String),
      queuedAt: DateTime.parse(json['queuedAt'] as String),
      failedFlushes: (json['failedFlushes'] as num?)?.toInt() ?? 0,
    );
  }

  /// `type` of a finished lesson (docs/api-contract.md → Progress).
  static const lessonComplete = 'lessonComplete';

  final String clientEventId;
  final String type;

  /// The event's fields besides `clientEventId` and `type` (JSON values).
  final Map<String, dynamic> payload;

  /// When it happened on the device (orders the queue, oldest first).
  final DateTime occurredAt;

  /// When it was queued (breaks ties).
  final DateTime queuedAt;

  /// Flushes that failed while it was queued.
  final int failedFlushes;

  /// One entry of the `POST /progress/sync` `events` list.
  Map<String, dynamic> toWire() => {
    'clientEventId': clientEventId,
    'type': type,
    ...payload,
  };

  Map<String, dynamic> toJson() => {
    'clientEventId': clientEventId,
    'type': type,
    'payload': payload,
    'occurredAt': occurredAt.toUtc().toIso8601String(),
    'queuedAt': queuedAt.toUtc().toIso8601String(),
    'failedFlushes': failedFlushes,
  };

  SyncEvent withFailedFlush() => SyncEvent(
    clientEventId: clientEventId,
    type: type,
    payload: payload,
    occurredAt: occurredAt,
    queuedAt: queuedAt,
    failedFlushes: failedFlushes + 1,
  );
}

/// What one flush did.
@immutable
class SyncReport {
  const SyncReport({
    this.applied = const [],
    this.duplicates = 0,
    this.rejected = 0,
    this.remaining = 0,
  });

  /// Events the server newly applied, with what it returned for each.
  final List<SyncApplied> applied;

  /// Events the server had already recorded (dropped from the queue).
  final int duplicates;

  /// Events the server can't apply (dropped; the contract says never retry).
  final int rejected;

  /// Events still waiting in the queue after this flush.
  final int remaining;
}

/// One newly applied event and the server's `result` for it (e.g. a
/// LessonResult for `lessonComplete`), for features to interpret.
@immutable
class SyncApplied {
  const SyncApplied({
    required this.clientEventId,
    required this.type,
    this.result,
  });

  final String clientEventId;
  final String type;
  final Map<String, dynamic>? result;
}
