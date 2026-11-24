import '../../error/app_exception.dart';

/// The API envelope: `{ status, success, message, data, meta? }`.
class ApiEnvelope<T> {
  const ApiEnvelope({
    required this.status,
    required this.success,
    required this.message,
    this.data,
    this.meta,
  });

  /// Parses [json]; [parseData] turns a non-null `data` into a [T].
  /// Throws [UnknownException] when [json] isn't an envelope.
  factory ApiEnvelope.fromJson(
    Object? json,
    T Function(Object? data) parseData,
  ) {
    if (json is! Map<String, dynamic>) throw const UnknownException();
    final raw = json['data'];
    final meta = json['meta'];
    return ApiEnvelope(
      status: (json['status'] as num?)?.toInt() ?? 0,
      success: json['success'] == true,
      message: json['message'] as String? ?? '',
      data: raw == null ? null : parseData(raw),
      meta: meta is Map<String, dynamic> ? PaginationMeta.fromJson(meta) : null,
    );
  }

  final int status;
  final bool success;
  final String message;
  final T? data;
  final PaginationMeta? meta;

  /// [data], or [UnknownException] if the server sent none.
  T get requireData => data ?? (throw const UnknownException());
}

/// `meta = { page, limit, total, totalPages }` on paginated lists.
class PaginationMeta {
  const PaginationMeta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) => PaginationMeta(
    page: (json['page'] as num).toInt(),
    limit: (json['limit'] as num).toInt(),
    total: (json['total'] as num).toInt(),
    totalPages: (json['totalPages'] as num).toInt(),
  );

  final int page;
  final int limit;
  final int total;
  final int totalPages;

  bool get hasNextPage => page < totalPages;
}
