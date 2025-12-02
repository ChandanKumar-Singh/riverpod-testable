import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/core/di/providers.dart';
import 'package:testable/shared/localization/supported_locales.dart';

class LangSwitcher extends ConsumerStatefulWidget {
  const LangSwitcher({super.key});
  static const buttonKey = 'global_lang_switcher';
  @override
  ConsumerState<LangSwitcher> createState() => _LangSwitcherState();
}

class _LangSwitcherState extends ConsumerState<LangSwitcher>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(langProvider);
    final currentTheme = Theme.of(context);
    final isDark = currentTheme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.grey[100],
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Locale>(
          key: const Key(LangSwitcher.buttonKey),
          value: locale,
          isDense: true,
          borderRadius: BorderRadius.circular(12),
          dropdownColor: isDark ? Colors.grey[900] : Colors.white,
          icon: AnimatedRotation(
            turns: _isOpen ? 0.5 : 0,
            duration: const Duration(milliseconds: 200),
            child: Icon(
              Icons.language_rounded,
              color: isDark ? Colors.white70 : Colors.black87,
              size: 22,
            ),
          ),
          onChanged: (newLocale) async {
            if (newLocale != null) {
              await ref.read(langProvider.notifier).setLocale(newLocale);
              setState(() => _isOpen = false);
            }
          },
          onTap: () {
            setState(() => _isOpen = !_isOpen);
          },
          items: SupportedLocales.all.map((loc) {
            final name = SupportedLocales.localeName(loc);
            final flag = SupportedLocales.localeFlag(loc);
            return DropdownMenuItem(
              value: loc,
              child: Row(
                children: [
                  Text(flag, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
