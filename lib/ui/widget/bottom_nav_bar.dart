import 'package:flutter/material.dart';
import 'package:gompa_tour/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/style.dart';
import '../../states/bottom_nav_state.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int navIndex = (ref.watch(bottomNavProvider) as int?) ?? 0;
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    final items = [
      (Icons.home, AppLocalizations.of(context)!.home),
      (Icons.map, AppLocalizations.of(context)!.map),
      (Icons.qr_code, AppLocalizations.of(context)!.qr),
      (Icons.person, AppLocalizations.of(context)!.settings),
    ];

    return Card(
      margin: EdgeInsets.zero,
      elevation: theme.bottomNavigationBarTheme.elevation ?? 8,
      shadowColor: theme.colorScheme.shadow,
      color: theme.bottomNavigationBarTheme.backgroundColor ?? theme.colorScheme.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.only(
          topLeft: Style.radiusLg,
          topRight: Style.radiusLg,
        ),
        side: BorderSide(
          color: theme.shadowColor,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: 18,
          bottom: bottomPadding > 0 ? bottomPadding + 10 : 18,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(items.length, (index) {
            final isSelected = index == navIndex;
            final item = items[index];
            return InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                ref.read(bottomNavProvider.notifier).setAndPersistValue(index);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Icon(
                  item.$1,
                  size: 32,
                  color: isSelected
                      ? (theme.bottomNavigationBarTheme.selectedItemColor ?? theme.colorScheme.primary)
                      : (theme.bottomNavigationBarTheme.unselectedItemColor ??
                          theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
