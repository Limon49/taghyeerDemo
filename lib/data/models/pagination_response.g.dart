part of 'pagination_response.dart';

PaginationResponse<T> _$PaginationResponseFromJson<T>(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,) {
  return PaginationResponse<T>(
    items: (json['items'] as List<dynamic>?)
            ?.map((e) => fromJsonT(e))
            .toList() ??
        [],
    total: (json['total'] as int?) ?? 0,
    skip: (json['skip'] as int?) ?? 0,
    limit: (json['limit'] as int?) ?? 0,
  );
}

Map<String, dynamic> _$PaginationResponseToJson<T>(
    PaginationResponse<T> instance,
    Object Function(T value) toJsonT,) =>
    <String, dynamic>{
      'items': instance.items.map(toJsonT).toList(),
      'total': instance.total,
      'skip': instance.skip,
      'limit': instance.limit,
    };
