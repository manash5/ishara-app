import '../../../../core/error/result.dart';
import '../entities/sign.dart';
import '../repositories/sign_repository.dart';

/// Server-side search and category filter (falls back to the cached list
/// offline). [query] is trimmed; blank means no search.
class SearchSigns {
  const SearchSigns(this._repository);

  final SignRepository _repository;

  Future<Result<List<Sign>>> call({
    String query = '',
    SignCategory? category,
  }) => _repository.searchSigns(query: query.trim(), category: category);
}
