import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_supabase/models/book_model.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/book_image.dart';
import '../../core/theme/app_color.dart';
import '../../viewmodel/book_view_model.dart';
import '../../core/storage_service.dart';
import '../../core/book_image_service.dart';
import 'custom_app_bar.dart';
import 'bottom_nav_bar.dart';

String _statusLabel(BookStatus status) {
  switch (status) {
    case BookStatus.nonLetto:
      return 'Non letto';
    case BookStatus.inLettura:
      return 'In lettura';
    case BookStatus.daLeggere:
      return 'Da leggere';
    case BookStatus.lasciato:
      return 'Lasciato';
    case BookStatus.letto:
      return 'Letto';
  }
}

class AddBookView extends StatefulWidget {
  const AddBookView({super.key});

  @override
  State<AddBookView> createState() => _AddBookViewState();
}

class _AddBookViewState extends State<AddBookView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _genreController = TextEditingController();
  final _pagesController = TextEditingController();
  final _commentController = TextEditingController();

  // Stato di lettura selezionato dall'utente
  BookStatus? _selectedStatus;

  // Valutazione iniziale del libro
  double _rating = 3.0;
  List<File> _selectedImages = [];

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _genreController.dispose();
    _pagesController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedStatus != null) {
      // Recupero l'ID dell'utente autenticato
      final userId = Supabase.instance.client.auth.currentUser?.id;

      if (userId == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Utente non autenticato')));
        return;
      }

      // Logica per salvare il libro
      final newBook = Book(
        id: const Uuid().v4(),
        userId: userId,
        title: _titleController.text.trim(),
        genre: _genreController.text.trim(),
        author: _authorController.text.trim(),
        pages: int.tryParse(_pagesController.text) ?? 0,
        rating: _rating.toInt(),
        comment: _commentController.text.trim(),
        status: _selectedStatus!,
        createdAt: DateTime.now(),
      );

      final messenger = ScaffoldMessenger.of(context);

      try {
        // Salvataggio del libro tramite BookViewModel
        await Provider.of<BookViewModel>(
          context,
          listen: false,
        ).addBook(newBook);

        // Controllo del libro appena salvato
        final client = Supabase.instance.client;

        debugPrint('UTENTE AUTENTICATO: ${client.auth.currentUser?.id}');
        debugPrint('ID LIBRO: ${newBook.id}');

        final booksFound = await client
            .from('books')
            .select('id, user_id')
            .eq('id', newBook.id);

        debugPrint('LIBRI VISIBILI: $booksFound');
        debugPrint('NUMERO IMMAGINI: ${_selectedImages.length}');

        // Caricamento delle immagini selezionate
        if (_selectedImages.isNotEmpty) {
          final storageService = StorageService();
          final imageService = BookImageService();

          for (final image in _selectedImages) {
            final imageUrl = await storageService.uploadImage(
              image,
              newBook.id,
            );

            debugPrint('URL IMMAGINE: $imageUrl');

            final bookImage = BookImage(
              id: const Uuid().v4(),
              bookId: newBook.id,
              imageUrl: imageUrl,
            );

            await imageService.createBookImage(bookImage);

            debugPrint('IMMAGINE SALVATA NEL DATABASE');
          }
        }

        // Controllo che il widget sia ancora presente
        if (!mounted) return;

        // Messaggio di conferma
        messenger.showSnackBar(
          const SnackBar(content: Text('Libro aggiunto con successo')),
        );

        // Torno alla schermata precedente
        Navigator.pop(context);
      } catch (e) {
        debugPrint("Errore durante l'aggiunta del libro: $e");

        if (!mounted) return;

        messenger.showSnackBar(
          const SnackBar(content: Text("Errore durante l'aggiunta del libro")),
        );
      }
    }
  }

  // metodo per il caricamento delle immagini
  Future<void> _pickMultipleImages() async {
    final result = await ImagePicker().pickMultiImage();

    if (result.isEmpty || !mounted) return;

    setState(() {
      _selectedImages = result.map((image) => File(image.path)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //* AppBar personalizzata
      appBar: const CustomAppBar(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Inserisci libro',
                  style: TextStyle(
                    fontFamily: 'HennyPenny',
                    fontSize: 32,
                    color: AppColors.gold,
                  ),
                ),

                const SizedBox(height: 16),

                //* Campo per il titolo
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Titolo',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'campo obbligatorio'
                      : null,
                ),

                const SizedBox(height: 16),

                //* Campo per l'autore
                TextFormField(
                  controller: _authorController,
                  decoration: const InputDecoration(
                    labelText: 'Autore',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'campo obbligatorio'
                      : null,
                ),

                const SizedBox(height: 16),

                //* Campo per il genere
                TextFormField(
                  controller: _genreController,
                  decoration: const InputDecoration(
                    labelText: 'Genere',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'campo obbligatorio'
                      : null,
                ),

                const SizedBox(height: 16),

                //* Campo per il numero di pagine
                TextFormField(
                  controller: _pagesController,
                  decoration: const InputDecoration(
                    labelText: 'Numero di pagine',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return null;
                    }

                    final pages = int.tryParse(value);

                    if (pages == null || pages <= 0) {
                      return 'Inserisci un numero valido';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                //* Dropdown per lo stato di lettura
                DropdownButtonFormField<BookStatus>(
                  initialValue: _selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Stato',
                    border: OutlineInputBorder(),
                  ),
                  items: BookStatus.values.map((status) {
                    return DropdownMenuItem<BookStatus>(
                      value: status,
                      child: Text(_statusLabel(status)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Seleziona uno stato di lettura' : null,
                ),

                const SizedBox(height: 16),

                //* Slider per la valutazione
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Valutazione', style: TextStyle(fontSize: 16)),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: _rating,
                            min: 1,
                            max: 5,
                            divisions: 4,
                            onChanged: (value) {
                              setState(() {
                                _rating = value;
                              });
                            },
                          ),
                        ),
                        Text('${_rating.toStringAsFixed(0)} ⭐'),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                //* Campo per il commento
                TextFormField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    labelText: 'Commento',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 5,
                ),

                const SizedBox(height: 20),

                //* inserimento file copertina
                ElevatedButton.icon(
                  onPressed: _pickMultipleImages,
                  label: const Text('Seleziona Immagini'),
                  icon: Icon(Icons.photo_library),
                ),
                if (_selectedImages.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ..._selectedImages.map((file) {
                        return Image.file(
                          file,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        );
                      }).toList(),
                    ],
                  ),

                const SizedBox(height: 16),

                //* Pulsante per continuare
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 72, 15, 129),
                    foregroundColor: const Color.fromARGB(255, 223, 191, 117),
                  ),
                  onPressed: _submitForm,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Continua'),
                ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }
}
