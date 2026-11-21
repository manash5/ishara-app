import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/dictionary_providers.dart';

/// Figma "13 Dictionary" search field (IsharaTextField instance 12:834 with
/// the label hidden and a search leading icon).
class DictionarySearchField extends ConsumerStatefulWidget {
  const DictionarySearchField({super.key});

  @override
  ConsumerState<DictionarySearchField> createState() =>
      _DictionarySearchFieldState();
}

class _DictionarySearchFieldState extends ConsumerState<DictionarySearchField> {
  late final TextEditingController _controller = TextEditingController(
    text: ref.read(dictionaryQueryProvider),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setQuery(String value) =>
      ref.read(dictionaryQueryProvider.notifier).setQuery(value);

  @override
  Widget build(BuildContext context) {
    // Keep the field in sync when the query is cleared elsewhere
    // (e.g. the no-results "Clear search" action).
    ref.listen(dictionaryQueryProvider, (_, next) {
      if (_controller.text != next) _controller.text = next;
    });
    final query = ref.watch(dictionaryQueryProvider);
    return IsharaTextField(
      label: 'Search signs',
      showLabel: false,
      hint: 'Search signs',
      controller: _controller,
      onChanged: _setQuery,
      textInputAction: TextInputAction.search,
      prefixIcon: IsharaIcons.search,
      suffixIcon: query.isEmpty
          ? null
          : IsharaIconButton(
              icon: IsharaIcons.close,
              tooltip: 'Clear search',
              color: context.colors.textSecondary,
              compact: true,
              onPressed: () => _setQuery(''),
            ),
    );
  }
}
