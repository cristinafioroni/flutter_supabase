import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book_image.dart';
import '../viewmodel/book_view_model.dart';
import 'book_detail_view.dart';
import 'widget/custom_app_bar.dart';
import 'widget/bottom_nav_bar.dart';

class BooksListView extends StatefulWidget {
  const BooksListView({super.key});

  @override
  State<BooksListView> createState() => _BooksListViewState();
}

class _BooksListViewState extends State<BooksListView> {
  @override
  void initState() {
    super.initState();

    // Caricamento dei libri dopo il primo frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<BookViewModel>().loadBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),

      body: Consumer<BookViewModel>(
        builder: (context, viewModel, child) {
          final books = viewModel.books;

          if (books.isEmpty) {
            return const Center(
              child: Text(
                'Non hai ancora aggiunto libri',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];

              // Recupero la prima immagine del libro
              final images = book.images.whereType<BookImage>().toList();

              final coverUrl = images.isNotEmpty
                  ? images.first.imageUrl
                  : null;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  // Copertina del libro
                  leading: coverUrl != null
                      ? Image.network(
                          coverUrl,
                          width: 50,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.menu_book);
                          },
                        )
                      : const Icon(
                          Icons.menu_book,
                          size: 40,
                        ),

                  title: Text(book.title),
                  subtitle: Text(book.author),

                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),

                  // Apertura della pagina dettaglio
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailView(
                          book: book,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),

      bottomNavigationBar: const BottomNavBar(
        currentIndex: 2,
      ),
    );
  }
}