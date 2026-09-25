import 'package:fastwork_core/category.dart';
import 'package:fastwork_core/data/shift_repository.dart';
import 'package:fastwork_core/payment.dart';

/// Смена, которую создали и сразу оплатили тестовой картой.
///
/// Большинству тестов оплата не интересна — им нужна опубликованная
/// смена. Путь при этом настоящий: создать, начать оплату, «заплатить»
/// тестовой картой, дождаться подтверждения.
extension PublishShift on ShiftRepository {
  Future<int> publishShift({
    required DateTime workDate,
    required String title,
    required String company,
    required String address,
    required int startMinutes,
    required int endMinutes,
    required int hourlyRate,
    required int workersNeeded,
    required int createdBy,
    required String city,
    required PaymentCard card,
    String category = kOtherCategory,
    List<String> duties = const [],
    String? dressCode,
    double? minRating,
  }) async {
    final checkout = await createShift(
      method: PaymentMethod.card,
      workDate: workDate,
      title: title,
      company: company,
      address: address,
      startMinutes: startMinutes,
      endMinutes: endMinutes,
      hourlyRate: hourlyRate,
      workersNeeded: workersNeeded,
      createdBy: createdBy,
      city: city,
      category: category,
      duties: duties,
      dressCode: dressCode,
      minRating: minRating,
    );
    final paid = await completeSandboxPayment(checkout.id, card: card);
    if (!paid.isPaid) throw PaymentDeclined(paid.message ?? 'не оплачено');
    return checkout.shiftId!;
  }
}
