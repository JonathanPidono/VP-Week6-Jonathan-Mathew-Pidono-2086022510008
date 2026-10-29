import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  const BookCard({
    super.key,
    required this.title,
    required this.author,
    required this.availableCount,
    required this.borrowedCount,
    required this.overdueCount,
    required this.missingCount,
    required this.onBorrow,
  });

  final String title;
  final String author;
  final int availableCount;
  final int borrowedCount;
  final int overdueCount;
  final int missingCount;
  final VoidCallback? onBorrow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            Text(
              author,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _StockChip(
                  label: 'Tersedia $availableCount',
                  background: scheme.primaryContainer,
                  foreground: scheme.onPrimaryContainer,
                ),
                if (borrowedCount > 0)
                  _StockChip(
                    label: 'Dipinjam $borrowedCount',
                    background: scheme.secondaryContainer,
                    foreground: scheme.onSecondaryContainer,
                  ),
                if (overdueCount > 0)
                  _StockChip(
                    label: 'Terlambat $overdueCount',
                    background: scheme.tertiaryContainer,
                    foreground: scheme.onTertiaryContainer,
                  ),
                if (missingCount > 0)
                  _StockChip(
                    label: 'Hilang $missingCount',
                    background: scheme.errorContainer,
                    foreground: scheme.onErrorContainer,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: onBorrow,
                icon: const Icon(Icons.bookmark_add_outlined),
                label: const Text('Pinjam'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StockChip extends StatelessWidget {
  const _StockChip({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: background,
      labelStyle: TextStyle(color: foreground),
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
    );
  }
}