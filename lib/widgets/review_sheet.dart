import 'package:flutter/material.dart';

import '../shift.dart';
import '../theme/app_colors.dart';

/// Результат окна оценки.
class ReviewInput {
  final int rating;
  final String? comment;

  const ReviewInput({required this.rating, this.comment});
}

/// Окно «оцените место работы» — его открывает исполнитель.
Future<ReviewInput?> showReviewSheet(BuildContext context, Shift shift) {
  return showRatingSheet(
    context,
    title: 'Как прошла смена?',
    subtitle: '${shift.company} · ${shift.workDate.day} '
        '${monthsShort[shift.workDate.month - 1]}',
    hint: 'Что понравилось или нет? Это увидят другие исполнители',
  );
}

/// Общее окно оценки: пять звёзд и необязательный комментарий.
///
/// Раньше это окно умело оценивать только смену и принимало `Shift`.
/// Теперь оно принимает просто тексты, и тем же окном заказчик оценивает
/// исполнителя. Приём обычный: как только код понадобился второй раз,
/// из него убирают всё лишнее — и он начинает подходить обоим.
Future<ReviewInput?> showRatingSheet(
  BuildContext context, {
  required String title,
  required String subtitle,
  required String hint,
  String buttonLabel = 'Отправить отзыв',
}) {
  return showModalBottomSheet<ReviewInput>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _ReviewSheet(
      title: title,
      subtitle: subtitle,
      hint: hint,
      buttonLabel: buttonLabel,
    ),
  );
}

class _ReviewSheet extends StatefulWidget {
  final String title;
  final String subtitle;
  final String hint;
  final String buttonLabel;

  const _ReviewSheet({
    required this.title,
    required this.subtitle,
    required this.hint,
    required this.buttonLabel,
  });

  @override
  State<_ReviewSheet> createState() => _ReviewSheetState();
}

class _ReviewSheetState extends State<_ReviewSheet> {
  int rating = 0;
  final commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  static const _labels = [
    'Выберите оценку',
    'Плохо',
    'Так себе',
    'Нормально',
    'Хорошо',
    'Отлично',
  ];

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        // Поднимаем окно над клавиатурой, когда она открыта.
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.muted.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.title,
                    style: text.headlineSmall?.copyWith(fontSize: 21),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.subtitle,
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Пять звёзд. Оценка обязательна, комментарий — нет.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 1; i <= 5; i++)
                        IconButton(
                          onPressed: () => setState(() => rating = i),
                          icon: Icon(
                            i <= rating
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            size: 38,
                            color: i <= rating
                                ? AppColors.accent
                                : AppColors.muted.withValues(alpha: 0.5),
                          ),
                        ),
                    ],
                  ),
                  Center(
                    child: Text(
                      _labels[rating],
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color:
                            rating == 0 ? AppColors.muted : AppColors.accent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: commentController,
                    maxLines: 3,
                    maxLength: 300,
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      filled: true,
                      fillColor: isDark ? AppColors.darkBg : AppColors.bg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color:
                              isDark ? AppColors.darkBorder : AppColors.border,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color:
                              isDark ? AppColors.darkBorder : AppColors.border,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                            const BorderSide(color: AppColors.brand, width: 1.6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SafeArea(
                    top: false,
                    child: FilledButton(
                      // Пока звёзды не выбраны — отправлять нечего.
                      onPressed: rating == 0
                          ? null
                          : () => Navigator.of(context).pop(
                                ReviewInput(
                                  rating: rating,
                                  comment:
                                      commentController.text.trim().isEmpty
                                          ? null
                                          : commentController.text.trim(),
                                ),
                              ),
                      child: Text(widget.buttonLabel),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
