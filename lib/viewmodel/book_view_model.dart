import 'package:flutter/material.dart';

import '../core/book_service.dart';
import '../models/book_model.dart';

class BookViewModel extends ChangeNotifier {
  // qui puoi aggiungere le proprietà e i metodi per gestire lo stato dei libri
  final BookService _bookService = BookService();
  List<Book> _books = [];
  bool _isLoading = false;

  List<Book> get books => _books;

  Future<void> loadBooks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _books = await _bookService.fetchBookForCurrentUser();
    } catch (e) {
      // stampa l'errore
      print("Errore durante il caricamento dei libri: $e");
    } 
      _isLoading = false;
      notifyListeners();
  }

  //* metodo per aggiungere un libro
  Future<void> addBook(Book book) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _bookService.createBook(book);
      _books.insert(0, book);
      notifyListeners();

    } catch (e) {
      print("Errore durante l'aggiunta del libro: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  //* aggiornamento di un libro
  Future<void> updateBook(Book updatedBook) async {
    try {
      await _bookService.updateBook(updatedBook);
      // b = book 
      final index = _books.indexWhere((b) => b.id == updatedBook.id);
      if (index != -1) {
        _books[index] = updatedBook;
        notifyListeners();
      }
    } catch (e) {
      print("Errore durante l'aggiornamento del libro: $e");
    }
  }
  
  //* eliminazione di un libro
  Future<void> deleteBook(String bookId) async {

    try {
      await _bookService.deleteBook(bookId);
      _books.removeWhere((b) => b.id == bookId);
      notifyListeners();
    } catch (e) {
      print("Errore durante l'eliminazione del libro: $e");
    }
  }
}
    
