enum BookStatus { available, borrowed, overdue, missing }

class Book {
  final String id;
  final String title;
  final String author;
  final double replacementPrice;
  final BookStatus status;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.replacementPrice,
    this.status = BookStatus.available,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      replacementPrice: (json['replacementPrice'] as num).toDouble(),
    );
  }

  Book copyWith({BookStatus? status}) {
    return Book(
      id: id,
      title: title,
      author: author,
      replacementPrice: replacementPrice,
      status: status ?? this.status,
    );
  }
}