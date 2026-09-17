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
