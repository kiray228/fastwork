/// Что именно произошло. Нужен, чтобы экран выбрал значок и цвет,
/// а нажатие вело в правильное место.
///
/// Почему не просто текст «на смену записался Азамат»? Потому что по
/// тексту нельзя ничего решить: значок по нему не выберешь, а разбирать
/// строку словами — это уже гадание. Вид события — отдельное поле.
enum NotificationKind {
  /// Кто-то записался на твою смену. Приходит заказчику.
  applied,

  /// Исполнитель снял запись. Приходит заказчику.
  withdrew,

  /// Заказчик подтвердил, что человек отработал. Приходит исполнителю.
  confirmed,

  /// Заказчику поставили оценку исполнителю. Приходит исполнителю.
  rated,

  /// Смену отменили. Приходит всем, кто был на неё записан.
  shiftCancelled,

  /// Смену изменили: время, ставку или адрес. Приходит записавшимся.
  shiftChanged,

  /// Заказчик отметил, что человек не вышел. Приходит исполнителю.
  noShow,
}

/// Одно уведомление в колокольчике.
///
/// Обрати внимание: текст хранится **готовым**, а не собирается при показе
/// из смены и пользователя. Это осознанное исключение из правила «не храни
/// то, что можно вычислить».
///
/// Причина: уведомление — это запись о том, что было верно в тот момент.
/// Заказчик может потом переименовать смену или вовсе её удалить, а строчка
/// «на смену „Повар в Магнум“ записался Азамат» обязана читаться так же,
/// как в день события. Вычисляемое значение показало бы сегодняшнюю правду
/// вместо вчерашней — а это уже другая запись.
class AppNotification {
  final int id;
  final NotificationKind kind;
  final String title;
  final String body;

  /// Смена, к которой относится событие. `null` — смену успели удалить,
  /// тогда уведомление просто не открывается по нажатию.
  final int? shiftId;

  final DateTime createdAt;

  /// Когда прочитано. `null` — ещё не прочитано.
  ///
  /// Опять время вместо галочки: из времени галочку получить легко
  /// (`readAt != null`), а из галочки время уже не вернёшь.
  final DateTime? readAt;

  const AppNotification({
    required this.id,
    required this.kind,
    required this.title,
    required this.body,
    required this.shiftId,
    required this.createdAt,
    required this.readAt,
  });

  bool get isUnread => readAt == null;

  /// Разбор строки из базы. Незнакомый вид (например, запись, сделанную
  /// более новой версией приложения) не роняем, а показываем как обычную.
  static NotificationKind kindFrom(String value) =>
      NotificationKind.values.firstWhere(
        (k) => k.name == value,
        orElse: () => NotificationKind.applied,
      );
}

/// Перевод уведомления в JSON и обратно.
///
/// Тот же приём, что у смен и отзывов: сама модель ничего не знает про
/// сеть, а умение «превратиться в JSON» дописано сбоку, расширением.
extension AppNotificationJson on AppNotification {
  Map<String, dynamic> toJson() => {
        'id': id,
        'kind': kind.name,
        'title': title,
        'body': body,
        'shiftId': shiftId,
        'createdAt': createdAt.toIso8601String(),
        'readAt': readAt?.toIso8601String(),
      };
}

AppNotification notificationFromJson(Map<String, dynamic> json) =>
    AppNotification(
      id: json['id'] as int,
      kind: AppNotification.kindFrom(json['kind'] as String),
      title: json['title'] as String,
      body: json['body'] as String,
      shiftId: json['shiftId'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      readAt: json['readAt'] == null
          ? null
          : DateTime.parse(json['readAt'] as String),
    );
