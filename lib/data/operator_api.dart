import 'api_client.dart';

/// Документ в очереди на проверку — глазами оператора.
class PendingDocument {
  final int id;
  final String fullName;
  final String type;
  final String number;
  final DateTime? expiresAt;

  const PendingDocument({
    required this.id,
    required this.fullName,
    required this.type,
    required this.number,
    this.expiresAt,
  });

  static PendingDocument fromJson(Map<String, dynamic> json) =>
      PendingDocument(
        id: json['id'] as int,
        fullName: json['fullName'] as String,
        type: json['type'] as String,
        number: json['number'] as String,
        expiresAt: json['expiresAt'] == null
            ? null
            : DateTime.parse(json['expiresAt'] as String),
      );
}

/// Что умеет экран оператора: показать очередь и вынести решение.
abstract class OperatorDocuments {
  Future<List<PendingDocument>> pending(String key);
  Future<void> review(String key, int documentId, {required bool approved});
}

/// Очередь документов на сервере — по служебному ключу.
class ApiOperatorDocuments implements OperatorDocuments {
  final ApiClient client;

  ApiOperatorDocuments(this.client);

  static Map<String, String> _key(String key) => {'X-Admin-Key': key};

  @override
  Future<List<PendingDocument>> pending(String key) async {
    final data = await client.get('/api/admin/documents', null, _key(key))
        as List<dynamic>;
    return [
      for (final e in data) PendingDocument.fromJson(e as Map<String, dynamic>),
    ];
  }

  @override
  Future<void> review(String key, int documentId,
          {required bool approved}) =>
      client.post('/api/admin/documents/$documentId/review',
          {'approved': approved}, _key(key));
}
