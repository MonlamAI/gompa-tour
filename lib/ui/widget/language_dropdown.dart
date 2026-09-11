import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/states/language_state.dart';

class LanguageDropdown extends ConsumerWidget {
  final bool showIcon;
  final bool isCompact;
  final ValueChanged<String>? onChanged;

  const LanguageDropdown({
    super.key,
    this.showIcon = true,
    this.isCompact = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageState = ref.watch(languageProvider);
    final currentCode = languageState.currentLanguage;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final dropdownBg = isDark ? const Color(0xFF27272a) : colorScheme.surface;
    final containerBg = isDark
        ? colorScheme.surfaceContainer
        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 10,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: containerBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark
              ? colorScheme.outline.withValues(alpha: 0.3)
              : colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentCode,
          alignment: Alignment.center,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: colorScheme.onSurface,
          ),
          elevation: 4,
          dropdownColor: dropdownBg,
          borderRadius: BorderRadius.circular(12),
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 14,
          ),
          onChanged: (String? val) {
            if (val != null) {
              ref.read(languageProvider.notifier).setLanguage(val);
              if (onChanged != null) {
                onChanged!(val);
              }
            }
          },
          selectedItemBuilder: (BuildContext context) {
            return LanguageState.supportedLanguages.map((lang) {
              return Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (showIcon) ...[
                      Icon(
                        Icons.language_rounded,
                        size: 16,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      isCompact ? lang.shortCode : lang.nativeName,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                        fontFamily: lang.fontFamily,
                      ),
                    ),
                  ],
                ),
              );
            }).toList();
          },
          items: LanguageState.supportedLanguages.map((lang) {
            final isSelected = lang.code == currentCode;
            return DropdownMenuItem<String>(
              value: lang.code,
              alignment: Alignment.center,
              child: Container(
                constraints: const BoxConstraints(minWidth: 90),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      lang.nativeName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                        fontFamily: lang.fontFamily,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 6),
                      Icon(
                        Icons.check_rounded,
                        size: 16,
                        color: colorScheme.primary,
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
