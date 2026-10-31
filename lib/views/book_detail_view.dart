import 'package:flutter/material.dart';
import '../models/book_image.dart';
import '../models/book_model.dart';
import 'widget/custom_app_bar.dart';
import '../../core/theme/app_color.dart';

class BookDetailView extends StatelessWidget {
  final Book book;

  const BookDetailView({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final images = book.images.whereType<BookImage>().toList();

    return Scaffold(
      appBar: const CustomAppBar(),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //* carousel view
            if (images.isNotEmpty)
              SizedBox(
                height: 200,
                child: CarouselView(
                  itemExtent: 300,
                  itemSnapping: true,
                  elevation: 2,
                  scrollDirection: Axis.horizontal,
                  children: images.map((img) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        img.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    );
                  }).toList(),
                ),
              )
            else
              Container(height: 200, color: AppColors.gold, child: const Center(child: Icon(Icons.photo, size: 40)),
              ),
            Text("Titolo: ${book.title}", style: Theme.of(context).textTheme.headlineMedium),
            Text("Autore: ${book.author}"),
            Text("Genere: ${book.genre}"),
            Text("Pagine: ${book.pages}"),
            Text("Stato di lettura: ${book.status.name}"),
            Text("Valutazione ${book.rating}/5"),
            if(book.comment.isNotEmpty)
              Text("Commento: \n ${book.comment}", style: TextStyle(fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
}