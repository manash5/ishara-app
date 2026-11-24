import '../../../../core/services/api/api_client.dart';
import '../../../../core/services/api/api_endpoints.dart';
import '../../../../core/services/api/api_response.dart';
import '../models/sign_dto.dart';

/// `/signs` over the REST API. Throws `AppException`.
class SignRemoteDataSource {
  const SignRemoteDataSource(this._api);

  /// Signs per page the app asks for (the API allows up to 100).
  static const pageSize = 50;

  final ApiClient _api;

  /// One page of signs, optionally filtered by [category] (`Sign.category`
  /// wire name) and [search]. Blank filters are left out of the query.
  Future<ApiEnvelope<List<SignDto>>> fetchPage({
    int page = 1,
    String? category,
    String? search,
  }) async {
    final response = await _api.get(
      ApiEndpoints.getSigns,
      queryParameters: {
        'page': page,
        'limit': pageSize,
        if (category != null && category.isNotEmpty) 'category': category,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    return ApiEnvelope.fromJson(
      response.data,
      (d) => [
        for (final s in d! as List) SignDto.fromJson(s as Map<String, dynamic>),
      ],
    );
  }

  /// Every page (with the same filters), in order.
  Future<List<SignDto>> fetchAll({String? category, String? search}) async {
    final signs = <SignDto>[];
    for (var page = 1; ; page++) {
      final envelope = await fetchPage(
        page: page,
        category: category,
        search: search,
      );
      signs.addAll(envelope.data ?? const []);
      if (!(envelope.meta?.hasNextPage ?? false)) return signs;
    }
  }

  /// One sign with its details (`GET /signs/:id`).
  Future<SignDto> fetchSign(String signId) async {
    final response = await _api.get(ApiEndpoints.getSignById(signId));
    return ApiEnvelope.fromJson(
      response.data,
      (d) => SignDto.fromJson(d! as Map<String, dynamic>),
    ).requireData;
  }
}
