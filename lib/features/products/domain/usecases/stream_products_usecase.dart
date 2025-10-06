// lib/features/products/domain/usecases/stream_products_usecase.dart
import '../../domain/entities/product.dart';
import '../repositories/product_repository.dart';

class StreamProductsUsecase {
  final ProductRepository repository;

  StreamProductsUsecase(this.repository);

  Stream<List<Product>> call(String ownerId) {
    return repository.streamProducts(ownerId);
  }
}