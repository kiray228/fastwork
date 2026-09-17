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
}

/// Типы документов и их названия для экрана.
const documentTypes = {
  'id_card': 'Удостоверение личности',
  'medical_book': 'Санитарная книжка',
};
