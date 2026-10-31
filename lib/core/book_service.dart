import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/book_model.dart';
import '../models/book_image.dart';

class BookService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Book>> fetchBookForCurrentUser() async {
    final userId = _client.auth.currentUser?.id;

    if (userId == null) {
      return [];
    }

    // per ottenere i libri dell'utente corrente
    final response = await _client
        .from('books')
        .select()
        .eq('user_id', userId)
        // ordina i libri per data di creazione decrescente
        .order('created_at', ascending: false);

    return (response as List).map((book) => Book.fromMap(book)).toList();
  }

  // aggiungi un nuovo libro per l'utente corrente
  Future<void> createBook(Book book) async {
    final response = await _client.from('books').insert(book.toMap()).select();

    print("inserimento del libro $response");
  }

  Future<void> updateBook(Book book) async {
    final response = await _client
        .from('books')
        .update(book.toMap())
        .eq('id', book.id)
        .select();

    print("aggiornamento del libro $response");
  }

  Future<void> deleteBook(String bookId) async {
    await _client.from('books').delete().eq('id', bookId);

    print("cancellazione del libro $bookId");
  }

  Future<List<Book>> fetchBooks() async {
    final response = await _client
        .from('books')
        .select('*, book_images (id, book_id, image_url)')
        .order('created_at', ascending: false);

    final data = response as List;
    
    return data.map((map) {
      final images = (map['book_images'] as List<dynamic>? ?? [])
          .map((img) => BookImage.fromMap(img))
          .toList();

      return Book.fromMap(map);
    }).toList();
  }
}
