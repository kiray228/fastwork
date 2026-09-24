import 'package:flutter/material.dart';

import 'package:fastwork_core/mrp.dart';
import 'package:fastwork_core/user.dart';

/// Куда может отправить кнопка внизу истории.
///
/// Перечисление, а не готовый экран: история не знает, как устроено
/// приложение, и не держит хранилищ. Она только говорит «человек хочет
/// в выплаты», а открывает выплаты тот экран, откуда историю запустили.
enum StoryAction {
  wallet,
  documents,
  terms,
  support,
  reviews,
  createShift,
  rateWorkers,
}

/// Что истории нужно знать о человеке, чтобы говорить с ним о нём.
///
/// Лимит — не число, а ожидание: он грузится с сервера, и историю не
/// стоит держать закрытой, пока он едет. Слайд с лимитом сам покажет
/// кольцо на нуле, а потом настоящее.
///
/// Грузится лимит только тогда, когда до него дошли: человек, открывший
/// «Документы», не должен ждать запроса про деньги.
class StoryData {
  final AppUser? user;
  final Future<EarningsLimit?> Function()? loadLimit;
  Future<EarningsLimit?>? _limit;

  StoryData({this.user, this.loadLimit});

  Future<EarningsLimit?>? get limit => _limit ??= loadLimit?.call();
}

/// Рисует картинку слайда.
typedef StoryVisual = Widget Function(BuildContext context, StoryData data);

/// Один экран истории: инфографика сверху, короткий текст снизу.
class StorySlide {
  final String title;
  final String body;
  final StoryVisual visual;

  /// Кнопка внизу слайда — перейти от объяснения к делу.
  final StoryAction? action;
  final String? actionLabel;

  const StorySlide({
    required this.title,
    required this.body,
    required this.visual,
    this.action,
    this.actionLabel,
  });

  /// Сколько показывать слайд.
  ///
  /// Не одинаково для всех: на «4%» хватит пяти секунд, а абзац про
  /// отмену записи за пять секунд не прочитать. Считаем от длины текста —
  /// примерно столько, сколько нужно, чтобы спокойно дочитать.
  Duration get duration {
    final ms = 4500 + (title.length + body.length) * 38;
    return Duration(milliseconds: ms.clamp(5500, 12000));
  }
}

/// История — несколько слайдов об одном: выплатах, документах, правилах.
class Story {
  /// Ключ с версией: `payouts.1`. По нему запоминаем, что историю видели.
  /// Поменялось содержание по существу — поднимаем версию, и история
  /// снова станет «непросмотренной».
  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final List<StorySlide> slides;

  const Story({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    required this.slides,
  });
}
