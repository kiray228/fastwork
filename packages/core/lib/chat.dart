/// Переписка по смене: исполнитель и заказчик.
///
/// Смена — короткая встреча незнакомых людей: «опаздываю на пятнадцать
/// минут», «вход со двора», «где взять форму». Раньше договориться было
/// негде — только звонить по номеру из списка записавшихся, а номер
/// исполнителю не виден вовсе. Теперь у каждой пары «смена + исполнитель»
/// своя переписка с заказчиком этой смены.
///
/// Переписка именно на пару, а не одна на смену: человек пишет «у меня
/// температура», и это не дело остальных двадцати записавшихся.
class ShiftMessage {
  final int id;
  final int shiftId;

  /// Исполнитель, с которым эта переписка. Ключ переписки вместе со сменой.
  final int workerId;

  /// Кто написал: исполнитель или заказчик.
  final int authorId;
  final String text;
  final DateTime createdAt;

  /// Написал тот, кто читает. Считается для читающего: одно и то же
  /// сообщение у автора справа, у собеседника слева.
  final bool mine;

  const ShiftMessage({
    required this.id,
    required this.shiftId,
    required this.workerId,
    required this.authorId,
    required this.text,
    required this.createdAt,
    required this.mine,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'shiftId': shiftId,
        'workerId': workerId,
        'authorId': authorId,
        'text': text,
        'createdAt': createdAt.toIso8601String(),
        'mine': mine,
      };

  static ShiftMessage fromJson(Map<String, dynamic> json) => ShiftMessage(
        id: json['id'] as int,
        shiftId: json['shiftId'] as int,
        workerId: json['workerId'] as int,
        authorId: json['authorId'] as int,
        text: json['text'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        mine: json['mine'] as bool? ?? false,
      );
}

/// Самое длинное сообщение. Переписка — для коротких договорённостей;
/// длинное письмо — это уже обращение в поддержку.
const kMaxMessageLength = 1000;
