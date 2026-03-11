import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
)
class ProductModel {
  @JsonKey(defaultValue: 0)
  final int id;
  @JsonKey(defaultValue: '')
  final String title;
  @JsonKey(defaultValue: '')
  final String description;
  @JsonKey(defaultValue: 0.0)
  final double price;
  @JsonKey(name: 'discountPercentage', defaultValue: 0.0)
  final double discountPercentage;
  @JsonKey(defaultValue: 0.0)
  final double rating;
  @JsonKey(defaultValue: 0)
  final int stock;
  @JsonKey(defaultValue: '')
  final String brand;
  @JsonKey(defaultValue: '')
  final String category;
  @JsonKey(defaultValue: '')
  final String thumbnail;
  final List<String> images;
  
  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.category,
    required this.thumbnail,
    required this.images,
  });
  
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    print('ProductModel JSON input: $json');
    
    try {
      final result = _$ProductModelFromJson(json);
      print('ProductModel parsed successfully: $result');
      return result;
    } catch (e) {
      print('ProductModel parsing error: $e');
      print('JSON keys: ${json.keys}');
      print('JSON types: ${json.map((key, value) => MapEntry(key, value.runtimeType))}');
      rethrow;
    }
  }
  
  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
