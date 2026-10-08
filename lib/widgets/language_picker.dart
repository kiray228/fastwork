import 'package:flutter/material.dart';

import '../data/app_preferences.dart';
import '../l10n/strings.dart';
import '../theme/app_colors.dart';
import '../theme/glass.dart';

/// Выбрать язык: қазақша, русский, English.
///
/// Языки подписаны каждый на самом себе. Человек, которому приложение
/// досталось на непонятном языке, всё равно найдёт в списке свой.
Future<void> pickLanguage(
  BuildContext context,
  AppPreferences preferences,
) async {
  final picked = await showModalBottomSheet<Lang>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => GlassSheet(
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SheetHandle(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Text(
                tr.common.language,
                style: Theme.of(sheetContext)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontSize: 20),
              ),
            ),
            for (final lang in Lang.values)
              ListTile(
                leading: const Icon(Icons.translate_rounded,
                    color: AppColors.brand),
                title: Text(lang.selfName),
                trailing: lang == preferences.language
                    ? const Icon(Icons.check_rounded, color: AppColors.brand)
                    : null,
                onTap: () => Navigator.of(sheetContext).pop(lang),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    ),
  );
  if (picked != null) await preferences.setLanguage(picked);
}

/// Кнопка языка для экрана входа: «Русский ▾».
///
/// Язык нужно уметь сменить ещё до входа — иначе человек, который не
/// читает по-русски, не поймёт, что от него хотят на первом же экране.
class LanguageButton extends StatelessWidget {
  final AppPreferences preferences;

  const LanguageButton({super.key, required this.preferences});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => pickLanguage(context, preferences),
      icon: const Icon(Icons.translate_rounded, size: 18),
      label: Text(preferences.language.selfName),
    );
  }
}
