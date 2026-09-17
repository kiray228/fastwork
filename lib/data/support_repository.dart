import 'package:drift/drift.dart';

import '../support.dart';
import 'database.dart';
import 'session.dart';

/// Документы исполнителя и их проверка.
abstract class DocumentRepository {
  Future<List<UserDocument>> documents();

  /// Отправить документ на проверку.
  Future<void> upload({
    required String type,
    required String number,
    DateTime? expiresAt,
  });

  /// Решение оператора по документу.
  ///
  /// В боевом приложении это делает сотрудник платформы из своего
  /// интерфейса. У нас его нет, поэтому экран вызывает метод сам —
  /// чтобы было видно, как работает цепочка статусов.
  Future<void> review(int documentId, {required bool approved});
}

/// Переписка с поддержкой.
abstract class SupportRepository {
  Future<List<SupportTicket>> tickets();
  Future<int> createTicket(String subject, String firstMessage);
  Future<List<SupportMessage>> messages(int ticketId);
  Future<void> sendMessage(int ticketId, String text);
}

// ---------------------------------------------------------------------------
// SQLite
// ---------------------------------------------------------------------------

class DbDocumentRepository implements DocumentRepository {
  final AppDatabase db;
  final AppSession session;

  DbDocumentRepository(this.db, this.session);

  @override
  Future<List<UserDocument>> documents() async {
    final rows = await (db.select(db.documentRows)
          ..where((d) => d.userId.equals(session.workerId)))
        .get();

    return rows
        .map((r) => UserDocument(
              id: r.id,
              type: r.type,
              number: r.number,
              expiresAt: r.expiresAt,
              status: r.status,
              createdAt: r.createdAt,
            ))
        .toList();
  }

  @override
  Future<void> upload({
    required String type,
    required String number,
    DateTime? expiresAt,
  }) async {
    // insertOnConflictUpdate: если документ такого типа уже есть, он
    // заменяется. За уникальность пары (пользователь, тип) следит база.
    await db.into(db.documentRows).insertOnConflictUpdate(
          DocumentRowsCompanion.insert(
            userId: session.workerId,
            type: type,
            number: number,
            expiresAt: Value(expiresAt),
            status: DocumentStatus.pending,
            createdAt: DateTime.now(),
          ),
        );
  }

  @override
  Future<void> review(int documentId, {required bool approved}) async {
    await (db.update(db.documentRows)..where((d) => d.id.equals(documentId)))
        .write(DocumentRowsCompanion(
      status: Value(
        approved ? DocumentStatus.approved : DocumentStatus.rejected,
      ),
    ));

    // Пользователь считается проверенным, когда одобрено удостоверение.
    final idCard = await (db.select(db.documentRows)
          ..where((d) =>
              d.userId.equals(session.workerId) & d.type.equals('id_card')))
        .getSingleOrNull();

    final verified = idCard?.status == DocumentStatus.approved;
    await (db.update(db.userRows)
          ..where((u) => u.id.equals(session.workerId)))
        .write(UserRowsCompanion(isVerified: Value(verified)));
  }
}

class DbSupportRepository implements SupportRepository {
  final AppDatabase db;
  final AppSession session;

  DbSupportRepository(this.db, this.session);

  @override
  Future<List<SupportTicket>> tickets() async {
    // Подзапросы достают последнее сообщение и их количество —
    // связь один-ко-многим, свёрнутая до одной строки на обращение.
    final rows = await db.customSelect(
      '''
      SELECT t.*,
        (SELECT COUNT(*) FROM support_message_rows m
          WHERE m.ticket_id = t.id) AS cnt,
        (SELECT m2.body FROM support_message_rows m2
          WHERE m2.ticket_id = t.id
          ORDER BY m2.created_at DESC LIMIT 1) AS last_text
      FROM support_ticket_rows t
      WHERE t.user_id = ?
      ORDER BY t.created_at DESC
      ''',
      variables: [Variable.withInt(session.workerId)],
      readsFrom: {db.supportTicketRows, db.supportMessageRows},
    ).get();

    return rows
        .map((r) => SupportTicket(
              id: r.read<int>('id'),
              subject: r.read<String>('subject'),
              status: r.read<String>('status'),
              createdAt: r.read<DateTime>('created_at'),
              lastMessage: r.readNullable<String>('last_text'),
              messageCount: r.read<int>('cnt'),
            ))
        .toList();
  }

  @override
  Future<int> createTicket(String subject, String firstMessage) async {
    final id = await db.into(db.supportTicketRows).insert(
          SupportTicketRowsCompanion.insert(
            userId: session.workerId,
            subject: subject,
            status: 'open',
            createdAt: DateTime.now(),
          ),
        );
    await sendMessage(id, firstMessage);
    return id;
  }

  @override
  Future<List<SupportMessage>> messages(int ticketId) async {
    final rows = await (db.select(db.supportMessageRows)
          ..where((m) => m.ticketId.equals(ticketId))
          ..orderBy([(m) => OrderingTerm.asc(m.createdAt)]))
        .get();

    return rows
        .map((r) => SupportMessage(
              id: r.id,
              text: r.body,
              fromSupport: r.fromSupport,
              createdAt: r.createdAt,
            ))
        .toList();
  }

  @override
  Future<void> sendMessage(int ticketId, String text) async {
    await db.into(db.supportMessageRows).insert(
          SupportMessageRowsCompanion.insert(
            ticketId: ticketId,
            body: text,
            fromSupport: false,
            createdAt: DateTime.now(),
          ),
        );
  }
}

// ---------------------------------------------------------------------------
// В памяти — для тестов
// ---------------------------------------------------------------------------

class FakeDocumentRepository implements DocumentRepository {
  final List<UserDocument> _docs = [];
  int _nextId = 1;

  @override
  Future<List<UserDocument>> documents() async => List.of(_docs);

  @override
  Future<void> upload({
    required String type,
    required String number,
    DateTime? expiresAt,
  }) async {
    _docs.removeWhere((d) => d.type == type);
    _docs.add(UserDocument(
      id: _nextId++,
      type: type,
      number: number,
      expiresAt: expiresAt,
      status: DocumentStatus.pending,
      createdAt: DateTime.now(),
    ));
  }

  @override
  Future<void> review(int documentId, {required bool approved}) async {
    final index = _docs.indexWhere((d) => d.id == documentId);
    if (index == -1) return;
    final old = _docs[index];
    _docs[index] = UserDocument(
      id: old.id,
      type: old.type,
      number: old.number,
      expiresAt: old.expiresAt,
      status:
          approved ? DocumentStatus.approved : DocumentStatus.rejected,
      createdAt: old.createdAt,
    );
  }
}

class FakeSupportRepository implements SupportRepository {
  final List<SupportTicket> _tickets = [];
  final Map<int, List<SupportMessage>> _messages = {};
  int _nextTicket = 1;
  int _nextMessage = 1;

  @override
  Future<List<SupportTicket>> tickets() async => _tickets
      .map((t) => SupportTicket(
            id: t.id,
            subject: t.subject,
            status: t.status,
            createdAt: t.createdAt,
            messageCount: _messages[t.id]?.length ?? 0,
            lastMessage: _messages[t.id]?.last.text,
          ))
      .toList()
      .reversed
      .toList();

  @override
  Future<int> createTicket(String subject, String firstMessage) async {
    final id = _nextTicket++;
    _tickets.add(SupportTicket(
      id: id,
      subject: subject,
      status: 'open',
      createdAt: DateTime.now(),
    ));
    await sendMessage(id, firstMessage);
    return id;
  }

  @override
  Future<List<SupportMessage>> messages(int ticketId) async =>
      List.of(_messages[ticketId] ?? const []);

  @override
  Future<void> sendMessage(int ticketId, String text) async {
    _messages.putIfAbsent(ticketId, () => []).add(SupportMessage(
          id: _nextMessage++,
          text: text,
          fromSupport: false,
          createdAt: DateTime.now(),
        ));
  }
}
