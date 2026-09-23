import 'package:drift/drift.dart';

import '../payment.dart';
import 'current_user.dart';
import 'database.dart';
import 'fake_shift_repository.dart';

/// Кошелёк: что заработано, что выведено, и вывод на карту.
///
/// Отдельное хранилище, а не ещё десяток методов в хранилище смен. Смены
/// и деньги связаны — деньги появляются от смен, — но это разные вещи:
/// у кошелька свои правила (нельзя вывести больше, чем есть) и свои
/// экраны. Когда подключат настоящего провайдера, меняться будет этот
/// файл, а смены останутся как были.
abstract class WalletRepository {
  /// Баланс и история текущего пользователя.
  Future<WalletSummary> summary();

  /// Вывести деньги на карту.
  Future<void> withdraw({required int amount, required PaymentCard card});
}

/// Отказ в выводе: сумма не та.
class WithdrawRejected extends PaymentDeclined {
  const WithdrawRejected(super.message);
}

/// Меньше этого выводить нельзя: перевод на карту стоит провайдеру денег,
/// и гонять по сто тенге невыгодно никому.
const kMinWithdrawal = 100000; // 1 000 ₸

/// Проверка суммы вывода — одна на все хранилища.
void checkWithdrawal(int amount, int balance) {
  if (amount < kMinWithdrawal) {
    throw WithdrawRejected('Вывести можно от ${kMinWithdrawal ~/ 100} ₸');
  }
  if (amount > balance) {
    throw const WithdrawRejected('На балансе меньше, чем вы хотите вывести');
  }
}

class DbWalletRepository implements WalletRepository {
  final AppDatabase db;
  final CurrentUser session;
  final PaymentGateway payments;

  DbWalletRepository(this.db, this.session, {PaymentGateway? payments})
      : payments = payments ?? SandboxPaymentGateway();

  Future<List<WalletEntry>> _entries() async {
    final rows = await (db.select(db.walletEntryRows)
          ..where((e) => e.userId.equals(session.workerId))
          ..orderBy([
            (e) => OrderingTerm.desc(e.createdAt),
            (e) => OrderingTerm.desc(e.id),
          ]))
        .get();
    return rows
        .map((r) => WalletEntry(
              id: r.id,
              kind: r.kind,
              amount: r.amount,
              shiftId: r.shiftId,
              title: r.title,
              createdAt: r.createdAt,
            ))
        .toList();
  }

  @override
  Future<WalletSummary> summary() async =>
      WalletSummary.from(await _entries(), sandbox: payments.isSandbox);

  @override
  Future<void> withdraw({
    required int amount,
    required PaymentCard card,
  }) async {
    // Сначала списываем с баланса, потом переводим. В обратном порядке
    // два вывода подряд оба увидели бы полный баланс и оба прошли бы —
    // и человек получил бы вдвое больше, чем заработал.
    final id = await db.transaction(() async {
      final balance = (await summary()).balance;
      checkWithdrawal(amount, balance);
      return db.into(db.walletEntryRows).insert(
            WalletEntryRowsCompanion.insert(
              userId: session.workerId,
              kind: WalletEntryKind.withdrawal,
              amount: -amount,
              title: 'Вывод на карту ${card.masked}',
              createdAt: DateTime.now(),
            ),
          );
    });

    try {
      await payments.payout(amount: amount, card: card);
    } catch (_) {
      // Перевод не прошёл — деньги возвращаются на баланс. Строку можно
      // удалить: перевода не было, и в истории ему не место.
      await (db.delete(db.walletEntryRows)..where((e) => e.id.equals(id)))
          .go();
      rethrow;
    }
  }
}

/// Кошелёк в памяти — поверх журнала из хранилища смен в памяти.
class FakeWalletRepository implements WalletRepository {
  final FakeShiftRepository shifts;

  FakeWalletRepository(this.shifts);

  @override
  Future<WalletSummary> summary() async => WalletSummary.from(
        shifts.ledger.reversed.toList(),
        sandbox: true,
      );

  @override
  Future<void> withdraw({
    required int amount,
    required PaymentCard card,
  }) async {
    checkWithdrawal(amount, (await summary()).balance);
    await shifts.payments.payout(amount: amount, card: card);
    shifts.ledger.add(WalletEntry(
      id: shifts.ledger.length + 1000,
      kind: WalletEntryKind.withdrawal,
      amount: -amount,
      title: 'Вывод на карту ${card.masked}',
      createdAt: DateTime.now(),
    ));
  }
}
