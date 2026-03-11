import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/remote/post_remote_data_source.dart';
import '../models/post_model.dart';
import '../../core/exceptions/failures.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;
  
  PostRepositoryImpl({required this.remoteDataSource});
  
  @override
  Future<List<PostEntity>> getPosts(int limit, int skip) async {
    try {
      final response = await remoteDataSource.getPosts(limit, skip);
      return response.items.map((model) => PostEntity(
        id: model.id,
        title: model.title,
        body: model.body,
        userId: model.userId,
        tags: model.tags,
        reactions: model.reactions,
        views: model.views,
      )).toList();
    } catch (e) {
      if (e is Failure) {
        rethrow;
      }
      throw UnknownFailure('Failed to get posts: $e');
    }
  }
}
