import '../loan.dart';

class FinePolicy {
  static const int loanPeriodDays = 6;
  static const int daysPerWeek = 7;
  static const int weeklyRateIncrease = 5000;
  static const int missingAfterMonths = 6;
}

class FineCalculator {
  static DateTime _day(DateTime x) => DateTime.utc(x.year, x.month, x.day);

  static int daysLate(DateTime due, DateTime end) {
    final days = _day(end).difference(_day(due)).inDays;
    return days < 0 ? 0 : days;
  }

  static DateTime missingDate(DateTime due) {
    final d = _day(due);
    final month = d.month + FinePolicy.missingAfterMonths;
    final lastDay = DateTime.utc(d.year, month + 1, 0).day;
    return DateTime.utc(d.year, month, d.day > lastDay ? lastDay : d.day);
  }

  static bool isMissing(DateTime due, DateTime end) =>
      !_day(end).isBefore(missingDate(due));

  static double overdueFine(DateTime due, DateTime end) {
    final cappedEnd =
        isMissing(due, end) ? missingDate(due) : _day(end);

    final chargeable = daysLate(due, cappedEnd);
    if (chargeable <= 0) return 0;

    final weeks = chargeable ~/ FinePolicy.daysPerWeek;
    final rest = chargeable % FinePolicy.daysPerWeek; 

    final weekRate = FinePolicy.weeklyRateIncrease;
    final completedWeeksFine = weekRate *
        FinePolicy.daysPerWeek *
        (weeks * (weeks + 1) ~/ 2);
    final currentWeekFine = rest * weekRate * (weeks + 1);

    return (completedWeeksFine + currentWeekFine).toDouble();
  }

  static double totalCharge(
    DateTime due,
    DateTime end,
    double replacementPrice,
  ) {
    final fine = overdueFine(due, end);
    return isMissing(due, end) ? fine + replacementPrice : fine;
  }

  static LoanStatus statusOf(Loan loan, DateTime now) {
    final end = loan.returnedAt ?? now;

    if (loan.missingDeclaredAt != null || isMissing(loan.dueDate, end)) {
      return LoanStatus.missing;
    }
    if (loan.returnedAt != null) return LoanStatus.returned;
    if (daysLate(loan.dueDate, now) > 0) return LoanStatus.overdue;
    return LoanStatus.borrowed;
  }
}