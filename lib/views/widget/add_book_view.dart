
import 'package:flutter/material.dart';
import 'package:flutter_supabase/models/book_model.dart';

import '../../core/theme/app_color.dart';
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

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _genreController.dispose();
    _pagesController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Logica per salvare il libro
      final title = _titleController.text;
      final author = _authorController.text;
      final genre = _genreController.text;
      final pages = int.tryParse(_pagesController.text);
      final status = _selectedStatus;
      final rating = _rating;
      final comment = _commentController.text;

      // Esempio di stampa dei dati
      print('Titolo: $title');
      print('Autore: $author');
      print('Genere: $genre');
      print('Pagine: $pages');
      print('Stato: ${status?.toDbValue()}');
      print('Valutazione: $rating');
      print('Commento: $comment');
    }
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
                  validator: (value) =>
                      value == null || value.trim().isEmpty
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
                  validator: (value) =>
                      value == null || value.trim().isEmpty
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
                  validator: (value) =>
                      value == null || value.trim().isEmpty
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
                  validator: (value) => value == null
                      ? 'Seleziona uno stato di lettura'
                      : null,
                ),

                const SizedBox(height: 16),

                //* Slider per la valutazione
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Valutazione',
                      style: TextStyle(fontSize: 16),
                    ),
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

                //* Pulsante per continuare
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color.fromARGB(255, 72, 15, 129),
                    foregroundColor:
                        const Color.fromARGB(255, 223, 191, 117),
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