import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:gompa_tour/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/constants/state_data.dart';
import 'package:gompa_tour/constants/type_data.dart';
import 'package:gompa_tour/models/gonpa.dart';
import 'package:gompa_tour/states/gonpa_state.dart';
import 'package:gompa_tour/states/recent_search.dart';
import 'package:gompa_tour/ui/screen/deities_list_screen.dart';
import 'package:gompa_tour/ui/widget/gonpa_app_bar.dart';
import 'package:gompa_tour/ui/widget/organization_card_item.dart';
import 'package:gompa_tour/util/search_debouncer.dart';
import 'package:gompa_tour/util/string_extensions.dart';

class OrganizationListScreen extends ConsumerStatefulWidget {
  static const String routeName = '/organization-list';
  final String? sect;
  final List<Gonpa>? gonpas;

  const OrganizationListScreen({
    super.key,
    this.sect,
    this.gonpas,
  });

  @override
  ConsumerState createState() => _OrganizationListScreenState();
}

class _OrganizationListScreenState
    extends ConsumerState<OrganizationListScreen> {
  late GonpaNotifier gonpaNotifier;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final _searchDebouncer = SearchDebouncer();
  ViewType _currentView = ViewType.grid;
  String? _selectedType;
  String? _selectedState;

  @override
  void initState() {
    super.initState();
    // Fetch initial deities when the screen is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialGonpasByCategory();
    });
  }

  Future<void> _loadInitialGonpasByCategory() async {
    gonpaNotifier = ref.read(gonpaNotifierProvider.notifier);
    widget.sect == "ALL"
        ? gonpaNotifier.fetchInitialGonpas()
        : gonpaNotifier.fetchInitialGonpasBySect(widget.sect!);
  }

  void _performSearch(String query) async {
    _searchDebouncer.run(
      query,
      onSearch: (q) {
        // set types to null to show all types
        _selectedType = null;
        _selectedState = null;
        if (widget.sect == "ALL") {
          return gonpaNotifier.searchGonpas(q);
        } else {
          return gonpaNotifier.searchGonpasBySect(q, widget.sect!);
        }
      },
      onSaveSearch: (q) =>
          ref.read(recentSearchesProvider.notifier).addSearch(q),
      onClearResults: () =>
          gonpaNotifier.fetchInitialGonpasBySect(widget.sect!),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gonpaState = ref.watch(gonpaNotifierProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: GonpaAppBar(title: AppLocalizations.of(context)!.organization),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              !gonpaState.isLoading &&
              !gonpaState.hasReachedMax) {
            widget.sect == "ALL"
                ? gonpaNotifier.fetchMoreGonpas()
                : gonpaNotifier.fetchMoreGonpasBySect(widget.sect!);
          }
          return false;
        },
        child: Column(
          children: [
            _buildSearchBar(context),
            _buildToggleView(gonpaState),
            gonpaState.isLoading &&
                    (gonpaState.gonpas.isEmpty ||
                        _searchController.text.isEmpty)
                ? const Center(child: CircularProgressIndicator())
                : gonpaState.gonpas.isEmpty
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
                                itemCount: gonpaState.gonpas.length +
                                    (gonpaState.isLoading ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == gonpaState.gonpas.length) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  final gonpa = gonpaState.gonpas[index];

                                  return OrganizationCardItem(
                                    gonpa: gonpa,
                                  );
                                },
                              )
                            : GridView.builder(
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
                                physics: const BouncingScrollPhysics(),
                                itemCount: gonpaState.gonpas.length +
                                    (gonpaState.isLoading ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == gonpaState.gonpas.length) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  final gonpa = gonpaState.gonpas[index];

                                  return OrganizationCardItem(
                                    gonpa: gonpa,
                                    isGridView: true,
                                  );
                                },
                              ),
                      ),
          ],
        ),
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
                    _selectedType = null;
                    _selectedState = null;
                    _loadInitialGonpasByCategory();
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

  Widget _buildToggleView(GonpaListState gonpaState) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Grouped Container for gonpa types and states filters
          Expanded(
            child: Container(
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
              child: DropdownButtonHideUnderline(
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        underline: const SizedBox(),
                        value: _selectedType,
                    hint: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.category_outlined,
                            size: 13,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              AppLocalizations.of(context)!.gonpaTypes,
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    selectedItemBuilder: (BuildContext context) {
                      return TypeData.typeTranslations.entries.map((type) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.category_outlined,
                                size: 13,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                TypeData.getLocalizedTypeName(
                                  type.key,
                                  Localizations.localeOf(context).languageCode,
                                ),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        );
                      }).toList();
                    },
                    items: TypeData.typeTranslations.entries.map(
                      (type) => DropdownMenuItem<String>(
                        value: type.key,
                        child: Text(
                          TypeData.getLocalizedTypeName(
                            type.key,
                            Localizations.localeOf(context).languageCode,
                          ),
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedType = value;
                      });
                      gonpaNotifier.filterGonpas(
                        sect: widget.sect!,
                        type: value,
                        stateFilter: _selectedState,
                      );
                    },
                    buttonStyleData: ButtonStyleData(
                      height: 36,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: _selectedType != null
                            ? Theme.of(context).colorScheme.surface
                            : Colors.transparent,
                      ),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF27272a)
                            : Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                    iconStyleData: IconStyleData(
                      icon: _selectedType != null
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedType = null;
                                });
                                gonpaNotifier.filterGonpas(
                                  sect: widget.sect!,
                                  type: null,
                                  stateFilter: _selectedState,
                                );
                              },
                              child: Icon(
                                Icons.close,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.7),
                              ),
                            )
                          : Icon(
                              Icons.keyboard_arrow_down,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.7),
                            ),
                      ),
                    ),
                  ),
                  Container(
                    height: 18,
                    width: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    color: Theme.of(context)
                        .colorScheme
                        .outlineVariant
                        .withValues(alpha: 0.4),
                  ),
                  // dropdown for unique states
                  Expanded(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      underline: const SizedBox(),
                      value: _selectedState?.toUpperCase(),
                    hint: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.location_on_outlined,
                            size: 13,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              AppLocalizations.of(context)!.allStates,
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    selectedItemBuilder: (BuildContext context) {
                      return StateData.stateTranslationsForGonpa.entries.map((state) {
                        String stateName =
                            StateData.getLocalizedStateNameForGonpa(
                          state.key,
                          Localizations.localeOf(context).languageCode,
                        );
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.location_on_outlined,
                                size: 13,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                Localizations.localeOf(context).languageCode == "en"
                                    ? stateName.toPascalCase()
                                    : stateName,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        );
                      }).toList();
                    },
                    items: StateData.stateTranslationsForGonpa.entries.map(
                      (state) {
                        String stateName =
                            StateData.getLocalizedStateNameForGonpa(
                          state.key,
                          Localizations.localeOf(context).languageCode,
                        );
                        return DropdownMenuItem<String>(
                          value: state.key,
                          child: Text(
                            Localizations.localeOf(context).languageCode == "en"
                                ? stateName.toPascalCase()
                                : stateName,
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      },
                    ).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedState = value;
                      });
                      gonpaNotifier.filterGonpas(
                        sect: widget.sect!,
                        type: _selectedType,
                        stateFilter: value,
                      );
                    },
                    buttonStyleData: ButtonStyleData(
                      height: 36,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: _selectedState != null
                            ? Theme.of(context).colorScheme.surface
                            : Colors.transparent,
                      ),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF27272a)
                            : Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                    iconStyleData: IconStyleData(
                      icon: _selectedState != null
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedState = null;
                                });
                                gonpaNotifier.filterGonpas(
                                  sect: widget.sect!,
                                  type: _selectedType,
                                  stateFilter: null,
                                );
                              },
                              child: Icon(
                                Icons.close,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.7),
                              ),
                            )
                          : Icon(
                              Icons.keyboard_arrow_down,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.7),
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ),
          const SizedBox(width: 8),
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
}
