import 'package:flutter/foundation.dart';
import '../models/book.dart';
import '../models/loan.dart';
import '../models/repo/book_repository.dart';
import '../models/repo/loan_repository.dart';
import '../models/service/loan_service.dart';

enum BorrowResult {success, invalidStudentId, invalidCount, bookNotFound, notEnoughStock}

class BookGroup {
  const BookGroup({
    required this.key,
    required this.title,
    required this.author,
    required this.replacementPrice,
    required this.copies,
  });

  final String key;
  final String title;
  final String author;
  final double replacementPrice;
  final List<Book> copies; 

  int _count(BookStatus s) => copies.where((b) => b.status == s).length;

  int get totalCount => copies.length;
  int get availableCount => _count(BookStatus.available);
  int get borrowedCount => _count(BookStatus.borrowed);
  int get overdueCount => _count(BookStatus.overdue);
  int get missingCount => _count(BookStatus.missing);
  bool get hasStock => availableCount > 0;
}

class LibraryViewModel extends ChangeNotifier {
  LibraryViewModel(this._books, this._loans, {DateTime Function()? clock})
      : _now = clock ?? DateTime.now {
    _books.addListener(notifyListeners);
    _loans.addListener(notifyListeners);
  }

  final BookRepository _books;
  final LoanRepository _loans;
  final DateTime Function() _now;

  @override
  void dispose() {
    _books.removeListener(notifyListeners);
    _loans.removeListener(notifyListeners);
    super.dispose();
  }

  List<BookGroup> get groups {
    final byKey = <String, List<Book>>{};
    for (final book in _books.all) {
      byKey.putIfAbsent(_keyOf(book), () => []).add(_withFreshStatus(book));
    }

    return byKey.entries.map((e) {
      final first = e.value.first;
      return BookGroup(
        key: e.key,
        title: first.title,
        author: first.author,
        replacementPrice: first.replacementPrice,
        copies: e.value,
      );
    }).toList();
  }

  BorrowResult borrowBook(String groupKey, String studentId, int count) {
    final id = studentId.trim();
    if (id.isEmpty) return BorrowResult.invalidStudentId;
    if (count < 1) return BorrowResult.invalidCount;

    final group = groups.where((g) => g.key == groupKey).firstOrNull;
    if (group == null) return BorrowResult.bookNotFound;

    final available = group.copies
        .where((b) =>
            b.status == BookStatus.available &&
            !_loans.hasActiveLoanFor(b.id))
        .toList();
    if (available.length < count) return BorrowResult.notEnoughStock;

    final now = _now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(
      today.year,
      today.month,
      today.day + FinePolicy.loanPeriodDays,
    );
    final stamp = now.microsecondsSinceEpoch;

    _loans.addAll([
      for (var i = 0; i < count; i++)
        Loan(
          id: 'L$stamp-${available[i].id}',
          bookId: available[i].id,
          studentId: id,
          borrowedAt: today,
          dueDate: due,
        ),
    ]);
    return BorrowResult.success;
  }

  String _keyOf(Book book) => '${book.title}|${book.author}';

  Book _withFreshStatus(Book book) {
    final loan = _loans.activeLoanOf(book.id);
    if (loan == null) return book.copyWith(status: BookStatus.available);

    final status = switch (FineCalculator.statusOf(loan, _now())) {
      LoanStatus.missing => BookStatus.missing,
      LoanStatus.overdue => BookStatus.overdue,
      _ => BookStatus.borrowed,
    };
    return book.copyWith(status: status);
  }
}