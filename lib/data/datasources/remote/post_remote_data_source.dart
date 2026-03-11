import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/exceptions/failures.dart';
import '../../../core/constants/app_constants.dart';
import '../../models/post_model.dart';
import '../../models/pagination_response.dart';

abstract class PostRemoteDataSource {
  Future<PaginationResponse<PostModel>> getPosts(int limit, int skip);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final http.Client client;
  
  PostRemoteDataSourceImpl({required this.client});
  
  @override
  Future<PaginationResponse<PostModel>> getPosts(int limit, int skip) async {
    final response = await client.get(
      Uri.parse('${AppConstants.baseUrl}${AppConstants.postsEndpoint}?limit=$limit&skip=$skip'),
      headers: {'Content-Type': AppConstants.contentTypeHeader},
    );
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return PaginationResponse<PostModel>.fromJson(
        json,
        (json) => PostModel.fromJson(json as Map<String, dynamic>),
      );
    } else {
      throw ServerFailure('Failed to load posts: ${response.statusCode}');
    }
  }
}
