import 'package:flutter/foundation.dart';

class PostEntity {
  final int id;
  final String title;
  final String body;
  final int userId;
  final List<String> tags;
  final Map<String, dynamic>? reactions;
  final int views;
  
  const PostEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
    required this.tags,
    this.reactions,
    required this.views,
  });
  
  String get bodyPreview {
    if (body.length <= 100) return body;
    return '${body.substring(0, 100)}...';
  }
  
  int get totalReactions {
    if (reactions == null) return 0;
    final likes = (reactions!['likes'] as num?)?.toInt() ?? 0;
    final dislikes = (reactions!['dislikes'] as num?)?.toInt() ?? 0;
    return likes + dislikes;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PostEntity &&
        other.id == id &&
        other.title == title &&
        other.body == body &&
        other.userId == userId &&
        other.tags == tags &&
        other.reactions == reactions &&
        other.views == views;
  }
  
  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        body.hashCode ^
        userId.hashCode ^
        tags.hashCode ^
        reactions.hashCode ^
        views.hashCode;
  }
}
