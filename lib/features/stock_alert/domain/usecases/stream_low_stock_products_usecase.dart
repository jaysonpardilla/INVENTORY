// lib/features/products/domain/usecases/stream_low_stock_products_usecase.dart
import '../../../products/domain/entities/product.dart';
import '../../../products/domain/repositories/product_repository.dart';

class StreamLowStockProductsUsecase {
  final ProductRepository repository;
  StreamLowStockProductsUsecase(this.repository);

  Stream<List<Product>> call(String ownerId) {
    return repository.streamLowStockProducts(ownerId);
  }
}