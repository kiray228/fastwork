/// Обращение в поддержку.
class SupportTicket {
  final int id;
  final String subject;
  final String status; // open / closed
  final DateTime createdAt;
  final String? lastMessage;
  final int messageCount;

  const SupportTicket({
    required this.id,
    required this.subject,
    required this.status,
    required this.createdAt,
    this.lastMessage,
    this.messageCount = 0,
  });

  bool get isOpen => status == 'open';
}

/// Сообщение в переписке.
class SupportMessage {
  final int id;
  final String text;
  final bool fromSupport;
  final DateTime createdAt;

  const SupportMessage({
    required this.id,
    required this.text,
    required this.fromSupport,
    required this.createdAt,
  });
}

/// Документ исполнителя.
class UserDocument {
  final int id;
  final String type;
  final String number;
  final DateTime? expiresAt;
  final String status;
  final DateTime createdAt;

  const UserDocument({
    required this.id,
    required this.type,
    required this.number,
    required this.expiresAt,
    required this.status,
    required this.createdAt,
  });

  bool get isApproved => status == 'approved';
  bool get isPending => status == 'pending';

  /// Срок вышел. Документ действует до конца последнего дня.
  bool isExpiredAt(DateTime now) {
    final until = expiresAt;
    if (until == null) return false;
    return !now.isBefore(DateTime(until.year, until.month, until.day + 1));
  }

  /// Сколько полных дней осталось. null — срока у документа нет.
  int? daysLeftAt(DateTime now) {
    final until = expiresAt;
    if (until == null) return null;
    final today = DateTime.utc(now.year, now.month, now.day);
    return DateTime.utc(until.year, until.month, until.day)
        .difference(today)
        .inDays;
  }

  /// Срок скоро выйдет — пора записываться на медосмотр.
  ///
  /// Месяц — столько обычно хватает, чтобы пройти врачей без спешки.
  bool expiresSoonAt(DateTime now) {
    final left = daysLeftAt(now);
    return left != null && left >= 0 && left < 30;
  }
}

/// Типы документов и их названия для экрана.
const documentTypes = {
  'id_card': 'Удостоверение личности',
  'medical_book': 'Санитарная книжка',
};

/// Документы со сроком действия. Удостоверение тоже не вечное, но оно
/// действует десять лет, а медосмотр в книжке нужно проходить регулярно.
const documentsWithExpiry = {'medical_book'};

// ---------------------------------------------------------------------------
// JSON
// ---------------------------------------------------------------------------

extension SupportTicketJson on SupportTicket {
  Map<String, dynamic> toJson() => {
        'id': id,
        'subject': subject,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'lastMessage': lastMessage,
        'messageCount': messageCount,
      };
}

SupportTicket ticketFromJson(Map<String, dynamic> json) => SupportTicket(
      id: json['id'] as int,
      subject: json['subject'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastMessage: json['lastMessage'] as String?,
      messageCount: json['messageCount'] as int? ?? 0,
    );

extension SupportMessageJson on SupportMessage {
  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'fromSupport': fromSupport,
        'createdAt': createdAt.toIso8601String(),
      };
}

SupportMessage messageFromJson(Map<String, dynamic> json) => SupportMessage(
      id: json['id'] as int,
      text: json['text'] as String,
      fromSupport: json['fromSupport'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

extension UserDocumentJson on UserDocument {
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'number': number,
        'status': status,
        'expiresAt': expiresAt?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
      };
}

UserDocument documentFromJson(Map<String, dynamic> json) => UserDocument(
      id: json['id'] as int,
      type: json['type'] as String,
      number: json['number'] as String,
      status: json['status'] as String,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
