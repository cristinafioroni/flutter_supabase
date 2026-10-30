class BookImage {
  final String id;
  final String bookId;
  final String imageUrl;

  BookImage({
    required this.id,
    required this.bookId,
    required this.imageUrl,
  });

  factory BookImage.fromJson(Map<String, dynamic> json) {
    return BookImage(
      id: json['id'],
      bookId: json['book_id'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'book_id': bookId,
      'image_url': imageUrl,
    };
  }
}