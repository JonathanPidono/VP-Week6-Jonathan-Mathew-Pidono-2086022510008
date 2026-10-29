enum LoanStatus { borrowed, returned, overdue, missing }

class Loan {
  final String id;
  final String bookId;
  final String studentId;
  final DateTime borrowedAt;
  final DateTime dueDate;
  final DateTime? returnedAt;
  final DateTime? missingDeclaredAt;
  final double outstandingCharge;

  const Loan({
    required this.id,
    required this.bookId,
    required this.studentId,
    required this.borrowedAt,
    required this.dueDate,
    this.returnedAt,
    this.missingDeclaredAt,
    this.outstandingCharge = 0,
  });

  Loan copyWith({DateTime? returnedAt, DateTime? missingDeclaredAt, double? outstandingCharge,}) {
    return Loan(
      id: id,
      bookId: bookId,
      studentId: studentId,
      borrowedAt: borrowedAt,
      dueDate: dueDate,
      returnedAt: returnedAt ?? this.returnedAt,
      missingDeclaredAt: missingDeclaredAt ?? this.missingDeclaredAt,
      outstandingCharge: outstandingCharge ?? this.outstandingCharge,
    );
  }
}