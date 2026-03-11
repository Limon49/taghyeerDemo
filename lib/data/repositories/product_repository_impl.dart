import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/remote/product_remote_data_source.dart';
import '../models/product_model.dart';
import '../../core/exceptions/failures.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  
  ProductRepositoryImpl({required this.remoteDataSource});
  
  @override
  Future<List<ProductEntity>> getProducts(int limit, int skip) async {
    try {
      final response = await remoteDataSource.getProducts(limit, skip);
      return response.products.map((model) => ProductEntity(
        id: model.id,
        title: model.title,
        description: model.description,
        price: model.price,
        discountPercentage: model.discountPercentage,
        rating: model.rating,
        stock: model.stock,
        brand: model.brand,
        category: model.category,
        thumbnail: model.thumbnail,
        images: model.images,
      )).toList();
    } catch (e) {
      if (e is Failure) {
        rethrow;
      }
      throw UnknownFailure('Failed to get products: $e');
    }
  }
}
