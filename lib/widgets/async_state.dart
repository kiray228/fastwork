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

  if (text.contains('socket') ||
      text.contains('network') ||
      text.contains('connection') ||
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
