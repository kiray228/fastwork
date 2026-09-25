import 'package:drift/drift.dart';

import '../errors.dart';
import '../payment.dart';
import '../shift.dart';
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

  /// Начать вывод денег на карту.
  ///
  /// Сумма сразу уходит с баланса — иначе, пока идёт перевод, её можно
  /// было бы вывести второй раз. Не прошёл перевод — деньги вернутся.
  Future<PaymentCheckout> startWithdrawal(int amount);

  /// Как идёт вывод.
  Future<PaymentCheckout> withdrawalStatus(int payoutId);

  /// Тестовый режим: «перевести» на тестовую карту без провайдера.
  Future<PaymentCheckout> completeSandboxWithdrawal(
    int payoutId,
    PaymentCard card,
  );
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
      WalletSummary.from(await _entries(), sandbox: payments.payouts.isSandbox);

  @override
  Future<PaymentCheckout> startWithdrawal(int amount) async {
    // Сначала списываем с баланса, потом просим провайдера. В обратном
    // порядке два вывода подряд оба увидели бы полный баланс и оба
    // прошли бы — и человек получил бы вдвое больше, чем заработал.
    final id = await db.transaction(() async {
      final balance = (await summary()).balance;
      checkWithdrawal(amount, balance);
      await db.into(db.walletEntryRows).insert(
            WalletEntryRowsCompanion.insert(
              userId: session.workerId,
              kind: WalletEntryKind.withdrawal,
              amount: -amount,
              title: 'Вывод на карту',
              createdAt: DateTime.now(),
            ),
          );
      return db.into(db.payoutRows).insert(PayoutRowsCompanion.insert(
            userId: session.workerId,
            amount: amount,
            status: CheckoutStatus.pending,
            provider: payments.payouts.name,
            createdAt: DateTime.now(),
          ));
    });

    try {
      final started = await payments.payouts.startPayout(
        amount: amount,
        reference: 'payout-$id',
        description: 'Вывод заработка fastwork',
      );
      await (db.update(db.payoutRows)..where((p) => p.id.equals(id)))
          .write(PayoutRowsCompanion(
        operation: Value(started.operation),
        checkoutUrl: Value(started.url),
      ));
    } catch (error) {
      final message = error is UserError
          ? error.message
          : 'Платёжный сервис не ответил. Попробуйте ещё раз';
      await _fail(await _payout(id), message);
      throw PaymentDeclined(message);
    }
    return _checkoutOf(await _payout(id));
  }

  @override
  Future<PaymentCheckout> withdrawalStatus(int payoutId) async =>
      _checkoutOf(await _settle(await _myPayout(payoutId)));

  @override
  Future<PaymentCheckout> completeSandboxWithdrawal(
    int payoutId,
    PaymentCard card,
  ) async {
    final payout = await _myPayout(payoutId);
    final sandbox = payments.sandboxPayouts;
    if (sandbox == null || payout.provider != sandbox.name) {
      throw const PaymentDeclined(
          'Этот вывод идёт через платёжный сервис, а не в тестовом режиме');
    }
    sandbox.complete(payout.operation, card: card);
    return _checkoutOf(await _settle(payout));
  }

  /// Довести до конца выводы, о которых провайдер ещё не сообщил.
  Future<void> settlePending({
    Duration within = const Duration(days: 3),
  }) async {
    final since = DateTime.now().subtract(within);
    final pending = await (db.select(db.payoutRows)
          ..where((p) =>
              p.status.equals(CheckoutStatus.pending) &
              p.createdAt.isBiggerThanValue(since) &
              p.provider.equals('sandbox').not()))
        .get();
    for (final payout in pending) {
      await _settle(payout);
    }
  }

  /// Провайдер прислал вебхук про вывод — проверяем.
  Future<void> settleOperation(String provider, String operation) async {
    final rows = await (db.select(db.payoutRows)
          ..where((p) =>
              p.provider.equals(provider) & p.operation.equals(operation)))
        .get();
    for (final payout in rows) {
      await _settle(payout);
    }
  }

  Future<PayoutRow> _payout(int id) =>
      (db.select(db.payoutRows)..where((p) => p.id.equals(id))).getSingle();

  Future<PayoutRow> _myPayout(int id) async {
    final payout = await (db.select(db.payoutRows)
          ..where((p) => p.id.equals(id)))
        .getSingleOrNull();
    if (payout == null || payout.userId != session.workerId) {
      throw const PaymentDeclined('Вывод не найден');
    }
    return payout;
  }

  PaymentCheckout _checkoutOf(PayoutRow p) => PaymentCheckout(
        id: p.id,
        method: PaymentMethod.card,
        amount: p.amount,
        status: p.status,
        url: p.checkoutUrl,
        sandbox: p.provider == 'sandbox',
        message: p.message,
      );

  Future<PayoutRow> _settle(PayoutRow payout) async {
    if (payout.status != CheckoutStatus.pending || payout.operation.isEmpty) {
      return payout;
    }
    if (payments.payouts.name != payout.provider) return payout;

    final ProviderResult result;
    try {
      result = await payments.payouts.checkPayout(payout.operation);
    } catch (_) {
      return payout;
    }
    switch (result.state) {
      case ProviderState.pending:
        return payout;
      case ProviderState.failed:
        await _fail(payout, result.message ?? 'Перевод не прошёл');
      case ProviderState.paid:
        final won = await (db.update(db.payoutRows)
              ..where((p) =>
                  p.id.equals(payout.id) &
                  p.status.equals(CheckoutStatus.pending)))
            .write(PayoutRowsCompanion(
          status: const Value(CheckoutStatus.paid),
          doneAt: Value(DateTime.now()),
          message: Value(result.paidWith),
        ));
        if (won > 0 && result.paidWith != null) {
          // Строку журнала не правим, а дописываем: на какую карту ушло.
          // Перевод уже учтён в балансе, поэтому сумма ноль.
          await db.into(db.walletEntryRows).insert(
                WalletEntryRowsCompanion.insert(
                  userId: payout.userId,
                  kind: WalletEntryKind.payoutDone,
                  amount: 0,
                  title: 'Перевод ${formatMoney(payout.amount)} '
                      'на карту ${result.paidWith} выполнен',
                  createdAt: DateTime.now(),
                ),
              );
        }
    }
    return _payout(payout.id);
  }

  /// Вывод не прошёл — деньги возвращаются на баланс.
  ///
  /// Строку «вывод» не удаляем: журнал только дописывается. Рядом ложится
  /// обратная — и история честно объясняет, почему баланс снова прежний.
  Future<void> _fail(PayoutRow payout, String message) async {
    final won = await (db.update(db.payoutRows)
          ..where((p) =>
              p.id.equals(payout.id) &
              p.status.equals(CheckoutStatus.pending)))
        .write(PayoutRowsCompanion(
      status: const Value(CheckoutStatus.failed),
      message: Value(message),
      doneAt: Value(DateTime.now()),
    ));
    if (won == 0) return;
    await db.into(db.walletEntryRows).insert(
          WalletEntryRowsCompanion.insert(
            userId: payout.userId,
            kind: WalletEntryKind.withdrawal,
            amount: payout.amount,
            title: 'Вывод не прошёл — деньги вернулись на баланс',
            createdAt: DateTime.now(),
          ),
        );
  }
}

/// Кошелёк в памяти — поверх журнала из хранилища смен в памяти.
class FakeWalletRepository implements WalletRepository {
  final FakeShiftRepository shifts;
  final _payouts = <int, (int amount, String operation, String status)>{};

  FakeWalletRepository(this.shifts);

  @override
  Future<WalletSummary> summary() async => WalletSummary.from(
        shifts.ledger.reversed.toList(),
        sandbox: true,
      );

  @override
  Future<PaymentCheckout> startWithdrawal(int amount) async {
    checkWithdrawal(amount, (await summary()).balance);
    final started = await shifts.payments.payouts.startPayout(
      amount: amount,
      reference: 'payout',
      description: 'Вывод',
    );
    final id = _payouts.length + 1;
    _payouts[id] = (amount, started.operation, CheckoutStatus.pending);
    _entry(-amount, 'Вывод на карту');
    return _checkout(id);
  }

  @override
  Future<PaymentCheckout> withdrawalStatus(int payoutId) async =>
      _checkout(payoutId);

  @override
  Future<PaymentCheckout> completeSandboxWithdrawal(
    int payoutId,
    PaymentCard card,
  ) async {
    final (amount, operation, status) = _payouts[payoutId]!;
    if (status != CheckoutStatus.pending) return _checkout(payoutId);
    final result = shifts.payments.sandboxPayouts!.complete(operation, card: card);
    if (result.state == ProviderState.paid) {
      _payouts[payoutId] = (amount, operation, CheckoutStatus.paid);
    } else {
      _payouts[payoutId] = (amount, operation, CheckoutStatus.failed);
      _entry(amount, 'Вывод не прошёл — деньги вернулись на баланс');
    }
    return _checkout(payoutId, message: result.message);
  }

  void _entry(int amount, String title) => shifts.ledger.add(WalletEntry(
        id: shifts.ledger.length + 1000,
        kind: WalletEntryKind.withdrawal,
        amount: amount,
        title: title,
        createdAt: DateTime.now(),
      ));

  PaymentCheckout _checkout(int id, {String? message}) {
    final (amount, _, status) = _payouts[id]!;
    return PaymentCheckout(
      id: id,
      method: PaymentMethod.card,
      amount: amount,
      status: status,
      sandbox: true,
      message: message,
    );
  }
}
