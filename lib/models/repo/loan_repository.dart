import 'package:flutter/foundation.dart';
import '../loan.dart';

class LoanRepository extends ChangeNotifier {
  final List<Loan> _loans = [];

  List<Loan> get all => List.unmodifiable(_loans);

  Loan? byId(String id) {
    for (final loan in _loans) {
      if (loan.id == id) return loan;
    }
    return null;
  }

  Loan? activeLoanOf(String bookId) {
    for (final loan in _loans) {
      if (loan.bookId == bookId && loan.returnedAt == null) return loan;
    }
    return null;
  }

  bool hasActiveLoanFor(String bookId) => activeLoanOf(bookId) != null;

  void add(Loan loan) {
    _loans.add(loan);
    notifyListeners();
  }

  void addAll(List<Loan> loans) {
    if (loans.isEmpty) return;
    _loans.addAll(loans);
    notifyListeners();
  }

  void update(Loan loan) {
    final index = _loans.indexWhere((l) => l.id == loan.id);
    if (index == -1) return;
    _loans[index] = loan;
    notifyListeners();
  }
}