import 'package:flutter/material.dart';

/// Состояние любой загрузки данных.
///
/// До сих пор мы обходились `List<Shift>?`, где `null` значило «грузим».
/// Но состояний на самом деле три: **грузим**, **получилось**, **ошибка**.
/// Одной переменной с `null` третье состояние не выразить, и пользователь
/// при сбое видит вечный крутящийся кружок.
///
/// `sealed` значит «наследников ровно три, других не будет». Благодаря
/// этому `switch` по состоянию обязан разобрать все три случая — если
/// забудешь ошибку, компилятор не даст собрать программу.
sealed class Async<T> {
  const Async();
}

/// Данные едут.
class Loading<T> extends Async<T> {
  const Loading();
}

/// Данные приехали.
class Ready<T> extends Async<T> {
  final T value;

  const Ready(this.value);
}

/// Не приехали, и вот почему.
class Failed<T> extends Async<T> {
  final Object error;

  const Failed(this.error);
}

/// Выполнить загрузку и вернуть результат уже в виде состояния.
///
/// Без этого в каждом экране пришлось бы писать один и тот же try/catch.
/// Ошибку не проглатываем: она попадает в `Failed` и доезжает до экрана.
Future<Async<T>> load<T>(Future<T> Function() body) async {
  try {
    return Ready(await body());
  } catch (error) {
    return Failed(error);
  }
}

/// Понятное человеку объяснение сбоя.
///
/// Показывать пользователю текст исключения нельзя: он написан для
/// программиста. Но и «что-то пошло не так» — плохо, потому что не
/// подсказывает, что делать. Поэтому объясняем причину по-русски.
String describeError(Object error) {
  final text = error.toString().toLowerCase();

  // `failed to fetch` и `clientexception` — это как браузер и пакет http
  // сообщают, что до сервера не достучались. Узнать их можно было только
  // на живом сервере: пока база лежала на устройстве, таких ошибок
  // просто не существовало.
  if (text.contains('socket') ||
      text.contains('network') ||
      text.contains('connection') ||
      text.contains('failed to fetch') ||
      text.contains('clientexception') ||
      text.contains('failed host lookup')) {
    return 'Нет связи с сервером. Проверьте интернет и попробуйте снова.';
  }
  if (text.contains('timeout')) {
    return 'Сервер долго не отвечает. Попробуйте ещё раз.';
  }
  if (text.contains('database') ||
      text.contains('sqlite') ||
      text.contains('drift')) {
    return 'Не удалось прочитать данные на устройстве.';
  }
  return 'Что-то пошло не так. Попробуйте ещё раз.';
}

/// Выполнить действие и показать понятное сообщение, если сорвалось.
///
/// Нужно там, где действие что-то **меняет**: записаться, отметиться,
/// оставить отзыв. Пока база была на устройстве, такие вызовы не
/// отказывали, и перехват казался лишним. С сервером связь может
/// пропасть в любой момент — и без перехвата экран замирает с
/// крутящейся кнопкой, а человек не понимает, что случилось.
///
/// Возвращает `null`, если не получилось.
Future<T?> guarded<T>(
  BuildContext context,
  Future<T> Function() body,
) async {
  try {
    return await body();
  } catch (error) {
    // `context.mounted` — та же проверка, что и `mounted` у экрана:
    // пока мы ждали, человек мог уйти, и показывать сообщение уже негде.
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(describeError(error)),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    return null;
  }
}

/// То же самое для действий, которые ничего не возвращают.
///
/// Отдельная функция нужна из-за особенности Dart: `void` — это «ничего»,
/// и значение такого типа нельзя проверить на `null`. Поэтому здесь
/// возвращаем `true`/`false` — получилось или нет.
Future<bool> guardedDone(
  BuildContext context,
  Future<void> Function() body,
) async {
  try {
    await body();
    return true;
  } catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(describeError(error)),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    return false;
  }
}
