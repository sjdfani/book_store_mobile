class Book {
  final int id;
  final String title;
  final String author;
  final double rating;
  final int numberOfPages;
  final String language;
  final String description;
  final int price;
  final bool publish;
  final String image;

  Book(
    this.id,
    this.title,
    this.author,
    this.rating,
    this.numberOfPages,
    this.language,
    this.description,
    this.price,
    this.publish,
    this.image,
  );

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      json['id'],
      json['title'],
      json['author'],
      json['rating'],
      json['number_of_pages'],
      json['language'],
      json['description'],
      json['price'],
      json['publish'],
      json['image'],
    );
  }
}

class SavedItem {
  final int bookId;

  SavedItem(this.bookId);

  factory SavedItem.fromJson(Map<String, dynamic> json) {
    return SavedItem(json['book']);
  }
}
