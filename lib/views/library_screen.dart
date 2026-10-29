import 'package:flutter/material.dart';
import '../viewmodels/library_view_model.dart';
import 'book_card.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({
    super.key,
    required this.viewModel,
    required this.loansPageBuilder,
  });

  final LibraryViewModel viewModel;
  final WidgetBuilder loansPageBuilder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Perpustakaan'),
        actions: [
          IconButton(
            tooltip: 'Buku yang dipinjam',
            icon: const Icon(Icons.assignment_return_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: loansPageBuilder),
            ),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          final groups = viewModel.groups;

          if (groups.isEmpty) {
            return const _EmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return BookCard(
                title: group.title,
                author: group.author,
                availableCount: group.availableCount,
                borrowedCount: group.borrowedCount,
                overdueCount: group.overdueCount,
                missingCount: group.missingCount,
                onBorrow: group.hasStock ? () => _borrow(context, group) : null,
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _borrow(BuildContext context, BookGroup group) async {
    final request = await showDialog<({String studentId, int count})>(
      context: context,
      builder: (_) => _BorrowDialog(
        title: group.title,
        maxCount: group.availableCount,
      ),
    );
    if (request == null || !context.mounted) return;

    final result = viewModel.borrowBook(
      group.key,
      request.studentId,
      request.count,
    );

    final message = switch (result) {
      BorrowResult.success =>
        'Berhasil meminjam ${request.count} buku "${group.title}"',
      BorrowResult.invalidStudentId => 'ID mahasiswa wajib diisi',
      BorrowResult.invalidCount => 'Jumlah buku tidak valid',
      BorrowResult.bookNotFound => 'Buku tidak ditemukan',
      BorrowResult.notEnoughStock => 'Stok buku tidak mencukupi',
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
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.menu_book_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 8),
          const Text('Belum ada buku di katalog.'),
        ],
      ),
    );
  }
}

class _BorrowDialog extends StatefulWidget {
  const _BorrowDialog({required this.title, required this.maxCount});

  final String title;
  final int maxCount;

  @override
  State<_BorrowDialog> createState() => _BorrowDialogState();
}

class _BorrowDialogState extends State<_BorrowDialog> {
  final _controller = TextEditingController();
  int _count = 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Pinjam "${widget.title}"'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'ID Mahasiswa',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Jumlah'),
              const Spacer(),
              IconButton(
                onPressed: _count > 1 ? () => setState(() => _count--) : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('$_count'),
              IconButton(
                onPressed: _count < widget.maxCount
                    ? () => setState(() => _count++)
                    : null,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          Text('Tersedia: ${widget.maxCount}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(
            (studentId: _controller.text, count: _count),
          ),
          child: const Text('Pinjam'),
        ),
      ],
    );
  }
}