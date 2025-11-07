import 'package:flutter/material.dart';
import 'package:flmhaiti_fall25team/localization/l10n_extension.dart';
import 'package:flmhaiti_fall25team/localization/locale_scope.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final controller = LocaleScope.of(context);
    final currentLocale = controller.locale ?? Localizations.localeOf(context);

    final options = _languageOptions(context);
    final selected = options.firstWhere(
      (option) => option.locale.languageCode == currentLocale.languageCode,
      orElse: () => options.first,
    );

    final dropdown = DropdownButton<Locale>(
      value: selected.locale,
      onChanged: (value) {
        if (value != null) {
          controller.setLocale(value);
        }
      },
      borderRadius: BorderRadius.circular(8),
      icon: compact
          ? const Icon(Icons.language_outlined)
          : const Icon(Icons.arrow_drop_down),
      underline: const SizedBox.shrink(),
      items: options
          .map(
            (option) => DropdownMenuItem<Locale>(
              value: option.locale,
              child: Text(option.label),
            ),
          )
          .toList(),
    );

    if (compact) {
      return dropdown;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.languageSelectorLabel,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: dropdown,
        ),
      ],
    );
  }

  List<_LanguageOption> _languageOptions(BuildContext context) {
    return [
      _LanguageOption(locale: const Locale('en'), label: context.l10n.languageEnglish),
      _LanguageOption(locale: const Locale('fr'), label: context.l10n.languageFrench),
      _LanguageOption(locale: const Locale('ht'), label: context.l10n.languageHaitianCreole),
    ];
  }
}

class _LanguageOption {
  const _LanguageOption({required this.locale, required this.label});

  final Locale locale;
  final String label;
}
