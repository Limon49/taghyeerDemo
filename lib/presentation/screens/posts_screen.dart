import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/post_controller.dart';
import '../../../domain/entities/post_entity.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    
    return Obx(() {
      print('PostsScreen building - checking controller');
      PostController controller;
      try {
        controller = Get.find<PostController>();
        print('PostController found: isLoading=${controller.isLoading}, posts.length=${controller.posts.length}');
        
        // Manually trigger fetch if no posts and not loading
        if (!controller.isLoading && controller.posts.isEmpty) {
          print('No posts found and not loading, manually triggering fetch');
          controller.refreshPosts();
        }
      } catch (e) {
        print('Error finding PostController: $e');
        return Scaffold(
          appBar: AppBar(title: const Text('Posts')),
          body: Center(child: Text('Controller not found')),
        );
      }
      
      // Add scroll listener for pagination
      scrollController.addListener(() {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
          controller.loadMorePosts();
        }
      });

      return Scaffold(
        appBar: AppBar(
          title: const Text('Posts'),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await controller.refreshPosts();
          },
          child: controller.isLoading && controller.posts.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : controller.isEmpty
                  ? const Center(
                      child: Text('No posts available'),
                    )
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: controller.posts.length + (controller.hasReachedMax ? 0 : 1),
                      itemBuilder: (context, index) {
                        if (index >= controller.posts.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final post = controller.posts[index];
                        return PostCard(post: post);
                      },
                    ),
        ),
      );
    });
  }
}

class PostCard extends StatelessWidget {
  final PostEntity post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Text(
              post.bodyPreview,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.tag, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: post.tags.take(3).map((tag) {
                      return Chip(
                        label: Text(
                          tag,
                          style: const TextStyle(fontSize: 12),
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.favorite_border, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${post.reactions}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
