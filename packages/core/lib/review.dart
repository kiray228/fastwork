/// Отзыв исполнителя о месте работы.
class Review {
  final int id;
  final int shiftId;
  final String authorName;
  final int rating; // 1..5
  final String? comment;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.shiftId,
    required this.authorName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}

/// Сводка по компании: описание, средняя оценка и число отзывов.
///
/// Средняя оценка нигде не хранится — она считается запросом `AVG`
/// по таблице отзывов. Храни мы её колонкой, она бы разъезжалась с
/// реальностью при каждом новом отзыве.
class CompanyInfo {
  final String name;
  final double? rating; // null — отзывов ещё нет
  final int reviewCount;
  final List<Review> reviews;

  const CompanyInfo({
    required this.name,
    required this.rating,
    required this.reviewCount,
    required this.reviews,
  });
}

/// Отзыв заказчика об исполнителе.
///
/// Отличается от отзыва о компании тем, что здесь важно не только кто
/// написал, но и **за какую смену** — исполнитель должен понимать,
/// о каком дне речь.
class WorkerReview {
  final int id;
  final int shiftId;
  final String shiftTitle;
  final String company;
  final int rating; // 1..5
  final String? comment;
  final DateTime createdAt;

  const WorkerReview({
    required this.id,
    required this.shiftId,
    required this.shiftTitle,
    required this.company,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}

/// Исполнитель, которого заказчик ещё не оценил после отработанной смены.
///
/// Это не строка какой-то таблицы, а **результат запроса**: смена,
/// которая уже прошла, плюс человек, который на неё был записан, минус
/// те, кого уже оценили. Такие «склеенные» объекты и есть обычный
/// результат работы с базой — таблицы отдельно, ответы отдельно.
class PendingRating {
  final int shiftId;
  final String shiftTitle;
  final DateTime workDate;
  final int workerId;
  final String workerName;
  final double workerRating;

  const PendingRating({
    required this.shiftId,
    required this.shiftTitle,
    required this.workDate,
    required this.workerId,
    required this.workerName,
    required this.workerRating,
  });
}

extension ReviewJson on Review {
  Map<String, dynamic> toJson() => {
        'id': id,
        'shiftId': shiftId,
        'authorName': authorName,
        'rating': rating,
        'comment': comment,
        'createdAt': createdAt.toIso8601String(),
      };
}

Review reviewFromJson(Map<String, dynamic> json) => Review(
      id: json['id'] as int,
      shiftId: json['shiftId'] as int,
      authorName: json['authorName'] as String,
      rating: json['rating'] as int,
      comment: json['comment'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

extension CompanyInfoJson on CompanyInfo {
  Map<String, dynamic> toJson() => {
        'name': name,
        'rating': rating,
        'reviewCount': reviewCount,
        'reviews': reviews.map((r) => r.toJson()).toList(),
      };
}

CompanyInfo companyInfoFromJson(Map<String, dynamic> json) => CompanyInfo(
      name: json['name'] as String,
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: json['reviewCount'] as int,
      reviews: (json['reviews'] as List<dynamic>)
          .map((r) => reviewFromJson(r as Map<String, dynamic>))
          .toList(),
    );

extension WorkerReviewJson on WorkerReview {
  Map<String, dynamic> toJson() => {
        'id': id,
        'shiftId': shiftId,
        'shiftTitle': shiftTitle,
        'company': company,
        'rating': rating,
        'comment': comment,
        'createdAt': createdAt.toIso8601String(),
      };
}

WorkerReview workerReviewFromJson(Map<String, dynamic> json) => WorkerReview(
      id: json['id'] as int,
      shiftId: json['shiftId'] as int,
      shiftTitle: json['shiftTitle'] as String,
      company: json['company'] as String,
      rating: json['rating'] as int,
      comment: json['comment'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

extension PendingRatingJson on PendingRating {
  Map<String, dynamic> toJson() => {
        'shiftId': shiftId,
        'shiftTitle': shiftTitle,
        'workDate': workDate.toIso8601String(),
        'workerId': workerId,
        'workerName': workerName,
        'workerRating': workerRating,
      };
}

PendingRating pendingRatingFromJson(Map<String, dynamic> json) => PendingRating(
      shiftId: json['shiftId'] as int,
      shiftTitle: json['shiftTitle'] as String,
      workDate: DateTime.parse(json['workDate'] as String),
      workerId: json['workerId'] as int,
      workerName: json['workerName'] as String,
      workerRating: (json['workerRating'] as num).toDouble(),
    );
