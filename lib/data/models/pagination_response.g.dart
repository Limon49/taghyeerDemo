// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationResponse<T> _$PaginationResponseFromJson<T>(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,) {
  return PaginationResponse<T>(
    products: (json['products'] as List<dynamic>?)
            ?.map((e) => fromJsonT(e))
            .toList() ??
        [],
    posts: (json['posts'] as List<dynamic>?)
            ?.map((e) => fromJsonT(e))
            .toList() ??
        [],
    total: json['total'] as int,
    skip: json['skip'] as int,
    limit: json['limit'] as int,
  );
}

Map<String, dynamic> _$PaginationResponseToJson<T>(
    PaginationResponse<T> instance,
    Object Function(T value) toJsonT,) =>
    <String, dynamic>{
      'products': instance.products.map(toJsonT).toList(),
      'posts': instance.posts.map(toJsonT).toList(),
      'total': instance.total,
      'skip': instance.skip,
      'limit': instance.limit,
    };
