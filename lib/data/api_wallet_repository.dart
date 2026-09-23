import 'package:fastwork_core/data/wallet_repository.dart';
import 'package:fastwork_core/payment.dart';
import 'api_client.dart';

/// Кошелёк на сервере.
///
/// Обрати внимание, чего здесь нет: платёжного шлюза. Деньги двигает
/// сервер, у которого ключи провайдера. Приложение только просит
/// «выведи столько-то вот на эту карту» — и передаёт токен карты,
/// а не её номер.
class ApiWalletRepository implements WalletRepository {
  final ApiClient client;

  ApiWalletRepository(this.client);

  @override
  Future<WalletSummary> summary() async => WalletSummary.fromJson(
        await client.get('/api/wallet') as Map<String, dynamic>,
      );

  @override
  Future<void> withdraw({
    required int amount,
    required PaymentCard card,
  }) async {
    await client.post('/api/wallet/withdraw', {
      'amount': amount,
      'card': card.toJson(),
    });
  }
}
