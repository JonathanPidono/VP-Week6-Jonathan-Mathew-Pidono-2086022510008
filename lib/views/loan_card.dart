import 'package:flutter/material.dart';
import '../models/loan.dart';
import 'fine_summary_cards.dart' show formatRupiah;

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
  'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
];

String _formatDate(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

class LoanCard extends StatelessWidget {
  const LoanCard({
    super.key,
    required this.title,
    required this.bookId,
    required this.studentId,
    required this.dueDate,
    required this.status,
    required this.fine,
    required this.onReturn,
  });

  final String title;
  final String bookId;
  final String studentId;
  final DateTime dueDate;
  final LoanStatus status;
  final double fine;
  final VoidCallback onReturn;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final (label, background, foreground) = switch (status) {
      LoanStatus.borrowed => (
          'Dipinjam',
          scheme.primaryContainer,
          scheme.onPrimaryContainer,
        ),
      LoanStatus.returned => (
          'Dikembalikan',
          scheme.surfaceContainerHighest,
          scheme.onSurface,
        ),
      LoanStatus.overdue => (
          'Terlambat',
          scheme.tertiaryContainer,
          scheme.onTertiaryContainer,
        ),
      LoanStatus.missing => (
          'Hilang',
          scheme.errorContainer,
          scheme.onErrorContainer,
        ),
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(title, style: theme.textTheme.titleMedium),
                ),
                Chip(
                  label: Text(label),
                  backgroundColor: background,
                  labelStyle: TextStyle(color: foreground),
                  side: BorderSide.none,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text('ID Buku: $bookId'),
            Text('Mahasiswa: $studentId'),
            Text('Jatuh tempo: ${_formatDate(dueDate)}'),
            if (fine > 0)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Tagihan: ${formatRupiah(fine)}',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(color: scheme.error),
                ),
              ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.tonalIcon(
                onPressed: onReturn,
                icon: const Icon(Icons.assignment_return_outlined),
                label: const Text('Kembalikan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}