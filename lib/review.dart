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
