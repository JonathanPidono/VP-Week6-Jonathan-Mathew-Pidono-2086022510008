import 'package:flutter/foundation.dart';
import '../models/loan.dart';
import '../models/repo/book_repository.dart';
import '../models/repo/loan_repository.dart';
import '../models/service/loan_service.dart';

enum ReturnResult {
  returned,
  returnedWithCharge,
  alreadyReturned,
  notFound,
}

class BorrowedBooksViewModel extends ChangeNotifier {
  BorrowedBooksViewModel(this._books, this._loans,
      {DateTime Function()? clock})
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

  List<Loan> get activeLoans =>
      _loans.all.where((l) => l.returnedAt == null).toList();

  List<Loan> get overdueLoans => activeLoans
      .where((l) => getOverdueStatus(l) == LoanStatus.overdue)
      .toList();

  List<Loan> get missingLoans => activeLoans
      .where((l) => getOverdueStatus(l) == LoanStatus.missing)
      .toList();

  double get totalOutstandingFine =>
      _loans.all.fold(0.0, (sum, l) => sum + calculateFine(l));

  LoanStatus getOverdueStatus(Loan loan) =>
      FineCalculator.statusOf(loan, _now());

  double calculateFine(Loan loan) {
    if (loan.outstandingCharge > 0) return loan.outstandingCharge;

    final price = _books.byId(loan.bookId)?.replacementPrice ?? 0;
    return FineCalculator.totalCharge(
      loan.dueDate,
      loan.returnedAt ?? _now(),
      price,
    );
  }

  ReturnResult returnBook(String loanId) {
    final loan = _loans.byId(loanId);
    if (loan == null) return ReturnResult.notFound;
    if (loan.returnedAt != null) return ReturnResult.alreadyReturned;

    final now = _now();
    final wasMissing = FineCalculator.statusOf(loan, now) == LoanStatus.missing;

    if (wasMissing) {
      final price = _books.byId(loan.bookId)?.replacementPrice ?? 0;
      _loans.update(loan.copyWith(
        returnedAt: now,
        missingDeclaredAt: loan.missingDeclaredAt ??
            FineCalculator.missingDate(loan.dueDate),
        outstandingCharge:
            FineCalculator.totalCharge(loan.dueDate, now, price),
      ));
      return ReturnResult.returnedWithCharge;
    }

    _loans.update(loan.copyWith(returnedAt: now));
    return ReturnResult.returned;
  }

  String titleOf(Loan loan) => _books.byId(loan.bookId)?.title ?? loan.bookId;
}