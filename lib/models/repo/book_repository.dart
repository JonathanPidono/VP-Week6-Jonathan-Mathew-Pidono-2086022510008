import 'package:flutter/foundation.dart';
import '../book.dart';
import '../service/book_service.dart';

class BookRepository extends ChangeNotifier {
  BookRepository(this._service);

  final BookService _service;
  List<Book> _books = [];

  List<Book> get all => List.unmodifiable(_books);

  Future<void> load() async {
    _books = await _service.loadBooks();
    notifyListeners();
  }

  Book? byId(String id) {
    for (final book in _books) {
      if (book.id == id) return book;
    }
    return null;
  }
}