import 'package:book_store_mobile/models/book_model.dart';

// ignore: non_constant_identifier_names
class PurchaseItems {
  final int id;
  final Book book;
  final int count;
  // ignore: non_constant_identifier_names
  final int price_of_one_book;
  // ignore: non_constant_identifier_names
  final String? date_of_payment;
  // ignore: non_constant_identifier_names
  final String? transaction_id;

  PurchaseItems(
    this.id,
    this.book,
    this.count,
    this.price_of_one_book,
    this.date_of_payment,
    this.transaction_id,
  );

  factory PurchaseItems.fromJson(Map<String, dynamic> json) {
    Book book1 = Book.fromJson(json['book']);
    return PurchaseItems(
      json['id'],
      book1,
      json['count'],
      json['price_of_one_book'],
      json['date_of_payment'],
      json['transaction_id'],
    );
  }
}

class Cart {
  final int bookId;

  Cart(this.bookId);

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(json['book']);
  }
}

class TotalPrice {
  // ignore: non_constant_identifier_names
  final int total_price;

  TotalPrice(this.total_price);

  factory TotalPrice.fromJson(Map<String, dynamic> json) {
    return TotalPrice(json['total_price']);
  }
}
