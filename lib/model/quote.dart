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
    List<String> likedUserIds = [];

    var likedByUsersField = 'likedByUsers';
    if (data.containsKey(likedByUsersField) &&
        data[likedByUsersField] != null) {
      var _likedUserData = data[likedByUsersField];
      likedUserIds = (_likedUserData as List).map((x) => x as String).toList();
    }

    return QuoteModel(
      id: doc.id,
      quote: data['quote'] ?? '',
      author: data['author'] ?? '',
      likedByUsers: likedUserIds,
      likeCount: data['likeCount'] ?? 0,
      isLiked: likedUserIds.contains(AppSettings.userId),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'quote': quote,
      'author': author,
      'likedByUsers': likedByUsers,
      'likeCount': likeCount,
    };
  }

  void addLikedUser() {
    var currentUserId = AppSettings.userId;
    if (currentUserId.isNotEmpty && !likedByUsers.contains(currentUserId)) {
      likedByUsers.add(currentUserId);
      likeCount++;
      isLiked = true;
    }
  }

  void removeLikedUser() {
    var currentUserId = AppSettings.userId;
    if (currentUserId.isNotEmpty && likedByUsers.contains(currentUserId)) {
      likedByUsers.remove(currentUserId);
      likeCount--;
      isLiked = false;
    }
  }
}
