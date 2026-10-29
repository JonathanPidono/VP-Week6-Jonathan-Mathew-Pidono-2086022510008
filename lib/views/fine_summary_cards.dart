import 'package:flutter/material.dart';

String formatRupiah(double amount) {
  final digits = amount.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return 'Rp$buffer';
}

class FineSummaryCard extends StatelessWidget {
  const FineSummaryCard({
    super.key,
    required this.totalFine,
    required this.overdueCount,
    required this.missingCount,
  });

  final double totalFine;
  final int overdueCount;
  final int missingCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card.filled(
      color: scheme.secondaryContainer,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total tagihan',
              style: theme.textTheme.labelLarge
                  ?.copyWith(color: scheme.onSecondaryContainer),
            ),
            const SizedBox(height: 4),
            Text(
              formatRupiah(totalFine),
              style: theme.textTheme.headlineMedium?.copyWith(
                color: scheme.onSecondaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Terlambat: $overdueCount   Hilang: $missingCount',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: scheme.onSecondaryContainer),
            ),
          ],
        ),
      ),
    );
  }
}