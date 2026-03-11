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
    print('PostRemoteDataSource: Getting posts with limit=$limit, skip=$skip');
    
    final response = await client.get(
      Uri.parse('${AppConstants.baseUrl}${AppConstants.postsEndpoint}?limit=$limit&skip=$skip'),
      headers: {'Content-Type': AppConstants.contentTypeHeader},
    );
    
    print('Post API Response Status: ${response.statusCode}');
    print('Post API Response Body: ${response.body}');
    
    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> json = jsonDecode(response.body);
        print('Post API Decoded JSON keys: ${json.keys}');
        print('Post API full JSON: $json');
        
        // Check what fields are available
        if (json.containsKey('posts')) {
          print('Found "posts" field');
          final List<dynamic> postsData = json['posts'] ?? [];
          print('Raw posts data: $postsData');
          print('Posts data type: ${postsData.runtimeType}');
          print('Posts data length: ${postsData.length}');
          
          if (postsData.isEmpty) {
            print('Warning: No posts data found in API response');
            return PaginationResponse<PostModel>(
              items: [],
              total: json['total'] ?? 0,
              skip: json['skip'] ?? 0,
              limit: json['limit'] ?? 10,
            );
          }
          
          // Convert to PostModel objects
          final List<PostModel> postModels = [];
          for (int i = 0; i < postsData.length; i++) {
            try {
              final postJson = postsData[i] as Map<String, dynamic>;
              print('Processing post $i: $postJson');
              final postModel = PostModel.fromJson(postJson);
              postModels.add(postModel);
              print('Successfully converted post $i');
            } catch (e) {
              print('Error converting post $i: $e');
              print('Post data that failed: ${postsData[i]}');
            }
          }
          
          print('Converted ${postModels.length} post models successfully');
          
          // Create PaginationResponse
          final paginationResponse = PaginationResponse<PostModel>(
            items: postModels,
            total: json['total'] ?? 0,
            skip: json['skip'] ?? 0,
            limit: json['limit'] ?? 10,
          );
          
          print('Post Pagination Response: ${paginationResponse.items.length} items');
          return paginationResponse;
        } else {
          print('ERROR: "posts" field not found in response');
          print('Available fields: ${json.keys}');
          // Return empty response
          return PaginationResponse<PostModel>(
            items: [],
            total: 0,
            skip: 0,
            limit: 10,
          );
        }
      } catch (e) {
        print('Error parsing post response: $e');
        throw ServerFailure('Failed to parse posts: $e');
      }
    } else {
      throw ServerFailure('Failed to load posts: ${response.statusCode}');
    }
  }
}
