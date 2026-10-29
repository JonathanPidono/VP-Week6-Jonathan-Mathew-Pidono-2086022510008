import 'package:flutter/material.dart';
import 'models/repo/book_repository.dart';
import 'models/repo/loan_repository.dart';
import 'models/service/book_service.dart';
import 'viewmodels/borrowed_books_view_model.dart';
import 'viewmodels/library_view_model.dart';
import 'views/borrowed_books_screen.dart';
import 'views/library_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final bookRepository = BookRepository(BookService());
  final loanRepository = LoanRepository();
  await bookRepository.load();

  runApp(
    LibraryApp(
      libraryViewModel: LibraryViewModel(bookRepository, loanRepository),
      borrowedBooksViewModel:
          BorrowedBooksViewModel(bookRepository, loanRepository),
    ),
  );
}

class LibraryApp extends StatelessWidget {
  const LibraryApp({
    super.key,
    required this.libraryViewModel,
    required this.borrowedBooksViewModel,
  });

  final LibraryViewModel libraryViewModel;
  final BorrowedBooksViewModel borrowedBooksViewModel;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: LibraryScreen(
        viewModel: libraryViewModel,
        loansPageBuilder: (_) =>
            BorrowedBooksScreen(viewModel: borrowedBooksViewModel),
      ),
    );
  }
}