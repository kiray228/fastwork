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
