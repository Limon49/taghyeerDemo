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
      try {
        final Map<String, dynamic> json = jsonDecode(response.body);
        
        final List<dynamic> postsData = json['posts'] ?? [];
        final int total = json['total'] ?? 0;
        final int skip = json['skip'] ?? 0;
        final int limit = json['limit'] ?? 10;
        
        final List<PostModel> postModels = postsData
            .map((postJson) => PostModel.fromJson(postJson as Map<String, dynamic>))
            .toList();
        
        return PaginationResponse<PostModel>(
          items: postModels,
          total: total,
          skip: skip,
          limit: limit,
        );
      } catch (e) {
        throw ServerFailure('Failed to parse posts: $e');
      }
    } else {
      throw ServerFailure('Failed to load posts: ${response.statusCode}');
    }
  }
}
