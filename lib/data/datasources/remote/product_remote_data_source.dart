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
    print('ProductRemoteDataSource: Getting products with limit=$limit, skip=$skip');
    
    final response = await client.get(
      Uri.parse('${AppConstants.baseUrl}${AppConstants.productsEndpoint}?limit=$limit&skip=$skip'),
      headers: {'Content-Type': AppConstants.contentTypeHeader},
    );
    
    print('Product API Response Status: ${response.statusCode}');
    print('Product API Response Body: ${response.body}');
    
    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> json = jsonDecode(response.body);
        print('Product API Decoded JSON: $json');

        //todo dummy for post
        final List<dynamic> productsData = json['products'] ?? [];
        final int total = json['total'] ?? 0;
        final int skip = json['skip'] ?? 0;
        final int limit = json['limit'] ?? 10;
        
        print('Raw products data: $productsData');
        
        final List<ProductModel> productModels = productsData
            .map((productJson) => ProductModel.fromJson(productJson as Map<String, dynamic>))
            .toList();
        
        print('Converted ${productModels.length} product models');
        
        final paginationResponse = PaginationResponse<ProductModel>(
          items: productModels,
          total: total,
          skip: skip,
          limit: limit,
        );
        
        print('Product Pagination Response: ${paginationResponse.items.length} items');
        return paginationResponse;
      } catch (e) {
        print('Error parsing product response: $e');
        throw ServerFailure('Failed to parse products: $e');
      }
    } else {
      throw ServerFailure('Failed to load products: ${response.statusCode}');
    }
  }
}
