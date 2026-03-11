import 'package:json_annotation/json_annotation.dart';

part 'post_model.g.dart';

@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
)
class PostModel {
  @JsonKey(defaultValue: 0)
  final int id;
  @JsonKey(defaultValue: '')
  final String title;
  @JsonKey(defaultValue: '')
  final String body;
  @JsonKey(defaultValue: 0)
  final int userId;
  final List<String> tags;
  final Map<String, dynamic>? reactions;
  @JsonKey(defaultValue: 0)
  final int views;
  
  const PostModel({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
    required this.tags,
    this.reactions,
    required this.views,
  });
  
  factory PostModel.fromJson(Map<String, dynamic> json) {
    print('PostModel JSON input: $json');
    
    try {
      final result = _$PostModelFromJson(json);
      print('PostModel parsed successfully: $result');
      return result;
    } catch (e) {
      print('PostModel parsing error: $e');
      print('JSON keys: ${json.keys}');
      print('JSON types: ${json.map((key, value) => MapEntry(key, value.runtimeType))}');
      rethrow;
    }
  }
  
  Map<String, dynamic> toJson() => _$PostModelToJson(this);
  
  // Helper method to get total reactions count
  int get totalReactions {
    if (reactions == null) return 0;
    final likes = (reactions!['likes'] as num?)?.toInt() ?? 0;
    final dislikes = (reactions!['dislikes'] as num?)?.toInt() ?? 0;
    return likes + dislikes;
  }
}
