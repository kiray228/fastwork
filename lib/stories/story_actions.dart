import 'package:flutter/material.dart';

import 'package:fastwork_core/data/shift_repository.dart';
import 'package:fastwork_core/mrp.dart';
import '../auth/terms_page.dart';
import '../data/app_preferences.dart';
import '../data/repositories.dart';
import '../data/session.dart';
import '../documents_page.dart';
import '../my_reviews_page.dart';
import '../support_ui/support_page.dart';
import '../wallet_page.dart';
import '../widgets/nav.dart';
import 'story.dart';
import 'story_content.dart';
import 'story_viewer.dart';

/// Истории для того, кто сейчас вошёл: у заказчика свои.
List<Story> storiesFor(AppSession session) =>
    session.user?.isManager == true ? managerStories() : workerStories();

/// Одна история по ключу без версии: `payouts`, `limit`.
///
/// Нужна экранам, которые открывают справку о себе: «Выплаты» — историю
/// о выплатах, «Документы» — о документах.
Story storyByKey(String key) => [...workerStories(), ...managerStories()]
    .firstWhere((s) => s.id.startsWith('$key.'));

/// Лимит месяца для слайда «Ваш месяц». Не узнали — слайд покажет общий.
Future<EarningsLimit?> Function() limitLoader(ShiftRepository shifts) =>
    () async {
      try {
        return await shifts.earningsLimit(DateTime.now());
      } catch (_) {
        return null;
      }
    };

/// Открыть истории, а если человек нажал кнопку внизу слайда — перейти.
///
/// Вкладки приложения история переключить не может — это умеет только
/// каркас с нижним меню. Поэтому «Создать смену» и «Оценить» приходят
/// сюда колбэками от него.
Future<void> openStories(
  BuildContext context, {
  required AppSession session,
  required AppRepositories repos,
  AppPreferences? preferences,
  int initialIndex = 0,
  VoidCallback? onCreateShift,
  VoidCallback? onRateWorkers,
}) async {
  final user = session.user;
  final action = await showStories(
    context,
    stories: storiesFor(session),
    initialIndex: initialIndex,
    preferences: preferences,
    data: StoryData(
      user: user,
      loadLimit: user == null || user.isManager
          ? null
          : limitLoader(repos.shifts),
    ),
  );
  if (action == null || !context.mounted) return;

  final navigator = Navigator.of(context);
  switch (action) {
    case StoryAction.wallet:
      await navigator.push(appRoute(WalletPage(
        repository: repos.shifts,
        wallet: repos.wallet,
        isManager: user?.isManager ?? false,
      )));
    case StoryAction.documents:
      await navigator.push(appRoute(
        DocumentsPage(repository: repos.documents, session: session),
      ));
    case StoryAction.terms:
      await navigator.push(appRoute(const TermsPage()));
    case StoryAction.support:
      await navigator.push(appRoute(SupportPage(repository: repos.support)));
    case StoryAction.reviews:
      await navigator.push(appRoute(
        MyReviewsPage(session: session, repository: repos.shifts),
      ));
    case StoryAction.createShift:
      onCreateShift?.call();
    case StoryAction.rateWorkers:
      onRateWorkers?.call();
  }
}

/// Открыть одну историю-справку с экрана, о котором она рассказывает.
///
/// Кнопки внизу слайдов здесь не нужны: человек уже на том экране, куда
/// они ведут.
Future<void> openHelpStory(
  BuildContext context,
  String key, {
  StoryData? data,
}) =>
    showStories(
      context,
      stories: [storyByKey(key)],
      data: data,
      showActions: false,
    );
