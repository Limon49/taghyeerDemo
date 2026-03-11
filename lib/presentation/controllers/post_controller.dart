import 'package:get/get.dart';
import '../../../domain/entities/post_entity.dart';
import '../../../domain/repositories/post_repository.dart';
import '../../../core/exceptions/failures.dart';

class PostController extends GetxController {
  final PostRepository _postRepository;
  
  PostController(this._postRepository);
  
  final RxList<PostEntity> _posts = <PostEntity>[].obs;
  final RxBool _isLoading = false.obs;
  final RxBool _isLoadingMore = false.obs;
  final RxBool _hasReachedMax = false.obs;
  final RxString _errorMessage = ''.obs;
  
  final int _limit = 10;
  int _skip = 0;
  
  List<PostEntity> get posts => _posts;
  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  bool get hasReachedMax => _hasReachedMax.value;
  bool get isEmpty => _posts.isEmpty && !_isLoading.value;
  String get errorMessage => _errorMessage.value;
  
  @override
  void onInit() {
    super.onInit();
    print('PostController onInit() called');
    _fetchPosts();
  }
  
  Future<void> _fetchPosts({bool isRefresh = false}) async {
    print('Fetching posts: isRefresh=$isRefresh, skip=$_skip, limit=$_limit');
    
    if (isRefresh) {
      _skip = 0;
      _isLoading.value = true;
      _posts.clear();
      _hasReachedMax.value = false;
    } else {
      _isLoadingMore.value = true;
    }
    
    try {
      final newPosts = await _postRepository.getPosts(_limit, _skip);
      print('Received ${newPosts.length} posts from repository');
      
      if (isRefresh) {
        _posts.assignAll(newPosts);
        print('Assigned ${newPosts.length} posts to refresh list');
      } else {
        _posts.addAll(newPosts);
        print('Added ${newPosts.length} posts to existing list');
      }
      
      if (newPosts.length < _limit) {
        _hasReachedMax.value = true;
        print('Reached max posts: ${newPosts.length} < $_limit');
      }
      
      _skip += _limit;
      print('Total posts now: ${_posts.length}');
    } catch (e) {
      print('Error fetching posts: $e');
      _errorMessage.value = _mapExceptionToMessage(e);
      Get.snackbar('Error', _errorMessage.value, backgroundColor: Get.theme.colorScheme.error);
    } finally {
      _isLoading.value = false;
      _isLoadingMore.value = false;
    }
  }
  
  Future<void> refreshPosts() async {
    await _fetchPosts(isRefresh: true);
  }
  
  Future<void> loadMorePosts() async {
    if (!_hasReachedMax.value && !_isLoadingMore.value && !_isLoading.value) {
      await _fetchPosts();
    }
  }
  
  void clearError() {
    _errorMessage.value = '';
  }
  
  String _mapExceptionToMessage(dynamic exception) {
    if (exception is Failure) {
      return exception.message;
    } else if (exception.toString().contains('SocketException')) {
      return 'No internet connection';
    } else if (exception.toString().contains('TimeoutException')) {
      return 'Request timeout';
    } else {
      return 'Failed to load posts';
    }
  }
}
