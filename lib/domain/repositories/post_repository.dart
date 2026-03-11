import '../entities/post_entity.dart';

abstract class PostRepository {
  Future<List<PostEntity>> getPosts(int limit, int skip);
}
