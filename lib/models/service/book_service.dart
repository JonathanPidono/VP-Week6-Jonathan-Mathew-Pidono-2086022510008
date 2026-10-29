import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../book.dart';

class BookService {
  static const _assetPath = 'books.json';

  Future<List<Book>> loadBooks() async {
    final raw = await rootBundle.loadString(_assetPath);
    final list = jsonDecode(raw) as List<dynamic>;

    final books = list
        .map((e) => Book.fromJson(e as Map<String, dynamic>))
        .toList();

    final ids = <String>{};
    for (final book in books) {
      if (!ids.add(book.id)) {
        throw FormatException('Duplicate book id in books.json: ${book.id}');
      }
    }

    return books;
  }
}