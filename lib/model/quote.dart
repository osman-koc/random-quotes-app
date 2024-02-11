import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:randomquotes/constants/app_settings.dart';

class QuoteModel {
  final String id;
  final String quote;
  final String author;
  List<String> likedByUsers;
  int likeCount;
  bool isLiked = false;

  QuoteModel({
    required this.id,
    required this.quote,
    required this.author,
    required this.likedByUsers,
    required this.likeCount,
    isLiked,
  });

  factory QuoteModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return QuoteModel(
      id: doc.id,
      quote: data['quote'] ?? '',
      author: data['author'] ?? '',
      likedByUsers: data['likedByUsers'] ?? [],
      likeCount: data['likeCount'] ?? 0,
      isLiked: data['likedByUsers']?.contains(AppSettings.userId) ?? false,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'quote': quote,
      'author': author,
      'likedByUsers': likedByUsers.toList(),
      'likeCount': likeCount,
    };
  }

  void addLikedUser(){
    var currentUserId = AppSettings.userId;
    if (!likedByUsers.contains(currentUserId)){
      likedByUsers.add(currentUserId);
      likeCount++;
      isLiked = true;
    }
  }

  void removeLikedUser(){
    var currentUserId = AppSettings.userId;
    if (likedByUsers.contains(currentUserId)){
      likedByUsers.remove(currentUserId);
      likeCount--;
      isLiked = false;
    }
  }
}
