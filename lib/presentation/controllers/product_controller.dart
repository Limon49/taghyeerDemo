import 'package:get/get.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/repositories/product_repository.dart';
import '../../../core/exceptions/failures.dart';

class ProductController extends GetxController {
  final ProductRepository _productRepository;
  
  ProductController(this._productRepository);
  
  final RxList<ProductEntity> _products = <ProductEntity>[].obs;
  final RxBool _isLoading = false.obs;
  final RxBool _isLoadingMore = false.obs;
  final RxBool _hasReachedMax = false.obs;
  final RxString _errorMessage = ''.obs;
  
  final int _limit = 10;
  int _skip = 0;
  
  List<ProductEntity> get products => _products;
  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  bool get hasReachedMax => _hasReachedMax.value;
  bool get isEmpty => _products.isEmpty && !_isLoading.value;
  String get errorMessage => _errorMessage.value;
  
  @override
  void onInit() {
    super.onInit();
    _fetchProducts();
  }
  
  Future<void> _fetchProducts({bool isRefresh = false}) async {
    if (isRefresh) {
      _skip = 0;
      _isLoading.value = true;
      _products.clear();
      _hasReachedMax.value = false;
    } else {
      _isLoadingMore.value = true;
    }
    
    try {
      final newProducts = await _productRepository.getProducts(_limit, _skip);
      
      if (isRefresh) {
        _products.assignAll(newProducts);
      } else {
        _products.addAll(newProducts);
      }
      
      if (newProducts.length < _limit) {
        _hasReachedMax.value = true;
      }
      
      _skip += _limit;
    } catch (e) {
      _errorMessage.value = _mapExceptionToMessage(e);
      Get.snackbar('Error', _errorMessage.value, backgroundColor: Get.theme.colorScheme.error);
    } finally {
      _isLoading.value = false;
      _isLoadingMore.value = false;
    }
  }
  
  Future<void> refreshProducts() async {
    await _fetchProducts(isRefresh: true);
  }
  
  Future<void> loadMoreProducts() async {
    if (!_hasReachedMax.value && !_isLoadingMore.value && !_isLoading.value) {
      await _fetchProducts();
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
      return 'Failed to load products';
    }
  }
}
