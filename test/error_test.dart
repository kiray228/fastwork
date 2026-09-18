import 'package:fastwork/data/api_client.dart';
import 'package:fastwork/widgets/async_state.dart';
import 'package:flutter_test/flutter_test.dart';

/// Проверяем, что человек видит внятную причину, а не общие слова.
void main() {

  group('сообщения об ошибках', () {
    test('сообщение сервера показывается как есть', () {
      // Сервер уже написал причину по-человечески — подменять её своим
      // «что-то пошло не так» значит прятать от человека ответ.
      expect(
        describeError(ApiException('Код неверный. Осталось попыток: 2', 400)),
        'Код неверный. Осталось попыток: 2',
      );
      expect(
        describeError(ApiException('Слишком много запросов', 429)),
        'Слишком много запросов',
      );
    });

    test('обрыв связи объясняется по-человечески', () {
      expect(
        describeError(Exception('ClientException: Failed to fetch')),
        contains('Нет связи с сервером'),
      );
    });

    test('незнакомая ошибка не пугает подробностями', () {
      expect(
        describeError(StateError('Bad state: no element')),
        contains('Что-то пошло не так'),
      );
    });
  });
}
