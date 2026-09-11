import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/l10n/generated/app_localizations.dart';
import 'package:gompa_tour/states/statue_state.dart';
import 'package:gompa_tour/states/recent_search.dart';
import 'package:gompa_tour/ui/widget/gonpa_app_bar.dart';
import 'package:gompa_tour/util/search_debouncer.dart';

import '../widget/deity_card_item.dart';

enum ViewType { grid, list }

class DeitiesListScreen extends ConsumerStatefulWidget {
  static const String routeName = '/deties-list';

  const DeitiesListScreen({super.key});

  @override
  ConsumerState<DeitiesListScreen> createState() => _DeitiesListScreenState();
}

class _DeitiesListScreenState extends ConsumerState<DeitiesListScreen> {
  ViewType _currentView = ViewType.grid;
  late StatueNotifier statueNotifier;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final _searchDebouncer = SearchDebouncer();

  @override
  void initState() {
    super.initState();
    statueNotifier = ref.read(statueNotifierProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      statueNotifier.fetchInitialStatues();
    });
  }

  void _performSearch(String query) async {
    _searchDebouncer.run(
      query,
      onSearch: (q) =>
          ref.read(statueNotifierProvider.notifier).searchStatues(q),
      onSaveSearch: (q) =>
          ref.read(recentSearchesProvider.notifier).addSearch(q),
      onClearResults: statueNotifier.fetchInitialStatues,
    );
  }

  @override
  Widget build(BuildContext context) {
    final statueState = ref.watch(statueNotifierProvider);

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: GonpaAppBar(title: AppLocalizations.of(context)!.deities),
        body: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent &&
                !statueState.isLoading &&
                !statueState.hasReachedMax) {
              statueNotifier.fetchMoreStatues();
            }
            return false;
          },
          child: Column(
            children: [
              _buildSearchBar(context),
              _buildToggleView(),
              statueState.isLoading &&
                      (statueState.statues.isEmpty ||
                          _searchController.text.isNotEmpty)
                  ? const Center(child: CircularProgressIndicator())
                  : statueState.statues.isEmpty
                      ? Center(
                          child: Text(
                            AppLocalizations.of(context)!.noRecordFound,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        )
                      : Expanded(
                          child: _currentView == ViewType.list
                              ? ListView.builder(
                                  padding: const EdgeInsets.only(bottom: 100),
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: statueState.statues.length +
                                      (statueState.isLoading ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index == statueState.statues.length) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    final statue = statueState.statues[index];

                                    return DeityCardItem(
                                      statue: statue,
                                    );
                                  },
                                )
                              : GridView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.only(
                                    left: 16,
                                    right: 16,
                                    top: 0,
                                    bottom: 100,
                                  ),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.75,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                  ),
                                  itemCount: statueState.statues.length +
                                      (statueState.isLoading ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index == statueState.statues.length) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    final statue = statueState.statues[index];
                                    return DeityCardItem(
                                      statue: statue,
                                      isGridView: true,
                                    );
                                  },
                                ),
                        ),
            ],
          ),
        ));
  }

  Widget _buildToggleView() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context)!.deities,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outlineVariant
                    .withValues(alpha: 0.3),
              ),
            ),
            padding: const EdgeInsets.all(2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    setState(() {
                      _currentView = ViewType.list;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: _currentView == ViewType.list
                          ? Theme.of(context).colorScheme.surface
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: _currentView == ViewType.list
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              )
                            ]
                          : null,
                    ),
                    child: Icon(
                      Icons.list_alt,
                      size: 20,
                      color: _currentView == ViewType.list
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.6),
                    ),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    setState(() {
                      _currentView = ViewType.grid;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: _currentView == ViewType.grid
                          ? Theme.of(context).colorScheme.surface
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: _currentView == ViewType.grid
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              )
                            ]
                          : null,
                    ),
                    child: Icon(
                      Icons.grid_view,
                      size: 20,
                      color: _currentView == ViewType.grid
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      child: SearchBar(
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) => Theme.of(context).colorScheme.surfaceContainer,
        ),
        controller: _searchController,
        focusNode: _searchFocusNode,
        leading: Icon(Icons.search),
        trailing: [
          _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    statueNotifier.fetchInitialStatues();
                  },
                )
              : const SizedBox(),
        ],
        hintText: AppLocalizations.of(context)!.search,
        onChanged: (value) {
          _performSearch(value);
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
}
