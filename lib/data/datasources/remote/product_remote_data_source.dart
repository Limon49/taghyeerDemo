import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/exceptions/failures.dart';
import '../../../core/constants/app_constants.dart';
import '../../models/product_model.dart';
import '../../models/pagination_response.dart';

abstract class ProductRemoteDataSource {
  Future<PaginationResponse<ProductModel>> getProducts(int limit, int skip);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;
  
  ProductRemoteDataSourceImpl({required this.client});
  
  @override
  Future<PaginationResponse<ProductModel>> getProducts(int limit, int skip) async {
    final response = await client.get(
      Uri.parse('${AppConstants.baseUrl}${AppConstants.productsEndpoint}?limit=$limit&skip=$skip'),
      headers: {'Content-Type': AppConstants.contentTypeHeader},
    );
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return PaginationResponse<ProductModel>.fromJson(
        json,
        (json) => ProductModel.fromJson(json as Map<String, dynamic>),
      );
    } else {
      throw ServerFailure('Failed to load products: ${response.statusCode}');
    }
  }
}
