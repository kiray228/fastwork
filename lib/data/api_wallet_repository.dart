import 'package:fastwork_core/data/wallet_repository.dart';
import 'package:fastwork_core/payment.dart';
import 'api_client.dart';

/// Кошелёк на сервере.
///
/// Обрати внимание, чего здесь нет: платёжного шлюза. Деньги двигает
/// сервер, у которого ключи провайдера. Приложение только просит
/// «выведи столько-то», а карту человек вводит на странице провайдера.
class ApiWalletRepository implements WalletRepository {
  final ApiClient client;

  ApiWalletRepository(this.client);

  @override
  Future<WalletSummary> summary() async => WalletSummary.fromJson(
        await client.get('/api/wallet') as Map<String, dynamic>,
      );

  @override
  Future<PaymentCheckout> startWithdrawal(int amount) async =>
      PaymentCheckout.fromJson(await client.post('/api/wallet/withdraw', {
        'amount': amount,
      }) as Map<String, dynamic>);

  @override
  Future<PaymentCheckout> withdrawalStatus(int payoutId) async =>
      PaymentCheckout.fromJson(await client.get('/api/wallet/payouts/$payoutId')
          as Map<String, dynamic>);

  @override
  Future<PaymentCheckout> completeSandboxWithdrawal(
    int payoutId,
    PaymentCard card,
  ) async =>
      PaymentCheckout.fromJson(await client.post(
        '/api/wallet/payouts/$payoutId/sandbox',
        {'card': card.toJson()},
      ) as Map<String, dynamic>);
}
