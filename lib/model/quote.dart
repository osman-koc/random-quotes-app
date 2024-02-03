import 'package:cloud_firestore/cloud_firestore.dart';

class QuoteModel {
  final String quote;
  final String author;

  QuoteModel({required this.quote, required this.author});

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      quote: json['quote'] ?? "",
      author: json['author'] ?? "",
    );
  }

  factory QuoteModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return QuoteModel(
      quote: data['quote'] ?? '',
      author: data['author'] ?? '',
    );
  }
}
