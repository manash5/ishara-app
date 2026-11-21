import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/dictionary_models.dart';
import '../providers/dictionary_providers.dart';
import '../widgets/category_filter_bar.dart';
import '../widgets/dictionary_hero_header.dart';
import '../widgets/dictionary_search_field.dart';
import '../widgets/dictionary_state_message.dart';
import '../widgets/sign_status_tone.dart';

/// Figma "13 Dictionary" (Light 12:820 · Dark 60:6816): a tab root in the
/// bottom-bar shell. Hero header with search, then a content panel with the
/// "All signs" section, category filters and the sign list.
class DictionaryScreen extends ConsumerWidget {
  const DictionaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final count = ref.watch(dictionarySignsProvider).value?.length;
    final category = ref.watch(dictionaryCategoryProvider);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      // White status-bar icons over the teal hero.
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: c.bgSurface,
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(
            bottom:
                IsharaSizes.bottomBarContentPadding -
                IsharaSpacing.screenMargin,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DictionaryHeroHeader(
                title: 'Dictionary',
                subtitle: count == null
                    ? 'Nepali Sign Language'
                    : '$count signs · Nepali Sign Language',
                bottom: const DictionarySearchField(),
              ),
              ContentPanel(
                children: [
                  SectionHeader(
                    title: 'All signs',
                    actionLabel: 'A–Z',
                    onAction: () => ref
                        .read(dictionarySortAlphabeticalProvider.notifier)
                        .toggle(),
                  ),
                  CategoryFilterBar(
                    selected: category,
                    onSelected: (value) => ref
                        .read(dictionaryCategoryProvider.notifier)
                        .select(value),
                  ),
                  const _SignList(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignList extends ConsumerWidget {
  const _SignList();

  void _clearFilters(WidgetRef ref) {
    ref.read(dictionaryQueryProvider.notifier).setQuery('');
    ref.read(dictionaryCategoryProvider.notifier).select(null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signs = ref.watch(filteredDictionarySignsProvider);
    return switch (signs) {
      AsyncValue(:final value?, hasValue: true) => _data(context, ref, value),
      AsyncValue(hasError: true) => DictionaryStateMessage(
        title: 'Couldn’t load signs',
        body: 'Check your connection and try again.',
        actionLabel: 'Try again',
        onAction: () => ref.invalidate(dictionarySignsProvider),
      ),
      _ => const SignListSkeleton(),
    };
  }

  Widget _data(BuildContext context, WidgetRef ref, List<DictionarySign> list) {
    if (list.isEmpty) {
      final filtered =
          ref.watch(dictionaryQueryProvider).trim().isNotEmpty ||
          ref.watch(dictionaryCategoryProvider) != null;
      if (!filtered) {
        return const DictionaryStateMessage(
          title: 'No signs yet',
          body: 'Signs you can learn will appear here.',
        );
      }
      final query = ref.watch(dictionaryQueryProvider).trim();
      return DictionaryStateMessage(
        title: 'No signs found',
        body: query.isEmpty
            ? 'There are no signs in this category yet.'
            : 'No signs match “$query”.',
        actionLabel: 'Clear search',
        onAction: () => _clearFilters(ref),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < list.length; i++) ...[
          if (i > 0) const SizedBox(height: IsharaSpacing.s2),
          SignListTile(
            title: list[i].name,
            subtitle: list[i].category.label,
            statusLabel: list[i].status.label,
            statusTone: list[i].status.chipTone,
            onTap: () => SignDetailRoute(signId: list[i].id).go(context),
          ),
        ],
      ],
    );
  }
}
