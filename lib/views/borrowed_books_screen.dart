import 'package:flutter/material.dart';
import '../viewmodels/borrowed_books_view_model.dart';
import 'fine_summary_cards.dart';
import 'loan_card.dart';

class BorrowedBooksScreen extends StatelessWidget {
  const BorrowedBooksScreen({super.key, required this.viewModel});

  final BorrowedBooksViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buku yang Dipinjam')),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          final loans = viewModel.activeLoans;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              FineSummaryCard(
                totalFine: viewModel.totalOutstandingFine,
                overdueCount: viewModel.overdueLoans.length,
                missingCount: viewModel.missingLoans.length,
              ),
              const SizedBox(height: 16),
              if (loans.isEmpty)
                const _EmptyState()
              else
                for (final loan in loans)
                  LoanCard(
                    title: viewModel.titleOf(loan),
                    bookId: loan.bookId,
                    studentId: loan.studentId,
                    dueDate: loan.dueDate,
                    status: viewModel.getOverdueStatus(loan),
                    fine: viewModel.calculateFine(loan),
                    onReturn: () => _return(context, loan.id),
                  ),
            ],
          );
        },
      ),
    );
  }

  void _return(BuildContext context, String loanId) {
    final result = viewModel.returnBook(loanId);

    final message = switch (result) {
      ReturnResult.returned => 'Buku berhasil dikembalikan',
      ReturnResult.returnedWithCharge =>
        'Buku dikembalikan. Tagihan sebelumnya tetap berlaku.',
      ReturnResult.alreadyReturned => 'Buku ini sudah dikembalikan',
      ReturnResult.notFound => 'Data peminjaman tidak ditemukan',
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 8),
            const Text('Tidak ada buku yang sedang dipinjam.'),
          ],
        ),
      ),
    );
  }
}