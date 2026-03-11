import 'package:json_annotation/json_annotation.dart';
part 'pagination_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class PaginationResponse<T> {
  final List<T> items;
  final int total;
  final int skip;
  final int limit;
  
  const PaginationResponse({
    required this.items,
    required this.total,
    required this.skip,
    required this.limit,
  });
  
  factory PaginationResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$PaginationResponseFromJson(json, fromJsonT);
  
  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$PaginationResponseToJson(this, toJsonT);
}
