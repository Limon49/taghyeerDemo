class PostEntity {
  final int id;
  final String title;
  final String body;
  final int userId;
  final List<String> tags;
  final int reactions;
  
  const PostEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
    required this.tags,
    required this.reactions,
  });
  
  String get bodyPreview {
    if (body.length <= 100) return body;
    return '${body.substring(0, 100)}...';
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
        other.reactions == reactions;
  }
  
  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        body.hashCode ^
        userId.hashCode ^
        tags.hashCode ^
        reactions.hashCode;
  }
}
